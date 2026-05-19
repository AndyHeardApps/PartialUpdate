# PartialUpdate

[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndyHeardApps%2FPartialUpdate%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AndyHeardApps/PartialUpdate)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndyHeardApps%2FPartialUpdate%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/AndyHeardApps/PartialUpdate)
[![Documentation](https://img.shields.io/badge/documentation-DocC-blue)](https://swiftpackageindex.com/AndyHeardApps/PartialUpdate/documentation/partialupdate)
[![GitHub release](https://img.shields.io/github/v/release/AndyHeardApps/PartialUpdate)](https://github.com/AndyHeardApps/PartialUpdate/releases)
[![SPM compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)

Efficiently compute and apply the differences between two Swift values.

## Overview

When synchronising data — across a network, between app layers, or between two copies of the same model — you often only need to transmit or apply what *changed*. PartialUpdate gives you a type-safe, `Codable`-friendly diff for any Swift value type.

The library is built around the `PartiallyUpdatable` protocol and a `@PartiallyUpdatable` macro that generates everything for your own structs and enums automatically.

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/AndyHeardApps/PartialUpdate.git", from: "0.1.7")
],
targets: [
    .target(
        name: "MyTarget",
        dependencies: ["PartialUpdate"]
    )
]
```

## Quick Start

Annotate your struct with `@PartiallyUpdatable` and the macro generates a `PartialUpdate` type and full protocol conformance:

```swift
import PartialUpdate

@PartiallyUpdatable
struct UserProfile: Hashable {
    var name: String
    var age: Int
    var bio: String?
}

let old = UserProfile(name: "Alice", age: 30, bio: nil)
let new = UserProfile(name: "Alice", age: 31, bio: "Swift developer")

// Compute only what changed
let diff = new.update(from: old)
// diff == UserProfile.PartialUpdate(name: nil, age: 31, bio: .full("Swift developer"))

// Apply the diff to reconstruct the new value
let updated = try old.updated(with: diff)
// updated == new

// No changes → nil diff
let noDiff = old.update(from: old) // nil
```

## Core Concepts

The `PartiallyUpdatable` protocol requires two methods:

```swift
public protocol PartiallyUpdatable: Hashable {
    associatedtype PartialUpdate

    /// Returns the differences between self and oldValue, or nil if they are equal.
    func update(from oldValue: Self) -> PartialUpdate?

    /// Applies a partial update and returns the resulting value.
    func updated(with partialUpdate: PartialUpdate?) throws -> Self
}
```

- `update(from:)` returns `nil` when no changes exist — useful for skipping unnecessary work or network traffic.
- `updated(with:)` is a throwing function; passing `nil` always returns `self` unchanged.

## Usage

### Structs

The `@PartiallyUpdatable` macro generates a `PartialUpdate` struct whose properties mirror the original struct, but each field is optional — only changed fields are non-nil.

```swift
@PartiallyUpdatable
struct Point: Hashable {
    var x: Double
    var y: Double
}

let a = Point(x: 1, y: 2)
let b = Point(x: 1, y: 5)

let diff = b.update(from: a)
// diff == Point.PartialUpdate(x: nil, y: 5)

let result = try a.updated(with: diff)
// result == Point(x: 1, y: 5)
```

### Enums

For enums, `@PartiallyUpdatable` generates a matching `PartialUpdate` enum. Each case mirrors the original with its associated values replaced by their own partial update types, plus a `.caseChange` case for when the case itself switches.

```swift
@PartiallyUpdatable
enum Shape: Hashable {
    case circle(radius: Double)
    case rectangle(width: Double, height: Double)
}

// Same case — partial update
let old = Shape.circle(radius: 5)
let new = Shape.circle(radius: 8)
let diff = new.update(from: old)
// diff == .circle(radius: 8)

// Different case — full replacement
let old2 = Shape.circle(radius: 5)
let new2 = Shape.rectangle(width: 10, height: 4)
let diff2 = new2.update(from: old2)
// diff2 == .caseChange(.rectangle(width: 10, height: 4))
```

Applying a case-A update to a case-B value throws `PartialUpdateError.updatingEnumWithIncorrectCase`.

### Optionals

`Optional` has a three-case `PartialUpdate` enum:

| Case | Meaning |
|------|---------|
| `.full(Wrapped)` | Transition from `nil` to a new value |
| `.updated(Wrapped.PartialUpdate)` | Update an existing (non-nil) value |
| `.nullified` | Set the value to `nil` |

```swift
var value: Int? = nil

// nil → value
let diff1 = Int?.some(42).update(from: nil)
// diff1 == .full(42)

// value → updated value
let diff2 = Int?.some(99).update(from: .some(42))
// diff2 == .updated(99)

// value → nil
let diff3 = Int?.none.update(from: .some(42))
// diff3 == .nullified
```

Attempting to apply `.updated` to a `nil` value throws `PartialUpdateError.updatingNilWithPartialValue`.

### Arrays

`Array.PartialUpdate` is `[Array<Element>.Difference]`, an array of fine-grained change operations:

| Difference | Meaning |
|-----------|---------|
| `.inserted(element:index:)` | Element added at position |
| `.removed(index:)` | Element removed from position |
| `.moved(from:to:)` | Element moved between positions (inferred for `Identifiable` elements) |
| `.updated(update:index:)` | Partial update applied to element at position |

```swift
var items = [1, 2, 3]
let updated = [1, 2, 3, 4]

let diff = updated.update(from: items)
// diff == [.inserted(element: 4, index: 3)]

let result = try items.updated(with: diff)
// result == [1, 2, 3, 4]
```

For arrays of `Identifiable` elements, moves are inferred automatically from Swift's `CollectionDifference.inferringMoves()`.

### Dictionaries

`Dictionary.PartialUpdate` is `[Dictionary<Key, Value>.Difference]`:

| Difference | Meaning |
|-----------|---------|
| `.inserted(value:key:)` | New key-value pair added |
| `.removed(key:)` | Key removed |
| `.updated(update:key:)` | Partial update applied to the value for a key |

```swift
let old = ["a": 1, "b": 2]
let new = ["a": 1, "b": 3, "c": 4]

let diff = new.update(from: old)
// diff contains .updated(update: 3, key: "b") and .inserted(value: 4, key: "c")

let result = try old.updated(with: diff)
// result == ["a": 1, "b": 3, "c": 4]
```

### Sets

`Set.PartialUpdate` is `[Set<Element>.Difference]`:

| Difference | Meaning |
|-----------|---------|
| `.inserted(element:)` | Element added to the set |
| `.removed(element:)` | Element removed from the set |
| `.updated(update:id:)` | Partial update applied to a matching element |

```swift
let old: Set = [1, 2, 3]
let new: Set = [1, 2, 4]

let diff = new.update(from: old)
// diff contains .removed(element: 3) and .inserted(element: 4)

let result = try old.updated(with: diff)
// result == Set([1, 2, 4])
```

### Property Exclusion

Two macros let you opt individual properties out of partial update tracking:

**`@PartiallyUpdatableIgnored`** — the property is excluded from the generated `PartialUpdate` type but still participates in `updated(with:)` using its current value:

```swift
@PartiallyUpdatable
struct Document: Hashable {
    var title: String
    @PartiallyUpdatableIgnored var lastModified: Date  // never in a diff
}
```

**`@PartiallyUpdatableOmitted`** — the property is excluded entirely from both the `PartialUpdate` type and the `updated(with:)` initialiser call:

```swift
@PartiallyUpdatable
struct CachedItem: Hashable {
    var value: String
    @PartiallyUpdatableOmitted var cache: [String: Any]  // fully ignored
}
```

### Codable Support

All built-in conformances automatically conform to `Codable` when their element types do. This means you can encode a `PartialUpdate` to JSON and transmit it over the network, then decode and apply it on the other side:

```swift
@PartiallyUpdatable
struct Config: Hashable, Codable {
    var timeout: Int
    var retries: Int
}

let old = Config(timeout: 30, retries: 3)
let new = Config(timeout: 60, retries: 3)

let diff = new.update(from: old)!

let data = try JSONEncoder().encode(diff)
// {"timeout":60}

let decoded = try JSONDecoder().decode(Config.PartialUpdate.self, from: data)
let result = try old.updated(with: decoded)
// result == Config(timeout: 60, retries: 3)
```

## Built-in Conformances

The following types conform to `PartiallyUpdatable` out of the box:

| Category | Types |
|----------|-------|
| Integer | `Int`, `Int8`, `Int16`, `Int32`, `Int64`, `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64` |
| Floating point | `Double`, `Float` |
| Foundation | `String`, `Bool`, `Date`, `UUID` |
| Collections | `Optional`, `Array`, `Dictionary`, `Set` |

For basic (non-collection) types, the type itself is its own `PartialUpdate` — the full new value is the diff.

## Error Reference

| Error | When thrown |
|-------|-------------|
| `PartialUpdateError.updatingNilWithPartialValue` | `updated(with: .updated(...))` called on a `nil` optional |
| `PartialUpdateError.updatingEnumWithIncorrectCase` | A case-specific partial update is applied to a different enum case |

## Requirements

- Swift 6.0+
- macOS 13.0+ / iOS 13.0+

## License

PartialUpdate is available under the Apache 2.0 license. See the [LICENSE](LICENSE) file for details.

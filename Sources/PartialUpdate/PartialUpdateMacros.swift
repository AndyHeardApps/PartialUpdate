
/// Generates a default implementation of the ``PartiallyUpdatable`` protocol for a `struct` or `enum` type.
///
/// This macro will synthesize an implemenation for ``PartiallyUpdatable/PartialUpdate``, ``PartiallyUpdatable/update(from:)`` and ``PartiallyUpdatable/updated(with:)``. This implementation assumes that a memberwise initializer is available  for the type the macro is attached to.
///
/// The macro will make the synthesized ``PartiallyUpdatable/PartialUpdate`` type shadow the `Codable`, `Encodable` and `Decodable` inheritances of the parent type.
@attached(extension, conformances: PartiallyUpdatable, Codable, Encodable, Decodable, names: named(PartialUpdate), named(update(from: )), named(updated(with: )))
public macro PartiallyUpdatable() = #externalMacro(module: "PartialUpdateMacros", type: "PartiallyUpdatableMacro")

/// Instructs the `@PartiallyUpdatable` macro to ignore updates to the property that this macro is attached to.
///
/// This can only be applied to properties on a `struct`, and that property will not have a synthesized property in the `PartialUpdate` type. Additionally, the ``PartiallyUpdatable/updated(with:)`` function will instead just inject the current value of this property in the initializer without attempting to update it.
@attached(accessor, names: named(didSet))
public macro PartiallyUpdatableIgnored() = #externalMacro(module: "PartialUpdateMacros", type: "PartiallyUpdatableIgnoredMacro")

/// Instructs the `@PartiallyUpdatable` macro to completely ignore the property that this macro is attached to.
///
/// This can only be applied to properties on a `struct`, and that property will not have a synthesized property in the `PartialUpdate` type. Additionally, the ``PartiallyUpdatable/updated(with:)`` function will not include this property in the used initializer.
@attached(accessor, names: named(didSet))
public macro PartiallyUpdatableOmitted() = #externalMacro(module: "PartialUpdateMacros", type: "PartiallyUpdatableOmittedMacro")

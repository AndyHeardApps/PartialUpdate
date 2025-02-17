
@attached(extension, conformances: PartiallyUpdatable, Codable, Encodable, Decodable, names: named(PartialUpdate), named(update(from: )), named(updated(with: )))
public macro PartiallyUpdatable() = #externalMacro(module: "PartialUpdateMacros", type: "PartiallyUpdatableMacro")

@attached(accessor, names: named(didSet))
public macro PartiallyUpdatableIgnored() = #externalMacro(module: "PartialUpdateMacros", type: "PartiallyUpdatableIgnoredMacro")

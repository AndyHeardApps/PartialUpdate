import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite(
    "Manual childOpaqueCode function declaration",
    .enabled(if: MacroTesting.shared.isEnabled)
)
struct PartiallyUpdatableTests {

    @Test
    func test() {
        assertMacroExpansion(
            """
            @PartiallyUpdatable
            struct Test {
                let int: Int
            }
            """,
            expandedSource: """
            """,
            macros: MacroTesting.shared.testMacros
        )
    }
}

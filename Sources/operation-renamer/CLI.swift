import Foundation
import RegexBuilder
import CodeGenSupport

#if !os(macOS)
#error("This project is for macOS only! Select 'My Mac' from run destinations to continue!")
#endif

@main
struct CLI {
    static func main() async throws {
        let swaggerFilePath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "bitrise_swagger.json")

        print(swaggerFilePath)
        var content = try String(contentsOf: swaggerFilePath, encoding: .utf8)

        let regex = try Regex("""
        "operationId": "(.+)"
        """)

        content.replace(regex) { match in
            guard let originalName = match.output[1].substring
            else {
                preconditionFailure("The match has to include a captured operation id")
            }
            let newName = String(originalName).camelCased()
            return """
            "operationId": "\(newName)"
            """
        }

        try content.write(to: swaggerFilePath, atomically: true, encoding: .utf8)
    }
}

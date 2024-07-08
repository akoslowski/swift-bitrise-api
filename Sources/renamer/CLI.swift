import Foundation
import RegexBuilder

#if !os(macOS)
#error("This project is for macOS only! Select 'My Mac' from run destinations to continue!")
#endif

@main
/// The original swagger schema uses "-" in operation- and parameter-names. That leads to some funky naming where swift-openapi-generator turns "app-list" into "app_hyphen_list". It also breaks replacing placeholders in paths, e.g. "/apps/{app-slug}/build". The parameter name has to match the placeholder name.
struct CLI {
    static func main() async throws {
        let swaggerFilePath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "bitrise_swagger.json")

        var content = try String(contentsOf: swaggerFilePath, encoding: .utf8)

        replaceHyphenWithUnderscoreInMatch(
            string: &content,
            regex: try Regex("""
            "operationId": "(.+)"
            """)
        )

        replaceHyphenWithUnderscoreInMatch(
            string: &content,
            regex: try Regex("""
            "name": "([a-z-]+)",
            """)
        )

        replaceHyphenWithUnderscoreInMatch(
            string: &content,
            regex: try Regex("""
            {([a-z-]+)}
            """)
        )

        try content.write(to: swaggerFilePath, atomically: true, encoding: .utf8)
    }
}

func replaceHyphenWithUnderscoreInMatch(string: inout String, regex: Regex<AnyRegexOutput>) {
    string.replace(regex) { match in
        guard
            var matchedString = match[0].substring,
            let capturedString = match.output[1].substring,
            let capturedRange = match.output[1].range
        else {
            preconditionFailure("Missing match")
        }
        let newString = String(capturedString).replacingOccurrences(of: "-", with: "_")
        matchedString.replaceSubrange(capturedRange, with: newString)
        return matchedString
    }
}

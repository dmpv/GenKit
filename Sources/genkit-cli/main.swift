//
//  main.swift
//  
//
//  Created by Dmitry Purtov on 06.07.2021.
//

import Foundation

import ArgumentParser
import ShellOut

Tasks.main()

struct Tasks: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "tasks",
        abstract: "",
        subcommands: [Tst.self]
    )
}

extension Tasks {
    struct Tst: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "sourcery",
            abstract: ""
        )

        func run() throws {
            let packageURL = URL(fileURLWithPath: "\(#file)", isDirectory: false)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()

            let templatesPath = packageURL
                .appendingPathComponent("templates")
                .path

            let genkitPath = packageURL
                .appendingPathComponent("Sources/GenKit/")
                .path

            let parentPath = try runShell("pwd")

            let targetName: String = {
                let parentURL = URL(string: parentPath)!
                return parentURL.lastPathComponent
            }()

            let sources: [String] = [
                "\(parentPath)/Sources/",
                "\(genkitPath)"
            ]
//            try runShell("echo \(sources)")

            let templates = "\(templatesPath)/"
//            try runShell("echo \(templates)")

            let output = "\(parentPath)/Sources/\(targetName)/Generated"
//            try runShell("echo \(output)")

            try runShell("""
                sourcery \
                    \(
                        sources.map {
                            "--sources \($0) "
                        }.joined(separator: " ")
                    ) \
                    --templates \(templates)/ \
                    --output \(output) \
                    --watch
            """)
        }
    }
}

@discardableResult
func runShell(_ command: String, continueOnError: Bool = false) throws -> String {
    do {
        return try shellOut(
            to: command,
            outputHandle: .standardOutput,
            errorHandle: .standardError
        )
    } catch {
        if continueOnError {
            return ""
        } else {
            throw ShellError()
        }
    }
}

struct ShellError: Error, CustomStringConvertible {
    var description: String {
        "Failed when running shell command"
    }
}

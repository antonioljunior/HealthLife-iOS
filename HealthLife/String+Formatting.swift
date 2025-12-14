//
//  String+Formatting.swift
//  HealthLife
//
//  Created by Antonio Almeida on 02/12/25.
//

import Foundation

extension String {

    /// Splits a camelCase or PascalCase identifier by inserting spaces before uppercase letters.
    /// Examples:
    /// - "upperChest" -> "upper Chest"
    /// - "RearDelts" -> "Rear Delts"
    /// - "fullBody" -> "full Body"
    func splitBeforeUppercase() -> String {
        // Insert space before each uppercase letter that follows a lowercase or another uppercase followed by lowercase.
        // This handles transitions like "rD" in "rearDelts" and "RD" in "RDTest" -> "RD Test".
        let pattern = #"(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])"#
        let withSpaces = self.replacingOccurrences(of: pattern, with: " ", options: .regularExpression)
        // Collapse any accidental multiple spaces
        return withSpaces.replacingOccurrences(of: #" {2,}"#, with: " ", options: .regularExpression)
    }

    /// Capitalizes each word while preserving common gym acronyms.
    /// Examples:
    /// - "upper chest" -> "Upper Chest"
    /// - "rear delts" -> "Rear Delts"
    /// - "abs" -> "Abs"
    /// - "lats" -> "Lats"
    func capitalizedWords() -> String {
        // Words to keep as specific casing
        let preserved: [String: String] = [
            "abs": "Abs",
            "lats": "Lats",
            "delts": "Delts",
            "rd": "RD" // example acronym preservation
        ]

        let parts = self.split(separator: " ")
        let mapped = parts.map { part -> String in
            let lower = part.lowercased()
            if let keep = preserved[lower] {
                return keep
            }
            return part.capitalized
        }
        return mapped.joined(separator: " ")
    }
}

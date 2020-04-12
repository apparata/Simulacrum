//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Convenience class for easier use of NSRegularExpression
///
/// Example:
/// ```
/// Regex("he[l]+").isMatch("hello")
/// let regex: Regex = "he[l]+o"
/// regex.isMatch("hello")
/// "hello".matches(regex: regex)
/// "hello".matches(regex: "he[l]+o")
///
/// let regex2: Regex = "([0123456789]+)\\.([0123456789]+)"
/// regex2.numberOfMatches("313.145192653 1.78")
/// let matches = regex2.match("3.145192653 1.78 2.41")
/// "3.145192653 1.78 2.41".match(regex: "([0123456789]+)\\.([0123456789]+)")
///
/// switch "This is a test" {
/// case Regex("This is a .*"):
///     print("It is indeed.")
///     break
///     ...
/// }
///
/// let regex3 = Regex("(\\w+)=(\\d+)")
/// let a = regex3.replaceMatches(in: "123 456 789", template: "($0)")
/// let b = regex3.replaceMatches(in: "a=123 b=456 c=789", template: "($1: $2)")
/// ```
public struct Regex {
    
    fileprivate var matcher: NSRegularExpression?
    
    fileprivate let pattern: String
    
    fileprivate var options: NSRegularExpression.Options = []
    
    /// Indicates whether pattern is valid or not.
    public var isValid: Bool {
        return matcher != nil
    }
    
    /// Initializes regular expression object with a pattern.
    ///
    /// - parameter pattern: Pattern to use for matching.
    /// - parameter options: General regular expression options.
    public init(_ pattern: String, options: NSRegularExpression.Options = []) {
        self.options = options
        self.pattern = pattern
        createMatcher()
    }
    
    fileprivate mutating func createMatcher() {
        do {
            let regex = try NSRegularExpression(pattern: self.pattern, options: self.options)
            matcher = regex
        } catch let error as NSError {
            print("[Regex] ERROR: Failed to create regular expression: \(error.localizedDescription)")
            matcher = nil
        }
    }
    
    /// Checks if string matches pattern.
    ///
    /// Examples:
    /// ```
    /// Regex("he[l]+").isMatch("hello")
    ///
    /// let regex: Regex = "he[l]+o"
    /// regex.isMatch("hello")
    /// ```
    ///
    /// - parameter string: String to match.
    /// - parameter options: Regular expression matching options.
    ///
    /// - returns: Returns `true` if string matches pattern, else `false`.
    public func isMatch(_ string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        return numberOfMatches(string, options: options) != 0
    }
    
    /// Returns the number of matches for this pattern in the string.
    ///
    /// - parameter string: String to match.
    /// - parameter inRange: Restrict matching to this part of the string.
    ///                      Defaults to entire string.
    /// - parameter options: Regular expression matching options.
    ///
    /// - returns: The number of matches for this pattern in the string.
    public func numberOfMatches(_ string: String, inRange: CountableRange<Int>? = nil, options: NSRegularExpression.MatchingOptions = []) -> Int {
        if let matcher = matcher {
            let inputRange = rangeToNSRange(in: string, range: inRange)
            return matcher.numberOfMatches(in: string, options: options, range: inputRange)
        } else {
            return 0
        }
    }
    
    /// Matches pattern with a string and return the matches.
    ///
    /// - parameter string: String to match.
    /// - parameter inRange: Restrict matching to this part of the string.
    ///                      Defaults to entire string.
    /// - parameter options: Regular expression matching options.
    ///
    /// - returns: The matches.
    public func match(_ string: String, inRange: CountableRange<Int>? = nil, options: NSRegularExpression.MatchingOptions = []) -> [[String]] {
        let inputRange = rangeToNSRange(in: string, range: inRange)
        var matches: [[String]] = []
        matcher?.enumerateMatches(in: string, options: options, range: inputRange) { (match, flags, stop) -> Void in
            if let match = match {
                let group = self.group(from: string, match: match)
                matches.append(group)
            }
        }
        return matches
    }
    
    /// Returns the first match from the string.
    ///
    /// - parameter string: String to match.
    /// - parameter inRange: Restrict matching to this part of the string.
    ///                      Defaults to entire string.
    /// - parameter options: Regular expression matching options.
    ///
    /// - returns: Returns the first match from the string.
    public func firstMatch(in string: String, inRange: CountableRange<Int>? = nil, options: NSRegularExpression.MatchingOptions = []) -> ([String], CountableRange<Int>)? {
        let inputRange = rangeToNSRange(in: string, range: inRange)
        
        let match = matcher?.firstMatch(in: string, options: options, range: inputRange)
        
        if let match = match {
            let group = self.group(from: string, match: match)
            
            let min = match.range.location
            let max = match.range.location + match.range.length
            
            return (group, min..<max)
        }
        return nil
    }
    
    /// Returns the range of the first match from the string.
    ///
    /// - parameter string: String to match.
    /// - parameter inRange: Restrict matching to this part of the string.
    ///                      Defaults to entire string.
    /// - parameter options: Regular expression matching options.
    ///
    /// - returns: Returns the range of the first match from the string.
    public func rangeOfFirstMatch(in string: String, inRange: CountableRange<Int>? = nil, options: NSRegularExpression.MatchingOptions = []) -> Range<Int>? {
        let inputRange = rangeToNSRange(in: string, range: inRange)
        guard let range = matcher?.rangeOfFirstMatch(in: string, options: options, range: inputRange) else {
            return nil
        }
        guard range.location != NSNotFound else {
            return nil
        }
        let min = range.location
        let max = range.location + range.length
        return min..<max
    }
    
    /// Returns a new string where the matches in the string have been replaced
    /// with a substring generated from a template.
    ///
    /// - parameter string: String to match.
    /// - parameter template: Template to use when replacing substrings.
    /// - parameter inRange: Restrict matching to this part of the string.
    /// - parameter options: Regular expression matching options.
    ///
    /// - returns: Returns a new string where the matches in the string have
    ///            been replaced with a substring generated from a template.
    public func replaceMatches(in string: String, template: String, inRange: CountableRange<Int>? = nil, options: NSRegularExpression.MatchingOptions = []) -> String {
        guard let matcher = matcher else {
            return string
        }
        let inputRange = rangeToNSRange(in: string, range: inRange)
        return matcher.stringByReplacingMatches(in: string, options: options, range: inputRange, withTemplate: template)
    }
    
    /// Enumerates the pattern matches in the string.
    ///
    /// - parameter string: String to match.
    /// - parameter inRange: Restrict matching to this part of the string.
    /// - parameter options: Regular expression matching options.
    /// - parameter action: Closure to call for each match in the string.
    public func enumerateMatches(in string: String, inRange: CountableRange<Int>? = nil, options: NSRegularExpression.MatchingOptions = [], action: (_ match: [String]) -> Void) {
        let inputRange = rangeToNSRange(in: string, range: inRange)
        matcher?.enumerateMatches(in: string, options: options, range: inputRange, using: { (result, _, _) -> Void in
            if let result = result {
                let group = self.group(from: string, match: result)
                action(group)
            }
        })
    }
    
    private func group(from string: String, match: NSTextCheckingResult) -> [String] {
        var group: [String] = []
        for i in 0..<match.numberOfRanges {
            let range = match.range(at: i)
            if range.location == NSNotFound {
                group.append("")
            } else {
                // swiftlint:disable force_unwrapping
                let fromUtf16 = string.utf16.index(string.utf16.startIndex, offsetBy: range.location, limitedBy: string.utf16.endIndex)!
                let toUtf16 = string.utf16.index(fromUtf16, offsetBy: range.length, limitedBy: string.utf16.endIndex)!
                // swiftlint:enable force_unwrapping
                if let from = String.Index(fromUtf16, within: string),
                    let to = String.Index(toUtf16, within: string) {
                        group.append(String(string[from..<to]))
                }
            }
        }
        return group
    }
    
    private func rangeToNSRange(in string: String, range: CountableRange<Int>?) -> NSRange {
        if let range = range {
            return NSRange(location: range.startIndex, length: range.endIndex - range.startIndex)
        } else {
            return NSRange(location: 0, length: string.count)
        }
    }
}

// MARK: - String Literal Convertible

// This is what allows the Regex to be created from a literal pattern string.
extension Regex: ExpressibleByStringLiteral {
    public typealias UnicodeScalarLiteralType = StringLiteralType
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        pattern = "\(value)"
        createMatcher()
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        pattern = value
        createMatcher()
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.pattern = value
        createMatcher()
    }
}

// MARK: - Object Description

extension Regex: CustomStringConvertible {
    public var description: String {
        return pattern
    }
}

// MARK: - Extension on String

extension String {
    
    /// Checks if string matches a regular expression.
    ///
    /// - parameter regex: Regular expression to match with string.
    ///
    /// - returns: Returns `true` if string matches regular expression,
    ///            else `false`
    public func matches(regex: Regex) -> Bool {
        return regex.isMatch(self)
    }
        
    /// Returns regular expression matches.
    ///
    /// - parameter regex: Regular expression to match with string.
    ///
    /// - returns: Returns regular expression matches.
    public func match(regex: Regex) -> [[String]] {
        return regex.match(self)
    }
}

// MARK: - Pattern matching

public func ~= (regex: Regex, input: String) -> Bool {
    return regex.isMatch(input)
}

//
//  StringEncoding.swift
//  StringEncoding
//
//  Created by Charlie Welsh on 9/5/21.
//

import Foundation

extension Data {
	struct HexEncodingOptions: OptionSet {
		let rawValue: Int
		static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
	}

	func hexEncodedString(options: HexEncodingOptions = []) -> String {
		let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
		return self.map { String(format: format, $0) }.joined()
	}

	func octalEncodedString(options: HexEncodingOptions = []) -> String {
		let format = options.contains(.upperCase) ? "%1hX" : "%1hx"
		return self.map { String(format: format, $0) }.joined()
	}
}

// https://stackoverflow.com/questions/53832164/replacing-string-value-at-index-swift
extension String {
	/// Returns a string where an index has been updated with a given string
	func replaced(_ with: String, at index: Int) -> String {
		var modifiedString = String()
		for (i, char) in self.enumerated() {
			modifiedString += String((i == index) ? with : String(char))
		}
		return modifiedString
	}

	/// Replaces an index with a given string in place
	mutating func replace(_ with: String, at index: Int) {
		var modifiedString = String()
		for (i, char) in self.enumerated() {
			modifiedString += String((i == index) ? with : String(char))
		}
		self = modifiedString
	}
}

// Adapted from https://stackoverflow.com/questions/44807378/swift-convert-uint8-byte-to-array-of-bits/51770616
extension UInt8 {
	/// Returns an array of `Bool`s for a given UInt8
	var bits: [Bool] {
		var byte = self
		var bits = [Bool](repeating: false, count: 8)

		for i in 0 ..< 8 {
			let currentBit = byte & 0x01
			if currentBit != 0 {
				bits[i] = true
			}

			byte >>= 1
		}

		return bits
	}
}

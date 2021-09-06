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

//
//  PermissionsEncodings.swift
//  PermissionsEncodings
//
//  Created by Charlie Welsh on 9/5/21.
//

import Foundation

struct Permissions {
	var matrix: [BitArray]

	var octal: String {
		return matrix.map {$0.octalEncodedString}.joined()
	}

	var symbolic: String {
		return matrix.map { array in
			var result = ""
			for index in array.indices.reversed() {
				if array[index] {
					result.append("1")
				} else {
					result.append("0")
				}
			}

			for index in 0 ..< result.count {
				if result[String.Index(utf16Offset: index, in: result)] == "1" {
					let index = index + 1
					if index % 3 == 0 {
						result.replace("x", at: index - 1)
					} else if index % 2 == 0 {
						result.replace("w", at: index - 1)
					} else {
						result.replace("r", at: index - 1)
					}
				} else {
					result.replace("-", at: index)
				}
			}

			return result
		}.joined()
	}
}

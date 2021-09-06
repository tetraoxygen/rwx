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
}

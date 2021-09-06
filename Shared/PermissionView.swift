//
//  PermissionView.swift
//  PermissionView
//
//  Created by Charlie Welsh on 9/5/21.
//

import SwiftUI

struct PermissionView: View {
	@Binding var permissionArray: BitArray
	var name: String

    var body: some View {
		VStack (alignment: .leading) {
			Text(name.uppercased())
				.font(.caption)
				.foregroundColor(.secondary)
				.fontWeight(.medium)

			// HACK: this should be iterating over the array, but not sure how to handle labels cleanly in that case
			Toggle(isOn: $permissionArray[2]) {
				Text("Read")
			}
			Toggle(isOn: $permissionArray[1]) {
				Text("Write")
			}
			Toggle(isOn: $permissionArray[0]) {
				Text("Execute")
			}
		}
		.frame(minWidth: 80, minHeight: 100)
		.padding()
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
		PermissionView(permissionArray: .constant(BitArray([true, false, true])), name: "Test")
    }
}

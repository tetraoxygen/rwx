//
//  ContentView.swift
//  Shared
//
//  Created by Charlie Welsh on 9/5/21.
//

import SwiftUI

struct ContentView: View {
	@State var permissions = Permissions(matrix: [
			BitArray([false, false, false]),
			BitArray([false, false, false]),
			BitArray([false, false, false])
		]
	)


    var body: some View {
		VStack {
			VStack (alignment: .leading) {
				Text("Octal".uppercased())
					.font(.caption.bold())
					.foregroundColor(.secondary)
				Text("\(permissions.octal)")
					.font(.largeTitle)
			}
			.frame(minHeight: 60)

			HStack {
				PermissionView(permissionArray: $permissions.matrix[0], name: "User")

				PermissionView(permissionArray: $permissions.matrix[1], name: "Group")

				PermissionView(permissionArray: $permissions.matrix[2], name: "World")
			}
		}
		.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

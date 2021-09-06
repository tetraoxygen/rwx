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
				HStack {
					VStack (alignment: .leading) {
						Text("Octal".uppercased())
							.font(.caption.bold())
							.foregroundColor(.secondary)
						if #available(macOS 12, *, iOS 15, *) {
							Text("\(permissions.octal)")
								.textSelection(.enabled)

						} else {
							Text("\(permissions.octal)")
								.contextMenu(ContextMenu(menuItems: {
									Button("Copy", action: {
										copyToClipboard(textToCopy: permissions.octal)
									})
								}))
						}
					}

					VStack (alignment: .leading) {
						Text("Symbolic".uppercased())
							.font(.caption.bold())
							.foregroundColor(.secondary)
						if #available(macOS 12, *, iOS 15, *) {
							Text("\(permissions.octal)")
								.textSelection(.enabled)

						} else {
							Text("\(permissions.symbolic)")
								.contextMenu(ContextMenu(menuItems: {
									Button("Copy", action: {
										copyToClipboard(textToCopy: permissions.symbolic)
									})
								}))
						}
					}
				}
				.font(.system(.largeTitle, design: .monospaced))
				.frame(minHeight: 60)

				VStack (alignment: .leading) {
					Text("Command".uppercased())
						.font(.caption.bold())
						.foregroundColor(.secondary)
					if #available(macOS 12, *, iOS 15, *) {
						Text("chmod \(permissions.octal) name_of_file")
							.font(.system(.body, design: .monospaced))
							.textSelection(.enabled)
					} else {
						Text("chmod \(permissions.octal) name_of_file")
							.font(.system(.body, design: .monospaced))
							.contextMenu(ContextMenu(menuItems: {
								Button("Copy", action: {
									copyToClipboard(textToCopy: "chmod \(permissions.octal) name_of_file")
								})
							}))
					}
				}
				.frame(minHeight: 30)
			}
			HStack {
				PermissionView(permissionArray: $permissions.matrix[0], name: "User")

				PermissionView(permissionArray: $permissions.matrix[1], name: "Group")

				PermissionView(permissionArray: $permissions.matrix[2], name: "World")
			}
		}
		.padding()
    }

	private func copyToClipboard(textToCopy: String) {
	#if os(iOS)
		UIPasteboard.general.string = textToCopy
	#elseif os(macOS)
		let pasteboard = NSPasteboard.general
		pasteboard.clearContents()
		pasteboard.setString(textToCopy, forType: .string)
	#endif
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  CommandView.swift
//  CommandView
//
//  Created by Charlie Welsh on 9/10/21.
//

import SwiftUI

struct CommandView: View {
	@Binding var permissions: Permissions

    var body: some View {
		VStack (alignment: .leading) {
			Text("Command")
				.font(.caption.bold())
				.foregroundColor(.secondary)
				.textCase(.uppercase)
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
}

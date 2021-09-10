//
//  OctalView.swift
//  OctalView
//
//  Created by Charlie Welsh on 9/10/21.
//

import SwiftUI

struct OctalView: View {
	@Binding var permissions: Permissions

    var body: some View {
		VStack (alignment: .leading) {
			Text("Octal")
				.font(.caption.bold())
				.foregroundColor(.secondary)
				.textCase(.uppercase)
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
    }
}

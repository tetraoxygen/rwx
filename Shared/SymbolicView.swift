//
//  SymbolicView.swift
//  SymbolicView
//
//  Created by Charlie Welsh on 9/10/21.
//

import SwiftUI

struct SymbolicView: View {
	@Binding var permissions: Permissions

    var body: some View {
		VStack (alignment: .leading) {
			Text("Symbolic")
				.font(.caption.bold())
				.foregroundColor(.secondary)
				.textCase(.uppercase)
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
}

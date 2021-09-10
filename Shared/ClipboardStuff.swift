//
//  ClipboardStuff.swift
//  ClipboardStuff
//
//  Created by Charlie Welsh on 9/10/21.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

func copyToClipboard(textToCopy: String) {
#if os(iOS)
	UIPasteboard.general.string = textToCopy
#elseif os(macOS)
	let pasteboard = NSPasteboard.general
	pasteboard.clearContents()
	pasteboard.setString(textToCopy, forType: .string)
#endif
}

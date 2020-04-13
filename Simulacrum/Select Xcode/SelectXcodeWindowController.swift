//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

class SelectXcodeWindowController: NSWindowController, NSToolbarDelegate {

    private var toolbar: NSToolbar!
    
    private let windowState = SelectXcodeWindowState()
        
    convenience init() {
        
        let window = Self.makeWindow()
        
        window.backgroundColor = NSColor.controlBackgroundColor

        self.init(window: window)
        
        windowState.window = window
        
        let contentView = makeContentView()
            .environmentObject(windowState)
        
        window.center()
        window.title = "Simulacrum"
        window.contentView = NSHostingView(rootView: contentView)
        window.setFrameAutosaveName("SelectXcodeWindow")
        window.titlebarAppearsTransparent = false
    }
        
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 480, height: 360)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .miniaturizable,
            .resizable
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }
    
    private func makeContentView() -> some View {
        SelectXcodeView()
            .frame(minWidth: 300, minHeight: 200)
            .frame(maxWidth: 300, maxHeight: 200)
    }
    
}

extension WindowManager {
    
    @discardableResult
    static func makeSelectXcodeWindowController() -> SelectXcodeWindowController {
        addWindowController(SelectXcodeWindowController())
    }
}

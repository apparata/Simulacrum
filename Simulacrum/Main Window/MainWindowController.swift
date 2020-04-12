//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

class MainWindowController: NSWindowController, NSToolbarDelegate {

    private var toolbar: NSToolbar!
    
    private var windowState: MainWindowState!
    
    private let simulators = Simulators()
    
    convenience init() {
        
        let window = Self.makeWindow()
        
        window.backgroundColor = NSColor.controlBackgroundColor
        
        self.init(window: window)

        let contentView = makeMainView()
            .environmentObject(simulators)
                
        window.titleVisibility = .hidden
        window.center()
        window.title = "Whatever"
        window.contentView = NSHostingView(rootView: contentView)
        window.setFrameAutosaveName("MainAppWindow")
        window.titlebarAppearsTransparent = true

        toolbar = makeToolbar()
        window.toolbar = toolbar

        simulators.refresh()
    }
        
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 480, height: 360)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .miniaturizable,
            .resizable,
            .fullSizeContentView
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }
    
    private func makeMainView() -> some View {
        MainView()
            .frame(minWidth: 480, minHeight: 360)
            .edgesIgnoringSafeArea(.all)
    }

    private func makeToolbar() -> NSToolbar {
        toolbar = NSToolbar(identifier: "Whatever.MainAppWindowToolbar")
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .iconOnly
        toolbar.showsBaselineSeparator = false
        toolbar.delegate = self
        return toolbar
    }
            
    @objc
    public func refreshAction(_ sender: Any?) {
        print("Refresh!")
        simulators.refresh()
    }
    
    // MARK: - NSToolbarDelegate
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem
        
        switch itemIdentifier {
        case .refreshItem:
            toolbarItem = NSToolbarItem(id: .refreshItem,
                                        target: self,
                                        selector: #selector(refreshAction(_:)),
                                        label: "Refresh",
                                        image: NSImage(requiredNamed: NSImage.refreshTemplateName),
                                        toolTip: "Refresh")
        case NSToolbarItem.Identifier.flexibleSpace:
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        default:
            fatalError()
        }
        
        return toolbarItem
    }
    
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .refreshItem
        ]
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .refreshItem
        ]
    }
}

private extension NSToolbarItem.Identifier {
    static let refreshItem = NSToolbarItem.Identifier("refresh")
}

//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

class ScreenshotsWindowController: NSWindowController, NSToolbarDelegate {

    private var toolbar: NSToolbar!
    
    private var windowState: ScreenshotsWindowState!
    
    private let screenshotsFolder = ScreenshotsFolder()
    
    private var screenshotsManager: ScreenshotsManager!
    
    private let sketchExporter = SketchExporter()
    
    convenience init(simulators: Simulators) {
        
        let window = Self.makeWindow()
        
        window.backgroundColor = NSColor.controlBackgroundColor

        self.init(window: window)

        screenshotsManager = ScreenshotsManager(simulators: simulators,
                                                folder: screenshotsFolder)
        
        let contentView = makeContentView()
            .environmentObject(simulators)
            .environmentObject(screenshotsFolder)
            .environmentObject(screenshotsManager)
        
        do {
            try screenshotsFolder.create()
        } catch {
            dump(error)
        }
                
        window.titleVisibility = .hidden
        window.center()
        window.title = "Screenshots"
        window.contentView = NSHostingView(rootView: contentView)
        window.setFrameAutosaveName("ScreenshotsWindow")
        window.titlebarAppearsTransparent = false

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
            .resizable
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }
    
    private func makeContentView() -> some View {
        ScreenshotsView()
            .frame(minWidth: 480, minHeight: 360)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func makeToolbar() -> NSToolbar {
        toolbar = NSToolbar(identifier: "Whatever.ScreenshotsWindowToolbar")
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .iconOnly
        toolbar.showsBaselineSeparator = false
        toolbar.delegate = self
        return toolbar
    }
            
    @objc
    public func refreshAction(_ sender: Any?) {
        screenshotsManager.screenshots.refresh()
    }

    @objc
    public func exportAction(_ sender: Any?) {
        sketchExporter.exportScreenshots(screenshotsManager.screenshots)
    }

    @objc
    public func removeAllAction(_ sender: Any?) {
        screenshotsManager.removeAll()
    }
    
    @objc
    public func showInFinderAction(_ sender: Any?) {
        screenshotsFolder.openInFinder()
    }
    
    // MARK: - NSToolbarDelegate
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem
        
        switch itemIdentifier {
        case .removeAllItem:
            toolbarItem = NSToolbarItem(id: .removeAllItem,
                                        target: self,
                                        selector: #selector(removeAllAction(_:)),
                                        label: "Remove All",
                                        image: NSImage(requiredNamed: "icon/delete"),
                                        toolTip: "Remove All")
        case .showInFinderItem:
                toolbarItem = NSToolbarItem(id: .showInFinderItem,
                                            target: self,
                                            selector: #selector(showInFinderAction(_:)),
                                            label: "Show in Finder",
                                            image: NSImage(requiredNamed: "icon/folder"),
                                            toolTip: "Show in Finder")
        case .titleItem:
            toolbarItem = NSToolbarItem(id: .titleItem, windowTitle: "Screenshots")
        case .exportItem:
            toolbarItem = NSToolbarItem(id: .refreshItem,
                                        target: self,
                                        selector: #selector(exportAction(_:)),
                                        label: "Export",
                                        image: NSImage(requiredNamed: NSImage.shareTemplateName),
                                        toolTip: "Export")
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
            .removeAllItem,
            .showInFinderItem,
            .titleItem,
            .exportItem,
            .refreshItem
        ]
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .removeAllItem,
            .showInFinderItem,
            .flexibleSpace,
            .titleItem,
            .flexibleSpace,
            .exportItem,
            .refreshItem
        ]
    }
}

private extension NSToolbarItem.Identifier {
    static let removeAllItem = NSToolbarItem.Identifier("removeAll")
    static let showInFinderItem = NSToolbarItem.Identifier("showInFinder")
    static let titleItem = NSToolbarItem.Identifier("title")
    static let exportItem = NSToolbarItem.Identifier("export")
    static let refreshItem = NSToolbarItem.Identifier("refresh")
}

extension WindowManager {

    @discardableResult
    static func makeScreenshotsWindowController(simulators: Simulators) -> ScreenshotsWindowController {
        addWindowController(ScreenshotsWindowController(simulators: simulators))
    }
}

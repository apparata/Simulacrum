//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Cocoa
import Constructs

class WindowManager {
    
    internal static var windowControllers: Set<NSWindowController> = []
    
    static func addWindowController<T: NSWindowController>(_ windowController: T) -> T {
        windowControllers.insert(windowController)
        guard let window = windowController.window else {
            return windowController
        }
        window.makeKeyAndOrderFront(nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowWillClose),
            name: NSWindow.willCloseNotification,
            object: window)
        return windowController
    }
        
    static func disposeWindowController(_ windowController: NSWindowController) {
        windowControllers.remove(windowController)
    }
    
    @objc
    static func windowWillClose(_ window: NSWindow) { NotificationCenter.default.removeObserver(self)
        for windowController in windowControllers {
            if windowController.window == window {
                windowControllers.remove(windowController)
                return
            }
        }
    }
}

extension NSWindowController: AutomaticallyHashable {}

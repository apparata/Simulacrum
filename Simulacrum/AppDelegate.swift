//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa
import SystemKit
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        WindowManager.makeMainWindowController()
    }

    // Terminate the app as soon as the last window is closed.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Cocoa
import SystemKit

class ScreenshotsFolder: ObservableObject {
    
    let path: Path
    
    init() {
        path = Path.temporaryDirectory
            .appendingComponent("Screenshots")
            .appendingComponent(UUID().uuidString)
    }

    func create() throws {
        try path.createDirectory(withIntermediateDirectories: true)
    }
    
    func openInFinder() {
        NSWorkspace.shared.open(path.url)
    }
    
    func screenshotsByGroup() -> [ScreenshotGroup: [Screenshot]] {
        var screenshotsByGroup: [ScreenshotGroup: [Screenshot]] = [:]
        do {
            let folders = try path.contentsOfDirectory(fullPaths: true)
            for folder in folders where !folder.lastComponent.hasPrefix(".") {
                let group = ScreenshotGroup(name: folder.lastComponent, path: folder)
                let files = try folder.contentsOfDirectory(fullPaths: true).filter { $0.extension == "png" }
                screenshotsByGroup[group] = files.map {
                    let deviceName = $0.deletingExtension.lastComponent
                    return Screenshot(path: $0, deviceName: deviceName)
                }
            }
        } catch {
            dump(error)
            return [:]
        }
        return screenshotsByGroup
    }
}

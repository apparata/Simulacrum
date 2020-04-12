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
    
    func screenshotFilesByFolder() -> [Path: [Path]] {
        var filesByFolder: [Path: [Path]] = [:]
        do {
            let folders = try path.contentsOfDirectory(fullPaths: true)
            for folder in folders where !folder.lastComponent.hasPrefix(".") {
                let files = try folder.contentsOfDirectory(fullPaths: true).filter { $0.extension == "png" }
                filesByFolder[folder] = files
            }
        } catch {
            dump(error)
            return [:]
        }
        return filesByFolder
    }
}

//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit

struct Screenshot {
    let groupName: String
    let deviceName: String
    let path: Path
}

class Screenshots: ObservableObject {
    
    let folder: ScreenshotsFolder
        
    @Published var filesByFolder: [Path: [Path]] = [:]
    
    @Published var deviceNames: [String] = []
    
    var screenshotsByDeviceName: [String: [Screenshot]] {
        
        var screenshotsByDevice: [String: [Screenshot]] = [:]
        for (folder, files) in filesByFolder {
            let screenshots = files.map { filePath in
                Screenshot(groupName: folder.lastComponent,
                           deviceName: filePath.deletingExtension.lastComponent,
                           path: filePath)
            }
            for screenshot in screenshots {
                screenshotsByDevice[screenshot.deviceName, default: []] += [screenshot]
            }
        }
        
        return screenshotsByDevice
    }
        
    init(folder: ScreenshotsFolder) {
        self.folder = folder
    }
    
    func refresh() {
        filesByFolder = folder.screenshotFilesByFolder()
        deviceNames = filesByFolder.first?.1.compactMap {
            $0.deletingExtension.lastComponent
        } ?? []
    }
}

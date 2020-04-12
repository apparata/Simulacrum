//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit

struct ScreenshotGroup: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let path: Path
}

struct Screenshot: Identifiable {
    var id: Path { path }
    let path: Path
    let deviceName: String
    let thumbnailPath: Path
    
    init(path: Path, deviceName: String) {
        self.path = path
        self.deviceName = deviceName
        thumbnailPath = path
            .replacingLastComponent(with: ".thumbnails")
            .appendingComponent(path.lastComponent)
    }
}

class Screenshots: ObservableObject {
    
    let folder: ScreenshotsFolder
        
    @Published var screenshotsByGroup: [ScreenshotGroup: [Screenshot]] = [:]
    
    @Published var deviceNames: [String] = []
    
    var screenshotsByDeviceName: [String: [Screenshot]] {
        
        var screenshotsByDevice: [String: [Screenshot]] = [:]
        for (_, screenshots) in screenshotsByGroup {
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
        screenshotsByGroup = folder.screenshotsByGroup()
        deviceNames = screenshotsByGroup.first?.1.map(\.deviceName) ?? []
    }
}

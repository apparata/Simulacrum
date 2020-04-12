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
    
    func makeDragItem() -> NSItemProvider {
        do {
            let dragNDropFolder = Path.temporaryDirectory
                .appendingComponent(".dragNDrop")
            try dragNDropFolder.createDirectory(withIntermediateDirectories: true)
            let dragNDropFile = dragNDropFolder
                .appendingComponent(path.lastComponent)
            if dragNDropFile.exists {
                try dragNDropFile.remove()
            }
            try path.copy(to: dragNDropFile)
            return NSItemProvider(object: dragNDropFile.url as NSURL)
        } catch {
            dump(error)
            return NSItemProvider()
        }
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

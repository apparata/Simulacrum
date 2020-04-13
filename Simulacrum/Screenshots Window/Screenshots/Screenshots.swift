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

struct ScreenshotDevice: Identifiable, Hashable {
    var id: String { name }
    let name: String
}

struct Screenshot: Identifiable {
    var id: Path { path }
    let path: Path
    let group: ScreenshotGroup
    let device: ScreenshotDevice
    let thumbnailPath: Path
    let width: Int
    let height: Int

    init(path: Path, group: ScreenshotGroup, device: ScreenshotDevice, width: Int, height: Int) {
        self.path = path
        self.group = group
        self.device = device
        self.width = width
        self.height = height
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
    
    var groups: [ScreenshotGroup] {
        Array(screenshotsByGroup.keys)
    }
        
    @Published var screenshotsByGroup: [ScreenshotGroup: [Screenshot]] = [:]
    
    var devices: [ScreenshotDevice] {
        Array(screenshotsByDevice.keys)
    }
    
    var screenshotsByDevice: [ScreenshotDevice: [Screenshot]] = [:]
        
    init(folder: ScreenshotsFolder) {
        self.folder = folder
    }
    
    func refresh() {
        screenshotsByGroup = folder.screenshotsByGroup()
                
        screenshotsByDevice = [:]
        for group in screenshotsByGroup.keys.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending }) {
            for screenshot in screenshotsByGroup[group] ?? [] {
                screenshotsByDevice[screenshot.device, default: []] += [screenshot]
            }
        }

    }
}

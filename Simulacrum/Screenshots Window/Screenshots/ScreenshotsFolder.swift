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
                    let size = self.imageSizeFromPNG(at: $0.url)
                    let deviceName = $0.deletingExtension.lastComponent
                    return Screenshot(path: $0, deviceName: deviceName, width: size?.width ?? 0, height: size?.height ?? 0)
                }
            }
        } catch {
            dump(error)
            return [:]
        }
        return screenshotsByGroup
    }
    
    /// Returns size of PNG image without loading entire file into memory,
    /// when memory mapping is safe, which depends on media etc.
    func imageSizeFromPNG(at url: URL) -> (width: Int, height: Int)? {
        let tagIHDR = 0x49484452
        func decodeInt(from data: Data, at offset: Int) -> Int {
            Int(data.subdata(in: offset..<offset + 4).withUnsafeBytes {
                $0.load(as: UInt32.self).byteSwapped
            })
        }
        // Memory map file, only first page (4096 bytes) is loaded into memory.
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe),
            data.count > 24, tagIHDR == decodeInt(from: data, at: 12) else {
            return nil
        }
        return (width: decodeInt(from: data, at: 16),
                height: decodeInt(from: data, at: 20))
    }
}

//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit
import Cocoa

class SketchExporter {
    
    struct Artboard {
        let id: String
        let name: String
        let json: String
    }

    func exportScreenshots(_ screenshots: Screenshots) throws {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        
        let exportFolder = Path.temporaryDirectory
            .appendingComponent("SketchExport")
            .appendingComponent(UUID().uuidString)
            try exportFolder.createDirectory(withIntermediateDirectories: true)

        let documentFolder = exportFolder
            .appendingComponent("Screenshots \(dateFormatter.string(from: Date()))")
        try documentFolder.createDirectory(withIntermediateDirectories: true)

        let pagesFolder = documentFolder.appendingComponent("pages")
        try pagesFolder.createDirectory(withIntermediateDirectories: true)
        
        let imagesFolder = documentFolder.appendingComponent("images")
        try imagesFolder.createDirectory(withIntermediateDirectories: true)
        
        let pageID = UUID().uuidString
        
        var artboards: [Artboard] = []
        
        var y: Int = 0
        
        for (_, screenshotFiles) in screenshots.screenshotsByDeviceName {
            var x: Int = 0
            var maxHeight: Int = 0
            for screenshot in screenshotFiles {
                
                guard let image = NSImage(contentsOf: screenshot.path.url) else {
                    print("ERROR: Could not read \(screenshot.path.string)")
                    continue
                }
                
                let (width, height) = image.sizeInPixels
                
                maxHeight = max(maxHeight, height)

                let imageFileName = String((UUID().uuidString + UUID().uuidString)
                    .lowercased().prefix(40))
                let artboardName = screenshot.deviceName
                let artboardID = UUID().uuidString
                let artboardJSON = makeArtboardJSON(x: x,
                                                    y: y,
                                                    width: width,
                                                    height: height,
                                                    imageName: artboardName,
                                                    imageFileName: imageFileName,
                                                    artboardName: artboardName,
                                                    artboardID: artboardID,
                                                    pageID: pageID)
                let artboard = Artboard(id: artboardID,
                                        name: artboardName,
                                        json: artboardJSON)
                artboards.append(artboard)
                
                let imagePath = imagesFolder
                    .appendingComponent(imageFileName)
                    .appendingExtension("png")
                
                try image.write(to: imagePath.url)
                
                x += 200 + width
            }
            y += 500 + maxHeight
        }

        let pageJSON = makePageJSON(pageID: pageID, artboards: artboards)

        let documentJSON = makeDocumentJSON(pageID: pageID)

        let metaJSON = makeMetaJSON(pageID: pageID, artboards: artboards)

        let userJSON = makeUserJSON(pageID: pageID)
                
        try metaJSON.write(to: documentFolder.appendingComponent("meta.json").url, atomically: true, encoding: .utf8)
        try userJSON.write(to: documentFolder.appendingComponent("user.json").url, atomically: true, encoding: .utf8)
        try documentJSON.write(to: documentFolder.appendingComponent("document.json").url, atomically: true, encoding: .utf8)
        try pageJSON.write(to: pagesFolder.appendingComponent("\(pageID).json").url, atomically: true, encoding: .utf8)

        NSWorkspace.shared.open(exportFolder.url)
    }
}

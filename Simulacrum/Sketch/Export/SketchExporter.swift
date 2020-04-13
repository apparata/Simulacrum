//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit
import Cocoa
import Zipcode

class SketchExporter {
    
    enum Error: Swift.Error {
        case failedToWriteData
    }
    
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
        
        let pageID = UUID().uuidString
        
        let archive = ZipArchive(path: exportFolder.appendingComponent("Screenshots \(dateFormatter.string(from: Date())).sketch").string)
        try archive.write(type: .overwrite) { writer in
        
            var artboards: [Artboard] = []
            
            var y: Int = 0
            
            for device in screenshots.devices.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending }) {
            
                var x: Int = 0
                var maxHeight: Int = 0
                for screenshot in screenshots.screenshotsByDevice[device] ?? [] {
                    
                    guard let image = NSImage(contentsOf: screenshot.path.url) else {
                        print("ERROR: Could not read \(screenshot.path.string)")
                        continue
                    }
                    
                    let (width, height) = image.sizeInPixels
                    
                    maxHeight = max(maxHeight, height)

                    let imageFileName = String((UUID().uuidString + UUID().uuidString)
                        .lowercased().prefix(40))
                    let artboardName = screenshot.device.name
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
                                        
                    try writer.writeEntryNamed("images/\(imageFileName).png", image: image)
                    
                    x += 200 + width
                }
                y += 500 + maxHeight
            }

            let pageJSON = makePageJSON(pageID: pageID, artboards: artboards)

            let documentJSON = makeDocumentJSON(pageID: pageID)

            let metaJSON = makeMetaJSON(pageID: pageID, artboards: artboards)

            let userJSON = makeUserJSON(pageID: pageID)
                    
            /*
            try metaJSON.write(to: documentFolder.appendingComponent("meta.json").url, atomically: true, encoding: .utf8)
            try userJSON.write(to: documentFolder.appendingComponent("user.json").url, atomically: true, encoding: .utf8)
            try documentJSON.write(to: documentFolder.appendingComponent("document.json").url, atomically: true, encoding: .utf8)
            try pageJSON.write(to: pagesFolder.appendingComponent("\(pageID).json").url, atomically: true, encoding: .utf8)*/
        
            try writer.writeEntryNamed("meta.json", string: metaJSON)
            try writer.writeEntryNamed("user.json", string: userJSON)
            try writer.writeEntryNamed("document.json", string: documentJSON)
            try writer.writeEntryNamed("pages/\(pageID).json", string: pageJSON)
        }

        NSWorkspace.shared.open(exportFolder.url)
    }
}

private extension ZipWriter {
    
    func writeEntryNamed(_ name: String, string: String) throws {
        let data = string.data(using: .utf8) ?? Data()
        try writeEntryNamed(name, data: data)
    }
}

private extension ZipWriter {
    
    enum NSImageZipWriterError: Error {
        case failedToGetTIFFRepresentation
        case failedToCreateBitmapRepresentation
        case failedToCreateImageData
    }
    
    func writeEntryNamed(_ name: String, image: NSImage, fileType: NSBitmapImageRep.FileType = .png) throws {

        guard let tiffData = image.tiffRepresentation else {
            throw NSImageZipWriterError.failedToGetTIFFRepresentation
        }
        
        guard let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw NSImageZipWriterError.failedToCreateBitmapRepresentation
        }
        
        guard let data = bitmap.representation(using: fileType, properties: [.compressionFactor: 1.0]) else {
            throw NSImageZipWriterError.failedToCreateImageData
        }

        try writeEntryNamed(name, data: data)
    }
}

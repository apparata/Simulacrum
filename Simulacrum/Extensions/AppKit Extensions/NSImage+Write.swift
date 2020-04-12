//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    
    enum WriteError: Error {
        case failedToGetTIFFRepresentation
        case failedToCreateBitmapRepresentation
        case failedToCreateImageData
        case failedToWrite(Error)
    }
    
    func write(to url: URL, fileType: NSBitmapImageRep.FileType = .png) throws {

        guard let tiffData = tiffRepresentation else {
            throw WriteError.failedToGetTIFFRepresentation
        }
        
        guard let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw WriteError.failedToCreateBitmapRepresentation
        }
        
        guard let data = bitmap.representation(using: fileType, properties: [.compressionFactor: 1.0]) else {
            throw WriteError.failedToCreateImageData
        }

        do {
            try data.write(to: url)
        } catch {
            throw WriteError.failedToWrite(error)
        }
    }
}

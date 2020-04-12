//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    
    var sizeInPixels: (width: Int, height: Int) {
        let representation = representations[0]
        let width = CGFloat(representation.pixelsWide)
        let height = CGFloat(representation.pixelsHigh)
        return (width: Int(width), height: Int(height))
    }
    
    func resized(to size: NSSize) -> NSImage? {
        
        guard isValid else {
            return nil
        }
        
        guard let representation = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0) else {
            return nil
        }
        
        representation.size = size
        
        let context = NSGraphicsContext(bitmapImageRep: representation)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context
        let frame = NSRect(origin: .zero, size: size)
        draw(in: frame, from: .zero, operation: .copy, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: size)
        newImage.addRepresentation(representation)
        
        return newImage
    }
    
    func resizedToFit(in size: CGSize) -> NSImage? {
        let representation = representations[0]
        let width = CGFloat(representation.pixelsWide)
        let height = CGFloat(representation.pixelsHigh)
        
        let w = size.width / width
        let h = size.height / height
        
        var adjustedSize: NSSize = size
        if h < w {
            adjustedSize.width = size.height / height * width
        } else if w < h {
            adjustedSize.height = size.width / width * height
        }
        
        return resized(to: adjustedSize)
    }
    
}

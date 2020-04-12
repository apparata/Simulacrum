//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

enum ScreenshotMask: String, CaseIterable, Codable {
    case ignored = "Ignored"
    case alpha = "Alpha"
    case black = "Black"
    
    var argument: String {
        rawValue.lowercased()
    }
}

extension ScreenshotMask: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

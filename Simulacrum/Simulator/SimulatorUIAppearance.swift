//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

enum SimulatorUIAppearance: String, CaseIterable, Codable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    
    var argument: String {
        rawValue.lowercased()
    }
}

extension SimulatorUIAppearance: CustomStringConvertible {
    var description: String { rawValue }
    var id: Self { self }
}

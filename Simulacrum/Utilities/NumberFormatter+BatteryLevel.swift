//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    static var batteryLevel: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}

//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa

public extension NSImage {
    
    convenience init(requiredNamed name: String) {
        // swiftlint:disable force_unwrapping
        self.init(named: name)!
        // swiftlint:enable <rule1>
    }
}

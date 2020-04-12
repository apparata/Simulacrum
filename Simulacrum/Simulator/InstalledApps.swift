//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit
import Combine

class InstalledApps: ObservableObject {
    
    @Published var apps: [AppInfo] = []
    
    private var device: Device
    
    init(on device: Device) {
        self.device = device
        update()
    }
    
    func update() {
        apps = AppInfo.listInstalledApps(for: device)
    }
}

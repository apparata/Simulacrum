//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import SettingsKit

struct SimulatorDetailView: View {
    
    let runtime: Runtime
    
    let deviceID: Device.ID
    
    var device: Device? {
        simulators.deviceWithID(id: deviceID, runtime: runtime)
    }
    
    @EnvironmentObject private var simulators: Simulators
            
    var body: some View {
        ZStack {
            Color(NSColor.controlBackgroundColor)
                .edgesIgnoringSafeArea(.top)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    SimulatorDetailHeaderView(runtime: runtime, deviceID: deviceID)

                    StatusBarView(runtime: runtime, deviceID: deviceID)
                        .padding(.top, 4)
                    
                    Divider()
                        .padding(.top, 4)

                    InstalledAppsView()
                    
                    Divider()
                        .padding(.top, 4)

                    PermissionsView()
                }
                .padding(EdgeInsets(top: 10, leading: 40, bottom: 40, trailing: 40))
            }
            .padding(.top, 1)
        }
    }
}


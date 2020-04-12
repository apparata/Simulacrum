//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import SettingsKit

struct AllStartedSimulatorsDetailView: View {
    
    let runtime: Runtime
        
    @EnvironmentObject private var simulators: Simulators
            
    var body: some View {
        ZStack {
            Color(NSColor.controlBackgroundColor)
                .edgesIgnoringSafeArea(.top)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    SimulatorDetailHeaderView(runtime: runtime, deviceID: "AllStarted")

                    StatusBarView(runtime: runtime, deviceID: "AllStarted")
                        .padding(.top, 4)
                    
                    Divider()
                        .padding(.top, 4)
                }
                .padding(EdgeInsets(top: 10, leading: 40, bottom: 40, trailing: 40))
            }
            .padding(.top, 1)
        }
    }
}


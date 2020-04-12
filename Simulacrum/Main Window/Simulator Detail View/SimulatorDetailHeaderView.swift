//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIToolbox

struct SimulatorDetailHeaderView: View {
    
    let runtime: Runtime
    
    let deviceID: DeviceID
    
    var device: Device? {
        simulators.deviceWithID(id: deviceID, runtime: runtime)
    }
    
    @EnvironmentObject private var simulators: Simulators
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Text("\(device?.name ?? (deviceID == "AllStarted" ? "All Started Simulators" : "<Unknown>"))")
                    .font(.title)
                    .bold()
                Spacer()
                if deviceID == "AllStarted" {
                    Button("Screenshots", action: openScreenshotsWindow)
                        .buttonStyle(ActionButtonStyle())
                } else {
                    Button(action: startOrStopDevice) {
                        Text(device?.state == "Booted" ? "Stop" : "Start")
                    }.buttonStyle(ActionButtonStyle())
                }
            }
            Divider()
                .padding(.top, -2)
        }
    }
    
    private func startOrStopDevice() {
        guard let device = device else {
            return
        }
        if device.state == "Booted" {
            simulators.shutDownDevice(device)
        } else {
            simulators.bootDevice(device)
        }
    }
    
    private func openScreenshotsWindow() {
        WindowManager.makeScreenshotsWindowController(simulators: simulators)
    }
}

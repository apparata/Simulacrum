//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox

struct MainSplitView: View {
    
    @ObservedObject private var searchFilter = SearchFilter<Device>()
    
    @EnvironmentObject private var simulators: Simulators
    
    var body: some View {
        NavigationView {
            
            MainSidebarView {
                
                SidebarSearchField(text: self.$searchFilter.searchText)
                    .padding(EdgeInsets(top: 16, leading: 10, bottom: 0, trailing: 10))
                
                Picker(selection: self.$simulators.runtimeSelection, label: EmptyView()) {
                    ForEach(self.simulators.list.runtimes) { runtime in
                        Text(runtime.name).tag(runtime)
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 10, bottom: 0, trailing: 10))
                
                List(selection: self.$simulators.deviceSelection) {

                    Section(header: Text("Started")) {
                        ForEach(self.startedSimulators(), id: \.self) { device in
                            NavigationLink(destination: Group {
                                if device.udid == "AllStarted" {
                                    AllStartedSimulatorsDetailView(runtime: self.simulators.runtimeSelection)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                } else {
                                    SimulatorDetailView(runtime: self.simulators.runtimeSelection, deviceID: device.id)
                                        .environmentObject(InstalledApps(on: device))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }) {
                                Text(device.name)
                                    .foregroundColor(Color.primary)
                            }
                            .tag(device)
                            .contextMenu {
                                Button(action: {
                                    self.simulators.shutDownDevice(device)
                                }) {
                                    Text("Stop")
                                }
                            }
                        }
                    }

                    Section(header: Text("Stopped")) {
                        ForEach(self.stoppedSimulators(), id: \.self) { device in
                            NavigationLink(destination: SimulatorDetailView(runtime: self.simulators.runtimeSelection, deviceID: device.id)
                                .environmentObject(InstalledApps(on: device))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)) {
                                Text(device.name)
                                    .foregroundColor(Color.secondary.opacity(0.5))
                            }
                            .tag(device)
                            .contextMenu {
                                Button(action: {
                                    self.simulators.bootDevice(device)
                                }) {
                                    Text("Start")
                                }
                            }

                        }
                    }

                }
                .listStyle(SidebarListStyle())
            }
            
            MainContentView {
                Text("Select a Device")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func startedSimulators() -> [Device] {
        return searchFilter.apply(to: simulators.bootedDevicesForSelectedRuntime)
            + [Device(udid: "AllStarted", name: "All Started", state: "Booted", isAvailable: true)]
    }
    
    private func stoppedSimulators() -> [Device] {
        self.searchFilter.apply(to: self.simulators.nonBootedDevicesForSelectedRuntime)
    }
}

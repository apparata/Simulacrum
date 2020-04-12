//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import SettingsKit

struct StatusBarView: View {
    
    let runtime: Runtime
    
    let deviceID: DeviceID
    
    var device: Device? {
        simulators.deviceWithID(id: deviceID, runtime: runtime)
    }
    
    @EnvironmentObject private var simulators: Simulators
    
    @State var overrideTime: Bool = false
    @State var timeString: String = "13:37"
    
    @State var overrideAppearance: Bool = false
    @State var appearance: StatusBarOverrides.Appearance = .light
    
    @State var overrideOperatorName: Bool = false
    @State var operatorName: String = "Carrier"

    @State var overrideNetwork: Bool = false
    @State var network: StatusBarOverrides.NetworkType = .lte

    @State var overrideWiFiMode: Bool = false
    @State var wifiMode: StatusBarOverrides.WiFiMode = .active

    @State var overrideWiFiBars: Bool = false
    @State var wifiBars: Int = 3

    @State var overrideCellularMode: Bool = false
    @State var cellularMode: StatusBarOverrides.CellularMode = .active

    @State var overrideCellularBars: Bool = false
    @State var cellularBars: Int = 4

    @State var overrideBatteryState: Bool = false
    @State var batteryState: StatusBarOverrides.BatteryState = .charged

    @State var overrideBatteryLevel: Bool = false
    @State var batteryLevel: Int = 100
    
    private let titleWidth: CGFloat = 90

    var body: some View {
        VStack(alignment: .leading) {
            Text("Status Bar & Appearance")
                .font(.headline)
                .padding(.bottom, 10)
            HStack {
                HStack {
                    Toggle(isOn: $overrideTime) {
                        Text("Time:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    TextField("E.g. 13:37", text: $timeString)
                        .frame(width: 98)
                }.padding(.trailing, 16)
                HStack {
                    Toggle(isOn: $overrideAppearance) {
                        Text("Appearance:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    EnumPickerSetting(title: "", selected: $appearance)
                        .labelsHidden()
                        .frame(width: 80)
                }
            }
            HStack {
                HStack {
                    Toggle(isOn: $overrideOperatorName) {
                        Text("Operator:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    TextField("Carrier", text: $operatorName)
                        .frame(width: 98)
                }.padding(.trailing, 16)
                HStack {
                    Toggle(isOn: $overrideNetwork) {
                        Text("Network Type:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    EnumPickerSetting(title: "", selected: $network)
                        .labelsHidden()
                        .frame(width: 80)
                }
            }
            HStack {
                HStack {
                    Toggle(isOn: $overrideWiFiMode) {
                        Text("WiFi Mode:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    EnumPickerSetting(title: "", selected: $wifiMode)
                        .labelsHidden()
                        .frame(width: 98)
                }.padding(.trailing, 16)
                HStack {
                    Toggle(isOn: $overrideWiFiBars) {
                        Text("WiFi Bars:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    Stepper(value: $wifiBars, in: 0...3) {
                        Text("\(wifiBars)")
                            .frame(width: 10, alignment: .leading)
                    }
                }
            }
            HStack {
                HStack {
                    Toggle(isOn: $overrideCellularMode) {
                        Text("Cellular Mode:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    EnumPickerSetting(title: "", selected: $cellularMode)
                        .labelsHidden()
                        .frame(width: 98)
                }.padding(.trailing, 16)
                HStack {
                    Toggle(isOn: $overrideCellularBars) {
                        Text("Cellular Bars:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    Stepper(value: $cellularBars, in: 0...4) {
                        Text("\(cellularBars)")
                            .frame(width: 10, alignment: .leading)
                    }

                }
            }
            HStack {
                HStack {
                    Toggle(isOn: $overrideBatteryState) {
                        Text("Battery State:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    EnumPickerSetting(title: "", selected: $batteryState)
                        .labelsHidden()
                        .frame(width: 98)
                }.padding(.trailing, 16)
                HStack {
                    Toggle(isOn: $overrideBatteryLevel) {
                        Text("Battery Level:")
                            .frame(width: titleWidth, alignment: .leading)
                    }.toggleStyle(CheckboxToggleStyle())
                    TextField("0 - 100", value: $batteryLevel, formatter: NumberFormatter.batteryLevel)
                        .frame(width: 34)
                    Text("%")
                }
            }
            HStack {
                Button("Apply", action: {
                    let overrides = StatusBarOverrides(
                        time: self.overrideTime ? self.timeString : nil,
                        operatorName: self.overrideOperatorName ? self.operatorName : nil,
                        networkType: self.overrideNetwork ? self.network : nil,
                        wifiMode: self.overrideWiFiMode ? self.wifiMode : nil,
                        wifiBars: self.overrideWiFiBars ? self.wifiBars : nil,
                        cellularMode: self.overrideCellularMode ? self.cellularMode : nil,
                        cellularBars: self.overrideCellularBars ? self.cellularBars : nil,
                        batteryState: self.overrideBatteryState ? self.batteryState : nil,
                        batteryLevel: self.overrideBatteryLevel ? self.batteryLevel : nil)
                    self.applyStatusBarOverrides(overrides)
                    self.applyAppearance()
                })
                Button("Reset", action: clearStatusBar)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
    
    private func applyStatusBarOverrides(_ overrides: StatusBarOverrides) {
        if let device = device {
            simulators.applyStatusBarOverrides(overrides, on: device)
        } else {
            let devices = simulators.bootedDevicesForSelectedRuntime
            for device in devices {
                simulators.applyStatusBarOverrides(overrides, on: device)
            }
        }
    }
    
    private func applyAppearance() {
        guard overrideAppearance else {
            return
        }
        if let device = device {
            simulators.applyAppearance(appearance == .light ? .light : .dark, for: device)
        } else {
            let devices = simulators.bootedDevicesForSelectedRuntime
            for device in devices {
                simulators.applyAppearance(appearance == .light ? .light : .dark, for: device)
            }
        }
    }
    
    private func clearStatusBar() {
        if let device = device {
            simulators.clearStatusBar(on: device)
            simulators.applyAppearance(.light, for: device)
        } else {
            let devices = simulators.bootedDevicesForSelectedRuntime
            for device in devices {
                simulators.clearStatusBar(on: device)
                simulators.applyAppearance(.light, for: device)
            }
        }
    }
}

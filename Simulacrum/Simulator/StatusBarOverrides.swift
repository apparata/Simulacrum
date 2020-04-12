//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

struct StatusBarOverrides {
    
    enum Appearance: String, CaseIterable, Codable {
        case light = "Light"
        case dark = "Dark"
        
        var argument: String {
            rawValue.lowercased()
        }
    }

    enum NetworkType: String, CaseIterable, Codable {
        case wifi = "WiFi"
        case threeG = "3G"
        case fourG = "4G"
        case lte = "LTE"
        case lteA = "LTE-A"
        case ltePlus = "LTE+"
        
        var argument: String {
            switch self {
            case .wifi: return "wifi"
            case .threeG: return "3g"
            case .fourG: return "4g"
            case .lte: return "lte"
            case .lteA: return "lte-a"
            case .ltePlus: return "lte+"
            }
        }
    }
    
    enum WiFiMode: String, CaseIterable, Codable {
        case searching = "Searching"
        case failed = "Failed"
        case active = "Active"
        
        var argument: String {
            rawValue.lowercased()
        }
    }
    
    enum CellularMode: String, CaseIterable, Codable {
        case notSupported = "Not Supported"
        case searching = "Searching"
        case failed = "Failed"
        case active = "Active"
        
        var argument: String {
            switch self {
            case .notSupported: return "notSupported"
            case .searching: return "searching"
            case .failed: return "failed"
            case .active: return "active"
            }
        }
    }
    
    enum BatteryState: String, CaseIterable, Codable {
        case charging = "Charging"
        case charged = "Charged"
        case discharging = "Discharging"

        var argument: String {
            rawValue.lowercased()
        }
    }
    
    let time: String?
    let operatorName: String?
    let networkType: NetworkType?
    let wifiMode: WiFiMode?
    let wifiBars: Int?
    let cellularMode: CellularMode?
    let cellularBars: Int?
    let batteryState: BatteryState?
    let batteryLevel: Int?
}

extension StatusBarOverrides.Appearance: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

extension StatusBarOverrides.NetworkType: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

extension StatusBarOverrides.WiFiMode: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

extension StatusBarOverrides.CellularMode: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

extension StatusBarOverrides.BatteryState: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

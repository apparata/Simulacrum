//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit
import Cocoa

class AppInfo: Identifiable, Hashable {

    enum Error: Swift.Error {
        case missingField(key: String)
        case notFoundOrNotAPropertyList
    }

    var id: String {
        return bundleIdentifier
    }
    
    let bundleIdentifier: String
    let appVersion: String
    let buildVersion: String
    let displayName: String
    let minimumOSVersion: String
    let appIcon: NSImage?
    
    init(bundlePath: Path) throws {
        
        let infoPListPath = bundlePath.appendingComponent("Info.plist")
        guard let appInfo = NSDictionary(contentsOf: infoPListPath.url) else {
            throw Error.notFoundOrNotAPropertyList
        }
        displayName = try optional(key: "CFBundleDisplayName", in: appInfo) ?? bundlePath.deletingExtension.lastComponent
        
        bundleIdentifier = try required(key: "CFBundleIdentifier", in: appInfo)
        appVersion = try required(key: "CFBundleShortVersionString", in: appInfo)
        buildVersion = try required(key: "CFBundleVersion", in: appInfo)
        minimumOSVersion = try required(key: "MinimumOSVersion", in: appInfo)
        
        if let bundleIcons: NSDictionary = try optional(key: "CFBundleIcons", in: appInfo),
            let primaryIcon: NSDictionary = try optional(key: "CFBundlePrimaryIcon", in: bundleIcons),
            let iconFiles: NSArray = try optional(key: "CFBundleIconFiles", in: primaryIcon),
            let iconFileName: String = iconFiles.firstObject as? String,
            let icon: NSImage = NSImage(contentsOf: bundlePath.appendingComponent("\(iconFileName)@2x.png").url) {
            appIcon = icon
        } else {
            appIcon = nil
        }
    }
    
    init() {
        bundleIdentifier = "none"
        appVersion = "0.0.0"
        buildVersion = "0"
        displayName = "None"
        minimumOSVersion = "0.0.0"
        appIcon = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        lhs.id == rhs.id
    }
}

private func required<T>(key: String, in dictionary: NSDictionary) throws -> T {
    guard let value = dictionary[key] as? T else {
        throw AppInfo.Error.missingField(key: key)
    }
    return value
}

private func optional<T>(key: String, in dictionary: NSDictionary) throws -> T? {
    return dictionary[key] as? T
}

extension AppInfo {
    static func listInstalledApps(for device: Device) -> [AppInfo] {
        let path = Path("~/Library/Developer/CoreSimulator/Devices")
            .appendingComponent(device.udid)
            .appending("data/Containers/Bundle/Application")
            .normalized
        
        guard let appContainerPaths = try? path.contentsOfDirectory(fullPaths: true) else {
            return []
        }
        
        var apps: [AppInfo] = []
        for appContainerPath in appContainerPaths {
            guard let potentialAppPaths = try? appContainerPath.contentsOfDirectory(fullPaths: true) else {
                continue
            }
            guard let appBundlePath = potentialAppPaths.first(where: { $0.extension == "app" }) else {
                continue
            }
            guard let appInfo = try? AppInfo(bundlePath: appBundlePath) else {
                continue
            }
            apps.append(appInfo)
        }
        
        return apps
    }
}

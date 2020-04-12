//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public typealias RuntimeID = String
public typealias DeviceTypeID = String
public typealias DeviceID = String
public typealias PairID = String

public struct Runtime: Identifiable, Hashable {
    
    public static let zero = Runtime()
    
    public let id: RuntimeID
    public let name: String
    public let version: String
    public let buildVersion: String
    public let bundlePath: String
    public let isAvailable: Bool
    
    init(id: RuntimeID = "",
         name: String = "",
         version: String = "",
         buildVersion: String = "",
         bundlePath: String = "",
         isAvailable: Bool = false) {
        self.id = id
        self.name = name
        self.version = version
        self.buildVersion = buildVersion
        self.bundlePath = bundlePath
        self.isAvailable = isAvailable
    }
}

public struct DeviceType: Identifiable, Hashable {
    
    public static let zero = DeviceType()
    
    public let id: DeviceTypeID
    public let name: String
    public let bundlePath: String
    
    public init(id: DeviceTypeID = "",
                name: String = "",
                bundlePath: String = "") {
        self.id = id
        self.name = name
        self.bundlePath = bundlePath
    }
}

public struct Device: Identifiable, Hashable {
    
    public static let zero = Device()
    
    public var id: DeviceID { udid }
    public let udid: DeviceID
    public let name: String
    public let state: String
    public let isAvailable: Bool
    public let availabilityError: String?

    public init(udid: DeviceID = "",
                name: String = "",
                state: String = "",
                isAvailable: Bool = false,
                availabilityError: String? = nil) {
        self.udid = udid
        self.name = name
        self.state = state
        self.isAvailable = isAvailable
        self.availabilityError = nil
    }
}

// TODO
/*
struct Pair {
    public var watch: String
    public var phone: String
    public var state: String
}*/

struct SimulatorList {
        
    let runtimes: [Runtime]
    let deviceTypes: [DeviceType]
    let devices: [RuntimeID: [Device]]
    //let pairs: [PairID: Pair]
    
    init() {
        runtimes = []
        deviceTypes = []
        devices = [:]
    }
}

// ---------------------------------------------------------------------------
// MARK: - Codable
// ---------------------------------------------------------------------------
        
extension SimulatorList: Decodable {
        
    enum CodingKeys: String, CodingKey {
        case runtimes
        case deviceTypes = "devicetypes"
        case devices
        case pairs
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        runtimes = try container.decode([Runtime].self, forKey: .runtimes)
        deviceTypes = try container.decode([DeviceType].self, forKey: .deviceTypes)
        devices = try container.decode([RuntimeID: [Device]].self, forKey: .devices)
    }
}

extension DeviceType: Decodable {
        
    enum CodingKeys: String, CodingKey {
        case name
        case bundlePath
        case id = "identifier"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        bundlePath = try container.decode(String.self, forKey: .bundlePath)
        id = try container.decode(String.self, forKey: .id)
    }
}

extension Runtime: Decodable {
        
    enum CodingKeys: String, CodingKey {
        case version
        case bundlePath
        case isAvailable
        case name
        case id = "identifier"
        case buildVersion = "buildversion"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        bundlePath = try container.decode(String.self, forKey: .bundlePath)
        isAvailable = try container.decode(Bool.self, forKey: .isAvailable)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        buildVersion = try container.decode(String.self, forKey: .buildVersion)
    }
}

extension Device: Decodable {
        
    enum CodingKeys: String, CodingKey {
        case state
        case isAvailable
        case name
        case udid
        case availabilityError
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        state = try container.decode(String.self, forKey: .state)
        isAvailable = try container.decode(Bool.self, forKey: .isAvailable)
        name = try container.decode(String.self, forKey: .name)
        udid = try container.decode(String.self, forKey: .udid)
        availabilityError = try container.decodeIfPresent(String.self, forKey: .availabilityError)
    }
}


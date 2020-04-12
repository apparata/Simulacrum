//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

enum Permission: String, CaseIterable, Codable, Identifiable {
    
    // Apply the action to all services.
    case all = "All Permissions"
    
    // Allow access to calendar.
    case calendar = "Calendar"
    
    // Allow access to basic contact info.
    case contactsLimited = "Contacts (Limited)"
    
    // Allow access to full contact details.
    case contacts = "Contacts (Full)"
        
    // Allow access to location services when app is in use.
    case location = "Location (In Use)"
    
    // Allow access to location services at all times.
    case locationAlways = "Location (Always)"

    // Allow adding photos to the photo library.
    case photosAdd = "Photos (Add Only)"

    // Allow full access to the photo library.
    case photos = "Photos (Full)"
    
    // Allow access to the media library.
    case mediaLibrary = "Media Library"
    
    // Allow access to audio input.
    case microphone = "Microphone"
    
    // Allow access to motion and fitness data.
    case motion = "Motion / Fitness"
    
    // Allow access to reminders.
    case reminders = "Reminders"
    
    // Allow use of the app with Siri.
    case siri = "Siri"
    
    var argument: String {
        switch self {
        case .all: return "all"
        case .calendar: return "calendar"
        case .contactsLimited: return "contacts-limited"
        case .contacts: return "contacts"
        case .location: return "location"
        case .locationAlways: return "location-always"
        case .photosAdd: return "photos-add"
        case .photos: return "photos"
        case .mediaLibrary: return "media-library"
        case .microphone: return "microphone"
        case .motion: return "motion"
        case .reminders: return "reminders"
        case .siri: return "siri"
        }
    }
}

extension Permission: CustomStringConvertible {
    var description: String { rawValue }
    var id: Self { self }
}

enum PermissionAction: String, CaseIterable, Codable, Identifiable {
    case grant = "Grant"
    case revoke = "Revoke"
    case reset = "Reset"
    
    var argument: String {
        rawValue.lowercased()
    }
}

extension PermissionAction: CustomStringConvertible {
    var description: String { rawValue }
    var id: Self { self }
}

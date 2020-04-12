//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIToolbox
import SettingsKit

struct PermissionsView: View {
    
    @EnvironmentObject var installedApps: InstalledApps
    
    @State var action: PermissionAction = .grant
    @State var permission: Permission = .location
    @State var app: AppInfo = AppInfo()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Permissions")
                .font(.headline)
                .padding(.bottom, 10)
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        EnumPickerSetting(title: "", selected: $action)
                            .labelsHidden()
                            .frame(width: 80)
                    }
                    HStack {
                        EnumPickerSetting(title: "", selected: $permission)
                            .labelsHidden()
                            .frame(width: 150)
                    }
                    HStack {
                        Picker(selection: $app, label: Text("in app")) {
                            ForEach(installedApps.apps) { value in
                                Text(value.displayName).tag(value)
                            }
                        }
                        .frame(width: 160)
                    }
                }
                .padding(.bottom, 10)
                Button("Execute", action: grantPermission)
            }
        }
    }
    
    private func grantPermission() {
        
    }

    private func revokePermission() {
        
    }
    
    private func resetPermission() {
        
    }
}

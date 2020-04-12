//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI

struct InstalledAppsView: View {
    
    @EnvironmentObject var installedApps: InstalledApps

    var body: some View {
        VStack(alignment: .leading) {
            Text("Installed Apps")
                .font(.headline)
            ForEach(installedApps.apps) { appInfo in
                HStack {
                    Image(nsImage: appInfo.appIcon ?? NSImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                        )
                    Text(appInfo.displayName)
                        .foregroundColor(Color.primary)
                        .lineLimit(1)
                        .frame(width: 120, alignment: .leading)
                    Text("\(appInfo.appVersion) (\(appInfo.buildVersion))")
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .frame(width: 100, alignment: .leading)
                    Text(appInfo.bundleIdentifier)
                        .foregroundColor(Color.secondary.opacity(0.6))
                        .lineLimit(1)
                        .frame(alignment: .leading)
                    Spacer()
                }
            }
        }
    }
}

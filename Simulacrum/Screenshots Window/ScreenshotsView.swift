//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import SettingsKit
import SystemKit

struct ScreenshotsView: View {
    
    @EnvironmentObject var simulators: Simulators
    @EnvironmentObject var screenshotsFolder: ScreenshotsFolder
    @EnvironmentObject var screenshotsManager: ScreenshotsManager
    
    @State private var screenshotMask: ScreenshotMask = .ignored
    @State private var thumbnailSize: CGFloat = 200
    @State private var rowIsType: RowType = .group

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: takeScreenshots) {
                    Image("icon/screenshots")
                }
                Spacer()
                    .frame(width: 8)
                EnumPickerSetting(title: "Mask:", selected: $screenshotMask)
                    .frame(width: 130)
            }
            .padding()
            Divider()
                .background(Color(NSColor(requiredNamed: "Colors/screenshotsDivider")))
                .padding([.leading, .trailing], 20)
            ScrollView([.horizontal, .vertical]) {
                ScreenshotsMatrix($screenshotsManager.screenshots,
                                  thumbnailSize: $thumbnailSize,
                                  rowIsType: $rowIsType)
            }
            Divider()
                .background(Color(NSColor(requiredNamed: "Colors/screenshotsDivider")))
                .padding([.leading, .trailing], 20)
            HStack(alignment: .center) {
                
                EnumPickerSetting(title: "Row is:", selected: $rowIsType)
                    .frame(width: 130)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 1)
                    .fill()
                    .foregroundColor(Color(white: 0.8))
                    .frame(width: 6, height: 12)
                Slider(value: $thumbnailSize, in: 100...300)
                    .frame(width: 150)
                RoundedRectangle(cornerRadius: 2)
                    .fill()
                    .foregroundColor(Color(white: 0.8))
                    .frame(width: 8, height: 16)
            }
            .padding(.horizontal, 20)
            .padding(2)
        }.background(Color(NSColor(requiredNamed: "Colors/screenshotsBackground")))
    }
    
    private func takeScreenshots() {
        let devices = simulators.bootedDevicesForSelectedRuntime
        screenshotsManager.saveScreenshots(for: devices, mask: screenshotMask) { _ in
            //self.screenshotsFolder.openInFinder()
            self.screenshotsManager.screenshots.refresh()
        }
    }
}

enum RowType: String, CaseIterable, Codable {
    case group = "Group"
    case device = "Device"
}

extension RowType: CustomStringConvertible, Identifiable {
    var description: String { rawValue }
    var id: Self { self }
}

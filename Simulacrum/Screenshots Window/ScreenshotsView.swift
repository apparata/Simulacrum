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

    var body: some View {
        VStack {
            HStack {
                Button("Take Screenshots", action: takeScreenshots)
                
                HStack {
                    EnumPickerSetting(title: "Mask:", selected: $screenshotMask)
                        .frame(width: 130)
                }
            }
            .padding()
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading) {
                    ScreenshotsMatrixHeaders(deviceNames: $screenshotsManager.screenshots.deviceNames)
                    ScreenshotsMatrix(screenshotsManager.screenshots)
                }
            }
            Spacer()
        }
    }
    
    private func takeScreenshots() {
        let devices = simulators.bootedDevicesForSelectedRuntime
        screenshotsManager.saveScreenshots(for: devices, mask: screenshotMask) { _ in
            //self.screenshotsFolder.openInFinder()
            self.screenshotsManager.screenshots.refresh()
        }
    }
}

struct ScreenshotsMatrixHeaders: View {
    
    @Binding<[String]> var deviceNames: [String]
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer(minLength: 200)
            ForEach(deviceNames.sorted(), id: \.self) {
                Text($0)
                    .frame(width: 200)
            }
        }
    }
}

struct ScreenshotsMatrix: View {
    
    let groups: [ScreenshotGroup]
    let screenshots: Screenshots
    
    init(_ screenshots: Screenshots) {
        groups = Array(screenshots.screenshotsByGroup.keys)
        self.screenshots = screenshots
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(groups) { group in
                HStack(alignment: .top) {
                    Text(group.name)
                        .frame(width: 200)
                    ForEach(self.screenshots.screenshotsByGroup[group]?.sorted(by: \.deviceName) ?? []) { screenshot in
                        Image(nsImage: NSImage(byReferencing: screenshot.thumbnailPath.url))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .shadow(radius: 10)
                            .onDrag { screenshot.makeDragItem() }
                    }
                }
            }
        }
    }
}

extension SystemKit.Path: Identifiable {
    
    public var id: String {
        return string
    }
}

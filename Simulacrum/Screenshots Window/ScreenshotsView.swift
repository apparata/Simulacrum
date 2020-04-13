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

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Snapshot", action: takeScreenshots)
                
                EnumPickerSetting(title: "Mask:", selected: $screenshotMask)
                    .frame(width: 130)
            }
            .padding()
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading) {
                    ScreenshotsMatrixHeaders(deviceNames: $screenshotsManager.screenshots.deviceNames,
                                             thumbnailSize: $thumbnailSize)
                    ScreenshotsMatrix(screenshotsManager.screenshots, thumbnailSize: $thumbnailSize)
                }
            }.background(Color(white: 0.97))
            HStack(alignment: .center) {
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
    @Binding var thumbnailSize: CGFloat
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer(minLength: thumbnailSize)
            ForEach(deviceNames.sorted(), id: \.self) {
                Text($0)
                    .frame(width: self.thumbnailSize)
            }
        }
    }
}

struct ScreenshotsMatrix: View {
    
    let groups: [ScreenshotGroup]
    let screenshots: Screenshots
    
    @Binding var thumbnailSize: CGFloat
    
    init(_ screenshots: Screenshots, thumbnailSize: Binding<CGFloat>) {
        groups = Array(screenshots.screenshotsByGroup.keys)
        self.screenshots = screenshots
        _thumbnailSize = thumbnailSize
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(groups) { group in
                HStack(alignment: .top) {
                    Text(group.name)
                        .frame(width: self.thumbnailSize)
                    ForEach(self.screenshots.screenshotsByGroup[group]?.sorted(by: \.deviceName) ?? []) { screenshot in
                        VStack {
                            Image(nsImage: NSImage(byReferencing: screenshot.thumbnailPath.url))
                                .resizable()
                                .scaledToFit()
                                .frame(width: self.thumbnailSize, height: self.thumbnailSize)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
                                .onDrag { screenshot.makeDragItem() }
                            Text("\(String(screenshot.width))x\(String(screenshot.height))")
                        }
                        .padding(.bottom)
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

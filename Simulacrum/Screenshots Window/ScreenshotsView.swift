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
                Button(action: takeScreenshots) {
                    Image("icon/screenshots")
                }
                
                EnumPickerSetting(title: "Mask:", selected: $screenshotMask)
                    .frame(width: 130)
            }
            .padding()
            Divider()
                .background(Color(NSColor(requiredNamed: "Colors/screenshotsDivider")))
                .padding([.leading, .trailing], 20)
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading) {
                    ScreenshotsMatrix(screenshotsManager.screenshots, thumbnailSize: $thumbnailSize)
                }
            }
            Divider()
                .background(Color(NSColor(requiredNamed: "Colors/screenshotsDivider")))
                .padding([.leading, .trailing], 20)
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
                VStack {
                    Text(group.name)
                        .font(.title)
                        .bold()
                        .padding()
                        .padding([.bottom, .top], 4)
                    HStack(alignment: .top) {
                        ForEach(self.screenshots.screenshotsByGroup[group]?.sorted(by: \.deviceName) ?? []) { screenshot in
                            VStack {
                                Text("\(screenshot.deviceName)")
                                    .bold()
                                Text("\(String(screenshot.width)) x \(String(screenshot.height))")
                                    .font(.caption)
                                    .opacity(0.3)
                                    .padding(.top, 4)
                                Image(nsImage: NSImage(byReferencing: screenshot.thumbnailPath.url))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: self.thumbnailSize, height: self.thumbnailSize)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
                                    .onDrag { screenshot.makeDragItem() }
                            }
                            .padding(.bottom)
                        }
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

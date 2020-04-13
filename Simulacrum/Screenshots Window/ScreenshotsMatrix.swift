//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import SettingsKit
import SystemKit

struct ScreenshotsMatrix: View {
    
    @EnvironmentObject var screenshotsManager: ScreenshotsManager
    
    @Binding private var screenshots: Screenshots
    
    @Binding private var thumbnailSize: CGFloat
    @Binding private var rowIsType: RowType
    
    @State private var showingRenameSheet: Bool = false
    @State private var selectedGroup: ScreenshotGroup = ScreenshotGroup(name: "Placeholder", path: Path("/tmp/Placeholder"))
        
    init(_ screenshots: Binding<Screenshots>, thumbnailSize: Binding<CGFloat>, rowIsType: Binding<RowType>) {
        _screenshots = screenshots
        _thumbnailSize = thumbnailSize
        _rowIsType = rowIsType
    }
    
    var body: some View {
        VStack {
            if rowIsType == .group {
                ForEach(screenshots.groups.sorted(by: \.name)) { group in
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            Text(group.name)
                                .font(.title)
                                .bold()
                                .padding([.bottom, .top])
                                .padding([.bottom, .top], 4)
                            MoreMenuButton {
                                Button(action: {
                                    self.screenshotsManager.removeGroup(group)
                                }) {
                                    HStack {
                                        Image("icon/delete")
                                        Text("Remove")
                                    }
                                }
                                Button(action: {
                                    self.selectedGroup = group
                                    self.showingRenameSheet = true
                                }) {
                                    HStack {
                                        Image("icon/editText")
                                        Text("Rename")
                                    }
                                }
                                Button(action: {
                                    NSWorkspace.shared.open(group.path.url)
                                }) {
                                    HStack {
                                        Image("icon/folder")
                                        Text("Show in Finder")
                                    }
                                }

                            }
                        }
                        HStack(alignment: .top) {
                            ForEach(self.screenshots.screenshotsByGroup[group]?.sorted(by: \.device.name) ?? []) { screenshot in
                                ScreenshotView(screenshot,
                                               thumbnailSize: self._thumbnailSize,
                                               title: screenshot.device.name)
                                    .padding(.bottom)
                            }
                        }
                    }
                }.sheet(isPresented: self.$showingRenameSheet) {
                    RenameGroupSheet(
                        showingSheet: self.$showingRenameSheet,
                        group: self.$selectedGroup) { group, name in
                        self.screenshotsManager.renameGroup(group, to: name)
                    }
                }
            } else {
                ForEach(screenshots.devices.sorted(by: \.name)) { device in
                    VStack {
                        Text(device.name)
                            .font(.title)
                            .bold()
                            .padding()
                            .padding([.bottom, .top], 4)
                        HStack(alignment: .top) {
                            ForEach(self.screenshots.screenshotsByDevice[device] ?? []) { screenshot in
                                ScreenshotView(screenshot,
                                               thumbnailSize: self._thumbnailSize,
                                               title: screenshot.group.name)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ScreenshotView: View {
    
    let screenshot: Screenshot
    @Binding private var thumbnailSize: CGFloat
    let title: String

    init(_ screenshot: Screenshot, thumbnailSize: Binding<CGFloat>, title: String) {
        self.screenshot = screenshot
        self._thumbnailSize = thumbnailSize
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title)
                .bold()
            Text("\(String(screenshot.width)) x \(String(screenshot.height))")
                .font(.caption)
                .opacity(0.3)
                .padding(.top, 4)
            Image(nsImage: NSImage(byReferencing: screenshot.thumbnailPath.url))
                .resizable()
                .scaledToFit()
                .frame(width: self.thumbnailSize, height: self.thumbnailSize)
                .onDrag { self.screenshot.makeDragItem() }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
        }
    }
}

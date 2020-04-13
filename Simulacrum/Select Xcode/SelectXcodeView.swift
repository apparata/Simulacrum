//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import SystemKit

struct SelectXcodeView: View {
    
    @EnvironmentObject var windowState: SelectXcodeWindowState

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Select Xcode")
                    .font(.headline)
                    .padding(.bottom, 12)
                Text("Simulacrum uses the ")
                    .font(Font.system(size: 14))
                    + Text("simctl")
                        .font(Font.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.accentColor)
                    + Text(" command from Xcode to talk to the simulator.")
                        .font(Font.system(size: 14))
                Text("Please select the Xcode app you wish to use.")
                    .font(Font.system(size: 14))
                    .padding(.top, 12)
            }
            .padding(.bottom, 8)
            Button("Select Xcode", action: selectXcode)
        }
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 20, trailing: 20))
    }
    
    private func selectXcode() {
        let openPanel = NSOpenPanel()
        openPanel.message = "Select Xcode"
        openPanel.prompt = "Select"
        openPanel.allowedFileTypes = ["app"]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false

        guard openPanel.runModal() == .OK else {
            print("No Xcode was selected.")
            return
        }
        guard let xcodeURL = openPanel.urls.first else {
            print("No Xcode URL returned.")
            return
        }
        let simctlPath = SystemKit.Path(xcodeURL.path)
            .appendingComponent("Contents/Developer/usr/bin/simctl")
        print(simctlPath)
        WindowManager.makeMainWindowController(simctlPath: simctlPath)
        windowState.window?.close()
    }
}

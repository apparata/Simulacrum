//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI

struct RenameGroupSheet: View {
    
    @EnvironmentObject private var screenshotsManager: ScreenshotsManager
    
    @Binding private var showingSheet: Bool
    
    @State private var groupName: String

    @Binding private var group: ScreenshotGroup
    
    private let okAction: (_ group: ScreenshotGroup, _ name: String) -> Void
    
    init(showingSheet: Binding<Bool>, group: Binding<ScreenshotGroup>, okAction: @escaping (_ group: ScreenshotGroup, _ name: String) -> Void) {
        self.okAction = okAction
        self._group = group
        self._showingSheet = showingSheet
        _groupName = State(initialValue: group.wrappedValue.name)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rename Group")
                .font(.headline)
            Text("Rename group to:")
                .padding(.top, 16)
            TextField("Group Name", text: $groupName)
            HStack {
                Spacer()
                MacButton(title: "Cancel", key: .escape) {
                    self.showingSheet = false
                }
                MacButton(title: "OK", key: .carriageReturn) {
                    let trimmedName = self.groupName.trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: ":", with: "_")
                        .replacingOccurrences(of: "/", with: "-")
                    if trimmedName.count > 0 {
                        self.showingSheet = false
                        self.okAction(self.group, self.groupName)
                    }
                }
            }
            .padding(.top, 14)
        }
        .padding(EdgeInsets(top: 26, leading: 26, bottom: 16, trailing: 26))
    }
}

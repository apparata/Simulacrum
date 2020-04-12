//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

struct MainSidebarView<Content>: View where Content: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack {
            content()
        }
        .frame(minWidth: 180)
        .layoutPriority(2)
    }
}

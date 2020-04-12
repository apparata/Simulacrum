//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

struct MainContentView<Content>: View where Content: View {

    let content: Content

    private let backgroundColor: Color
    
    // swiftlint:disable vertical_parameter_alignment
    @inlinable
    init(backgroundColor: Color = Color(NSColor.controlBackgroundColor),
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.backgroundColor = backgroundColor
    }
    // swiftlint:enable vertical_parameter_alignment

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.top)
            content
        }.edgesIgnoringSafeArea(.top)
    }
}

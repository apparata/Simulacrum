//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

#if os(macOS)

public struct MoreMenuButton<Content>: View where Content: View {
    
    private let contentBuilder: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        contentBuilder = content
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.accentColor)
                .frame(width: 12, height: 12)
                .inverseMask(
                    HStack(spacing: 1) {
                        Circle()
                            .frame(width: 2, height: 2)
                        Circle()
                            .frame(width: 2, height: 2)
                        Circle()
                            .frame(width: 2, height: 2)
                    }.frame(width: 12, height: 12)
                )
            MenuButton("") {
                contentBuilder()
            }
            .menuButtonStyle(BorderlessButtonMenuButtonStyle())
            .padding(.leading, 4)
            .frame(width: 20, height: 20)
        }
    }
}

#endif

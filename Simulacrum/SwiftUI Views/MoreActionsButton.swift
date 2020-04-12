//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

#if os(macOS)

public struct MoreActionsButton: View {
    
    public var body: some View {
        Button(action: { }) {
            HStack(spacing: 2.5) {
                Circle()
                    .frame(width: 3.5, height: 3.5)
                Circle()
                    .frame(width: 3.5, height: 3.5)
                Circle()
                    .frame(width: 3.5, height: 3.5)
            }.frame(width: 26, height: 26)
        }.buttonStyle(CircularButtonStyle())
    }
}

public struct CircularButtonStyle: ButtonStyle {
    
    public init() {
        //
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .foregroundColor(Color(NSColor.controlBackgroundColor))
        .background(configuration.isPressed
            ? Color.accentColor.opacity(0.4)
            : Color.accentColor)
        .cornerRadius(.infinity)
    }
}

struct MoreButtonStylePreview: PreviewProvider {
  static var previews: some View {
    Group {
        MoreActionsButton()
    }
    .previewLayout(.sizeThatFits)
    .padding(10)
  }
}

#endif

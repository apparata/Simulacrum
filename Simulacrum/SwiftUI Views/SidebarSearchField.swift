//
//  Copyright © {{CURRENT_YEAR}} {{COPYRIGHT_HOLDER}}. All rights reserved.
//

#if os(macOS)

import Cocoa
import SwiftUI

struct SidebarSearchField: NSViewRepresentable {
    
    @Binding var text: String

    init(text: Binding<String>) {
        _text = text
    }

    func makeNSView(context: Context) -> NSVisualEffectView {
        let wrapperView = NSVisualEffectView()
        let searchField = NSSearchField(string: "Search")
        searchField.delegate = context.coordinator
        searchField.isBordered = false
        searchField.isBezeled = true
        searchField.bezelStyle = .roundedBezel
        searchField.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            searchField.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            searchField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor)
        ])
        return wrapperView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        (nsView.subviews[0] as! NSSearchField).stringValue = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator { self.text = $0 }
    }

    final class Coordinator: NSObject, NSSearchFieldDelegate {
        var setter: (String) -> Void

        init(_ setter: @escaping (String) -> Void) {
            self.setter = setter
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                setter(textField.stringValue)
            }
        }
    }
}

#endif


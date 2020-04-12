//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class MainWindowState: ObservableObject {
    
    private weak var window: NSWindow?
    
    @Published var alwaysOnTop: Bool = UserDefaults.standard.bool(forKey: "MainWindowAlwaysOnTop")

    private var cancellables = Set<AnyCancellable>()
    
    init(window: NSWindow) {
        self.window = window
        $alwaysOnTop
            .sink { [weak self] in
                UserDefaults.standard.set($0, forKey: "MainWindowAlwaysOnTop")
                self?.window?.alwaysOnTop = $0
            }
            .store(in: &cancellables)
    }
}

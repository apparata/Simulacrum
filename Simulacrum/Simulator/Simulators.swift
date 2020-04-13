//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Combine
import SwiftUIToolbox
import SystemKit

class Simulators: ObservableObject {
    
    @Published var runtimeSelection: Runtime = Runtime.zero

    @Published var deviceSelection: Device?
        
    @Published var list: SimulatorList
    
    var devicesForSelectedRuntime: [Device] {
        list.devices[runtimeSelection.id] ?? []
    }

    var nonBootedDevicesForSelectedRuntime: [Device] {
        devicesForSelectedRuntime.filter {
            $0.state != "Booted"
        }
    }

    var bootedDevicesForSelectedRuntime: [Device] {
        devicesForSelectedRuntime.filter {
            $0.state == "Booted"
        }
    }
    
    private let controller: SimulatorController
    
    private var cancellable: AnyCancellable?
    
    init(simctlPath: SystemKit.Path) {
        controller = SimulatorController(simctlPath: simctlPath)
        list = SimulatorList()
    }
    
    func refresh() {
        cancellable?.cancel()
        cancellable = controller
            .listSimulators()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                dump(error)
                self?.list = SimulatorList()
            }
        }, receiveValue: { [weak self] output in
            self?.list = output
            self?.runtimeSelection = output.runtimes.first ?? Runtime.zero
        })
    }
    
    func deviceWithID(id: DeviceID, runtime: Runtime) -> Device? {
        return list.devices[runtime.id]?.first(where: {
            $0.id == id
        })
    }
    
    func bootDevice(_ device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .bootDevice(device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
            switch result {
            case .finished:
                print("Launched boot command")
                self?.refresh()
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }

    func shutDownDevice(_ device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .shutDownDevice(device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
            switch result {
            case .finished:
                print("Launched shutdown command")
                self?.refresh()
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }
    
    func applyStatusBarOverrides(_ overrides: StatusBarOverrides, on device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .applyStatusBarOverrides(overrides, on: device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("Launched apply status bar command")
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }

    func clearStatusBar(on device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .clearStatusBar(on: device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("Launched clear status bar command")
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }
    
    func applyAppearance(_ appearance: SimulatorUIAppearance, for device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .applyAppearance(appearance, for: device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("Launched apply status bar command")
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }
    
    func grantPermission(_ permission: Permission, in app: AppInfo, for device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .grantPermission(permission, in: app, for: device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("Launched grant permission command")
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }

    func revokePermission(_ permission: Permission, in app: AppInfo, for device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .revokePermission(permission, in: app, for: device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("Launched revoke permission command")
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }
    
    func resetPermission(_ permission: Permission, in app: AppInfo, for device: Device) {
        cancellable?.cancel()
        cancellable = controller
            .resetPermission(permission, in: app, for: device)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("Launched reset permission command")
            case .failure(let error):
                dump(error)
            }
        }, receiveValue: { output in
            // Do nothing
        })
    }
    
    func saveScreenshot(of device: Device, to path: Path, mask: ScreenshotMask) -> AnyPublisher<Path, Error> {
        return controller
            .saveScreenshot(of: device, to: path, mask: mask)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension Device: SearchFilterable {
    
    public func isMatch(for searchString: String) -> Bool {
        let parts = searchString.lowercased().split(separator: " ")
        let lowercasedName = name.lowercased()
        for part in parts {
            if !lowercasedName.contains(part) {
                return false
            }
        }
        return true
    }
}

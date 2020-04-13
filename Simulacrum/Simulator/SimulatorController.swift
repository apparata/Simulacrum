//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SystemKit
import Combine

class SimulatorController {
    
    enum Error: Swift.Error {
        case cannotFindXcrun
        case commandFailed(status: Int)
    }
    
    private var executionQueue = DispatchQueue(label: "SimulatorController", qos: .default)
    
    private let simctlPath: SystemKit.Path
    
    init(simctlPath: SystemKit.Path) {
        self.simctlPath = simctlPath
    }
    
    // MARK: - List Simulators
    
    func listSimulators() -> AnyPublisher<SimulatorList, Swift.Error> {
        
        let subject = PassthroughSubject<Data, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["list", "--json"],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()

                let outputString = try result.capturedOutputString()
                
                subject.send(outputString.data(using: .utf8) ?? Data())
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject
            .decode(type: SimulatorList.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - Start / Stop Device
    
    func bootDevice(_ device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["boot", device.udid],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }

    func shutDownDevice(_ device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["shutdown", device.udid],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Status Bar

    func applyStatusBarOverrides(_ overrides: StatusBarOverrides, on device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            var arguments: [String] = []
            if let time = overrides.time {
                arguments.append(contentsOf: ["--time", time])
            }
            if let operatorName = overrides.operatorName {
                arguments.append(contentsOf: ["--operatorName", operatorName])
            }
            if let networkType = overrides.networkType {
                arguments.append(contentsOf: ["--dataNetwork", networkType.argument])
            }
            if let wifiMode = overrides.wifiMode {
                arguments.append(contentsOf: ["--wifiMode", wifiMode.argument])
            }
            if let wifiBars = overrides.wifiBars {
                arguments.append(contentsOf: ["--wifiBars", "\(wifiBars)"])
            }
            if let cellularMode = overrides.cellularMode {
                arguments.append(contentsOf: ["--cellularMode", cellularMode.argument])
            }
            if let cellularBars = overrides.cellularBars {
                arguments.append(contentsOf: ["--cellularBars", "\(cellularBars)"])
            }
            if let batteryState = overrides.batteryState {
                arguments.append(contentsOf: ["--batteryState", batteryState.argument])
            }
            if let batteryLevel = overrides.batteryLevel {
                arguments.append(contentsOf: ["--batteryLevel", "\(batteryLevel)"])
            }

            do {
                
                let clearSubprocess = Subprocess(executable: simctlPath,
                                                 arguments: ["status_bar", device.udid, "clear"],
                                                 captureOutput: true)
                try clearSubprocess.spawn()
                
                try clearSubprocess.wait()
                
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["status_bar", device.udid, "override"] + arguments,
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    func clearStatusBar(on device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in

            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["status_bar", device.udid, "clear"],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Appearance
    
    func applyAppearance(_ appearance: SimulatorUIAppearance, for device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["ui", device.udid, "appearance", appearance.argument],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Permissions
    
    func grantPermission(_ permission: Permission, in app: AppInfo, for device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["ui", device.udid, "grant", permission.argument, app.bundleIdentifier],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    func revokePermission(_ permission: Permission, in app: AppInfo, for device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["ui", device.udid, "revoke", permission.argument, app.bundleIdentifier],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    func resetPermission(_ permission: Permission, in app: AppInfo, for device: Device) -> AnyPublisher<Void, Swift.Error> {
        
        let subject = PassthroughSubject<Void, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: ["ui", device.udid, "reset", permission.argument, app.bundleIdentifier],
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
    
    // MARK: Screenshots
    
    func saveScreenshot(of device: Device, to filePath: Path, mask: ScreenshotMask) -> AnyPublisher<Path, Swift.Error> {
        
        let subject = PassthroughSubject<Path, Swift.Error>()
        
        executionQueue.async { [simctlPath] in
            
            let arguments: [String] = [
                "io", device.udid,
                    "screenshot",
                        "--type", "png",
                        "--mask", mask.argument,
                        filePath.string
            ]
            
            do {
                let subprocess = Subprocess(executable: simctlPath,
                                            arguments: arguments,
                                            captureOutput: true)
                try subprocess.spawn()
                
                let result = try subprocess.wait()
                
                guard result.status == 0 else {
                    throw Error.commandFailed(status: result.status)
                }
                
                subject.send(filePath)
                subject.send(completion: .finished)
                
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }

        return subject.eraseToAnyPublisher()
    }
}

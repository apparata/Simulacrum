//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Cocoa
import SystemKit
import Combine

class ScreenshotsManager: ObservableObject {
    
    let simulators: Simulators
    
    let folder: ScreenshotsFolder
    
    @Published var screenshots: Screenshots
        
    private var idCounter: Int = 0
    
    private var nextID: Int {
        idCounter += 1
        return idCounter
    }
    
    private var takeScreenshotCancellable: AnyCancellable?
    
    private var screenshotsWillChangeCancellable: AnyCancellable?
    
    init(simulators: Simulators, folder: ScreenshotsFolder) {
        self.simulators = simulators
        self.folder = folder
        screenshots = Screenshots(folder: folder)
        screenshotsWillChangeCancellable = screenshots.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func saveScreenshots(for devices: [Device], mask: ScreenshotMask, completion: @escaping (Result<[Path], Error>) -> Void) {
        
        let subfolderPath = folder.path
            .appendingComponent("Screenshot \(nextID)")
        do {
            try subfolderPath.createDirectory(withIntermediateDirectories: true)
        } catch {
            completion(.failure(error))
            return
        }

        var publishers: [AnyPublisher<Path, Error>] = []
        for device in devices {
            let filePath = subfolderPath
                .appendingComponent(device.name)
                .appendingExtension("png")
            publishers.append(simulators.saveScreenshot(of: device, to: filePath, mask: mask))
        }
        takeScreenshotCancellable = Publishers.MergeMany(publishers)
            .collect()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { [weak self] paths in
                self?.saveThumbnails(inputImagePaths: paths, completion: completion)
            })
    }
    
    private func saveThumbnails(inputImagePaths: [Path], completion: @escaping (Result<[Path], Error>) -> Void) {
        for path in inputImagePaths {
            let folderPath = path.replacingLastComponent(with: ".thumbnails")
            do {
                if !folderPath.exists {
                    try folderPath.createDirectory(withIntermediateDirectories: true)
                }
                let thumbnailPath = folderPath.appendingComponent(path.lastComponent)
                guard let image = NSImage(contentsOf: path.url) else {
                    continue
                }
                guard let resizedImage = image.resizedToFit(in: NSSize(width: 300, height: 300)) else {
                    continue
                }
                try resizedImage.write(to: thumbnailPath.url)
            } catch {
                dump(error)
            }
        }

        completion(.success(inputImagePaths))
    }
}

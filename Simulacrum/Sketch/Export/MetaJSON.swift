//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// pageID is a UUID
func makeMetaJSON(pageID: String, artboards: [SketchExporter.Artboard]) -> String {
    let artboardsJSON = artboards.map {
        return """
        "\($0.id)": {
            "name": "\($0.name)"
        }
"""
    }
    .joined(separator: ",\n")
    
    return """
{
  "app": "com.bohemiancoding.sketch3",
  "appVersion": "64",
  "autosaved": 0,
  "build": 93537,
  "commit": "114d9f420fc7d6eb556b8b3a94b7c317265edafe",
  "compatibilityVersion": 99,
  "created": {
    "app": "com.bohemiancoding.sketch3",
    "appVersion": "64",
    "build": 93537,
    "commit": "114d9f420fc7d6eb556b8b3a94b7c317265edafe",
    "compatibilityVersion": 99,
    "variant": "NONAPPSTORE",
    "version": 125
  },
  "fonts": [
  ],
  "pagesAndArtboards": {
    "\(pageID)": {
      "artboards": {
        \(artboardsJSON)
      },
      "name": "Page 1"
    }
  },
  "saveHistory": [
    "NONAPPSTORE.93537"
  ],
  "variant": "NONAPPSTORE",
  "version": 125
}
"""
}

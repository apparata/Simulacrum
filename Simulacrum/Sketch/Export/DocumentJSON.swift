//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// pageID is a UUID
func makeDocumentJSON(pageID: String) -> String {
    let assetsID = UUID().uuidString
    let documentID = UUID().uuidString
    return """
{
  "_class": "document",
  "assets": {
    "_class": "assetCollection",
    "colorAssets": [
    ],
    "colors": [
    ],
    "do_objectID": "\(assetsID)",
    "exportPresets": [
    ],
    "gradientAssets": [
    ],
    "gradients": [
    ],
    "imageCollection": {
      "_class": "imageCollection",
      "images": {
      }
    },
    "images": [
    ]
  },
  "colorSpace": 0,
  "currentPageIndex": 0,
  "do_objectID": "\(documentID)",
  "foreignLayerStyles": [
  ],
  "foreignSymbols": [
  ],
  "foreignTextStyles": [
  ],
  "layerStyles": {
    "_class": "sharedStyleContainer",
    "objects": [
    ]
  },
  "layerSymbols": {
    "_class": "symbolContainer",
    "objects": [
    ]
  },
  "layerTextStyles": {
    "_class": "sharedTextStyleContainer",
    "objects": [
    ]
  },
  "pages": [
    {
      "_class": "MSJSONFileReference",
      "_ref": "pages/\(pageID)",
      "_ref_class": "MSImmutablePage"
    }
  ]
}
"""
}

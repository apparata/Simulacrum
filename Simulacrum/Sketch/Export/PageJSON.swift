//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// pageID is a UUID
func makePageJSON(pageID: String, artboards: [SketchExporter.Artboard]) -> String {
    let styleID = UUID().uuidString
    let artboardJSONs = artboards.map(\.json).joined(separator: ",\n\t")
    return """
{
  "_class": "page",
  "booleanOperation": -1,
  "clippingMaskMode": 0,
  "do_objectID": "\(pageID)",
  "exportOptions": {
    "_class": "exportOptions",
    "exportFormats": [
    ],
    "includedLayerIds": [
    ],
    "layerOptions": 0,
    "shouldTrim": false
  },
  "frame": {
    "_class": "rect",
    "constrainProportions": true,
    "height": 0,
    "width": 0,
    "x": 0,
    "y": 0
  },
  "groupLayout": {
    "_class": "MSImmutableFreeformGroupLayout"
  },
  "hasClickThrough": true,
  "hasClippingMask": false,
  "horizontalRulerData": {
    "_class": "rulerData",
    "base": 0,
    "guides": [
    ]
  },
  "includeInCloudUpload": true,
  "isFixedToViewport": false,
  "isFlippedHorizontal": false,
  "isFlippedVertical": false,
  "isLocked": false,
  "isVisible": true,
  "layerListExpandedType": 0,
  "layers": [
    \(artboardJSONs)
  ],
  "name": "Page 1",
  "nameIsFixed": false,
  "resizingConstraint": 63,
  "resizingType": 0,
  "rotation": 0,
  "shouldBreakMaskChain": false,
  "style": {
    "_class": "style",
    "blur": {
      "_class": "blur",
      "center": "{0.5, 0.5}",
      "isEnabled": false,
      "motionAngle": 0,
      "radius": 10,
      "saturation": 1,
      "type": 0
    },
    "borderOptions": {
      "_class": "borderOptions",
      "dashPattern": [
      ],
      "isEnabled": true,
      "lineCapStyle": 0,
      "lineJoinStyle": 0
    },
    "borders": [
    ],
    "colorControls": {
      "_class": "colorControls",
      "brightness": 0,
      "contrast": 1,
      "hue": 0,
      "isEnabled": false,
      "saturation": 1
    },
    "contextSettings": {
      "_class": "graphicsContextSettings",
      "blendMode": 0,
      "opacity": 1
    },
    "do_objectID": "\(styleID)",
    "endMarkerType": 0,
    "fills": [
    ],
    "innerShadows": [
    ],
    "miterLimit": 10,
    "shadows": [
    ],
    "startMarkerType": 0,
    "windingRule": 1
  },
  "verticalRulerData": {
    "_class": "rulerData",
    "base": 0,
    "guides": [
    ]
  }
}
"""
}

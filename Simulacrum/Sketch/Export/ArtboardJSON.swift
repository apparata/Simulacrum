//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Example imageName: "iPhone 11 Pro"
/// Example imageFileName: fee651bfb9e867dd9b56919d7480601c921900b5
/// Example artboardName: "iPhone 11 Pro"
/// artboardID is a UUID
/// pageID is a UUID
func makeArtboardJSON(x: Int, y: Int, width: Int, height: Int, imageName: String, imageFileName: String, artboardName: String, artboardID: String, pageID: String) -> String {
    let bitmapLayerID = UUID().uuidString
    return """
    {
      "_class": "artboard",
      "backgroundColor": {
        "_class": "color",
        "alpha": 1,
        "blue": 1,
        "green": 1,
        "red": 1
      },
      "booleanOperation": -1,
      "clippingMaskMode": 0,
      "do_objectID": "\(artboardID)",
      "exportOptions": {
        "_class": "exportOptions",
        "exportFormats": [
          {
            "_class": "exportFormat",
            "absoluteSize": 0,
            "fileFormat": "png",
            "name": "",
            "namingScheme": 0,
            "scale": 1,
            "visibleScaleType": 0
          }
        ],
        "includedLayerIds": [
        ],
        "layerOptions": 0,
        "shouldTrim": false
      },
      "frame": {
        "_class": "rect",
        "constrainProportions": false,
        "height": \(height),
        "width": \(width),
        "x": \(x),
        "y": \(y)
      },
      "groupLayout": {
        "_class": "MSImmutableFreeformGroupLayout"
      },
      "hasBackgroundColor": false,
      "hasClickThrough": true,
      "hasClippingMask": false,
      "horizontalRulerData": {
        "_class": "rulerData",
        "base": 0,
        "guides": [
        ]
      },
      "includeBackgroundColorInExport": true,
      "includeInCloudUpload": true,
      "isFixedToViewport": false,
      "isFlippedHorizontal": false,
      "isFlippedVertical": false,
      "isFlowHome": false,
      "isLocked": false,
      "isVisible": true,
      "layerListExpandedType": 1,
      "layers": [
        {
          "_class": "bitmap",
          "booleanOperation": -1,
          "clippingMask": "{{0, 0}, {1, 1}}",
          "clippingMaskMode": 0,
          "do_objectID": "\(bitmapLayerID)",
          "exportOptions": {
            "_class": "exportOptions",
            "exportFormats": [
            ],
            "includedLayerIds": [
            ],
            "layerOptions": 0,
            "shouldTrim": false
          },
          "fillReplacesImage": false,
          "frame": {
            "_class": "rect",
            "constrainProportions": true,
            "height": \(height),
            "width": \(width),
            "x": 0,
            "y": 0
          },
          "hasClippingMask": false,
          "image": {
            "_class": "MSJSONFileReference",
            "_ref": "images/\(imageFileName).png",
            "_ref_class": "MSImageData"
          },
          "intendedDPI": 72,
          "isFixedToViewport": false,
          "isFlippedHorizontal": false,
          "isFlippedVertical": false,
          "isLocked": false,
          "isVisible": true,
          "layerListExpandedType": 0,
          "name": "\(imageName)",
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
            "do_objectID": "7321C969-E9CC-499E-943C-112D79009B0A",
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
          }
        }
      ],
      "name": "\(artboardName)",
      "nameIsFixed": true,
      "presetDictionary": {
      },
      "resizesContent": false,
      "resizingConstraint": 63,
      "resizingType": 0,
      "rotation": 0,
      "shouldBreakMaskChain": true,
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
        "do_objectID": "9C5FC4FE-D48E-4BA5-AFB9-351824C0170F",
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

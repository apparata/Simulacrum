//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// pageID is a UUID
func makeUserJSON(pageID: String) -> String {
    return """
{
  "\(pageID)": {
    "scrollOrigin": "{0, 0}",
    "zoomValue": 0.1
  },
  "document": {
    "pageListCollapsed": 0,
    "pageListHeight": 85
  }
}
"""
}

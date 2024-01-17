//
//  Color+Extension.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import SwiftUI

extension Color {
  
  init?(hex: String) {
    guard let uiColor = UIColor(hex: hex) else { return nil }
    self.init(uiColor: uiColor)
  }
  
  func toHexString(includeAlpha: Bool = false) -> String? {
    return UIColor(self).toHexString(includeAlpha: includeAlpha)
  }
  
}

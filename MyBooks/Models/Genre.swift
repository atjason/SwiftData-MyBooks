//
//  Genre.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import SwiftUI
import SwiftData

@Model
final class Genre {
  
  var name: String = ""
  var color: String = "FF0000"
  var books: [Book]?
  
  @Transient
  var hexColor: Color {
    Color(hex: color) ?? .red
  }  
  
  init(name: String, color: String) {
    self.name = name
    self.color = color
  }
  
}

//
//  Quote.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import Foundation
import SwiftData

@Model
final class Quote {
  
  let createDate = Date.now
  var text = ""
  var page: String?
  
  var book: Book?
  
  init(text: String = "", page: String? = nil) {
    self.text = text
    self.page = page
  }
}

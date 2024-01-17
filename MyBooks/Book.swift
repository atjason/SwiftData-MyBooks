//
//  Book.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import Foundation
import SwiftData

enum SortOrder: String, Identifiable, CaseIterable {
  case title, author, status

  var id: Self { self }
}

@Model
final class Book {
  var title: String
  var author: String
  var dateAdded: Date
  var dateStarted: Date
  var dateCompleted: Date
  var summary: String
  var rating: Int?
  var status: Status
  var recommendedBy = ""
  
  var icon: String {
    switch(status) {
    case .onShelf: "checkmark.diamond.fill"
    case .inProgress: "book.fill"
    case .completed: "book.closed.fill"
    }
  }
  
  init(
    title: String,
    author: String,
    dateAdded: Date = Date.now,
    dateStarted: Date = Date.distantPast,
    dateCompleted: Date = Date.distantPast,
    summary: String = "",
    rating: Int? = nil,
    status: Status = .onShelf,
    recommendedBy: String = ""
  ) {
    self.title = title
    self.author = author
    self.dateAdded = dateAdded
    self.dateStarted = dateStarted
    self.dateCompleted = dateCompleted
    self.summary = summary
    self.rating = rating
    self.status = status
    self.recommendedBy = recommendedBy
  }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
  case onShelf, inProgress, completed
  var id: Self { self }
  var description: String {
    switch(self) {
    case .onShelf: "On Shelf"
    case .inProgress: "In Progress"
    case .completed: "Completed"
    }
  }
}

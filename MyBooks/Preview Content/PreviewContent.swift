//
//  PreviewContent.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import Foundation
import SwiftData

struct Preview {
  let container: ModelContainer

  init() {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    do {
      container = try ModelContainer(for: Book.self, configurations: config)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  func addExamples(_ examples: [Book]) {
    Task { @MainActor in
      let context = container.mainContext
      examples.forEach { example in
        context.insert(example)
      }
    }
  }
}

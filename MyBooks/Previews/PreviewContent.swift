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

  init(_ models: any PersistentModel.Type...) {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema(models)
    
    do {
      container = try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  func addExamples(_ examples: [any PersistentModel]) {
    Task { @MainActor in
      let context = container.mainContext
      examples.forEach { example in
        context.insert(example)
      }
    }
  }
}

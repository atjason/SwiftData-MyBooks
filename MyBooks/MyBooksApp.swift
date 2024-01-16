//
//  MyBooksApp.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI
import SwiftData

@main
struct MyBooksApp: App {
//  var sharedModelContainer: ModelContainer = {
//    let schema = Schema([
//      Item.self,
//    ])
//    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//    
//    do {
//      return try ModelContainer(for: schema, configurations: [modelConfiguration])
//    } catch {
//      fatalError("Could not create ModelContainer: \(error)")
//    }
//  }()
  
  init() {
    print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: Book.self)
//    .modelContainer(sharedModelContainer)
  }
}

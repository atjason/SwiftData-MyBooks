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
  
  var modelContainer: ModelContainer = {
    let schema = Schema([Book.self])
//    let config = ModelConfiguration(url: URL.documentsDirectory.appending(path: "MyBooks.store"))
    let config = ModelConfiguration("MyBooks", schema: schema) // Create "MyBooks.store"
    do {
      return try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  init() {
   print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
//    .modelContainer(for: Book.self)
    .modelContainer(modelContainer)
  }
}

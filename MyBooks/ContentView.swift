//
//  ContentView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @State private var createNewBook = false
  @State private var sortOrder = SortOrder.title
    
  var body: some View {
    NavigationStack {
      Picker("", selection: $sortOrder) {
        ForEach(SortOrder.allCases) { order in
          Text("Sort by " + order.rawValue.capitalized).tag(order)
        }
      }
      .buttonStyle(.bordered)
      BookListView(sortOrder: sortOrder)
      .listStyle(.plain)
      .navigationTitle("My Books")
      .toolbar {
        EditButton()
        Button {
          createNewBook = true
        } label: {
          Image(systemName: "plus")
            .imageScale(.large)
        }
      }
      .sheet(isPresented: $createNewBook) {
        NewBookView()
          .presentationDetents([.medium])
      }
    }
  }
}

#Preview {
  let preview = Preview(Book.self)
  preview.addExamples(Book.samples)
  return ContentView()
    .modelContainer(preview.container)
//    .modelContainer(for: Book.self)
//    .modelContainer(for: Book.self, inMemory: true)
}

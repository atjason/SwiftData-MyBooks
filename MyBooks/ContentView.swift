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
  @State private var filterString = ""
  
  var body: some View {
    NavigationStack {
      Picker("", selection: $sortOrder) {
        ForEach(SortOrder.allCases) { order in
          Text("Sort by " + order.rawValue.capitalized).tag(order)
        }
      }
      .buttonStyle(.bordered)
      BookListView(sortOrder: sortOrder, filterString: filterString)
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
    .searchable(text: $filterString, prompt: Text("Search title or author"))
  }
}

#Preview {
  let preview = Preview(Book.self)
  preview.addExamples(Book.samples)
  preview.addExamples(Genre.samples)
  return ContentView()
    .modelContainer(preview.container)
  //    .modelContainer(for: Book.self)
  //    .modelContainer(for: Book.self, inMemory: true)
}

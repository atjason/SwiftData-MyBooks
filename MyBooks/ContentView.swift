//
//  ContentView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  
  @Query(sort: \Book.title) private var books: [Book]
  
  @State private var createNewBook = false
    
  var body: some View {
    NavigationStack {
      if books.isEmpty {
        ContentUnavailableView("Enter your first book", systemImage: "book.fill")
      }
      
      List {
        ForEach(books) { book in
          NavigationLink {
            EditBookView(book: book)
          } label: {
            HStack(spacing: 20) {
              Image(systemName: book.icon)
                .font(.title)
              VStack(alignment: .leading) {
                Text(book.title)
                  .font(.title2)
                Text(book.author)
                  .foregroundStyle(.secondary)
                if let rating = book.rating {
                  HStack {
                    ForEach(1..<rating, id: \.self) { _ in
                      Image(systemName: "star")
                        .imageScale(.small)
                        .foregroundColor(.yellow)
                    }
                  }
                }
              }
            }
          }
        }
        .onDelete { indexSet in
          indexSet.forEach { index in
            modelContext.delete(books[index])
          }
        }
      }
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

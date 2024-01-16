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
  @State private var createNewBook = false
  @Query(sort: \Book.title) private var books: [Book]
    
  var body: some View {
    NavigationStack {
      if books.isEmpty {
        ContentUnavailableView("Enter your first book", systemImage: "book.fill")
      }
      
      List {
        ForEach(books) { book in
          NavigationLink {
            
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
                    ForEach(0..<rating, id: \.self) { _ in
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
      }
      .listStyle(.plain)
      .navigationTitle("My Books")
      .toolbar {
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
  ContentView()
    .modelContainer(for: Book.self)
//    .modelContainer(for: Book.self, inMemory: true)
}

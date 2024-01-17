//
//  GenresView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import SwiftUI
import SwiftData

struct GenresView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @Query(sort: \Genre.name) private var genres: [Genre]
  
  @Bindable var book: Book
  
  var body: some View {
    if genres.isEmpty {
      ContentUnavailableView {
        Label("No genres", systemImage: "bookmark.fill")
      } description: {
        Text("Create genres first.")
      } actions: {
        Button("Create Genre") {
          
        }
        .buttonStyle(.borderedProminent)
      }
    }
    
    List {
      
    }
  }
}

#Preview {
  let preview = Preview(Book.self)
  let books = Book.samples
  let genres = Genre.samples
  preview.addExamples(books)
  preview.addExamples(genres)
  
  let book = books[0]
  book.genres?.append(genres[0])
  return GenresView(book: book)
    .modelContainer(preview.container)
}

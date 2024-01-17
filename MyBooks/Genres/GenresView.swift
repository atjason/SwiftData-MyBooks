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
    NavigationStack {
      Group {
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
          ForEach(genres) { genre in
            HStack {
              Button {
                addRemove(genre)
              } label: {
                Image(systemName: book.genres?.contains(genre) == true ? "circle.fill" : "circle")
              }
              .foregroundColor(genre.hexColor)
              Text(genre.name)
            }
          }
        }
      }
      .navigationTitle(book.title)
    }
  }
  
  func addRemove(_ genre: Genre) {
    if let index = book.genres?.firstIndex(where: { $0.id == genre.id }) {
      book.genres?.remove(at: index)
    } else {
      book.genres = book.genres ?? []
      book.genres?.append(genre)
    }
  }
}

#Preview {
  let preview = Preview(Book.self)
  let books = Book.samples
  let genres = Genre.samples
  preview.addExamples(books)
  preview.addExamples(genres)
  
  let book = books[1]
//  book.genres?.append(genres[0])
  return GenresView(book: book)
    .modelContainer(preview.container)
}

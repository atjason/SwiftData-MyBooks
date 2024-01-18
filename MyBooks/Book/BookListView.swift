//
//  BookListView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import SwiftUI
import SwiftData

struct BookListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var books: [Book]
  
  init(sortOrder: SortOrder, filterString: String) {
    let sortDescriptions: [SortDescriptor<Book>] = {
      switch sortOrder {
      case .title:
        return [SortDescriptor(\Book.title)]
      case .author:
        return [SortDescriptor(\Book.author)]
      case .status:
        return [SortDescriptor(\Book.title)]
      }
    }()
    let filter = #Predicate<Book> {
      filterString.isEmpty
      || $0.title.localizedStandardContains(filterString)
      || $0.author.localizedStandardContains(filterString)
    }
    _books = Query(filter: filter, sort: sortDescriptions)
  }
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
                if let genres = book.genres {
                  ViewThatFits {
                    ScrollView(.horizontal, showsIndicators: false) {
                      GenresStackView(genres: genres)
                    }
                  }
                }
              }
            }
          }
        }
        .onDelete { indexSet in
          indexSet.reversed().forEach { index in
            modelContext.delete(books[index])
          }
        }
      }
    }
  }
}

#Preview {
  let preview = Preview(Book.self)
  preview.addExamples(Book.samples)
  return BookListView(sortOrder: .title, filterString: "")
    .modelContainer(preview.container)
  //    .modelContainer(for: Book.self)
  //    .modelContainer(for: Book.self, inMemory: true)
}

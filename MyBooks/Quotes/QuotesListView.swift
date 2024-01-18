//
//  QuotesListView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import SwiftUI

struct QuotesListView: View {
  @Environment(\.modelContext) private var modelContext
  
  let book: Book
  
  @State private var title = ""
  @State private var page = ""
  @State private var text = ""
  @State private var selectedQuote: Quote?
  
  var isEditing: Bool {
    selectedQuote != nil
  }
  
  var body: some View {
    GroupBox {
      HStack {
        LabeledContent("Page") {
          TextField("page #", text: $page)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
          Spacer()
        }
        if isEditing {
          Button("Cancel") {
            page = ""
            text = ""
            selectedQuote = nil
          }
          .buttonStyle(.borderedProminent)
        }
        Button(isEditing ? "Update" : "Create") {
          if isEditing {
            selectedQuote?.page = page.isEmpty ? nil : page
            selectedQuote?.text = text

            page = ""
            text = ""
            selectedQuote = nil

          } else {
            let quote = Quote(text: text)
            if !page.isEmpty {
              quote.page = page
            }
            book.quotes?.append(quote)

            page = ""
            text = ""
            selectedQuote = nil
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(page.isEmpty)
      }
      TextEditor(text: $text)
        .border(.secondary)
        .frame(height: 100)
    }
    .padding(.horizontal)
    
    List {
      let sortedQuotes = book.quotes?.sorted(using: KeyPathComparator(\Quote.createDate)) ?? []
//      let sortedQuotes = book.quotes?.sorted(by: { $0.createDate < $1.createDate}) ?? []
      ForEach(sortedQuotes) { quote in
        VStack(alignment: .leading) {
          Text(quote.createDate, format: .dateTime.month().day().year())
            .font(.caption)
            .foregroundStyle(.secondary)
          Text(quote.text)
          HStack() {
            Spacer()
            if let page = quote.page, !page.isEmpty {
              Text("Page: \(page)")
            }
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          selectedQuote = quote
          text = quote.text
          page = quote.page ?? ""
        }
      }
      .onDelete { indexSet in
        indexSet.reversed().forEach { index in
          withAnimation {
            if let quote = book.quotes?[index] {
              modelContext.delete(quote)
            }
          }
        }
      }
    }
    .listStyle(.plain)
    .navigationTitle("Quotes")
  }
}

#Preview {
  let preview = Preview(Book.self)
  let books = Book.samples
  preview.addExamples(books)
  return NavigationStack {
    QuotesListView(book: books[4])
      .navigationBarTitleDisplayMode(.inline)
      .modelContainer(preview.container)
  }
}

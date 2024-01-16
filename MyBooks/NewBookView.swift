//
//  NewBookView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI

struct NewBookView: View {
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  
  @State private var title = ""
  @State private var author = ""
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("Book Title", text: $title)
        TextField("Book Author", text: $author)
        Button("Create") {
          let book = Book(title: title, author: author)
          context.insert(book)
          dismiss()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .buttonStyle(.borderedProminent)
        .padding(.vertical)
        .disabled(title.isEmpty || author.isEmpty)
      }
      .navigationTitle("New Book")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  NewBookView()
}

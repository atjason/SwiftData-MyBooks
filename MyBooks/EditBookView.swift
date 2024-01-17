//
//  EditBookView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI

struct EditBookView: View {
  @Environment(\.dismiss) var dismiss
  
  @Bindable var book: Book

  @State private var status = Status.onShelf
  @State private var rating: Int?
  @State private var title = ""
  @State private var author = ""
  @State private var summary = ""
  @State private var dateAdded = Date.distantPast
  @State private var dateStarted = Date.distantPast
  @State private var dateCompleted = Date.distantPast

  var body: some View {
    HStack {
      Text("Status")
      Picker("Status", selection: $status) {
        ForEach(Status.allCases) { status in
          Text(status.description).tag(status)
        }
      }
      .buttonStyle(.bordered)
    }
    VStack(alignment: .leading) {
      GroupBox {
        LabeledContent {
          DatePicker("", selection: $dateAdded, in: ...Date.now, displayedComponents: .date)
        } label: {
          Text("Date Added")
        }
        if status == .inProgress || status == .completed {
          LabeledContent {
            DatePicker("", selection: $dateStarted, in: dateAdded...Date.now, displayedComponents: .date)
          } label: {
            Text("Date Started")
          }
        }
        if status == .completed {
          LabeledContent {
            DatePicker("", selection: $dateCompleted, in: dateStarted...Date.now, displayedComponents: .date)
          } label: {
            Text("Date Completed")
          }
        }
      }
      .foregroundStyle(.secondary)
      .onChange(of: status) { oldValue, newValue in
        if newValue == .onShelf {
          dateStarted = Date.distantPast
          dateCompleted = Date.distantPast
        } else if newValue == .inProgress {
          if dateStarted == Date.distantPast {
            dateStarted = Date()
          }
          dateCompleted = Date.distantPast
        } else if newValue == .completed {
          dateCompleted = Date()
        }
      }
      Divider()
      LabeledContent {
        RatingsView(maxRating: 5, currentRating: $rating, width: 30)
      } label: {
        Text("Rating").foregroundStyle(.secondary)
      }
      LabeledContent {
        TextField("", text: $title)
      } label: {
        Text("Title").foregroundStyle(.secondary)
      }
      LabeledContent {
        TextField("", text: $author)
      } label: {
        Text("Author").foregroundStyle(.secondary)
      }
      Divider()
      Text("Summary").foregroundStyle(.secondary)
      TextEditor(text: $summary)
        .padding(5)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 1)
        )
    }
    .padding()
    .textFieldStyle(.roundedBorder)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Save") {
          book.status = status
          book.rating = rating
          book.title = title
          book.author = author
          book.summary = summary
          book.dateAdded = dateAdded
          book.dateStarted = dateStarted
          book.dateCompleted = dateCompleted
          
          dismiss()
        }
        .buttonStyle(.borderedProminent)
        .disabled(!changed)
      }
    }
    .onAppear {
      status = book.status
      rating = book.rating
      title = book.title
      author = book.author
      summary = book.summary
      dateAdded = book.dateAdded
      dateStarted = book.dateStarted
      dateCompleted = book.dateCompleted
    }
  }

  var changed: Bool {
    status != book.status ||
    rating != book.rating ||
    title != book.title ||
    author != book.author ||
    summary != book.summary ||
    dateAdded != book.dateAdded ||
    dateStarted != book.dateStarted ||
    dateCompleted != book.dateCompleted
  }
}

#Preview {
  @State var book = Book(title: "", author: "")
  return NavigationStack {
    EditBookView(book: book)
  }
}

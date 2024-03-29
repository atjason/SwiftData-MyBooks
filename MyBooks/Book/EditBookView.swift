//
//  EditBookView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI
import PhotosUI

struct EditBookView: View {
  @Environment(\.dismiss) var dismiss
  
  @Bindable var book: Book

  @State private var status = Status.onShelf
  @State private var rating: Int?
  @State private var title = ""
  @State private var author = ""
  @State private var summary = ""
  @State private var recommendedBy = ""
  @State private var dateAdded = Date.distantPast
  @State private var dateStarted = Date.distantPast
  @State private var dateCompleted = Date.distantPast
  @State private var showGenres = false
  @State private var selectedBookCover: PhotosPickerItem?
  @State private var selectedBookCoverData: Data?

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
      HStack {
        PhotosPicker(
          selection: $selectedBookCover,
          matching: .images,
          photoLibrary: .shared()) {
            Group {
              if let selectedBookCoverData,
                 let uiImage = UIImage(data: selectedBookCoverData) {
                Image(uiImage: uiImage)
                  .resizable()
                  .scaledToFit()
              } else {
                Image(systemName: "photo")
                  .resizable()
                  .scaledToFit()
                  .tint(.primary)
              }
            }
            .frame(width: 75, height: 100)
            .overlay(alignment: .bottomTrailing) {
              if selectedBookCoverData != nil {
                Button {
                  selectedBookCover = nil
                  selectedBookCoverData = nil
                  
                } label: {
                  Image(systemName: "x.circle.fill")
                    .foregroundStyle(.red)
                }
              }
            }
          }
        VStack {
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
        }
      }
      LabeledContent {
        TextField("", text: $recommendedBy)
      } label: {
        Text("Recommended By").foregroundStyle(.secondary)
      }
      Divider()
      Text("Summary").foregroundStyle(.secondary)
      TextEditor(text: $summary)
        .padding(5)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 1)
        )
      if let genres = book.genres {
        ViewThatFits {
          ScrollView(.horizontal, showsIndicators: false) {
            GenresStackView(genres: genres)
          }
        }
      }
      HStack {
        Button("Show Genres") {
          showGenres.toggle()
        }
        .sheet(isPresented: $showGenres) {
          GenresView(book: book)
        }
        NavigationLink {
          QuotesListView(book: book)
        } label: {
          let count = book.quotes?.count ?? 0
          Label("^[\(count) quotes](inflect: true)", systemImage: "quote.opening")
        }
      }
      .buttonStyle(.bordered)
      .frame(maxWidth: .infinity, alignment: .trailing)
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
          book.recommendedBy = recommendedBy
          book.bookCover = selectedBookCoverData
          
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
      recommendedBy = book.recommendedBy
      selectedBookCoverData = book.bookCover
    }
    .task(id: selectedBookCover) {
      if let selectedBookCover {
        selectedBookCoverData = try? await selectedBookCover.loadTransferable(type: Data.self)
      }
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
    dateCompleted != book.dateCompleted ||
    recommendedBy != book.recommendedBy ||
    selectedBookCoverData != book.bookCover
  }
}

#Preview {
  @State var book = Book(title: "", author: "")
  return NavigationStack {
    EditBookView(book: book)
  }
}

//
//  EditBookView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import SwiftUI

struct EditBookView: View {
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
          DatePicker("", selection: $dateAdded, displayedComponents: .date)
        } label: {
          Text("Date Added")
        }
        if status == .inProgress || status == .completed {
          LabeledContent {
            DatePicker("", selection: $dateStarted, displayedComponents: .date)
          } label: {
            Text("Date Started")
          }
        }
        if status == .completed {
          LabeledContent {
            DatePicker("", selection: $dateCompleted, displayedComponents: .date)
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
    }
  }
}

#Preview {
  EditBookView()
}

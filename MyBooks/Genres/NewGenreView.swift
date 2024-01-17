//
//  NewGenreView.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import SwiftUI
import SwiftData

struct NewGenreView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var name = ""
  @State private var color = Color.red

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Name", text: $name)
          ColorPicker("Color", selection: $color, supportsOpacity: false)
          Button("Create") {
            let genre = Genre(name: name, color: color.toHexString()!)
            modelContext.insert(genre)
            dismiss()
          }
          .buttonStyle(.borderedProminent)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .disabled(name.isEmpty)
        }
      }
      .padding()
      .navigationTitle("New Genre")
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
  NewGenreView()
}

//
//  GenreSamples.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/17.
//

import Foundation

extension Genre {
  
  static var samples: [Genre] {
    [
      Genre(name: "Fiction", color: "00FF00"),
      Genre(name: "Non Fiction", color: "0000FF"),
      Genre(name: "Romance", color: "FF0000"),
      Genre(name: "Thriller", color: "000000")
    ]
  }
}

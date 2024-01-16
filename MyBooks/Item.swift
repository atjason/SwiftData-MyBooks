//
//  Item.swift
//  MyBooks
//
//  Created by Jason Zheng on 2024/1/16.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

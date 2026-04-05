//
//  Item.swift
//  GameBacklog
//
//  Created by Travis Burgess on 4/5/26.
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

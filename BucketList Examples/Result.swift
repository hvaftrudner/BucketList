//
//  Result.swift
//  BucketList Examples
//
//  Created by Kristoffer Eriksson on 2021-04-14.
//

import Foundation
import SwiftUI

struct Result: Codable{
    let query: Query
}

struct Query: Codable{
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    
    let pageid: Int
    let title: String
    let terms : [String: [String]]?
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    var description: String {
        terms?["description"]?.first ?? "No furher info"
    }
}

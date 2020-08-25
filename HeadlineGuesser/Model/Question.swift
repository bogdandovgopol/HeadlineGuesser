//
//  FeedItem.swift
//  HeadlineGuesser
//
//  Created by Bogdan on 25/8/20.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let correctAnswerIndex: Int
    let imageUrl: URL
    let standFirst: String
    let storyUrl: URL
    let section: String
    let headlines: [String]
}

//
//  Feed.swift
//  HeadlineGuesser
//
//  Created by Bogdan on 25/8/20.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import Foundation

struct Feed: Decodable {
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case questions = "items"
    }
}

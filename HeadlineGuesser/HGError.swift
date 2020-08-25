//
//  HGError.swift
//  HeadlineGuesser
//
//  Created by Bogdan on 25/8/20.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import Foundation

enum HGError: String, Error {
    case invalidUrl = "API URL is malformated"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidData = "The data received from the server was invalid. Please try again."
    case invalidJson = "Could not parse JSON"
}

//
//  StockModel.swift
//  ShareByte
//
//  Created by Dmitriy Chernov on 28.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import Foundation

struct StockModel {                                 //Model of our encoded data
    var companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google" : "GOOG",
        "Amazon": "AMZN",
        "Facebook" : "FB"
    ]
    
    var symbol = "-"
    let company: String
    let price: Double
    let priceChange: Double
    
    
    var priceString: String {
        return String(format: "%0.2f", price)
    }
    
    var arrow: String {
        if priceChange > 0 {
            return "green"
        } else if priceChange < 0 {
            return "red"
        } else {
            return "black"
        }
    }
    
    var priceChangeString: String {
        return String(format: "%0.2f", priceChange)
    }
}

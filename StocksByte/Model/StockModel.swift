//
//  StockModel.swift
//  ShareByte
//
//  Created by Dmitriy Chernov on 28.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import UIKit

struct StockModel {                                 //Model of our encoded data

    var symbol = "-"
    let company: String
    let price: Double
    let priceChange: Double
    
    
    var priceString: String {
        return String(format: "%0.2f$", price)
    }
    
    var arrow: (String, UIColor) {
        if priceChange > 0 {
            return ("arrow.up.right", .green)
        } else if priceChange < 0 {
            return ("arrow.down.right", .red)
        } else {
            return ("minus", .systemGray)
        }
    }
    
    var priceChangeString: String {
        return String(format: "%0.2f$", priceChange)
    }
}


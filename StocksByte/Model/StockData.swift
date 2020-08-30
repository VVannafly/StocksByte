//
//  StockData.swift
//  ShareByte
//
//  Created by Dmitriy Chernov on 28.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import Foundation

struct StockData: Codable {             //Parsing JSON Data
    let symbol: String
    let companyName: String
    let latestPrice: Double
    let change: Double
}


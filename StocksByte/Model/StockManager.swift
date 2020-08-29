//
//  StockManager.swift
//  ShareByte
//
//  Created by Dmitriy Chernov on 28.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import Foundation

protocol StockManagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockModel)
    func didFailWithError(error: Error)
}

struct StockManager {
    let stockURL = "https://cloud.iexapis.com/stable/stock/"
    let token = "/quote?&token=pk_30b9ed6f9bfa4eb4b35f47df49884270"
    
    var companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google" : "GOOG",
        "Amazon": "AMZN",
        "Facebook" : "FB"
    ]
    
    var delegate: StockManagerDelegate?
    
    func fetchStock(symbol: String) {
        let urlString = "\(stockURL)\(symbol)\(token)"      //Input a company symbol
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data,
            (response as? HTTPURLResponse)?.statusCode == 200 {
                if let stock = self.parseJSON(safeData) {
                    self.delegate?.didUpdateStocks(self, stock:stock)
                }
            }
        }
        task.resume()
}

func parseJSON(_ stockData: Data) -> StockModel? {
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(StockData.self, from: stockData)
        
        let symbol = decodedData.symbol
        let name = decodedData.companyName
        let price = decodedData.latestPrice
        let change = decodedData.change
        
        
        let stock = StockModel(symbol: symbol, company: name, price: price, priceChange: change)
        return stock
    } catch {
        delegate?.didFailWithError(error: error)
        return nil
    }
}

}

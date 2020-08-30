//
//  ImageManager.swift
//  StocksByte
//
//  Created by Dmitriy Chernov on 29.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import UIKit
protocol ImageManagerDelegate {
    func didLoadImage(_ imageManager: ImageManager, image: UIImage,num: Int)
    func didFailImageError(error: Error)
}

struct ImageManager{
    let stockURL = "https://cloud.iexapis.com/stable/stock/"
    let token = "/quote?&token=pk_30b9ed6f9bfa4eb4b35f47df49884270"
    
    var delegate: ImageManagerDelegate?
    
    func requestImage(symbol: String,group: DispatchGroup, num: Int){
        //for i in 0..<symbols.count {
            let imgURL = "\(stockURL)\(symbol)/logo\(token)"      //Input a company symbol
            performRequest(with: imgURL,group: group,num: num)
        //}
    }
    
    func performRequest(with imgURL: String,group: DispatchGroup,num: Int) {
        guard let url = URL(string: imgURL) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("url error")
                self.delegate?.didFailImageError(error: error!)
                group.leave()
                return
            }
            if let safeData = data,
                (response as? HTTPURLResponse)?.statusCode == 200 {
                if let jsonImage = (try? JSONSerialization.jsonObject(with: safeData) as? [String: Any]) {
                    self.loadImage(link: URL(string: jsonImage["url"] as! String)!, complete: {img in
                        self.delegate?.didLoadImage(self, image: img!,num: num)
                        group.leave()
                    })
                } else {
                    print("url error")
                    group.leave()
                }
            }
        }
        task.resume()
    }
    
    func loadImage(link: URL, complete: @escaping (UIImage?)->()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30                          
        configuration.timeoutIntervalForResource = 30
        
        let loadSession = URLSession(configuration: configuration)
        let task = loadSession.dataTask(with: link) {( data,response, error) in
            if error != nil {
                complete(nil)
            }
            if let safeImage = data {
                complete(UIImage(data: safeImage))
            }
        }
        task.resume()
    }
    
}

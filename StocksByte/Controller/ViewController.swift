//
//  ViewController.swift
//  StocksByte
//
//  Created by Dmitriy Chernov on 28.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeArrow: UIImageView!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var stockManager = StockManager()
    var imageManager = ImageManager()
    
    var companyList: [StockModel] = []
    var iconsList: [UIImage] = []
    
    private var needShowTable: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        companyLabel.adjustsFontSizeToFitWidth = true
        
        stockManager.delegate = self
        imageManager.delegate = self
        

        activityIndicator.hidesWhenStopped = true
    }
    
    private func requestQuoteUpdate() {
        activityIndicator.startAnimating()
        
        companyLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        symbolLabel.text = "-"
        priceChangeArrow.image = UIImage(systemName: "minus")
        priceChangeArrow.tintColor = .systemGray
        companyLogo.image = nil
        

        stockManager.fetchStock()
        
        
    }
    
    @IBAction func chooseCompany(_ sender: UIButton){
        requestQuoteUpdate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList" && companyList.count != 0 {
            print("no")
            let destinationVC = segue.destination as! TableViewController
            destinationVC.objects = companyList
            destinationVC.images = iconsList
            print(destinationVC.objects)
            destinationVC.tableView.reloadData()
        }
    }
}



//MARK: - StockManagerDelegate

extension ViewController: StockManagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stockArr: [StockModel]) {
        DispatchQueue.global().sync { [weak self] in
            self?.companyList = stockArr
            self?.iconsList = Array(repeating: UIImage(), count: stockArr.count)
            
            let group = DispatchGroup()
            
            for stock in 0..<stockArr.count {
                group.enter()
                self!.imageManager.requestImage(symbol: stockArr[stock].symbol,group: group,num: stock)
            }
            
            group.wait()
            print("now")
            
            DispatchQueue.main.sync {
                print("yes")
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                
                let table = storyboard?.instantiateViewController(identifier: "TableViewController") as! TableViewController
                table.objects = companyList
                table.images = iconsList
                table.delegate = self
                self?.show(table, sender: self)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: ImageManagerDelegate {
    func didLoadImage(_ imageManager: ImageManager, image: UIImage,num: Int) {
        DispatchQueue.main.async { [weak self] in
            //self?.companyLogo.image = image
            self?.iconsList[num] = image
            
        }
    }
    func didFailImageError(error: Error) {
        print(error)
    }
}


extension ViewController: TableViewDelegate {
    func sendCompanyInfo(info: StockModel, image: UIImage) {
        self.companyLabel.text = info.company
        self.symbolLabel.text = info.symbol
        self.priceLabel.text = info.priceString
        self.priceChangeLabel.text = info.priceChangeString
        self.companyLogo.image = image
        self.priceChangeArrow.image = UIImage(systemName: info.arrow.0)
        self.priceChangeArrow.tintColor = info.arrow.1
    }
    
    
}

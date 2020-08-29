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
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var stockManager = StockManager()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        companyLabel.adjustsFontSizeToFitWidth = true
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        stockManager.delegate = self
        
        requestQuoteUpdate()
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
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(stockManager.companies.values)[selectedRow]
        stockManager.fetchStock(symbol: selectedSymbol)
        
    }
    
}

//MARK: - UIPickerView

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stockManager.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(stockManager.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
    }
}

//MARK: - StockManagerDelegate

extension ViewController: StockManagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockModel) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.companyLabel.text = stock.company
            self?.symbolLabel.text = stock.symbol
            self?.priceLabel.text = stock.priceString
            self?.priceChangeArrow.image = UIImage(systemName: stock.arrow.0)
            self?.priceChangeArrow.tintColor = stock.arrow.1
            self?.priceChangeLabel.text = stock.priceChangeString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


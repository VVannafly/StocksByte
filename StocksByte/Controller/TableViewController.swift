//
//  TableViewController.swift
//  StocksByte
//
//  Created by Dmitriy Chernov on 29.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import UIKit

protocol TableViewDelegate {
    func sendCompanyInfo(info: StockModel, image: UIImage)
}

class TableViewController: UITableViewController {

    var objects: [StockModel] = []
    var images: [UIImage] = []
    var delegate: TableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        let image = images[indexPath.row]
        self.delegate?.sendCompanyInfo(info: object, image: image)
        self.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath) as! CompanyTableViewCell
        let object = objects[indexPath.row]
        let image = images[indexPath.row]
        cell.set(object: object, image:image)
        return cell
    }
    
    

}

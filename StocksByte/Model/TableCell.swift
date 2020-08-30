//
//  TableCell.swift
//  StocksByte
//
//  Created by Dmitriy Chernov on 29.08.2020.
//  Copyright © 2020 Dmitriy Chernov. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    

    func set(object: StockModel, image: UIImage) {
        self.nameLabel.text = object.company
        self.symbolLabel.text = object.symbol
        self.companyImage.image = image
    }
}

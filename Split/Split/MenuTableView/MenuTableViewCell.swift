//
//  MenuTableViewCell.swift
//  Split
//
//  Created by Shashank Sharma on 10/20/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(name: String, price: Float) {
        itemName.text = name
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: price as NSNumber) {
            self.itemPrice.text = "\(formattedTipAmount)"
        }
    }

}

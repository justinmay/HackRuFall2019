//
//  SelectionTableViewCell.swift
//  Split
//
//  Created by Vineeth Puli on 10/20/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        // Configure the view for the selected state
    }

}

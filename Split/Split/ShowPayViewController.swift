//
//  ShowPayViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/20/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class ShowPayViewController: UIViewController {

    @IBOutlet weak var dollarAmountLabel: UILabel!
    var tableId: Int = UserDefaults.standard.integer(forKey: "tableId")
    var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    var totalPrice: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        DataManager.dataManager.getAmountOwed(tableId: tableId) { (owedArray) in
            guard let owedArray = owedArray else { return }
            for currItem in owedArray{
                if(currItem.name == self.username) {
                    print("Curr Item price: \(currItem.owed)")
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currency
                    if let formattedTipAmount = formatter.string(from: currItem.owed as NSNumber) {
                        DispatchQueue.main.async {
                            self.dollarAmountLabel.text = "\(formattedTipAmount)"
                        }
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

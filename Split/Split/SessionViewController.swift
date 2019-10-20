//
//  SessionViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {

    @IBOutlet weak var navMenuButton: UIButton!
    var tableName : String!
    
    @IBOutlet weak var partyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Justin's Kitchen - \(tableName!)"
        navMenuButton.clipsToBounds = true
        navMenuButton.layer.cornerRadius = 15
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

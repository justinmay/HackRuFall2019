//
//  SessionViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var navMenuButton: UIButton!
    var tableName : String!
    var tableId : String!
    
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var partyTableView: UITableView!
    
    var partyPeople : PeopleInTable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Justin's Kitchen - \(tableName!)"
        self.partyTableView.delegate = self
        self.partyTableView.dataSource = self
        
        navMenuButton.clipsToBounds = true
        navMenuButton.layer.cornerRadius = 15
        
        DataManager.dataManager.getPeopleInTable(table: tableId!, completionBlock: {(people) in
            self.partyPeople = people
            self.partyTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let peeps = partyPeople {
                return peeps.people.count
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let peeps = partyPeople {
            let tableViewCell = partyTableView.dequeueReusableCell(withIdentifier: "tables", for: indexPath)
            tableViewCell.textLabel?.text = peeps.people[indexPath.row]
            return tableViewCell
        }
        return UITableViewCell()
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

//
//  MenuViewController.swift
//  Split
//
//  Created by Shashank Sharma on 10/20/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    var menu: menuItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        DataManager.dataManager.getMenuItems { (menu) in
            DispatchQueue.main.async { [weak self] in
                self?.menu = menu
                self?.menuTableView.reloadData()
            }

        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu?.items.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        let currItem = menu?.items[indexPath.row]
        tableViewCell.setUpCell(name: currItem?.name ?? "Blank", price: currItem?.price ?? 0.0)
        return tableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
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

//
//  SelectionViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/20/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit
import StitchCore
import StitchCoreRemoteMongoDBService
import StitchRemoteMongoDBService

class SelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let receipt = self.receipt {
            return receipt.items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let receipt = self.receipt else {
            return UITableViewCell()
        }

        let tableViewCell = selectionTableView.dequeueReusableCell(withIdentifier: "selectedItem", for: indexPath)
        let item = receipt.items[indexPath.row]
        tableViewCell.textLabel?.text = "\(item.name) - price: $\(item.price)"
        return tableViewCell
    }
    
    @IBOutlet weak var selectionTableView: UITableView!
    
    public var mongoClient: RemoteMongoClient!
    var tableId: Int!
    private var ledgersCollection: RemoteMongoCollection<Document>?
    private var ledgerTableWatcher: LedgerTableCollectionWatcher?

    var receipt: menuItems?
    
    func goToPayScreen(){
        print("all payments received: going to Pay screen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        
        DataManager.dataManager.getTableReceipt(tableId: self.tableId, completionBlock: { (receivedItems) in
                DispatchQueue.main.async { [weak self] in
                    self?.receipt = receivedItems
                    self?.selectionTableView.reloadData()
                }
        })
    
        do {
            self.ledgersCollection = self.mongoClient?.db("resdb").collection("ledgers")
            
            self.ledgerTableWatcher = LedgerTableCollectionWatcher()
            try self.ledgerTableWatcher?.watch(collection: self.ledgersCollection, tableId: self.tableId, funcToCall: self.goToPayScreen)
        } catch {
            print("\(error) Ledger table watcher failed")
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        
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

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
    
    
    var selectedItems : [item] = []
    
    @IBOutlet weak var selectionTableView: UITableView!
    
    public var mongoClient: RemoteMongoClient!
    var tableId: Int!
    private var ledgersCollection: RemoteMongoCollection<Document>?
    private var ledgerTableWatcher: LedgerTableCollectionWatcher?

    var receipt: menuItems?
    
    func goToPayScreen(){
        print("all payments received: going to Pay screen")
        self.performSegue(withIdentifier: "showPaymentSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        self.selectionTableView.allowsMultipleSelection = true
        self.selectionTableView.allowsMultipleSelectionDuringEditing = true
        
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
        let username = UserDefaults.standard.string(forKey: "username")
        DataManager.dataManager.pay(username: username!, tableId: tableId, menuItems: self.receipt!.items, completionBlock: {(error) in
            print("3 am very tired")
        })
        
        //add the loading indicator here that spins until goToPayScreen is called
    }
    
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
        
        let customTableViewCell = selectionTableView.dequeueReusableCell(withIdentifier: "selectedItem", for: indexPath) as? SelectionTableViewCell
        
        guard let cell = customTableViewCell else { return UITableViewCell()}
        let item = receipt.items[indexPath.row]
        // tableViewCell.textLabel?.text = "\(item.name) - price: $\(item.price)"
        cell.itemNameLabel.text = item.name
        cell.itemPriceLabel.text = "$\(item.price)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItems.append(receipt!.items[indexPath.row])
        //ToDo - add removing items
        //if tableView.cellForRow(at: indexPath)?.isSelected
        print(selectedItems)
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

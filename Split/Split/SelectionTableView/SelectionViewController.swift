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
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectionTableView: UITableView!
    
    public var mongoClient: RemoteMongoClient!
    var tableId: Int!
    private var ledgersCollection: RemoteMongoCollection<Document>?
    private var ledgerTableWatcher: LedgerTableCollectionWatcher?

    var receipt: MenuItems?
    
    func goToPayScreen(){
        print("all payments received: going to Pay screen")
        DispatchQueue.main.async {
            if(!UserDefaults.standard.bool(forKey: "selectTappedYet")) {
                self.activityIndicator.stopAnimating()
                UserDefaults.standard.set(true, forKey: "selectTappedYet")
                self.performSegue(withIdentifier: "showPaymentSegue", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        UserDefaults.standard.set(false, forKey: "selectTappedYet")
        self.selectButton.layer.cornerRadius = 20
        self.selectButton.clipsToBounds = true
        
        self.selectionTableView.layer.cornerRadius = 20
        self.selectionTableView.clipsToBounds = true
        
        
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        self.selectionTableView.allowsMultipleSelection = true
        self.selectionTableView.allowsMultipleSelectionDuringEditing = true
        self.activityIndicator.isHidden = true
        
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
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        
        
        let username = UserDefaults.standard.string(forKey: "username")
        activityIndicator.isHidden = false
        sender.isHidden = true
        print("Select tapped")
        DataManager.dataManager.pay(username: username!, tableId: tableId, menuItems: selectedItems, completionBlock: {(error) in
            print("Error in pay: \(error)")
        })
        
        activityIndicator.startAnimating()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
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
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: item.price as NSNumber) {
            cell.itemPriceLabel.text = "\(formattedTipAmount)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currItem = receipt!.items[indexPath.row]
        var newItem = true
        for(index, element) in selectedItems.enumerated() {
            if(currItem.name == element.name && currItem.price == element.price) {
                selectedItems.remove(at: index)
                newItem = false
                break;
            }
        }

        if(newItem) {
            selectedItems.append(currItem)
        }
        print("Selected items: \(selectedItems)")
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

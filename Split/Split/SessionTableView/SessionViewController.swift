//
//  SessionViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit
import StitchCore
import StitchCoreRemoteMongoDBService
import StitchRemoteMongoDBService

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var navMenuButton: UIButton!
    var tableName : String!
    var tableId : Int!
    
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var partyTableView: UITableView!
    
    var partyPeople : PeopleInTable?
    
    private lazy var stitchClient = Stitch.defaultAppClient!
    public var mongoClient: RemoteMongoClient?
    private var tablesCollection: RemoteMongoCollection<Document>?
    private var sessionsCollection: RemoteMongoCollection<Document>?
    private var peopleTableWatcher: PeopleTableCollectionWatcher?
    private var sessionTableWatcher: SessionTableCollectionWatcher?
    
    func reloadData() {
        print("From Tables Watcher")
        DataManager.dataManager.getPeopleInTable(table: "\(tableId!)", completionBlock: {(people) in
            DispatchQueue.main.async { [weak self] in
                self?.partyPeople = people
                self?.partyTableView.reloadData()
            }
        })
    }
    
    func goToSelectItemScreen(){
        DispatchQueue.main.async {
            print("From Sessions Watcher: Going To Next Screen")
            self.performSegue(withIdentifier: "selectSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stitchClient.auth.login(withCredential: AnonymousCredential.init()) { result in
            switch result {
            case .success:
                print("logged in anonymously")
            case .failure(let error):
                print("failed to log in anonymously: \(error)")
            }
            
            do {
                self.mongoClient = try self.stitchClient.serviceClient(
                    fromFactory: remoteMongoClientFactory,
                    withName: "split"
                )

            } catch {
                print("\(error) Mongo Client Failed")
            }
            
            do {
                self.tablesCollection = self.mongoClient?.db("resdb").collection("tables")

                self.peopleTableWatcher = PeopleTableCollectionWatcher()
                try self.peopleTableWatcher?.watch(collection: self.tablesCollection, funcToCall: self.reloadData)
            } catch {
                print("\(error) People table watcher failed")
            }
            
            do {
                self.sessionsCollection = self.mongoClient?.db("resdb").collection("sessions")
                
                self.sessionTableWatcher = SessionTableCollectionWatcher()
                
                try self.sessionTableWatcher?.watch(collection: self.sessionsCollection, tableId: self.tableId!,funcToCall: self.goToSelectItemScreen)
            } catch {
                print("\(error) Session table watcher failed")
            }
            self.navMenuButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
            
//            let query: Document = [:]
//            let sort: Document = [:]
//            self.tablesCollection?.insertOne(["a": 5] as Document) { doc in
//                print("hahaha wtf \(doc)")
//            }
//            self.tablesCollection?.findOne() { (doc) in
//                print("doc: \(doc)")
//            }
        }
            
        
        self.title = "Justin's Kitchen - \(tableName!)"
        self.partyTableView.delegate = self
        self.partyTableView.dataSource = self
        
        self.cardView.layer.cornerRadius = 20
        self.cardView.clipsToBounds = true
        
        navMenuButton.clipsToBounds = true
        navMenuButton.layer.cornerRadius = 15
        
        DataManager.dataManager.getPeopleInTable(table: "\(tableId!)", completionBlock: {(people) in
            DispatchQueue.main.async { [weak self] in
                self?.partyPeople = people
                self?.partyTableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let peeps = partyPeople {
            return peeps.people.count
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let peeps = partyPeople else { return UITableViewCell() }

        let tableViewCell = partyTableView.dequeueReusableCell(withIdentifier: "people", for: indexPath)
        tableViewCell.textLabel?.text = peeps.people[indexPath.row]
        tableViewCell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)!
        return tableViewCell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectSegue" {
            let destination = segue.destination as? SelectionViewController
            guard let selectionViewController = destination else {return}
            selectionViewController.mongoClient = self.mongoClient
            selectionViewController.tableId = self.tableId
        }
    }
    

}

//extension UIViewController<T>: ChangeStreamDelegate
//where T: Encodable, T: Decodable{
//
//    public typealias DocumentT = T
//
//
//    func didReceive(event: ChangeEvent<T>) {
//        // react to events
//    }
//
//}
//

//
//  BeaconViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class BeaconViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BeaconScannerDelegate {
    
    var beaconScanner: BeaconScanner!
    var listObeacons: [String] = ["Table 0"]
    var sumOfDicts: [String:Double] = [:]
    var averageTable: [String:[Double]] = [:]
    var distance: Double!
    var domainMax: Double!
    var domainMin: Double!
    var txPower = -58.0
    var sum = 0.0
    
    var beaconsSearched : [String] = []
    
    var beaconHardDict : [String : String] = [
        "http://www.vineeth.com" : "Table 1",
        "http://www.revanth.com" : "Table 2",
    ]

    
    @IBOutlet weak var beaconTableView: UITableView!
    //listOfBeacons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconScanner = BeaconScanner()
        self.beaconScanner!.delegate = self
        self.beaconScanner!.startScanning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listObeacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tables", for: indexPath)
        tableViewCell.textLabel?.text = listObeacons[indexPath.row]
        return tableViewCell
    }

    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
         NSLog("FIND: %@", beaconInfo.description)
    }
    
    func didLoseBeacon(beaconScanner: BeaconScanner, URL: NSURL, beaconInfo: BeaconInfo) {
        let beaconString = URL.absoluteString!
        let beaconActualString = beaconHardDict[beaconString]
        if let beaconActualString = beaconActualString,
           let index = listObeacons.firstIndex(of: beaconActualString) {
            listObeacons.remove(at: index)
            DispatchQueue.main.async {
                self.beaconTableView.reloadData()
            }
        }
        print("Lost " + URL.absoluteString!)
        NSLog("LOST: %@", beaconInfo.description)
    }
    
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        NSLog("UPDATE: %@", beaconInfo.description)
    }
    
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {
        let distance = getDistance(rssi: RSSI, txPower: self.txPower)
        let beaconString = URL.absoluteString!
        
        if(distance >= 3.0){
            print(beaconString)
//            let beaconActualString = beaconHardDict[beaconString]
//            if let beaconActualString = beaconActualString {
//
//                if(listObeacons.contains(beaconActualString)) {
//                    listObeacons.remove(at: listObeacons.firstIndex(of: beaconActualString)!)
//                }
//            }
            return;
        }
        
        if averageTable[beaconString] == nil {
            averageTable[beaconString] = [distance]
            sumOfDicts[beaconString] = 0.0
        } else {
            averageTable[beaconString]?.append(distance)
        }
        
        
        if distance < 0.3 {
            
            if (beaconsSearched.contains(beaconString)){
                //print("already there")
            } else {
                
                print(beaconString)
                let beaconActualString = beaconHardDict[beaconString]
                if let beaconActualString = beaconActualString {
                    listObeacons.append(beaconActualString)
                    DispatchQueue.main.async {
                        self.beaconTableView.reloadData()
                    }
                }
                
                print(beaconActualString! + " found")
                self.beaconsSearched.append(beaconString)
                
            }
        }
        print("real distance is \(distance)")
        if(averageTable[beaconString]!.count >= 5){
            sumOfDicts[beaconString]! -=  averageTable[beaconString]![averageTable[beaconString]!.count - 5]
        }
        averageTable[beaconString]!.append(distance)
        sumOfDicts[beaconString]! += distance
        print(sumOfDicts[beaconString]!)
        
        if(averageTable[beaconString]!.count>=6){
            print("URL SEEN: \(URL), RSSI: \(RSSI), Distance: \(sumOfDicts[beaconString]! / 5)")
        }
    }
    
    func getDistance(rssi: Int, txPower: Double) -> Double {
        if (rssi == 0) {
            return -1.0; // if we cannot determine accuracy, return -1.
        }
        
        let ratio = (Double(rssi))/txPower;
        if (ratio < 1.0) {
            return Double(pow(ratio,10));
        }
        else {
            let accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
            return accuracy;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Confirm Table Selection", message: "Are you sure you would like to join \(listObeacons[indexPath.row])", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            
            let username = UserDefaults.standard.string(forKey: "username")
            DataManager.dataManager.verifyUser(username: username!, table: "\(indexPath.row + 1)")
            
            self.performSegue(withIdentifier: "selectTableSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectTableSegue" {
            var selectedindex = beaconTableView.indexPathForSelectedRow?.row
            guard let index = selectedindex else { return }
            let destination = segue.destination as? SessionViewController
            guard let sessionViewController = destination else { return }
            sessionViewController.tableName = listObeacons[index]
        }
    }
}

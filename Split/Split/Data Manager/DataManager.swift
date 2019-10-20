//
//  DataManager.swift
//  Split
//
//  Created by Shashank Sharma on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import Foundation

struct item: Codable {
    var name: String
    var price: Float
    var image: String?
}

struct owed: Codable {
    var name: String
    var owed: Float
}

struct MenuItems: Codable {
    init(items: [item]) {
        self.items = items
    }
    
    var items: [item]
}

struct PeopleInTable: Codable {
    var people: [String]
}

class DataManager {
    
    static let dataManager = DataManager()
    let baseUrl: String = "https://2ca69306.ngrok.io"
    
    func debugOutput(methodName: String? = nil,data: Data?, response: URLResponse?, error: Error?) {
        print("\n\(methodName ?? "N/A")")
        guard let data = data,
            let response = response as? HTTPURLResponse,
            error == nil else {                                              // check for fundamental networking error
            print("error", error ?? "Unknown error")
            return
        }

        guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
            print("statusCode should be 2xx, but is \(response.statusCode)")
            print("response = \(response)")
            return
        }

        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString ?? "No Response")")
        print("\n")
    }
    
    // Verifying user entered a specific table
    func verifyUser(username: String, table: String) {
        
        if let url = URL(string: "\(baseUrl)/restaurants/1/tables/\(table)/verify?username=\(username)") {

            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                self.debugOutput(data: data, response: response, error: error)
            }.resume()
        }
        
    }
    
    func getPeopleInTable(table: String, completionBlock: ((PeopleInTable?) -> ())?) {
        
        guard let url = URL(string: "\(baseUrl)/restaurants/1/tables/\(table)") else { return }
        var peopleData: PeopleInTable?
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.debugOutput(methodName: "getPeopleInTable: ", data: data, response: response, error: error)
            guard let data = data else { return }
               do {
                   let decoder = JSONDecoder()
                   peopleData = try decoder.decode(PeopleInTable.self, from: data)
                    completionBlock?(peopleData)
                   
               } catch let err {
                   print("Err", err)
            }

        }.resume()
        
    }
    
    func getMenuItems(completionBlock: ((MenuItems?) -> ())?) {
        
        guard let url = URL(string: "\(baseUrl)/restaurants/1/items") else { return }
        var menu: MenuItems?
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.debugOutput(methodName: "debug getMenuItems: ", data: data, response: response, error: error)
            guard let data = data else { return }
               do {
                   let decoder = JSONDecoder()
                   menu = try decoder.decode(MenuItems.self, from: data)
                   completionBlock?(menu)

               } catch let err {
                   print("Err", err)
            }

        }.resume()
        
    }
    
    
    func getTableReceipt(tableId: Int, completionBlock: ((MenuItems?) -> ())?) {
        
        guard let url = URL(string:
            "\(baseUrl)/restaurants/1/tables/\(tableId)/receipt") else { return }
        var menu: MenuItems?
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.debugOutput(methodName: "debug getTableReceipts: ", data: data, response: response, error: error)
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                menu = try decoder.decode(MenuItems.self, from: data)
                completionBlock?(menu)
                
            } catch let err {
                print("Err", err)
            }
            
            }.resume()
    }
    
    //when a user is done selecting their items
    func pay(username: String, tableId: Int, menuItems: [item], completionBlock: ((Error?) -> ())?) {
        
        if let url = URL(string: "\(baseUrl)/restaurants/1/tables/\(tableId)/pay?username=\(username)") {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        

        do {
            let encoder = JSONEncoder()
            let newMenuItems = MenuItems(items: menuItems)
            let jsonData = try encoder.encode(newMenuItems)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
            self.debugOutput(methodName: "debug pay: ", data: data, response: response, error: error)
                if error != nil {
                    completionBlock?(error)
                } else {
                    completionBlock?(nil)
                }
                
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print("JSON Data: \(JSONString)")
                print("Menu items: \(menuItems)")
            }

            }.resume()
        } catch {
            print("error during json encoding of menuItems")
        }

        }
    }
    
    func getAmountOwed(tableId: Int, completionBlock: (([owed]?) -> ())?) {
        guard let url = URL(string:
            "\(baseUrl)/restaurants/1/tables/\(tableId)/ledger") else { return }
        var owedArr: [owed]?
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.debugOutput(methodName: "debug getAmountOwed: ", data: data, response: response, error: error)
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                owedArr = try decoder.decode([owed].self, from: data)
                completionBlock?(owedArr)
                
            } catch let err {
                print("Err", err)
            }
            
            }.resume()
    }
}



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
}

struct menuItems: Codable {
    var items: [item]
}

struct PeopleInTable: Codable {
    var people: [String]
}

class DataManager {
    
    static let dataManager = DataManager()
    let baseUrl: String = "https://b8c04993.ngrok.io"
    
    func debugOutput(data: Data?, response: URLResponse?, error: Error?) {
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
            self.debugOutput(data: data, response: response, error: error)
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
    
    func getMenuItems(completionBlock: ((menuItems?) -> ())?) {
        
        guard let url = URL(string: "\(baseUrl)/restaurants/1/items") else { return }
        var menu: menuItems?
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.debugOutput(data: data, response: response, error: error)
            guard let data = data else { return }
               do {
                   let decoder = JSONDecoder()
                   menu = try decoder.decode(menuItems.self, from: data)
                   completionBlock?(menu)

               } catch let err {
                   print("Err", err)
            }

        }.resume()
        
    }
    
    
    func getTableReceipt(tableId: Int, completionBlock: ((menuItems?) -> ())?) {
        
        guard let url = URL(string:
            "\(baseUrl)/restaurants/1/tables/\(tableId)/receipt") else { return }
        var menu: menuItems?
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.debugOutput(data: data, response: response, error: error)
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                menu = try decoder.decode(menuItems.self, from: data)
                completionBlock?(menu)
                
            } catch let err {
                print("Err", err)
            }
            
            }.resume()
    }
    
}



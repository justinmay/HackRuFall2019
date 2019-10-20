//
//  StichWatcher.swift
//  Split
//
//  Created by Shashank Sharma on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//
import StitchCore
import StitchCoreRemoteMongoDBService
import StitchRemoteMongoDBService

class MyCustomDelegate<T>: ChangeStreamDelegate
  where T: Encodable, T: Decodable
{
    typealias DocumentT = T

    var funcToCall: (() -> Void)?
    
    init(funcToCall: @escaping (() -> Void)) {
        self.funcToCall = funcToCall
    }
    
    func didReceive(streamError: Error) {
        print("error receive")
    }
    
    func didOpen() {
        print("inside open stitch")
    }
    
    func didClose() {
        print("inside close stitch")
    }
        
    func didReceive(event: ChangeEvent<T>) {
        print("Inside did receive, printing full Document:")
        print(event.fullDocument)
        guard let funcToCall = funcToCall else { return }
        funcToCall()
    }
}

class PeopleTableCollectionWatcher {
   var changeStreamSession: ChangeStreamSession<Document>?
    
    func watch(collection: RemoteMongoCollection<Document>?, funcToCall: @escaping (() -> Void)) throws {
      // Watch the collection for any changes. As long as the changeStreamSession
      // is alive, it will continue to send events to the delegate.
    print("watch initialized")
    guard let collection = collection else {
        print("collection dont exist")
        return
    }
    do {
        changeStreamSession = try collection.watch(delegate: MyCustomDelegate<Document>.init(funcToCall: funcToCall))
    } catch {
        print("Watcher error: \(error)")
    }
   }
}

class SessionTableCollectionWatcher {
    var changeStreamSession: ChangeStreamSession<Document>?
    
    func watch(collection: RemoteMongoCollection<Document>?, tableId: Int, funcToCall: @escaping (() -> Void)) throws {
        // Watch the collection for any changes. As long as the changeStreamSession
        // is alive, it will continue to send events to the delegate.
        print("session watch initialized")
        guard let collection = collection else {
            print("session collection dont exist")
            return
        }
        do {
            changeStreamSession = try collection.watch(
                matchFilter: ["fullDocument.tableId": tableId,
                              "fullDocument.restaurantId": 1] as Document,
                delegate: MyCustomDelegate<Document>.init(funcToCall: funcToCall))
        } catch {
            print("Session Watcher error: \(error)")
        }
    }
}


class LedgerTableCollectionWatcher {
    var changeStreamSession: ChangeStreamSession<Document>?
    
    func watch(collection: RemoteMongoCollection<Document>?, tableId: Int, funcToCall: @escaping (() -> Void)) throws {
        // Watch the collection for any changes. As long as the changeStreamSession
        // is alive, it will continue to send events to the delegate.
        print("Ledger watch initialized")
        guard let collection = collection else {
            print("Ledger collection dont exist")
            return
        }
        do {
            changeStreamSession = try collection.watch(
               // matchFilter: ["fullDocument.tableId": tableId,
                //              "fullDocument.restaurantId": 1] as Document,
                delegate: MyCustomDelegate<Document>.init(funcToCall: funcToCall))
        } catch {
            print("Ledger Watcher error: \(error)")
        }
    }
}

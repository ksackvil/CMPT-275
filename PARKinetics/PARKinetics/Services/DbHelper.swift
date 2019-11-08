//
//  DbHelper.swift
//  PARKinetics
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Contributors:
//      Evan huang
//          - File creation
//          - connections to database
//
import Foundation
import Firebase
import FirebaseDatabase

class DbHelper{
    static var ref: DatabaseReference = Database.database().reference()
    
    //This function creates new user with auto generated user id which will also be the return value, please save it in local storage
    static func createUser(username: String, email: String) -> String {
        var uid: String!
        uid = ref.child("users").childByAutoId().key
        ref.child("users").child(uid).setValue(["username": username, "email": email])
        return uid
    }
    
    //This function is for uploading game statistics to Firebase Realtime Database
    static func uploadGame(uid: String, type: String, balance: String, facial: String, speech: String, dexterity: String, posture: String){
        
        guard let gkey = ref.child("users/\(uid)/games").childByAutoId().key else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let game = ["type": type,
                    "time": formatter.string(from: Date()),
                    "balance": balance,
                    "facial": facial,
                    "speech": speech,
                    "dexterity": dexterity,
                    "posture": posture] as [String : Any]
        let childUpdates = ["/users/\(uid)/games/\(gkey)": game]
        ref.updateChildValues(childUpdates)
    }
    
    //This function is for retrieving history game statistics of the user, please pass in user id and a closure in which you can do view update with the retrieved result games(type is [[String : Any]])
    static func retrieveAllGames(uid: String, closure: @escaping (_ games : [[String : Any]]) -> Void) {
        var games: [[String : Any]] = []; ref.child("users").child(uid).child("games").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for(gkey, data) in value!{
                var game = data as? NSDictionary
                var temp : [String : Any] = [:]
                for(att, value) in game!{
                    temp[att as! String] = value
                }
                games.append(temp)
            }
            closure(games)
            //print(games)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

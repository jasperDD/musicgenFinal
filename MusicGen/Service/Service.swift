//
//  Service.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//
import UIKit
import Firebase

//MARK: - DatabaseRef


let DB_REF = Database.database().reference()

let REF_USERS = DB_REF.child("users")

//MARK: - Shared Service
struct Service {
    
    static let shared = Service()

    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void){
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            //print("DEBUG: \(snapshot.value)")
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
}


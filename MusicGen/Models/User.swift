//
//  User.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//



struct User {
    let fullname:String
    let email:String
    let userID: String
  
    
    var firstInitial: String { return String(fullname.prefix(1)) }
    
    init(uid: String, dictionary:[String: Any]) {
        self.userID = dictionary["userID"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
    }
}

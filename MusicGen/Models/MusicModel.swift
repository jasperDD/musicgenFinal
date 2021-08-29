//
//  MusicModel.swift
//  MusicGen
//
//  Created by Kartinin Studio on 29.06.2021.
//

import UIKit
import SwiftyJSON

struct MusicModel {
    var success = Bool()
    var midi = String()
    var userID = String()
    var add_drums = Bool()
    
    static func initForm(json : JSON) -> MusicModel {
        var musicModel = MusicModel()
        musicModel.success = json[""].boolValue
        musicModel.add_drums = json["add_drums"].boolValue
        musicModel.userID = json["user_id"].stringValue
        return musicModel
    }
   
   
    
}

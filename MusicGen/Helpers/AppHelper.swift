//
//  AppHelper.swift
//  MusicGen
//
//  Created by Kartinin Studio on 21.07.2021.
//

import UIKit

class AppHelper: NSObject {
 
    static func getLocalizeString(str:String) -> String {
        let string = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "Language"), ofType: "lproj")
        let myBundle = Bundle(path: string!)
        return (myBundle?.localizedString(forKey: str, value: "", table: nil))!
    }
    
}

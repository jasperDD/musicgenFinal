//
//  API.swift
//  MusicGen
//
//  Created by Kartinin Studio on 29.06.2021.
//

import Alamofire
import SwiftyJSON

typealias callback = ((_ json: MusicModel) -> Void)
typealias callbackPopup = ((_ title : String, _ message : String) -> Void)

class API {
    
}

extension API {
    
    

    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                print("fileUrl = \(fileUrl)")
                print("data = \(data)")
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    func playMidi(_ callback : @escaping callback) {
        let params: [String: Any] = [
        "change_instruments": [
            [
        "track_1": 2,
        "track_3": 25,
        "track_4": 39,
        "track_5":46
        ],
        // Adds chords to track in bellow array
            [
                "add_chords": 5
        ],
        [
        "add_drums": false,
        "set_bpm": 100,
        "modify_length": 160
        ]
            ]
            ]
        ///songs/{song_id}
        //http://172.104.137.82:8000/songs?gen_type=ai1
        AF.request("http://172.104.137.82/songs?gen_type=ai3&user_id=6c71f038-183b-47c5-b450-5825bf4c7963", method: .post, parameters: params).responseJSON {
            response in
           
          
            //self.readLocalJSONFile(forName: response.data as! String)
        }
        
    }
    
    
    
   
    func getUserId(_ callback : @escaping callback) {
        AF.request("http://172.104.137.82/users",
        method: .post).responseJSON {
            response in
            switch (response.result) {
            case .success(let json):
              let json2 = json as? Dictionary<String, AnyObject>
              let userID = json2?["user_id"] as? String ?? ""
            //  let message = json2?["message"] as? String ?? ""
             // callbackPopup(title, message)
              print("Success")
                print("userID = \(userID)")
                callback(MusicModel(userID: userID))
            case .failure(let error):
              print(error)
            //failure code here
            }
        }
    }
        
    func sendMusicRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, error)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    func getMusic(fileName: String) {
        let musicModel = MusicModel()
       
        
        //http://172.104.137.82:8000/songs?gen_type=ai1
        //AF.request("http://172.104.137.82/songs?gen_type=ai3&user_id=6c71f038-183b-47c5-b450-5825bf4c7963",
        //AF.request("http://172.104.137.82/users",
        AF.request("http://172.104.137.82/songs/\(fileName)",
        method: .get).responseJSON {
            response in
            print("response.data = \(response.data)")
            print("response.data = \(response.result)")
            print("response.data = \(response.response)")
            //self.readLocalJSONFile(forName: response.data as! String)
            
           
        }
        
        
        
        //a0cfdb3d-b702-4288-a058-082ec58d1a57
        //http://172.104.137.82/songs?gen_type={ai1|ai2|ai3|ai4}&userid=
    }
}

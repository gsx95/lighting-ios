//
//  Request.swift
//  leds_sb
//
//  Created by Georg Schwarz on 05.09.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import Foundation

class Request: NSObject {

    var host = ""
    
    func setHost(newHost: String) {
        host = newHost
    }
    
    func sendOff() {
        sendApiCall(path: "off", data: nil)
    }
    
    func sendOn() {
        sendApiCall(path: "on", data: nil)
    }
    
    func sendFullColor(colorHex: String) {
        let data: [String: Any] = [
            "colorHex": colorHex,
        ]
        sendApiCall(path: "set", data: data)
    }
    
    func sendApiCall(path:String, data: [String:Any]?) {
        let url = URL(string: host + "/" + path)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        if(data != nil){
            let jsonData = try? JSONSerialization.data(withJSONObject: data!)
            request.httpBody = jsonData
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }

        task.resume()
    }
    
}

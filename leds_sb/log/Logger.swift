//
//  Logger.swift
//  leds_sb
//
//  Created by Georg Schwarz on 07.11.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import Foundation

class Logger: NSObject {
    
    static var instance = Logger.init()
    
    let isoFormatter = ISO8601DateFormatter()
    
    override init() {
        isoFormatter.timeZone = TimeZone.current
    }
    
    static func log(type: String, requestId: String, message: String, body: String) {
        instance.sendLog(type: type, requestId: requestId, message: message, body: body)
    }
    
    func sendLog(type: String, requestId: String, message: String, body: String) {
        let url = URL(string: "https://log-api.eu.newrelic.com/log/v1")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.LICENSE_KEY, forHTTPHeaderField: "X-License-Key")
        request.httpMethod = "POST"
        
        let data: [String: Any] = [
            "timestamp": isoFormatter.string(from: Date()),
            "type": type,
            "sender": "app",
            "request_id": requestId,
            "message": message,
            "body": body
        ]
        
        let encodedData = try? JSONSerialization.data(withJSONObject: data)
        request.httpBody = encodedData
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        }
        task.resume()
    }
    
}

//
//  Request.swift
//  leds_sb
//
//  Created by Georg Schwarz on 05.09.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import Foundation
import UIKit

class Request: NSObject {
    
    typealias ResponseCallback = (String)  -> Void
    typealias IsOnCallback = (Bool)  -> Void

    var host = ""
    
    func setHost(newHost: String) {
        host = newHost
    }
    
    func isOn(callback: @escaping IsOnCallback) {
        sendGetRequest(path: "isOn", callback: { (response) in
            let on = response.toBool
            callback(on!)
        });
    }
    func sendOff() {
        sendApiCall(path: "off", data: nil)
    }
    
    func sendOn() {
        sendApiCall(path: "on", data: nil)
    }
    
    func getRow(cell: KallaxCell) -> Int {
        return cell.num / 4
    }
    
    func getCol(cell: KallaxCell) -> Int {
        return cell.num % 4
    }
    
    
    struct ColorGrad : Encodable, Decodable {
        var from: String
        var to: String
        
        init(fromColor: UIColor, toColor: UIColor) {
            from = fromColor.toHex()!
            to = toColor.toHex()!
        }
    }
    
    struct ShelfBox : Encodable, Decodable {
        var left: ColorGrad
        var top: ColorGrad
        var right: ColorGrad
        var bottom: ColorGrad
        
        var orig_start: String
        var orig_end: String
        var orig_mode: String
        
        init(leftGrad: ColorGrad, topGrad: ColorGrad, rightGrad: ColorGrad, bottomGrad: ColorGrad, orig_start: UIColor, orig_end: UIColor, orig_mode: String) {
            left = leftGrad
            top = topGrad
            right = rightGrad
            bottom = bottomGrad
            self.orig_start = orig_start.toHex()!
            self.orig_end = orig_end.toHex()!
            self.orig_mode = orig_mode
        }
    }
    
    struct ShelfData : Encodable, Decodable {
        var row1: [ShelfBox] = []
        var row2: [ShelfBox] = []
        var row3: [ShelfBox] = []
        var row4: [ShelfBox] = []
    }
    
    func kallaxCellToDataCell(cell: KallaxCell) -> ShelfBox {
        let topGrad = ColorGrad(fromColor: cell.top.from, toColor: cell.top.to)
        let bottomGrad = ColorGrad(fromColor: cell.bottom.from, toColor: cell.bottom.to)
        let leftGrad = ColorGrad(fromColor: cell.left.from, toColor: cell.left.to)
        let rightGrad = ColorGrad(fromColor: cell.right.from, toColor: cell.right.to)
        return ShelfBox(leftGrad: leftGrad, topGrad: topGrad, rightGrad: rightGrad, bottomGrad: bottomGrad, orig_start: cell.orig_start, orig_end: cell.orig_end, orig_mode: cell.orig_mode)
    }
    
    func sendKallaxColors(kallax: Kallax) -> Data? {
        let rows = kallax.rows
        let row1 = rows[0]
        let row2 = rows[1]
        let row3 = rows[2]
        let row4 = rows[3]
        
        var shelfData = ShelfData()
        
        for kallaxCell in row4 {
            shelfData.row1.append(kallaxCellToDataCell(cell: kallaxCell))
        }
        for kallaxCell in row3 {
            shelfData.row2.append(kallaxCellToDataCell(cell: kallaxCell))
        }
        for kallaxCell in row2 {
            shelfData.row3.append(kallaxCellToDataCell(cell: kallaxCell))
        }
        for kallaxCell in row1 {
            shelfData.row4.append(kallaxCellToDataCell(cell: kallaxCell))
        }
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(shelfData)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            sendApiCall(path: "shelf", data: nil, method: "POST", byteData: json?.data(using: .utf8))
            return json?.data(using: .utf8)
        }catch{
            print("failed json encoding")
            return nil
        }
    }
    
    func sendFullColor(colorHex: String) -> Data? {
        let data: [String: Any] = [
            "colorHex": colorHex,
        ]
        sendApiCall(path: "set", data: data)
        return try? JSONSerialization.data(withJSONObject: data)
    }
    
    func sendFullColorRaw(data: Data) {
        sendApiCall(path: "set", data: nil, method: "POST", byteData: data)
    }
    
    func sendKallaxColorRaw(data: Data) {
        sendApiCall(path: "shelf", data: nil, method: "POST", byteData: data)
    }
    
    func sendGetRequest(path: String, callback: @escaping ResponseCallback) {
        
        var request = URLRequest(url: URL(string: host + "/" + path)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                callback(dataString)
            }
            
        }
        task.resume()
    }
    
    func sendApiCall(path:String, data: [String:Any]?, method: String = "POST", byteData: Data? = nil) {
        let url = URL(string: host + "/" + path)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        
        if(data != nil){
            let encodedData = try? JSONSerialization.data(withJSONObject: data!)
            request.httpBody = encodedData
        }
        
        if(byteData != nil) {
            request.httpBody = byteData
        }

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        }
        task.resume()
    }
    
}

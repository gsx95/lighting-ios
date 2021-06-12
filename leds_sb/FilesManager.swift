//
//  FilesManager.swift
//  leds_sb
//
//  Created by Georg Schwarz on 08.10.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import Foundation

class FilesManager {
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    func save(fileNamed: String, data: Data) -> Bool {
        Logger.log(type: "favorites", requestId: "", message: "saving " + fileNamed, body: String(data: data, encoding: .utf8)!)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileNamed)
            //writing
            do {
                try data.write(to: fileURL)
            }
            catch {
                Logger.log(type: "error", requestId: "", message: "error while saving file " + fileNamed, body: "\(error)")
                return false
            }
        }
        return true
    }
    
    func deleteAll() {
        Logger.log(type: "favorites", requestId: "", message: "delete all", body: "")
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  {
            Logger.log(type: "error", requestId: "", message: "error while deleting all files", body: "\(error)")
            
        }
    }
    
    func delete(fileNamed: String) {
        Logger.log(type: "favorites", requestId: "", message: "delete favorite " + fileNamed, body: "")
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileNamed)
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch {
                Logger.log(type: "error", requestId: "", message: "error while deleting file " + fileNamed, body: "\(error)")
            }
        }
    }
    
    func read(fileNamed: String) throws -> Data? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileNamed)
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                Logger.log(type: "favorites", requestId: "", message: "reading file " + fileNamed, body: text)
                return text.data(using: .utf8)
            }
            catch {
                Logger.log(type: "error", requestId: "", message: "error while deleting file " + fileNamed, body: "\(error)")
                return nil
            }
        }
        return nil
    }
    
}

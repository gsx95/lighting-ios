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
        print("SAVING [ " + fileNamed + " ]:  " + String(data: data, encoding: .utf8)!)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileNamed)
            //writing
            do {
                try data.write(to: fileURL)
            }
            catch {
                print(error)
                return false
            }
        }
        print("saved")
        return true
    }
    
    func deleteAll() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    func delete(fileNamed: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileNamed)
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch {
                print(error)
            }
        }
    }
    
    func read(fileNamed: String) throws -> Data? {
        print("READING [ " + fileNamed + " ]")
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileNamed)
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                
                print("READING [ " + fileNamed + " ]:  " + text)
                return text.data(using: .utf8)
            }
            catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
}

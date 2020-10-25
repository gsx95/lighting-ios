//
//  favorites.swift
//  leds_sb
//
//  Created by Georg Schwarz on 27.09.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import Foundation

class Favorite : NSObject {
    
    var name: String
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func getName() -> String{
        return name
    }

}



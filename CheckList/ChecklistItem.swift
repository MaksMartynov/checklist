//
//  ChecklistItem.swift
//  CheckList
//
//  Created by ale on 24.04.2020.
//  Copyright © 2020 ale. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder: NSCoder) {
        super.init()
    }
    
    var text = ""
    var checked = false
    
    func toogleChecked() {
        checked = !checked
    }
}

//
//  ChecklistItem.swift
//  CheckList
//
//  Created by ale on 24.04.2020.
//  Copyright © 2020 ale. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject
{
    var text = ""
    var checked = false
    
    func toogleChecked() {
        checked = !checked
    }
}

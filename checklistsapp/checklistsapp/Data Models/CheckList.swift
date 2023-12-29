//
//  CheckList.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 26/12/23.
//

import UIKit

class CheckList: NSObject,Codable {
    var name=""
    var items=[checkListItem]()
    init(name: String ) {
        self.name = name
        super.init()
    }
    func unfinished()->Int{
        var count=0
        for item in items{
            if !item.checked{
                count+=1
            }
        }
        return count
    }
    
}

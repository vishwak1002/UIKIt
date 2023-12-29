//
//  Model.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 26/12/23.
//

import Foundation

class DataModel{
    var lists=[CheckList]()
    var index:Int{
        get {
            return UserDefaults.standard.integer(forKey: "CheckListIndex")
        }
        set{
             UserDefaults.standard.set(newValue, forKey: "CheckListIndex")
        }
    }
    init(){
        loadCheckListItems()
        registerDefaults()
        firstTime()
    }
    func sortChecklists(){
        lists.sort{
            list1,list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    //    MARK: - Helper methods
        func documentDirectory()->URL{
            let paths=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0];
        }
        func dataFilePath()->URL{
            documentDirectory().appendingPathComponent("Checklists.plist")
        }
    
    func registerDefaults(){
        let dictionary=["CheckListIndex":-1,"FirstTime":true] as [String:Any]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func firstTime(){
        let first=UserDefaults.standard.bool(forKey: "FirstTime")
        if(first){
            let checklist=CheckList(name:"List");
            lists.append(checklist)
            UserDefaults.standard.setValue(false, forKey: "FirstTime")
            index=0
        }
    }
    
    class func nextChecklistItemID()->Int{
        let userDefaults = UserDefaults.standard
        let itemID=userDefaults.integer(forKey: "CheckListItemID")
        userDefaults.set(itemID+1, forKey: "CheckListItemID")
        return itemID
    }
    //    MARK: - Saving and Loading methods
        func saveCheckListItems(){
            let encoder=PropertyListEncoder()
            do{
                let data=try encoder.encode(lists)
                try data.write(to: dataFilePath(),options:Data.WritingOptions.atomic)
            }
            catch{
                print("Error  :\(error.localizedDescription)");
            }
        }
    
        func loadCheckListItems(){
            let path=dataFilePath()
            if let data=try? Data(contentsOf: path){
                let decoder=PropertyListDecoder()
                do{
                    lists=try decoder.decode([CheckList].self, from: data)
                    sortChecklists()
                }
                catch{
                    print("Error  :\(error.localizedDescription)");
                }
            }
        }
    
}

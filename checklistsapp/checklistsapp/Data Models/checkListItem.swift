//
//  checkListItem.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 08/11/23.
//

import Foundation
import UserNotifications

class checkListItem:NSObject,Codable{
    var text = ""
    var checked = false
    var dueDate=Date()
    var shouldRemind=false
    var itemID = -1
    override init(){
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    deinit{
        removeNotification()
    }
    func removeNotification(){
        let center=UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
        
    }
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate>Date(){
            let content=UNMutableNotificationContent()
            content.title="Reminder"
            content.body=text
            content.sound=UNNotificationSound.default
            
            let cal=Calendar(identifier: .gregorian)
            let components=cal.dateComponents([.year,.month,.day,.hour,.minute], from: dueDate)
            
            let trigger=UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request=UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center=UNUserNotificationCenter.current()
            center.add(request)
        }
    }
}

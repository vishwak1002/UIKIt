//
//  ItemDetailViewController.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 11/11/23.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate:AnyObject{
    func ItemDetailViewControllerDidCancel( _ controller :ItemDetailViewController )
    func ItemDetailViewController(_ controller:ItemDetailViewController,didFinishAdding item:checkListItem)
    func ItemDetailViewController(_ controller:ItemDetailViewController,didFinishEditing item:checkListItem)
}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    weak var delegate:ItemDetailViewControllerDelegate?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textFied: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    
    @IBOutlet weak var shouldRemind: UISwitch!
    
    var itemToEdit:checkListItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item=itemToEdit{
            title="Edit Item"
            textFied.text=item.text
            doneButton.isEnabled=true
            shouldRemind.isOn=item.shouldRemind
            dueDate.date=item.dueDate
        }
        navigationItem.largeTitleDisplayMode = .never
        print("View did load")
       
    }
    @IBAction func cancel(){
        delegate?.ItemDetailViewControllerDidCancel(self)
//        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(){
        if let itemToEdit = itemToEdit{
            itemToEdit.text=textFied.text!
            itemToEdit.shouldRemind=shouldRemind.isOn
            itemToEdit.dueDate=dueDate.date
            itemToEdit.scheduleNotification()
            delegate?.ItemDetailViewController(self, didFinishEditing: itemToEdit)
        }
        else{
            let item=checkListItem()
            item.text=textFied.text!
            item.shouldRemind=shouldRemind.isOn
            item.dueDate=dueDate.date
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }

    }
    @IBAction func shouldRemindToggled(_ switchControl:UISwitch){
        textFied.resignFirstResponder()
        if switchControl.isOn{
            let center=UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.sound]){
                _,_ in
//                if granted{
//                    print("User has given permission")
//                   
//                }
//                else{
//                    print("Permission Denied")
//                }
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFied.becomeFirstResponder()
        print("View will appear")
    }

    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil;
    }
    
    
//    MARK: - TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange=Range(range,in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty

        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled=false
        return true;
    }
    
   

}

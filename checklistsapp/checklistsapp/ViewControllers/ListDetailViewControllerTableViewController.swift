//
//  ListDetailViewControllerTableViewController.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 26/12/23.
//

import UIKit


protocol ListDetailViewControllerDelegate:AnyObject{
    func ListDetailViewControllerDidCancel( _ controller :ListDetailViewController )
    func ListDetailViewController(_ controller:ListDetailViewController,didFinishAdding checkList:CheckList)
    func ListDetailViewController(_ controller:ListDetailViewController,didFinishEditing checkList:CheckList)
}

class ListDetailViewController: UITableViewController ,UITextFieldDelegate{
    
    weak var delegate:ListDetailViewControllerDelegate?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var checkListToEdit:CheckList?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item=checkListToEdit{
            print("It came here")
            title="Edit CheckList"
            textField.text=item.name
            doneButton.isEnabled=true
        }
        navigationItem.largeTitleDisplayMode = .never
        print("View did load")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        print("View will appear")
    }
    @IBAction func cancel(){
        delegate?.ListDetailViewControllerDidCancel(self)
//        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(){
        if let itemToEdit = checkListToEdit{
            itemToEdit.name=textField.text!
            delegate?.ListDetailViewController(self, didFinishEditing: itemToEdit)
        }
        else{
            let item=CheckList(name:textField.text!)
            delegate?.ListDetailViewController(self, didFinishAdding: item)
        }

    }
//    MARK: - Table View Delegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil;
    }
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

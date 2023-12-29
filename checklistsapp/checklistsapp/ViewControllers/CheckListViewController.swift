//
//  ViewController.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 08/11/23.
//

import UIKit

class CheckListViewController: UITableViewController,ItemDetailViewControllerDelegate {
    var checkList:CheckList!
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: checkListItem) {
        if let index=checkList.items.firstIndex(of:item){
            print(checkList.items[index].text)
            let indexPath=IndexPath(row:index,section:0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
                
            }
            
        }
        navigationController?.popViewController(animated: true)
//        saveCheckListItems()
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: checkListItem) {
        let newrows = checkList.items.count
        checkList.items.append(item)
        let indexPath=IndexPath(row: newrows,section:0)
        let indexPaths=[indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
//        saveCheckListItems()
    }
    
//    var items=[checkListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title=checkList.name
        navigationItem.largeTitleDisplayMode = .never
        // Load items.
//       loadCheckListItems()
        
    }
//    MARK: - Helper methods
//    func documentDirectory()->URL{
//        let paths=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0];
//    }
//    func dataFilePath()->URL{
//        documentDirectory().appendingPathExtension("Checklists.plist")
//    }
//    
    func configureCheckMark(for cell :UITableViewCell , with item :checkListItem ){
//        let item=items[indexPath.row]
        let label = cell.viewWithTag(201) as! UILabel
        if item.checked{
            label.text="✔";
        }
        else{
            label.text="";
        }
       
    }
    func configureText(for cell :UITableViewCell , with item :checkListItem ){
        let label = cell.viewWithTag(200) as! UILabel
        label.text=item.text
    }
//  MARK: - SEGUE for other view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit=checkList.items[indexPath.row]
            }
        }
    }
//    MARK: - Datasource
////    TODO:
    ////FIXME:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "checkListItem", for: indexPath)
        let item=checkList.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckMark(for: cell, with: item)
        return cell;
    }
    
//    MARK: - Data Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item=checkList.items[indexPath.row]
            item.checked.toggle()
            configureCheckMark(for: cell,with:item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
//        saveCheckListItems()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkList.items.remove(at: indexPath.row)
        let indexPaths=[indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
//        saveCheckListItems()
    }
    
    

}


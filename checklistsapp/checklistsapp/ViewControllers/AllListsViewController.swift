//
//  TableViewController.swift
//  checklistsapp
//
//  Created by Vishwasai Karnati on 26/12/23.
//

import UIKit

class AllListsViewController: UITableViewController,ListDetailViewControllerDelegate,UINavigationControllerDelegate {
    
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding checkList: CheckList) {
//        let newrows=dataModel.lists.count
        dataModel.lists.append(checkList)
        dataModel.sortChecklists()
        tableView.reloadData()
        
//        let indexPath=IndexPath(row: newrows,section:0)
//        let indexPaths=[indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing checkList: CheckList) {
//        if let index=dataModel.lists.firstIndex(of:checkList){
////            print(dataModel.lists[index].text)
//            let indexPath=IndexPath(row:index,section:0)
//            if let cell = tableView.cellForRow(at: indexPath){
//                cell.textLabel!.text=checkList.name
//                
//            }
//            
//        }
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    let cellIdentifier = "Checklistcell";
//    var dataModel.lists=[CheckList]()
    var dataModel:DataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles=true
//        loadCheckListItems();
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier);
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate=self;
        let index=dataModel.index
        if(index >= 0 && index<dataModel.lists.count){
            let checklist=dataModel.lists[index];
            performSegue(withIdentifier: "ShowCheckList", sender:checklist )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
//    MARK: - TABLEVIEW DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell;
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            cell=tmp;
        }
        else{
            cell=UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
//        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist=dataModel.lists[indexPath.row];
        cell.textLabel!.text = checklist.name;
        if(checklist.items.count == 0){
            cell.detailTextLabel!.text = "(No items)";
        }
        else{
            cell.detailTextLabel!.text = checklist.unfinished() == 0 ? "All Done" :  "\(checklist.unfinished()) remaining"
        }
        
        cell.accessoryType = .detailDisclosureButton
       
        return cell;
    }
//    MARK: - Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.index=indexPath.row
        let checklist=dataModel.lists[indexPath.row];
        performSegue(withIdentifier: "ShowCheckList", sender:checklist )
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths=[indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate=self
        let checklist=dataModel.lists[indexPath.row];
        controller.checkListToEdit=checklist;
        navigationController?.pushViewController(controller, animated: true)
    }
//    MARK: -Navigation Controller Delegates
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.index =  -1
        }
    }
//    MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCheckList"{
            let controller = segue.destination as! CheckListViewController
            controller.checkList = sender as? CheckList
        }else if segue.identifier == "AddCheckList"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
//        else if segue.identifier == "EditCheckList"{
//            let controller = segue.destination as! ListDetailViewController
//            controller.delegate = self
//            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
////                controller.checkListToEdit=dataModel.lists[indexPath.row]
//            }
//        }
    }
    
    
}

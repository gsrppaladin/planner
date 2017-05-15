//
//  ToDoTasksTVC.swift
//  planner
//
//  Created by Sam Greenhill on 5/9/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import CoreData

class ToDoTasksTVC: UITableViewController, NSFetchedResultsControllerDelegate {
//the NSFetchedResultsControllerDelegate uses methods in this protocol to notify its delegate that the controller's fetch results have been changed due to an add, remove, move, or update operations. Below are the other delegate methods.
    /*
    controllerWillChangeContent - we can call tableView.beginUpdates()
    controllerDidChangeContent - we can call tableView.endUpdates()
    controllerDidChange sectionInfo atSectionIndex for type - update table sections info
    Controller didChange Object - handle tableView for .insert, .delete, .update, .move updates.
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return (fetchedResultsController.sections?.count)!
    }

    //before implementing numberofrows, now we need to tell section title to tableview. 
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = (fetchedResultsController.sections?[section])! as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = (fetchedResultsController.sections?[section])! as NSFetchedResultsSectionInfo

        return sectionInfo.numberOfObjects
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        
        
        
        // Configure the cell...

        configureCell(cell: taskCell, atIndexPath: indexPath)
        
        
        
        
        return taskCell
    }

    func configureCell(cell: UITableViewCell, atIndexPath: IndexPath) {
         let object = fetchedResultsController.object(at: atIndexPath) as! NSManagedObject
                                                    //if you dont set it to above type, then it will be of type any. 
        
        cell.textLabel?.text = object.value(forKey: "taskDescription")! as? String
        
        if object.value(forKey: "taskStatus") as! Bool == true {
            cell.textLabel?.textColor = UIColor.green
        } else if object.value(forKey: "featured") as! Bool == true {
            cell.textLabel?.textColor = UIColor.red
        }
        
        
        
        
    }
    
    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let objectToDelete = fetchedResultsController.object(at: indexPath) as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
                try context.save()
            } catch {
                print("Error in deleting records from fetched results controller")
            }
            
        }
            
    }
   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            let destination = segue.destination as! AddEditVC
            let indexPath = tableView.indexPathForSelectedRow
            destination.passedObject = fetchedResultsController.object(at: indexPath!) as! NSManagedObject
        }
    }
 

    
    
    //Mark:= NSFetchedResultsController Implementation
    
    
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        fetchRequest.fetchBatchSize = 20
        //shows about 20 batches, and as you scoll, you will see more baches of 20. 
        fetchRequest.resultType = .managedObjectResultType
        
        let sortDescriptor = NSSortDescriptor(key: "taskDate", ascending: false)
        //new tasks are displayed on the top. 
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //on what context it will be preformed. optionally, can pass if we want any sections. if we want any cached files. 
        
        _fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "taskDateString", cacheName: nil)
        //now can preform fetchrequest, so records are returned from coredata and stored in fetch results controller. 
        
        
        _fetchedResultsController?.delegate = self
        //
        
        
        
        do {
            
            try _fetchedResultsController?.performFetch()
            
        } catch {
            print("Issue in fetching records with the help of NSFetchedResultsController")
            
        }
        return _fetchedResultsController!
        
    }
    
//Mark: FRC - Delegate Methods
    
    
    //about to change content
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let sectionIndexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            self.tableView.insertSections(sectionIndexSet, with: .fade)
        
        case .delete:
            self.tableView.deleteSections(sectionIndexSet, with: .fade)
        default:
            return
            
        }
        
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(cell: tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            return
        }
    }
    
    
    
    
    
    
    
}

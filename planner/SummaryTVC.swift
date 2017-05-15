//
//  SummaryTVC.swift
//  planner
//
//  Created by Sam Greenhill on 5/14/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import CoreData

class SummaryTVC: UITableViewController {

    var tableData = [(String, Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        populateTableData()
        tableView.reloadData()
    }
   
    
    func populateTableData() {
        var totalTasks = 0
        var totalCompleteTasks = 0
        var todaysTask = 0
        var todaysCompleteTasks = 0
        
        //count total tasks
        
        totalTasks = fetchData(entityName: "ToDo", predicate: nil, sortDescriptor: nil).count
        
        
        //count total complete tasks
            //will need a predicate. to see if the status is equal to true. 
        let totalCompletePredicate = NSPredicate(format: "taskStatus = %@", true as CVarArg)
        totalCompleteTasks = fetchData(entityName: "ToDo", predicate: totalCompletePredicate, sortDescriptor: nil).count
        
        //Count today's total tasks
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        let todayString = formatter.string(from: today)
        
        
        let todaysTotalTasksPredicate = NSPredicate(format: "taskDateString = %@", todayString)
        todaysTask = fetchData(entityName: "ToDo", predicate: todaysTotalTasksPredicate, sortDescriptor: nil).count
        
        //Count today's complete tasks
        let todaysCompleteTasksPredicate = NSPredicate(format: "taskStatus = %@ And taskDateString = %@", true as CVarArg, todayString)
        totalCompleteTasks = fetchData(entityName: "ToDo", predicate: todaysCompleteTasksPredicate, sortDescriptor: nil).count
        
        tableData.removeAll()
        tableData.append(("Today's Task", todaysTask))
        tableData.append(("Today's Complete Tasks", todaysCompleteTasks))
        tableData.append(("Total Tasks", totalTasks))
        tableData.append(("Total Complete Tasks", totalCompleteTasks))
        
        print(tableData)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

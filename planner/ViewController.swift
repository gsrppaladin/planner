//
//  ViewController.swift
//  planner
//
//  Created by Sam Greenhill on 5/7/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var featuredTableView: UITableView!
    
    
    var featuredTasksData = [NSManagedObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featuredTableView.delegate = self
        featuredTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let predicate = NSPredicate(format: "featured = %@ AND taskStatus = %@", true as CVarArg, false as CVarArg)
        
        featuredTasksData = fetchData(entityName: "ToDo", predicate: predicate, sortDescriptor: nil)
        featuredTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuredTasksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //configure cell
        
        
        cell.textLabel?.text = featuredTasksData[indexPath.row].value(forKey: "taskDescription") as! String
        cell.textLabel?.textColor = UIColor.red
        
        cell.detailTextLabel?.text = featuredTasksData[indexPath.row].value(forKey: "taskDateString") as! String
        
        return cell
        
        
        
        
    }
    
    
    
    
    
    
    
    

}


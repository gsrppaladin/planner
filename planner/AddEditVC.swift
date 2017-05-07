//
//  AddEditVC.swift
//  planner
//
//  Created by Sam Greenhill on 5/7/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import CoreData

class AddEditVC: UIViewController {

    
    @IBOutlet var toDoTxtField: UITextField!
    
    @IBOutlet var toDoSwitch: UISwitch!
    
    @IBOutlet var featureSwitch: UISwitch!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if toDoTxtField.text == "" {
            print("Please provide to do item")
            return
        }
        //save new record. 
        
        let todo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        
        
        todo.setValue(toDoTxtField, forKey: "taskDescription")
        let date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        let dateString = formatter.string(from: date)
        
        
        todo.setValue(date, forKey: "taskDate")
        todo.setValue(dateString, forKey: "taskDateString")
        todo.setValue(toDoSwitch.isOn, forKey: "taskStatus")
        todo.setValue(featureSwitch.isOn, forKey: "featured")
        
        
        do {
            try context.save()
            print("Record saved successfully")
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error in saving record")
        }
        
        
        
        self.view.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    
   }

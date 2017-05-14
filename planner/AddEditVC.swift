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
    
    var passedObject: NSManagedObject?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let object = passedObject {
            toDoTxtField.text = object.value(forKey: "taskDescription") as! String
            datePicker.date = object.value(forKey: "taskDate") as! Date
            toDoSwitch.isOn = object.value(forKey: "taskStatus") as! Bool
            featureSwitch.isOn = object.value(forKey: "featured") as! Bool
        }
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if toDoTxtField.text == "" {
            print("Please provide to do item")
            return
        }
        
        if let object = passedObject {
            saveObject(object: object, savedRecord: false)
            return
        }
        //save new record.
        
        let todo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        saveObject(object: todo, savedRecord: true)
        /*
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
        
        
        */
        self.view.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    func saveObject(object: NSManagedObject, savedRecord: Bool) {
        
        
        
        
        object.setValue(toDoTxtField.text, forKey: "taskDescription")
        
        let date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        let dateString = formatter.string(from: date)
        
        
        object.setValue(date, forKey: "taskDate")
        object.setValue(dateString, forKey: "taskDateString")
        object.setValue(toDoSwitch.isOn, forKey: "taskStatus")
        object.setValue(featureSwitch.isOn, forKey: "featured")
        
        
        do {
            try context.save()
            if savedRecord {
                print("Record saved successfully")
            } else {
                print("Record Updated Successfully")
            }
            self.navigationController?.popViewController(animated: true)
        } catch {
            if savedRecord {
                print("Error in saving record")
            } else {
                print("Error in updating record")
            }
        }
        
        

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   }

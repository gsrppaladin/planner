//
//  helperClass.swift
//  planner
//
//  Created by Sam Greenhill on 5/7/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import Foundation
import CoreData
import UIKit


var _appDel: AppDelegate?

var appDel: AppDelegate {
    //whenever this appdelegate is called it will set with help of what is in here.
    
    if _appDel == nil {
        _appDel = UIApplication.shared.delegate as! AppDelegate
    }
    return _appDel!
}

var _context: NSManagedObjectContext?

var context: NSManagedObjectContext {
    
    if _context == nil {
        _context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        _context = appDel.persistentContainer.viewContext
    }
    return _context!
}



func fetchData(entityName: String, predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) -> [NSManagedObject] {
    
    var returningArray = [NSManagedObject]()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    request.resultType = .managedObjectResultType
    
    if let pred = predicate {
        request.predicate = pred
        //this block will only work when a predicate is being passed and a nil value is not being passed. which is why it is an optional.
    }
    
    if let sort = sortDescriptor {
        request.sortDescriptors = [sort]
    }
    
    do {
        let results = try context.fetch(request)
        returningArray = results as! [NSManagedObject]
        
        
    } catch {
        print("Error in fetching records from \(entityName)")
    }
    return returningArray
}


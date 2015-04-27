//
//  ViewController.swift
//  blow
//
//  Created by Tainara Specht on 4/8/15.
//  Copyright (c) 2015 Tainara Specht. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var items = [NSManagedObject]()
    
    
    @IBAction func addItem(sender: AnyObject) {
            
            var alert = UIAlertController(title: "New Item",
                message: "Add a new item",
                preferredStyle: .Alert)
        
            let saveAction = UIAlertAction(title: "Save",
                style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as! UITextField
                self.saveItem(textField.text)
                self.tableView.reloadData()
        }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                style: .Default) { (action: UIAlertAction!) -> Void in
            }
            
            alert.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
            }
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"My First Bucket List\""
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"List")
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
            error: &error) as! [NSManagedObject]?
        
        if let results = fetchedResults {
            items = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
 
    func loadData(){

            let queueTableView = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(queueTableView, 0)) {
          
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName:"List")
            var error: NSError?
            let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
                error: &error) as! [NSManagedObject]?
            
            dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            
            }
        }
        
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return items.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as! UITableViewCell
            
            let list = items[indexPath.row]
            cell.textLabel!.text = list.valueForKey("item") as! String?
            
            return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let obj = items[indexPath.row]
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            managedContext.deleteObject(obj)
            
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            var error: NSError?
            managedContext.save(&error)
            
        }
    }
    
    func saveItem(item: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName ("List",
            inManagedObjectContext:
            managedContext)
        
        let list = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        list.setValue(item, forKey: "item")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        items.append(list)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


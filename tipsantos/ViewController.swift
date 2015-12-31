//
//  ViewController.swift
//  tipsantos
//
//  Created by Santos Solorzano on 12/28/15.
//  Copyright © 2015 santosjs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewBill: UIButton!
    
    var arrayOfStrings: [String] = ["Frugality is good", "Dinner for 2?", "Broken ❤"]
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Swiftip"
        self.view.backgroundColor = UIColor.lightGrayColor()
        tipLabel.text = "0.00"
        totalLabel.text = "0.00"
        
        addNewBill.setTitle("\u{2713}", forState: .Normal)
        addNewBill.layer.borderWidth = 1
        addNewBill.layer.cornerRadius = 0.5 * addNewBill.bounds.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentages = [0.18, 0.20, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        tipLabel.text = String(format:"%.2f", tip)
        totalLabel.text = String(format:"%.2f", total)
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        // cast Int to String
        print(String(month) + "/" + String(day) + "/" + String(year))
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("userNameKey")
        {
            print(name)
        }
    }
    
    // button press
    @IBAction func addBillToTableView(sender: AnyObject) {
        print("Button pressed")
        swiftBlogs.append(totalLabel.text!)
        tableView.reloadData()
        billField.text = ""
    }
    
    @IBAction func onTap(sender: AnyObject) {
        // dismiss the keyboard
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        // This is a good place to retrieve the default tip percentage from NSUserDefaults
        // and use it to update the tip amount
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    let textCellIdentifier = "TextCell"
    
    var swiftBlogs = ["Frugality is the \u{1F511} to success."]
    var deleteBillAmountIndexPath: NSIndexPath? = nil
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(swiftBlogs[row])
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteBillAmountIndexPath = indexPath
            let billToDelete = swiftBlogs[indexPath.row]
            confirmDelete(billToDelete)
        }
    }
    
    func confirmDelete(bill: String) {
        let alert = UIAlertController(title: "Delete Bill", message: "Are you sure you want to permanently delete \(bill)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteBill)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteBill)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteBill(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteBillAmountIndexPath {
            tableView.beginUpdates()
            
            swiftBlogs.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteBillAmountIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteBill(alertAction: UIAlertAction!) {
        deleteBillAmountIndexPath = nil
    }
    
    

}

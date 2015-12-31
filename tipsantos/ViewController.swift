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
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    var arrayOfStrings: [String] = ["Frugality is good", "Dinner for 2?", "Broken ❤"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        setLabelAttributes()
        setButtonAttributes()
        
    }
    
    func setLabelAttributes() {
        self.title = "Swiftip"
        self.view.backgroundColor = UIColor.lightGrayColor()
        totalLabel.text = "$0.00"
        tipLabel.text = "$0.00"
    }
    
    func setButtonAttributes() {
        addNewBill.setTitle("\u{2713}", forState: .Normal)
        addNewBill.layer.cornerRadius = 0.5 * addNewBill.bounds.size.width
        addNewBill.layer.borderColor = UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1).CGColor as CGColorRef
        addNewBill.layer.borderWidth = 2.0
        addNewBill.clipsToBounds = true
        
        //addNewBill.layer.borderWidth = 1
        //addNewBill.layer.cornerRadius = 0.5 * addNewBill.bounds.size.width
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
        
        // format tip and total amounts to 2 decimal places
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
    }
    
    // when user is satisfied with bill total, button press
    // adds new bill amount to list
    @IBAction func addBillToTableView(sender: AnyObject) {
        totalBillHistory.append(totalLabel.text!)
        tableView.reloadData()
        // hide keypad
        self.view.endEditing(true)
        // reset text field and labels
        billField.text = ""
        totalLabel.text = "$0.00"
        tipLabel.text = "$0.00"
    }
    
    // dismiss the keyboard on tap above and outside
    // the field where the user enters bill amount
    @IBAction func onTap(sender: AnyObject) {
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
    var totalBillHistory = ["Frugality is the \u{1F511} to success."]
    var deleteBillAmountIndexPath: NSIndexPath? = nil
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalBillHistory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = totalBillHistory[row]
        
        return cell
    }
    
    // does not allow deletion of first element in list, which is the key to success
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var returnValue:Bool = true
        if(totalBillHistory[indexPath.row] == "Frugality is the \u{1F511} to success.")
        {
            returnValue = false
        }
        return returnValue
        
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(totalBillHistory[row])
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteBillAmountIndexPath = indexPath
            let billToDelete = totalBillHistory[indexPath.row]
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
            
            totalBillHistory.removeAtIndex(indexPath.row)
            
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

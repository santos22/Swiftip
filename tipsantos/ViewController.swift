//
//  ViewController.swift
//  tipsantos
//
//  Created by Santos Solorzano on 12/28/15.
//  Copyright © 2015 santosjs. All rights reserved.
//
// icons -> bit.ly/1mkL2oe

import UIKit

// use constants to avoid unexpected changes to reference later on
let defaults = NSUserDefaults.standardUserDefaults()

// generate random number to retrieve random tip
extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

// array of tips provided to user on how to save money
let lifestyleTips = ["Frugality is the \u{1F511} to success", "Always grocery shop with a list \u{1F4DD}", "Buy generic items \u{1F4AF}", "Don’t drink soda. Drink water! \u{1F4A7}", "Grow your own produce \u{1F34A}", "Bring lunch from home \u{1F3E0}"]

let randomTip = lifestyleTips.randomItem()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewBill: UIButton!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // keypad up and running as soon as app starts
        billField.becomeFirstResponder()
        
        // primarily to control HOW this data is displayed
        tableView.delegate = self
        // what data to show in the UITableView
        tableView.dataSource = self
        setLabelAttributes()
        setButtonAttributes()
        loadUserDefaults()
        
    }
    
    // sets title of app and labels default to $0.00
    func setLabelAttributes() {
        self.title = "Swiftip"
        totalLabel.text = "$0.00"
        tipLabel.text = "$0.00"
    }
    
    // sets button attributes...currently an emoji
    func setButtonAttributes() {
        addNewBill.setTitle("\u{2705}", forState: .Normal)
        addNewBill.layer.cornerRadius = 0.5 * addNewBill.bounds.size.width
        addNewBill.layer.borderColor = UIColor(red:79.0, green:86.0, blue:111.0, alpha:1).CGColor as CGColorRef
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // dynamically updates tip and total amounts as user types
    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentages = [0.18, 0.20, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        // format tip and total amounts to 2 decimal places
        tipLabel.text = String(format:"$%.2f", tip)
        totalLabel.text = String(format:"$%.2f", total)
    }
    
    // when user is satisfied with bill total, button
    // press adds new bill amount to bill history and resets labels
    @IBAction func addBillToTableView(sender: AnyObject) {
    
        let billDate = getBillDate()
        
        // do not append the total value if a bill amount
        // reads $0.00 AND the add button is pressed
        if totalLabel.text! != "$0.00" {
            totalBillHistory.append(billDate + " | " + totalLabel.text!)
            
            // synchronize NSUserDefaults to save data
            defaults.setValue(totalBillHistory, forKey: "billData")
            defaults.synchronize()
            tableView.reloadData()
        }
        
        // hide keypad after tapping button
        self.view.endEditing(true)
        billField.text = ""
        totalLabel.text = "$0.00"
        tipLabel.text = "$0.00"
    }
    
    // dismiss the keyboard on tap above and outside
    // the text field where the user enters bill amount
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // function to retrieve date when bill amount was entered
    func getBillDate() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        // cast Int to String
        let billDate = String(month) + "/" + String(day) + "/" + String(year)
        return billDate
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
    // data source for this UITableViewDataSource
    var totalBillHistory = [String](arrayLiteral: randomTip)
    
    var deleteBillAmountIndexPath: NSIndexPath? = nil
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // return the count of the elements (bill totals) in our array here
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
        if(indexPath.row == 0)
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
    
    // delegate method that causes the buttons to appear on swipe (commitEditingStyle)
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteBillAmountIndexPath = indexPath
            
            //store the indexPath of the row we’re wanting to delete
            // in a class-viewable variable
            let billToDelete = totalBillHistory[indexPath.row]
            confirmDelete(billToDelete)
        }
    }
    
    // function to confirm that user in fact wants to delete said item
    func confirmDelete(bill: String) {
        let alert = UIAlertController(title: "Delete Bill", message: "Are you sure you want to permanently delete $\(bill)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteBill)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteBill)
        
        // create UIAlertAction buttons: one for Delete and one for Cancel
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // function to handle delete UIAlertAction instance
    func handleDeleteBill(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteBillAmountIndexPath {
            // signals the start of UI updates to the table view.
            tableView.beginUpdates()
            
            // remove the bill from the data source set in delegate method
            totalBillHistory.removeAtIndex(indexPath.row)
            
            // note that indexPath is wrapped in an array:  [indexPath] instances
            // removes the bill from the UI (table view)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            // reset the class-viewable deleteBillAmountIndexPath to nil
            deleteBillAmountIndexPath = nil
            
            // synchronize NSUserDefaults to save data
            defaults.setValue(totalBillHistory, forKey: "billData")
            defaults.synchronize()
            tableView.endUpdates()
        }
    }
    
    // function to handle cancel UIAlertAction instance
    func cancelDeleteBill(alertAction: UIAlertAction!) {
        deleteBillAmountIndexPath = nil
    }
    
    func loadUserDefaults() {
        if let tempBillArray = defaults.valueForKey("billData") {
            totalBillHistory = tempBillArray as! [String]
        }
    }

}

//
//  ViewController.swift
//  TipCalculator
//
//  Created by Hyun on 2015. 11. 7..
//  Copyright © 2015년 wook2. All rights reserved.
//

// 1
// iOS is split up into multiple frameworks, each of which contain different sets of code. Before you can use code from a framework in your app, you have to import it like you see here. UIKit is the framework that contains the base class for view controllers, various controls like buttons and text fields, and much more.
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultsTextView: UITextView!
   
    @IBOutlet weak var taxPctLabel: UILabel!
    @IBOutlet weak var taxPctSlider: UISlider!
    @IBOutlet weak var totalTextField: UITextField!
    
    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    //You’re marking the variables with an exclamation mark (!). This indicates the variables are optional values, but they are implicitly unwrapped. This is a fancy way of saying you can write code assuming that they are set, and your app will crash if they are not set.
    //Implicitly unwrapped optionals are a convenient way to create variables you know for sure will be set up before you use them (like user interface elements created in the Storyboard), so you don’t have to unwrap the optionals every time you want to use them
    
    
    // This method is called with the root view of this view controller is first accessed. Whenever you override a method in Swift, you need to mark it with the override keyword. This is to help you avoid a situation where you override a method by mistake.
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
    }

    // This method is called when the device is running low on memory. It’s a good place to clean up any resources you can spare.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func refreshUI() {
        // 1
        totalTextField.text = String(format: "%0.2f", tipCalc.total)
        // 2
        taxPctSlider.value = Float(tipCalc.taxPct) * 100.0
        // 3
        taxPctLabel.text = "Tax Percentage (\(Int(taxPctSlider.value))%)"
        // 4
        resultsTextView.text = ""
    }
    
    @IBAction func calculateTapped(sender: AnyObject) {
        //Here you need to convert a String to a Double. This is a bit of a hack to do this; hopefully there will be an easier way in a future update to Swift.
        tipCalc.total = Double((totalTextField.text! as NSString).doubleValue)
        
        let possibleTips = tipCalc.returnPossibleTips()
        var results = ""
        
        // sort by key value in order to print texts in numerical order
        
        var keys = Array(possibleTips.keys)
        keys.sortInPlace()
        
        for tipPct in keys {
            let tipValue = possibleTips[tipPct]!
            let prettyTipValue = String(format:"%.2f", tipValue)
            results += "\(tipPct)% : \(prettyTipValue)\n"
        }
//        
//        for (tipPct, tipValue) in possibleTips {
//            results += "\(tipPct)% : \(tipValue)\n"
//        }
        
        
        resultsTextView.text = results
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        totalTextField.resignFirstResponder()
    }
    
    @IBAction func taxPercentageChanged(sender: AnyObject) {
        tipCalc.taxPct = Double(taxPctSlider.value) / 100.0
        refreshUI()
    }

}


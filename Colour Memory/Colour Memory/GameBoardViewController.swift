//
//  GameBoardViewController.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import UIKit

// MARK : - MemoryGameViewController : UIViewController
class GameBoardViewController: UIViewController {

    // MARK : Properties
    @IBOutlet var cardButtons : [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreBtn: UIButton!
    
    weak var actionToEnable : UIAlertAction?
    
    var playingPack = PlayingPack()
    var gameMatchManager = CardMatchingManager()
    let delay = 1.0
    var numOfCard: Int?
    
    
    var scoresDictionary:[String:Int] = [String:Int]()
    var userName:String = String()
    var userScore:Int = Int()
    
    var userDefaults : NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    struct Constants {
        
        static let DefaultName = "highScoreList"
        static let SegueIdentifier = "showScoreTable"
        static let BackGroundImageName = "card_bg"
        static let AlertTitle = "Game Over"
        static let AlertMessage = "Enter your name"
        static let AlertPlaceholder = "Name"
        static let ActionOk = "Ok"
        static let ActionCancel = "Cancel"
    }
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameMatchManager = CardMatchingManager(count: cardButtons.count, pack: playingPack)
        
        for card in cardButtons  {
            card.setBackgroundImage(UIImage(named:Constants.BackGroundImageName), forState: .Normal)
        }
        
        // load the dictionary from NSUserDefaults, if exists
        // getScoresList()
    }
    
    // MARK : Set AutoRotate option
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK : Force Orientation
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    
    func getScoresList() {
        
        if let scoresDict = userDefaults.objectForKey(Constants.DefaultName) as? [String:Int] {
            scoresDictionary = scoresDict
            let sortedKeysAndValues = scoresDictionary.sort { $0 > $1 }
            print(sortedKeysAndValues)
        }
    }

    
    
    // do everything at the final score screen
    func dosomething() {
        
        // do whatever you want to do here for final scoring and animations, etc.....
        
        
        // save final score
        self.saveFinalScore()
    }
    
    func saveFinalScore() {
        
        // add the user's score to the dictionary
        self.scoresDictionary[userName] = userScore
        
        // set defaults to simplify NSUD access
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // write the dictionary to NSUserDefaults
        defaults.setObject(self.scoresDictionary, forKey: "scoreDict")
    }
    
    // MARK : Button Action
    @IBAction func tapCardButton(sender: UIButton)
    {
        print("tap button")
        let selectedBtnIndex =  cardButtons.indexOf(sender)
        print("selected index: \(selectedBtnIndex)")
        gameMatchManager.selectCardAtIndex(selectedBtnIndex!)
        performUIUpdate()
    }
    
    // MARK : UI Update
    func performUIUpdate() {
        print("UI Update")
        showAlert()
        for cardButton in cardButtons {
            
            let index = cardButtons.indexOf(cardButton)
            let card =  gameMatchManager.cardAtIndex(index!)
            
            cardButton.setBackgroundImage(getBackgroundImage(card!), forState: .Normal)
            
            // Creates a dispatch_time_t relative to the default clock or modifies an existing dispatch_time_t.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay * Double(NSEC_PER_SEC)))
            
            // Enqueue a block for execution at the specified time
            dispatch_after(time, dispatch_get_main_queue()) {
                cardButton.hidden = (card?.isMatched)!
            }
            
            self.scoreLabel.text = "Score : \(self.gameMatchManager.getScore())"
        }
        
        if gameMatchManager.checkNumOfMatchedCard() == cardButtons.count {
            showAlert()
        }
    }
    
    // MARK : Get Background Image of Card
    func getBackgroundImage(card:Card)->UIImage {
        let imageName = (card.isSelected == true) ? card.colourDesc: Constants.BackGroundImageName
        return UIImage(named:imageName!)!
    }
    
    // MARK : Show AlertView
    func showAlert()
    {
        let title = Constants.AlertTitle
        let message = Constants.AlertMessage
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let placeholder = Constants.AlertPlaceholder
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = placeholder
            textField.addTarget(self, action: #selector(GameBoardViewController.textChanged(_:)), forControlEvents: .EditingChanged)
        })
        
        let cancel = UIAlertAction(title: Constants.ActionCancel, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            
        })
        
        let action = UIAlertAction(title: Constants.ActionOk, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            let textfield = alert.textFields!.first!
            print(textfield.text)
            
            
            self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: self)
            
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.actionToEnable = action
        action.enabled = false
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK : TextField Action Method
    func textChanged(sender:UITextField) {
        // If text is entered, UIAlertAction becomes enabled
        self.actionToEnable?.enabled = (sender.text! != "")
    }
    
    // MARK : Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.SegueIdentifier {
            // slet viewController = segue.destinationViewController as? HighScoreTableViewController
            // let indexPath = self.tableView.indexPathForSelectedRow()
            // viewController.pinCode = self.exams[indexPath.row]

        }
    
    }

    
}

 // MARK : UINavigationController Extension

extension UINavigationController {
    
    // MARK : Override Auto Rotate
    public override func shouldAutorotate() -> Bool {
        // This line enables GameBoardViewController to force 'portrait orientation'
        return visibleViewController!.shouldAutorotate()
    }
}


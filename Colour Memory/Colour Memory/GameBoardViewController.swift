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
    
    var scoresList:[String:Int] = [String:Int]()
    
    var userName:String = String()
    var userScore:Int = Int()
    var rank:Int?
    
    var userDefaults : NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    // MARK : Constants
    struct Constants {
        
        static let DefaultName = "highScoreList"
        static let SegueIdentifier = "showScoreVC"
        static let BtnSegueIdentifier = "showScoreTable"
        static let BackGroundImageName = "card_bg"
        static let AlertTitle = "Game Over"
        static let AlertMessage = "Enter your name"
        static let AlertPlaceholder = "Name"
        static let ActionOk = "Ok"
        static let ActionCancel = "Cancel"
        static let CellIdentifier = "scoreCell"
        
    }
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameMatchManager = CardMatchingManager(count: cardButtons.count, pack: playingPack)
        
        // Load the dictionary from user's defaults database
        getHighScoreList()
    }
    
    override func viewWillAppear(animated: Bool) {
        scoreLabel.text = "Score : 0"
        shuffleCard()
    }
    
    func shuffleCard() {
        for card in cardButtons  {
            card.setBackgroundImage(UIImage(named:Constants.BackGroundImageName), forState: .Normal)
            card.hidden = false
        }
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
    
    func getHighScoreList() {
        
        if let scoresDictionary = userDefaults.objectForKey(Constants.DefaultName) as? [String:Int] {
            print("Load Score")
            scoresList = scoresDictionary
        }
    }

    func saveHighScoreList() {
        print("Save High Score List")
        if( scoresList.count > 0 ) {
        
            // Sort the dictionary in a descending order
            let sortedList = scoresList.sort { $0.1 > $1.1 }
            
            print("Dictionary : \(scoresList)")
            print("Sorted List : \(sortedList)")
            
            print("current Score: \(gameMatchManager.getScore())")
            
            // If the current user's score is higher than the existing highest score
            if( gameMatchManager.getScore() >= sortedList[0].1){
                
                // Add the user's score to the dictionary
                scoresList[userName] = userScore
                
                // Save to user's defaults database
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(scoresList, forKey: Constants.DefaultName)
                
                // Set rank
                rank = 1
            } else {
                // If not, search through list whether user's score history exists
                let index = sortedList.indexOf { $0.0 == self.userName }
                
                if let index = index {
                    rank = index + 1
                }
            }
            
        } else {
            rank = 1
            scoresList[userName] = userScore
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(scoresList, forKey: Constants.DefaultName)

        }
        
        
    }

    // MARK : Button Action
    @IBAction func tapCardButton(sender: UIButton)
    {
        let selectedBtnIndex =  cardButtons.indexOf(sender)
        
        gameMatchManager.selectCardAtIndex(selectedBtnIndex!)
        performUIUpdate()
    }
    
    // MARK : UI Update
    func performUIUpdate() {
        
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
            
            scoreLabel.text = "Score : \(self.gameMatchManager.getScore())"
        }
        
        if gameMatchManager.numOfMatchedCard() == cardButtons.count {
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
            // textField.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
            textField.addTarget(self, action: #selector(GameBoardViewController.textChanged(_:)), forControlEvents: .EditingChanged)
        })
        
        let cancel = UIAlertAction(title: Constants.ActionCancel, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            
        })
        
        let save = UIAlertAction(title: Constants.ActionOk, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            let textfield = alert.textFields!.first!
            print(textfield.text)
            self.userName = textfield.text!
            self.userScore = self.gameMatchManager.getScore()
            self.saveHighScoreList()
            self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: self)
        })
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        actionToEnable = save
        save.enabled = false
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK : TextField Action Method
    func textChanged(sender:UITextField) {
        
        // If text is entered, UIAlertAction becomes enabled
        actionToEnable?.enabled = (sender.text! != "")
    }
    
    // MARK : Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.SegueIdentifier {
            
            let highScoreVC = segue.destinationViewController as? HighScoreTableViewController
            print("PrepareSegue")
            print("score : \(userScore)")
            print("rank  : \(rank)")
            highScoreVC?.score = userScore
            highScoreVC?.rank  = rank 
            highScoreVC?.highScoreList = scoresList
            
        }
        
        if segue.identifier == Constants.BtnSegueIdentifier {
            
            let highScoreVC = segue.destinationViewController as? HighScoreTableViewController
            highScoreVC?.highScoreList = scoresList
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

// MARK : Dictionary Extension
extension Dictionary {
    
    // MARK : Subscripting Dictionary By Index
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[self.startIndex.advancedBy(i)]
        }
    }
}


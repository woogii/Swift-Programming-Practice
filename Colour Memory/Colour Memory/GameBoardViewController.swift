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
    @IBOutlet weak var highScoreBtn: BorderedButton!
    
    weak var actionToEnable : UIAlertAction?
    
    var gameMatchManager = CardMatchingManager()
    var numOfCard: Int?
    var userName:String = String()
    var userScore:Int = Int()
    var rank = 0
    var scoresList:[String:Int] = [String:Int]()
    
    var userDefaults : NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    var selectedCard  = [Card]()
    var buttonIndices = [Int]()
    var numOfFlippedCards = 0
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the dictionary from user's defaults database
        getHighScoreList()
    }
    
    override func viewWillAppear(animated: Bool) {
        resetGame()
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        //supportedInterfaceOrientations()
    }
    
    // MARK : Reset Game
    func resetGame() {
        
        scoreLabel.text = Constants.InitScoreLabelText
        rank = 0
        gameMatchManager = CardMatchingManager(count: cardButtons.count, pack: PlayingPack())
        faceDownCard()
    }
    
    // MARK : Place cards face down
    func faceDownCard() {
        
        for card in cardButtons  {
            card.setBackgroundImage(UIImage(named:Constants.BackGroundImageName), forState: .Normal)
            card.alpha = 1.0
        }
    }
    
    // MARK : Set AutoRotate option
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    // MARK : Get Scores
    func getHighScoreList() {
        
        guard let scoresDictionary = userDefaults.objectForKey(Constants.DefaultName) as? [String:Int] else {
            return
        }
        scoresList = scoresDictionary
    }

    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    // MARK : Save Scores
    func saveHighScoreList() {
    
        // Save to user's defaults database
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(scoresList, forKey: Constants.DefaultName)
    }
    
    // MARK : Process(= Rank,Sort and save Result) game result
    func processGameResult() {
        
        // If there is scores saved
        if( scoresList.count > 0 ) {
            
            // Sort the dictionary in a descending order
            let sortedList = scoresList.sort { $0.1 > $1.1 }
            
            // If the current user's score is higher than the existing highest score
            if( gameMatchManager.getScore() >= sortedList[0].1){
                
                // Add the user's score to the dictionary
                scoresList[userName] = userScore
                
                saveHighScoreList()
                rank = 1
                
            } else {
                
                // If not, search through list whether user's score history exists
                let returnIndex = sortedList.indexOf { $0.0 == self.userName }
                
                guard let index = returnIndex else {
                    return
                }
                
                rank = index + 1
            }
            
        } else {
            // First player will be ranked at the top spot
            rank = 1
            
            scoresList[userName] = userScore
            saveHighScoreList()
        }
    
    }
    
    // MARK : Button Action
    @IBAction func tapCardButton(sender: UIButton)
    {
        let selectedBtnIndex = cardButtons.indexOf(sender)
        
        gameMatchManager.selectCardAtIndex(selectedBtnIndex!)
        
        performUIUpdate()
    }
    
    // MARK : UI Update
    func performUIUpdate() {
        print("UI update")
        
        for cardButton in cardButtons {
            
            guard let index = cardButtons.indexOf(cardButton) else {
                return
            }
            
            guard let card =  gameMatchManager.cardAtIndex(index) else {
                return
            }
            
            let imageName = self.getBackgroundImage(card)
            cardButton.setBackgroundImage(UIImage(named:imageName), forState: .Normal)
        
        
            // Creates a dispatch_time_t relative to the default clock or modifies an existing dispatch_time_t.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(Constants.Delay * Double(NSEC_PER_SEC)))
            
            // Enqueue a block for execution at the specified time
            dispatch_after(time, dispatch_get_main_queue()) {
                
                // Hidden card after posing one second
                // Have to use alpha property since stackview was adopted
                if card.isMatched {
                    cardButton.alpha = 0.0
                } else {
                    cardButton.alpha = 1.0
                }
            }
        
            scoreLabel.text =  Constants.ScoreLabelText + String(self.gameMatchManager.getScore())
        }
        
        numOfFlippedCards = numOfFlippedCards + 1
        
        if (numOfFlippedCards == 2) {
            checkTwoCardsFlipped()
            numOfFlippedCards = 0
        }

        
        // All cards are matched, show alert message to ask user to input his/her name
        if gameMatchManager.numOfMatchedCard() == cardButtons.count {
            showAlert()
        }
    }
    
    func checkTwoCardsFlipped() {
    
        for cardButton in cardButtons {
            
            guard let index = cardButtons.indexOf(cardButton) else {
                return
            }
            
            guard let card =  gameMatchManager.cardAtIndex(index) else {
                return
            }
            
            if card.isSelected == true {
                print("card is selected")
                print("card value \(card.isSelected)")
                print("card value \(card.isMatched)")
                selectedCard.append(card)
                buttonIndices.append(index)
            }
        }
        
        
        print("two flipped cards")
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(Constants.Delay * Double(NSEC_PER_SEC)))
            
        // Enqueue a block for execution at the specified time
        dispatch_after(time, dispatch_get_main_queue()) {
            
            print(self.selectedCard.count)
            for i in 0..<self.selectedCard.count {
                self.selectedCard[i].isSelected = false
                    
                let imageName = self.getBackgroundImage(self.selectedCard[i])
                print("imageName : \(imageName)")
                self.cardButtons[self.buttonIndices[i]].setBackgroundImage(UIImage(named:imageName), forState: .Normal)
                
            }

            self.selectedCard = [Card]()
            self.buttonIndices = [Int]()
        }
    }
    
    
    // MARK : Get Background Image of Card
    func getBackgroundImage(card:Card)->String {
        
        if (card.isSelected == true) {
            return card.colourDesc
        }else {
            return Constants.BackGroundImageName
        }
        
    }
    
    // MARK : Show AlertView
    func showAlert()
    {
        let title   = Constants.AlertTitle
        let message = Constants.AlertMessage
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let placeholder = Constants.AlertPlaceholder
        
        // Adds a text field to an alert
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = placeholder
            // Associate target object with action 'textChanged:' when a control event occurs
            // textField.addTarget(self, action: #selector(GameBoardViewController.textChanged(_:)), forControlEvents: .EditingChanged)
            textField.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
            
        })
        
        // Define action when 'Cancle' button tapped
        let cancel = UIAlertAction(title: Constants.ActionCancel, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            self.resetGame()
        })
        
        // Define action when 'Ok' button tapped
        let ok = UIAlertAction(title: Constants.ActionOk, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            
            // Get the first element of textField array
            let textfield = alert.textFields!.first!
            
            // Get User Name
            self.userName = textfield.text!
            
            // Save the current user's score
            self.userScore = self.gameMatchManager.getScore()
            
            // Processing the game result
            self.processGameResult()
            
            self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: self)
        })
        
        // Add actions
        alert.addAction(cancel)
        alert.addAction(ok)
        
        actionToEnable = ok
        
        // Disabled OK button initially
        ok.enabled = false
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK : TextField Action Method
    func textChanged(sender:UITextField) {
        
        // Once text is entered, UIAlertAction becomes enabled
        actionToEnable?.enabled = (sender.text! != "")
    }
    
    // MARK : Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if segue to the highscoretable viewcontroller after playing game
        if segue.identifier == Constants.SegueIdentifier {
            
            let highScoreVC = segue.destinationViewController as? HighScoreTableViewController
            highScoreVC?.score = userScore
            highScoreVC?.rank  = rank 
            highScoreVC?.highScoreList = scoresList
            
        }
        
        // if segue to the highscoretable viewcontroller after tapping highscore button without playing game
        if segue.identifier == Constants.BtnSegueIdentifier {
            
            let highScoreVC = segue.destinationViewController as? HighScoreTableViewController
            highScoreVC?.highScoreList = scoresList
        }
    }
}

// MARK : - UINavigationController ( Force orientation )
extension UINavigationController {
    
    // MARK : Override Auto Rotate
    public override func shouldAutorotate() -> Bool {
        // This line enables GameBoardViewController to force 'portrait orientation'
        return visibleViewController!.shouldAutorotate()
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations())!
    }
}


extension UIAlertController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    public override func shouldAutorotate() -> Bool {
        return false
    }
}

// MARK : - Dictionary ( Subscripting support )
extension Dictionary {
    
    // MARK : Subscripting Dictionary By Index
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[self.startIndex.advancedBy(i)]
        }
    }

}


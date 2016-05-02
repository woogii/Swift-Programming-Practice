//
//  GameBoardViewController.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import UIKit
import CoreData

// MARK : - MemoryGameViewController : UIViewController
class GameBoardViewController: UIViewController {

    // MARK : Properties
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button16: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var highScoreBtn: BorderedButton!
    
    var cardButtons:[UIButton]! {
        return [button1,button2,button3,button4,button5,button6,button7,button8,
            button9,button10,button11,button12,button13,button14,button15,button16]
    }
    
    weak var actionToEnable : UIAlertAction?
    var userName  = String()
    var userScore = Int()
    var rank      = 0
    
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    var gameMatchManager = CardMatchingManager()
    var scoreDict        = [String:AnyObject]()
    var scoreList        = [ScoreList]()
    var selectedCard     = [Card]()
    var buttonIndices    = [Int]()

    // MARK : Fetch score list
    func fetchAllScores()->[ScoreList] {
        
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityName)
        let sortDescriptorByScore = NSSortDescriptor(key: Constants.KeyScore, ascending: false)
        let sortDescriptorByDate  = NSSortDescriptor(key: Constants.KeyDate,  ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptorByScore, sortDescriptorByDate]
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [ScoreList]
        } catch let error as NSError {
            print(error.description)
            return [ScoreList]()
        }
    }
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreList = fetchAllScores()
    }
    
    override func viewWillAppear(animated: Bool) {
        resetGame()
        
        // Set Orientation as Portrait mode
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: Constants.KeyOrientation)
    }
    
    // MARK : Reset Game
    func resetGame() {
        
        scoreLabel.text = Constants.InitScoreLabelText
        rank = 0
        gameMatchManager = CardMatchingManager(count: cardButtons.count, pack: PlayingPack())
        placeCardsFaceDown()
    }
    
    // MARK : Place cards face down
    func placeCardsFaceDown() {
        
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
    

    
    // MARK : Save Scores
    func saveHighScoreList() {
        
        let newScore = ScoreList(dictionary: scoreDict, context: self.sharedContext)
        scoreList.append(newScore)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // MARK : Process(= Rank,Sort and save Result) game result
    func processGameResult() {
        
        // If there is scores saved
        if( scoreList.count > 0 ) {
            
            // If the current user's score is higher than the existing highest score
            if( gameMatchManager.getScore() >= Int(scoreList[0].score) ){
                
                // Add the user's score to the dictionary
                scoreDict[Constants.KeyName]  = userName
                scoreDict[Constants.KeyScore] = userScore
                scoreDict[Constants.KeyDate]  = NSDate()
                
                saveHighScoreList()

                rank = 1 
            } else {
                print("Not highest")
                var i = 0
                
                // If not, search through list whether user's score history exists
                for list in scoreList {
                    
                    if list.name == userName {
                        rank = i+1
                        break
                    }
                    i = i + 1
                }
            }
        } else {
            // First player will be ranked at the top spot
            rank = 1
            
            scoreDict[Constants.KeyName]  = userName
            scoreDict[Constants.KeyScore] = userScore
            scoreDict[Constants.KeyDate]  = NSDate()
            saveHighScoreList()
        }
        
        
        // Sort ScoreList after appending data
        scoreList.sortInPlace({
            // If there are records with same score, then sort records by the 'date' property
            if $0.score as Int == $1.score as Int {
                return $0.recordTime.compare($1.recordTime) == NSComparisonResult.OrderedDescending
            }
            return $0.score as Int > $1.score as Int
        })

    
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
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(Constants.DelayIfMathced * Double(NSEC_PER_SEC)))
            
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
       
        
        let numberOfFlippedCards = calNumberOfFlippedCards()
        
        // If there are more than two cards selected
        if (numberOfFlippedCards >= Constants.numOfFlippedCards) {
            placeFippedCardsFaceDown()
        }
        
        // All cards are matched, show alert message to ask user to input his/her name
        if gameMatchManager.numOfMatchedCard() == cardButtons.count {
            showAlert()
        }
    }
    
    // MARK : Calculate the number of flipped cards
    func calNumberOfFlippedCards()->Int{
        
        var num = 0
        
        for cardButton in cardButtons {
            
            guard let index = cardButtons.indexOf(cardButton) else {
                return 0
            }
            
            guard let card =  gameMatchManager.cardAtIndex(index) else {
                return 0
            }
            
            if card.isSelected == true {
                num = num + 1
                // Save information about which indices and cards are selected
                selectedCard.append(card)
                buttonIndices.append(index)
            }
        }
        
        return num
    }
    
    // MARK : Place flipped cards face down
    func placeFippedCardsFaceDown() {
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(Constants.DelayIfNotMathced * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            
            // If there are more than two cards selected
            if ( self.buttonIndices.count >= 2 ) {
            
                // loop through as much as the number of card selected
                for i in 0..<self.selectedCard.count {
                    
                    // Set as not selected
                    self.selectedCard[i].isSelected = false
                    
                    // Update Card background image as default image
                    let imageName = self.getBackgroundImage(self.selectedCard[i])
                    self.cardButtons[self.buttonIndices[i]].setBackgroundImage(UIImage(named:imageName), forState: .Normal)
                    
                }
            }
            // Initialize both arrays
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
            textField.addTarget(self, action: #selector(GameBoardViewController.textChanged(_:)), forControlEvents: .EditingChanged)
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
            print("userScore: \(userScore)")
            print("rank : \(rank)")
            highScoreVC?.score = userScore
            highScoreVC?.rank  = rank 
            highScoreVC?.highScoreList = scoreList
            
        }
        
        // if segue to the highscoretable viewcontroller after tapping highscore button without playing game
        if segue.identifier == Constants.BtnSegueIdentifier {
            
            let highScoreVC = segue.destinationViewController as? HighScoreTableViewController
            highScoreVC?.highScoreList = scoreList
            

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

// MARK : UIAlertController ( For Preventing Layout error : http://goo.gl/IUeHk9 )  
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


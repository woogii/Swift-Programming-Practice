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
    var gameMatchManager: CardMatchingManager?
    let delay = 1.0
    var numOfCard: Int?
    let segueIdentifier = "showScoreTable"
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameMatchManager = CardMatchingManager(count: cardButtons.count, pack: playingPack)
        
        
        for card in cardButtons  {
            card.setBackgroundImage(UIImage(named:"card_bg"), forState: .Normal)
        }
    }
    
    // MARK : Set AutoRotate option
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK : Force Orientation
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask =
            [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    
    // MARK : Button Action
    @IBAction func tapCardButton(sender: UIButton)
    {
        print("tap button")
        let selectedBtnIndex =  cardButtons.indexOf(sender)
        print("selected index: \(selectedBtnIndex)")
        gameMatchManager?.selectCardAtIndex(selectedBtnIndex!)
        performUIUpdate()
    }
    
    // MARK : UI Update
    func performUIUpdate() {
        print("UI Update")
    
        for cardButton in cardButtons {
            
            let index = cardButtons.indexOf(cardButton)
            let card =  gameMatchManager?.cardAtIndex(index!)
            
            cardButton.setBackgroundImage(getBackgroundImage(card!), forState: .Normal)
            
            // Creates a dispatch_time_t relative to the default clock or modifies an existing dispatch_time_t.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay * Double(NSEC_PER_SEC)))
            
            // Enqueue a block for execution at the specified time
            dispatch_after(time, dispatch_get_main_queue()) {
                cardButton.hidden = (card?.isMatched)!
            }
            
            self.scoreLabel.text = "Score : \(self.gameMatchManager!.getScore())"
        }
        
        
        if gameMatchManager?.checkNumOfMatchedCard() == cardButtons.count {
            showAlert()
        }
    }
    
    // MARK : Get Background Image of Card
    func getBackgroundImage(card:Card)->UIImage {
        let imageName = (card.isSelected == true) ? card.colourDesc:"card_bg"
        return UIImage(named:imageName!)!
    }
    
    // MARK : Show AlertView
    func showAlert()
    {
        let title = "Game is Over"
        let message = "Enter your name"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let placeholder = "Name"
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = placeholder
            textField.addTarget(self, action: #selector(GameBoardViewController.textChanged(_:)), forControlEvents: .EditingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            
        })
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            let textfield = alert.textFields!.first!
            
            //Do what you want with the textfield!
            self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
            
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
        
        if segue.identifier == segueIdentifier {
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


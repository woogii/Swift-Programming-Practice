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
    var playingPack = PlayingPack()
    var matchingManager: CardMatchingManager?
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchingManager = CardMatchingManager(count: cardButtons.count, pack: playingPack)
        
        for card in cardButtons  {
            card.setBackgroundImage(UIImage(named:"card_bg"), forState: .Normal)
            card.tag = 0
        }
    }
    
    // MARK : Button Action
    @IBAction func tapCardButton(sender: UIButton)
    {
        let selectedBtnIndex =  cardButtons.indexOf(sender)
        matchingManager?.selectCardAtIndex(selectedBtnIndex!)
        performUIUpdate()
    }
    
    func performUIUpdate() {
        
    }


}


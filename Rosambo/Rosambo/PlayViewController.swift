//
//  ViewController.swift
//  Rosambo
//
//  Created by Hyun on 2016. 1. 15..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var scissorButton: UIButton!
    
    var matchResult: String!
    var resultMessage: String!
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    enum roshamboMove : Int {
        case Rock = 1, Scissor, Paper
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        
        let nextViewController = segue.destinationViewController as! ResultViewController

        nextViewController.resultMessage = resultMessage + matchResult
        nextViewController.imageName = imageName
    
    }
    
    @IBAction func buttonClick(sender: UIButton) {
        
        playGame(sender)

        
        switch sender {
            case paperButton:
                var controller : ResultViewController
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultViewController
                controller.resultMessage = resultMessage + matchResult
                controller.imageName = imageName
        
                self.presentViewController(controller, animated: true, completion: nil)
                
                break
            case rockButton:
                print("rockButton in switch")
                performSegueWithIdentifier("rockSegue", sender: sender)
                break
            
            default:
                break
        }
    }
    
  
    func playGame(sender: UIButton) {
        
        let randomPick = Int(arc4random_uniform(3)+1)
        
        let yourMove = roshamboMove(rawValue: randomPick)!
        let myMove = sender
        
        switch(myMove, yourMove) {
            
            case (paperButton, .Scissor), (scissorButton, .Paper):
                imageName = "ScissorsCutPaper"
                resultMessage = "Scissors cuts paper."
            
            case (paperButton, .Rock), (rockButton, .Paper):
                imageName = "PaperCoversRock"
                resultMessage = "Paper covers rock."
            case (scissorButton, .Rock), (rockButton, .Scissor):
                imageName = "RockCrushesScissors"
                resultMessage = "Rock crushes scissors."
            case (paperButton, .Paper), (scissorButton, .Scissor), (rockButton, .Rock):
                imageName = "itsATie"
                resultMessage = "It is a tie."
            default :
                break
        }
        
        switch(myMove, yourMove) {
            case (paperButton, .Rock), (scissorButton, .Paper), (rockButton, .Scissor):
                matchResult = " You win"
            case (paperButton, .Scissor), (scissorButton, .Rock),(rockButton, .Paper) :
                matchResult = " You Lose"
            default :
                matchResult = " "
                break
        }

        
    }
    
    

   
    
    
    
}


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
    
    var match: RPSMatch!
    var resultMessage: String!
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        let nextViewController = segue.destinationViewController as! ResultViewController
        nextViewController.match = self.match
    
    }
    
    @IBAction func makeYourMove(sender: UIButton) {
        
        switch sender {
            
        case paperButton :
            throwDown(RPS.Paper)
            break
        case scissorButton :
            throwDown(RPS.Scissors)
            break
        case rockButton :
            throwDown(RPS.Rock)
            break
        default:
            break
        }
        
    }

    
    func throwDown(myMove: RPS) {
    
        let opponent = RPS()
        match = RPSMatch(p1: myMove, p2: opponent)
        
        switch myMove {
        
            case RPS.Rock:
        
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultViewController
                controller.match = match
                
                //self.presentViewController(controller, animated: true, completion: nil)
                self.navigationController?.pushViewController(controller, animated: true)
                break
    
            case RPS.Paper:
                performSegueWithIdentifier("throwPaper", sender: self)
                break
            
            default:
                break
        }
    }
    
  
}


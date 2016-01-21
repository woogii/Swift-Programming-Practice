//
//  ResultViewController.swift
//  Rosambo
//
//  Created by Hyun on 2016. 1. 15..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    
    var match: RPSMatch!
    var matchResult :String!
    
    // PaperCoversRock
    // RockCrushesScissors
    // ScissorsCutPaper
    // itsATie
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        showImage()
        showMatchResult()
    }
    
    func showMatchResult() {
        var result = match.p1.defeats(match.p2) ? "You Win!" : "You Lose!"
        textLabel.text = result
    }
    
    func showImage() {
        
        print("my move : \(match.p1.description)")
        print("opponent move: \(match.p2.description)")

        if(match.winner.description != match.loser.description) {

            var imageName:String!
            
            switch match.winner.description {
                
                case "Paper" :
                    imageName = "\(match.winner.description)Covers\(match.loser.description)"
                break
                case "Scissors":
                    imageName = "\(match.winner.description)Cut\(match.loser.description)"
                break
                case "Rock" :
                    imageName = "\(match.winner.description)Crushes\(match.loser.description)"
                break
            default:
                break
            }
            print(imageName)
            imageView.image = UIImage(named: imageName)
        } else {
            imageView.image = UIImage(named:"itsATie")
        }
        
        print("=====================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func playAgainButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

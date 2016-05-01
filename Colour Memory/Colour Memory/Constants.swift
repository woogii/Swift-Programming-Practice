//
//  Constants.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 30..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation


// MARK : Constants
struct Constants {
    
    static let DefaultName          = "highScoreList"
    static let BackGroundImageName  = "card_bg"
    static let AlertTitle           = "Mission Completed!"
    static let AlertMessage         = "Enter your name"
    static let AlertPlaceholder     = "Name"
    static let ActionOk             = "Ok"
    static let ActionCancel         = "Cancel"
    static let Delay                = 1.0
    
    // MARK : TableView
    static let HeaderCellIdentifier = "sectionHeader"
    static let CellIdentifier       = "scoreCell"
    static let HeaderFirstColumn    = "RANK"
    static let HeaderSecondColumn   = "NAME"
    static let HeaderThirdColumn    = "SCORE"
    static let NumOfHeader          = 1
    static let layoutContraintValue = 109

    // MARK : UIView Tag
    static let RankLabelTag         = 100
    static let NameLabelTag         = 101
    static let ScoreLabelTag        = 102


    // MARK : Segue
    static let SegueIdentifier      = "showScoreVC"
    static let BtnSegueIdentifier   = "showScoreTable"

    
    static let InitScoreLabelText   = "Score : 0"
    static let ScoreLabelText       = "Score : "
    static let ResultScoreText      = "Your Score : "
    static let ResultRankText       = "Your Rank  : "
    static let ResultNoScoreText    = "Your Score : No Record Found"
    static let ResultNoRankText     = "Your Rank  : No Record Found"
    
    static let ColourSetBlue         = "blue"
    static let ColourSetBrown        = "brown"
    static let ColourSetDarkGreen    = "darkGreen"
    static let ColourSetGreen        = "green"
    static let ColourSetLightBlue    = "lightBlue"
    static let ColourSetOlive        = "olive"
    static let ColourSetPurple       = "purple"
    static let ColourSetRed          = "red"
    
    

    static let MatchingPoint        = 2
    static let PenaltyPoint         = -1
    
}
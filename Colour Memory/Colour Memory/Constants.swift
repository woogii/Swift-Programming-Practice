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
    
    // MARK : CoreData
    static let EntityName           = "ScoreList"
    static let KeyName              = "name"
    static let KeyScore             = "score"
    static let KeyRank              = "rank"
    static let KeyDate              = "recordTime"
    static let CoreDataFileName     = "ScoreList.sqlite"
    static let ModelName            = "Model"
    static let ModelExtension       = "momd"
    
    // MARK : AlertController
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

    // MARK : Score Label
    static let InitScoreLabelText   = "Score : 0"
    static let ScoreLabelText       = "Score : "
    static let ResultScoreText      = "Your Score : "
    static let ResultRankText       = "Your Rank  : "
    static let ResultNoScoreText    = "Your Score : No Record Found"
    static let ResultNoRankText     = "Your Rank  : No Record Found"
    
    // MARK : Image Names
    static let ColourSetBlue        = "blue"
    static let ColourSetBrown       = "brown"
    static let ColourSetDarkGreen   = "darkGreen"
    static let ColourSetGreen       = "green"
    static let ColourSetLightBlue   = "lightBlue"
    static let ColourSetOlive       = "olive"
    static let ColourSetPurple      = "purple"
    static let ColourSetRed         = "red"
    static let BackGroundImageName  = "card_bg"

    // MARK : Orientation 
    static let KeyOrientation       = "orientation"
    
    // MARK : Point
    static let MatchingPoint        = 30
    static let PenaltyPoint         = -1
    
    // MARK : Error
    static let CreateOrLoadError    = "There was an error creating or loading the application's saved data."
    static let FailToInitSavedData  = "Failed to initialize the application's saved data"
    static let ErrorDomain          = "persistent coordinator create"
    static let ErrorLogPrefix       = "Unresolved error"
    
    static let numOfFlippedCards    = 2
}
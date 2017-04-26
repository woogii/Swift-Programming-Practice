//
//  RPSGame.m
//  RockPaperScissors
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import "RPSGame.h"

@implementation RPSGame

-(instancetype)initWithFirstTurn:(Move)firstTurn secondTurn:(Move)secondTurn {
  
  self = [super init];
  
  if(self) {
    
    _firstTurn = firstTurn;
    _secondTurn = secondTurn;
  
  }
  
  return self;
}

@end

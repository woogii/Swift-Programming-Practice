//
//  RPSGame.h
//  RockPaperScissors
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSTurn.h"

@interface RPSGame : NSObject

@property (nonatomic) Move firstTurn;
@property (nonatomic) Move secondTurn;

-(instancetype)initWithFirstTurn:(Move)firstTurn
                      secondTurn:(Move)secondTurn;

@end

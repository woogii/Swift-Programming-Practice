//
//  RPSTurn.h
//  RockPaperScissors
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Move) {
  Rock,
  Paper,
  Scissors
};

@interface RPSTurn : NSObject

@property (nonatomic) Move move;

-(instancetype)initWithMove:(Move)move;

@end

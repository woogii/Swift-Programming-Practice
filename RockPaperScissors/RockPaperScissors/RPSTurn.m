//
//  RPSTurn.m
//  RockPaperScissors
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import "RPSTurn.h"

@implementation RPSTurn


-(instancetype)initWithMove:(Move)move {
  
  self = [super init];
  
  if(self) {
    _move = move;
  }
  
  return self;
}

@end

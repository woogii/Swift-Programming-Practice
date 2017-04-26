//
//  House.m
//  House
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import "House.h"

@implementation House

-(instancetype)initWithAddress:(NSString*)address {
  
  self = [super init];
  
  if(self) {
    _address = [address copy];
    _numberOfBedrooms = 2;
    _hasHotTub = false;
    
  }
  return self;
}


@end


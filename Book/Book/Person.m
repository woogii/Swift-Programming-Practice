//
//  Person.m
//  Book
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import "Person.h"

@implementation Person

-(instancetype)initWithName:(NSString *)name birthday:(NSDate *)birthday {
  
  self = [super init];
  
  if(self) {
    _name = [name copy];
    _birthday = birthday;
  }
  
  return self;
}



@end

//
//  Book.m
//  Book
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import "Book.h"

@implementation Book

-(instancetype)initWithTitle:(NSString*)title
                      author:(Person*)author
                        year:(int)year {
  self = [super init];
  
  if(self) {
    _title = title;
    _author = author;
    _yearOfPublication = year;
  }
  
  return self;
}

@end

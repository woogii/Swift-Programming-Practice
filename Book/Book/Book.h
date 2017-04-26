//
//  Book.h
//  Book
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Book : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) Person* author;
@property (nonatomic) int yearOfPublication;

-(instancetype)initWithTitle:(NSString*)title
                      author:(NSString*)author
                        year:(int)year;
@end

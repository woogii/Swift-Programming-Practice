//
//  Person.h
//  Book
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *birthday;

-(instancetype)initWithName:(NSString *)name
                   birthday:(NSDate *)birthday;

@end

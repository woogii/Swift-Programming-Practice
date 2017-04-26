//
//  House.h
//  House
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bedroom.h"

@interface House : NSObject

@property (nonatomic) NSString *address;
@property (nonatomic, readonly) int numberOfBedrooms;
@property (nonatomic) BOOL hasHotTub;


@property (nonatomic) Bedroom *fontBedroom;
@property (nonatomic) Bedroom *backBedroom;

-(instancetype)initWithAddress:(NSString*)address;
@end

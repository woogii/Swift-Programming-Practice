//
//  Bedroom.h
//  House
//
//  Created by siwook on 2017. 4. 26..
//  Copyright © 2017년 siwook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Direction) {
  North,
  South,
  East,
  West
};

@interface Bedroom : NSObject

@property (nonatomic) BOOL privateBath;
@property (nonatomic) Direction directionWindowFaces;


@end

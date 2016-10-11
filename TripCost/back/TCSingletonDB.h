//
//  TCSingletonDB.h
//  TripCost
//
//  Created by andy on 15/8/21.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSingletonDB : NSObject

+ (TCSingletonDB*)sharedDB;
- (void)addTrip:(Trip*)trip;
- (NSMutableArray*)loadTrip;
@end

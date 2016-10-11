//
//  Trip.h
//  TripCost
//
//  Created by andy on 15/8/21.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* tripid;
@property (strong, nonatomic) NSString* createdate;
@property (strong, nonatomic) NSString* creatername;
@property (strong, nonatomic) NSString* createrid;
@property (strong, nonatomic) NSMutableArray *membersArray;
@property (strong, nonatomic) NSString* amount;

@end

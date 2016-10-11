//
//  DataModels.m
//  TripCost
//
//  Created by andy on 15/9/2.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "DataModels.h"

@implementation Trip

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"amount": @"", @"creatername":@"",@"createrid":@""};
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end

@implementation TCContact

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"strAvatar": @"", @"strEmail": @"", @"strUserName": @""};
}

@end

@implementation TCMember

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"bSelected": @0};
}

- (id)initWithContact:(TCContact*)contact{
    self = [super init];
    if (self) {
        self.strUserName = contact.strUserName;
        self.strEmail = contact.strEmail;
        self.strAvatar = contact.strAvatar;
    }
    
    return self;
}

@end

@implementation TCBill
+ (NSDictionary *)defaultPropertyValues
{
    return @{@"billid": @"",@"tripid":@"",@"name":@"",@"createdate":@"",@"createrid":@"",@"creatername":@"",@"amount":@"0",@"comment":@"",@"capture":@""};
}

@end

@implementation TCLocation
@end
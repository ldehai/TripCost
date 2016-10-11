//
//  TCMember.m
//  TripCost
//
//  Created by andy on 15/8/19.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "TCMember.h"

@implementation TCMember

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

//
//  TCMember.h
//  TripCost
//
//  Created by andy on 15/8/19.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCContact.h"

@interface TCMember : TCContact

@property BOOL bSelected;

- (id)initWithContact:(TCContact*)contact;

@end

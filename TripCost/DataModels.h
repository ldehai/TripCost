//
//  DataModels.h
//  TripCost
//
//  Created by andy on 15/9/2.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <Realm/Realm.h>
@import CoreLocation;

@class TCContact;
@class TCMember;
@class TCLocation;
@class TCBill;

RLM_ARRAY_TYPE(TCContact)
RLM_ARRAY_TYPE(TCMember)
RLM_ARRAY_TYPE(TCBill)

@interface Trip : RLMObject

@property NSString* name;
@property NSString* tripid;
@property NSString* createdate;
@property NSString* creatername;
@property NSString* createrid;
@property RLMArray<TCMember> *membersArray;
@property NSString* amount;

@end

@interface TCContact : RLMObject

@property NSString* strUserName;
@property NSString* strEmail;
@property NSString* strAvatar;
@end

@interface TCMember : TCContact

@property BOOL bSelected;

- (id)initWithContact:(TCContact*)contact;

@end

@interface TCBill : RLMObject

@property NSString* billid;
@property NSString* tripid;
@property NSString* name;
@property NSString* createdate;
@property NSString* creatername;
@property NSString* createrid;
@property RLMArray<TCMember> *membersArray;
@property NSString* amount;
@property NSString* comment;
@property NSString* capture;
//@property TCLocation* location;

@end

@interface TCLocation : RLMObject

@property double latitude;
@property double longitude;
@property NSString* address;

@end
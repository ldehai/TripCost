//
//  UIColor+AventColor.h
//  TripCost
//
//  Created by andy on 15/8/13.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(AventColor)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

+ (UIColor *)aventGreenColor;

@end

//
//  UIButton+AventButton.m
//  TripCost
//
//  Created by andy on 15/8/13.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "UIButton+AventButton.h"
#import "UIColor+AventColor.h"

@implementation UIButton(AventButton)

+(UIButton *)aventButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor aventGreenColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];

    return btn;
}

@end

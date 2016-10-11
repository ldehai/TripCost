//
//  TripBillView.h
//  TripCost
//
//  Created by andy on 15/8/17.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModels.h"

@interface TripBillViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UIButton *selectbtn;
@property (strong, nonatomic) UILabel *lbName;
@property (strong, nonatomic) UILabel *lbEmail;
@property (strong, nonatomic) TCBill* bill;

@end

@interface TripBillView : UIView
@property (strong,nonatomic) RLMResults *bills;

@end

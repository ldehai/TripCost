//
//  TripViewCell.m
//  TripCost
//
//  Created by andy on 15/8/23.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "TripViewCell.h"

@interface TripViewCell()
@property (strong, nonatomic) UILabel *lbName;
@property (strong, nonatomic) UILabel *lbDate;
@property (strong,nonatomic) UILabel *lbAmount;
@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UIView *mView;

@end
@implementation TripViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self ) {
        
        UIImageView* coverImg = UIImageView.new;
        [coverImg setImage:[UIImage imageNamed:@"cover"]];
        self.image = coverImg;
        [self.contentView addSubview:coverImg];

        UILabel *name = UILabel.new;
        name.textColor = [UIColor whiteColor];
        self.lbName = name;
        [self.contentView addSubview:name];

        UILabel *tdate = UILabel.new;
        tdate.textColor = [UIColor whiteColor];
        self.lbDate = tdate;
        [self.contentView addSubview:tdate];

        UILabel *amount = UILabel.new;
        amount.textColor = [UIColor whiteColor];
        self.lbAmount = amount;
        [self.contentView addSubview:amount];
        
        UIView *mView = UIView.new;
        self.mView = mView;
        [self.contentView addSubview:mView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self.mView addGestureRecognizer:singleTap];

        [name makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(10);
            make.left.equalTo(self.left).offset(15);
            make.width.equalTo(self);
            make.height.equalTo(@25);
        }];
        
        [tdate makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(30);
            make.left.equalTo(self.left).offset(15);
            make.width.equalTo(self);
            make.height.equalTo(@25);
        }];
        
        [amount makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-30);
            make.left.equalTo(self.left).offset(15);
            make.width.equalTo(@100);
            make.height.equalTo(@25);
        }];
        
        [coverImg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0,0,25,0));
        }];
        
        [mView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.bottom).offset(-50);
            make.right.equalTo(self.contentView.right).offset(-41);
            make.height.equalTo(@40);
        }];

    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return self;
}

- (void)setTrip:(Trip *)trip{
    _trip = trip;
    
    self.lbName.text = trip.name;
    
    NSDate * createdate = [NSDate dateWithString:trip.createdate formatString:@"yyyyMMddHHmmss"];
    NSString *timeAgo = [NSDate timeAgoSinceDate:createdate];
    self.lbDate.text = timeAgo;
    
    self.lbAmount.text = trip.amount;
    
    [self addMember:trip.membersArray];
}

- (void)addMember:(RLMArray*)memberArray{
    
    //insert member
    UIView *lastView;
    
    for (int i=0; i<memberArray.count; i++) {
        TCMember *member = [memberArray objectAtIndex:i];
        UIButton *btn = UIButton.new;
        if (!member.strAvatar && ![member.strAvatar isEqualToString:@""]) {
            [btn setImage:[UIImage imageNamed:member.strAvatar] forState:UIControlStateNormal];
        }
        else{
            [btn setImage:[UIImage imageNamed:@"amy"] forState:UIControlStateNormal];
        }
        [self.mView addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mView.top);
            make.right.equalTo(lastView?lastView.left:self.mView.right).offset(-5);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        
        lastView = btn;
    }

}

- (void)singleTap:(UITapGestureRecognizer*)sender {
};

@end

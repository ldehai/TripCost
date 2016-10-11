//
//  memberView.m
//  TripCost
//
//  Created by andy on 15/8/17.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "TripBillView.h"

static NSString * const kTripBillCellReuseIdentifier = @"kTripBillCellReuseIdentifier";

#pragma -
#pragma TripBillViewCell interface
@interface TripBillViewCell ()
@end

#pragma -
#pragma TripBillViewCell implementation
@implementation TripBillViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self ) {
        UIButton *btnAdd = UIButton.new;
        [btnAdd setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(selectMember) forControlEvents:UIControlEventTouchUpInside];
        self.selectbtn = btnAdd;
        [self.contentView addSubview:btnAdd];
        
        UILabel *name = UILabel.new;
        //        name.textColor = [UIColor aventGreenColor];
        self.lbName = name;
        [self.contentView addSubview:name];
        
        UILabel *email = UILabel.new;
        //        email.textColor = [UIColor aventGreenColor];
        self.lbEmail = email;
        [self.contentView addSubview:email];
        
        [name makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left).offset(5);
            make.width.equalTo(@100);
            make.height.equalTo(@25);
        }];
        
        [email makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(name.bottom);
            make.left.equalTo(self.left).offset(5);
            make.width.equalTo(@300);
            make.height.equalTo(@25);
        }];
        
        [btnAdd makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(10);
            make.right.equalTo(self.contentView.right);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return self;
}

- (void)setBill:(TCBill *)bill{
    _bill = bill;
    
//    self.lbName.text = member.strUserName;
//    self.lbEmail.text = member.strEmail;
//    
//    if (self.member.bSelected)
//    {
//        [self.selectbtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.selectbtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    }
}

//- (void)selectMember{
//    if (self.member.bSelected)
//    {
//        [self.selectbtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.selectbtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//    }
//    
//    self.member.bSelected = !self.member.bSelected;
//}

@end

#pragma -
#pragma TripBillView interface
@interface TripBillView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;

@end

#pragma -
#pragma TripBillView implementation
@implementation TripBillView

- (id)init {
    self = [super init];
    
    UITableView *table = UITableView.new;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    [self addSubview:table];
    
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactToMember:) name:MSG_SELECTED_MEMBER object:nil];

    [self.table registerClass:[TripBillViewCell class] forCellReuseIdentifier:kTripBillCellReuseIdentifier];

    return self;
}

- (void)setBills:(RLMResults *)bills{
    _bills = bills;
    
    [self.table reloadData];
}

#pragma -
#pragma tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TripBillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTripBillCellReuseIdentifier forIndexPath:indexPath];
    
    TCBill *bill = [self.bills objectAtIndex:indexPath.row];
    [cell setBill:bill];
    return cell;

}

@end

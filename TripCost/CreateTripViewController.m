//
//  CreateTripViewController.m
//  TripCost
//
//  Created by andy on 15/8/16.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "CreateTripViewController.h"
#import "ChooseMemberViewController.h"
#import "DataModels.h"

@interface CreateTripViewController ()

@property (strong, nonatomic) UITextField *tripname;
@property (strong, nonatomic) NSMutableArray *memberArray;
//@property RLMArray<TCMember> *memberArray;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UIView *mView;

@end

@implementation CreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"New Trip";
    
    UIBarButtonItem *cancelbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCloseClick)];
    self.navigationItem.rightBarButtonItem = cancelbtn;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseMemberFinish:) name:MSG_CHOOSEMEMBER_FINISH object:nil];
    UIView *superview = self.view;
    
    //用户名
    UITextField *textName = UITextField.new;
    textName.placeholder = @"Trip Name";
    self.tripname = textName;
    [superview addSubview:textName];
    
    UILabel *lbMember = UILabel.new;
    lbMember.text = @"Add Friends";
    [superview addSubview:lbMember];
    
    UIView *mView = UIView.new;
    self.mView = mView;
    [superview addSubview:mView];

    UIButton *addbtn = UIButton.new;
    [addbtn setImage:[UIImage imageNamed:@"AddMember"] forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addMember) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:addbtn];    
    
    //确定按钮
    UIButton *btnCommit = [UIButton aventButton];
    [btnCommit addTarget:self action:@selector(btnCreateClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnCommit];
    [btnCommit setTitle:@"Go" forState:UIControlStateNormal];
    
    [textName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(80);
        make.left.equalTo(self.view.left).offset(41);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@35);
    }];
    
    [lbMember makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textName.bottom).offset(10);
        make.left.equalTo(textName.left);
        make.right.equalTo(textName.right);
        make.height.equalTo(@25);
    }];
    
    [addbtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbMember.bottom).offset(10);
        make.left.equalTo(lbMember.left);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [mView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addbtn.top);
        make.left.equalTo(addbtn.left);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@40);
    }];
    
    [btnCommit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addbtn.bottom).offset(25);
        make.left.equalTo(self.view.left).offset(40);
        make.right.equalTo(self.view.right).offset(-40);
        make.height.equalTo(@48);
    }];

}

- (void)btnCloseClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnCreateClick{
    Trip *trip = Trip.new;
    trip.tripid = [[NSUUID UUID] UUIDString];
    trip.name = self.tripname.text;
    trip.creatername = @"andy";
    trip.createrid = @"1";
    [trip.membersArray addObjects:self.memberArray];
    trip.createdate = [self currentTime];
    trip.amount = @"0";

    TCBill *bill = TCBill.new;
    bill.tripid = trip.tripid;
    bill.name = @"南京";
    
    NSLog(@"trip member count:%ld",trip.membersArray.count);
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // Save your object
    [realm beginWriteTransaction];
    [realm addObject:trip];
    [realm commitWriteTransaction];
    
    RLMResults *rt = [Trip allObjects];
    
    NSLog(@"%d",rt.count);

    
    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_ADDTRIP_OK object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addMember{
    ChooseMemberViewController *chooseMember = ChooseMemberViewController.new;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseMember];
    self.nav = nav;
    [self presentViewController:nav animated:NO completion:nil];

}

- (void)chooseMemberFinish:(NSNotification*)notify{
    NSMutableArray *memberArray = notify.object;
    if (!self.memberArray) {
        self.memberArray = [NSMutableArray array];
    }
    [self.memberArray removeAllObjects];
    [self.memberArray addObjectsFromArray:memberArray];
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
            make.left.equalTo(lastView?lastView.right:@40).offset(5);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        
        lastView = btn;
    }
    
    [self.nav dismissViewControllerAnimated:YES completion:nil];
    self.nav = nil;
}

- (NSString*)currentTime{
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    [dF setDateStyle:NSDateFormatterMediumStyle];
    [dF setTimeStyle:NSDateFormatterMediumStyle];
    [dF setDateFormat:@"yyyyMMddHHmmss"];
    
    return [dF stringFromDate:[NSDate date]];
}
@end

//
//  TripBillViewController.m
//  TripCost
//
//  Created by andy on 15/9/7.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "TripBillViewController.h"
#import "TripBillView.h"

@interface TripBillViewController ()
@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) TripBillView* billview;

@end

@implementation TripBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl* segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"账单",@"AA分账", nil]];
    [segment setSelectedSegmentIndex:0];
    [segment setTintColor:[UIColor aventGreenColor]];
    [segment addTarget:self action:@selector(segmentSelectChanged) forControlEvents:UIControlEventValueChanged];
    self.segment = segment;
    [self.view addSubview:segment];
    
    TripBillView *bview = TripBillView.new;
    bview.bills = [TCBill objectsWhere:@"tripid = '%@'",self.trip.tripid];
    self.billview = bview;
    [self.view addSubview:bview];
    
    [segment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(160);
        make.left.equalTo(self.view.left).offset(8);
        make.right.equalTo(self.view.right).offset(-8);
        make.height.equalTo(@25);
    }];

    [bview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.bottom).offset(5);
        make.left.equalTo(self.view.left).offset(15);
        make.right.equalTo(self.view.right).offset(-15);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveBill:) name:MSG_SAVEBILL object:nil];

}

- (void)saveBill:(NSNotification*)notify{
    TCBill *bill = notify.object;
    bill.tripid = self.trip.tripid;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // Save your object
    [realm beginWriteTransaction];
    [realm addObject:bill];
    [realm commitWriteTransaction];
    
    self.billview.bills = [TCBill objectsWhere:@"tripid = '%@'",self.trip.tripid];
}

- (void)segmentSelectChanged{
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

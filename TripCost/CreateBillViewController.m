//
//  CreateBillViewController.m
//  TripCost
//
//  Created by andy on 15/9/7.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "CreateBillViewController.h"
#import "DataModels.h"


@interface CreateBillViewController ()

@property (strong,nonatomic) TCBill *bill;
@end

@implementation CreateBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TCBill *bi = TCBill.new;
    bi.name = @"hello";
    self.bill = bi;
    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_SAVEBILL object:self.bill];
}

@end

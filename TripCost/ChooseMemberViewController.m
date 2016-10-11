//
//  ChooseMemberViewController.m
//  TripCost
//
//  Created by andy on 15/8/16.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "ChooseMemberViewController.h"
#import "MemberView.h"
#import "ContactView.h"

@interface ChooseMemberViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISegmentedControl *memberSegment;
@property (strong, nonatomic) MemberView *memberView;
@property (strong, nonatomic) ContactView *contactView;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation ChooseMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加好伙伴";
    UIBarButtonItem *cancelbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCloseClick)];
    self.navigationItem.leftBarButtonItem = cancelbtn;

    UIBarButtonItem *okbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnOkClick)];
    self.navigationItem.rightBarButtonItem = okbtn;

    
    UISearchBar *searchBar = UISearchBar.new;
    searchBar.placeholder = @"Search by name or email...";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar = searchBar;
    [self.view addSubview:searchBar];
    
    UISegmentedControl* segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Friends",@"Contacts", nil]];
    [segment setSelectedSegmentIndex:0];
    [segment setTintColor:[UIColor aventGreenColor]];
    [segment addTarget:self action:@selector(segmentSelectChanged) forControlEvents:UIControlEventValueChanged];
    self.memberSegment = segment;
    [self.view addSubview:segment];
    
    MemberView *mview = MemberView.new;
    self.memberView = mview;
    [self.view addSubview:self.memberView];
    
    [searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(80);
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.height.equalTo(@35);
    }];
    
    [segment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.bottom).offset(5);
        make.left.equalTo(searchBar.left).offset(8);
        make.right.equalTo(searchBar.right).offset(-8);
        make.height.equalTo(@25);
    }];
    
    [mview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.bottom).offset(5);
        make.left.equalTo(self.view.left).offset(15);
        make.right.equalTo(self.view.right).offset(-15);
        make.bottom.equalTo(self.view.bottom);
    }];
    
}

- (void)segmentSelectChanged{
    [self.searchBar resignFirstResponder];
    
    if ([self.memberSegment selectedSegmentIndex] == 1 && !self.contactView) {
        ContactView *cview = ContactView.new;
        self.contactView = cview;
        [self.view addSubview:self.contactView];
        
        [cview makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.memberView);
        }];
    }
    
    if ([self.memberSegment selectedSegmentIndex] == 0) {
        [self.memberView setHidden:NO];
        [self.contactView setHidden:YES];
    }
    else{
        [self.memberView setHidden:YES];
        [self.contactView setHidden:NO];
    }
}

- (void)btnCloseClick{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)btnOkClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_CHOOSEMEMBER_FINISH object:self.memberView.memberArray];
}
@end

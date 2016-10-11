//
//  ViewController.m
//  TripCost
//
//  Created by andy on 15/8/11.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <Realm/Realm.h>
#import "ViewController.h"
#import "DataModels.h"
#import "IntroViewController.h"
#import "ProfileViewController.h"
#import "CreateTripViewController.h"
#import "TripBillViewController.h"
#import "TripViewCell.h"

static NSString * const kTripCellReuseIdentifier = @"kTripCellReuseIdentifier";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IntroViewController* introView;
@property (strong, nonatomic) UITableView* table;
//@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) RLMResults *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TripCost";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewTrip)];
    self.navigationItem.rightBarButtonItem = addButton;

    UIBarButtonItem *profileBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Profile"] style:UIBarButtonItemStylePlain target:self action:@selector(openProfile)];
    self.navigationItem.leftBarButtonItem = profileBtn;

    
    UITableView *table = UITableView.new;
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsHorizontalScrollIndicator = FALSE;
    table.showsVerticalScrollIndicator = FALSE;
    self.table = table;
    [self.view addSubview:self.table];
    
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.top.equalTo(self.view.top);
//        make.left.equalTo(self.view.left);
//        make.right.equalTo(self.view.right);
//        make.bottom.equalTo(self.view.bottom);
    }];

    [self.table registerClass:[TripViewCell class] forCellReuseIdentifier:kTripCellReuseIdentifier];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSuccess) name:MSG_SIGNUP_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSuccess) name:MSG_SIGNIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTrip) name:MSG_LOADTRIP_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:MSG_ADDTRIP_OK object:nil];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUsername = [user valueForKey:@"username"];
    if ([strUsername isEqualToString:@""]) {
        [self performSelector:@selector(presentIntroView) withObject:self afterDelay:0];
    }
    else{
        [self initData];
       // [self loadTrips];
    }
}

- (void)addNewTrip{
    CreateTripViewController *newtrip = CreateTripViewController.new;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newtrip];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)openProfile{
    ProfileViewController *profile = ProfileViewController.new;
    [self.navigationController pushViewController:profile animated:YES];
    
}

- (void)initData{
//    if (!self.dataArray) {
//        self.dataArray = [NSMutableArray array];
//    }
//    [self.dataArray removeAllObjects];
//    self.dataArray = [[TCSingletonDB sharedDB] loadTrip];
    NSString *strPath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"%@",strPath);
    
    self.dataArray = [Trip allObjects];
    
    [self.table reloadData];
}

- (void)loadTrips{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strToken = [user valueForKey:@"token"];
    if (!strToken) {
        return;
    }

    [SVProgressHUD show];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    NSDictionary *parameters = @{
                                 @"token": strToken
                                 };
    
    [manager POST:@"/api/mytrip" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *result = [responseObject valueForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            
            self.dataArray = [responseObject mutableArrayValueForKey:@"data"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_LOADTRIP_SUCCESS object:nil];
        }
        
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)refreshTrip{
    [self.table reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TripViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTripCellReuseIdentifier forIndexPath:indexPath];
    
    Trip *trip = [self.dataArray objectAtIndex:indexPath.row];
    [cell setTrip:trip];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Trip *trip = [self.dataArray objectAtIndex:indexPath.row];
    
    TripBillViewController *billview = TripBillViewController.new;
    billview.trip = trip;
    [self.navigationController pushViewController:billview animated:YES];
    
}

- (void)presentIntroView{
    IntroViewController *intro = [[IntroViewController alloc]init];
    self.introView = intro;
    [self presentViewController:self.introView animated:NO completion:nil];
}

- (void)signSuccess{
    
}

@end

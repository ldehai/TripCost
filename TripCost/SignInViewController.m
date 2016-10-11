//
//  SignInViewController.m
//  TripCost
//
//  Created by andy on 15/8/11.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (strong, nonatomic) UITextField *userEmail;
@property (strong, nonatomic) UITextField *userPwd;
@property (strong, nonatomic) UILabel *tip;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *superview = self.view;
    UILabel *titlelab = UILabel.new;
    titlelab.font = [UIFont systemFontOfSize:20];
    titlelab.text = @"Sign In";
    titlelab.textAlignment = NSTextAlignmentCenter;
    [superview addSubview:titlelab];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setFrame:CGRectMake(16, 41, 26, 26)];
    [btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnClose];
    [btnClose setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    
    [titlelab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(34);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    //邮箱
    UITextField *textEmail = UITextField.new;
    textEmail.placeholder = @"Email";
    textEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.userEmail = textEmail;
    [superview addSubview:self.userEmail];
    
    UIView *lineView = UIView.new;
    lineView.backgroundColor = [UIColor colorWithHexString:@"#979797"];
    lineView.alpha = 0.39;
    [superview addSubview:lineView];
    
    //密码
    UITextField *textPasword = UITextField.new;
    textPasword.placeholder = @"Password";
    [textPasword setSecureTextEntry:YES];
    self.userPwd = textPasword;
    [superview addSubview:self.userPwd];
    
    //提示信息
    UILabel *tiplab = UILabel.new;
    tiplab.font = [UIFont systemFontOfSize:14];
    tiplab.text = @"";
    tiplab.textColor = [UIColor redColor];
    tiplab.textAlignment = NSTextAlignmentLeft;
    self.tip = tiplab;
    [superview addSubview:tiplab];

    //登录按钮
    UIButton *btnSignIn = [UIButton aventButton];
    [btnSignIn addTarget:self action:@selector(btnSignInClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnSignIn];
    [btnSignIn setTitle:@"Sign In" forState:UIControlStateNormal];
    
    [titlelab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(34);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [textEmail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlelab.bottom).offset(10);
        make.left.equalTo(self.view.left).offset(41);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@35);
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textEmail.bottom).offset(5);
        make.left.equalTo(self.view.left).offset(41);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@1);
    }];
    
    [textPasword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(5);
        make.left.equalTo(self.view.left).offset(41);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@35);
    }];
    
    [tiplab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textPasword.bottom).offset(0);
        make.left.equalTo(self.view.left).offset(41);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@0);
    }];

    [btnSignIn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tiplab.bottom).offset(25);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@59);
    }];

}

- (void)btnCloseClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnSignInClick{
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    NSDictionary *parameters = @{@"email": self.userEmail.text,
                                 @"password": self.userPwd.text};
    
    [manager POST:@"api/signin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *result = [responseObject valueForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSString* strUserName = [responseObject valueForKey:@"username"];
            NSString *token = [responseObject valueForKey:@"token"];
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setValue:strUserName forKey:@"username"];
            [userdefault setValue:self.userEmail.text forKey:@"email"];
            [userdefault setValue:self.userPwd.text forKey:@"password"];
            [userdefault setValue:token forKey:@"token"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_SIGNIN_SUCCESS object:nil];
        }
        else{
            NSString *errmsg = [responseObject valueForKey:@"errormsg"];
            NSLog(@"%@",errmsg);
            self.tip.text = errmsg;
            
            [self.tip updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userPwd.bottom).offset(10);
                make.left.equalTo(self.view.left).offset(41);
                make.right.equalTo(self.view.right).offset(-41);
                make.height.equalTo(@15);
            }];
            
            // tell constraints they need updating
            [self.view setNeedsUpdateConstraints];
            
            // update constraints now so we can animate the change
            [self.view updateConstraintsIfNeeded];
            
            [UIView animateWithDuration:0.4 animations:^{
                [self.view layoutIfNeeded];
            }];
            
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"Error: %@", error);
    }];
    
}
@end

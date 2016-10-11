//
//  SignUpViewController.m
//  TripCost
//
//  Created by andy on 15/8/11.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (strong, nonatomic) UITextField *userName;
@property (strong, nonatomic) UITextField *userEmail;
@property (strong, nonatomic) UITextField *userPwd;
@property (strong, nonatomic) UILabel *tip;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *superview = self.view;
    
    //标题
    UILabel *titlelab = UILabel.new;
    titlelab.font = [UIFont systemFontOfSize:20];
    titlelab.text = @"Sign Up";
    titlelab.textAlignment = NSTextAlignmentCenter;
    [superview addSubview:titlelab];

    //关闭按钮
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setFrame:CGRectMake(16, 41, 26, 26)];
    [btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnClose];
    [btnClose setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    
    //用户名
    UITextField *textName = UITextField.new;
    textName.placeholder = @"Full Name";
    self.userName = textName;
    [superview addSubview:textName];
    
    //邮箱
    UITextField *textEmail = UITextField.new;
    textEmail.placeholder = @"Email";
    textEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.userEmail = textEmail;
    [superview addSubview:textEmail];
    
    UIView *lineView = UIView.new;
    lineView.backgroundColor = [UIColor colorWithHexString:@"#979797"];
    lineView.alpha = 0.39;
    [superview addSubview:lineView];
    
    //密码
    UITextField *textPasword = UITextField.new;
    textPasword.placeholder = @"Password";
    [textPasword setSecureTextEntry:YES];
    self.userPwd = textPasword;
    [superview addSubview:textPasword];
    
    //提示信息
    UILabel *tiplab = UILabel.new;
    tiplab.font = [UIFont systemFontOfSize:14];
    tiplab.text = @"";
    tiplab.textColor = [UIColor redColor];
    tiplab.textAlignment = NSTextAlignmentLeft;
    self.tip = tiplab;
    [superview addSubview:tiplab];
    
    //注册按钮
    UIButton *btnSignUp = [UIButton aventButton];
    [btnSignUp addTarget:self action:@selector(btnSignUpClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnSignUp];
    [btnSignUp setTitle:@"Sign Up" forState:UIControlStateNormal];

    [titlelab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(34);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [textName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlelab.bottom).offset(10);
        make.left.equalTo(self.view.left).offset(41);
        make.right.equalTo(self.view.right).offset(-41);
        make.height.equalTo(@35);
    }];
    [textEmail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textName.bottom).offset(5);
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
    
    [btnSignUp makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tiplab.bottom).offset(25);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@59);
    }];
}

- (void)btnCloseClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnSignUpClick{
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    NSDictionary *parameters = @{@"username": self.userName.text,
                                 @"email": self.userEmail.text,
                                 @"password": self.userPwd.text};
    
    [manager POST:@"/api/signup" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *result = [responseObject valueForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSString *token = [responseObject valueForKey:@"token"];
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setValue:self.userName.text forKey:@"username"];
            [userdefault setValue:self.userEmail.text forKey:@"email"];
            [userdefault setValue:self.userPwd.text forKey:@"password"];
            [userdefault setValue:token forKey:@"token"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_SIGNUP_SUCCESS object:nil];
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
        NSLog(@"Error: %@", error);
    }];
    
}
@end

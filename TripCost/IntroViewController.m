//
//  IntroViewController.m
//  TripCost
//
//  Created by andy on 15/8/11.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "IntroViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface IntroViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIPageControl* pageControl;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSuccess) name:MSG_SIGNUP_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSuccess) name:MSG_SIGNIN_SUCCESS object:nil];


    UIView *superview = self.view;
    
    //scrollview
    UIScrollView *scrollView = UIScrollView.new;
    [scrollView setPagingEnabled:YES];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    [superview addSubview:scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self generateContent];
    
    UIPageControl *pageControl = UIPageControl.new;
    self.pageControl = pageControl;
    [pageControl setNumberOfPages:3];
    [superview addSubview:pageControl];
    
    [pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(-65);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
    
    UIButton *btnSignUp = [UIButton aventButton];
    [btnSignUp addTarget:self action:@selector(btnSignUpClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnSignUp];
    [btnSignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    
    [btnSignUp makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(0);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.mas_centerX).offset(-1);
        make.height.equalTo(@55);
    }];
    
    UIButton *btnSignIn = [UIButton aventButton];
    [btnSignIn addTarget:self action:@selector(btnSignInClick) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:btnSignIn];
    [btnSignIn setTitle:@"Sign In" forState:UIControlStateNormal];
    
    [btnSignIn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(0);
        make.left.equalTo(self.view.mas_centerX).offset(1);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@55);
    }];
    
}

//生成介绍页面
- (void)generateContent {
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    UIView *lastView;
    
    for (int i = 1; i < 4; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"page%d.jpg",i];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [contentView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(lastView ? lastView.right : @0);
            make.width.equalTo(self.view.width);
            make.height.equalTo(self.view.height);
        }];
        
        lastView = image;
    }
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.right);
    }];
}

- (void)btnSignUpClick{
    SignUpViewController *signUp = SignUpViewController.new;
    
    [self presentViewController:signUp animated:YES completion:nil];
    
}

- (void)btnSignInClick{
    SignInViewController *signIn = SignInViewController.new;
    
    [self presentViewController:signIn animated:YES completion:nil];
}

//翻页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int xoffset = scrollView.contentOffset.x;
    
    int pageNumber = xoffset/self.view.frame.size.width;
    
    [self.pageControl setCurrentPage:pageNumber];
}

- (void)signSuccess{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end

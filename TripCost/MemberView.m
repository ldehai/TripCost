//
//  memberView.m
//  TripCost
//
//  Created by andy on 15/8/17.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "MemberView.h"

static NSString * const kMemberCellReuseIdentifier = @"kMemberCellReuseIdentifier";

#pragma -
#pragma MemberCellView interface
@interface MemberViewCell ()
@end

#pragma -
#pragma MemberCellView implementation
@implementation MemberViewCell

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

- (void)setMember:(TCMember*)member{
    _member = member;
    
    self.lbName.text = member.strUserName;
    self.lbEmail.text = member.strEmail;
    
    if (self.member.bSelected)
    {
        [self.selectbtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectbtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
}

- (void)selectMember{
    if (self.member.bSelected)
    {
        [self.selectbtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectbtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    
    self.member.bSelected = !self.member.bSelected;
}

@end

#pragma -
#pragma MemberView interface
@interface MemberView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;

@end

#pragma -
#pragma MemberView implementation
@implementation MemberView

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactToMember:) name:MSG_SELECTED_MEMBER object:nil];
    
    if (!self.memberArray) {
        self.memberArray = [NSMutableArray array];
    }

    [self.table registerClass:[MemberViewCell class] forCellReuseIdentifier:kMemberCellReuseIdentifier];

    return self;
}

- (void)addContactToMember:(NSNotification *)notification{
    TCContact* contact = (TCContact*)notification.object;
    TCMember* member = [[TCMember alloc] initWithContact:contact];
    member.bSelected = TRUE;
    
    [self.memberArray addObject:member];
    
    [self.table reloadData];
}

#pragma -
#pragma tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemberCellReuseIdentifier forIndexPath:indexPath];
    
    TCMember *member = [self.memberArray objectAtIndex:indexPath.row];
    [cell setMember:member];
    return cell;

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MSG_SELECTED_MEMBER object:nil];
}
@end

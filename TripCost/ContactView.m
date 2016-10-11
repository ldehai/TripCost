//
//  contactView.m
//  TripCost
//
//  Created by andy on 15/8/17.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "ContactView.h"
#import <AddressBook/AddressBook.h>

static NSString * const kContactCellReuseIdentifier = @"kContactCellReuseIdentifier";

#pragma mark -
#pragma mark ContacetCellView interface
@interface ContactViewCell ()
@end

#pragma mark -
#pragma mark ContacetCellView implementation
@implementation ContactViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self ) {
        UIButton *btnAdd = UIButton.new;
        [btnAdd setImage:[UIImage imageNamed:@"AddMember"] forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(addmember) forControlEvents:UIControlEventTouchUpInside];
        self.selectbtn = btnAdd;
        [self.contentView addSubview:btnAdd];
        
        UILabel *name = UILabel.new;
        self.lbName = name;
        [self.contentView addSubview:name];

        UILabel *email = UILabel.new;
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

- (void)setContact:(TCContact*)contact{
    _contact = contact;
    
    self.lbName.text = contact.strUserName;
    self.lbEmail.text = contact.strEmail;
}

- (void)addmember{

    [self.selectbtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [self.selectbtn setUserInteractionEnabled:FALSE];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_SELECTED_MEMBER object:self.contact];
}

@end

#pragma mark -
#pragma mark ContactView interface
@interface ContactView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (nonatomic) ABAddressBookRef addressBook;

@end

#pragma mark -
#pragma mark ContactView implementation
@implementation ContactView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UITableView *table = UITableView.new;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    [self addSubview:table];
    
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (!self.contactArray) {
        self.contactArray = [NSMutableArray array];
    }

    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    [self checkAddressBookAccess];
    
    [self.table registerClass:[ContactViewCell class] forCellReuseIdentifier:kContactCellReuseIdentifier];

    return self;
}

#pragma mark -
#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"请到系统设置中授权TripCost访问您的通讯录"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    ContactView * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (granted)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakSelf accessGrantedForAddressBook];
                                                         
                                                     });
                                                 }
                                             });
}

// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook
{
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    for (id record in allContacts){
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        NSString *strFirstName = (__bridge NSString*)ABRecordCopyValue(thisContact,kABPersonFirstNameProperty);
        ABMultiValueRef emailProperty = ABRecordCopyValue(thisContact, kABPersonEmailProperty);
        NSArray* emailArray = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(emailProperty);
        CFRelease(emailProperty);
        
        NSString *strNickName = (__bridge NSString*)ABRecordCopyValue(thisContact,kABPersonNicknameProperty);
        
        if (emailArray.count > 0) {
            TCContact *contact = TCContact.new;
            contact.strUserName = strFirstName;
            contact.strEmail = [emailArray objectAtIndex:0];
            
            [self.contactArray addObject:contact];
            
        }
    }

    [self.table reloadData];
}

#pragma mark -
#pragma mark tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCellReuseIdentifier forIndexPath:indexPath];

    TCContact *contact = [self.contactArray objectAtIndex:indexPath.row];
    [cell setContact:contact];
    return cell;

}

- (void)dealloc{
    
}
@end

//
//  IMFriendRequestViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMFriendRequestViewController.h"

//Third party
#import "BDKNotifyHUD.h"
#import "MBProgressHUD.h"

//IMSDK Headers
#import "IMMyself+Relationship.h"

@interface IMFriendRequestViewController ()<UITableViewDataSource, UITextFieldDelegate>

- (void)rightBarButtonItemClick;

@end

@implementation IMFriendRequestViewController {
    UITableView *_tableView;
    UITextField *_textField;
    UIBarButtonItem *_rightBarButtonItem;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
    MBProgressHUD *_hud;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    
    [_tableView setDataSource:self];
    [[self view] addSubview:_tableView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    [_tableView setTableHeaderView:tableHeaderView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 310, 40)];
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"你需要发送验证申请，等对方通过"];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [tableHeaderView addSubview:label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    [_textField setDelegate:self];
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClick {
    [[self view] endEditing:YES];
    
    if (_hud) {
        [_hud hide:YES];
        [_hud removeFromSuperview];
        _hud = nil;
    }
    _hud = [[MBProgressHUD alloc] initWithView:[self view]];
    
    [[self view] addSubview:_hud];
    [_hud setLabelText:@"请稍候..."];
    [_hud show:YES];
    
    [g_pIMMyself sendFriendRequest:[_textField text] toUser:_customUserID success:^{
        [_hud hide:YES];
        [_hud removeFromSuperview];
        _hud = nil;
        
        _notifyText = @"发送好友请求成功";
        _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
        [self displayNotifyHUD];
        
        [[self navigationController] popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [_hud hide:YES];
        [_hud removeFromSuperview];
        _hud = nil;
        
        _notifyText = @"发送好友请求失败";
        _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
        [self displayNotifyHUD];
    }];
}


#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    
    return NO;
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    [[cell contentView] addSubview:_textField];
    
    return cell;
}


#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil){
        return _notify;
    }
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:_notifyImage text:_notifyText];
    [_notify setCenter:CGPointMake(self.tabBarController.view.center.x, self.tabBarController.view.center.y - 20)];
    return _notify;
}

- (void)displayNotifyHUD {
    if (_notify) {
        [_notify removeFromSuperview];
        _notify = nil;
    }
    
    [self.tabBarController.view addSubview:[self notify]];
    [[self notify] presentWithDuration:1.0f speed:0.5f inView:self.tabBarController.view completion:^{
        [[self notify] removeFromSuperview];
    }];
}


@end

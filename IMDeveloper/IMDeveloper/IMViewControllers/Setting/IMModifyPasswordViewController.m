//
//  ModifyPasswordViewController.m
//  IMSDK
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMModifyPasswordViewController.h"
#import "IMDefine.h"

#import "BDKNotifyHUD.h"
#import "MBProgressHUD.h"

//IMSDK Headers
#import "IMMyself+UserPassword.h"

@interface IMModifyPasswordViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation IMModifyPasswordViewController {
    UITableView *_tableView;
    UITextField *_oldPasswordField;
    UITextField *_newPasswordField;
    UITextField *_confirmField;
    UIBarButtonItem *_rightBarButtonItem;
    
    MBProgressHUD *_hud;
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
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
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [[self view] addSubview:_tableView];
    
    _oldPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 190, 40)];
    
    [_oldPasswordField setPlaceholder:@"请输入当前密码"];
    [_oldPasswordField setSecureTextEntry:YES];
    [_oldPasswordField setBorderStyle:UITextBorderStyleNone];
    [_oldPasswordField setDelegate:self];
    [_oldPasswordField becomeFirstResponder];
    [_oldPasswordField setFont:[UIFont systemFontOfSize:16]];
    [_oldPasswordField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_oldPasswordField setTextColor:[UIColor lightGrayColor]];
    [_oldPasswordField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _newPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 190, 40)];
    
    [_newPasswordField setPlaceholder:@"不能超过16位"];
    [_newPasswordField setSecureTextEntry:YES];
    [_newPasswordField setBorderStyle:UITextBorderStyleNone];
    [_newPasswordField setDelegate:self];
    [_newPasswordField setFont:[UIFont systemFontOfSize:16]];
    [_newPasswordField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_newPasswordField setTextColor:[UIColor lightGrayColor]];
    [_newPasswordField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _confirmField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 190, 40)];
    
    [_confirmField setPlaceholder:@"请再次输入新密码"];
    [_confirmField setSecureTextEntry:YES];
    [_confirmField setBorderStyle:UITextBorderStyleNone];
    [_confirmField setDelegate:self];
    [_confirmField setFont:[UIFont systemFontOfSize:16]];
    [_confirmField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_confirmField setTextColor:[UIColor lightGrayColor]];
    [_confirmField setClearButtonMode:UITextFieldViewModeWhileEditing];
 
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];

}

- (void)rightBarButtonClick:(id)sender {
    if (sender == _rightBarButtonItem) {
        if ([[_oldPasswordField text] length] == 0) {
            _notifyText = @"请输入当前密码";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return;
        }
        
        if ([[_newPasswordField text] length] == 0) {
            _notifyText = @"请输入新密码";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return;
        }
        
        if ([[_confirmField text] length] == 0) {
            _notifyText = @"请重复密码";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return;
        }
        
        if (![[_newPasswordField text] isEqualToString:[_confirmField text]]) {
            _notifyText = @"两次输入密码不一致";
            _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
            [self displayNotifyHUD];
            
            return;
        }
        
        if (_hud) {
            [_hud hide:YES];
            [_hud removeFromSuperview];
            _hud = nil;
        }
        
        _hud = [[MBProgressHUD alloc] initWithView:[[self tabBarController] view]];
        
        [[[self tabBarController] view] addSubview:_hud];
        [_hud setLabelText:@"请稍候..."];
        [_hud show:YES];
        
        [g_pIMMyself modifyOldPassword:[_oldPasswordField text]
                         toNewPassword:[_newPasswordField text] success:^{
                             [_hud hide:YES];
                             [_hud removeFromSuperview];
                             _hud = nil;
                             
                             _notifyText = @"修改成功";
                             _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
                             [self displayNotifyHUD];
                                }
                               failure:^(NSString *error) {
                                   [_hud hide:YES];
                                   [_hud removeFromSuperview];
                                   _hud = nil;
                                   
                                   if ([error isEqualToString:@"new password couldn't be equal to original password"]) {
                                       error = @"新密码不能和原密码一致";
                                   } else if ([error isEqualToString:@"original password is wrong"]) {
                                       error = @"当前密码错误";
                                   } else {
                                       error = @"修改失败";
                                   }
                                   
                                   _notifyText = error;
                                   _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                                   [self displayNotifyHUD];
                               }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[self view] endEditing:YES];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField text] length] + [string length] > 16 ) {
        
        return NO;
    }
    
    return YES;
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    switch ([indexPath row]) {
        case 0:
        {
            [[cell textLabel] setText:@"当前密码"];
            [[cell contentView] addSubview:_oldPasswordField];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:16]];
        }
            break;
        case 1:
        {
            [[cell textLabel] setText:@"新密码"];
            [[cell contentView] addSubview:_newPasswordField];
        }
            break;
        case 2:
        {
            [[cell textLabel] setText:@"重复密码"];
            [[cell contentView] addSubview:_confirmField];
        }
            break;
        default:
            break;
    }
    
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

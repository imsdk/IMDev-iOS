//
//  IMCreateGroupViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMCreateGroupViewController.h"
#import "IMGroupListViewController.h"

//Third party
#import "MBProgressHUD.h"
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMMyself+Group.h"

@interface IMCreateGroupViewController () <IMGroupDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation IMCreateGroupViewController{
    UITableView *_tableView;
    UITextField *_textField;
    UIBarButtonItem *_rightBarButtonItem;
    
    MBProgressHUD *_hud;
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (void)viewDidLoad {
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
    [label setText:@"请填写群名称，不能超过10个字符"];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [tableHeaderView addSubview:label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    [_textField setDelegate:self];
    [_textField becomeFirstResponder];
}

- (void)rightBarButtonItemClick {
    if ([[_textField text] length] == 0) {
        _notifyText = @"请填写群名称";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        [self displayNotifyHUD];
        return;
    }
    
    if (_hud) {
        [_hud hide:YES];
        [_hud removeFromSuperview];
        _hud = nil;
    }
    _hud = [[MBProgressHUD alloc] initWithView:[self view]];
    
    [[self view] addSubview:_hud];
    [_hud setLabelText:@"请稍候..."];
    [_hud show:YES];
    
    [g_pIMMyself createGroupWithName:[_textField text] success:^(NSString *groupID) {
        _notifyText = @"创建群组成功";
        _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
        [self displayNotifyHUD];
        
        for (UIViewController *controller in [[self navigationController] viewControllers]) {
            if ([controller isKindOfClass:[IMGroupListViewController class]]) {
                [[self navigationController] popToViewController:controller animated:YES];
                return ;
            }
        }

        [[self navigationController] popViewControllerAnimated:YES];

    } failure:^(NSString *error) {
        if ([error isEqualToString:@"You have already found a group." ]) {
            error = @"你已经创建了一个群";
        } else {
            error = @"创建群组失败";
        }
        
        _notifyText = error;
        _notifyImage = [UIImage imageNamed:@"IM_failed_image"];
        [self displayNotifyHUD];
        
    }];
}


#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField text] length] + [string length] > 10 ) {
        _notifyText = @"群组名称不能超过10个字符";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        [self displayNotifyHUD];
        return NO;
    }
    
    return YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

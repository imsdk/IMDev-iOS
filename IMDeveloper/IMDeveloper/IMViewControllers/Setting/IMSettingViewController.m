//
//  IMSettingViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMSettingViewController.h"
#import "IMDefine.h"
#import "IMMyselfInfoViewController.h"
#import "IMSettingTableViewCell.h"
#import "IMModifyPasswordViewController.h"
#import "IMBlackListViewController.h"

#import "MBProgressHUD.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+CustomUserInfo.h"

@interface IMSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

- (void)logoutBtnClick:(id)sender;

@end

@implementation IMSettingViewController {
    UITableView *_tableView;
    UIButton *_logoutBtn;
    
    MBProgressHUD *_hud;
    
    BOOL isLogouting;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"我的"];
        [_titleLabel setText:@"我的"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"IM_setting_normal.png"]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setBackgroundColor:RGB(242, 242, 242)];
    [[self view] addSubview:_tableView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableHeaderView:tableHeaderView];
    
    UIView *tableFooterView = [[UIView alloc] init];
    
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:tableFooterView];
    
    [g_pIMSDK requestMainPhotoOfUser:[g_pIMMyself customUserID] success:^(UIImage *mainPhoto) {
        [_tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
//    _logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 200, 240, 40)];
//    
//    [_logoutBtn setBackgroundColor:RGB(210, 0, 8)];
//    [[_logoutBtn layer] setCornerRadius:5.0f];
//    [_logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
//    [tableFooterView addSubview:_logoutBtn];
//    
//    [_logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:IMCustomUserInfoDidInitializeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:IMReloadMainPhotoNotification([g_pIMMyself customUserID]) object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutBtnClick:(id)sender {
//    if (sender != _logoutBtn) {
//        return;
//    }
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定注销" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil];
//    
//    [actionSheet showFromTabBar:[self tabBarController].tabBar];
}


#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
       
        if (_hud) {
            [_hud hide:YES];
            [_hud removeFromSuperview];
            _hud = nil;
        }
        _hud = [[MBProgressHUD alloc] initWithView:[[self tabBarController] view]];
        
        [[[self tabBarController] view] addSubview:_hud];
        [_hud setLabelText:@"正在注销..."];
        [_hud show:YES];
        
        [g_pIMMyself logoutOnSuccess:^(NSString *reason) {
            [_hud hide:YES];
            [_hud removeFromSuperview];
            _hud = nil;
        } failure:^(NSString *error) {
            [_hud hide:YES];
            [_hud removeFromSuperview];
            _hud = nil;
        }];
    } else {
        isLogouting = NO;
    }
}


#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if ([indexPath section] == 0) {
        cell = nil;
        
        cell = [[IMSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImage *headPhoto = [g_pIMSDK mainPhotoOfUser:[g_pIMMyself customUserID]];
        
        if (headPhoto == nil) {
            headPhoto = [UIImage imageNamed:@"IM_head_default.png"];
        }
        
        [(IMSettingTableViewCell *)cell setHeadPhoto:headPhoto];
        
        NSString *customInfo = [g_pIMMyself customUserInfo];
        
        NSArray *array = [customInfo componentsSeparatedByString:@"\n"];
        
        NSString *location = nil;
        if ([array count] > 2) {
            location = [array objectAtIndex:1];
        }
        
        if (location == nil) {
            location = @"未填写";
        }
        
        [(IMSettingTableViewCell *)cell setLocation:location];
        [(IMSettingTableViewCell *)cell setCustomUserID:[g_pIMMyself customUserID]];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if([indexPath section] == 1 && [indexPath row] == 0) {
        [[cell textLabel] setText:@"黑名单用户"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:18]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if ([indexPath section] == 1 &&[indexPath row] == 1) {
        [[cell textLabel] setText:@"修改密码"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:18]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [[cell textLabel] setText:@"退出登录"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:18]];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return 80;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}


#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath section] == 0) {
        IMMyselfInfoViewController *controller = [[IMMyselfInfoViewController alloc] init];
        
        [controller setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:controller animated:YES];
    } else if ([indexPath section] == 1 && [indexPath row] == 0) {
        IMBlackListViewController *controller = [[IMBlackListViewController alloc] init];
        
        [controller setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:controller animated:YES];
    } else if ([indexPath section] == 1 && [indexPath row] == 1) {
        IMModifyPasswordViewController *controller = [[IMModifyPasswordViewController alloc] init];
        
        [controller setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:controller animated:YES];
    } else {
        if (isLogouting) {
            return;
        }
        
        isLogouting = YES;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，也不会收到任何推送消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
        [actionSheet showFromTabBar:[self tabBarController].tabBar];
    }
}


#pragma mark - notification

- (void)reloadData:(NSNotification *)notification {
    [_tableView reloadData];
}

@end

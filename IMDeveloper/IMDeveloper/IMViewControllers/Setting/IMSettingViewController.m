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
#import "IMVersionInformationViewController.h"
#import "IMUserDialogViewController.h"

#import "MBProgressHUD.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+CustomUserInfo.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMSDK+Nickname.h"

@interface IMSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@end

@implementation IMSettingViewController {
    UITableView *_tableView;
    UIButton *_logoutBtn;
    UISwitch *_soundSwitch;
    UISwitch *_shakeSwitch;
    
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
        [[self tabBarItem] setImage:[UIImage imageNamed:@"tab_me.png"]];
        [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"tab_me_.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 114;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification object:[g_pIMMyself customUserID]];
    } failure:^(NSString *error) {
        
    }];
    
    _soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 60, 5, 60, 34)];
    
    [_soundSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    _shakeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 60, 5, 60, 34)];
    
    [_shakeSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:IMCustomUserInfoDidInitializeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:IMReloadMainPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:IMLogoutNotification object:nil];
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

- (void)switchValueChanged:(id)sender {
    if (sender == _soundSwitch) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_soundSwitch.isOn] forKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_soundSwitch.isOn] forKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
        
        [g_pIMMyself logout];
    } else {
        isLogouting = NO;
    }
}

- (void)didLogout {
    [_hud hide:YES];
    [_hud removeFromSuperview];
    _hud = nil;
}


#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
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
            NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:[g_pIMMyself customUserID]];
            
            NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
            NSString *sex = nil;
            
            if ([customInfoArray count] > 0) {
                sex = [customInfoArray objectAtIndex:0];
            }
            
            if ([sex isEqualToString:@"女"]) {
                headPhoto = [UIImage imageNamed:@"IM_head_female.png"];
            } else {
                headPhoto = [UIImage imageNamed:@"IM_head_male.png"];
            }

        }
        
        [(IMSettingTableViewCell *)cell setHeadPhoto:headPhoto];
        
        NSString *nickname = [g_pIMSDK nicknameOfUser:[g_pIMMyself customUserID]];
        
        if ([nickname length] == 0) {
            nickname = [g_pIMMyself customUserID];
        }
        
        [(IMSettingTableViewCell *)cell setNickname:nickname];
        
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
    }else if ([indexPath section] == 2 && [indexPath row] == 0) {
        [[cell textLabel] setText:@"声音"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:18]];
        
        if (![[[cell contentView] subviews] containsObject:_soundSwitch]) {
            [cell addSubview:_soundSwitch];
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSNumber *sound = [userDefault objectForKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
        
        if (!sound) {
            [_soundSwitch setOn:YES];
            [userDefault setObject:[NSNumber numberWithBool:_soundSwitch.isOn] forKey:[NSString stringWithFormat:@"sound:%@",[g_pIMMyself customUserID]]];
            [userDefault synchronize];
        } else {
            [_soundSwitch setOn:[sound boolValue]];
        }
    }else if ([indexPath section] == 2 && [indexPath row] == 1) {
        [[cell textLabel] setText:@"震动"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:18]];
        
        if (![[[cell contentView] subviews] containsObject:_shakeSwitch]) {
            [cell addSubview:_shakeSwitch];
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSNumber *shake = [userDefault objectForKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
        
        if (!shake) {
            [_shakeSwitch setOn:YES];
            [userDefault setObject:[NSNumber numberWithBool:_shakeSwitch.isOn] forKey:[NSString stringWithFormat:@"shake:%@",[g_pIMMyself customUserID]]];
            [userDefault synchronize];
        } else {
            [_shakeSwitch setOn:[shake boolValue]];
        }
        
    }else if ([indexPath section] == 3) {
        [[cell textLabel] setText:@"联系客服"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:18]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
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
    } else if ([indexPath section] == 2) {
        return;
    } else if ([indexPath section] == 3) {
//        IMVersionInformationViewController *controller = [[IMVersionInformationViewController alloc] init];
//        
//        [controller setHidesBottomBarWhenPushed:YES];
//        [[self navigationController] pushViewController:controller animated:YES];
        IMUserDialogViewController *controller = [[IMUserDialogViewController alloc] init];
        
        [controller setIsCustomerSevice:YES];
        [controller setTitle:@"客服"];
        [controller setCustomUserID:@"kefu_104695"];
        [controller setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:controller animated:YES];
    }
    else {
        if (isLogouting) {
            return;
        }
        
        isLogouting = YES;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，也不会收到任何推送消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
        [actionSheet showFromTabBar:[self tabBarController].tabBar];
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - notification

- (void)reloadData:(NSNotification *)notification {
    if (![notification.object isEqual:[g_pIMMyself customUserID]]) {
        return;
    }
    
    [_tableView reloadData];
}

@end

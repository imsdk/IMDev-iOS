//
//  IMGroupInfoViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/24.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMGroupInfoViewController.h"
#import "IMDefine.h"
#import "IMGroupMemberHeadersView.h"
#import "IMUserInformationViewController.h"
#import "IMAddGroupMemberViewController.h"
#import "IMGroupInfoEditViewController.h"
#import "IMGroupListViewController.h"

#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMMyself+Group.h"
#import "IMSDK+Group.h"

@interface IMGroupInfoViewController ()<UITableViewDataSource, UITableViewDelegate, IMGroupMemberHeadersViewDelegate, IMGroupInfoEditDelegate, IMGroupInfoUpdateDelegate, UIActionSheetDelegate>

@end

@implementation IMGroupInfoViewController{
    UITableView *_tableView;
    UISwitch *_switch;
    UILabel *_operateLabel;
    
    BOOL _deleteStatus;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_titleLabel setText:[NSString stringWithFormat:@"群信息(%lu)",(unsigned long)[[_groupInfo memberList] count]]];
    
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 64;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:RGB(242, 242, 242)];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self view] addSubview:_tableView];
    
    _switch = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 60, 5, 60, 34)];
    
    [_switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:IMShowGroupMemberName([g_pIMMyself customUserID], [_groupInfo groupID])];
    
    BOOL show = NO;
    
    if (object == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:IMShowGroupMemberName([g_pIMMyself customUserID], [_groupInfo groupID])];
        [[NSUserDefaults standardUserDefaults] synchronize];
        show = YES;
    } else {
        show = [object boolValue];
    }
    [_switch setOn:show];
    
    _operateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [_operateLabel setBackgroundColor:[UIColor clearColor]];
    [_operateLabel setTextAlignment:NSTextAlignmentCenter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMember:) name:IMAddGroupMemberNotification object:nil];
//    [_switch setTintColor:[UIColor greenColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchValueChanged:(id)sender {
    BOOL show = [[[NSUserDefaults standardUserDefaults] objectForKey:IMShowGroupMemberName([g_pIMMyself customUserID], [_groupInfo groupID])] boolValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!show] forKey:IMShowGroupMemberName([g_pIMMyself customUserID], [_groupInfo groupID])];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMShowGroupMemberNameNotification([_groupInfo groupID]) object:nil];
}

- (void)setGroupInfo:(IMGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    [_groupInfo setDelegate:self];
    
    
}

#pragma mark - IMGroupInfoUpdateDelegate

- (void)didUpdateGroupInfo:(IMGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    
    [_titleLabel setText:[NSString stringWithFormat:@"群信息(%lu)",(unsigned long)[[_groupInfo memberList] count]]];

    [_tableView reloadData];
}

- (void)didUpdateMemberListForGroupInfo:(IMGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    
    if (![[groupInfo memberList] containsObject:[g_pIMMyself customUserID]]) {
        _notifyText = @"你已经被移出该群";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        [self displayNotifyHUD];
        
        for (UIViewController *controller in [[self navigationController] viewControllers]) {
            if ([controller isKindOfClass:[IMGroupListViewController class]]) {
                [[self navigationController] popToViewController:controller animated:YES];
                
                return;
            }
        }
        
        [[self navigationController] popToRootViewControllerAnimated:YES];
        return;
    }
    
    [_titleLabel setText:[NSString stringWithFormat:@"群信息(%lu)",(unsigned long)[[_groupInfo memberList] count]]];

    [_tableView reloadData];
}


#pragma mark - IMCustomGroupInfoEditDelegate

- (void)customGroupInfoEdit:(NSInteger)type content:(NSString *)content {
    if (type == 1) {
        [_groupInfo setGroupName:content];
    } else {
        [_groupInfo setCustomGroupInfo:content];
    }
    
    [_groupInfo commitGroupInfoOnSuccess:^(IMGroupInfo *groupInfo) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSString *error) {
        _groupInfo = [g_pIMSDK groupInfoWithGroupID:[_groupInfo groupID]];
    }];
}


#pragma mark - IMGroupMemberHeadersViewDelegate

- (void)headViewTaped:(NSString *)customUserID {
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setCustomUserID:customUserID];
    [controller setFromUserDialogView:NO];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)addMemberButtonClick {
    IMAddGroupMemberViewController *controller = [[IMAddGroupMemberViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [controller setCustomUserIDs:[_groupInfo memberList]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setDeleteStatus:(BOOL)deleteStatus {
    _deleteStatus = deleteStatus;
}

- (void)deleteMember:(NSString *)customUserID {
    [g_pIMMyself removeMember:customUserID fromGroup:[_groupInfo groupID] success:^{
        if ([[_groupInfo memberList] containsObject:[g_pIMMyself customUserID]] && [[_groupInfo memberList] count] == 1) {
            _deleteStatus = NO;
        }
        [_tableView reloadData];
    } failure:^(NSString *error) {
        _notifyText = @"删除群成员失败";
        _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
        [self displayNotifyHUD];
    }];
}


#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    
    if ([indexPath section] == 0) {
        NSInteger viewCount = [[_groupInfo memberList] count];
        
        if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
            viewCount += 2;
        }
        
        for (UIView *view in [[cell contentView] subviews]) {
            if ([view isKindOfClass:[IMGroupMemberHeadersView class]]) {
                [(IMGroupMemberHeadersView *)view setDelegate:nil];
                [view removeFromSuperview];
            }
        }
        
        IMGroupMemberHeadersView *headsView = [[IMGroupMemberHeadersView alloc] initWithFrame:CGRectMake(0, 0, 320, ((viewCount - 1) / 4 + 1)* 95 + 20)];
        
        [headsView setDeleteStatus:_deleteStatus];
        [headsView setGroupInfo:_groupInfo];
        [headsView setDelegate:self];
        [[cell contentView] addSubview:headsView];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    } else if([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"群名称"];
            [[cell detailTextLabel] setText:[_groupInfo groupName]];
            if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            } else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        } else if([indexPath row] == 1) {
            [[cell textLabel] setText:@"群信息"];
            [[cell detailTextLabel] setText:[_groupInfo customGroupInfo]];
            if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            } else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        
            [[cell detailTextLabel] setNumberOfLines:0];
        } else if([indexPath row] == 2) {
            [[cell textLabel] setText:@"群创建者"];
            [[cell detailTextLabel] setText:[_groupInfo ownerCustomUserID]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else {
            [[cell textLabel] setText:@"群聊大小"];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%ld人",(long)[_groupInfo maxUserCount]]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    } else if ([indexPath section] == 2){
        [[cell textLabel] setText:@"显示群成员昵称"];
        
        [_switch removeFromSuperview];
        [[cell contentView] addSubview:_switch];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
        [_operateLabel removeFromSuperview];
        
        [[cell contentView] addSubview:_operateLabel];
        
        if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
            [_operateLabel setText:@"解散"];
        } else {
            [_operateLabel setText:@"退出"];
        }
}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0) {
        NSInteger viewCount = [[_groupInfo memberList] count];
        
        if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
            viewCount += 2;
        }
        
        return ((viewCount - 1) / 4 + 1) * 95 + 20;
    } else if ([indexPath section] == 1 && [indexPath row] == 1) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
            CGSize size = [[_groupInfo customGroupInfo] boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, nil] context:nil].size;
            
            if (size.height + 20 < 44) {
                return 44;
            }
            return size.height + 20;
        } else {
            CGSize size = [[_groupInfo customGroupInfo] sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(240, 100)];
            
            if (size.height + 20 < 44) {
                return 44;
            }
            return size.height + 20;
        }
    } else {
        return 44.0f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath section] == 0 || [indexPath section] == 2 || [indexPath row] > 1) {
        return;
    } else if([indexPath section] == 3) {
        NSString *alertString = nil;
        
        if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
            alertString  = [NSString stringWithFormat:@"确定解散群组\"%@\"?",[_groupInfo groupName]];
        } else {
            alertString  = [NSString stringWithFormat:@"确定退出群组\"%@\"?",[_groupInfo groupName]];
        }
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertString delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
        [actionSheet showFromTabBar:[self tabBarController].tabBar];
        return;
    } else {
        IMGroupInfoEditViewController *controller = [[IMGroupInfoEditViewController alloc] init];
        
        if ([indexPath row] == 0) {
            [controller setContent:[_groupInfo groupName]];
        } else {
            [controller setContent:[_groupInfo customGroupInfo]];
        }
        [controller setType:[indexPath row] +1];
        [controller setDelegate:self];
        [[self navigationController] pushViewController:controller animated:YES];
    }
}


#pragma mark - notification

- (void)addMember:(NSNotification *)notification {
    [_tableView reloadData];

    NSString *customUserID = [notification object];
    
    if (![customUserID isKindOfClass:[NSString class]]) {
        return;
    }
    
    [g_pIMMyself addMember:customUserID toGroup:[_groupInfo groupID] success:^{
        [_titleLabel setText:[NSString stringWithFormat:@"群信息(%lu)",(unsigned long)[[_groupInfo memberList] count]]];
        [_tableView reloadData];
    } failure:^(NSString *error) {
        _notifyText = @"添加群成员失败";
        _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
        [self displayNotifyHUD];
    }];
}


#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
            [g_pIMMyself deleteGroup:[_groupInfo groupID] success:^{
                _notifyText = @"解散群组成功";
                _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
                [self displayNotifyHUD];
                
                for (UIViewController *controller in [[self navigationController] viewControllers]) {
                    if ([controller isKindOfClass:[IMGroupListViewController class]]) {
                        [[self navigationController] popToViewController:controller animated:YES];
                        return ;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
                
                [[self navigationController] popToRootViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                _notifyText = @"解散群组失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
            }];
        } else {
            [g_pIMMyself quitGroup:[_groupInfo groupID] success:^{
                _notifyText = @"退出群组成功";
                _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
                [self displayNotifyHUD];
                
                for (UIViewController *controller in [[self navigationController] viewControllers]) {
                    if ([controller isKindOfClass:[IMGroupListViewController class]]) {
                        [[self navigationController] popToViewController:controller animated:YES];
                        return ;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
                
                [[self navigationController] popToRootViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                _notifyText = @"退出群组失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
            }];
        }
    }
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

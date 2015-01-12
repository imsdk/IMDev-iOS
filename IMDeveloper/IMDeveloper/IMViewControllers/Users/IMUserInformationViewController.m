//
//  IMUserInformationViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMUserInformationViewController.h"
#import "IMDefine.h"
#import "IMFriendRequestViewController.h"
#import "IMUserDialogViewController.h"

//Third Party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMMyself+Relationship.h"
#import "IMMyself+RecentContacts.h"

@interface IMUserInformationViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

// load head image
- (void)loadHeadImage;
// load custom user information
- (void)loadCustomUserInfomation;
// load relationships
- (void)loadUserRelations;

- (void)buttonClick:(id)sender;
@end

@implementation IMUserInformationViewController {
    UITableView *_tableView;
    
    UIView *_tableHeaderView;
    UIImageView *_headView;
    UILabel *_userNameLabel;
    UILabel *_sexLabel;
    
    UIView *_tableFooterView;
    UIButton *_removeBlacklistBtn;
    UIButton *_chatBtn;
    UIButton *_sendFriendsRequestBtn;
    UIButton *_removeFriendsBtn;
    
    UIBarButtonItem *_rightBarButtonItem;
    
    //third party
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [_titleLabel setText:@"详细资料"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMRelationshipDidInitializeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMReloadFriendlistNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMReloadFriendlistNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [[self view] addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    [_tableView setTableHeaderView:_tableHeaderView];
    
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    [[_headView layer] setCornerRadius:5.0];
    [[_headView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_headView layer] setBorderWidth:0.3];
    [_headView setContentMode:UIViewContentModeScaleAspectFill];
    [_headView setClipsToBounds:YES];
    [_headView setBackgroundColor:[UIColor clearColor]];
    [_tableHeaderView addSubview:_headView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right + 10, 10, 200, 30)];
    
    [_userNameLabel setBackgroundColor:[UIColor clearColor]];
    [_userNameLabel setText:_customUserID];
    [_userNameLabel setTextColor:[UIColor blackColor]];
    [_userNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_tableHeaderView addSubview:_userNameLabel];
    
    _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right + 10, _userNameLabel.bottom, 200, 30)];
    
    [_sexLabel setBackgroundColor:[UIColor clearColor]];
    [_sexLabel setTextColor:[UIColor grayColor]];
    [_sexLabel setFont:[UIFont systemFontOfSize:15]];
    [_tableHeaderView addSubview:_sexLabel];
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [_tableView setTableFooterView:_tableFooterView];
    
    _sendFriendsRequestBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 60, 240, 40)];
    
    [[_sendFriendsRequestBtn layer] setCornerRadius:10.0f];
    [_sendFriendsRequestBtn setBackgroundColor:RGB(41, 140, 38)];
    [_sendFriendsRequestBtn setTitle:@"加为好友" forState:UIControlStateNormal];
    [_sendFriendsRequestBtn setAlpha:0.8];
    [_tableFooterView addSubview:_sendFriendsRequestBtn];
    
    [_sendFriendsRequestBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 60, 240, 40)];
    
    [[_chatBtn layer] setCornerRadius:10.0f];
    [_chatBtn setBackgroundColor:RGB(44, 164, 232)];
    [_chatBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [_tableFooterView addSubview:_chatBtn];
    
    [_chatBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    _removeFriendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, 240, 40)];
    
    [[_removeFriendsBtn layer] setCornerRadius:10.0f];
    [_removeFriendsBtn setBackgroundColor:RGB(244, 42, 41)];
    [_removeFriendsBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    [_removeFriendsBtn setAlpha:0.8];
    [_tableFooterView addSubview:_removeFriendsBtn];
    
    [_removeFriendsBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _removeBlacklistBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, 240, 40)];
    
    [[_removeBlacklistBtn layer] setCornerRadius:10.0f];
    [_removeBlacklistBtn setBackgroundColor:RGB(244, 42, 41)];
    [_removeBlacklistBtn setTitle:@"从黑名单移除" forState:UIControlStateNormal];
    [_removeBlacklistBtn setAlpha:0.8];
    [_tableFooterView addSubview:_removeBlacklistBtn];
    
    [_removeBlacklistBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItenClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    [self loadHeadImage];
    [self loadCustomUserInfomation];
    [self loadUserRelations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItenClick:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    [actionSheet showFromTabBar:[self tabBarController].tabBar];
    
}

- (void)loadHeadImage {
    UIImage *image = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (image == nil) {
        [_headView setImage:[UIImage imageNamed:@"IM_head_default.png"]];
    } else {
        [_headView setImage:image];
    }
    
    [g_pIMSDK requestMainPhotoOfUser:_customUserID success:^(UIImage *mainPhoto) {
        if (mainPhoto) {
            [_headView setImage:mainPhoto];
            [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification(_customUserID) object:nil];
        }
    } failure:^(NSString *error) {
        NSLog(@"load head image failed for %@",error);
    }];
}

- (void)loadCustomUserInfomation {
    // firstly, load local custom userinfo
    NSString *userInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
    
    NSArray *array = [userInfo componentsSeparatedByString:@"\n"];
    
    if ([array count] > 0) {
        NSString *sex = [array objectAtIndex:0];
        
        if (![sex isEqualToString:@"男"] && ![sex isEqualToString:@"女"] ) {
            sex = @"男";
        }
        [_sexLabel setText:sex];
    }
    
    [_tableView reloadData];
    
    //secondly, request server custom userinfo
    [g_pIMSDK requestCustomUserInfoWithCustomUserID:_customUserID success:^(NSString *customUserInfo) {
        if (customUserInfo == nil) {
            return ;
        }
        
        NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
        
        if ([array count] > 0) {
            NSString *sex = [array objectAtIndex:0];
            
            if (![sex isEqualToString:@"男"] && ![sex isEqualToString:@"女"] ) {
                sex = @"男";
            }
            [_sexLabel setText:sex];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSString *error) {
        NSLog(@"load custom user information failed for %@",error);
    }];
}

- (void)loadUserRelations {
    if ([[g_pIMMyself customUserID] isEqualToString:_customUserID]) {
        [_chatBtn setHidden:NO];
        [_removeFriendsBtn setHidden:YES];
        [_sendFriendsRequestBtn setHidden:YES];
        [_removeBlacklistBtn setHidden:YES];
    } else if ([g_pIMMyself isMyFriend:_customUserID]) {
        [_chatBtn setHidden:NO];
        [_removeFriendsBtn setHidden:NO];
        [_sendFriendsRequestBtn setHidden:YES];
        [_removeBlacklistBtn setHidden:YES];
    } else if ([g_pIMMyself isMyBlacklistUser:_customUserID]) {
        [_chatBtn setHidden:YES];
        [_removeFriendsBtn setHidden:YES];
        [_sendFriendsRequestBtn setHidden:YES];
        [_removeBlacklistBtn setHidden:NO];
    } else {
        [_chatBtn setHidden:YES];
        [_removeFriendsBtn setHidden:YES];
        [_sendFriendsRequestBtn setHidden:NO];
        [_removeBlacklistBtn setHidden:YES];
    }
    
}

- (void)buttonClick:(id)sender {
    if (sender == _chatBtn) {
        //send message
        if (_fromUserDialogView) {
            [[self navigationController] popViewControllerAnimated:YES];
        } else {
            IMUserDialogViewController *controller = [[IMUserDialogViewController alloc] init];
            
            [controller setCustomUserID:_customUserID];
            [[self navigationController] pushViewController:controller animated:YES];
        }
        
    } else if (sender == _sendFriendsRequestBtn) {
        //send friend request
        IMFriendRequestViewController *controller = [[IMFriendRequestViewController alloc] init];
        
        [controller setCustomUserID:_customUserID];
        [[self navigationController] pushViewController:controller animated:YES];
        
    } else if (sender == _removeFriendsBtn) {
        __block BOOL fromUserDialogView = _fromUserDialogView;
        
        [g_pIMMyself removeFromFriendsList:_customUserID success:^{
            [self loadUserRelations];
            [g_pIMMyself removeRecentContact:_customUserID];
            
            if (fromUserDialogView) {
                [self displayNotifyHUD];
                [[self navigationController] popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSString *error) {
            _notifyText = @"删除好友失败";
            _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
            [self displayNotifyHUD];
        }];
        
    } else if (sender == _removeBlacklistBtn) {
        //remove from blacklist
        [g_pIMMyself removeUserFromBlacklist:_customUserID success:^{
            [self loadUserRelations];
            [g_pIMMyself removeRecentContact:_customUserID];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadBlacklistNotification object:nil];
        } failure:^(NSString *error) {
            _notifyText = @"移除黑名单失败";
            _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
            [self displayNotifyHUD];
        }];
        
    }
}


#pragma mark - actionsheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //move to blacklist
        [g_pIMMyself moveToBlacklist:_customUserID success:^{
            [self loadUserRelations];
            __block BOOL fromUserDialogView = _fromUserDialogView;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadBlacklistNotification object:nil];
            if (fromUserDialogView) {
                [self displayNotifyHUD];
                [[self navigationController] popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSString *error) {
            if ([error isEqualToString:@"Already in Blacklist"]) {
                error = @"该用户已经在黑名单中";
            } else {
                error = @"加入黑名单失败";
            }
            
            _notifyText = error;
            _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
            [self displayNotifyHUD];

        }];
    }
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    NSString *customUserInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
    
    NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
    
    if ([indexPath row] == 0) {
        [[cell textLabel] setText:@"地区"];
        
        NSString *location = nil;
        if ([array count] >= 2) {
            location = [array objectAtIndex:1];
        }
        
        if (location == nil || [location length] == 0) {
            location = @"未填写";
        }
        [[cell detailTextLabel] setText:location];
        
    } else if ([indexPath row] == 1) {
        [[cell textLabel] setText:@"个性签名"];
        
        NSString *signature = nil;
        if ([array count] >= 3) {
            signature = [array objectAtIndex:2];
        }
        
        if (signature == nil || [signature length] == 0) {
            signature = @"未填写";
        }
        [[cell detailTextLabel] setText:signature];
    }
    
    [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}


#pragma mark - notifications

- (void)loadData {
    [self loadUserRelations];
    [_tableView reloadData];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end

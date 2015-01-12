//
//  IMRootViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMRootViewController.h"
#import "IMConversationViewController.h"
#import "IMContactViewController.h"
#import "IMAroundViewController.h"
#import "IMSettingViewController.h"
#import "IMLoginViewController.h"
#import "IMDefine.h"

//thrid party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMMyself+CustomMessage.h"
#import "IMMyself+Relationship.h"
#import "IMMyself+Group.h"
#import "IMMyself+CustomUserInfo.h"

#define IM_CONVERSATION_TAG 1
#define IM_CONTACT_TAG 2
#define IM_AROUND_TAG 3
#define IM_SETTING_TAG 4

@interface IMExtraAlertView : UIAlertView

@property (nonatomic, strong) NSObject *extraData;

@end

@implementation IMExtraAlertView

@end

@interface IMRootViewController ()<UITabBarControllerDelegate, IMRelationshipDelegate, IMMyselfDelegate, IMCustomUserInfoDelegate, IMGroupDelegate>

- (void)logout;

@end

@implementation IMRootViewController{
    UITabBarController *_tabBarController;
    UINavigationController *_contactNav;
    UINavigationController *_conversationNav;
    UINavigationController *_aroundNav;
    UINavigationController *_settingNav;
    
    IMLoginViewController *_loginController;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [g_pIMMyself setDelegate:nil];
    [g_pIMMyself setRelationshipDelegate:nil];
    [g_pIMMyself setGroupDelegate:nil];
    [g_pIMMyself setCustomUserInfoDelegate:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:IMLogoutNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self navigationController] setNavigationBarHidden:YES];
    
    _tabBarController = [[UITabBarController alloc] init];
    
    [self addChildViewController:_tabBarController];
    [[_tabBarController view] setFrame:[[self view] bounds]];
    [[_tabBarController view] setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _tabBarController.delegate = self;
    
    [self.view addSubview:_tabBarController.view];
    
    IMConversationViewController *coversationCtrl = [[IMConversationViewController alloc] init];
    _conversationNav = [[UINavigationController alloc] initWithRootViewController:coversationCtrl];
    
    [[_conversationNav tabBarItem] setTag:IM_CONVERSATION_TAG];
    
    IMContactViewController *contactCtrl = [[IMContactViewController alloc] init];
    _contactNav = [[UINavigationController alloc] initWithRootViewController:contactCtrl];
    
    [[_contactNav tabBarItem] setTag:IM_CONTACT_TAG];
    
    IMAroundViewController *aroundCtrl = [[IMAroundViewController alloc] init];
    _aroundNav = [[UINavigationController alloc] initWithRootViewController:aroundCtrl];
    
    [[_aroundNav tabBarItem] setTag:IM_AROUND_TAG];
    
    IMSettingViewController *settingCtrl = [[IMSettingViewController alloc] init];
    _settingNav = [[UINavigationController alloc] initWithRootViewController:settingCtrl];
    
    [[_settingNav tabBarItem] setTag:IM_SETTING_TAG];
    
    NSArray *navArray = [NSArray arrayWithObjects:_conversationNav,_contactNav,_aroundNav,_settingNav, nil];
    
    [_tabBarController setViewControllers:navArray];
    
    //设置IMMyself 代理
    [g_pIMMyself setDelegate:self];
    [g_pIMMyself setRelationshipDelegate:self];
    [g_pIMMyself setGroupDelegate:self];
    [g_pIMMyself setCustomUserInfoDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logout {
    [_tabBarController setSelectedIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMLoginCustomUserID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self removeFromParentViewController];
    [[self view] removeFromSuperview];
}


#pragma mark - IMMyself delegate

- (void)didLogoutFor:(NSString *)reason {
    if ([[reason uppercaseString] isEqualToString:@"USER LOGOUT"] || [[reason uppercaseString] isEqualToString:@"LOGIN CONFLICT"] || [g_pIMMyself customUserID] == nil) {
        if ([[reason uppercaseString] isEqualToString:@"LOGIN CONFLICT"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的帐号在别处登陆,请确认是否本人操作" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            
            [alert show];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:IMLogoutNotification object:nil];
        return;
    }
    
    [self trylogin];
    
}

- (void)trylogin {
    NSString *loginCustomUserID = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginCustomUserID];
    NSString *loginPassword = [[NSUserDefaults standardUserDefaults] objectForKey:IMLoginPassword];
    
    if (![[g_pIMMyself customUserID] isEqualToString:loginCustomUserID]) {
        /*
         it is important! if you call method "initWithCustomUserID:appKey:",All IMMyself Delegates will reinit;
         so if customUserID didn't change,don't call this method;
        */
        [g_pIMMyself initWithCustomUserID:loginCustomUserID appKey:IMDeveloper_APPKey];
    }
    
    [g_pIMMyself setPassword:loginPassword];
    [g_pIMMyself loginWithTimeoutInterval:10 success:^(BOOL autoLogin) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
        [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
        [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSString *error) {
        [self trylogin];
    }];
}

- (void)logoutFailedWithError:(NSString *)error {
    //注销deviceToken 失败也要退回到登陆界面
    [[NSNotificationCenter defaultCenter] postNotificationName:IMLogoutNotification object:nil];
    
}

- (void)loginStatusDidUpdate:(IMMyselfLoginStatus)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMLoginStatusChangedNotification object:nil];
}


#pragma mark - IMMyself custom userinfo delegate

- (void)customUserInfoDidInitialize {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMCustomUserInfoDidInitializeNotification object:nil];
}


#pragma mark - IMMyself group delegate

- (void)groupListDidInitialize {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMGroupListDidInitializeNotification object:nil];
}

- (void)addedToGroup:(NSString *)groupID byUser:(NSString *)customUserID {
    if ([customUserID isEqualToString:[g_pIMMyself customUserID]]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
}

- (void)removedFromGroup:(NSString *)groupID byUser:(NSString *)customUserID {
    if ([customUserID isEqualToString:[g_pIMMyself customUserID]]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:IMRemovedGroupNotification(groupID) object:nil];
}

- (void)group:(NSString *)groupID deletedByUser:(NSString *)customUserID {
    if ([customUserID isEqualToString:[g_pIMMyself customUserID]]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:IMDeleteGroupNotification(groupID) object:nil];
}

- (void)didCreateGroupWithName:(NSString *)groupName groupID:(NSString *)groupID clientActionTime:(UInt32)timeIntervalSince1970 {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
}

- (void)didRemoveGroup:(NSString *)groupID clientActionTime:(UInt32)timeIntervalSince1970 {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadGroupListNotification object:nil];
}


#pragma mark - IMMyself relationship delegate

- (void)relationshipDidInitialize {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMRelationshipDidInitializeNotification object:nil];
}

- (void)didReceiveAgreeToFriendRequestFromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadFriendlistNotification object:nil];
}

- (void)didReceiveFriendRequest:(NSString *)text fromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 {
    IMExtraAlertView *alertView = [[IMExtraAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ 请求加为好友", customUserID] message:text delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"同意", @"拒绝", nil];
    
    [alertView setExtraData:customUserID];
    [alertView setDelegate:self];
    [alertView show];
}

- (void)didBuildFriendRelationshipWithUser:(NSString *)customUserID {
    _notifyText = @"添加好友成功";
    _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
    [self displayNotifyHUD];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadFriendlistNotification object:nil];
}

- (void)didReceiveRejectFromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 reason:(NSString *)reason {
    _notifyText = [NSString stringWithFormat:@"%@拒绝了你的好友请求:%@",customUserID,reason];
    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
    [self displayNotifyHUD];
}

- (void)didBreakUpFriendshipWithCustomUserID:(NSString *)customUserID {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadFriendlistNotification object:nil];
}


#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![alertView isKindOfClass:[IMExtraAlertView class]]) {
        return;
    }
    
    IMExtraAlertView *extraAlertView = (IMExtraAlertView *)alertView;
    NSString *customUserID = (NSString *)[extraAlertView extraData];
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [g_pIMMyself agreeToFriendRequestFromUser:customUserID success:^{
                
            } failure:^(NSString *error) {
                _notifyText = @"添加好友失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
            }];
        }
            break;
        case 2:
        {
            [g_pIMMyself rejectToFriendRequestFromUser:customUserID reason:@"" success:^{
                
            } failure:^(NSString *error) {
                _notifyText = @"拒绝失败";
                _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
                [self displayNotifyHUD];
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil){
        return _notify;
    }
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:_notifyImage text:_notifyText];
    [_notify setCenter:CGPointMake(_tabBarController.view.center.x, _tabBarController.view.center.y - 20)];
    return _notify;
}

- (void)displayNotifyHUD {
    if (_notify) {
        [_notify removeFromSuperview];
        _notify = nil;
    }
    
    [_tabBarController.view addSubview:[self notify]];
    [[self notify] presentWithDuration:1.0f speed:0.5f inView:_tabBarController.view completion:^{
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

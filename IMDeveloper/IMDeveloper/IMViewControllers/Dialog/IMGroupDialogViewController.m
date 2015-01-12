//
//  IMGroupDialogViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/23.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMGroupDialogViewController.h"
#import "IMGroupInfo.h"
#import "IMDefine.h"
#import "IMUserInformationViewController.h"
#import "IMGroupInfoViewController.h"
#import "IMGroupListViewController.h"

//Third party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMGroupChatView.h"
#import "IMSDK+Group.h"
#import "IMMyself.h"

@interface IMGroupDialogViewController ()<IMGroupChatViewDelegate, IMGroupInfoUpdateDelegate>

- (void)rightBarButtonItemClick:(id)sender;

@end

@implementation IMGroupDialogViewController{
    UIBarButtonItem *_rightBarButtonItem;
    
    IMGroupInfo *_groupInfo;
    IMGroupChatView *_groupChatView;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (void)dealloc
{
    [_groupChatView setDelegate:nil];
    [_groupInfo setDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"群信息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    _groupInfo = [g_pIMSDK groupInfoWithGroupID:_groupID];
    
    [_groupInfo setDelegate:self];
    
    [_titleLabel setText:[_groupInfo groupName]];
    
    CGFloat height = 480 - 64;
    
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        height = 568 - 64;
    }
    
    _groupChatView = [[IMGroupChatView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [_groupChatView setGroupID:_groupID];
    [_groupChatView setKeyboardHighLightImage:[UIImage imageNamed:@"IM_keyboard_normal.png"]];
    [_groupChatView setKeyboardNormalImage:[UIImage imageNamed:@"IM_keyboard_normal.png"]];
    [_groupChatView setFaceHighLightImage:[UIImage imageNamed:@"IM_face_normal.png"]];
    [_groupChatView setFaceNormalImage:[UIImage imageNamed:@"IM_face_normal.png"]];
    [_groupChatView setMoreHighLightImage:[UIImage imageNamed:@"IM_more_normal.png"]];
    [_groupChatView setMoreNormalImage:[UIImage imageNamed:@"IM_more_normal.png"]];
    [_groupChatView setMicHighLightImage:[UIImage imageNamed:@"IM_mic_normal.png"]];
    [_groupChatView setMicNormalImage:[UIImage imageNamed:@"IM_mic_normal.png"]];
    [_groupChatView setInputViewTintColor:RGB(245, 245, 245)];
    [_groupChatView setSenderTintColor:RGB(44, 164, 232)];
    [_groupChatView setReceiverTintColor:[UIColor lightGrayColor]];
    [self showGroupMemberName:nil];
    [_groupChatView setParentController:self];
    [_groupChatView setDelegate:self];
    [[self view] addSubview:_groupChatView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removedByGroupManager) name:IMRemovedGroupNotification(_groupID) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupHasBeenDeleted) name:IMDeleteGroupNotification(_groupID) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGroupMemberName:) name:IMShowGroupMemberNameNotification(_groupID) object:nil];
    
}

- (void)removedByGroupManager {
    _notifyText = [NSString stringWithFormat:@"你被移出“%@”群",[_groupInfo groupName]];
    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
    [self displayNotifyHUD];
    
    for (UIViewController *controller in [[self navigationController] viewControllers]) {
        if ([controller isKindOfClass:[IMGroupListViewController class]]) {
            [[self navigationController] popToViewController:controller animated:YES];
            return;
        }
    }
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    
}

- (void)groupHasBeenDeleted {
    _notifyText = [NSString stringWithFormat:@"“%@”群被解散",[_groupInfo groupName]];
    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
    [self displayNotifyHUD];
    
    for (UIViewController *controller in [[self navigationController] viewControllers]) {
        if ([controller isKindOfClass:[IMGroupListViewController class]]) {
            [[self navigationController] popToViewController:controller animated:YES];
            return;
        }
    }
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)showGroupMemberName:(NSNotification *)notification {
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:IMShowGroupMemberName([g_pIMMyself customUserID], _groupID)];
    
    BOOL show = NO;
    
    if (object == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:IMShowGroupMemberName([g_pIMMyself customUserID], _groupID)];
        [[NSUserDefaults standardUserDefaults] synchronize];
        show = YES;
    } else {
        show = [object boolValue];
    }
    
    [_groupChatView setShowCustomUserID:show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClick:(id)sender {
    IMGroupInfoViewController *controller = [[IMGroupInfoViewController alloc] init];
    
    [controller setGroupInfo:_groupInfo];
    [[self navigationController] pushViewController:controller animated:YES];
}


#pragma mark - IMGroupChatViewDelegate

- (void)onHeadViewTaped:(NSString *)customUserID {
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setFromUserDialogView:NO];
    [controller setCustomUserID:customUserID];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)recordAudioError:(NSString *)error {
    if ([error isEqualToString:@"the recording time is too short"]) {
        _notifyText = @"说话时间太短";
        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
        [self displayNotifyHUD];
    } else if ([error isEqualToString:@"The microphone is prohibited"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在iPhone的\"设置-隐私-麦克风\"选项中，允许爱萌开发者访问你的手机麦克风" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)playAudioError:(NSString *)error {
    if ([error isEqualToString:@"speech dysfunction"]) {
        error = @"语音播放功能障碍";
    } else  {
        error = @"播放失败";
    }
    
    _notifyText = error;
    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
    [self displayNotifyHUD];
}


#pragma mark - IMGroupInfoDelegate

- (void)didUpdateGroupInfo:(IMGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    
    [_titleLabel setText:[_groupInfo groupName]];
}

- (void)didUpdateMemberListForGroupInfo:(IMGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
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

//
//  IMUserDialogViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMUserDialogViewController.h"
#import "IMDefine.h"
#import "IMUserInformationViewController.h"
#import "IMSDKManager.h"

//Third party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMChatView.h"
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMMyself+RecentContacts.h"
#import "IMSDK+Nickname.h"

@interface IMUserDialogViewController ()<IMChatViewDelegate, IMChatViewDataSource>

- (void)rightBarButtonItemClick:(id)sender;

@end


@implementation IMUserDialogViewController {
    UIBarButtonItem *_rightBarButtonItem;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (void)dealloc
{
    [g_pIMSDKManager removeRecentChatObject:_customUserID];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[g_pIMSDKManager recentChatObjects] addObject:_customUserID];
    [g_pIMMyself clearUnreadChatMessageWithUser:_customUserID];
    [[NSNotificationCenter defaultCenter] postNotificationName:IMUnReadMessageChangedNotification object:nil];
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"个人信息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [_rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(6, 191, 4) forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    
    if (!_isCustomerSevice) {
        [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    NSString *title = [g_pIMSDK nicknameOfUser:_customUserID];
    
    if ([title length] == 0) {
        title = _customUserID;
    }
    
    if (_isCustomerSevice) {
        [_titleLabel setText:self.title];
    } else{
        [_titleLabel setText:title];
    }
    
    
    CGFloat height = 480 - 64;
    
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        height = 568 - 64;
    }
    
    IMChatView *view = [[IMChatView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    
    [view setKeyboardHighLightImage:[UIImage imageNamed:@"IM_keyboard_normal.png"]];
    [view setKeyboardNormalImage:[UIImage imageNamed:@"IM_keyboard_normal.png"]];
    [view setFaceHighLightImage:[UIImage imageNamed:@"IM_face_normal.png"]];
    [view setFaceNormalImage:[UIImage imageNamed:@"IM_face_normal.png"]];
    [view setMoreHighLightImage:[UIImage imageNamed:@"IM_more_normal.png"]];
    [view setMoreNormalImage:[UIImage imageNamed:@"IM_more_normal.png"]];
    [view setMicHighLightImage:[UIImage imageNamed:@"IM_mic_normal.png"]];
    [view setMicNormalImage:[UIImage imageNamed:@"IM_mic_normal.png"]];
    [view setInputViewTintColor:RGB(245, 245, 245)];
    [view setBackgroundColor:RGB(237, 237, 237)];
    [view setParentController:self];
    [view setDelegate:self];
    [view setDataSource:self];
    
    [view setCustomUserID:_customUserID];
    [[self view] addSubview:view];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *title = [g_pIMSDK nicknameOfUser:_customUserID];
    
    if ([title length] == 0) {
        title = _customUserID;
    }
    
    if (_isCustomerSevice) {
        [_titleLabel setText:self.title];
    } else{
        [_titleLabel setText:title];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)flag{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
        [super setAutomaticallyAdjustsScrollViewInsets:flag];
    }
}

- (void)rightBarButtonItemClick:(id)sender {
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setFromUserDialogView:YES];
    [controller setCustomUserID:_customUserID];
    [[self navigationController] pushViewController:controller animated:YES];
}


#pragma mark - IMChatViewDataSource

- (UIImage *)chatView:(IMChatView *)chatView imageForCustomUserID:(NSString *)customUserID {
    UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
    
    if (image == nil) {
        NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
        
        NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        NSString *sex = nil;
        
        if ([customInfoArray count] > 0) {
            sex = [customInfoArray objectAtIndex:0];
        }
        
        if ([sex isEqualToString:@"女"]) {
            image = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            image = [UIImage imageNamed:@"IM_head_male.png"];
        }

    }
    
    return image;
}


#pragma mark - IMChatViewDelegate

- (void)onHeadViewTaped:(NSString *)customUserID {
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
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

- (void)notExistCustomUserID:(NSString *)customUserID {
    _notifyText = @"对方用户不存在";
    _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
    [self displayNotifyHUD];
}

- (void)feedbackToServerFailed:(NSString *)error {
    _notifyText = @"举报信息反馈失败";
    _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
    [self displayNotifyHUD];
}

- (void)feedbackToServerSuccess:(NSString *)information {
    _notifyText = @"已经反馈到服务器，我们会尽快审核处理！";
    _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
    [self displayNotifyHUD];
}

#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil) {
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

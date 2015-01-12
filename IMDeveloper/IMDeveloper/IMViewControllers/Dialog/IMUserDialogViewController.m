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

//Third party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMChatView.h"

@interface IMUserDialogViewController ()<IMChatViewDelegate>

- (void)rightBarButtonItemClick:(id)sender;

@end


@implementation IMUserDialogViewController {
    UIBarButtonItem *_rightBarButtonItem;
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"个人信息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [_titleLabel setText:_customUserID];
    
    CGFloat height = 480 - 64;
    
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        height = 568 - 64;
    }
    
    IMChatView *view = [[IMChatView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [view setCustomUserID:_customUserID];
    [view setKeyboardHighLightImage:[UIImage imageNamed:@"IM_keyboard_normal.png"]];
    [view setKeyboardNormalImage:[UIImage imageNamed:@"IM_keyboard_normal.png"]];
    [view setFaceHighLightImage:[UIImage imageNamed:@"IM_face_normal.png"]];
    [view setFaceNormalImage:[UIImage imageNamed:@"IM_face_normal.png"]];
    [view setMoreHighLightImage:[UIImage imageNamed:@"IM_more_normal.png"]];
    [view setMoreNormalImage:[UIImage imageNamed:@"IM_more_normal.png"]];
    [view setMicHighLightImage:[UIImage imageNamed:@"IM_mic_normal.png"]];
    [view setMicNormalImage:[UIImage imageNamed:@"IM_mic_normal.png"]];
    [view setInputViewTintColor:RGB(245, 245, 245)];
    [view setSenderTintColor:RGB(44, 164, 232)];
    [view setReceiverTintColor:[UIColor lightGrayColor]];
//    [view setParentController:self];
    [view setDelegate:self];
    [[self view] addSubview:view];
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

//
//  IMLoginViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMLoginViewController.h"
#import "IMDefine.h"
#import "UIView+IM.h"
#import "IMRootViewController.h"

//third-party
#import "SFCountdownView.h"
#import "BDKNotifyHUD.h"

//IMSDK Header
#import "IMMyself.h"
#import "IMSDK+MainPhoto.h"
#import "IMLoginView.h"
#import "IMSDK+CustomUserInfo.h"

@interface IMLoginViewController ()<UITableViewDataSource, UITableViewDelegate ,UITextFieldDelegate, IMLoginViewDelegate>

//login
- (void)login:(id)sender;

@end

@implementation IMLoginViewController {
    UITableView *_tableview;
    UITextField *_userNameField;
    UITextField *_passwordField;
    UIButton *_loginBtn;
    UIImageView *_backgroundView;
    UIView *_backHeadView;
    UIImageView *_headView;
    
    IMLoginView *_loginView;
    
    //third-party
    SFCountdownView *_countdownView;
    
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
    _loginView = [[IMLoginView alloc] initWithFrame:self.view.bounds];
    
    [_loginView setDelegate:self];
    [[self view] addSubview:_loginView];
    

    
    if ([g_pIMMyself loginStatus] != IMMyselfLoginStatusNone) {
        IMRootViewController *controller = [[IMRootViewController alloc] init];
        
        [self addChildViewController:controller];
        [[self view] addSubview:controller.view];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:IMLogoutNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    NSMutableString *customUserID = [[NSMutableString alloc] initWithFormat:@"%@",[_userNameField text]];
//    
//    UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
//    
//    if (image) {
//        [_headView setImage:image];
//    } else {
//        [_headView setImage:[UIImage imageNamed:@"IM_head_default.png"]];
//    }
    [_loginView viewWillAppear];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login:(id)sender {
//    if (sender != _loginBtn) {
//        return;
//    }
//    
//    [[self view] endEditing:YES];
//    
//    NSString *customUserID = [_userNameField text];
//    NSString *password = [_passwordField text];
//    
//    if ([customUserID length] > 0) {
//        if ([password length] == 0) {
//            _notifyText = @"请输入密码";
//            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
//            [self displayNotifyHUD];
//            return;
//        }
//        
//        [g_pIMMyself setCustomUserID:customUserID];
//        
//        [g_pIMMyself setPassword:password];
//        
//        [g_pIMMyself loginWithAutoRegister:YES timeoutInterval:10 success:^(BOOL autoLogin) {
//            IMRootViewController *controller = [[IMRootViewController alloc] init];
//            
//            [self addChildViewController:controller];
//            [[self view] addSubview:controller.view];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
//            [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
//            [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            //应用角标清零
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//            
//            [_countdownView removeFromSuperview];
//            _countdownView = nil;
//            
//            [_passwordField setText:nil];
//            [[self view] endEditing:YES];
//        } failure:^(NSString *error) {
//            if ([error isEqualToString:@"Wrong Password"]) {
//                error = @"密码错误,请重新输入";
//            } else if ([error isEqualToString:@"customUserID should be only built by letters, Numbers, underscores, or '@''.',and the length between 2 to 32 characters"]){
//                error = @"用户名只能由字母、数字、下划线、@符或点组成,长度不能超过32位，也不能少于2位";
//            } else if ([error isEqualToString:@"Password length should between 2 to 32 characters"]) {
//                error = @"密码长度不能超过32位，也不能少于2位";
//            } else {
//                error = @"请检查网络是否可用";
//            }
//            
//            [self performSelector:@selector(loginError:) withObject:error afterDelay:1.0];
//        }];
//        
//        _countdownView = [[SFCountdownView alloc] initWithFrame:[self view].bounds];
//        
//        [_countdownView setCountdownFrom:10];
//        [_countdownView start];
//        [[self view] addSubview:_countdownView];
//    } else {
//        _notifyText = @"请输入用户名";
//        _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
//        [self displayNotifyHUD];
//    }
}

- (void)logout {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)loginError:(NSString *)error {
    
    _notifyText = error;
    _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
    [self displayNotifyHUD];
    
    [_countdownView removeFromSuperview];
    _countdownView = nil;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self view] endEditing:YES];
//}


#pragma mark - IMLoginView delegate

- (void)loginViewDidLogin:(BOOL)autoLogin {
    IMRootViewController *controller = [[IMRootViewController alloc] init];
    
    [self addChildViewController:controller];
    [[self view] addSubview:controller.view];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IMLastLoginTime];
    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself customUserID] forKey:IMLoginCustomUserID];
    [[NSUserDefaults standardUserDefaults] setObject:[g_pIMMyself password] forKey:IMLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //应用角标清零
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [_countdownView removeFromSuperview];
    _countdownView = nil;
    
}

- (void)loginViewLoginFailedWithError:(NSString *)error {
    if ([error isEqualToString:@"Wrong Password"]) {
        error = @"密码错误,请重新输入";
    } else if ([error isEqualToString:@"customUserID should be only built by letters, Numbers, underscores, or '@''.',and the length between 2 to 32 characters"]){
        error = @"用户名只能由字母、数字、下划线、@符或点组成,长度不能超过32位，也不能少于2位";
    } else if ([error isEqualToString:@"Password length should between 2 to 32 characters"]) {
        error = @"密码长度不能超过32位，也不能少于2位";
    } else if ([error isEqualToString:@"password不能为空字符串"]) {
        error = @"密码不能为空";
    } else if ([error isEqualToString:@"customUserID不能为null"]){
        error = @"账号不能为空";
    } else if ([error isEqualToString:@"Time out"]) {
        error = @"登录超时";
    } else if ([error isEqualToString:@"CustomUserID Already Exist"]) {
        error = @"用户已经存在";
    } else {
        error = @"登录失败";
    }
    
    
    [self performSelector:@selector(loginError:) withObject:error afterDelay:1.0];
}

- (void)loginActionStarted {
    _countdownView = [[SFCountdownView alloc] initWithFrame:[self view].bounds];

    [_countdownView setCountdownFrom:10];
    [_countdownView start];
    [[self view] addSubview:_countdownView];
}


#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if ([indexPath row] == 0) {
        [[cell contentView] addSubview:_userNameField];
    } else if ([indexPath row] == 1) {
        [[cell contentView] addSubview:_passwordField];
    }
    
    [cell setBackgroundColor:RGB(223, 235, 240)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}


#pragma mark - textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameField) {
        [_passwordField becomeFirstResponder];
        
        return NO;
    } else if (textField == _passwordField) {
        [[self view] endEditing:YES];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _userNameField) {
        if ([[textField text] length] + [string length] > 32 ) {
            _notifyText = @"用户名不能超过32个字符";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return NO;
        }
        
        NSMutableString *customUserID = [[NSMutableString alloc] initWithFormat:@"%@",[textField text]];
        
        [customUserID replaceCharactersInRange:range withString:string];
        
         UIImage *image = [g_pIMSDK mainPhotoOfUser:customUserID];
        
        if (image) {
            [_headView setImage:image];
        } else {
            NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
            
            NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
            NSString *sex = nil;
            
            if ([customInfoArray count] > 0) {
                sex = [customInfoArray objectAtIndex:0];
            }
            
            if ([sex isEqualToString:@"女"]) {
                [_headView setImage:[UIImage imageNamed:@"IM_head_female.png"]];
            } else {
                [_headView setImage:[UIImage imageNamed:@"IM_head_male.png"]];
            }
        
        }
    }
    
    if (textField == _passwordField) {
        if ([[textField text] length] + [string length] > 32 ) {
            _notifyText = @"密码不能超过32个字符";
            _notifyImage = [UIImage imageNamed:@"IM_alert_image.png"];
            [self displayNotifyHUD];
            
            return NO;
        }
    }
    return YES;
}


//#pragma mark - keyboard notifications
//
//- (void)keyboardWillShow:(NSNotification *)notification {
//    if ([[self childViewControllers] count] > 0) {
//        return;
//    }
//    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Get the origin of the keyboard when it's displayed.
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//    CGRect keyboardRect = [aValue CGRectValue];
//    [self.view convertRect:keyboardRect fromView:nil];
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    CGRect frame = self.view.frame;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    frame.origin.y =  -80;
//    if ([UIScreen mainScreen].bounds.size.height == 480) {
//        frame.origin.y = -100;
//    }
//    self.view.frame = frame;
//    [UIView commitAnimations];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    if ([[self childViewControllers] count] > 0) {
//        return;
//    }
//    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    [[self view] convertRect:keyboardRect fromView:nil];
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    CGRect frame = self.view.frame;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    frame.origin.y = 0;
//#elif __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
//    frame.origin.y = 20;
//#endif
//    self.view.frame = frame;
//    [UIView commitAnimations];
//}


#pragma mark - notify hud

- (BDKNotifyHUD *)notify {
    if (_notify != nil){
        return _notify;
    }
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:_notifyImage text:_notifyText];
    [_notify setCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)];
    return _notify;
}

- (void)displayNotifyHUD {
    if (_notify) {
        [_notify removeFromSuperview];
        _notify = nil;
    }
    
    [self.view addSubview:[self notify]];
    [[self notify] presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [[self notify] removeFromSuperview];
    }];
}


@end

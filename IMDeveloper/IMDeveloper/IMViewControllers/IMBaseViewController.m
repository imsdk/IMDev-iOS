//
//  IMBaseViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMBaseViewController.h"
#import "IMDefine.h"

@interface IMBaseViewController ()

- (void)didLogout;

@end

@implementation IMBaseViewController 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
        
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [[self navigationItem] setTitleView:_titleLabel];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:IMLogoutNotification object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [[[self navigationController] navigationBar] setTranslucent:NO];
        self.tabBarController.tabBar.translucent = NO;
    }
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = RGB(44, 164, 232);
    }
    else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.barTintColor = RGB(44, 164, 232);
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    }
    
}

- (void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)flag {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
        [super setAutomaticallyAdjustsScrollViewInsets:flag];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didLogout {
    [self reinit];
}

- (void)reinit {
    [[self navigationController] popToRootViewControllerAnimated:YES];
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

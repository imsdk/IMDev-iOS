//
//  IMAroundViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMAroundViewController.h"
#import "IMUserInformationViewController.h"
#import "IMAroundViewCell.h"
#import <CoreLocation/CoreLocation.h>

//Third Party
#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMAroundUsersView.h"
#import "IMMyself+Around.h"
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomUserInfo.h"

//update time
#define MAX_UPDATE_TIME 300

@interface IMAroundViewController ()<IMAroundUsersViewDataSource, IMAroundUsersViewDelegate, IMAroundDelegate>

- (CLLocationDistance)distanceFromLocation:(CLLocation *)distLocation toLocation:(CLLocation *)originLocation;

@end

@implementation IMAroundViewController {
    IMAroundUsersView *_aroundUsersView;
    
    NSMutableArray *_aroundList;
    
    IMUserLocation *_myselfLocation;
    
    NSDate *_lastUpdateTime;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (void)dealloc
{
    [_aroundUsersView setDelegate:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"周边"];
        [_titleLabel setText:@"周边"];
        
        [[self tabBarItem] setImage:[UIImage imageNamed:@"IM_around_normal.png"]];
        
        _aroundList = [[NSMutableArray alloc] initWithCapacity:32];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 114;
    _aroundUsersView = [[IMAroundUsersView alloc] initWithFrame:rect];
    
    [_aroundUsersView setDataSource:self];
    [_aroundUsersView setDelegate:self];
    [[self view] addSubview:_aroundUsersView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_lastUpdateTime == nil && [g_pIMMyself aroundState] == IMAroundStateNormal) {
        [_aroundUsersView update];
        return;
    }
    
    NSTimeInterval lastTimeInterval = [_lastUpdateTime timeIntervalSince1970];
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    if (currentTimeInterval - lastTimeInterval > MAX_UPDATE_TIME && [g_pIMMyself aroundState] != IMAroundStateUpdating && [g_pIMMyself aroundState] != IMAroundStatePaging  && [g_pIMMyself loginStatus] == IMMyselfLoginStatusLogined) {
        
        //update every five minutes
        [_aroundUsersView update];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CLLocationDistance)distanceFromLocation:(CLLocation *)distLocation toLocation:(CLLocation *)originLocation {
    
    CLLocationDistance distance = [originLocation distanceFromLocation:distLocation]/1000;
    
    return distance;
}


#pragma mark - around view datasource

- (UIView *)aroundUsersView:(IMAroundUsersView *)aroundUsersView viewAtRowIndex:(NSInteger)rowIndex {
    if (rowIndex == 0) {
        IMUserLocation *firstLocation = [[g_pIMMyself aroundUserLocationList] objectAtIndex:0];
        
        if ([[firstLocation customUserID]isEqualToString:[g_pIMMyself customUserID]]) {
            _myselfLocation = firstLocation;
        }
    }
    
    IMAroundViewCell *cellView = [[IMAroundViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    IMUserLocation *location = [[g_pIMMyself aroundUserLocationList] objectAtIndex:rowIndex];
    
    UIImage *image = [g_pIMSDK mainPhotoOfUser:[location customUserID]];
    
    if (image == nil) {
        image = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [cellView setHeadPhoto:image];
    [cellView setCustomUserID:[location customUserID]];
    
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:[_myselfLocation latitude] longitude:[_myselfLocation longitude]];
    
    CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:[location latitude] longitude:[location longitude]];
    
    if (location != _myselfLocation) {
        NSString *distanceString = nil;
        CLLocationDistance distance = [self distanceFromLocation:fromLocation toLocation:toLocation];
        
        if (distance < 1) {
            if (distance < 0.1) {
                distance = 0.1;
            }
            distanceString = [NSString stringWithFormat:@"%d00米以内",(int)(distance * 10)];
        } else if(distance > 1000) {
            distanceString = [NSString stringWithFormat:@"千里之外"];
        } else {
            distanceString = [NSString stringWithFormat:@"%d千米",(int)distance];
        }
        [cellView setDistance:distanceString];

    }

    NSString *customUserInfo = [g_pIMSDK customUserInfoWithCustomUserID:[location customUserID]];
    
    if (customUserInfo == nil) {
        [g_pIMSDK requestCustomUserInfoWithCustomUserID:[location customUserID] success:^(NSString *customUserInfo) {
            NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
            
            if ([array count] >= 3) {
                [cellView setSignature:[array objectAtIndex:2]];
            }
            
        } failure:^(NSString *error) {
            
        }];
    } else {
        NSArray *array = [customUserInfo componentsSeparatedByString:@"\n"];
        
        if ([array count] >= 3) {
            [cellView setSignature:[array objectAtIndex:2]];
        }
    }
    
    
    return cellView;
}


#pragma mark - around view delegate

- (void)aroundUsersView:(IMAroundUsersView *)aroundUsersView didSelectRowWithUserLocation:(IMUserLocation *)userLocation {
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setCustomUserID:[userLocation customUserID]];
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)didUpdate:(NSArray *)aroundUserLocationList {
    _lastUpdateTime = [NSDate date];
}

- (void)updateFailedWithError:(NSString *)error {
    _notifyText = @"获取周边用户失败，请稍候重试";
    _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
    [self displayNotifyHUD];
}

- (void)nextPageFailedWithError:(NSString *)error {
    _notifyText = @"获取周边用户失败，请稍后重试";
    _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
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

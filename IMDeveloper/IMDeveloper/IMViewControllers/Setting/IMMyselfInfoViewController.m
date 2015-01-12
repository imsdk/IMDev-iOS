//
//  IMMyselfInfoViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-12.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMMyselfInfoViewController.h"
#import "IMMyselfInfoTableViewCell.h"
#import "IMDefine.h"
#import "IMMyselfInfoEditViewController.h"

#import "BDKNotifyHUD.h"

//IMSDK Headers
#import "IMMyself+CustomUserInfo.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+MainPhoto.h"

@interface IMMyselfInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IMMyselfInfoEditDelegate>

@end

@implementation IMMyselfInfoViewController {
    UITableView *_tableView;
    
    NSArray *_customInfoArray;
    NSString *_sex;
    NSString *_location;
    NSString *_signature;
    
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [_titleLabel setText:@"个人信息"];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMCustomUserInfoDidInitializeNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView= [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [[self view] addSubview:_tableView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMyselfInfoTableViewCell *cell = [[IMMyselfInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    if ([indexPath section] == 0) {
        UIImage *image = nil;
        
        image = [g_pIMSDK mainPhotoOfUser:[g_pIMMyself customUserID]];
        
        if (image == nil) {
            image = [UIImage imageNamed:@"IM_head_default.png"];
        }
        
        [cell setHeadPhoto:image];
        [[cell textLabel] setText:@"头像"];
    } else {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"名字"];
            [[cell detailTextLabel] setText:[g_pIMMyself customUserID]];
        } else if([indexPath row] == 1) {
            [[cell textLabel] setText:@"性别"];
            if ([_sex length] > 0) {
                [[cell detailTextLabel] setText:_sex];
            } else {
                [[cell detailTextLabel] setText:@"男"];
            }
        } else if([indexPath row] == 2) {
            [[cell textLabel] setText:@"地区"];
            if ([_location length] > 0) {
                [[cell detailTextLabel] setText:_location];
            } else {
                [[cell detailTextLabel] setText:@"未填写"];
            }
        } else {
            [[cell textLabel] setText:@"个性签名"];
            if ([_signature length] > 0) {
                [[cell detailTextLabel] setText:_signature];
            } else {
                [[cell detailTextLabel] setText:@"未填写"];
            }
        }
    }
    
    [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0f]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if ([indexPath row] == 0 && [indexPath section] == 1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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


#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath section] == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择",nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
        [actionSheet showFromTabBar:[self tabBarController].tabBar];
    } else if ([indexPath row] == 0) {
        return;
    } else{
        IMMyselfInfoEditViewController *controller = [[IMMyselfInfoEditViewController alloc] init];
        
        NSString *content = nil;
        
        if ([_customInfoArray count] >= [indexPath row]) {
            content = [_customInfoArray objectAtIndex:[indexPath row] - 1];
        }
        
        [controller setDelegate:self];
        [controller setContent:content];
        [controller setType:[indexPath row]];
        [[self navigationController] pushViewController:controller animated:YES];
    }
}


#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        UIImagePickerController *picker  = [[UIImagePickerController alloc] init];
        [picker setEdgesForExtendedLayout:UIRectEdgeNone];
        
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return;
        }
        UIImagePickerController *picker  = [[UIImagePickerController alloc] init];
        
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }

}


#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = nil;
    
    image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if (image) {

        [g_pIMMyself uploadMainPhoto:image success:^{
            _notifyText = @"上传头像成功";
            _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
            [self displayNotifyHUD];
            
            IMMyselfInfoTableViewCell *cell = [[_tableView visibleCells] objectAtIndex:0];
            
            [cell setHeadPhoto:image];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification([g_pIMMyself customUserID]) object:nil];
            
        } failure:^(NSString *error) {
            _notifyText = @"上传头像失败";
            _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
            [self displayNotifyHUD];
        }];
    }
}


#pragma mark - IMMyselfInfoEdit delegate

- (void)customUerInfoEdit:(NSInteger)type content:(NSString *)content {
    switch (type) {
        case 1:
        {
            _sex = content;
        }
            break;
        case 2:
        {
            _location = content;
        }
            break;
        case 3:
        {
            _signature = content;
        }
            break;
        default:
            break;
    }
    
    _customInfoArray = [NSArray arrayWithObjects:_sex,_location, _signature, nil];
    [_tableView reloadData];
    
    [g_pIMMyself commitCustomUserInfo:[_customInfoArray componentsJoinedByString:@"\n"] success:^{
        _notifyText = @"修改成功";
        _notifyImage = [UIImage imageNamed:@"IM_success_image.png"];
        [self displayNotifyHUD];
    } failure:^(NSString *error) {
        
        _notifyText = @"修改信息失败";
        _notifyImage = [UIImage imageNamed:@"IM_failed_image.png"];
        [self displayNotifyHUD];
        
        NSString *customInfo = [g_pIMMyself customUserInfo];
        
        _customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        
        if ([_customInfoArray count] > 0) {
            _sex = [_customInfoArray objectAtIndex:0];
        }
        
        if ([_customInfoArray count] > 1) {
            _location = [_customInfoArray objectAtIndex:1];
        }
        
        if ([_customInfoArray count] > 2) {
            _signature = [_customInfoArray objectAtIndex:2];
        }
        
        [_tableView reloadData];
    }];
}


#pragma mark - notifications

- (void)loadData {
    NSString *customInfo = [g_pIMMyself customUserInfo];
    
    _sex = @"";
    _signature = @"";
    _location = @"";
    _customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
    
    if ([_customInfoArray count] > 0) {
        _sex = [_customInfoArray objectAtIndex:0];
    }
    
    if ([_customInfoArray count] > 1) {
        _location = [_customInfoArray objectAtIndex:1];
    }
    
    if ([_customInfoArray count] > 2) {
        _signature = [_customInfoArray objectAtIndex:2];
    }
    
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

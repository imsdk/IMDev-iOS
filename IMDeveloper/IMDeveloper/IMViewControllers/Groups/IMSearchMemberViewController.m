//
//  IMSearchMemberViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMSearchMemberViewController.h"
#import "IMAroundViewCell.h"
#import "IMDefine.h"
#import "UIView+IM.h"

#import "BDKNotifyHUD.h"
#import "MBProgressHUD.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"
#import "IMMyself+CustomUserInfo.h"
#import "IMSDK+CustomUserInfo.h"

@interface IMSearchMemberViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation IMSearchMemberViewController{
    //UI
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    UIBarButtonItem *_doneBarButtonItem;
    
    MBProgressHUD *_hud;
    BDKNotifyHUD *_notify;
    NSString *_notifyText;
    UIImage *_notifyImage;
    
    //data
    NSMutableArray *_searchResult;
    NSString *_selectedCustomUserID;
    NSIndexPath *_lastIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_titleLabel setText:@"添加群成员"];
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonItemClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_doneBarButtonItem];
    
    _searchResult = [[NSMutableArray alloc] initWithCapacity:32];
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds]  style:UITableViewStylePlain];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setEditing:YES];
    [[self view] addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [_searchBar setPlaceholder:@"请填写你要添加的用户名"];
    [_searchBar setDelegate:self];
    [_tableView setTableHeaderView:_searchBar];
    
    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneBarButtonItemClick:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAddGroupMemberNotification object:_selectedCustomUserID];
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    IMAroundViewCell *cellView = [[IMAroundViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    UIImage *image = [g_pIMSDK mainPhotoOfUser:[_searchBar text]];
    
    if (image == nil) {
        image = [UIImage imageNamed:@"IM_head_default.png"];
        
        [g_pIMSDK requestMainPhotoOfUser:[_searchBar text] success:^(UIImage *mainPhoto) {
            if (mainPhoto) {
                [cellView setHeadPhoto:mainPhoto];
                [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification([_searchBar text]) object:nil];
            }
        } failure:^(NSString *error) {
            
        }];
    }
    
    [cellView setHeadPhoto:image];
    [cellView setCustomUserID:[_searchBar text]];
    
    NSString *customUserInfo = [g_pIMSDK customUserInfoWithCustomUserID:[_searchBar text]];
    
    if (customUserInfo == nil) {
        [g_pIMSDK requestCustomUserInfoWithCustomUserID:[_searchBar text] success:^(NSString *customUserInfo) {
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
    
    [[cellView signatureLabel] setLeft:[[cellView signatureLabel] left] - 60];
    
    [cellView setTag:[indexPath row] + 1];
    
    for (UIView *view in [[cell contentView] subviews]) {
        [view removeFromSuperview];
    }
    [[cell contentView] addSubview:cellView];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_lastIndex) {
        [tableView deselectRowAtIndexPath:_lastIndex animated:YES];
    }
    
    _selectedCustomUserID = [_searchResult objectAtIndex:[indexPath row]];
    
    _lastIndex = indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    _lastIndex = nil;
    _selectedCustomUserID = nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *customUserID = [_searchResult objectAtIndex:[indexPath row]];
    
    if ([_customUserIDs containsObject:customUserID]) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - searchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (_hud) {
        [_hud removeFromSuperview];
        _hud = nil;
    }
    
    _hud = [[MBProgressHUD alloc] initWithView:[self view]];
    
    [[self view] addSubview:_hud];
    [_hud show:YES];
    [[self view] endEditing:YES];
    
    [_searchResult removeAllObjects];
    
    [g_pIMSDK requestCustomUserInfoWithCustomUserID:[searchBar text] success:^(NSString *customUserInfo) {
        [_hud hide:YES];
        [_hud removeFromSuperview];
        _hud = nil;
        
        [_searchResult addObject:[searchBar text]];
        [_tableView reloadData];
    } failure:^(NSString *error) {
        [_hud hide:YES];
        [_hud removeFromSuperview];
        _hud = nil;
        
        _notifyText = @"无结果";
        _notifyImage =[UIImage imageNamed:@"IM_failed_image.png"];
        [self displayNotifyHUD];
        
        [_tableView reloadData];
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:nil];
    [searchBar setShowsCancelButton:NO animated:YES];
    [[self view] endEditing:YES];
    
    [_searchResult removeAllObjects];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

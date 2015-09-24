//
//  IMShopListViewController.m
//  IMDeveloper
//
//  Created by mac on 15/9/20.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "IMShopListViewController.h"
#import "IMDefine.h"
#import "JSONKit.h"
#import "IMAroundViewCell.h"
#import "IMUserDialogViewController.h"

#import "IMSDK+CustomerService.h"

@interface IMShopListViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation IMShopListViewController {
    UITableView *_tableView;
    UILabel *_totalNumLabel;
    NSMutableData *_dataForConnection;
    NSMutableArray *_shopList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shopList = [[NSMutableArray alloc] initWithCapacity:32];
    [self initViews];
    
    [_titleLabel setText:@"商家列表"];
}

- (void)initViews {
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 64;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:RGB(242, 242, 242)];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:RGB(6, 191, 4)];
    [[self view] addSubview:_tableView];
    
    UIView *customTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    
    [customTableFooterView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:customTableFooterView];
    
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 88)];
    
    [_totalNumLabel setBackgroundColor:[UIColor clearColor]];
    [_totalNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_totalNumLabel setTextColor:[UIColor grayColor]];
    [_totalNumLabel setNumberOfLines:0];
    [_totalNumLabel setFont:[UIFont systemFontOfSize:18]];
    [customTableFooterView addSubview:_totalNumLabel];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadGroupListNotification object:nil];
    
    [self getShopList];
}

- (void)getShopList {
    _dataForConnection = nil;
    
    _dataForConnection = [[NSMutableData alloc] initWithCapacity:32];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dev.rest.imdingtu.com:82/shop/v1/list"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_dataForConnection appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:_dataForConnection encoding:NSUTF8StringEncoding];
    
    NSArray *array = [string objectFromJSONString];
    
    [_shopList addObjectsFromArray:array];
    [_tableView reloadData];
    
    for (NSDictionary *dict in _shopList) {
        [g_pIMSDK requestServiceInfoWithCustomUserID:[dict objectForKey:@"cid"] success:^(IMServiceInfo *serviceInfo) {
            
        } failure:^(NSString *error) {
            
        }];
    }
}


#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_shopList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    
    IMAroundViewCell *cellView = [[IMAroundViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    NSDictionary *dict = [_shopList objectAtIndex:[indexPath row]];
    
    NSString *url = [dict objectForKey:@"avatar_url"];
    
    UIImage *image = nil;
    if (image == nil) {
        image = [UIImage imageNamed:@"IM_head_male.png"];
    }
    
    [cellView setHeadPhoto:image];
    [cellView setCustomUserID:[dict objectForKey:@"shop_name"]];
//    [cellView setDistance:[dict objectForKey:@""]];
    [cellView setSignature:[dict objectForKey:@"description"]];
    
    [[cell contentView] addSubview:cellView];

    return cell;
}


#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [_shopList objectAtIndex:[indexPath row]];
    
    IMUserDialogViewController *controller = [[IMUserDialogViewController alloc] init];
    
    [controller setIsCustomerSevice:YES];
    [controller setCustomUserID:[dict objectForKey:@"cid"]];
    [controller setTitle:[dict objectForKey:@"shop_name"]];
    [[self navigationController] pushViewController:controller animated:YES];
}

@end

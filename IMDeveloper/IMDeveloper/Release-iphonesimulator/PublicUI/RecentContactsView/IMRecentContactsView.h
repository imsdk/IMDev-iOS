//
//  IMRecentContactsView.h
//  IMSDK
//
//  Created by lyc on 14-10-4.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMRecentContactsView;

/**
 最近联系人界面数据源协议
 */
@protocol IMRecentContactsViewDatasource <NSObject>

@optional

/**
 用户可自定义每一个最近联系人的cell
 */
- (UIView *)recentContactsView:(IMRecentContactsView *)recentContactView viewAtIndex:(NSInteger)index;

@end

/**
 最近联系人界面操作协议
 */
@protocol IMRecentContactsViewDelegate <NSObject>

/**
 选择某个最近联系人用户的回调方法
 */
- (void)recentContactsView:(IMRecentContactsView *)recentContactView didSelectRowWithCustomUserID:(NSString *)customUserID;

@end

@interface IMRecentContactsView : UIView

@property (nonatomic, weak) id<IMRecentContactsViewDatasource> dataSource;
@property (nonatomic, weak) id<IMRecentContactsViewDelegate> delegate;

/**
 最近联系人界面，更新数据方法
 */
- (void)reloadData;

@end

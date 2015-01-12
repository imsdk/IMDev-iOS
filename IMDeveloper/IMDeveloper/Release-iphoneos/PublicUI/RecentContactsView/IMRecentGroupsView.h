//
//  IMRecentGroupsView.h
//  IMSDK
//
//  Created by mac on 15/1/2.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMRecentGroupsView;

/**
 最近联系群组界面数据源协议
 */
@protocol IMRecentGroupsViewDatasource <NSObject>

@optional

/**
 用户可自定义每一个最近联系群组的cell
 */
- (UIView *)recentGroupsView:(IMRecentGroupsView *)recentGroupsView viewAtIndex:(NSInteger)index;

@end

/**
 最近联系群组界面操作协议
 */
@protocol IMRecentGroupsViewDelegate <NSObject>

/**
 选择某个最近联系群组的回调方法
 */
- (void)recentGroupsView:(IMRecentGroupsView *)recentGroupsView didSelectRowWithGroupID:(NSString *)groupID;

@end

@interface IMRecentGroupsView : UIView

@property (nonatomic, weak) id<IMRecentGroupsViewDatasource> dataSource;
@property (nonatomic, weak) id<IMRecentGroupsViewDelegate> delegate;

/**
 最近联系群组界面，更新数据方法
 */
- (void)reloadData;

@end

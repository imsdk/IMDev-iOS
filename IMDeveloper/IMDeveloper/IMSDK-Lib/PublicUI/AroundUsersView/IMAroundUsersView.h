//
//  IMAroundUsersView.h
//  IMSDK
//
//  Created by lyc on 14-10-5.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUserLocation.h"

@class IMAroundUsersView;

/**
 周围用户界面数据源协议
 */
@protocol IMAroundUsersViewDataSource <NSObject>
@optional

/**
 自定义周围用户每一个cell
 */
- (UIView *)aroundUsersView:(IMAroundUsersView *)aroundUsersView viewAtRowIndex:(NSInteger)rowIndex;
@end

/**
 周围用户界面操作协议
 */
@protocol IMAroundUsersViewDelegate <NSObject>
@optional

/**
  选择某个周围用户的回调方法
 */
- (void)aroundUsersView:(IMAroundUsersView *)aroundUsersView didSelectRowWithUserLocation:(IMUserLocation *)userLocation;

/**
 @method
 @brief 更新地理位置成功回调方法
 @param aroundUserLocationList 第一页周围用户集合，为IMUserLocation对象的集合。
 */
- (void)didUpdate:(NSArray *)aroundUserLocationList;

/**
 @method
 @brief 更新地理位置失败的回调方法
 @param error 更新失败的错误信息
 */
- (void)updateFailedWithError:(NSString *)error;

/**
 @method
 @brief 获取下一页周围用户成功的回调方法
 @param aroundUserLocationList 下一页周围用户集合，为IMUserLocation对象的集合。
 */
- (void)didNextPage:(NSArray *)aroundUserLocationList;

/**
 @method
 @brief 获取下一页周围用户失败的回调方法
 @param error 获取失败的错误信息
 */
- (void)nextPageFailedWithError:(NSString *)error;
@end

@interface IMAroundUsersView : UIView

@property (nonatomic, weak) id<IMAroundUsersViewDataSource> dataSource;
@property (nonatomic, weak) id<IMAroundUsersViewDelegate> delegate;

/**
 更新地理位置，并从服务器重新获取周围用户数据
 */
- (void)update;

/**
 刷新本地周围用户数据
 */
- (void)reloadData;

@end

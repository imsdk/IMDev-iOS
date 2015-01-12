//
//  IMMyself+Around.h
//  IMSDK
//
//  Created by lyc on 14-10-13.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"
#import "IMUserLocation.h"
#import <Foundation/Foundation.h>

/**
 @enum
 @brief 获取周围用户时的更新状态
 */
typedef NS_ENUM(UInt8, IMAroundState) {
    IMAroundStateNormal = 0,   //未获取
    IMAroundStateUpdating,     //正在更新
    IMAroundStatePaging,       //正在获取下一页列表
    IMAroundStateReachEnd      //获取结束
};

/**
 @protocol
 @brief 周围用户协议
 @discussion IMMyself+Around类别中的方法，无论是否带block方法，只要注册接收回调的对象到aroundDelegate中，就能监听到回调方法。
 */
@protocol IMAroundDelegate <NSObject>

@optional


#pragma mark - 更新地理位置，获取周围用户

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


#pragma mark - 获取下一页周围用户

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


#pragma mark - Around category

/**
 @header IMMyself+Around
 @abstract IMMyself周围用户类别，为IMMyself提供获取周围用户功能
 */
@interface IMMyself (Around)

/**
 @property
 @brief 周围用户代理
 @discussion 遵循IMAroundDelegate协议
 */
@property (nonatomic, weak) id<IMAroundDelegate> aroundDelegate;


#pragma mark - 更新地理位置

/**
 @method
 @brief 更新地理位置，获取周围用户 （异步方法）
 */
- (void)update;

/**
 @method
 @brief 更新地理位置，获取周围用户 （异步方法）
 @param success               更新成功的block回调
 @param resultDictionary      更新成功的block回调的返回参数，字典类型,包含名周围用户列表等。
 @param failure               更新失败的block回调
 @param requestDictionary     更新失败的block回调的返回参数，字典类型,包含周围用户列表等。
 @param error                 更新失败的错误信息
 */
- (void)updateOnSuccess:(void (^)(NSArray *aroundUserLocationList))success
                  failure:(void (^)(NSString *error))failure;


#pragma mark - 获取下一页周围用户

/**
 @method
 @brief 获取下一页周围用户 （异步方法）
 */
- (void)nextPage;

/**
 @method
 @brief 获取下一页周围用户 （异步方法）
 @param success               获取成功的block回调
 @param resultDictionary      获取成功的block回调的返回参数，字典类型,包含名周围用户列表等。
 @param failure               获取失败的block回调
 @param requestDictionary     获取失败的block回调的返回参数，字典类型,包含周围用户列表等。
 @param error                 获取失败的错误信息
 */
- (void)nextPageOnSuccess:(void (^)(NSArray *aroundUserLocationList))success
                    failure:(void (^)(NSString *error))failure;


/**
 @method
 @brief 本地获取周围用户列表
 @return 周围用户结合，IMUserAround对象的集合
 */
- (NSArray *)aroundUserLocationList;

/**
 @method
 @brief 获取周围用户时的更新状态
 @return IMAroundState的枚举值
 */
- (IMAroundState)aroundState;

@end

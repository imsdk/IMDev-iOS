//
//  IMSDK+CustomUserInfo.h
//  IMSDK
//
//  Created by lyc on 14-10-13.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMSDK.h"

/**
 @protocol
 @brief 获取自定义用户信息协议
 @discussion IMSDK+CustomUserInfo类别中的方法，无论是否带block方法，只要注册接收回调的对象到customUserInfoDelegate中，就能监听到回调方法。
 */
@protocol IMSDKCustomUserInfoDelegate <NSObject>
@optional


#pragma mark - 获取自定义用户信息的回调

/**
 @method
 @brief 获取自定义用户信息成功的回调
 @param customUserInfo        自定义用户信息
 @param customUserID          获取对象的用户名
 @param timeIntervalSince1970 1970年到客户端提交自定义用户信息时间的秒数
 */
- (void)didRequestCustomUserInfo:(NSString *)customUserInfo
                withCustomUserID:(NSString *)customUserID
               clientRequestTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 获取自定义用户信息失败的回调
 @param customUserID          获取对象的用户名
 @param timeIntervalSince1970 1970年到客户端提交自定义用户信息时间的秒数
 @param error                 获取自定义用户信息失败的错误信息
 */
- (void)failedToRequestCustomUserInfoWithCustomUserID:(NSString *)customUserID
                                    clientRequestTime:(UInt32)timeIntervalSince1970
                                                error:(NSString *)error;
@end


#pragma mark - CustomUserInfo category（IMSDK）

/**
 @header IMSDK+CustomUserInfo.h
 @abstract IMSDK自定义用户信息类别，为IMSDK提供获取某个用户的自定义用户信息功能
 */
@interface IMSDK (CustomUserInfo)

/**
 @property
 @brief 获取自定义用户信息代理
 @discussion 遵循IMSDKCustomUserInfoDelegate协议
 */
@property (nonatomic, weak) id<IMSDKCustomUserInfoDelegate> customUserInfoDelegate;

- (NSString *)customUserInfoWithCustomUserID:(NSString *)customUserID;


#pragma mark - 获取自定义用户信息

/**
 @method
 @brief 请求自定义用户信息（异步方法，从服务器请求）
 @param customUserInfo        自定义用户信息
 @return 1970年到客户端获取自定义用户信息时间的秒数
 */
- (UInt32)requestCustomUserInfoWithCustomUserID:(NSString *)customUserID;

/**
 @method
 @brief 请求自定义用户信息（异步方法，从服务器请求）
 @param customUserInfo        自定义用户信息
 @param success               获取自定义用户信息成功的block回调
 @param customUserInfo        获取自定义用户信息成功的block回调的返回参数，字符串类型，该参数为成功获取到的自定义用户信息。
 @param failure               获取自定义用户信息失败的block回调
 @param error                 获取自定义用户信息失败的错误信息
 @return 1970年到客户端获取自定义用户信息时间的秒数
 */
- (UInt32)requestCustomUserInfoWithCustomUserID:(NSString *)customUserID
                                        success:(void (^)(NSString *customUserInfo))success
                                        failure:(void (^)(NSString *error))failure;
@end

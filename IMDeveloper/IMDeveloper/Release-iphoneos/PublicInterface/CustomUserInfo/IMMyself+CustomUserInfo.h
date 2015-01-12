//
//  IMMyself+CustomUserInfo.h
//  IMSDK
//
//  Created by lyc on 14-10-10.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"

/**
 @protocol 
 @brief 提交自定义用户信息协议
 @discussion IMMyself+CustomUserInfo类别中的方法，无论是否带block方法，只要注册接收回调的对象到customUserInfoDelegate中，就能监听到回调方法。
 */
@protocol IMCustomUserInfoDelegate <NSObject>
@optional

/**
 @method
 @brief 用户信息初始化成功回调
 @discussion 用户登录成功后，IMSDK会在后台获取用户个人信息，调用此方法表明已初始化成功，获取失败也表示初始化成功。
 */
- (void)customUserInfoDidInitialize;


#pragma mark - 提交自定义用户信息的回调

/**
 @method
 @brief 提交自定义用户信息成功的回调
 @param customUserInfo        自定义用户信息
 @param timeIntervalSince1970 1970年到客户端提交自定义用户信息时间的秒数
 */
- (void)didCommitCustomUserInfo:(NSString *)customUserInfo clientCommitTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 提交自定义用户信息失败的回调
 @param customUserInfo        自定义用户信息
 @param timeIntervalSince1970 1970年到客户端提交自定义用户信息时间的秒数
 @param error                 提交自定义用户信息失败的错误信息
 */
- (void)failedToCommitCustomUserInfo:(NSString *)customUserInfo
                    clientCommitTime:(UInt32)timeIntervalSince1970
                               error:(NSString *)error;
@end


#pragma mark - CustomUserInfo category

/**
 @header IMMyself+CustomUserInfo.h
 @abstract IMMyself自定义用户信息类别，为IMMyself提供获取和提交当前登录用户的自定义用户信息功能
 */
@interface IMMyself (CustomUserInfo)

/**
 @method
 @brief 获取当前登录用户的用户信息初始化状态
 @discussion 用户登录成功后，IMSDK会在后台获取用户个人信息，返回值为YES表示已获取成功，NO表示还在获取，如果获取失败返回值也为YES。
 @return YES表示已初始化成功，NO表示初始化失败
 */
- (BOOL)customUserInfoInitialized;

/**
 @property
 @brief 提交自定义用户信息代理
 @discussion 遵循IMCustomUserInfoDelegate协议
 */
@property (nonatomic, weak) id<IMCustomUserInfoDelegate> customUserInfoDelegate;

/**
 @property
 @brief 获取当前登录用户的自定义用户信息
 @discussion 从本地获取，只可读
 */
@property (nonatomic, readonly) NSString *customUserInfo;


#pragma mark - 提交自定义用户信息

/**
 @method
 @brief 提交自定义用户信息（异步方法，提交到服务器）
 @param customUserInfo        自定义用户信息
 @return 1970年到客户端提交自定义用户信息时间的秒数
 */
- (UInt32)commitCustomUserInfo:(NSString *)customUserInfo;

/**
 @method
 @brief 提交自定义用户信息（异步方法，提交到服务器）
 @param customUserInfo        自定义用户信息
 @param success               提交自定义用户信息成功的block回调
 @param failure               提交自定义用户信息失败的block回调
 @param error                 提交自定义用户信息失败的错误信息
 @return 1970年到客户端提交自定义用户信息时间的秒数
 */
- (UInt32)commitCustomUserInfo:(NSString *)customUserInfo
                       success:(void (^)())success
                       failure:(void (^)(NSString *error))failure;
@end

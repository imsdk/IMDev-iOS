//
//  IMMyself.h
//  IMSDK
//
//  Created by lyc on 14-8-16.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @enum
 @brief 登录状态
 */
typedef NS_ENUM(NSInteger, IMMyselfLoginStatus) {
    IMMyselfLoginStatusNone = 0,        // 未登录
    IMMyselfLoginStatusLogining = 1,    // 用户发起登录
    IMMyselfLoginStatusRelogining = 2,  // 断线重连
    IMMyselfLoginStatusLogouting = 3,   // 用户发起注销
    IMMyselfLoginStatusLogined = 11,    // 已登录
};

/**
 @protocol
 @brief IMMyself登录和文本消息代理
 @discussion IMMyself类中的方法，无论是否带block方法，只要注册接收回调的对象到delegate中，就能监听到回调方法
 */
@protocol IMMyselfDelegate <NSObject>

@optional


#pragma mark - 登录回调

/**
 @method
 @brief 登录成功回调方法
 @param autoLogin 是否是自动登录
 */
- (void)didLogin:(BOOL)autoLogin;

/**
 @method
 @brief 登录失败回调方法
 @param error 登录失败的错误信息
 */
- (void)loginFailedWithError:(NSString *)error;


#pragma mark - 注销回调

/**
 @method
 @brief 注销成功回调方法
 @param reason 注销原因
 */
- (void)didLogoutFor:(NSString *)reason;

/**
 @method
 @brief 注销失败回调方法
 @param error 注销失败的错误信息
 */
- (void)logoutFailedWithError:(NSString *)error;

- (void)loginStatusDidUpdate:(IMMyselfLoginStatus)status;


#pragma mark 发送文本消息回调

/**
 @method
 @brief 发送文本消息成功的回调方法
 @param text                  文本消息内容
 @param customUserID          接收方的用户名
 @param timeIntervalSince1970 1970年到客户端发送文本消息时间的秒数
 */
- (void)didSendText:(NSString *)text
             toUser:(NSString *)customUserID
     clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送文本消息失败的回调方法
 @param text                  文本消息内容
 @param customUserID          接收方的用户名
 @param timeIntervalSince1970 1970年到客户端发送文本消息时间的秒数
 @param error                 发送文本消息失败的错误信息
 */
- (void)failedToSendText:(NSString *)text
                  toUser:(NSString *)customUserID
          clientSendTime:(UInt32)timeIntervalSince1970
                   error:(NSString *)error;

/**
 @method
 @brief 接收到文本消息的回调方法
 @param text                  文本消息内容
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送文本消息时间的秒数
 */
- (void)didReceiveText:(NSString *)text
      fromCustomUserID:(NSString *)customUserID
        serverSendTime:(UInt32)timeIntervalSince1970;

#pragma mark 系统消息

/**
 @method
 @brief 接收到系统消息的回调方法
 @param text                  系统消息内容
 @param timeIntervalSince1970 1970年到服务端发送系统消息时间的秒数
 */
- (void)didReceiveSystemText:(NSString *)text serverSendTime:(UInt32)timeIntervalSince1970;

@end


#pragma mark - IMMyself class

/**
 @header IMMyself.h
 @abstract IMSDK的核心类之一，指代当前登录用户对象
 */
@interface IMMyself : NSObject

/**
 @method
 @brief 获取IMMyself单例对象
 */
+ (id)sharedInstance;

/**
 @property
 @brief IMMyself基本代理，包含登录注销和文本消息等
 @discussion 遵循IMMyselfDelegate协议
 */
@property (nonatomic, weak) id<IMMyselfDelegate> delegate;

/**
 @method
 @brief 获取登录用户名
 */
- (NSString *)customUserID;

/**
 @method
 @brief 获取应用标识
 */
- (NSString *)appKey;

/**
 @method
 @brief 判断当前用户是否登录
 */
- (BOOL)isLogined;

/**
 @property
 @brief 获取登录状态
 @discussion 登录状态为IMMyselfLoginStatus的枚举
 */
@property (nonatomic, readonly) IMMyselfLoginStatus loginStatus;

/**
 @method
 @brief 初始化登录信息
 @param customUserID 登录用户名，不能为nil，长度不能超过64个字节
 @param appkey       应用标识，不能为空，开发者需要填写从IMSDK.im官网注册时获取的appkey
 */
- (void)initWithCustomUserID:(NSString *)customUserID appKey:(NSString *)appKey;

/**
 @property
 @brief 是否自动登录
 @discussion 默认为YES，自动登录
 */
@property (nonatomic, assign) BOOL autoLogin;


#pragma mark - 登录

/**
 @method
 @brief 登录接口 （异步方法）
 */
- (void)login;

/**
 @method
 @brief 登录接口 （异步方法）
 @param timeoutInterval 登录超时时间
 */
- (void)loginWithTimeoutInterval:(UInt32)timeoutInterval;

/**
 @method
 @brief 登录接口 （异步方法）
 @param success               登录成功的block回调
 @param autoLogin             是否自动登录
 @param failure               登录失败的block回调
 @param error                 登录失败的错误信息
 */
- (void)loginOnSuccess:(void (^)(BOOL autoLogin))success
                 failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 登录接口 （异步方法）
 @param timeoutInterval       登录超时时间
 @param success               登录成功的block回调
 @param autoLogin             是否自动登录
 @param failure               登录失败的block回调
 @param error                 登录失败的错误信息
 */
- (void)loginWithTimeoutInterval:(UInt32)timeoutInterval
                         success:(void (^)(BOOL autoLogin))success
                         failure:(void (^)(NSString *error))failure;

/**
 @property
 @brief 登录密码
 @discussion 登录密码不能为空，小于16个字节
 */
@property (nonatomic, copy) NSString *password;


#pragma mark - 注销
/**
 @method
 @brief 注销接口 （异步方法）
 @discussion 注销将会自动将IMSDK对应当前用户的deviceToken清空，注销后用户收不到来自IMSDK的推送消息，注销可能需要少许时间
 */
- (void)logout;

/**
 @method
 @brief 注销接口 （异步方法）
 @param success               注销成功的block回调
 @param resaon                注销原因
 @param failure               注销失败的block回调
 @param error                 注销失败的错误信息
 */
- (void)logoutOnSuccess:(void (^)(NSString *reason))success
                  failure:(void (^)(NSString *error))failure;


#pragma mark - 发送文本消息

/**
 @method
 @brief 发送文本消息 （异步方法）
 @param text                  文本消息内容
 @param customUserID          接收方的用户名
 */
- (UInt32)sendText:(NSString *)text toUser:(NSString *)customUserID;

/**
 @method
 @brief 发送文本消息 （异步方法）
 @param text                  文本消息内容
 @param customUserID          接收方的用户名
 @param success               发送文本消息成功的block回调
 @param resultDictionary      发送文本消息成功的block回调的返回参数，字典类型,包含文本消息内容，接收方用户名，发送时间等。
 @param failure               发送文本消息失败的block回调
 @param requestDictionary     发送文本消息失败的block回调的返回参数，字典类型,包含文本消息内容，接收方用户名，发送时间等。
 @param error                 发送文本消息失败的错误信息
 */
- (UInt32)sendText:(NSString *)text toUser:(NSString *)customUserID
           success:(void (^)())success
           failure:(void (^)(NSString *error))failure;

@end

#define g_pIMMyself [IMMyself sharedInstance]













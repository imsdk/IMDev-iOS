//
//  IMMyself.h
//  IMSDK
//
//  Created by lyc on 14-8-16.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/**
 @enum
 @brief 登录状态
 */
typedef NS_ENUM(NSInteger, IMMyselfLoginStatus) {
    // 未登录
    IMMyselfLoginStatusNone = 0,        // 未登录
    IMMyselfLoginStatusLogining = 1,    // 用户发起登录
    IMMyselfLoginStatusReconnecting = 2,  // 断线重连
    IMMyselfLoginStatusAutoLogining = 4,  // 自动登录
    // 未登录 end
    
    // 已登录
    IMMyselfLoginStatusLogouting = 10,   // 用户发起退出登录
    IMMyselfLoginStatusLogined = 11,    // 已登录
    // 已登录 end
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
 @brief 登录成功 的回调方法
 @param autoLogin 是否是自动登录
 */
- (void)didLogin:(BOOL)autoLogin;

/**
 @method
 @brief 登录失败 的回调方法
 @param error 登录失败的错误信息
 */
- (void)loginFailedWithError:(NSString *)error;


#pragma mark - 注销回调

/**
 @method
 @brief 退出登录成功 的回调方法
 @param reason 注销原因
 */
- (void)didLogoutFor:(NSString *)reason;

- (void)didLoseConnection;

- (void)didReconnect;

/**
 @method
 @brief 登录状态更新 的回调方法
 @param oldStatus 原来的登录状态
 @param newStatus 新的登录状态
 */
- (void)loginStatusDidUpdateForOldStatus:(IMMyselfLoginStatus)oldStatus newStatus:(IMMyselfLoginStatus)newStatus;


#pragma mark 发送消息成功回调

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
 @brief 发送语音消息成功的回调方法
 @param data             语音消息内容
 @param format           语音格式
 @param fileID                文件ID
 @param customUserID          接收方的用户名
 @param timeIntervalSince1970 1970年到客户端发送语音消息时间的秒数
 */
- (void)didSendAudioData:(NSData *)data
             audioFormat:(NSString *)format
                  fileID:(NSString *)fileID
                  toUser:(NSString *)toCustomUserID
          clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送图片消息成功的回调方法
 @param photo                 图片消息内容
 @param fileID                文件ID
 @param customUserID          接收方的用户名
 @param timeIntervalSince1970 1970年到客户端发送图片消息时间的秒数
 */
- (void)didSendPhoto:(UIImage *)photo
              fileID:(NSString *)fileID
              toUser:(NSString *)toCustomUserID
      clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送用户间图片消息进度的回调方法
 @param progress              取值范围为 0-1 -- (0, 1]
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送文本消息时间的秒数
 */
- (void)didSendPhoto:(UIImage *)photo
            Progress:(CGFloat)progress
    fromCustomUserID:(NSString *)customUserID
      clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送系统文本消息成功的回调方法
 @param text                  文本消息内容
 @param timeIntervalSince1970 1970年到客户端发送文本消息时间的秒数
 */
- (void)didSendSystemText:(NSString *)text
           clientSendTime:(UInt32)timeIntervalSince1970;


#pragma mark 发送消息失败回调

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
 @brief 发送语音消息失败的回调方法
 @param data                  语音消息内容
 @param customUserID          接收方的用户名
 @param timeIntervalSince1970 1970年到客户端发送语音消息时间的秒数
 @param error                 发送语音消息失败的错误信息
 */
- (void)failedToSendAudioData:(NSData *)data
                       toUser:(NSString *)customUserID
               clientSendTime:(UInt32)timeIntervalSince1970
                        error:(NSString *)error;

/**
 @method
 @brief 发送图片消息失败的回调方法
 @param photo                 图片消息内容
 @param customUserID          接收方的用户名
 @param timeIntervalSince1970 1970年到客户端发送图片消息时间的秒数
 @param error                 发送图片消息失败的错误信息
 */
- (void)failedToSendPhoto:(UIImage *)photo
                   toUser:(NSString *)customUserID
           clientSendTime:(UInt32)timeIntervalSince1970
                    error:(NSString *)error;

/**
 @method
 @brief 给服务器发送文本消息失败的回调方法
 @param text                  文本消息内容
 @param timeIntervalSince1970 1970年到客户端发送文本消息时间的秒数
 @param error                 发送文本消息失败的错误信息
 */
- (void)failedToSendSystemText:(NSString *)text
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




#pragma mark 用户间语音消息
/**
 @method
 @brief 接收到用户间语音消息的回调方法
 @param data                  语音消息数据内容（如果是来自于界面版的语音消息，则格式为amr）
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送文本消息时间的秒数
 */
- (void)didReceiveAudioData:(NSData *)data
                audioFormat:(NSString *)format
                     fileID:(NSString *)fileID
           fromCustomUserID:(NSString *)customUserID
             serverSendTime:(UInt32)timeIntervalSince1970;

#pragma mark 用户间图片消息
/**
 @method
 @brief 接收到用户间图片消息的回调方法
 @param photo                 收到的图片
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送文本消息时间的秒数
 */
- (void)didReceivePhoto:(UIImage *)photo
                 fileID:(NSString *)fileID
       fromCustomUserID:(NSString *)customUserID
         serverSendTime:(UInt32)timeIntervalSince1970;


#pragma mark 用户间图片消息进度
/**
 @method
 @brief 接收用户间图片消息进度的回调方法
 @param progress              取值范围为 0-1 -- (0, 1]
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送文本消息时间的秒数
 */
- (void)didReceivePhotoProgress:(CGFloat)progress
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
 @brief 初始化用户数据
 @param customUserID 登录用户名，只能由2～32个字节的字母数字,'_'和'.'组成。
 */
- (void)setCustomUserID:(NSString *)customUserID;

/**
 @property
 @brief 是否自动登录
 @discussion 默认为YES，自动登录
 */
@property (nonatomic, assign) BOOL autoLogin;

- (void)checkExistanceOfCustomUserID:(NSString *)customUserID success:(void (^)(BOOL exist))success failure:(void (^)(NSString *error))failure;


#pragma mark - 注册与登录

/**
 @method
 @brief 注册接口 （异步方法） 注册成功后会自动登录
 @param timeoutInterval       注册超时时间
 @param success               注册成功的block回调
 @param failure               注册失败的block回调
 @param error                 注册失败的错误信息
 */
- (UInt32)registerWithTimeoutInterval:(UInt32)timeoutInterval
                              success:(void (^)())success
                              failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 登录接口 （异步方法）
 */
- (UInt32)loginWithTimeoutInterval:(UInt32)timeoutInterval
                           success:(void (^)())success
                           failure:(void (^)(NSString *error))failure;


/**
 @method  （v1.2.3及以后）
 @brief  自动注册接口（异步方法） IMSDK一键注册，自动生成用户名和密码，注册成功后自动登录
 @param timeoutInterval       注册超时时间
 @param success               注册并登录成功的block回调
 @param customUserID          注册成功自动生成的用户名
 @param password              注册成功自动生成的密码
 @param failure               注册失败的block回调
 @param error                 注册失败的错误信息
 */
- (UInt32)autoRegisterWithTimeoutInterval:(UInt32)timeoutInterval
                                  success:(void(^)(NSString *customUserID ,NSString *password))success
                                  failure:(void(^)(NSString * error))failure;

/**
 @property
 @brief 登录密码
 @discussion 登录密码不能为空，小于16个字节
 */
@property (nonatomic, copy) NSString *password;


#pragma mark - 客服行为

/**
 @method
 @brief 客服登录接口 （异步方法）
 */

- (UInt32)loginCustomerServiceWithTimeOutInterval:(UInt32)timeoutInterval
                                          success:(void (^)())success
                                          failure:(void (^)(NSString *error))failure;


#pragma mark - 注销
/**
 @method
 @brief 退出登录接口 （同步方法）
 @discussion 退出登录将会自动将IMSDK对应当前用户的deviceToken清空，退出登录后用户收不到来自IMSDK的推送消息
 */
- (void)logout;

- (void)logoutOnCompletion:(void(^)(void))completion;


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
 @param failure               发送文本消息失败的block回调
 @param error                 发送文本消息失败的错误信息
 */
- (UInt32)sendText:(NSString *)text
            toUser:(NSString *)customUserID
           success:(void (^)())success
           failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 向IMSDK服务器发送文本消息 （异步方法，可在IMSDK.im开发者中心查看）
 @param text                  文本消息内容
 @param success               发送文本消息成功的block回调
 @param failure               发送文本消息失败的block回调
 @param error                 发送文本消息失败的错误信息
 */
- (UInt32)sendSystemText:(NSString *)text
                 success:(void (^)())success
                 failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 插入一条通知消息，存入与关联customUserID的历史消息记录中（同步方法，不涉及网络交互）
 */
- (BOOL)insertNotice:(NSString *)text relatedCustomUserID:(NSString *)customUserID;

/**
 @method
 @brief 发送语音消息方法
 @param data             语音消息内容
 @param format           语音格式
 @param fileID           文件ID
 @param customUserI      接收方的用户名
 @param success          发送成功的block回调
 @param failure          发送失败的block回调
 @param 返回值 1970年到客户端发送语音消息时间的秒数
 */
- (UInt32)sendAudioData:(NSData *)data
            audioFormat:(NSString *)format
                 toUser:(NSString *)customUserID
               succeess:(void (^)(NSString *fileID))success
                failure:(void (^)(NSString *error))failure;

- (UInt32)sendPhoto:(UIImage *)photo
             toUser:(NSString *)customUserID
            success:(void (^)(NSString *fileID))success
           progress:(void(^)(CGFloat progress))progress
            failure:(void (^)(NSString *error))failure;

@end

#define g_pIMMyself [IMMyself sharedInstance]













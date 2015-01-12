//
//  IMMyself+CustomMessage.h
//  IMSDK
//
//  Created by lyc on 14-10-13.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"

/**
 @protocol
 @brief 自定义文本消息协议
 @discussion IMMyself+CustomMessage类别中的方法，无论是否带block方法，只要注册接收回调的对象到customDelegate中，就能监听到回调方法。
 */
@protocol IMCustomMessageDelegate <NSObject>

@optional


#pragma mark - 自定义文本消息的回调

/**
 @method
 @brief 发送自定义文本消息成功的回调方法
 @param text                  自定义文本消息的内容
 @param customUserID          接收方的用户名
 @param pushNotificationText  需要远程推送的消息，可为空
 @param timeIntervalSince1970 1970年到客户端发送自定义文本消息时间的秒数
 */
- (void)didSendCustomMessage:(NSString *)text
                      toUser:(NSString *)customUserID
        pushNotificationText:(NSString *)pushNotificationText
              clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送自定义文本消息失败的回调方法
 @param text                  自定义文本消息的内容
 @param customUserID          接收方的用户名
 @param pushNotificationText  需要远程推送的消息，可为空
 @param timeIntervalSince1970 1970年到客户端发送自定义文本消息时间的秒数
 @param error                 发送自定义文本消息失败的错误信息
 */
- (void)failedToSendCustomMessage:(NSString *)text
                           toUser:(NSString *)customUserID
             pushNotificationText:(NSString *)pushNotificationText
                   clientSendTime:(UInt32)timeIntervalSince1970
                            error:(NSString *)error;

/**
 @method
 @brief 接收到自定义文本消息的回调方法
 @param text                  自定义文本消息的内容
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送自定义文本消息时间的秒数
 */
- (void)didReceiveCustomMessage:(NSString *)text
               fromCustomUserID:(NSString *)customUserID
                 serverSendTime:(UInt32)timeIntervalSince1970;

@end


#pragma mark - CustomMessage category

/**
 @header IMMyself+CustomMessage.h
 @abstract IMMyself自定义文本消息类别，为IMMyself提供发送和接收自定义文本消息功能。
 */
@interface IMMyself (CustomMessage)

/**
 @property
 @brief 自定义文本消息代理
 @discussion 遵循IMCustomMessageDelegate
 */
@property (nonatomic, weak) id<IMCustomMessageDelegate> customMessageDelegate;


#pragma mark - 发送自定义文本消息的回调

/**
 @method
 @brief 发送自定义文本消息（异步方法）
 @param text                  自定义文本消息的内容
 @param customUserID          接收方的用户名
 @param pushNotificationText  需要远程推送的消息，可为空
 @return 1970年到客户端发送自定义文本消息时间的秒数
 */
- (UInt32)sendCustomMessage:(NSString *)text
       pushNotificationText:(NSString *)pushNotificationText
                     toUser:(NSString *)customUserID;

/**
 @method
 @brief 发送自定义文本消息（异步方法）
 @param text                  自定义文本消息的内容
 @param customUserID          接收方的用户名
 @param pushNotificationText  需要远程推送的消息，可为空
 @param success               发送自定义文本消息成功的block回调
 @param failure               发送自定义文本消息失败的block回调
 @param error                 发送自定义文本消息失败的错误信息
 @return 1970年到客户端发送自定义文本消息时间的秒数
 */
- (UInt32)sendCustomMessage:(NSString *)text
       pushNotificationText:(NSString *)pushNotificationText
                     toUser:(NSString *)customUserID
                    success:(void (^)())success
                    failure:(void (^)(NSString *error))failure;
@end



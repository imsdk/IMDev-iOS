//
//  IMMyself+UserPassword.h
//  IMSDK
//
//  Created by mac on 14-12-8.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"

@protocol IMUserPasswordDelegate <NSObject>

/**
 @method
 @brief 修改用户密码成功的回调方法
 @param oldPassword           原密码
 @param newPassword           新密码
 @param timeIntervalSince1970 1970年到客户端发送上传请求时间的秒数
 */
- (void)didModifyOldPassword:(NSString *)oldPassword
               toNewPassword:(NSString *)newPassword
              clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 修改用户密码失败的回调方法
 @param oldPassword           原密码
 @param newPassword           新密码
 @param timeIntervalSince1970 1970年到客户端发送上传请求时间的秒数
 @param error                 修改用户密码失败的错误原因
 */
- (void)failedToModifyOldPassword:(NSString *)oldPassword
                    toNewPassword:(NSString *)newPssaword
                   clientSendTime:(UInt32)timeIntervalSince1970
                            error:(NSString *)error;
@end

@interface IMMyself (UserPassword)

@property (nonatomic, weak) id<IMUserPasswordDelegate> userPasswordDelegate;

- (UInt32)modifyOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)freshPassword;

- (UInt32)modifyOldPassword:(NSString *)oldPassword
              toNewPassword:(NSString *)newPassword
                    success:(void (^)())success
                    failure:(void (^)(NSString *error))failure;

@end

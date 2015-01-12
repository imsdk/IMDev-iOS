//
//  IMMyself+Relationship.h
//  IMSDK
//
//  Created by lyc on 14-10-1.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"

/**
 @protocol
 @brief 好友关系协议
 @discussion IMMyself+Relationship类别中的方法，无论是否带block方法，只要注册接收回调的对象到relationshipDelegate中，就能监听到回调方法。
 */
@protocol IMRelationshipDelegate <NSObject>

@optional

/**
 @method
 @brief 用户关系初始化成功回调
 @discussion 用户登录成功后，IMSDK会在后台获取用户好友关系和黑名单列表，调用此方法表示已初始化成功，如果获取失败也表示初始化成功。
 */
- (void)relationshipDidInitialize;


#pragma mark - 好友请求的回调方法

/**
 @method
 @brief 发送好友请求成功回调方法
 @param text                  加好友验证消息
 @param customUserID          添加对象的用户名
 @param timeIntervalSince1970 1970年到客户端发送好友请求时间的秒数
 */
- (void)didSendFriendRequest:(NSString *)text
                      toUser:(NSString *)customUserID
              clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送好友请求失败的回调方法
 @param text                  加好友验证消息
 @param customUserID          添加对象的用户名
 @param timeIntervalSince1970 1970年到客户端发送好友请求时间的秒数
 @param error                 发送好友请求失败的错误信息
 */
- (void)failedToSendFriendRequest:(NSString *)text
                           toUser:(NSString *)customUserID
                   clientSendTime:(UInt32)timeIntervalSince1970
                            error:(NSString *)error;

/**
 @method
 @brief 收到好友请求的回调方法
 @param text                  加好友验证消息
 @param customUserID          发送好友请求的用户名
 @param timeIntervalSince1970 1970年到服务端转发好友请求时间的秒数
 */
- (void)didReceiveFriendRequest:(NSString *)text
               fromCustomUserID:(NSString *)customUserID
                 serverSendTime:(UInt32)timeIntervalSince1970;


#pragma mark - 响应好友请求的回调方法

/**
 @method
 @brief 同意好友请求成功的回调方法
 @param customUserID          发送好友请求的用户名
 @param timeIntervalSince1970 1970年到客户端同意好友请求时间的秒数
 */
- (void)didAgreeToFriendRequestFromUser:(NSString *)customUserID clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 同意好友请求失败的回调方法
 @param customUserID          发送好友请求的用户名
 @param timeIntervalSince1970 1970年到客户端同意好友请求时间的秒数
 @param error                 同意好友请求失败的错误信息
 */
- (void)failedToAgreeToFriendRequestFromUser:(NSString *)customUserID
                              clientSendTime:(UInt32)timeIntervalSince1970
                                       error:(NSString *)error;

/**
 @method
 @brief 收到对方同意加你为好友的回调方法
 @param customUserID          同意加你为好友的用户名
 @param timeIntervalSince1970 1970年到服务端转发同意好友请求时间的秒数
 */
- (void)didReceiveAgreeToFriendRequestFromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 对方加入你的好友列表
 @param customUserID  对方的用户名
 @discussion 两个用户间的所有好友关系交互，服务端都不会解析，所以客户端在同意好友请求和收到对方同意加好友的消息后，都会给服务端发送一条建立好友关系的通知，服务端收到通知后，才会在服务器上更新用户的好友关系。
 */
- (void)didBuildFriendRelationshipWithUser:(NSString *)customUserID;

/**
 @method
 @brief 拒绝加好友成功的回调方法
 @param customUserID          发送好友请求的用户名
 @param timeIntervalSince1970 1970年到客户端拒绝好友请求时间的秒数
 */
- (void)didRejectToFriendRequestFromUser:(NSString *)customUserID clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 拒绝加好友失败的回调方法
 @param customUserID          发送好友请求的用户名
 @param timeIntervalSince1970 1970年到客户端拒绝好友请求时间的秒数
 @param error                 拒绝好友请求失败的错误信息
 */
- (void)failedToRejectToFriendRequestFromUser:(NSString *)customUserID clientRejectTime:(UInt32)timeIntervalSince1970 error:(NSString *)error;

/**
 @method
 @brief 收到对方拒绝加好友的回调方法
 @param customUserID          对方的用户名
 @param timeIntervalSince1970 1970年到服务端转发拒绝好友请求时间的秒数
 @param reason                对方拒绝加好友的原因
 */
- (void)didReceiveRejectFromCustomUserID:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970 reason:(NSString *)reason;


#pragma mark - 好友列表操作的回调方法

/**
 @method
 @brief 移除好友成功的回调方法
 @param customUserID        移除对象的用户名
 @param clientActionTime    1970年到客户端移除好友时间的秒数
 */
- (void)didRemoveUserFromFriendsList:(NSString *)customUserID clientActionTime:(UInt32)clientActionTime;

/**
 @method
 @brief 移除好友失败的回调方法
 @param customUserID        移除对象的用户名
 @param clientActionTime    1970年到客户端移除好友时间的秒数
 @param error               移除好友失败的错误信息
 */
- (void)failedToRemoveUserFromFriendsList:(NSString *)customUserID clientActionTime:(UInt32)clientActionTime error:(NSString *)error;

/**
 @method
 @brief 移除好友失败的回调方法
 @param customUserID        移除对象的用户名
 @param clientActionTime    1970年到客户端移除好友时间的秒数
 @param error               移除好友失败的错误信息
 */
- (void)didBreakUpFriendshipWithCustomUserID:(NSString *)customUserID;


#pragma mark - 黑名单列表操作的回调方法

/**
 @method
 @brief 将用户移到黑名单成功的回调方法
 @param customUserID        被加入黑名单的用户名
 @param clientActionTime    1970年到客户端操作时间的秒数
 */
- (void)didMoveUserToBlacklist:(NSString *)customUserID clientActionTime:(UInt32)clientActionTime;

/**
 @method
 @brief 将用户移到黑名单失败的回调方法
 @param customUserID        被加入黑名单的用户名
 @param clientActionTime    1970年到客户端操作时间的秒数
 @param error               将用户移到黑名单失败的错误信息
 */
- (void)failedToMoveUserToBlacklist:(NSString *)customUserID
                   clientActionTime:(UInt32)clientActionTime
                              error:(NSString *)error;

/**
@method
@brief 将用户从黑名单移除成功的回调方法
@param customUserID        从黑名单移除的用户名
@param clientActionTime    1970年到客户端操作时间的秒数
*/
- (void)didRemoveUserFromBlacklist:(NSString *)customUserID clientActionTime:(UInt32)clientActionTime;

/**
 @method
 @brief 将用户从黑名单移除成功的回调方法
 @param customUserID        从黑名单移除的用户名
 @param clientActionTime    1970年到客户端操作时间的秒数
 @param error               将用户从黑名单移除失败的错误信息
 */
- (void)failedToRemoveUserFromBlacklist:(NSString *)customUserID
                       clientActionTime:(UInt32)clientActionTime
                                  error:(NSString *)error;

@end


#pragma mark - RelationShip category
/**
 @header IMMyself+Relationship.h
 @abstract IMMyself用户关系类别，为IMMyself提供根据用户间关系操作功能
 */
@interface IMMyself (Relationship)

/**
 @method
 @brief 获取当前登录用户的用户关系列表初始化状态
 @discussion 用户登录成功后，IMSDK会在后台获取用户关系列表，返回值为YES表示已获取成功，NO表示还在获取，如果获取失败返回值也为YES。
 @return YES表示已初始化成功，NO表示初始化失败
 */
- (BOOL)relationshipInitialized;

/**
 @property
 @brief 用户间关系代理
 @discussion 遵循IMRelationshipDelegate协议
 */
@property (nonatomic, weak) id<IMRelationshipDelegate> relationshipDelegate;

/**
 @method
 @brief 从本地获取好友列表
 @return 好友用户名的集合
 */
- (NSArray *)friends;

/**
 @method
 @brief 从本地获取黑名单列表
 @return 黑名单用户名的集合
 */
- (NSArray *)blacklistUsers;

/**
 @method
 @brief 判断对方是否为当前登录用户的好友
 @param customUserID   对方的用户名
 @return YES表示对方是当前登录用户的好友，NO则反之
 */
- (BOOL)isMyFriend:(NSString *)customUserID;

/**
 @method
 @brief 判断对方是否为当前登录用户的黑名单用户
 @param customUserID   对方的用户名
 @return YES表示对方是当前登录用户的黑名单用户，NO则反之
 */
- (BOOL)isMyBlacklistUser:(NSString *)customUserID;


#pragma mark - 发送好友请求
/**
 @method
 @brief 发送加好友请求 （异步方法）
 @param text                验证消息
 @param customUserID        对方的用户名
 @return 1970年到客户端发送加好友请求时间的秒数
 */
- (UInt32)sendFriendRequest:(NSString *)text toUser:(NSString *)customUserID;

/**
 @method
 @brief 发送加好友请求 （异步方法）
 @param text                验证消息
 @param customUserID        对方的用户名
 @param success             发送请求成功的block回调
 @param failure             发送请求失败的block回调
 @param error               发送请求失败的错误信息
 @return 1970年到客户端发送加好友请求时间的秒数
 */
- (UInt32)sendFriendRequest:(NSString *)text
                     toUser:(NSString *)customUserID
                    success:(void (^)())success
                    failure:(void (^)(NSString *error))failure;


#pragma mark - 响应好友请求

/**
 @method
 @brief 同意加好友请求 （异步方法）
 @param customUserID        对方的用户名
 @return 1970年到客户端同意加好友请求时间的秒数
 */
- (UInt32)agreeToFriendRequestFromUser:(NSString *)customUserID;

/**
 @method
 @brief 同意加好友请求 （异步方法）
 @param customUserID        对方的用户名
 @param success             同意请求成功的block回调
 @param failure             同意请求失败的block回调
 @param error               同意请求失败的错误信息
 @return 1970年到客户端同意加好友请求时间的秒数
 */
- (UInt32)agreeToFriendRequestFromUser:(NSString *)customUserID
                               success:(void (^)())success
                               failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 拒绝加好友请求
 @param customUserID        对方的用户名
 @param reason              拒绝加好友请求的原因
 @return 1970年到客户端拒绝加好友请求时间的秒数
 */
- (UInt32)rejectToFriendRequestFromUser:(NSString *)customUserID reason:(NSString *)reason;

/**
 @method
 @brief 拒绝加好友请求 （异步方法）
 @param customUserID        对方的用户名
 @param reason              拒绝加好友请求的原因
 @param success             拒绝请求成功的block回调
 @param failure             拒绝请求失败的block回调
 @param error               拒绝请求失败的错误信息
 @return 1970年到客户端拒绝加好友请求时间的秒数
 */
- (UInt32)rejectToFriendRequestFromUser:(NSString *)customUserID
                                 reason:(NSString *)reason
                                success:(void (^)())success
                                failure:(void (^)(NSString *error))failure;


#pragma mark - 好友列表操作

/**
 @method
 @brief 移除好友 （异步方法）
 @param customUserID        被移除对象的用户名
 @return 1970年到客户端移除好友时间的秒数
 */
- (UInt32)removeFromFriendsList:(NSString *)customUserID;

/**
 @method
 @brief 移除好友 （异步方法）
 @param customUserID        被移除对象的用户名
 @param success             移除好友成功的block回调
 @param failure             发送请求失败的block回调
 @param error               移除好友失败的错误信息
 @return 1970年到客户端移除好友时间的秒数
 */
- (UInt32)removeFromFriendsList:(NSString *)customUserID
                        success:(void (^)())success
                        failure:(void (^)(NSString *error))failure;


#pragma mark - 黑名单列表操作

/**
 @method
 @brief 将用户移到黑名单 （异步方法）
 @param customUserID        对方的用户名
 @return 1970年到客户端操作时间的秒数
 */
- (UInt32)moveToBlacklist:(NSString *)customUserID;

/**
 @method
 @brief 将用户移到黑名单 （异步方法）
 @param customUserID        对方的用户名
 @param success             将用户移到黑名单成功的block回调
 @param failure             将用户移到黑名单失败的block回调
 @param error               将用户移到黑名单失败的错误信息
 @return 1970年到客户端操作时间的秒数
 */
- (UInt32)moveToBlacklist:(NSString *)customUserID
                  success:(void (^)())success
                  failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 将用户从黑名单移除 （异步方法）
 @param customUserID        对方的用户名
 @return 1970年到客户端操作时间的秒数
 */
- (UInt32)removeUserFromBlacklist:(NSString *)customUserID;

/**
 @method
 @brief 将用户从黑名单移除 （异步方法）
 @param customUserID        对方的用户名
 @param success             将用户从黑名单移除成功的block回调
 @param failure             将用户从黑名单移除失败的block回调
 @param error               将用户从黑名单移除失败的错误信息
 @return 1970年到客户端操作时间的秒数
 */
- (UInt32)removeUserFromBlacklist:(NSString *)customUserID
                          success:(void (^)())success
                          failure:(void (^)(NSString *error))failure;

@end

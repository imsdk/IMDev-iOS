//
//  IMMyself+Group.h
//  IMSDK
//
//  Created by lyc on 14-10-2.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"

/**
 @protocol
 @brief 群操作代理
 @discussion IMMyself+Group类别中的方法，无论是否带block方法，只要注册接收回调的对象到groupDelegate中，就能监听到回调方法。
 */
@protocol IMGroupDelegate <NSObject>

@optional

/**
 @method
 @brief 群组列表初始化成功回调
 @discussion 用户登录成功后，IMSDK会在后台获取用户群组列表，调用次方法表示已初始化成功，如果获取失败也表示初始化成功。
 */
- (void)groupListDidInitialize;


#pragma mark - 创建群组回调方法

/**
 @method
 @brief 创建群组成功回调方法
 @param groupName             群名称
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端创建群组时间的秒数
 */
- (void)didCreateGroupWithName:(NSString *)groupName
                       groupID:(NSString *)groupID
              clientActionTime:(UInt32)timeIntervalSince1970;


/**
 @method
 @brief 创建群组失败回调方法
 @param groupName             群名称
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端创建群组时间的秒数
 @param error                 创建群组失败的回调方法
 */
- (void)failedToCreateGroupWithName:(NSString *)groupName
                   clientActionTime:(UInt32)timeIntervalSince1970
                              error:(NSString *)error;


#pragma mark - 解散群组回调方法

/**
 @method
 @brief 解散群组成功回调方法
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端解散群组时间的秒数
 */
- (void)didRemoveGroup:(NSString *)groupID clientActionTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 解散群组失败回调方法
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端解散群组时间的秒数
 @param error                 解散群组失败的回调方法
 */
- (void)failedToRemoveGroup:(NSString *)groupID
           clientActionTime:(UInt32)timeIntervalSince1970
                      error:(NSString *)error;


#pragma mark - 添加群成员回调方法

/**
 @method
 @brief 添加群组成员成功回调方法
 @param customUserID          添加对象的用户名
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端添加群组成员时间的秒数
 */
- (void)didAddMember:(NSString *)customUserID
         toJoinGroup:(NSString *)groupID
    clientActionTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 添加群组成员失败回调方法
 @param customUserID          添加对象的用户名
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端添加群组成员时间的秒数
 @param error                 添加群成员失败的错误信息
 */
- (void)failedToAddMember:(NSString *)customUserID
              toJoinGroup:(NSString *)groupID
         clientActionTime:(UInt32)timeIntervalSince1970
                    error:(NSString *)error;


#pragma mark - 删除群成员回调方法

/**
 @method
 @brief 删除群组成员失败回调方法
 @param customUserID          删除对象的用户名
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端删除群组成员时间的秒数
 */
- (void)didRemoveMember:(NSString *)customUserID
              fromGroup:(NSString *)groupID
       clientActionTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 删除群组成员失败回调方法
 @param customUserID          删除对象的用户名
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端删除群组成员时间的秒数
 @param error                 删除群成员失败的错误信息
 */
- (void)failedToRemoveMember:(NSString *)customUserID
                   fromGroup:(NSString *)groupID
            clientActionTime:(UInt32)timeIntervalSince1970
                       error:(NSString *)error;


#pragma mark - 退出群组回调方法

/**
 @method
 @brief 退出群组成功回调方法
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端退出群组时间的秒数
 */
- (void)didQuitGroup:(NSString *)groupID clientActionTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 删除群组成员失败回调方法
 @param customUserID          删除对象的用户名
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端删除群组成员时间的秒数
 @param error                 删除群成员失败的错误信息
 */
- (void)failedToQuitGroup:(NSString *)groupID
         clientActionTime:(UInt32)timeIntervalSince1970
                    error:(NSString *)error;


#pragma mark - 被添加入群的回调方法

/**
 @method
 @brief 被添加入群的回调方法
 @param groupID      群组ID
 @param customUserID 添加你入群的用户的用户名
 */
- (void)addedToGroup:(NSString *)groupID byUser:(NSString *)customUserID;


#pragma mark - 被移除出群的回调方法

/**
 @method
 @brief 被移除出群的回调方法
 @param groupID      群组ID
 @param customUserID 移除你出群的用户的用户名
 */
- (void)removedFromGroup:(NSString *)groupID byUser:(NSString *)customUserID;


#pragma mark - 群组被他人解散的回调方法

/**
 @method
 @brief 群组被其他用户解散的回调方法
 @param groupID      群组ID
 @param customUserID 解散群的用户的用户名
 */
- (void)group:(NSString *)groupID deletedByUser:(NSString *)customUserID;


#pragma mark - 用户退群的回调方法（仅供群创建者）

/**
 @method
 @brief 其他用户退群的回调方法
 @param groupID      群组ID
 @param customUserID 退出群的用户的用户名
 */
- (void)user:(NSString *)customUserID quittedGroup:(NSString *)groupID;


#pragma mark - 发送和接收群文本消息的回调方法

/**
 @method
 @brief 发送群文本消息成功的回调方法
 @param text                  文本消息内容
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端发送群文本消息时间的秒数
 */
- (void)didSendText:(NSString *)text
            toGroup:(NSString *)groupID
     clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送群文本消息失败的回调方法
 @param text                  文本消息内容
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端发送群文本消息时间的秒数
 @param error                 发送群文本消息失败的错误信息
 */
- (void)failedToSendText:(NSString *)text
                 toGroup:(NSString *)groupID
          clientSendTime:(UInt32)timeIntervalSince1970
                   error:(NSString *)error;

/**
 @method
 @brief 接收到群文本消息
 @param text                  文本消息内容
 @param groupID               群组ID
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送群文本消息时间的秒数
 */
- (void)didReceiveText:(NSString *)text fromGroup:(NSString *)groupID fromUser:(NSString *)customUserID serverSendTime:(UInt32)timeIntervalSince1970;


#pragma mark - 发送和接收自定义群文本消息的回调方法

/**
 @method
 @brief 发送自定义群文本消息成功的回调方法
 @param text                  自定义群文本消息内容
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端发送自定义群文本消息时间的秒数
 */
- (void)didSendCustomMessage:(NSString *)text
                     toGroup:(NSString *)groupID
              clientSendTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 发送自定义群文本消息失败的回调方法
 @param text                  自定义群文本消息内容
 @param groupID               群组ID
 @param timeIntervalSince1970 1970年到客户端发送自定义群文本消息时间的秒数
 @param error                 发送自定义群文本消息失败的错误信息
 */
- (void)failedToSendCustomMessage:(NSString *)text
                          toGroup:(NSString *)groupID
                   clientSendTime:(UInt32)timeIntervalSince1970
                            error:(NSString *)error;

/**
 @method
 @brief 接收到自定义群文本消息
 @param text                  自定义群文本消息内容
 @param groupID               群组ID
 @param customUserID          发送方的用户名
 @param timeIntervalSince1970 1970年到服务端发送群文本消息时间的秒数
 */
- (void)didReceiveCustomMessage:(NSString *)text
                      fromGroup:(NSString *)groupID
                       fromUser:(NSString *)customUserID
                 serverSendTime:(UInt32)timeIntervalSince1970;
@end


#pragma mark - Group category

/**
 @header IMMyself+Group.h
 @abstract IMMyself群组类别，为IMMyself提供群组操作功能
 */
@interface IMMyself (Group)

/**
 @property
 @brief 群组操作代理
 @discussion 遵循IMGroupDelegate协议
 */
@property (nonatomic, weak) id<IMGroupDelegate> groupDelegate;

/**
 @method
 @brief 获取当前登录用户的群组列表初始化状态
 @discussion 用户登录成功后，IMSDK会在后台获取用户群组列表，返回值为YES表示已获取成功，NO表示还在获取，如果获取失败返回值也为YES。
 @return YES表示已初始化成功，NO表示初始化失败
 */
- (BOOL)groupInitialized;

/**
 @method
 @brief 获取当前登录用户的群组列表（本地获取）
 @return 群组ID的集合
 */
- (NSArray *)myGroupList;

/**
 @method
 @brief 获取当前登录用户创建的群组列表（本地获取）
 @return 群组ID的集合
 */
- (NSArray *)myOwnGroupList;

/**
 @method
 @brief 判断当前登录用户是否是群组成员
 @return 布尔值，YES表示是该群组成员，NO表示不是该群组成员
 */
- (BOOL)isMyGroup:(NSString *)groupID;

/**
 @method
 @brief 判断群组是否由当前登录用户创建
 @return 布尔值，YES表示是当前用户创建，NO表示不是当前登录用户创建
 */
- (BOOL)isMyOwnGroup:(NSString *)groupID;


#pragma mark - 创建群

/**
 @method
 @brief 创建群 （异步方法）
 @param groupName 群名称，不能超过32个字节
 @return 1970年到客户端创建群组时间的秒数
 */
- (UInt32)createGroupWithName:(NSString *)groupName;

/**
 @method
 @brief 创建群 （异步方法）
 @param groupName             群名称，不能超过32个字节
 @param success               创建群组成功的block回调
 @param groupID               创建群组成功的block回调的返回参数，字符串类型,该参数为创建群成功后分配的群ID。
 @param failure               创建群组失败的block回调
 @param requestDictionary     创建群组失败的block回调的返回参数，字典类型,包含群名称，创建时间等。
 @param error                 创建群组失败的错误信息
 @return 1970年到客户端创建群组时间的秒数
 */
- (UInt32)createGroupWithName:(NSString *)groupName
                      success:(void (^)(NSString *groupID))success
                      failure:(void (^)(NSString *error))failure;


#pragma mark － 解散群

/**
 @method
 @brief 解散群组 （异步方法）
 @param groupID               群名称，不能超过32个字节
 @return 1970年到客户端解散群组时间的秒数
 */
- (UInt32)deleteGroup:(NSString *)groupID;

/**
 @method
 @brief 解散群组 （异步方法）
 @param groupID               群ID，不能超过32个字节
 @param success               解散群组成功的block回调
 @param failure               解散群组失败的block回调
 @param error                 解散群组失败的错误信息
 @return 1970年到客户端解散群组时间的秒数
 */
- (UInt32)deleteGroup:(NSString *)groupID
              success:(void (^)())success
              failure:(void (^)(NSString *error))failure;  // 解散群组


#pragma mark - 添加群成员

/**
 @method
 @brief 添加群成员 （异步方法）
 @param customUserID          添加对象的用户名
 @param groupID               群名称，不能超过32个字节
 @return 1970年到客户端添加群成员时间的秒数
 */
- (UInt32)addMember:(NSString *)customUserID toGroup:(NSString *)groupID;

/**
 @method
 @brief 添加群成员 （异步方法）
 @param customUserID          添加对象的用户名
 @param groupID               群ID，不能超过32个字节
 @param success               添加群成员成功的block回调
 @param failure               添加群成员失败的block回调
 @param error                 添加群成员失败的错误信息
 @return 1970年到客户端添加群成员时间的秒数
 */
- (UInt32)addMember:(NSString *)customUserID
            toGroup:(NSString *)groupID
            success:(void (^)())success
            failure:(void (^)( NSString *error))failure;


#pragma mark - 删除群成员

/**
 @method
 @brief 删除群成员 （异步方法）
 @param customUserID          删除对象的用户名
 @param groupID               群ID，不能超过32个字节
 @return 1970年到客户端删除群成员时间的秒数
 */
- (UInt32)removeMember:(NSString *)customUserID fromGroup:(NSString *)groupID;

/**
 @method
 @brief 删除群成员 （异步方法）
 @param customUserID          删除对象的用户名
 @param groupID               群ID，不能超过32个字节
 @param success               删除群成员成功的block回调
 @param failure               删除群成员失败的block回调
 @param error                 删除群成员失败的错误信息
 @return 1970年到客户端删除群成员时间的秒数
 */
- (UInt32)removeMember:(NSString *)customUserID
             fromGroup:(NSString *)groupID
               success:(void (^)())success
               failure:(void (^)(NSString *error))failure;


#pragma mark - 退出群组

/**
 @method
 @brief 退出群组
 @param groupID               群ID，不能超过32个字节
 @return 1970年到客户端退出群组时间的秒数
 */
- (UInt32)quitGroup:(NSString *)groupID;

/**
 @method
 @brief 退出群组
 @param groupID               群ID，不能超过32个字节
 @param success               退出群组成功的block回调
 @param failure               退出群组失败的block回调
 @param error                 退出群组失败的错误信息
 @return 1970年到客户端退出群组时间的秒数
 */
- (UInt32)quitGroup:(NSString *)groupID
            success:(void (^)())success
            failure:(void (^)(NSString *error))failure;


#pragma mark - 发送群文本消息

/**
 @method
 @brief 发送群文本消息
 @param text                  文本消息内容，不能超过300个字节
 @param groupID               群ID，不能超过32个字节
 @return 1970年到客户端发送群文本消息时间的秒数
 */
- (UInt32)sendText:(NSString *)text toGroup:(NSString *)groupID;

/**
 @method
 @brief 发送群文本消息
 @param text                  文本消息内容，不能超过300个字节
 @param groupID               群ID，不能超过32个字节
 @param success               发送群文本消息成功的block回调
 @param failure               发送群文本消息失败的block回调
 @param error                 发送群文本消息失败的错误信息
 @return 1970年到客户端发送群文本消息时间的秒数
 */
- (UInt32)sendText:(NSString *)text toGroup:(NSString *)groupID
           success:(void (^)())success
           failure:(void (^)(NSString *error))failure;


#pragma mark - 发送自定义群文本消息

/**
 @method
 @brief 发送自定义群文本消息
 @param text                  自定义文本消息内容，不能超过300个字节
 @param groupID               群ID，不能超过32个字节
 @return 1970年到客户端发送自定义群文本消息时间的秒数
 */
- (UInt32)sendCustomMessage:(NSString *)text toGroup:(NSString *)group;

/**
 @method
 @brief 发送自定义群文本消息
 @param text                  自定义文本消息内容，不能超过300个字节
 @param groupID               群ID，不能超过32个字节
 @param success               发送自定义群文本消息成功的block回调
 @param failure               发送自定义群文本消息失败的block回调
 @param error                 发送群文本消息失败的错误信息
 @return 1970年到客户端发送群文本消息时间的秒数
 */
- (UInt32)sendCustomMessage:(NSString *)text
                    toGroup:(NSString *)groupID
                    success:(void (^)())success
                    failure:(void (^)(NSString *error))failure;;

@end

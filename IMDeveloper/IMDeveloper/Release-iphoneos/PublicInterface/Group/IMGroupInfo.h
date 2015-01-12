//
//  IMGroupInfo.h
//  IMSDK
//
//  Created by lyc on 14-10-24.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IMGroupInfo;

/**
 @protocol
 @brief 群组更新代理
 @discussion IMGroupInfo中的方法，无论是否带block方法，只要注册接收回调的对象到delegate中，就能监听到回调方法。
 */
@protocol IMGroupInfoUpdateDelegate <NSObject>

@optional


#pragma mark - 群信息更新的回调方法

/**
 @method
 @brief 更新群信息成功的回调方法
 @param groupInfo             群组对象
 @param timeIntervalSince1970 1970年到客户端请求更新群信息时间的秒数
 */
- (void)didUpdateGroupInfo:(IMGroupInfo *)groupInfo clientRequestTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 更新群信息失败的回调方法
 @param groupInfo             群组对象
 @param timeIntervalSince1970 1970年到客户端请求更新群信息时间的秒数
 @param error                 更新群信息失败的错误信息
 */
- (void)failedToUpdateGroupInfo:(IMGroupInfo *)groupInfo
              clientRequestTime:(UInt32)timeIntervalSince1970
                          error:(NSString *)error;

/**
 @method
 @brief 群组信息更新（服务器推送）
 @param groupInfo 群组对象
 */
- (void)didUpdateGroupInfo:(IMGroupInfo *)groupInfo;


#pragma mark - 群成员更新的回调方法

/**
 @method
 @brief 更新群成员成功的回调方法
 @param groupInfo             群组对象
 @param timeIntervalSince1970 1970年到客户端请求更新群成员时间的秒数
 */
- (void)didUpdateMemberListForGroupInfo:(IMGroupInfo *)groupInfo clientRequestTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 更新群成员失败的回调方法
 @param groupInfo             群组对象
 @param timeIntervalSince1970 1970年到客户端请求更新群成员时间的秒数
 @param error                 更新群成员失败的错误信息
 */
- (void)failedToUpdateMemberListForGroupInfo:(IMGroupInfo *)groupInfo
                           clientRequestTime:(UInt32)timeIntervalSince1970
                                       error:(NSString *)error;

/**
 @method
 @brief 群成员更新（服务器推送）
 @param groupInfo 群组对象
 */
- (void)didUpdateMemberListForGroupInfo:(IMGroupInfo *)groupInfo;


#pragma mark - 提交修改群信息的回调方法

/**
 @method
 @brief 提交群信息成功的回调方法
 @param groupInfo             群组对象
 @param timeIntervalSince1970 1970年到客户端提交群信息时间的秒数
 */
- (void)didCommitGroupInfo:(IMGroupInfo *)groupInfo clientRequestTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 提交群信息失败的回调方法
 @param groupInfo             群组对象
 @param timeIntervalSince1970 1970年到客户端提交群信息时间的秒数
 @param error                 提交群信息失败的错误信息
 */
- (void)failedToCommitGroupInfo:(IMGroupInfo *)groupInfo
              clientRequestTime:(UInt32)timeIntervalSince1970
                          error:(NSString *)error;

@end


#pragma mark - IMGroupInfo class
/**
 @header IMGroupInfo.h
 @abstract 群组对象
 */
@interface IMGroupInfo : NSObject

/**
 @property 
 @brief 群组id,只可读
 */
@property (nonatomic, readonly) NSString *groupID;

/**
 @property 
 @brief 最大群成员数，只可读
 */
@property (nonatomic, readonly) NSInteger maxUserCount;

/**
 @property
 @brief 群创建者的用户名，只可读
 */
@property (nonatomic, readonly) NSString *ownerCustomUserID;

/**
 @property
 @brief 群名称，小于10个字节
 */
@property (nonatomic, copy) NSString *groupName;

/**
 @property
 @brief 群信息，小于50个字节
 */
@property (nonatomic, copy) NSString *customGroupInfo;

/**
 @property
 @brief 群成员的用户名集合，只可读
 */
@property (nonatomic, readonly) NSArray *memberList;    // customUserID List

/**
 @property
 @brief 更新群信息代理
 @discussion 遵循IMGroupInfoUpdateDelegate协议
 */
@property (nonatomic, weak) id<IMGroupInfoUpdateDelegate> delegate;


#pragma mark - 请求更新群信息

/**
 @method
 @brief 请求更新群信息（异步方法，从服务器获取）
 @return 1970年到客户端提交请求更新群信息时间的秒数
 */
- (UInt32)requestUpdateGroupInfo;

/**
 @method
 @brief 请求更新群信息（异步方法，从服务器获取）
 @param success               请求更新群信息成功的block回调
 @param groupInfo             请求更新群信息成功的block回调的返回参数，IMGroupInfo类型,该参数为更新成功后的群对象。
 @param failure               请求更新群信息失败的block回调
 @param error                 请求更新群信息失败的错误信息
 @return 1970年到客户端提交请求更新群信息时间的秒数
 */
- (UInt32)requestUpdateGroupInfoOnSuccess:(void (^)(IMGroupInfo *groupInfo))success
                                  failure:(void (^)(NSString *error))failure;


#pragma mark - 请求更新群成员

/**
 @method
 @brief 请求更新群成员（异步方法，从服务器获取）
 @return 1970年到客户端请求更新群成员时间的秒数
 */
- (UInt32)requestUpdateMemberList;

/**
 @method
 @brief 请求更新群成员（异步方法，从服务器获取）
 @param success               请求更新群成员成功的block回调
 @param groupInfo             请求更新群信息成功的block回调的返回参数，IMGroupInfo类型,该参数为更新成功后的群对象。
 @param failure               请求更新群成员失败的block回调
 @param error                 请求更新群成员失败的错误信息
 @return 1970年到客户端请求更新群成员时间的秒数
 */
- (UInt32)requestUpdateMemberListOnSuccess:(void (^)(IMGroupInfo *groupInfo))success
                                   failure:(void (^)(NSString *error))failure;


#pragma mark - 提交更新群信息

/**
 @method
 @brief 提交更新群信息（异步方法，从服务器获取）
 @return 1970年到客户端提交修改群信息时间的秒数
 */
- (UInt32)commitGroupInfo;

/**
 @method
 @brief 提交更新群信息（异步方法，从服务器获取）
 @param success               提交修改群信息成功的block回调
 @param groupInfo             请求更新群信息成功的block回调的返回参数，IMGroupInfo类型,该参数为提交成功后的群对象。
 @param failure               提交修改群信息失败的block回调
 @param error                 提交修改群信息失败的错误信息
 @return 1970年到客户端提交修改群信息时间的秒数
 */
- (UInt32)commitGroupInfoOnSuccess:(void (^)(IMGroupInfo *groupInfo))success
                           failure:(void (^)(NSString *error))failure;

@end




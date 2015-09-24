//
//  IMSDK+Topic.h
//  IMSDK
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"
#import "IMTopicInfo.h"

@protocol IMSDKTopicDelegate <NSObject>
@optional

- (void)didGetUserLatestTopics:(NSString *)customUserID
                     topicList:(NSArray *)topicList
              clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetUserLatestTopics:(NSString *)customUserID
                   clientActionTime:(UInt32)timeIntervalSince1970
                              error:(NSString *)error;

- (void)didGetFriendsLatestTopics:(NSArray *)topicList
                 clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetFriendsLatestTopicsOnClientActionTime:(UInt32)timeIntervalSince1970
                                                   error:(NSString *)error;

- (void)didGetAllUserLatestTopics:(NSArray *)topicList
                 clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetAllUsersLatestTopicsOnClientActionTime:(UInt32)timeIntervalSince1970
                                                    error:(NSString *)error
                       ;

- (void)didGetUserNextPageTopics:(NSString *)customUserID
                       topicList:(NSArray *)topicList
                clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetUserNextPageTopics:(NSString *)customUserID
                     clientActionTime:(UInt32)timeIntervalSince1970
                                error:(NSString *)error;

- (void)didGetFriendsNextPageTopics:(NSArray *)topicList
                   clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetFriendsNextPageTopicsOnClientActionTime:(UInt32)timeIntervalSince1970
                                                     error:(NSString *)error;

- (void)didGetAllUserNextPageTopics:(NSArray *)topicList
                   clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetAllUsersNextPageTopicOnClientActionTime:(UInt32)timeIntervalSince1970
                                                     error:(NSString *)error;

@end

@interface IMSDK (Topic)

@property (nonatomic, weak) id<IMSDKTopicDelegate> topicDelegate;

//local IMTopicInfo list, （最多20条）
- (NSArray *)getUserLocalCacheTopicList:(NSString *)customUserID;

- (NSArray *)getFriendsLocalCacheTopicList;

- (NSArray *)getAllUsersLocalCacheTopicList;

//
- (UInt32)getUserLatestTopics:(NSString *)customUserID
                      success:(void (^)(NSArray *topicList))success
                      failure:(void (^)(NSString *error))failure;

- (UInt32)getFriendsLatestTopicsOnSuccess:(void (^)(NSArray *topicList))success
                                  failure:(void (^)(NSString *error))failure;

- (UInt32)getAllUsersLatestTopicsOnSuccess:(void (^)(NSArray *topicList))success
                                   failure:(void (^)(NSString *error))failure;

- (UInt32)getUserNextPageTopics:(NSString *)customUserID
                        success:(void (^)(NSArray *topicList))success
                        failure:(void (^)(NSString *error))failure;

- (UInt32)getFriendsNextPageTopicsOnSuccess:(void (^)(NSArray *topicList))success
                                    failure:(void (^)(NSString *error))failure;

- (UInt32)getAllUsersNextPageTopicsOnSuccess:(void (^)(NSArray *topicList))success
                                     failure:(void (^)(NSString *error))failure;

- (IMTopicInfo *)topicInfoWithTopicID:(NSString *)topicID;
@end

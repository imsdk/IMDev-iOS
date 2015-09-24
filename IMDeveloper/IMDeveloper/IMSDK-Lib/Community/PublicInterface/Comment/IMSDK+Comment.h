//
//  IMSDK+Comment.h
//  IMSDK
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"

//IMCommentUpdateType 与 IMCommentGetDirection配套使用,建议使用时不要同时使用两个方向拉取
typedef NS_ENUM(UInt8, IMCommentUpdateType) {
    IMCommentUpdateTypeLatest = 0,   //获取离现在时间最近的
    IMCommentUpdateTypeLongest = 1,     //获取离现在时间最远的
};

typedef NS_ENUM(UInt8, IMCommentGetDirection) {
    IMCommentGetDirectionDown = 0,   //向上，由时间最近的往最远的获取
    IMCommentGetDirectionUp = 1,     //由时间最远的往最近的获取
};

@protocol IMSDKCommentDelegate <NSObject>

@optional

//获取批量话题的评论（最近一页或者最远一页）
- (void)didUpdateCommentsWithTopicIDs:(NSArray *)topicIDs
                            direction:(IMCommentGetDirection)direction
                     commentListInfos:(NSArray *)commentListInfos
                     clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToUpdateCommentsWithTopicIDs:(NSArray *)topicIDs
                                 direction:(IMCommentGetDirection)direction
                          clientActionTime:(UInt32)timeIntervalSince1970
                                     error:(NSString *)error;

//获取单个话题的评论（最近一页或者最远一页）
- (void)didUpdateCommentsWithTopicID:(NSString *)topicID
                           direction:(IMCommentGetDirection)direction
                         commentList:(NSArray *)commentList
                    clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToUpdateCommentsWithTopicID:(NSString *)topicID
                                direction:(IMCommentGetDirection)direction
                         clientActionTime:(UInt32)timeIntervalSince1970
                                    error:(NSString *)error;

//获取批量话题的评论（下一页）
- (void)didGetNextPageCommentsWithTopicIDs:(NSArray *)topicIDs
                                 direction:(IMCommentGetDirection)direction
                          commentListInfos:(NSArray *)commentListInfos
                          clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetNextPageCommentsWithTopicIDs:(NSArray *)topicIDs
                                      direction:(IMCommentGetDirection)direction
                               clientActionTime:(UInt32)timeIntervalSince1970
                                          error:(NSString *)error;

//获取单个话题的评论（下一页）
- (void)didGetNextPageCommentsWithTopicID:(NSString *)topicID
                                direction:(IMCommentGetDirection)direction
                              commentList:(NSArray *)commentList
                         clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToGetNextPageCommentsWithTopicID:(NSString *)topicID
                                     direction:(IMCommentGetDirection)direction
                              clientActionTime:(UInt32)timeIntervalSince1970
                                         error:(NSString *)error;
@end

@interface IMSDK (Comment)

@property (nonatomic, weak) id<IMSDKCommentDelegate> commentDelegate;

//返回值是IMCommentListInfo的集合
- (NSArray *)getLocalCacheCommentListWithTopicIDs:(NSArray *)topicIDs type:(IMCommentUpdateType)type;

//返回值是IMCommentInfo的集合
- (NSArray *)getLocalCacheCommentListWithTopicID:(NSString *)topicID type:(IMCommentUpdateType)type;

//获取批量话题的评论（最新一页或者最远一页）
- (UInt32)updateCommentsWithTopicIDs:(NSArray *)topicIDs
                           direction:(IMCommentGetDirection)direction
                             success:(void (^)(NSArray *commentListInfos))success
                             failure:(void (^)(NSString *error))failure;

//获取单个话题的评论（最新一页或者最远一页）
- (UInt32)updateCommentsWithTopicID:(NSString *)topicID
                          direction:(IMCommentGetDirection)direction
                            success:(void (^)(NSArray *commentList))success
                            failure:(void (^)(NSString *error))failure;

//获取批量话题的评论（下一页）
- (UInt32)getNextPageCommentsWithTopicIDs:(NSArray *)topicIDs
                                direction:(IMCommentGetDirection)direction
                                  success:(void (^)(NSArray *commentListInfos))success
                                  failure:(void (^)(NSString *error))failure;

//获取单个话题的评论（下一页）
- (UInt32)getNextPageCommentsWithTopicID:(NSString *)topicID
                               direction:(IMCommentGetDirection)direction
                                 success:(void (^)(NSArray *commentList))success
                                 failure:(void (^)(NSString *error))failure;


@end

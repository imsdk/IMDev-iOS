//
//  IMMyself+Comment.h
//  IMSDK
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMMyself.h"

@protocol IMCommentDelegate <NSObject>

@optional

- (void)didCreateCommentWithContent:(NSString *)content
                      targetTopicID:(NSString *)topicID
                   clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToCreateCommitWithContent:(NSString *)content
                         targetTopicID:(NSString *)topicID
                      clientActionTime:(UInt32)timeIntervalSince1970
                                 error:(NSString *)error;

- (void)didModifyComment:(NSString *)commentID
             withContent:(NSString *)content
        clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToModifyComment:(NSString *)commentID
                  withContent:(NSString *)content
             clientActionTime:(UInt32)timeIntervalSince1970
                        error:(NSString *)error;

- (void)didDeleteComment:(NSString *)commentID clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToDeleteComment:(NSString *)commentID
           clientActionTime:(UInt32)timeIntervalSince1970
                      error:(NSString *)error;


@end

@interface IMMyself (Comment)

@property (nonatomic, weak)id<IMCommentDelegate> commentDelegate;

- (UInt32)createCommentWithContent:(NSString *)content
                     targetTopicID:(NSString *)topicID
                           success:(void (^)(NSString *commentID))success
                           failure:(void (^)(NSString *error))failure;

- (UInt32)modifyComment:(NSString *)commentID
            withContent:(NSString *)content
                success:(void (^)(NSString *commentID))success
                failure:(void (^)(NSString *error))failure;

- (UInt32)deleteComment:(NSString *)commentID
                success:(void (^)(NSString *commentID))success
                failure:(void (^)(NSString *error))failure;

@end

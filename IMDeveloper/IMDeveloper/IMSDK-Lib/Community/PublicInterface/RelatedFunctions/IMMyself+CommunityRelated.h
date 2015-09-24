//
//  IMMyself+CommunityRelated.h
//  IMSDK
//
//  Created by mac on 15/6/24.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMMyself.h"

@protocol IMCommunityRelatedDelegate <NSObject>
@optional

- (void)didLikeTopic:(NSString *)topicID clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToLikeTopic:(NSString *)topicID clientActionTime:(UInt32)timeIntervalSince1970 error:(NSString *)error;

- (void)didLikeComment:(NSString *)commentID clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToLikeComment:(NSString *)commentID clientActionTime:(UInt32)timeIntervalSince1970 error:(NSString *)error;

- (void)didDislikeTopic:(NSString *)topicID clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToDislikeTopic:(NSString *)topicID clientActionTime:(UInt32)timeIntervalSince1970 error:(NSString *)error;

- (void)didDislikeComment:(NSString *)commentID clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToDislikeComment:(NSString *)commentID clientActionTime:(UInt32)timeIntervalSince1970 error:(NSString *)error;

@end

@interface IMMyself (CommunityRelated)

@property (nonatomic, weak) id<IMCommunityRelatedDelegate> communityRelatedDelegate;

- (UInt32)likeTopic:(NSString *)topicID
              success:(void (^)())success
              failure:(void (^)(NSString *error))failure;

- (UInt32)likeComment:(NSString *)commentID
                success:(void (^)())success
                failure:(void (^)(NSString *))failure;

- (UInt32)dislikeTopic:(NSString *)topicID
               success:(void (^)())success
               failure:(void (^)(NSString *error))failure;

- (UInt32)dislikeComment:(NSString *)commentID
                 success:(void (^)())success
                 failure:(void (^)(NSString *error))failure;

@end

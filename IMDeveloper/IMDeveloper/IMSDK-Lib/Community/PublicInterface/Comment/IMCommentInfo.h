//
//  IMCommentInfo.h
//  IMSDK
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMCommentInfo;

@protocol IMCommentInfoDelegate <NSObject>

@optional

- (void)didRequestUpdateCommentInfo:(IMCommentInfo *)commentInfo clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToRequestUpdateCommentInfo:(IMCommentInfo *)commentInfo
                        clientActionTime:(UInt32)timeIntervalSince1970
                                   error:(NSString *)error;
@end

@interface IMCommentInfo : NSObject

@property (nonatomic, readonly) NSString *topicID;
@property (nonatomic, readonly) NSString *commentID;
@property (nonatomic, readonly) UInt32 createTime;
@property (nonatomic, readonly) NSString *createCustomUserID;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) UInt32 likeCount;
@property (nonatomic, readonly) UInt32 dislikeCount;

@property (nonatomic, weak) id<IMCommentInfoDelegate> delegate;

- (UInt32)requestUpdateCommentInfoOnSuccess:(void(^)(IMCommentInfo *commentInfo))success
                                    failure:(void (^)(NSString *error))failure;

@end

//
//  IMTopicInfo.h
//  IMSDK
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMTopicInfo;

@protocol IMTopicInfoDelegate <NSObject>

@optional

- (void)didRequestUpdateTopicInfo:(IMTopicInfo *)topicInfo clientActionTime:(UInt32)timeIntervalSince1970;
- (void)failedToRequestUpdateTopicInfo:(IMTopicInfo *)topicInfo
                      clientActionTime:(UInt32)timeIntervalSince1970
                                 error:(NSString *)error;

@end

@interface IMTopicInfo : NSObject

@property (nonatomic, readonly) NSString *topicID;
@property (nonatomic, readonly) UInt32 createTime;
@property (nonatomic, readonly) NSString *createCustomUserID;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) UInt32 commentCount;
@property (nonatomic, readonly) UInt32 likeCount;
@property (nonatomic, readonly) UInt32 dislikeCount;
@property (nonatomic, readonly) NSArray *imageFileIDs;

@property (nonatomic, weak) id<IMTopicInfoDelegate> delegate;

- (UInt32)requestUpdateTopicInfoOnSuccess:(void(^)(IMTopicInfo *topicInfo))success
                                  failure:(void (^)(NSString *error))failure;

@end

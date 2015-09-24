//
//  IMMyself+Topic.h
//  IMSDK
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMMyself.h"

@protocol IMTopicDelegate <NSObject>

@optional

- (void)didCreateTopicWithTitle:(NSString *)title
                        content:(NSString *)content
                         images:(NSArray *)images
                        topicID:(NSString *)topicID
               clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToCreateTopicWithTitle:(NSString *)title
                             content:(NSString *)content
                              images:(NSArray *)images
                    clientActionTime:(UInt32)timeIntervalSince1970
                               error:(NSString *)error;

- (void)didModifyTopic:(NSString *)topicID
             withTitle:(NSString *)title
               content:(NSString *)content
                images:(NSArray *)images
      clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToModifyTopic:(NSString *)topicID
                  withTitle:(NSString *)title
                    content:(NSString *)content
                     images:(NSArray *)images
           clientActionTime:(UInt32)timeIntervalSince1970
                      error:(NSString *)error;

- (void)didDeleteTopic:(NSString *)topicID clientActionTime:(UInt32)timeIntervalSince1970;

- (void)failedToDeleteTopic:(NSString *)topicID
           clientActionTime:(UInt32)timeIntervalSince1970
                      error:(NSString *)error;

@end

@interface IMMyself (Topic)

@property (nonatomic ,weak)id<IMTopicDelegate> topicDelegate;

- (UInt32)createTopicWithTitle:(NSString *)title
                       content:(NSString *)content
                        images:(NSArray *)images
                       success:(void (^)(NSString *topicID))success
                       failure:(void (^)(NSString *error))failure;

- (UInt32)modifyTopic:(NSString *)topicID
            withTitle:(NSString *)title
              content:(NSString *)content
               images:(NSArray *)images
              success:(void (^)(NSString *topicID))success
              failure:(void (^)(NSString *error))failure;

- (UInt32)deleteTopic:(NSString *)topicID
              success:(void (^)(NSString *topicID))success
              failure:(void (^)(NSString *error))failure;

@end

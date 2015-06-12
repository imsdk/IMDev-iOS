//
//  IMSDK+Nickname.h
//  IMSDK
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"

@protocol IMSDKNicknameDelegate <NSObject>
@optional

- (void)didRequestNickname:(NSString *)nickname
              customUserID:(NSString *)customUserID
         clientRequestTime:(UInt32)timeIntervalSince1970;

- (void)failedToRequestNicknameWithCustomUserID:(NSString *)customUserID
                              clientRequestTime:(UInt32)timeIntervalSince1970
                                          error:(NSString *)error;


@end

@interface IMSDK (Nickname)

@property (nonatomic, weak)id<IMSDKNicknameDelegate> nicknameDelegate;

- (UInt32)requestNicknameWithCustomUserID:(NSString *)customUserID
                                  success:(void(^)(NSString *nickname))success
                                  failure:(void(^)(NSString *error))failure;

- (NSString *)nicknameOfUser:(NSString *)customUserID;

@end

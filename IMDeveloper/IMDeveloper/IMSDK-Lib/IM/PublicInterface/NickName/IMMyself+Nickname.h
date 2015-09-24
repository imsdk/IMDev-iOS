//
//  IMMyself+Nickname.h
//  IMSDK
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMMyself.h"

@protocol IMNicknameDelegate <NSObject>
@optional

- (void)nicknameDidInitialize;

- (void)didCommitNickname:(NSString *)nickname clientCommitTime:(UInt32)timeIntervalSince1970;

- (void)failedToCommitNickname:(NSString *)nickname
              clientCommitTime:(UInt32)timeIntervalSince1970
                         error:(NSString *)error;

@end

@interface IMMyself (Nickname)

@property (nonatomic, weak) id<IMNicknameDelegate> nicknameDelegate;

@property (nonatomic, readonly) NSString *nickname;

- (BOOL)nicknameInitialized;

- (UInt32)commitNickname:(NSString *)nickname succuss:(void (^)())success failure:(void (^)(NSString *error))failure;

@end

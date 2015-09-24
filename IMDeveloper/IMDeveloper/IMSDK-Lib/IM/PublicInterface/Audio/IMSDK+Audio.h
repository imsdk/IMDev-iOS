//
//  IMSDK+Audio.h
//  IMSDK
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"

@interface IMSDK (Audio)

- (UInt32)uploadAudioData:(NSData *)data success:(void (^)(NSString *fileID))success failure:(void (^)(NSString *error))failure;

- (UInt32)requestAudioDataWithFileID:(NSString *)fileID success:(void (^)(NSData *data))success failure:(void (^)(NSString *error))failure;

@end

//
//  IMSDK+Image.h
//  IMSDK
//
//  Created by mac on 15/6/30.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"
#import <UIKit/UIKit.h>

@interface IMSDK (Image)

- (UInt32)requestImageWithFileID:(NSString *)fileID success:(void (^)(UIImage *image))success failure:(void (^)(NSString *error))failure;

- (UInt32)requestImageWithFileID:(NSString *)fileID
                           width:(CGFloat)width
                          height:(CGFloat)height
                         success:(void (^)(UIImage *image))success
                         failure:(void (^)(NSString *error))failure;

@end

//
//  IMMyself+Photo.h
//  IMSDK
//
//  Created by lyc on 14-10-29.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"
#import <UIKit/UIKit.h>

/**
 @protocol
 @brief 上传头像协议
 @discussion IMMyself+MainPhoto类别中的方法，无论是否带block方法，只要注册接收回调的对象到mainPhotoDlegate中，就能监听到回调方法。
 */
@protocol IMMainPhotoDelegate <NSObject>

@optional


#pragma mark - 头像上传的回调

/**
 @method
 @brief 上传头像成功回调方法
 @param image                 头像图片
 @param timeIntervalSince1970 1970年到客户端发送上传请求时间的秒数
 */
- (void)didUploadMainPhoto:(UIImage *)image clientActionTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 上传头像成功回调方法
 @param image                 头像图片
 @param percentage            上传头像进度百分比
 @param timeIntervalSince1970 1970年到客户端发送上传请求时间的秒数
 */
- (void)didUploadMainPhoto:(UIImage *)image
                percentage:(CGFloat)percentage
          clientActionTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 上传头像成功回调方法
 @param image                 头像图片
 @param timeIntervalSince1970 1970年到客户端发送上传请求时间的秒数
 @param error                 上传头像失败的错误信息
 */
- (void)failedToUploadMainPhoto:(UIImage *)image
               clientActionTime:(UInt32)timeIntervalSince1970
                          error:(NSString *)error;
@end


#pragma mark - MainPhoto category

/**
 @header IMMyself+MainPhoto.h
 @abstract IMMyself用户头像类别，为IMMyself提供上传用户头像功能
 */
@interface IMMyself (MainPhoto)

/**
 @property
 @brief 上传头像代理
 @discussion 遵循IMMainPhotoDelegate协议
 */
@property (nonatomic, weak) id<IMMainPhotoDelegate> mainPhotoDelegate;


#pragma mark - 头像上传

/**
 @method
 @brief 上传头像（异步方法）
 @param image 头像图片
 @return 1970年到客户端发送上传请求时间的秒数
*/
- (UInt32)uploadMainPhoto:(UIImage *)image;

/**
 @method 
 @brief 上传头像带block回调方法,设置mainPhotoDelegate时，IMMainPhotoDelegate中的回调方法会被触发（异步方法）
 @param image             头像图片
 @param success           上传头像成功的block回调
 @param failure           上传头像失败的block回调
 @param error             上传头像失败的block回调的返回参数，包含上传失败的错误信息
 @return 1970年到客户端发送上传请求时间的秒数
 */
- (UInt32)uploadMainPhoto:(UIImage *)image
                  success:(void (^)())success
                  failure:(void (^)(NSString *error))failure;

@end

//
//  IMSDK+MainPhoto.h
//  IMSDK
//
//  Created by lyc on 14-10-30.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMSDK.h"
#import <UIKit/UIKit.h>

/**
 @protocol
 @brief 获取用户头像协议
 @discussion IMSDK+MainPhoto类别中的方法，无论是否带block方法，只要注册接收回调的对象到mainPhotoDlegate中，就能监听到回调方法。
 */
@protocol IMSDKMainPhotoDelegate <NSObject>

@optional


#pragma mark - 获取用户头像的回调

/**
 @method
 @brief 获取用户头像成功的回调方法
 @param image                 头像图片，可能为nil
 @param customUserID          获取对象的用户名
 @param timeIntervalSince1970 1970年到客户端发送获取头像请求时间的秒数
 */
- (void)didRequestMainPhoto:(UIImage *)image
                     ofUser:(NSString *)customUserID
          clientRequestTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 获取用户头像失败的回调方法
 @param customUserID          获取对象的用户名
 @param timeIntervalSince1970 1970年到客户端发送获取头像请求时间的秒数
 @param error                 获取用户头像失败的错误信息
 */
- (void)failedToRequestMainPhotoOfUser:(NSString *)customUserID
                     clientRequestTime:(UInt32)timeIntervalSince1970
                                 error:(NSString *)error;
/**
 @method
 @brief 获取指定尺寸的用户头像成功的回调方法
 @param image                 头像图片，可能为nil
 @param customUserID          获取对象的用户名
 @param timeIntervalSince1970 1970年到客户端发送获取头像请求时间的秒数
 */
- (void)didRequestCustomSizeMainPhoto:(UIImage *)image
                               ofUser:(NSString *)customUserID
                    clientRequestTime:(UInt32)timeIntervalSince1970;

/**
 @method
 @brief 获取指定尺寸用户头像失败的回调方法
 @param customUserID          获取对象的用户名
 @param timeIntervalSince1970 1970年到客户端发送获取头像请求时间的秒数
 @param error                 获取用户头像失败的错误信息
 */
- (void)failedToRequestCustomSizeMainPhotoOfUser:(NSString *)customUserID
                               clientRequestTime:(UInt32)timeIntervalSince1970
                                           error:(NSString *)error;
@end


#pragma mark - MainPhoto category（IMSDK）

/**
 @header IMSDK＋MainPhoto.h
 @abstract IMSDK用户头像类别，为IMSDK提供获取某个用户的头像功能
 */
@interface IMSDK (MainPhoto)

/**
 @property
 @brief 获取用户头像代理
 @discussion 遵循IMSDKMainPhotoDelegate协议
 */
@property (nonatomic, weak) id<IMSDKMainPhotoDelegate> mainPhotoDelegate;


#pragma mark - 获取用户头像

/**
 @method
 @brief 获取用户头像（服务器异步获取）
 @param customUserID 获取对象的用户名
 @return 1970年到客户端发送获取头像请求时间的秒数
 */
- (UInt32)requestMainPhotoOfUser:(NSString *)customUserID;

/**
 @method
 @brief 获取用户头像（服务器异步获取）
 @param customUserID       获取对象的用户名
 @param success            获取用户头像成功的block回调
 @param photo              获取用户头像成功的block回调的返回参数，获取成功的头像图片，可能为空。
 @param failure            获取用户头像失败的block回调
 @param error              获取用户头像失败的错误信息
 @return 1970年到客户端发送获取头像请求时间的秒数
 */
- (UInt32)requestMainPhotoOfUser:(NSString *)customUserID
                         success:(void (^)(UIImage *mainPhoto))success
                         failure:(void (^)(NSString *error))failure;

/**
 @method
 @brief 获取用户指定尺寸头像（服务器异步获取）
 @param customUserID 获取对象的用户名
 @param width        头像指定尺寸的宽
 @param height       头像指定尺寸的高
 @return 1970年到客户端发送获取头像请求时间的秒数
 */
- (UInt32)requestCustomSizeMainPhotoOfUser:(NSString *)customUserID width:(NSUInteger)width height:(NSUInteger)height;

/**
 @method
 @brief 获取用户头像(服务器异步获取)
 @param customUserID       获取对象的用户名
 @param width              指定尺寸的宽
 @param height             指定尺寸的高
 @param success            获取用户头像成功的block回调
 @param photo              获取用户头像成功的block回调的返回参数，获取成功的头像图片，可能为空。
 @param failure            获取用户头像失败的block回调
 @param error              获取用户头像失败的错误信息
 @return 1970年到客户端发送获取头像请求时间的秒数
 */
- (UInt32)requestCustomSizeMainPhotoOfUser:(NSString *)customUserID
                                     width:(NSUInteger)width
                                    height:(NSUInteger)height
                                   success:(void (^)(UIImage *mainPhoto))success
                                   failure:(void (^)(NSString *error))failure;;

/**
 @method
 @brief 获取用户本地的头像
 @param customUserID 获取对象的用户名
 @return 用户头像图片
 */
- (UIImage *)mainPhotoOfUser:(NSString *)customUserID;

/**
 @method
 @brief 按指定尺寸获取用户本地的头像
 @param customUserID 获取对象的用户名
 @param width        指定尺寸的宽
 @param height       指定尺寸的高
 @return 用户头像图片
 */
- (UIImage *)customSizeMainPhotoOfUser:(NSString *)customUserID width:(NSInteger)width height:(NSInteger)height;

@end




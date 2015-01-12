//
//  IMChatView.h
//  GGTalk
//
//  Created by Daniel Lee on 12-7-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 头像风格
 */
typedef NS_ENUM(NSInteger, IMHeadViewStyle) {
    IMHeadViewStyleDefault = 0,     //默认为圆角
    IMHeadViewStyleSqure = 1,
    IMHeadViewStyleRectangle = 2,
    IMHeadViewStyleCircle  = 3,   
};

@protocol IMChatViewDelegate <NSObject>

/**
 头像点击回调，返回点击头像所属用户名
 */
- (void)onHeadViewTaped:(NSString *)customUserID;;

/**
 录音失败回调方法
 */
- (void)recordAudioError:(NSString *)error;

/**
 播放语音失败回调方法
 */
- (void)playAudioError:(NSString *)error;

@end

@interface IMChatView : UIView<IMChatViewDelegate>

/**
 聊天界面代理
 */
@property (nonatomic, weak)id<IMChatViewDelegate> delegate;

/**
 一对一聊天对象的用户名
 */
@property (nonatomic, copy) NSString *customUserID;

/**
 发送气泡背景色
 默认为蓝色
 */
@property (nonatomic, strong) UIColor *senderTintColor;

/**
 接收气泡背景色
 默认为灰色
 */
@property (nonatomic, strong) UIColor *receiverTintColor;

/**
 气泡间的高度间隔
 默认为10.0f
 */
@property (nonatomic, assign) CGFloat cellVerticalInterval;

/**
 最大宽度（包括聊天气泡，头像和发送状态显示）
 默认为chatView 的宽（[self frame].size.width）
 */
@property (nonatomic, assign) CGFloat cellMaxWidth;

/**
 聊天气泡内的字体大小
 默认为systemFont 15
 */
@property (nonatomic, strong) UIFont *font;

/**
 聊天气泡内的字体颜色
 默认为黑色
 */
@property (nonatomic, strong) UIColor *fontColor;

/**
 输入框以下的多功能面板的背景色
 默认为白色
 */
@property (nonatomic, strong) UIColor *inputViewTintColor;

/**
 表情按钮normal状态下的图片
 默认为IMSDK提供的DTFace_normal.png
 */
@property (nonatomic, strong) UIImage *faceNormalImage;

/**
 表情按钮选中状态下的图片
 默认为IMSDK提供的DTFace_selected.png
 */
@property (nonatomic, strong) UIImage *faceHighLightImage;

/**
 键盘按钮normal状态下的图片
 默认为IMSDK提供的DTKeyboard_normal.png
 */
@property (nonatomic, strong) UIImage *keyboardNormalImage;

/**
 键盘按钮选中状态下的图片
 默认为IMSDK提供的DTKeyboard_selected.png
 */
@property (nonatomic, strong) UIImage *keyboardHighLightImage;

/**
 录音按钮normal状态下的图片
 默认为IMSDK提供的DTMic_normal.png
 */
@property (nonatomic, strong) UIImage *micNormalImage;

/**
 录音按钮选中状态下的图片
 默认为IMSDK提供的DTMic_selected.png
 */
@property (nonatomic, strong) UIImage *micHighLightImage;

/**
 多功能按钮normal状态下的图片
 默认为IMSDK提供的DTMore_normal.png
 */
@property (nonatomic, strong) UIImage *moreNormalImage;

/**
 多功能按钮选中状态下的图片
 默认为IMSDK提供的DTMore_selected.png
 */
@property (nonatomic, strong) UIImage *moreHighLightImage;

/**
 气泡背景图
 默认为IMSDK提供的DTImageMask.png
 目前只支持左上角开口的图片
 UIEdgeInsetsMake(20, 21, 20, 15)
 */
@property (nonatomic, strong) UIImage *bubbleMaskImage;

@property (nonatomic, strong) UIImage *defaultHeadImage;

/**
 头像形状
 默认为圆角
 还支持圆形，正方形、长方形
 */
@property (nonatomic, assign) IMHeadViewStyle headViewStyle;

/**
 聊天背景图
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/**
 聊天界面的父视图控制器
 */
@property (nonatomic, weak)UIViewController *parentController;
@end








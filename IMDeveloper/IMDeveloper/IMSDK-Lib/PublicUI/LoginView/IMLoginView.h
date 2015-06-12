//
//  IMLoginView.h
//  IMSDK
//
//  Created by mac on 15/2/27.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMLoginViewFunctionType) {
    IMLoginViewFunctionTypeDefault = 0,   //login,register
    IMLoginViewFunctionTypeContainAutoRegister = 1,   //contain auto register function
    IMLoginViewFunctionTypeAutoRegisterOnly = 2,  //only auto register function
};

@protocol IMLoginViewDelegate <NSObject>

@optional

- (void)loginViewLoginFailedWithError:(NSString *)error;

- (void)loginViewDidLogin:(BOOL)autoLogin;

- (void)loginActionStarted;
@end

@interface IMLoginView : UIView

/**
 login view function type
 */
@property (nonatomic, assign) IMLoginViewFunctionType type;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) BOOL showHeadView;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIImage *buttonBackgroundImage;

@property (nonatomic, strong) UIColor *textFieldColor;

/**
 注册界面显示的logo图片，如果设置为nil则表示不显示
 */
@property (nonatomic, copy) UIImage *logoImage;

/**
 Call this method when UIViewController‘s '- (void)viewWillAppear:(BOOL)animated' method being called
 */
- (void)viewWillAppear;

@end

//
//  IMMyselfInfoEditViewController.h
//  IMDeveloper
//
//  Created by mac on 14-12-12.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMMyselfInfoEditDelegate <NSObject>

- (void)customUerInfoEdit:(NSInteger)type content:(NSString *)content;

@end

@interface IMMyselfInfoEditViewController : UIViewController

@property (nonatomic, weak) id<IMMyselfInfoEditDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *content;

@end

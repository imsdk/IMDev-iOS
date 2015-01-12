//
//  IMGroupInfoEditViewController.h
//  IMDeveloper
//
//  Created by mac on 14/12/25.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMBaseViewController.h"

@protocol IMGroupInfoEditDelegate <NSObject>

- (void)customGroupInfoEdit:(NSInteger)type content:(NSString *)content;

@end

@interface IMGroupInfoEditViewController : IMBaseViewController

@property (nonatomic, weak) id<IMGroupInfoEditDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *content;

@end

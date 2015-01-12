//
//  IMGroupMemberHeadersView.h
//  IMDeveloper
//
//  Created by mac on 14/12/24.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

//IMSDK Headers
#import "IMGroupInfo.h"

@protocol IMGroupMemberHeadersViewDelegate <NSObject>

- (void)headViewTaped:(NSString *)customUserID;
- (void)addMemberButtonClick;
- (void)setDeleteStatus:(BOOL)deleteStatus;
- (void)deleteMember:(NSString *)customUserID;

@end

@interface IMGroupMemberHeadersView : UIView

@property (nonatomic, weak) id<IMGroupMemberHeadersViewDelegate> delegate;
@property (nonatomic, strong) IMGroupInfo *groupInfo;
@property (nonatomic, assign) BOOL deleteStatus;
@end

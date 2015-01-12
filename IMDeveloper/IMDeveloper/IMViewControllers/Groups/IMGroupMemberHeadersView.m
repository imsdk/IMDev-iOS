//
//  IMGroupMemberHeadersView.m
//  IMDeveloper
//
//  Created by mac on 14/12/24.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMGroupMemberHeadersView.h"
#import "IMHeadIcon.h"
#import "UIView+IM.h"

//IMSDK Headers
#import "IMMyself.h"
#import "IMGroupInfo.h"
#import "IMMyself+Group.h"

@interface IMGroupMemberHeadersView()

@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) NSMutableArray *customUserIDs;

@end

@implementation IMGroupMemberHeadersView {
    UIImageView *_addMemberView;
    UIImageView *_deleteMemberView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _addMemberView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        
        [_addMemberView setBackgroundColor:[UIColor clearColor]];
        [[_addMemberView layer] setBorderWidth:1.0];
        [[_addMemberView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [[_addMemberView layer] setCornerRadius:5.0];
        [_addMemberView setUserInteractionEnabled:YES];
        [self addSubview:_addMemberView];
        
        
        UITapGestureRecognizer *addGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTaped:)];
        
        [_addMemberView addGestureRecognizer:addGesture];
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(9, 26, 36, 3)];
        
        [line1 setBackgroundColor:[UIColor lightGrayColor]];
        [_addMemberView addSubview:line1];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(26, 9, 3, 36)];
        
        [line2 setBackgroundColor:[UIColor lightGrayColor]];
        [_addMemberView addSubview:line2];
        
        _deleteMemberView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        
        [_deleteMemberView setBackgroundColor:[UIColor clearColor]];
        [[_deleteMemberView layer] setBorderWidth:1.0];
        [[_deleteMemberView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [[_deleteMemberView layer] setCornerRadius:5.0];
        [_deleteMemberView setUserInteractionEnabled:YES];
        [self addSubview:_deleteMemberView];
        
        UITapGestureRecognizer *deleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTaped:)];
        
        [_deleteMemberView addGestureRecognizer:deleteGesture];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(9, 26, 36, 3)];
        
        [line3 setBackgroundColor:[UIColor lightGrayColor]];
        [_deleteMemberView addSubview:line3];
        
        [_deleteMemberView setHidden:YES];
        [_addMemberView setHidden:YES];
    
        _customUserIDs = [[NSMutableArray alloc] initWithCapacity:32];
    }
    return self;
}

- (void)setGroupInfo:(IMGroupInfo *)groupInfo {
    if (_groupInfo == groupInfo) {
        return;
    }
    
    _groupInfo = groupInfo;
    
    [self setCustomUserIDs:(NSMutableArray *)[_groupInfo memberList]];
    if ([[_groupInfo ownerCustomUserID] isEqualToString:[g_pIMMyself customUserID]]) {
        [self setIsManager:YES];
    } else {
        [self setIsManager:NO];
    }
    
}

- (void)setIsManager:(BOOL)isManager {
    _isManager = isManager;
    
    if (_isManager) {
        [_addMemberView setHidden:NO];
        [_deleteMemberView setHidden:NO];
    } else {
        [_addMemberView setHidden:YES];
        [_deleteMemberView setHidden:YES];
    }
}

- (void)setCustomUserIDs:(NSMutableArray *)customUserIDs {
    [_customUserIDs removeAllObjects];
    
    [_customUserIDs addObjectsFromArray:customUserIDs];
    
    for (UIView *view in [self subviews]) {
        if (view != _addMemberView && view != _deleteMemberView) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < [customUserIDs count]; i ++) {
        if (![[customUserIDs objectAtIndex:i] isKindOfClass:[NSString class]]) {
            continue;
        }
        
        NSInteger x = (i % 4) * 55 + ((i % 4) + 1) * 20;
        NSInteger y = (i / 4) * 75 + (i / 4 + 1) * 20;
        IMHeadIcon *headView = [[IMHeadIcon alloc] initWithFrame:CGRectMake(x, y, 55, 75)];
        
        [headView setCustomUserID:[customUserIDs objectAtIndex:i]];
        [headView setTag:1000 + i];
        [headView setUserInteractionEnabled:YES];
        
        if ([[_groupInfo ownerCustomUserID] isEqualToString:[customUserIDs objectAtIndex:i]]) {
            [headView setDeleteStatus:NO];
        } else {
            [headView setDeleteStatus:_deleteStatus];
        }
        [self addSubview:headView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTaped:)];
        
        [headView addGestureRecognizer:gesture];
        
        if (i == [customUserIDs count] - 1) {
            if (i % 4 == 3) {
                [_addMemberView setFrame:CGRectMake(20, headView.bottom + 20, 55, 55)];
                [_deleteMemberView setFrame:CGRectMake(_addMemberView.right + 20, _addMemberView.top, 55, 55)];
            } else {
                [_addMemberView setFrame:CGRectMake(headView.right + 20, headView.top, 55, 55)];
                
                if (i % 4 == 2) {
                    [_deleteMemberView setFrame:CGRectMake(20, headView.bottom + 20, 55, 55)];
                } else {
                    [_deleteMemberView setFrame:CGRectMake(_addMemberView.right + 20, _addMemberView.top, 55, 55)];
                }
            }
        }
    }
}

- (void)gestureTaped:(UITapGestureRecognizer *)gesture{
    if ([gesture view] == _addMemberView) {
        if (_delegate && [_delegate respondsToSelector:@selector(addMemberButtonClick)]) {
            [_delegate addMemberButtonClick];
        }
    } else if ([gesture view] == _deleteMemberView) {
        if ([_customUserIDs containsObject:[g_pIMMyself customUserID]] && [_customUserIDs count] == 1) {
            return;
        }
        _deleteStatus = !_deleteStatus;
        
        for (IMHeadIcon *headView in [self subviews]) {
            if (![headView isKindOfClass:[IMHeadIcon class]]) {
                continue;
            }
            if ([[headView customUserID] isEqualToString:[g_pIMMyself customUserID]]) {
                continue;
            }
            
            [headView setDeleteStatus:_deleteStatus];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(setDeleteStatus:)]) {
            [_delegate setDeleteStatus:_deleteStatus];
        }
        
    } else {
        IMHeadIcon *headView = (IMHeadIcon *)[gesture view];
        
        if (![headView isKindOfClass:[IMHeadIcon class]]) {
            return;
        }
        
        NSString *customUserID = [_customUserIDs objectAtIndex:[headView tag] - 1000];
        
        if ([headView deleteStatus]) {
            if (_delegate && [_delegate respondsToSelector:@selector(deleteMember:)]) {
                [_delegate deleteMember:customUserID];
            }
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(headViewTaped:)]) {
                [_delegate headViewTaped:customUserID];
            }
        }
    }
}

- (void)setDeleteStatus:(BOOL)deleteStatus {
    _deleteStatus = deleteStatus;
}
             
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

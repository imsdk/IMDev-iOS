//
//  SFCountdownView.h
//  Pod
//
//  Created by Thomas Winkler on 10/02/14.
//  Copyright (c) 2014 SimpliFlow. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int kDefaultCountdownFrom = 5;

@class SFCountdownView;

@protocol SFCountdownViewDelegate <NSObject>

@required
- (void) countdownFinished:(SFCountdownView *)view;

@end

@interface SFCountdownView : UIView

@property (nonatomic) int countdownFrom;
@property (nonatomic) NSString* finishText;

// appearance settings
@property (nonatomic) UIColor* countdownColor;
@property (nonatomic) NSString* fontName;
@property (nonatomic) float backgroundAlpha;

@property (nonatomic, weak) id<SFCountdownViewDelegate> delegate;

- (void) updateAppearance;
- (void) start;
- (void) stop;

@end

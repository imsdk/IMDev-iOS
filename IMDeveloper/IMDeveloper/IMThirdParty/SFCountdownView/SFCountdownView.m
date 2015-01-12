//
//  SFCountdownView.h
//  Pod
//
//  Created by Thomas Winkler on 10/02/14.
//  Copyright (c) 2014 SimpliFlow. All rights reserved.
//

#import "SFCountdownView.h"

@interface SFCountdownView ()

@property (nonatomic) NSTimer* timer;
@property (nonatomic) UILabel* countdownLabel;

@property (nonatomic) int currentCountdownValue;

@end

#define COUNTDOWN_LABEL_FONT_SCALE_FACTOR 0.3

@implementation SFCountdownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self updateAppearance];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aCoder {
    if(self = [super initWithCoder:aCoder]){
        [self updateAppearance];
    }
    return self;
}

- (void) updateAppearance
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:self.backgroundAlpha];
    
    // countdown label
    float fontSize = self.bounds.size.width * COUNTDOWN_LABEL_FONT_SCALE_FACTOR;
    
    self.countdownLabel = [[UILabel alloc] init];
    [self.countdownLabel setFont:[UIFont fontWithName:self.fontName size:fontSize]];
    [self.countdownLabel setTextColor:self.countdownColor];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    
    self.countdownLabel.opaque = YES;
    self.countdownLabel.alpha = 1.0;
    [self addSubview: self.countdownLabel];
    
    self.countdownLabel.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + 400, self.frame.size.height);
    [self.countdownLabel setCenter:self.center];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.countdownLabel.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + 400, self.frame.size.height);
    [self.countdownLabel setCenter:self.center];
}

#pragma mark - start/stopping
- (void) start
{
    [self stop];
    self.currentCountdownValue = self.countdownFrom;
    
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", self.countdownFrom];
    [self animate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(animate)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stop
{
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
    }
}

#pragma mark - animation stuff

- (void) animate
{
    [UIView animateWithDuration:0.9 animations:^{
    
        CGAffineTransform transform = CGAffineTransformMakeScale(2.5, 2.5);
        self.countdownLabel.transform = transform;
        self.countdownLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            
             if (self.currentCountdownValue == 0) {
                 [self stop];
                 if (self.delegate) {
                     [self.delegate countdownFinished:self];
                     [self removeFromSuperview];
                 }
                 
             } else {

                self.countdownLabel.transform = CGAffineTransformIdentity;
                self.countdownLabel.alpha = 1.0;
                
                self.currentCountdownValue--;
                if (self.currentCountdownValue == 0) {
                    self.countdownLabel.text = self.finishText;
                } else {
                    self.countdownLabel.text = [NSString stringWithFormat:@"%d", self.currentCountdownValue ];
                }
            }
        }
    }];
}

#pragma mark - custom getters
- (NSString*)finishText
{
    if (!_finishText) {
        _finishText = @"Go";
    }
    
    return _finishText;
}

- (float)backgroundAlpha
{
    if (_backgroundAlpha == 0) {
        _backgroundAlpha = 0.3;
    }
    
    return _backgroundAlpha;
}

- (int) countdownFrom
{
    if (_countdownFrom == 0) {
        _countdownFrom = kDefaultCountdownFrom;
    }
    
    return _countdownFrom;
}

- (UIColor*)countdownColor
{
    if (!_countdownColor) {
        _countdownColor = [UIColor blackColor];
    }
    
    return _countdownColor;
}

- (NSString *)fontName
{
    if (!_fontName) {
        _fontName = @"HelveticaNeue-Medium";
    }
    
    return _fontName;
}



@end

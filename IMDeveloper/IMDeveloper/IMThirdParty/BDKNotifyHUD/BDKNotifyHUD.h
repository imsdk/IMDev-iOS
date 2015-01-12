#import <UIKit/UIKit.h>

#define kBDKNotifyHUDDefaultWidth 130.0f
#define kBDKNotifyHUDDefaultHeight 100.0f

@interface BDKNotifyHUD : UIView

@property (nonatomic) CGFloat destinationOpacity;
@property (nonatomic) CGFloat currentOpacity;
@property (nonatomic) UIImage *image;
@property (nonatomic) CGFloat roundness;
@property (nonatomic) BOOL bordered;
@property (nonatomic) BOOL isAnimating;

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) NSString *text;

+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text;
- (id)initWithImage:(UIImage *)image text:(NSString *)text;

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion;
@end

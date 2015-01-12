//
//  UIImage+IM.h
//  IMSDK
//
//  Created by lyc on 14-10-9.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IM)

- (UIImage *)imMaskWithColor:(UIColor *)color;

// Alpha
- (BOOL)imHasAlpha;
- (UIImage *)imImageWithAlpha;
- (UIImage *)imTransparentBorderImage:(NSUInteger)borderSize;

// Resize
- (UIImage *)imCroppedImage:(CGRect)bounds;
- (UIImage *)imThumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)imResizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)imResizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

// RoundCorner
- (UIImage *)imRoundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
// Shape
+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
@end

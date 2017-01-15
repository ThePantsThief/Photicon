//
//  UIImage+PHExtensions.h
//  Photicon
//
//  Created by Tanner on 1/15/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PHExtensions)

- (instancetype)maskedToImage:(UIImage *)image;
- (instancetype)resizedToSize:(CGSize)size;
- (instancetype)tintedToColor:(UIColor *)color;
- (instancetype)blurred:(CGFloat)radius;

@end

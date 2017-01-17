//
//  UIImage+PHExtensions.m
//  Photicon
//
//  Created by Tanner on 1/15/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "UIImage+PHExtensions.h"

@implementation UIImage (PHExtensions)

- (instancetype)maskedToImage:(UIImage *)maskImage {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef maskImageRef = maskImage.CGImage;
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL,
                                                                maskImage.size.width,
                                                                maskImage.size.height,
                                                                8, 0, colorSpace,
                                                                kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (!mainViewContentContext) {
        return nil;
    }
    
    CGFloat ratio = maskImage.size.width/self.size.width;
    
    if (ratio * self.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ self.size.height;
    }
    
    CGRect rect1 = {CGPointZero, maskImage.size};
    CGRect rect2 = {{- ((self.size.width*ratio)-maskImage.size.width)/2 ,
        - ((self.size.height*ratio)-maskImage.size.height)/2},
        {self.size.width*ratio, self.size.height*ratio}};
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, self.CGImage);
    
    // Create CGImageRef of the main view bitmap content,
    // and then release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    
    return theImage;
}

- (instancetype)resizedToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (instancetype)tintedToColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, self.CGImage);
    
    [color set];
    
    CGContextFillRect(context, area);
    CGContextRestoreGState(context);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, area, self.CGImage);
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

- (instancetype)blurred:(CGFloat)radius {
    // Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:self.CIImage forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:self.CIImage.extent];
    
    return [UIImage imageWithCGImage:cgImage];
}

@end

//
//  UIImage+DYQRCode.h
//  DYScanDemo
//
//  Created by Ethank on 16/9/14.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DYQRCode)
+ (UIImage *)dy_qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageName:(NSString *)waterImageName;

@end

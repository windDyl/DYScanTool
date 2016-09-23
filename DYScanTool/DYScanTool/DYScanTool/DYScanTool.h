//
//  DYScanTool.h
//  DYScanDemo
//
//  Created by Ethank on 2016/9/22.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol DYScanToolDelegate <NSObject>
@required
- (void)scanCaptureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;

@end

@interface DYScanTool : NSObject
/** 捕捉会话 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
/** 打开闪关灯与否  **/
@property (nonatomic, assign) BOOL torch;
@property (nonatomic, weak)id<DYScanToolDelegate> delegate;
@end

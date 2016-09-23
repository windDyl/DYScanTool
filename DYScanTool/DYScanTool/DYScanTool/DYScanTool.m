//
//  DYScanTool.m
//  DYScanDemo
//
//  Created by Ethank on 2016/9/22.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "DYScanTool.h"


@interface DYScanTool()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, weak)AVCaptureDevice *device;
@end

@implementation DYScanTool
- (instancetype)init {
    self = [super init];
    if (self) {
        // 1. 创建捕捉会话
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        self.session = session;
        
        // 2. 添加输入设备(数据从摄像头输入)
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.device = device;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [session addInput:input];
        
        // 3. 添加输出数据接口
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        // 设置输出接口代理
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [session addOutput:output];
        // 3.1 设置输入元数据的类型(类型是二维码数据)
        // 注意，这里必须设置在addOutput后面，否则会报错
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        // 4.添加扫描图层
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.layer = layer;
    }
    return self;
}

- (void)setTorch:(BOOL)torch {
    _torch = torch;
    
    [self.device lockForConfiguration:nil];
    self.device.torchMode = self.torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [self.device unlockForConfiguration];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(scanCaptureOutput:didOutputMetadataObjects:fromConnection:)]) {
        [self.delegate scanCaptureOutput:captureOutput didOutputMetadataObjects:metadataObjects fromConnection:connection];
    }
}
@end

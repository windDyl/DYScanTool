//
//  DYScanVCViewController.m
//  DYScanDemo
//
//  Created by Ethank on 2016/9/22.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "DYScanVCViewController.h"
#import "DYScanTool.h"
#import "UIView+Extension.h"
#import "Masonry.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kTop 20
@interface DYScanVCViewController ()<DYScanToolDelegate>

@property (nonatomic , strong)DYScanTool *scanTool;
@property (nonatomic, weak)UIImageView *scanNetView;

@property (nonatomic, assign)BOOL animated;

@property (nonatomic, weak)UILabel *swithLabel;
@end

@implementation DYScanVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupSubviews];
    [self setupBackButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 5. 开始扫描
    [self.scanTool.session startRunning];
    self.animated = YES;
    [self scanNetAnimation];
}
- (void)setupSubviews {
    
    self.scanTool = [[DYScanTool alloc] init];
    self.scanTool.delegate = self;
    CGFloat height = self.view.bounds.size.width * 1.2;
    self.scanTool.layer.frame = CGRectMake(0, kTop, kScreenWidth, height);
    [self.view.layer addSublayer:self.scanTool.layer];
    
    
    // 扫描网图片
    UIImageView *scanNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_qrcode_line"]];
    self.animated = YES;
    scanNetView.x = 8  ;// (scanAreaImageView.width - scanNetView.width) * 0.5;
    scanNetView.y = kTop ;
    scanNetView.height = 2 ;
    [self.view addSubview:scanNetView];
    self.scanNetView = scanNetView;
    
    // 闪光灯开关
    UIButton *flashLightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [flashLightButton addTarget:self action:@selector(flashLightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [flashLightButton setBackgroundImage:[UIImage imageNamed:@"home_qrcode_lamp_on_btn"] forState:UIControlStateNormal];
    [flashLightButton setBackgroundImage:[UIImage imageNamed:@"home_qrcode_lamp_off_btn"] forState:UIControlStateSelected];
    [self.view addSubview:flashLightButton];
    [flashLightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(height + 40);
        make.size.mas_equalTo(flashLightButton.currentBackgroundImage.size);
    }];
    
    // 提示
    UILabel *swithLabel = [[UILabel alloc] init] ;
    swithLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5] ;
    swithLabel.font = [UIFont systemFontOfSize:11] ;
    swithLabel.text = @"打开闪光灯" ;
    [self.view addSubview:swithLabel] ;
    self.swithLabel = swithLabel ;
    [swithLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view) ;
        make.top.equalTo(flashLightButton.mas_bottom).offset(10) ;
    }];
}
- (void)setupBackButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton addTarget:self action:@selector(backBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[[UIImage imageNamed:@"home_qrcode_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(20.0);
        make.size.mas_equalTo(CGSizeMake(50.0, 50.0));
    }];
}

//扫描的动画
- (void)scanNetAnimation{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2.0 animations:^{
        weakSelf.scanNetView.y = weakSelf.scanTool.layer.frame.size.height - 1 + kTop;
    } completion:^(BOOL finished) {
        weakSelf.scanNetView.y =  kTop;
        if (weakSelf.animated) {
            [weakSelf scanNetAnimation];
        }
    }];
}
//闪关灯按钮点击事件
- (void)flashLightBtnOnClick:(UIButton *)button {
    button.selected = !button.selected;
    self.swithLabel.text = button.selected ? @"关闭闪光灯" : @"打开闪光灯";
    self.scanTool.torch = button.selected;
}
//返回
- (void)backBtnOnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -DYScanToolDelegate
- (void)scanCaptureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count) {// 扫描到了数据
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        
        // 停止扫描
        [self.scanTool.session stopRunning];
        
        // 将预览图层移除
        [self.scanTool.layer removeFromSuperlayer];
        NSLog(@"---------%@", object.stringValue);
        NSString *urlStr = object.stringValue;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        
        
    }else{
        NSLog(@"没有扫描到数据");
    }

}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}
@end

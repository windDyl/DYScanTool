//
//  ViewController.m
//  DYScanTool
//
//  Created by Ethank on 2016/9/23.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+DYQRCode.h"
#import "DYScanVCViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //二维码生成
    UIImage *image = [UIImage dy_qrImageForString:@"https://www.baidu.com" imageSize:200 logoImageName:@"AppIcon60x60"];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(50, 120, 200, 200)];
    
    [aView.layer setContents:(id)image.CGImage];
    [self.view addSubview:aView];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //二维码扫描
    DYScanVCViewController *scanVC = [[DYScanVCViewController alloc] init];
    [self presentViewController:scanVC animated:YES completion:nil];
}


@end

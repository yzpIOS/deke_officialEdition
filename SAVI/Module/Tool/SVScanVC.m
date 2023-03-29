//
//  SVScanVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVScanVC.h"
#import <AVFoundation/AVFoundation.h>

@interface SVScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *session;//输入输出的中间桥梁

@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation SVScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"扫一扫";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"扫一扫";
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //判断输入流是否可用
    if (input) {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        self.session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //设置为宽高为200的正方形区域相对于屏幕居中
        layer.frame = CGRectMake((self.view.bounds.size.width - 250) / 2.0, (self.view.bounds.size.height - 130 - 250) / 2.0, 250, 250);
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获图像:
        [_session startRunning];
    }
    
    // 蓝线
    
    UIImageView *line = [[UIImageView alloc] initWithFrame: CGRectMake((self.view.bounds.size.width - 250) / 2.0, (self.view.bounds.size.height - 130 - 250) / 2.0, 250, 1)];
    
    line.image = [UIImage imageNamed:@"fbackline"];
    
    [self.view addSubview:line ];
    
    /* 添加动画 */
    
    [UIView animateWithDuration:2 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        line.frame = CGRectMake((self.view.bounds.size.width - 250) / 2.0 , (self.view.bounds.size.height - 130 - 250) / 2.0 + 250, 250, 1);
        
    } completion:nil];
    
    
}




#pragma mark - 扫面结果在这个代理方法里获取到
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //获取到信息后停止扫描:
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        
        if (self.saosao_Block) {
            self.saosao_Block(metaDataObject.stringValue);
        }
        
        //输出扫描字符串:
        //移除扫描视图:
        AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
        [layer removeFromSuperlayer];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

//
//  QRCode.m
//  KaiQiCaiFu
//
//  Created by Macx on 2017/8/7.
//  Copyright © 2017年 BAOKAI ASSET. All rights reserved.
//

#import "QRCode.h"
#import "QRCodeScanningVC.h"

@implementation QRCode

+ (void)QRCodeClickBy:(UIViewController *)currentVC{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [currentVC.navigationController pushViewController:vc animated:YES];
                    });
                    SGQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    SGQRCodeLog(@"用户第一次同意了访问相机权限");
                }
                else {
                    // 用户第一次拒绝了访问相机权限
                    SGQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized) {
            // 用户允许当前应用访问相机
            QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [currentVC.navigationController pushViewController:vc animated:YES];
        }
        else if (status == AVAuthorizationStatusDenied) {
            // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertA];
            [currentVC presentViewController:alertC animated:YES completion:nil];
        }
        else if (status == AVAuthorizationStatusRestricted) {
            //[SVTool TextButtonAction:self.view withSing:@"因为系统原因, 无法访问相册"];
        }
    }
    else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:alertA];
        [currentVC presentViewController:alertC animated:YES completion:nil];
    }
}

@end

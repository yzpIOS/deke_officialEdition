//
//  QRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "ScanSuccessJumpVC.h"
//#import "personalDetailVC.h"

@interface QRCodeScanningVC ()

@end

@implementation QRCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
    
    self.navigationItem.leftBarButtonItem = ({
        UIButton *leftBtn                     = [UIButton buttonWithType:UIButtonTypeSystem];
        UIBarButtonItem *leftItem             = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        leftBtn.frame                         = CGRectMake(0, 0, 22, 22);
        [leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(back_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        leftItem;
    });
    NSDictionary *title_dict = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:title_dict];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
- (void)back_OnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;

    ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
    jumpVC.jump_URL = string;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
//    SGQRCodeLog(@"noti - - %@", noti);
//    NSString *string = noti.object;
//    NSLog(@"%@",string);
    
//    if ([string hasPrefix:@"http"]) {
//        if ([string hasPrefix:@"http://192.168.0.113"] || [string hasPrefix:@"http://api.m.kaiqicf.com:888"] || [string hasPrefix:@"https://api.m.kaiqicf.com"]) {
//            NSRange range = [string rangeOfString:@"id="];//匹配得到的下标
//            NSLog(@"rang:%@",NSStringFromRange(range));
//            NSUInteger aa = range.length + range.location;
//            NSString *newStr = [string substringFromIndex:aa];
//            NSLog(@"截取的值为：%@",newStr);
////            personalDetailVC *vc = [personalDetailVC new];
////            vc.userID = newStr;
////            vc.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else{
//            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//            jumpVC.jump_URL = string;
//            [self.navigationController pushViewController:jumpVC animated:YES];
//        }
//    }
//    else if ([string hasPrefix:@"kq:ticketNum"]) {
//        // 判断是否是机构用户
//        NSString *role = (NSString *)[NSObject readObjforKey:@"kqcf-role"];
//        if ([role isEqualToString:@"I"]) {
//            // 订单号
//            NSString *ticket = [string substringFromIndex:13];
//            WeakVar(wself, self);
//            [[XBaseServer shared] organizationUserScanTicket:ticket :^(NSDictionary *dict) {
//                StrongVar(sself, wself);
//                if (sself) {
//                    NSString *code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
//                    NSString *message = [dict objectForKey:@"message"];
//                    if ([code isEqualToString:@"0"]) {
//                        [MsgBox showMessage:@"扫描票号成功"];
//                    }
//                    else{
//                        [MsgBox showMessage:message];
//                    }
//                }
//            }];
//        }
//    }
//    else { // 扫描结果为条形码
//
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.jump_bar_code = string;
//        [self.navigationController pushViewController:jumpVC animated:YES];
//    }
}

- (void)dealloc {
    SGQRCodeLog(@"QRCodeScanningVC - dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
}

@end

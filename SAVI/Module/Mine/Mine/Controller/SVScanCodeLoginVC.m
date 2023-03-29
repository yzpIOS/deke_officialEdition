//
//  SVScanCodeLoginVC.m
//  SAVI
//
//  Created by F on 2020/10/16.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVScanCodeLoginVC.h"
#import "SVMineVC.h"
@interface SVScanCodeLoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation SVScanCodeLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户登录";
    self.confirmBtn.layer.cornerRadius = 30;
    self.confirmBtn.layer.masksToBounds = YES;
    
    self.cancleBtn.layer.cornerRadius = 30;
    self.cancleBtn.layer.masksToBounds = YES;
}

- (IBAction)confirmClick:(id)sender {
    self.confirmBtn.userInteractionEnabled = NO;
     [SVUserManager loadUserInfo];
    NSString *urlStr = [NSString stringWithFormat:@"http://push.decerp.cc/api/Message/PushByGroupId?group=%@",self.code];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"description"] = @"扫码登录";
    parame[@"notifyType"] = @"0";
    parame[@"passThrough"] = @"0";
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    content[@"token"] = [SVUserManager shareInstance].access_token;
    [payload setObject:content forKey:@"content"];
    NSArray *tagPackage = [NSArray arrayWithObject:self.code];
    NSString *title = @"扫码登录";
    NSArray *userGroups = [NSArray arrayWithObject:self.code];
    [parame setObject:payload forKey:@"payload"];
    [parame setObject:tagPackage forKey:@"tagPackage"];
    [parame setObject:title forKey:@"title"];
    [parame setObject:userGroups forKey:@"userGroups"];
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic收银记账 = %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            [SVTool TextButtonActionWithSing:@"扫码登录成功"];
             // 返回到任意界面
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[SVMineVC class]]) {
                    
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            // NSString *msg = dic[@"msg"];
             [SVTool TextButtonActionWithSing:@"扫码登录失败"];
           // [SVTool TextButtonActionWithSing:@"扫码登录失败"];
        }
         self.confirmBtn.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

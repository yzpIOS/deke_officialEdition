//
//  SVAccountCancellationOperation.m
//  SAVI
//
//  Created by 杨忠平 on 2022/6/27.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVAccountCancellationOperation.h"
#import "SVLandingVC.h"

@interface SVAccountCancellationOperation ()
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *SMSVerificationCodeText;
@property (weak, nonatomic) IBOutlet UIButton *SMSVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *SMSVerificationCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *accountCancellationBtn;

@end

@implementation SVAccountCancellationOperation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注销账号";
    self.accountNumberLabel.text = [SVUserManager shareInstance].sv_ul_mobile;
}

- (IBAction)SMSVerificationCodeClick:(id)sender {
    if (self.accountNumberLabel.text.length == 0) {
        [SVTool TextButtonAction:self.view withSing:@"必须要有手机号"];
        return;
    }
    //倒计时
    [self countdown];
    [SVUserManager loadUserInfo];
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
   // NSString *token = [SVUserManager shareInstance].access_token;
    NSString *sv_ul_mobile = [SVUserManager shareInstance].sv_ul_mobile;
     NSString *dURL=[URLhead stringByAppendingFormat:@"/api/BranchStoreNew/OrdinarySendVerificationCode?key=%@&phone=%@",[SVUserManager shareInstance].access_token,self.accountNumberLabel.text];
    
//    [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"dic验证码 = %@",dic);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              //隐藏提示框
//                     [MBProgressHUD hideHUDForView:self.view animated:YES];
//                     [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//    }];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
                       NSLog(@"dic验证码 = %@",dict);
        if ([dict[@"code"] integerValue] == 1) {
            NSString *msg= dict[@"msg"];
             if (msg.length == 0) {
                 [SVTool TextButtonAction:self.view withSing:@"发送验证码成功"];
             }else{
                 [SVTool TextButtonAction:self.view withSing:dict[@"msg"]];
             }
        }else{
           NSString *msg= dict[@"msg"];
            if (msg.length == 0) {
                [SVTool TextButtonAction:self.view withSing:@"数据有误"];
            }else{
                [SVTool TextButtonAction:self.view withSing:dict[@"msg"]];
            }
            
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma mark - 注销账号
- (IBAction)accountCancellationClick:(id)sender {
   
    if (self.accountNumberLabel.text.length == 0) {
        [SVTool TextButtonAction:self.view withSing:@"必须要有手机号"];
        return;
    }
    
    if (self.SMSVerificationCodeText.text.length == 0) {
        [SVTool TextButtonAction:self.view withSing:@"请输入验证码"];
        return;
    }
    
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    [SVUserManager loadUserInfo];
   // NSString *token = [SVUserManager shareInstance].access_token;
    NSString *sv_ul_mobile = [SVUserManager shareInstance].sv_ul_mobile;
     NSString *dURL=[URLhead stringByAppendingFormat:@"/api/BranchStoreNew/Store_Cancellation?key=%@",[SVUserManager shareInstance].access_token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"phone"] = self.accountNumberLabel.text;
    parame[@"code"] = self.SMSVerificationCodeText.text;
    [[SVSaviTool sharedSaviTool] POST:dURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
                       NSLog(@"dic验证码 = %@",dict);
        if ([dict[@"code"] integerValue] == 1) {
            NSString *msg= dict[@"msg"];
             if (msg.length == 0) {
                 [SVTool TextButtonAction:self.view withSing:@"注销账号成功"];
             
             }else{
                 [SVTool TextButtonAction:self.view withSing:dict[@"msg"]];
             }
            
            self.hidesBottomBarWhenPushed = YES;
//            //清除帐号
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults removeObjectForKey:@"bigName_Arr"];
//            [defaults removeObjectForKey:@"bigID_Arr"];
//            //[defaults setObject:@"" forKey:@"account"];
//            //[defaults setObject:@"" forKey:@"passwd"];
//            [defaults synchronize];

            SVLandingVC *mainVC = [[SVLandingVC alloc] init];
               UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
              [UIApplication sharedApplication].keyWindow.rootViewController = Nav;
            
        }else{
           NSString *msg= dict[@"msg"];
            if (msg.length == 0) {
                [SVTool TextButtonAction:self.view withSing:@"数据有误"];
            }else{
                [SVTool TextButtonAction:self.view withSing:dict[@"msg"]];
            }
            
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    
    
//    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                       NSLog(@"dic验证码 = %@",dict);
//        if ([dict[@"code"] integerValue] == 1) {
//            NSString *msg= dict[@"msg"];
//             if (msg.length == 0) {
//                 [SVTool TextButtonAction:self.view withSing:@"注销账号成功"];
//                 for (UIViewController *controller in self.navigationController.viewControllers) {
//                     if ([controller isKindOfClass:[SVLandingVC class]]) {
//                         [self.navigationController popToViewController:controller animated:YES];
//                     }
//                 }
//             }else{
//                 [SVTool TextButtonAction:self.view withSing:dict[@"msg"]];
//             }
//        }else{
//           NSString *msg= dict[@"msg"];
//            if (msg.length == 0) {
//                [SVTool TextButtonAction:self.view withSing:@"数据有误"];
//            }else{
//                [SVTool TextButtonAction:self.view withSing:dict[@"msg"]];
//            }
//
//        }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//        }];
}

#pragma mark - 按钮实现倒计时
-(void)countdown{
    //按钮实现倒计时
        __block int timeout=120; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.SMSVerificationCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    self.SMSVerificationCodeBtn.userInteractionEnabled = YES;
//                    self.attainButton.backgroundColor = [UIColor purpleColor];
                });
            }else{
                int seconds = timeout;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //让按钮变为不可点击的灰色
//                    self.attainButton.backgroundColor = [UIColor grayColor];
                    self.SMSVerificationCodeBtn.userInteractionEnabled = NO;
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.SMSVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
}

@end

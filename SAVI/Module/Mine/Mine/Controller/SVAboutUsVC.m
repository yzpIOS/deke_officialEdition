//
//  SVAboutUsVC.m
//  SAVI
//
//  Created by houming Wang on 2020/11/6.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVAboutUsVC.h"

@interface SVAboutUsVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usMine;
@property (weak, nonatomic) IBOutlet UILabel *VersionInformation;
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UILabel *QQ;
@property (weak, nonatomic) IBOutlet UILabel *wetChat;

@property (weak, nonatomic) IBOutlet UILabel *kefulianxi;
@property (weak, nonatomic) IBOutlet UILabel *QQLianxi;
@property (weak, nonatomic) IBOutlet UILabel *wechatlianxi;

@property (nonatomic,strong) NSString * telNumberStr;
@property (nonatomic,strong) NSString * QQStr;
@property (nonatomic,strong) NSString * wechatStr;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *telbohao;
@property (weak, nonatomic) IBOutlet UILabel *QQFuzhi;
@property (weak, nonatomic) IBOutlet UILabel *wechatFuzhi;


@end

@implementation SVAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系客服";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
      NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
      self.VersionInformation.text = [NSString stringWithFormat:@"当前版本:v%@",app_Version];
    NSString *sv_d_name=[SVUserManager shareInstance].sv_d_name;
    if (!kStringIsEmpty(sv_d_name)) {
        self.usMine.text = sv_d_name;
    }
//    NSString *sv_d_name = [SVUserManager shareInstance].sv_d_name;
//    self.usMine.text = sv_d_name;
    
//    NSString *sv_d_name = [SVUserManager shareInstance].sv_d_name;
//    self.usMine.text = sv_d_name;
//
//  //  NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
//  //  NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//   //  CFShow(infoDictionary);
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    self.VersionInformation.text = [NSString stringWithFormat:@"当前版本:v%@",app_Version];
//    NSArray *array =[SVUserManager shareInstance].sv_agent_custom_config;
//    if (!kArrayIsEmpty(array)) {
//        for (NSDictionary *dict in array) {
//            NSString *type=[NSString stringWithFormat:@"%@",dict[@"type"]];
//            if (type.doubleValue == 4) {
//                NSString *img = dict[@"img"];
//                if (!kStringIsEmpty(img)) {
//
//                    if ([img containsString:@"http:"]) {
//                       // self.icon.image = decodedImage;
//                        [self.icon sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"aboutUs"]];
//                    }else{
//                        NSArray *arrayTwo = [img componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
//                       // NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
//                        if (!kArrayIsEmpty(array)) {
//                            NSString *base64Str = arrayTwo[1];
//                            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
//                            UIImage *decodedImage = [UIImage imageWithData:decodedData];
//                            self.icon.image = decodedImage;
//                        }
//                    }
//
//
//                }
//                NSArray *data = dict[@"data"];
//                if (!kArrayIsEmpty(data)) {
//                    for (NSDictionary *dic in data) {
//                        NSString *type_detail = [NSString stringWithFormat:@"%@",dic[@"type"]];
//                        if (type_detail.doubleValue == 1) {
//
//                        }else if (type_detail.doubleValue == 2){ // 客服电话
//                            NSString *str =dic[@"data"];
//                            if (!kStringIsEmpty(str)) {
//                                self.telNumber.textColor = GlobalFontColor;
//                                self.telNumber.text = [NSString stringWithFormat:@" %@",dic[@"data"]];
//                                self.telNumberStr = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                                self.kefulianxi.hidden = NO;
//                            }else{
//
//                                self.telNumber.text = @"";
//                                self.telbohao.textColor = GlobalFontColor;
//                                self.telbohao.text = @"无";
//                            }
//
//                        }else if (type_detail.doubleValue == 3){ // qq
//                            NSString *str =dic[@"data"];
//                            if (!kStringIsEmpty(str)) {
//                                self.QQ.textColor = GlobalFontColor;
//                                self.QQ.text = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                                self.QQStr = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                                self.QQLianxi.hidden = NO;
//                            }else{
//
//                                self.QQ.text = @"";
//                                self.QQFuzhi.textColor = GlobalFontColor;
//                                self.QQFuzhi.text = @"无";
//                            }
//                           // self.QQ.text = [NSString stringWithFormat:@"(点击联系) %@",dic[@"data"]];
//                        }else if (type_detail.doubleValue == 4){// 微信
//                            NSString *str =dic[@"data"];
//                            if (!kStringIsEmpty(str)) {
//                                self.wetChat.textColor = GlobalFontColor;
//                                self.wetChat.text = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                                self.wechatStr = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                                self.wechatlianxi.hidden = NO;
//                            }else{
//
//                                self.wetChat.text = @"";
//                                self.wechatFuzhi.text = @"无";
//                                self.wechatFuzhi.textColor = GlobalFontColor;
//                            }
//                          //  self.wetChat.text = [NSString stringWithFormat:@"(点击联系) %@",dic[@"data"]];
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // app版本

    self.telNumberStr = self.telNumber.text;
    self.QQStr = self.QQ.text;
    self.wechatStr = self.wetChat.text;

}

#pragma mark - 点击电话
- (IBAction)telClick:(id)sender {
    if (!kStringIsEmpty(self.telNumber.text)) {
//        if (![SVTool valiMobile:self.telNumberStr]) {
//            [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
//            return;
//        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.telNumberStr;
       // [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@已经复制",self.telNumberStr]];
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telNumberStr];
        //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {//这句有一报错 / 2017.12.19
            
        }];//此方法有一个报错
    }
}
#pragma mark - 点击QQ客服
- (IBAction)kefuClick:(id)sender {
    if (!kStringIsEmpty(self.QQStr)) {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否去QQ联系%@",self.QQStr] message:nil preferredStyle:UIAlertControllerStyleActionSheet];

          UIAlertAction *alertT = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.QQStr;
            UIWebView *webView = [[UIWebView alloc] init];

               NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQStr]];
           // [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@已经复制",self.QQStr]];
               NSURLRequest *request = [NSURLRequest requestWithURL:url];

               webView.delegate = self;

               [webView loadRequest:request];

               [self.view addSubview:webView];

            }];

            UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

       

          }];



          [actionSheet addAction:alertT];

          [actionSheet addAction:alertF];

          [self presentViewController:actionSheet animated:YES completion:nil];

    
       
    }
}
#pragma mark - 点击微信
- (IBAction)wechatClick:(id)sender {
    if (!kStringIsEmpty(self.wechatStr)) {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否去微信联系%@",self.wechatStr] message:nil preferredStyle:UIAlertControllerStyleActionSheet];

          UIAlertAction *alertT = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = self.QQStr;
//            UIWebView *webView = [[UIWebView alloc] init];
//
//               NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQStr]];
//           // [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@已经复制",self.QQStr]];
//               NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//               webView.delegate = self;
//
//               [webView loadRequest:request];
//
//               [self.view addSubview:webView];
            
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.wechatStr;
           // [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@已经复制",self.wechatStr]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }

            }];

            UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

       

          }];



          [actionSheet addAction:alertT];

          [actionSheet addAction:alertF];

          [self presentViewController:actionSheet animated:YES completion:nil];
        
        
        
    }
}



@end

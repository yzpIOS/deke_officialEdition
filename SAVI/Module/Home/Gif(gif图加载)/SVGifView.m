//
//  SVGifView.m
//  SAVI
//
//  Created by 杨忠平 on 2022/11/14.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVGifView.h"

//#import "XMADSView.h"
#import "AJTicker.h"
#import "SVTabBar.h"
#import "SVLandingVC.h"
#import "UIImage+GIF.h"
#import "FLAnimatedImage.h"
/// 屏幕判断相关
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define XMSCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define XMSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define XMSCREEN_MAX_LENGTH (MAX(XMSCREEN_WIDTH, XMSCREEN_HEIGHT))
#define XMSCREEN_MIN_LENGTH (MIN(XMSCREEN_WIDTH, XMSCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && XMSCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && XMSCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && XMSCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && XMSCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && XMSCREEN_MAX_LENGTH >= 812.0)
@interface SVGifView()
/// 背景图
@property (weak, nonatomic) UIImageView *bgImgView;
/// 进入按钮
@property (weak, nonatomic) UIButton *enterBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger remain;
@property (weak, nonatomic) FLAnimatedImageView *imageView;

@end

@implementation SVGifView

+ (instancetype)adsView{
    SVGifView *adsView = [[SVGifView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    return adsView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    
    
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"]]];
    NSString *path;
    if (ScreenH == 812) {
        path = [[NSBundle mainBundle] pathForResource:@"dekeStartUpTwo" ofType:@"gif"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"dekeStartUp" ofType:@"gif"];
    }
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:path]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, ScreenW, ScreenH);
    [self addSubview:imageView];
    self.imageView = imageView;
    __weak typeof(self) weakSelf = self;
    [imageView setLoopCompletionBlock:^(NSUInteger loopCountRemaining) {
        if (weakSelf.imageView.animatedImage.loopCount == 0 && weakSelf.imageView.isAnimating) {
            if (self.stopAnimalBlock) {
                self.stopAnimalBlock();
            }
            [weakSelf.imageView stopAnimating];
        }
    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"dekeStartUp" ofType:@"gif"];
//       NSData *data = [NSData dataWithContentsOfFile:path];
//       UIImage *image = [UIImage sd_animatedGIFWithData:data];
      
//    // 背景图
//    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:self.bounds];
//   // bgImgView.userInteractionEnabled = YES;
//    bgImgView.image = image;
//    [self addSubview:bgImgView];
    
//    NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dekeStartUp" ofType:@"gif"]];
//       //UIWebView生成
//       UIWebView *imageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//       //用户不可交互
//       imageWebView.userInteractionEnabled = NO;
//       //加载gif数据
//
//       [imageWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//       //视图添加此gif控件
//       [self addSubview:imageWebView];
    
//    YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    //  CGFloat centerX = self.center.x;
//     // [imageView setCenter:CGPointMake(centerX, 402)];
//    UIImage* image = [YLGIFImage imageNamed:@"dekeStartUp.gif"];
//    imageView.animationImages = image.images;
//    imageView.animationDuration = image.duration;
//
//    imageView.animationRepeatCount = 1;
//    [imageView startAnimating];
//    imageView.image = image;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [self performSelector:@selector(animationDidFinish) withObject:self afterDelay:imageView.animationRepeatCount * imageView.animationDuration];
//      [self addSubview:imageView];
     
    
    
    
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:@"dekeStartUp.gif"]];
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//    imageView.animatedImage = image;
//    imageView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
//    [self addSubview:imageView];
//    
//    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
//        NSLog(@"-----%@", logString);
//    } logLevel:FLLogLevelWarn];
  
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
//     [self addSubview:webView];
//
//     NSString *path = [[NSBundle mainBundle] pathForResource:@"dekeStartUp" ofType:@"gif"];
//     /*
//          NSData *data = [NSData dataWithContentsOfFile:path];
//          使用loadData:MIMEType:textEncodingName: 则有警告
//          [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//      */
//     NSURL *url = [NSURL URLWithString:path];
//     [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    NSString *sv_ad_canskip = [SVUserManager shareInstance].sv_ad_canskip;
//   // NSString *str = [SVUserManager shareInstance].sv_ad_canskip;
//    int sv_ad_canskipNumber = [sv_ad_canskip intValue];
//    if (sv_ad_canskipNumber != 0) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgImgView)];
//        [bgImgView addGestureRecognizer:tap];
//    }
//
//
//    // 倒计时按钮
//    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    enterBtn.frame = CGRectMake(self.width-95, IS_IPHONE_X?50:30, 80, 34);
//    enterBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//    enterBtn.layer.cornerRadius = enterBtn.height *0.5;
//    enterBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
//    enterBtn.layer.borderWidth = 2;
//    enterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:enterBtn];
//    _enterBtn = enterBtn;
//
////    self.remain = 5;
////    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
////    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//
//    AJTicker *ticker = [AJTicker defaultTicker];
//   // ticker.kGetAuthCodeMaxTimeInterval = self.kGetAuthCodeMaxTimeInterval;
//        //  ticker.kGetAuthCodeMaxTimeInterval = self.kGetAuthCodeMaxTimeInterval;
//    [ticker startTickerWithButton:enterBtn];
//
//    __weak typeof(self) weakSelf = self;
//    ticker.timeBlock = ^{
//        [weakSelf dismiss];
//    };
   
   // ticker.remain = 5;
   // ticker.shouldTicking = YES;
  
}

- (void)animationDidFinish{
    
}


//- (void)setImgUrl:(NSString *)imgUrl{
//    _imgUrl = imgUrl;
//
//    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl?:@""] placeholderImage:nil];
//}
//
//- (void)setUrl:(NSString *)url{
//    _url = url;
//}
//
//- (void)tapBgImgView{
//
//    if (!_imgUrl.length) {
//        [self dismiss];
//        return;
//    }
//
//    if (!_url.length) {
////        [self dismiss];
//        return;
//    }
//   // [MobClick event:UM_CLICK_LAUNCH_AD_EVENT];
//    [self dismiss];
//
//    NSURL *URL = [NSURL URLWithString:_url?:@""];
//    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
//        [[UIApplication sharedApplication] openURL:URL];
//    }
//}

- (void)enterBtnClick{
   // NSString *sv_ad_skipbtn = [SVUserManager shareInstance].sv_ad_skipbtn;
  //  if (sv_ad_skipbtn.intValue == 1) {
        if ([AJTicker defaultTicker].isTicking) {
            return;
        }
        [self dismiss];
  //  }
   
}

//- (void)tick{
//
//    if(_remain == 0)
//    {
//        NSString *sv_ad_skipbtn = [SVUserManager shareInstance].sv_ad_skipbtn;
//        if (sv_ad_skipbtn.intValue == 0) {
//            [self dismiss];
//        }
//
//
//      //  NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
////            int kGetAuthCodeMaxTimeInterval = [str intValue];
////            self.remain = kGetAuthCodeMaxTimeInterval;
////        int kGetAuthCodeMaxTimeInterval = 5;
////        self.remain = kGetAuthCodeMaxTimeInterval;
////        self.shouldTicking = NO;
////        [self.button setTitle:@"进入" forState:UIControlStateNormal];
//////            self.button.backgroundColor = AJSystemColor;
////        [self.button setEnabled:YES];
////        self.button.alpha = 1;
//    }
//    else
//    {
//        _remain--;
////        [self.button setTitle:[NSString stringWithFormat:@"%lds", _remain] forState:UIControlStateNormal];
////        self.button.alpha = 0.8;
////      //  self.shouldTicking = YES;
////       //  self.shouldTicking = NO;
////         [self.button setEnabled:YES];
////            self.button.backgroundColor = AJRGBAColor(255, 87, 98, 0.6);
////            [self.button setEnabled:NO];
//    }
//}



- (void)dismiss{
   
    //跳转
    
    SVLandingVC *mainVC = [[SVLandingVC alloc] init];
       UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    // 点击通知打开app处理逻辑
//    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(userInfo){
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息"
//                                                                       message:[NSString stringWithFormat:@"%@", userInfo]
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *act = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:act];
//        [Nav presentViewController:alert animated:YES completion:nil];
//        //统计客户端 通过push开启app行为
//        NSString *messageId = [userInfo objectForKey:@"_id_"];
//        if (messageId!=nil) {
//            [MiPushSDK openAppNotify:messageId];
//        }
//    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
   // SVTabBar *tabbar = [[SVTabBar alloc]init];
    window.rootViewController = Nav;
    
     [self removeFromSuperview];
//       self.window.rootViewController = Nav;
//        [self.window makeKeyAndVisible];
    
  
}

@end

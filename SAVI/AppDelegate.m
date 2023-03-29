
//
//  AppDelegate.m
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "AppDelegate.h"
#import "SVTabBar.h"
#import "SVLandingVC.h"
//腾讯Bugly
#import <Bugly/Bugly.h>
//友盟分享
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//引导页
#import "SVGuidePagesVC.h"
#import "CALayer+Transition.h"
#import "XMADSView.h"
#import "MPViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import "KKSequenceImageView.h"
#import "UIImage+GIF.h"
#import "SVGifView.h"

#import "SVGifViewController.h"
static NSString * const kADImageName = @"kADImageName";
@interface AppDelegate ()<selectDelegate,KKSequenceImageDelegate>//引导页代理

{
    MPViewController *vMain;
    KKSequenceImageView* imageView;
    
}


@property (strong, nonatomic) UIImageView *customLaunchImageView;

/// 广告View
@property (weak, nonatomic) XMADSView *adsView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置启动图的时间
    //[NSThread sleepForTimeInterval:1.0];
    //设置全局状态栏字体颜色为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSArray *images = [NSArray array];
    // 测试的时候改变info 里的版本号就可以了
    if (ScreenH == 812) {
        images = @[@"GuidePages_1_1", @"GuidePages_2_2", @"GuidePages_3_3", @"GuidePages_4_4",@"GuidePages_5_5"];

    } else {
        images = @[@"GuidePages_1", @"GuidePages_2", @"GuidePages_3", @"GuidePages_4",@"GuidePages_5"];
        
    }
    
//    [NSThread sleepForTimeInterval:0.1];
   
    BOOL y = [SVGuidePagesVC isShow];
    if (y) {
        SVGuidePagesVC *xt = [[SVGuidePagesVC alloc] init];
        self.window.rootViewController = xt;
        xt.delegate = self;
        [xt guidePageControllerWithImages:images];
    } else {
        [self clickEnter];
    }
    
  
    // 设置所有光标颜色
    [[UITextField appearance] setTintColor:navigationBackgroundColor];
    [[UITextView appearance] setTintColor:navigationBackgroundColor];
    //腾讯    cf8fcbdb38
   // [Bugly startWithAppId:@"c2b4f8727d"];
    
    
    /* 设置友盟appkey */
    [UMSocialData setAppKey:@"15bf0db0d0dd6"];
    /* 打开调试日志 */
    [UMSocialData openLog:YES];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    //[UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954" secret:@"04b48b094faeb16683c32669824ebdad" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx692da5a54a080d67" appSecret:@"9cfaaae9d58167582fa8a3ca54b70946" url:nil];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1105525957" appKey:@"lQcbqayo71RfMb7Y" url:@"http://mobile.umeng.com/social"];
    
    [UMConfigure initWithAppkey:UMAppKey channel:UMAppChannel];
    [UMConfigure setAnalyticsEnabled:YES];//配置以上参数后调用此方法初始化SDK！
    [UMConfigure setLogEnabled:YES];
    // 设置APP版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [MobClick setVersion:version.integerValue];
    //lixiaoming替换成用户注册的电话号码
    [SVUserManager loadUserInfo];
   NSString *sv_ul_mobile = [SVUserManager shareInstance].sv_ul_mobile;
    if (!kStringIsEmpty(sv_ul_mobile)) {
        [MobClick event:@"__register" attributes:@{@"userid":sv_ul_mobile}];
    }
    [UMConfigure setLogEnabled:YES];
    
    //开发者需要显式的调用此函数，日志系统才能工作
  //  [UMCommonLogManager setUpUMCommonLogManager];
    
    //引用第三方键盘
    [IQKeyboardManager sharedManager].enable = YES;
    //点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //不需要工具条
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
   
    //当某一个输入框特定不需要键盘上的工具条时
    //textField.icputAccessoryView = [[UIView alloc]init];
    
//    /** 初始化imageView */
//      imageView = [[KKSequenceImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.screen.bounds.size.width,self.window.screen.bounds.size.height)];
//      NSMutableArray* gifImages = [NSMutableArray array];
//
//      /** 加载图片 */
//      for (int i = 1; i <= 90; i++)
//      {
//          NSString *path = [[NSBundle mainBundle] pathForResource:@"networkImage" ofType:@"gif"];
//          if (path.length) {
//              [gifImages addObject:path];
//          }
//      }
//
//      /** 设置参数 */
//      imageView.imagePathss = images;
//      imageView.durationMS = images.count * 60;
//      imageView.repeatCount = 1;
//      imageView.delegate = self;
//
//      /** 添加到window */
//      [_window addSubview:imageView];
//      [imageView begin];
    
    
   // fileUrl = [[NSBundle mainBundle] URLForResource:@"启动页" withExtension:@"gif"];
    
    /** 添加更新提示 */
    //方法一：
  
    //向微信注册,发起支付必须注册
   // [WXApi registerApp:@"wxb4ba3c02aa476ea1" enableMTA:YES];

//    SVTabBar *tabbar = [[SVTabBar alloc]init];
//    self.window.rootViewController = tabbar;

    /**
     小米推送
     */
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
   // vMain = [[MPViewController alloc] init];
   // vMain.iDelegate = self;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vMain];
//    self.window.rootViewController = nav;

//    [self.window makeKeyAndVisible];
    
//    vMain = [[MPViewController alloc] init];
//    vMain.iDelegate = self;
    
   // [MiPushSDK registerMiPush:self type:0 connect:YES];
    
    [SVUserManager loadUserInfo];
    [SVUserManager shareInstance].bannersConfig = nil;
    [SVUserManager shareInstance].launchOptions = launchOptions;
    [SVUserManager saveUserInfo];
    
//    // 点击通知打开app处理逻辑
//    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(userInfo){
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息"
//                                                                       message:[NSString stringWithFormat:@"%@", userInfo]
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *act = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:act];
//        [nav presentViewController:alert animated:YES completion:nil];
//        //统计客户端 通过push开启app行为
//        NSString *messageId = [userInfo objectForKey:@"_id_"];
//        if (messageId!=nil) {
//            [MiPushSDK openAppNotify:messageId];
//        }
//    }
    
    return YES;

}

- (void)loadGifView{
    
//    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GuidePages_1_1" ofType:@"png"]];
   

     SVGifView *adsView = [SVGifView adsView];
    
    __weak typeof(self) weakSelf = self;
    adsView.stopAnimalBlock = ^{
        [weakSelf judgeShowAdsViewRequest];
    };
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:adsView];
  



}



#pragma mark -- 代理方法
- (void)sequenceImageDidPlayCompeletion:(KKSequenceImageView *)imageView
{
    /** 运行完成--clean */
    [imageView removeFromSuperview];
    imageView = nil;
}

//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}
//
//#pragma mark 注册push服务.
//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//   // [vMain printLog:[NSString stringWithFormat:@"APNS token: %@", [deviceToken description]]];
//    NSLog(@"%@",[NSString stringWithFormat:@"APNS token: %@", [deviceToken description]]);
//    // 注册APNS成功, 注册deviceToken
//    [MiPushSDK bindDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
//{
//    [vMain printLog:[NSString stringWithFormat:@"APNS error: %@", err]];
//    NSLog(@"%@",[NSString stringWithFormat:@"APNS error: %@", err]);
//    // 注册APNS失败.
//    // 自行处理.
//}
//
//#pragma mark Local And Push Notification
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//   // [vMain printLog:[NSString stringWithFormat:@"APNS notify: %@", userInfo]];
//    NSLog(@"%@",[NSString stringWithFormat:@"APNS notify: %@", userInfo]);
//    // 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
//    [MiPushSDK handleReceiveRemoteNotification:userInfo];
//}
//
//// iOS10新加入的回调方法
//// 应用在前台收到通知
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//       // [vMain printLog:[NSString stringWithFormat:@"APNS notify: %@", userInfo]];
//        NSLog(@"%@",[NSString stringWithFormat:@"APNS notify: %@", userInfo]);
//        [MiPushSDK handleReceiveRemoteNotification:userInfo];
//    }
//    //    completionHandler(UNNotificationPresentationOptionAlert);
//}
//
//// 点击通知进入应用
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [vMain printLog:[NSString stringWithFormat:@"APNS notify: %@", userInfo]];
//        [MiPushSDK handleReceiveRemoteNotification:userInfo];
//    }
//    completionHandler();
//}
//
//#pragma mark MiPushSDKDelegate
//- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
//{
//   // [vMain printLog:];
//    NSLog(@"%@",[NSString stringWithFormat:@"command succ(%@): %@", [self getOperateType:selector], data]);
//    if ([selector isEqualToString:@"registerMiPush:"]) {
//        [vMain setRunState:YES];
//    }else if ([selector isEqualToString:@"registerApp"]) {
//        // 获取regId
//        NSLog(@"regid = %@", data[@"regid"]);
//    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
//        
//        [MiPushSDK setAlias:@"dailybuild_test_alias"];
//        [MiPushSDK subscribe:@"ios_phone"];
//        [MiPushSDK setAccount:[SVUserManager shareInstance].user_id];
//        // 获取regId
//        NSLog(@"regid = %@", data[@"regid"]);
//    }else if ([selector isEqualToString:@"unregisterMiPush"]) {
//        [vMain setRunState:NO];
//    }
//}
//
//- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
//{
//    [vMain printLog:[NSString stringWithFormat:@"command error(%d|%@): %@", error, [self getOperateType:selector], data]];
//}
//
//- (void)miPushReceiveNotification:(NSDictionary*)data
//{
//    // 1.当启动长连接时, 收到消息会回调此处
//    // 2.[MiPushSDK handleReceiveRemoteNotification]
//    //   当使用此方法后会把APNs消息导入到此
//    [vMain printLog:[NSString stringWithFormat:@"XMPP notify: %@", data]];
//}
//
//- (NSString*)getOperateType:(NSString*)selector
//{
//    NSString *ret = nil;
//    if ([selector hasPrefix:@"registerMiPush:"] ) {
//        ret = @"客户端注册设备";
//    }else if ([selector isEqualToString:@"unregisterMiPush"]) {
//        ret = @"客户端设备注销";
//    }else if ([selector isEqualToString:@"registerApp"]) {
//        ret = @"注册App";
//    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
//        ret = @"绑定 PushDeviceToken";
//    }else if ([selector isEqualToString:@"setAlias:"]) {
//        ret = @"客户端设置别名";
//    }else if ([selector isEqualToString:@"unsetAlias:"]) {
//        ret = @"客户端取消别名";
//    }else if ([selector isEqualToString:@"subscribe:"]) {
//        ret = @"客户端设置主题";
//    }else if ([selector isEqualToString:@"unsubscribe:"]) {
//        ret = @"客户端取消主题";
//    }else if ([selector isEqualToString:@"setAccount:"]) {
//        ret = @"客户端设置账号";
//    }else if ([selector isEqualToString:@"unsetAccount:"]) {
//        ret = @"客户端取消账号";
//    }else if ([selector isEqualToString:@"openAppNotify:"]) {
//        ret = @"统计客户端";
//    }else if ([selector isEqualToString:@"getAllAliasAsync"]) {
//        ret = @"获取Alias设置信息";
//    }else if ([selector isEqualToString:@"getAllTopicAsync"]) {
//        ret = @"获取Topic设置信息";
//    }
//    
//    return ret;
//}



//selectDelegate代理方法
- (void)clickEnter
{
  // self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
   // [ADImageHandle setupWithVC:Nav];
//    [self setUpLaunchScreen];
       
    [self loadGifView];

   
    //解决渲染的方法
//    Nav.navigationBar.translucent = NO;
//    [self.window.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:1.0f];
}

#pragma mark - 判断是否加载广告
// 广告
- (void)judgeShowAdsViewRequest{
    
        //    NSString *key = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOiIxNjAwNTAyMTE4IiwibmJmIjoxNjAwNTA yMTE4LCJleHAiOjE2MDExMDY5MTgsImlzcyI6IjEiLCJhdWQiOiIxIn0.Wuf9ka6OE- WEEKqFfAELcN3zCieeHe5otHZTp9w2DLI";
          //  NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.69:1181/System/GetAdConfigList?sv_ad_platform=1"];
          NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetAdConfigList?sv_ad_platform=1"];
  //  URLhead
        //   NSString *strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //解释数据
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                 NSLog(@"dic广告页 = %@",dic);
                if ([dic[@"succeed"] intValue] == 1) {
                    NSDictionary *valuesDic = dic[@"values"];
                    if (!kDictIsEmpty(valuesDic)) {
                        NSDictionary *adConfigDic = valuesDic[@"adConfig"];
                        NSArray *bannersConfig = valuesDic[@"bannersConfig"];
                        if (!kArrayIsEmpty(bannersConfig)) {
                            [SVUserManager shareInstance].bannersConfig = bannersConfig;
                            [SVUserManager saveUserInfo];
                        }
                       // [SVUserManager shareInstance].bannersConfig = sv_ad_canskip;
                        if (!kDictIsEmpty(adConfigDic)) {
                             
                            NSString *imageUrl = adConfigDic[@"sv_ad_smallimg"];
                            
                            NSString *sv_ad_link = adConfigDic[@"sv_ad_link"];
                            
                            NSString *sv_ad_skiptimer = [NSString stringWithFormat:@"%@",adConfigDic[@"sv_ad_skiptimer"]];
                            
                            NSLog(@"sv_ad_skiptimer = %@",sv_ad_skiptimer);
                            [SVUserManager shareInstance].sv_ad_skiptimer = sv_ad_skiptimer;
                            NSString *sv_ad_skipbtn = [NSString stringWithFormat:@"%@",adConfigDic[@"sv_ad_skipbtn"]];
                            
                            NSString *sv_ad_canskip = [NSString stringWithFormat:@"%@",adConfigDic[@"sv_ad_canskip"]];
                            
                            NSString *sv_ad_fordec = [NSString stringWithFormat:@"%@",adConfigDic[@"sv_ad_fordec"]];
                            
                            [SVUserManager shareInstance].sv_ad_skipbtn = sv_ad_skipbtn;
                            [SVUserManager shareInstance].sv_ad_canskip = sv_ad_canskip;
                            
                            [SVUserManager saveUserInfo];
                            NSString *pic = imageUrl;
                            NSString *url = sv_ad_link;
                          //  sv_ad_canskip
                          NSInteger sv_ad_fordecInter = [sv_ad_fordec integerValue];
                            if (sv_ad_fordecInter == 1) {
                                XMADSView *adsView = [XMADSView adsView];
                                 [[UIApplication sharedApplication].keyWindow addSubview:adsView];
                                 _adsView = adsView;
                                
                                _adsView.imgUrl = pic?:@"";
                                _adsView.url = url?:@"";
                            }else{
                                
                                SVLandingVC *mainVC = [[SVLandingVC alloc] init];
                                   UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
                           
                                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                               // SVTabBar *tabbar = [[SVTabBar alloc]init];
                                window.rootViewController = Nav;
                            }
                            
                            
                        }else{
//                            XMADSView *adsView = [XMADSView adsView];
//                             [[UIApplication sharedApplication].keyWindow addSubview:adsView];
//                             _adsView = adsView;
//                            [_adsView dismiss];
//                            SVLandingVC *mainVC = [[SVLandingVC alloc] init];
//                            UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
//                            self.window.rootViewController = Nav;
                            SVLandingVC *mainVC = [[SVLandingVC alloc] init];
                               UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
                       
                            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                           // SVTabBar *tabbar = [[SVTabBar alloc]init];
                            window.rootViewController = Nav;
                        }
                    }
                }else{

                    SVLandingVC *mainVC = [[SVLandingVC alloc] init];
                       UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
               
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                   // SVTabBar *tabbar = [[SVTabBar alloc]init];
                    window.rootViewController = Nav;
                    
                }
               
    
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                SVLandingVC *mainVC = [[SVLandingVC alloc] init];
                   UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
           
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
               // SVTabBar *tabbar = [[SVTabBar alloc]init];
                window.rootViewController = Nav;
            }];
    
}

///**
// 异步下载广告图片
//
// @param imageUrl 图片URL
// @param imageName 图片保存的名字
// @param oldImage 旧图片的名字
// */
//- (void) downloadImageWithUrl:(NSString *)imageUrl
//                    ImageName:(NSString *)imageName
//               DeleteOldImage:(NSString *)oldImage
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        UIImage *image = [UIImage imageWithData:imageData];
//        NSString *filePath = [[self getImageFilePath] stringByAppendingString:imageName];
//        if ([UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES]) {
//            //保存完图片就更新ImageName,并删除旧的图片
//            SMUserDefaultSet(kADImageName, imageName);
//            [self deleteOldImage:oldImage];
//        }
//    });
//
//}
//
//
//
//
///**
// 获取image的存储路径
//
// @return image的存储路径
// */
//- (NSString *) getImageFilePath
//{
//    BOOL isDir;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths lastObject];
//    NSString *directryPath = [path stringByAppendingPathComponent:@"AdImage"];
//
//    if (![kFileManager fileExistsAtPath:directryPath isDirectory:&isDir]) {
//        [kFileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return directryPath;
//}
//
//
//
//- (void) deleteOldImage:(NSString *)oldImage
//{
//    //为空时，跳过此步骤
//    if (oldImage == nil) {
//        return;
//    }
//    [kFileManager removeItemAtPath:[[self getImageFilePath]stringByAppendingString:oldImage] error:nil];
//}
//
//
//
/////**
//// 设置广告页的显示和代理VC
////
//// @param imagePath 加载的广告图片路径
//// @param vc 代理VC
//// */
////+ (void) ADViewShowWithImagePath:(NSString *)imagePath
////                          setDelegateVC:(id )vc
////{
////    ADView *adView = [[ADView alloc] initWithFrame:[UIScreen mainScreen].bounds];
////    adView.adImagePath = imagePath;
////    adView.delegate = vc;
////    [adView show];
////}
//
///**
// 判断图片是否存在
//
// @return yes 存在 no 不存在
// */
//- (BOOL) imageIsExsist
//{
//    if (!SMUserDefaultGet(kADImageName)) {
//        return NO;
//    }
//    BOOL isDir = NO;
//    if ([kFileManager fileExistsAtPath:[[self getImageFilePath] stringByAppendingString:SMUserDefaultGet(kADImageName)] isDirectory:&isDir]){
//        return YES;
//    } else {
//        return NO;
//    }
//}



- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
        
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
}


@end

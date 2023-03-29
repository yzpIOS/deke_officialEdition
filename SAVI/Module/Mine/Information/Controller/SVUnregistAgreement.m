//
//  SVUnregistAgreement.m
//  SAVI
//
//  Created by 杨忠平 on 2022/7/3.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVUnregistAgreement.h"

@interface SVUnregistAgreement ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation SVUnregistAgreement

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"德客协议";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.view.backgroundColor = [UIColor whiteColor];
    //设置类型
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
//    webView.backgroundColor = [UIColor grayColor];
//    webView.scrollView.backgroundColor = [UIColor grayColor];
    //下载文件
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"service" withExtension:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//    NSURLResponse *respnose = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respnose error:NULL];
//
//    [self.webView loadData:data MIMEType:respnose.MIMEType textEncodingName:@"UTF8" baseURL:nil];
     //创建webveiw
    // 获取路径
    if ([self.pathName isEqualToString:@"unregist"]) {
        self.navigationItem.title = @"注销提醒";
    }else{
        self.navigationItem.title = @"隐私条款";
    }
        NSString * path = [[NSBundle mainBundle] pathForResource:self.pathName ofType:@"html"];
        // 创建URL
        NSURL * url = [NSURL fileURLWithPath:path];
        // 创建NSURLRequest
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        // 加载
        [self.webView loadRequest:request];
    

    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"serviceProtol.txt" withExtension:nil];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//
//    [webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    //更改箭头颜色
//    self.navigationController.navigationBar.tintColor = GlobalFontColor;
//    //去掉左边的导航栏的文字
//    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];//ios11前
//    //[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];//ios11 将title 文字的颜色改为透明
//    //适配ios11偏移问题
//    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backltem;
//
//   // self.view.backgroundColor = [UIColor whiteColor];
//    //更改navigation的标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:GlobalFontColor}];
//
//    //更改navigation的背景色
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    //解决渲染的方法
//    //self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//     [self.navigationController.navigationBar setTranslucent:false];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    //设置导航栏透明
//    [self.navigationController.navigationBar setTranslucent:true];
//    //把背景设为空
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //处理导航栏有条线的问题
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

#pragma mark - 懒加载
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight)];
    }
    return _webView;
}
@end

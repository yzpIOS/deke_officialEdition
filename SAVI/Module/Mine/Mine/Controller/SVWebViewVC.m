//
//  SVWebViewVC.m
//  SAVI
//
//  Created by houming Wang on 2018/6/21.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWebViewVC.h"

#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"


@interface SVWebViewVC ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    UIWebView *_webView;
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}

@end

@implementation SVWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.turn == YES) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //允许转成横屏
        appDelegate.allowRotation = YES;
        //调用转屏代码
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    } else {
        
    }
    
    NSLog(@"self.url = %@",self.url);
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight)];
    _webView.backgroundColor = [UIColor whiteColor];
    //设置类型
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview: _webView];
    
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
//    CGRect navBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
    CGRect barFrame = CGRectMake(0,TopHeight,ScreenW,2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self loadBidu];
//    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    [self.view addSubview:_webViewProgressView];
}

-(void)loadBidu{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSLog(@"self.title = %@",self.title);
    
}

//MARK:点击返回按钮（你也可以自定义一个返回按钮）
-(BOOL)navigationShouldPopOnBackButton {
    if (self.turn == YES) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
        //切换到竖屏
        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    } else {
        
    }
    

    return YES;
}

//离开控制器时，调用
//- (void)viewDidDisappear:(BOOL)animated {
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
//    //切换到竖屏
//    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
//
//}




@end

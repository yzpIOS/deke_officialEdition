//
//  SVAboutWeVC.m
//  SAVI
//
//  Created by Sorgle on 2017/7/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVAboutWeVC.h"

@interface SVAboutWeVC ()

@end

@implementation SVAboutWeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"关于我们";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"关于我们";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
}

- (IBAction)buttonResponseEvent {
    
    //点击网页链接调用safari打开指定网页
    NSString *url = @"http://www.decerp.cn";//把http://带上
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}


@end

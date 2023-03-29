//
//  XMNavigationController.m
//  XMFilmTelevision
//
//  Created by sfk-ios on 2018/8/27.
//  Copyright © 2018年 aiq西米. All rights reserved.
//

#import "XMNavigationController.h"
#import "UINavigationBar+Awesome.h"

@interface XMNavigationController ()

@end

@implementation XMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    //    [navBar setBarTintColor:@"#353140".color];
    // 设置导航栏背景色
    //[navBar lt_setBackgroundColor:navigationBackgroundColor];
    navBar.barTintColor = [UIColor whiteColor];
  
    
    navBar.shadowImage = [UIImage new];
    
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: GlobalFontColor};
    navBar.tintColor =  GlobalFontColor;  // 设置返回箭头 < 的颜色,前景色
    //    navBar.translucent = NO;
    //    [navBar setBackgroundImage:[self imageWithColor:UIColorHEX(0x23232B)] forBarMetrics:UIBarMetricsDefault];
    
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = GlobalFontColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置所有光标颜色
    [[UITextField appearance] setTintColor:navigationBackgroundColor];
    [[UITextView appearance] setTintColor:navigationBackgroundColor];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    if (IS_iPhoneX) {
//        [navBar lt_setBackgroundColor:navigationBackgroundColor];
//        navBar.shadowImage = [UIImage new];
//    }
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/// 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target
                                          action:(SEL)action{
//    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
//                                            style:UIBarButtonItemStylePlain
//                                           target:target
//                                           action:action];
    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:target action:action];
}

@end

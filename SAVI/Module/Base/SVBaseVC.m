//
//  SVBaseVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVBaseVC ()
@property(nonatomic, weak)UIImageView*lineView;
@end

@implementation SVBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //更改箭头颜色
    self.navigationController.navigationBar.tintColor = GlobalFontColor;
    //去掉左边的导航栏的文字
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];//ios11前
    //[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];//ios11 将title 文字的颜色改为透明
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
   // self.view.backgroundColor = [UIColor whiteColor];
    //更改navigation的标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:GlobalFontColor}];
    
    //更改navigation的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //解决渲染的方法
    //self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = [UIColor whiteColor];

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
//
    //隐藏默认的返回箭头
//        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
//        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage new];
 
//    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    UIViewController *root = navigationController.viewControllers[0];
//
//    if (root != viewController) {
//        UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction:)];
//        viewController.navigationItem.leftBarButtonItem = itemleft;
//    }
//}


- (void)popAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


//设置导航栏的方法
-(UIViewController *)getViewControllerWithStoryboardName:(NSString *)sbName withStoryboardID:(NSString *)sbId{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:sbId];
}

//此方法可以去掉导航栏的黑线
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
//
//    //self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;
//    
//}

//+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
//    if (!color || size.width <=0 || size.height <=0)
//        return nil;
//    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
//    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


@end

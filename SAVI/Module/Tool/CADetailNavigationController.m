//
//  CADetailNavigationController.m
//  CatcherCoach
//
//  Created by sfk-ios on 2018/7/9.
//  Copyright © 2018年 aiq西米. All rights reserved.
//

#import "CADetailNavigationController.h"
//#import "UINavigationBar+Awesome.h"

@interface CADetailNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CADetailNavigationController


-(BOOL)prefersStatusBarHidden{
    [super prefersStatusBarHidden];
    return NO; //状态栏隐藏  NO显示
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;   //状态栏字体白色 UIStatusBarStyleDefault黑色
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UINavigationBar appearance] setBarTintColor:navigationBackgroundColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    UINavigationBar *navBar = [UINavigationBar appearance];
//
//    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: @"ffffff".color};
//    navBar.tintColor =  @"ffffff".color;  // 设置返回箭头 < 的颜色,前景色
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 控制全屏手势什么时候触发
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
 
    // 限制系统边缘滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate
// 判断下是否接收这个手指,触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 每次触发手势的时候就会调用
    // 判断下当前在不在根控制器
    return self.childViewControllers.count > 1;
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
        //        SFKMainTabBarController *tabBarVc = (SFKMainTabBarController *)self.tabBarController;
        //        tabBarVc.tabBarView.hidden = YES;
        
//        UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
//        backIetm.title = @"";
//        viewController.navigationItem.backBarButtonItem = backIetm;
        
//        // 设置返回按钮标题
//        UIButton *button = [[UIButton alloc] init];
//        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [button setTitle:@"" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        button.bounds = CGRectMake(0, 0, 40, 30);
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        _backBtn = button;
//
//        UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:button];
//       // UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithCustomView:menuBtn];
//
//        //    menuBtn.backgroundColor = [UIColor yellowColor];
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                           target:nil action:nil];
//        negativeSpacer.width = 0;
//        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btn_left,self.navigationItem.backBarButtonItem, nil];
        
        
    }else{
//        // 菜单按钮
//        UIButton *menuBtn = [[UIButton alloc] init];
//        [menuBtn setImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
//        menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [menuBtn setTitle:@"" forState:UIControlStateNormal];
//        [menuBtn addTarget:self.splitViewController action:@selector(toggleMasterVisible:) forControlEvents:UIControlEventTouchUpInside];
//        menuBtn.bounds = CGRectMake(0, 0, 40, 30);
//        menuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuBtn];
//        self.menuBtn = menuBtn;
        
        //        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"哈哈" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end

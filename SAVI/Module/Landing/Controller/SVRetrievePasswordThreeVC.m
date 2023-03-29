//
//  SVRetrievePasswordThreeVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRetrievePasswordThreeVC.h"
#import "SVLandingVC.h"

@interface SVRetrievePasswordThreeVC ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation SVRetrievePasswordThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ScreenH <= 800) {
        self.icon.image = [UIImage imageNamed:@"icon_8p"];

    } else {
        self.icon.image = [UIImage imageNamed:@"icon_proMax"];
        
    }
    //navigation的标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"重置密码";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"重置密码";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenW, 44)];
//    image.image = [UIImage imageNamed:@"register_03"];
//    [self.view addSubview:image];
    
    self.button.layer.cornerRadius = 25;
    
}

- (IBAction)jumpToLanding {
    self.hidesBottomBarWhenPushed = YES;
    SVLandingVC *viewController = [[SVLandingVC alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

//- (void)viewWillAppear:(BOOL)animated{
//    
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar setTranslucent:false];
   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

@end

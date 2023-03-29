//
//  SVNewShopDetailVC.m
//  SAVI
//
//  Created by houming Wang on 2021/2/3.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewShopDetailVC.h"
#import "SVNewShopDetailView.h"

@interface SVNewShopDetailVC ()

@end

@implementation SVNewShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildCotroller];
}

// 添加子控制器
- (void)setupAllChildCotroller {
    UIViewController *temp_1 = [[UIViewController alloc] init];
    temp_1.view.backgroundColor = [UIColor yellowColor];
    temp_1.title = @"关注";
    
    UIViewController *temp_2 = [[UIViewController alloc] init];
    temp_2.view.backgroundColor = [UIColor blueColor];
    temp_2.title = @"关注";
    
    UIViewController *temp_3 = [[UIViewController alloc] init];
    temp_3.view.backgroundColor = [UIColor redColor];
    temp_3.title = @"关注";
    
    [self addChildViewController:temp_1];
    [self addChildViewController:temp_2];
    [self addChildViewController:temp_3];
}

@end

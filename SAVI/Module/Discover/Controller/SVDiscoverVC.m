//
//  SVDiscoverVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVDiscoverVC.h"

@interface SVDiscoverVC ()

@end

@implementation SVDiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//        self.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256)/255.0) green:((float)arc4random_uniform(256)/255.0) blue:((float)arc4random_uniform(256)/255.0) alpha:((float)arc4random_uniform(256)/255.0)];
    self.view.backgroundColor = [UIColor whiteColor];
    //更改navigation的背景色
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    //更改navigation的标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}



@end

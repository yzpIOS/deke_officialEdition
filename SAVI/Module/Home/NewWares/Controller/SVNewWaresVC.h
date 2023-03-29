//
//  SVNewWaresVC.h
//  SAVI
//
//  Created by Sorgle on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoShowViewController.h"
@interface SVNewWaresVC : DemoShowViewController

//保存分类
@property (nonatomic,copy) NSString *waresClass;

@property (nonatomic,copy) void (^addWaresBlock)();

@end

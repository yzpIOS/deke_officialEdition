//
//  SVNewVipVC.h
//  SAVI
//
//  Created by Sorgle on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoShowViewController.h"
@interface SVNewVipVC : DemoShowViewController

@property (nonatomic,copy) void(^addVipBlock)();

@end

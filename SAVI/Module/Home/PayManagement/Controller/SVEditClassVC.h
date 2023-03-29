//
//  SVEditClassVC.h
//  SAVI
//
//  Created by Sorgle on 2017/9/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVEditClassVC : UIViewController

//清空回调的block
@property (nonatomic,copy) void(^editBlock)(NSInteger num);

@end

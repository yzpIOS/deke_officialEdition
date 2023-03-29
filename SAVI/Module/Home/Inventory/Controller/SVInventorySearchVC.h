//
//  SVInventorySearchVC.h
//  SAVI
//
//  Created by houming Wang on 2019/6/5.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYSearchViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVInventorySearchVC : PYSearchViewController
/// 搜索关键字
@property (copy, nonatomic) NSString *searchText;
@end

NS_ASSUME_NONNULL_END

//
//  SVWaresScreeningVC.h
//  SAVI
//
//  Created by Sorgle on 2017/6/2.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVWaresScreeningVC : UITableViewController

/**
 把选择好的二级分类名用block回调到上一个控制器
 */
@property (nonatomic, copy) void(^productsubcategory_idBlock)(NSInteger productsubcategory_id);

@end

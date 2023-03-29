//
//  SVWaresClassVC.h
//  SAVI
//
//  Created by Sorgle on 17/5/8.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SVWaresClassVC : UIViewController

/**
 把选择好的二级分类名用block回调到上一个控制器
 */
@property (nonatomic, copy) void(^nameBlock)(NSString *name,NSString *productcategory_id,NSString *productsubcategory_id,NSString *producttype_id);


@end

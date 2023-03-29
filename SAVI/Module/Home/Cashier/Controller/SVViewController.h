//
//  SVViewController.h
//  SAVI
//
//  Created by houming Wang on 2018/12/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVViewController : UIViewController
@property (nonatomic,assign) NSInteger sumCount;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSString *grade;
@property (nonatomic,copy) void (^arrayBlock)(NSMutableArray *modelArray);

@property (nonatomic,copy) void (^cleanBlock)(NSMutableArray *modelArray);
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;
@end

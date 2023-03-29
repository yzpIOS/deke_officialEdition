//
//  SVInventoryDetailsVC.h
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
@class SVdraftListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVInventoryDetailsVC : UIViewController
@property (nonatomic,strong) SVdraftListModel *model;
@property (nonatomic,assign) NSInteger selectNum; // 1是已完成  2是草稿  3是盘点哪里的已添加商品  4是从搜索过来的
@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,copy) void(^successBlock)();

@property (nonatomic,strong) NSString *sv_storestock_addshop_check_r_no;// 用于区分是已添加商品那里的商品

@end

NS_ASSUME_NONNULL_END

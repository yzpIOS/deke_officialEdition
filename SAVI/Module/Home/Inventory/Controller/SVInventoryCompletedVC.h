//
//  SVInventoryCompletedVC.h
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVSupplierListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVInventoryCompletedVC : UIViewController
@property (nonatomic,assign) NSInteger selectNumber; // 1是选择供应商
@property (nonatomic,copy) void(^selectSuplierBlock)(SVSupplierListModel *model);
@end

NS_ASSUME_NONNULL_END

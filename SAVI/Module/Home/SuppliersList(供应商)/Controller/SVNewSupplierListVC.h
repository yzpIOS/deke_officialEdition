//
//  SVNewSupplierListVC.h
//  SAVI
//
//  Created by houming Wang on 2021/4/12.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVSupplierListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVNewSupplierListVC : UIViewController
@property (nonatomic,assign) NSInteger selectNumber;// 1是选择供应商
@property (nonatomic,copy) void(^selectSuplierBlock)(SVSupplierListModel *model);
@end

NS_ASSUME_NONNULL_END

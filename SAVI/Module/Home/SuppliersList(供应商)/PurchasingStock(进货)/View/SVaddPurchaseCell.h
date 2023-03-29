//
//  SVaddPurchaseCell.h
//  SAVI
//
//  Created by Sorgle on 2018/3/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SVWaresListModel.h"
@class SVduoguigeModel;
@interface SVaddPurchaseCell : UITableViewCell

//给cell标记
@property (nonatomic, strong) NSIndexPath *indexPatch;

@property (nonatomic,strong) SVduoguigeModel *model;

//计算件数的block
@property (nonatomic, copy) void(^caddPurchaseBlock)();

@property (nonatomic,copy) void (^removeAddPurchaseCellBlock)(SVduoguigeModel *model);

@end

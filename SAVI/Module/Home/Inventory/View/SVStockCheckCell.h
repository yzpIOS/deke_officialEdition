//
//  SVStockCheckCell.h
//  SAVI
//
//  Created by Sorgle on 2017/10/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVCheckGoodsModel.h"

@interface SVStockCheckCell : UITableViewCell

//给cell标记
@property (nonatomic, strong) NSIndexPath *indexPatch;
//用模型赋值
@property (nonatomic,strong) SVCheckGoodsModel *goodsModel;

//记录是不是隐藏
@property (nonatomic,assign) BOOL checkCellBool;

@property (nonatomic, copy) void(^inventoryChangeBlock)(SVCheckGoodsModel * model,NSIndexPath *indexPatch);

@end

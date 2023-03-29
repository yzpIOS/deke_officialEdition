//
//  SVRefundGoodsCell.h
//  SAVI
//
//  Created by Sorgle on 2018/3/29.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPurchaseDeteilsModel.h"

@interface SVRefundGoodsCell : UITableViewCell


@property(nonatomic, strong) SVPurchaseDeteilsModel *model;


//block
@property (nonatomic,copy) void (^purchaseDeteilsBlock)();

@property (nonatomic,copy) void (^removeRefundGoodsCellBlock)(SVPurchaseDeteilsModel *model);


@end

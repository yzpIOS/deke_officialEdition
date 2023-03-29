//
//  SVNumberOfCopiesCell.h
//  SAVI
//
//  Created by houming Wang on 2018/9/28.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSelectNumberModel.h"
@interface SVNumberOfCopiesCell : UITableViewCell
@property (nonatomic,strong) SVSelectNumberModel *model;
//计算件数的block
@property (nonatomic, copy) void(^caddPurchaseBlock)();

@property (nonatomic,copy) void (^removeAddPurchaseCellBlock)(SVSelectNumberModel *model);
//@property (nonatomic,copy) void (^severalCopiesCellBlock)(NSInteger num);
@property (nonatomic,copy) void (^severalCopiesCellBlock)(NSInteger num);
@end

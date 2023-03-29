//
//  SVShoppingCardCell.h
//  SAVI
//
//  Created by houming Wang on 2018/12/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCashierSpecModel,SVShoppingCardCell;
@protocol XMGShopCellDelegate <NSObject>

@optional
// 点击加号
- (void)wineCellDidClickPlusButton:(SVShoppingCardCell *)cell;
// 点击减号
- (void)wineCellDidClickMinusButton:(SVShoppingCardCell *)cell;

// 点击textFilrd
- (void)wineCellDidClickTextButton:(SVShoppingCardCell *)cell;
@end
@interface SVShoppingCardCell : UITableViewCell
//NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//@property (nonatomic,strong) SVCashierSpecModel *model;
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,copy) void(^severalCopiesCellBlock)(NSMutableDictionary *dic);
@property (nonatomic,strong) NSString *number;
/** 代理属性 */
@property (nonatomic ,weak)id <XMGShopCellDelegate>delegate;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *grade;

@property (nonatomic,copy) void(^numZeroBlock)();

/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;

@end

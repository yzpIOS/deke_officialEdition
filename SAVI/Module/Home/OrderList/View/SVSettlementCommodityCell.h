//
//  SVSettlementCommodityCell.h
//  SAVI
//
//  Created by F on 2020/10/23.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVOrderDetailsModel.h"
#import "SVVipSelectModdl.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVSettlementCommodityCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *chahaoBtn;

@property (nonatomic,strong) SVVipSelectModdl *model;
@property (nonatomic, strong) SVOrderDetailsModel *orderDetailsModel;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, copy)void (^clearModelBlock)(NSMutableDictionary *dict, NSIndexPath *indexPath);
@property (nonatomic,strong) NSString *grade;
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;
@end

NS_ASSUME_NONNULL_END

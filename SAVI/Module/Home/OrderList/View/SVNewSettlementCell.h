//
//  SVNewSettlementCell.h
//  SAVI
//
//  Created by houming Wang on 2021/5/10.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVOrderDetailsModel.h"
#import "SVExpandBtn.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVNewSettlementCell : UITableViewCell
@property (nonatomic,strong) SVOrderDetailsModel * model;
@property (nonatomic, strong) SVOrderDetailsModel *orderDetailsModel;
@property (nonatomic,strong) NSString *grade;
@property (nonatomic,assign) NSInteger selectNumber;
@property (nonatomic,strong) NSMutableArray * modelArray;
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;

@property (weak, nonatomic) IBOutlet SVExpandBtn *clearBtn;

@property (nonatomic,strong) SVProductResultslList *productResultslList;
@end

NS_ASSUME_NONNULL_END

//
//  SVDetailsHistoryCell.h
//  SAVI
//
//  Created by Sorgle on 2017/6/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVDetailsHistoryModel.h"


@interface SVDetailsHistoryCell : UITableViewCell

@property (nonatomic,strong) SVDetailsHistoryModel *detalisHistoryModel;

@property (nonatomic,assign) NSInteger cardno;
//商品名
@property (weak, nonatomic) IBOutlet UILabel *waresName;
//原单价
@property (weak, nonatomic) IBOutlet UILabel *money;
//件数
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSString * sv_mr_name;
@property (nonatomic,strong)SVSalesDetailsList *salesDetailsListModel;
@end

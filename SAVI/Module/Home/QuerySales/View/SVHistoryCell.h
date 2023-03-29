//
//  SVHistoryCell.h
//  SAVI
//
//  Created by Sorgle on 2017/6/8.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVHistoryModel.h"

@interface SVHistoryCell : UITableViewCell

@property (nonatomic, strong) SVHistoryModel *historyModel;

@property (weak, nonatomic) IBOutlet UILabel *pay;

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *more;
//判断是否有退货
@property (weak, nonatomic) IBOutlet UILabel *returnWares;


@property (weak, nonatomic) IBOutlet UILabel *unitprice;


@end

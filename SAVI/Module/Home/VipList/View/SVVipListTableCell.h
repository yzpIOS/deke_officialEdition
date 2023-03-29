//
//  SVVipListTableCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVVipListModel.h"

@interface SVVipListTableCell : UITableViewCell

/**
 模型
 */
@property (nonatomic, strong) SVVipListModel *model;
@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, copy) void(^model_block)(SVVipListModel *model,NSIndexPath * index);

@end

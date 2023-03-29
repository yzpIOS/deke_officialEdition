//
//  SVMultiSelectCell.h
//  SAVI
//
//  Created by houming Wang on 2018/7/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVVipListModel.h"

@interface SVMultiSelectCell : UITableViewCell

@property (nonatomic, strong) SVVipListModel *model;
@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, copy) void(^model_block)(SVVipListModel *model,NSIndexPath * index);

@end

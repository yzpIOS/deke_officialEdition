//
//  SVMoreSpecificationsCell.h
//  SAVI
//
//  Created by houming Wang on 2019/4/13.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVWaresListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVMoreSpecificationsCell : UITableViewCell
@property (nonatomic,strong) SVWaresListModel *model;
@property (nonatomic,copy) void(^addBlock)();
@property (nonatomic,copy) void(^reduceBlock)();
@property (nonatomic,copy) void(^textBlock)(NSString *number);
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, copy) void(^model_block)(SVWaresListModel *model,NSIndexPath * index);
@end

NS_ASSUME_NONNULL_END

//
//  SVCompletedCell.h
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVdraftListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVCompletedCell : UITableViewCell
@property (nonatomic,strong) SVdraftListModel *model;
@end

NS_ASSUME_NONNULL_END

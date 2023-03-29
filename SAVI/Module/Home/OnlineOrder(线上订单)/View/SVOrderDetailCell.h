//
//  SVOrderDetailCell.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVOrderProductListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVOrderDetailCell : UITableViewCell
@property (nonatomic,strong) SVOrderProductListModel *model;

@property (nonatomic,strong) NSDictionary *dict;
@end

NS_ASSUME_NONNULL_END

//
//  SVIntelligentDetailCell.h
//  SAVI
//
//  Created by houming Wang on 2019/9/18.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SVShopOverviewModel;
@class SVStoreCategaryModel;
@interface SVIntelligentDetailCell : UITableViewCell
@property (nonatomic,strong) SVShopOverviewModel *model;

@property (nonatomic,strong) SVShopOverviewModel *memberModel;

@property (nonatomic,strong) SVStoreCategaryModel *categaryModel;
@end

NS_ASSUME_NONNULL_END

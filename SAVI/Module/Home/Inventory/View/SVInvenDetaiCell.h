//
//  SVInvenDetaiCell.h
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVPandianDetailModel;
@class SVduoguigeModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVInvenDetaiCell : UITableViewCell
@property (nonatomic,strong) SVPandianDetailModel *model;
@property (nonatomic,strong) SVduoguigeModel *duoguigeModel;
@end

NS_ASSUME_NONNULL_END

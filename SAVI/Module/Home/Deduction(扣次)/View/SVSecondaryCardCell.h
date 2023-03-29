//
//  SVSecondaryCardCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/10/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCardRechargeInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVSecondaryCardCell : UITableViewCell
@property (nonatomic,strong) SVCardRechargeInfoModel *model;
@property (nonatomic,assign) NSInteger selectVC;
@property (weak, nonatomic) IBOutlet UIButton *chongBtn;

@property (nonatomic, copy)void(^model_block)(SVCardRechargeInfoModel *model);
@end

NS_ASSUME_NONNULL_END

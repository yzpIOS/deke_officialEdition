//
//  SVConsumptionFrequencyView.h
//  SAVI
//
//  Created by 杨忠平 on 2020/2/18.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVConsumptionFrequencyView : UIView
//支出类名
@property (nonatomic, strong) UILabel *namelabel;
//颜色view
@property (nonatomic, strong) UIView *colorView;
//金额
@property (nonatomic, strong) UILabel *moneylabel;
//排行数
@property (nonatomic, strong) UILabel *taglabel;
@end

NS_ASSUME_NONNULL_END

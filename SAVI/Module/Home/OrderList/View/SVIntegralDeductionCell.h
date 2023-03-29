//
//  SVIntegralDeductionCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/12.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVIntegralDeductionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UIView *integralView;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@end

NS_ASSUME_NONNULL_END

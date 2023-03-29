//
//  SVSpendingDetailView.h
//  SAVI
//
//  Created by Sorgle on 2017/9/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSpendingDetailView : UIView

//颜色view
@property (nonatomic, strong) UIView *colorView;
//支出类名
@property (nonatomic, strong) UILabel *payClasslabel;
//比率
@property (nonatomic, strong) UILabel *ratiolabel;
//金额
@property (nonatomic, strong) UILabel *moneylabel;



@end

//
//  SVPayView.h
//  SAVI
//
//  Created by Sorgle on 2017/12/11.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVPayView : UIView

//颜色view
@property (nonatomic, strong) UIView *colorView;
//支出类名
@property (nonatomic, strong) UILabel *paylabel;
//金额
@property (nonatomic, strong) UILabel *moneylabel;
//元/笔
@property (nonatomic, strong) UILabel *yuanlabel;

@end

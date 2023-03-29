//
//  SVRankingsView.h
//  SAVI
//
//  Created by Sorgle on 2017/12/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVRankingsView : UIView

//支出类名
@property (nonatomic, strong) UILabel *namelabel;
//颜色view
@property (nonatomic, strong) UIView *colorView;
//金额
@property (nonatomic, strong) UILabel *moneylabel;
//排行数
@property (nonatomic, strong) UILabel *taglabel;

@end

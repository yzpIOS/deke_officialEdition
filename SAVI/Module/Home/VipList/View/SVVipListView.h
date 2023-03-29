//
//  SVVipListView.h
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVVipListView : UIView
//@property (weak, nonatomic) IBOutlet UIButton *message;
//选择全部会员列表
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
//扫一扫
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

//搜索关键词
@property (weak, nonatomic) IBOutlet UISearchBar *searchWares;

//总会员
@property (weak, nonatomic) IBOutlet UILabel *sumVip;

@end

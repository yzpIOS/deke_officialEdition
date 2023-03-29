//
//  SVSeeWaresView.h
//  SAVI
//
//  Created by houming Wang on 2018/6/6.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSeeWaresView : UIView
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UIButton *cancelB;
@property (weak, nonatomic) IBOutlet UIButton *removeB;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic,strong) NSString *grade;

/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;

@property (nonatomic, copy)void(^dictArrBlock)(NSMutableArray *dictArray);

@end

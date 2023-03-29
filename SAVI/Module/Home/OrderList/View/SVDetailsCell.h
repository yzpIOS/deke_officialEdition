//
//  SVDetailsCell.h
//  SAVI
//
//  Created by Sorgle on 17/5/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVOrderDetailsModel.h"
#import "SVVipSelectModdl.h"
@interface SVDetailsCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *chahaoBtn;

@property (nonatomic,strong) SVVipSelectModdl *model;
@property (nonatomic, strong) SVOrderDetailsModel *orderDetailsModel;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, copy)void (^clearModelBlock)(NSMutableDictionary *dict, NSIndexPath *indexPath);

@property (nonatomic,strong) NSString *grade;
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;

@end

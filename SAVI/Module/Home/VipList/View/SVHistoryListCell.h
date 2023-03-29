//
//  SVHistoryListCell.h
//  SAVI
//
//  Created by Sorgle on 2018/2/10.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVHistoryListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *pay;

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *more;
//判断是否有退货
@property (weak, nonatomic) IBOutlet UILabel *returnWares;

//金额
@property (weak, nonatomic) IBOutlet UILabel *unitprice;
/**
 消费店铺
 */
@property (weak, nonatomic) IBOutlet UILabel *ConsumerShop;

@end

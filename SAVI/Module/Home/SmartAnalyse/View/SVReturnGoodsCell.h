//
//  SVReturnGoodsCell.h
//  SAVI
//
//  Created by houming Wang on 2018/11/2.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCustormPaymentModel;
@interface SVReturnGoodsCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *nameL;
//@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (nonatomic,strong) SVCustormPaymentModel *model;
@end

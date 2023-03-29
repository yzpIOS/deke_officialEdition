//
//  SVPurchaseDeteilsCell.h
//  SAVI
//
//  Created by Sorgle on 2017/12/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPurchaseDeteilsModel.h"

@interface SVPurchaseDeteilsCell : UITableViewCell

@property(nonatomic, strong) SVPurchaseDeteilsModel *model;

//@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIView *numButtonView;

//block
@property (nonatomic,copy) void (^purchaseDeteilsBlock)();

@end

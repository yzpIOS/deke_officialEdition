//
//  SVPortfolioPaymentView.h
//  SAVI
//
//  Created by houming Wang on 2021/3/23.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVOrderDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVPortfolioPaymentView : UIView
@property (nonatomic, strong) SVOrderDetailsModel *orderDetailsModel;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *tuichu;

@property (nonatomic,strong) NSMutableDictionary *dict;

@property (nonatomic,strong) NSString * TotleMoney;

@property (nonatomic, copy)void(^orderDetailsModelBlock)(NSDictionary *dict);
@property (nonatomic,copy) void (^selectMoney)(NSString *money);

@property (nonatomic, copy)void(^clearBlock)();
@property (nonatomic,strong) NSString * title;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@end

NS_ASSUME_NONNULL_END

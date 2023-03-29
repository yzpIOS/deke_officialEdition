//
//  SVDiscountAndNumberView.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/24.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVOrderDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDiscountAndNumberView : UIView

@property (nonatomic, strong) SVOrderDetailsModel *orderDetailsModel;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *tuichu;

@property (nonatomic,strong) NSMutableDictionary *dict;

@property (nonatomic,assign) double huankuanMoney;

//@property (nonatomic, copy)void(^orderDetailsModelBlock)(SVOrderDetailsModel *orderDetailsModel);

@property (nonatomic, copy)void(^orderDetailsModelBlock)(NSDictionary *dict);

@property (nonatomic, copy)void(^clearBlock)();

@property (nonatomic,assign) BOOL isHiddenDecimalPoint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 供应商
 */
@property (nonatomic,copy) void (^moneyBlock)(NSString *money);

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property(retain,nonatomic) NSMutableString *string;
@property (nonatomic,copy) void (^chuqiBlock)(NSString *money);
@property (nonatomic,copy) void (^integralBlock)(NSString *integral);
@end

NS_ASSUME_NONNULL_END

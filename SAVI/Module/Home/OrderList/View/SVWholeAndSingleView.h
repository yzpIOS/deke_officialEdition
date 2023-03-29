//
//  SVWholeAndSingleView.h
//  SAVI
//
//  Created by houming Wang on 2021/5/12.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVduoguigeModel;
@class SVOrderDetailsModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVWholeAndSingleView : UIView
@property (nonatomic,strong) SVOrderDetailsModel * orderDetailsModel;
@property (weak, nonatomic) IBOutlet UIButton *btn_7;
@property (weak, nonatomic) IBOutlet UIButton *btn_8;
@property (weak, nonatomic) IBOutlet UIButton *btn_9;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;
@property (weak, nonatomic) IBOutlet UIButton *btn_5;
@property (weak, nonatomic) IBOutlet UIButton *btn_6;
@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_circle;
@property (weak, nonatomic) IBOutlet UIButton *btn_0;
@property (weak, nonatomic) IBOutlet UIButton *btn_clear_0;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *yuanjia;
//@property (nonatomic,strong) SVduoguigeModel *model;
@property (nonatomic,strong) NSMutableDictionary *dict;
/**
 传进来的总金额
 */
@property (nonatomic,strong) NSString * totleMoney;

@property (nonatomic,copy) void(^sureBtnClickBlock_dict)(NSInteger selctCount, NSMutableDictionary *dict);
// 区别单品优惠还是整单优惠字段 1是整单 其他是单品
@property (nonatomic,assign) NSInteger zhengdanOrdanpin;
//@property (nonatomic,copy) void(^sureBtnClickBlock_model)(SVOrderDetailsModel * orderDetailsModelTwo);

@property (nonatomic,copy) void(^determineBlock)(NSMutableDictionary * dict);

@property (weak, nonatomic) IBOutlet UIButton *tuichu;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,copy) void (^WholeOrderDiscountBlock)(double discount);
@property (nonatomic,copy) void (^WholeOrderMoneyBlock)(double money);

@end

NS_ASSUME_NONNULL_END

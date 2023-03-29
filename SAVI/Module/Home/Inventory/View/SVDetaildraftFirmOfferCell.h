//
//  SVDetaildraftFirmOfferCell.h
//  SAVI
//
//  Created by houming Wang on 2019/6/13.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVduoguigeModel;
@class SVPandianDetailModel;
@class SVOrderDetailsModel;
NS_ASSUME_NONNULL_BEGIN
//#import "SVduoguigeModel.h"
@interface SVDetaildraftFirmOfferCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *shipanView;
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
@property (nonatomic,copy) void(^sureBtnClickBlock)(NSInteger selctCount, SVduoguigeModel *model_two);
@property (nonatomic,copy) void(^sureBtnClickBlock_two)(NSInteger selctCount, SVPandianDetailModel *model_two);

@property (nonatomic,copy) void(^sureBtnClickBlock_model_order)(NSInteger selctCount, SVOrderDetailsModel *model_order);

@property (nonatomic,copy) void(^sureBtnClickBlock_dict)(NSInteger selctCount, NSMutableDictionary *dict);

@property (nonatomic,strong) SVduoguigeModel *model;
@property (nonatomic,strong) SVPandianDetailModel *model_two;

@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) SVOrderDetailsModel *model_order;
@property(retain,nonatomic) NSMutableString *string;  //NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@end

NS_ASSUME_NONNULL_END

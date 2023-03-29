//
//  SVServiceProjectCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/21.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVduoguigeModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVServiceProjectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
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

@property (nonatomic,strong) SVduoguigeModel *model;

@property (nonatomic,copy) void(^sureBtnClickBlock)(NSInteger selctCount, SVduoguigeModel *model);
@end

NS_ASSUME_NONNULL_END

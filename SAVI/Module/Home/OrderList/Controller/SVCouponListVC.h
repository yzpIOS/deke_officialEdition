//
//  SVCouponListVC.h
//  SAVI
//
//  Created by houming Wang on 2019/8/23.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCouponListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVCouponListVC : UIViewController
//会员ID self.twoCell.threeTextField.text
@property (nonatomic,copy) NSString *member_id;

@property (nonatomic,strong) NSString *totle_money;

@property (nonatomic,strong) SVCouponListModel *model;
@property (assign, nonatomic) NSIndexPath       *selIndex;      //单选选中的行
@property (nonatomic,copy) void(^couponBlock)(SVCouponListModel *model, NSIndexPath *selectIndex);
@end

NS_ASSUME_NONNULL_END

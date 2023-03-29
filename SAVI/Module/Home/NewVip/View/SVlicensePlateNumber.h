//
//  SVlicensePlateNumber.h
//  SAVI
//
//  Created by houming Wang on 2020/12/4.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVlicensePlateNumber : UITableViewCell
/**
 等级按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *levelView;

/**
 性别选择
 */
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIView *genderView;

/**
 日期选择
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;

//手机号码
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
//地址
@property (weak, nonatomic) IBOutlet UITextField *address;
/**
 车牌号
 */
@property (weak, nonatomic) IBOutlet UIView *LicensePlateView;

//@property (weak, nonatomic) IBOutlet UIView *LicensePlateBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *birthdayTopHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LicensePlateHeight;
//@property (weak, nonatomic) IBOutlet UIView *LicensePlateBottomHeight;
@property (weak, nonatomic) IBOutlet UIView *chengweiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chengweiHeight;

@property (weak, nonatomic) IBOutlet UITextField *sv_mr_platenumberText;
@end

NS_ASSUME_NONNULL_END

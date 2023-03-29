//
//  SVNewVipTwoCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SVNewVipTwoCell : UITableViewCell


/**
 等级按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *levelView;

/**
称谓
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

//+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
//                            index:(NSInteger )index;
@end

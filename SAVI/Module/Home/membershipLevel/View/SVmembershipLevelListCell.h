//
//  SVmembershipLevelListCell.h
//  SAVI
//
//  Created by 杨忠平 on 2022/7/23.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVmembershipLevelListCell : UITableViewCell
@property(nonatomic,strong)UIView* baseView;
@property(nonatomic,strong)UIImageView* img;
@property(nonatomic,strong)UILabel* nameLbl;
@property(nonatomic,strong)UILabel* peopleNumLbl;
@property(nonatomic,strong)UILabel* menberDicountLbl;
@property(nonatomic,strong)UILabel* integralRangeLbl;

@property(nonatomic,strong)SVMembershipLevelList* data;
@end

NS_ASSUME_NONNULL_END

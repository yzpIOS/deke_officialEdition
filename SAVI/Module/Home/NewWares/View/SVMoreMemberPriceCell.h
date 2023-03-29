//
//  SVMoreMemberPriceCell.h
//  SAVI
//
//  Created by houming Wang on 2020/12/11.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMoreMemberPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *MinimumDiscount;
@property (weak, nonatomic) IBOutlet UITextField *MinimumPrice;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice1;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice2;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice3;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice4;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice5;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *viewBottom1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view2Bottom;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view3Bottom;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view4Bottom;
@property (weak, nonatomic) IBOutlet UIView *view5;

@end

NS_ASSUME_NONNULL_END

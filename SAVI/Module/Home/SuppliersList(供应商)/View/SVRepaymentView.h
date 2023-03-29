//
//  SVRepaymentView.h
//  SAVI
//
//  Created by houming Wang on 2021/5/24.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVRepaymentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *SettlementNo;
@property (weak, nonatomic) IBOutlet UILabel *ArrearsDue;
@property (weak, nonatomic) IBOutlet UILabel *repaymentMoney;
@property (weak, nonatomic) IBOutlet UIView *repaymentView;
@property (weak, nonatomic) IBOutlet UITextView *beizhuTextView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

NS_ASSUME_NONNULL_END

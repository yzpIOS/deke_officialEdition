//
//  SVPromptRenewalView.h
//  SAVI
//
//  Created by F on 2020/8/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPromptRenewalView : UIView
@property (weak, nonatomic) IBOutlet UIButton *renewBtn;
@property (weak, nonatomic) IBOutlet UILabel *renewLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

NS_ASSUME_NONNULL_END

//
//  SVIntelligentDetailView.h
//  SAVI
//
//  Created by houming Wang on 2019/9/18.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVIntelligentDetailView : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_height_constens;
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;
@property (weak, nonatomic) IBOutlet UILabel *discountVolume;
@property (weak, nonatomic) IBOutlet UILabel *strokeNumber;

@end

NS_ASSUME_NONNULL_END

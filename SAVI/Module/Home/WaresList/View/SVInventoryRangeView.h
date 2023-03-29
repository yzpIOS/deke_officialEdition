//
//  SVInventoryRangeView.h
//  SAVI
//
//  Created by houming Wang on 2021/1/29.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVInventoryRangeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *tuichu;
@property (nonatomic,copy) void (^stockBlock)(NSInteger oneNumber, NSInteger twoNumber);
@end

NS_ASSUME_NONNULL_END

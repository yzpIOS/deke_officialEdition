//
//  SVExtendTimeView.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/7.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVExtendTimeView : UIView
@property (nonatomic,strong) NSString *timeStr;

@property (nonatomic, copy)void(^cleanBlock)();
@property (nonatomic, copy)void(^sureBlock)(NSString *validity_date);

@end

NS_ASSUME_NONNULL_END

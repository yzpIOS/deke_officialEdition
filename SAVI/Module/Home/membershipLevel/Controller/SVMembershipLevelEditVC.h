//
//  SVMembershipLevelEditVC.h
//  SAVI
//
//  Created by 杨忠平 on 2022/7/24.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMembershipLevelEditVC : UIViewController
@property (nonatomic,copy) void (^suessBlock)();
@property (nonatomic,strong) SVMembershipLevelList *model;


@end

NS_ASSUME_NONNULL_END

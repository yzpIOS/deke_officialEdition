//
//  SVOnlineOrderDetailVC.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/18.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVOnlineOrderDetailVC : UIViewController
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSDictionary *detailDict;


@end

NS_ASSUME_NONNULL_END

//
//  SVBluetoothListVC.h
//  SAVI
//
//  Created by houming Wang on 2019/4/19.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnecterManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVBluetoothListVC : UIViewController
@property(nonatomic,copy)ConnectDeviceState state;

@property (nonatomic,copy) void(^nameBlock)(NSString *name);
@end

NS_ASSUME_NONNULL_END

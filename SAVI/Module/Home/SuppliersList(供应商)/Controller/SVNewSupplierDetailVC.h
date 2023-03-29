//
//  SVNewSupplierDetailVC.h
//  SAVI
//
//  Created by houming Wang on 2021/4/13.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVNewSupplierDetailVC : UIViewController
@property (nonatomic,strong) NSString * sv_suid;
@property (nonatomic,copy) void (^EditSupplierBlock)();
@end

NS_ASSUME_NONNULL_END

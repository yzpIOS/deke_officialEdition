//
//  SVAddMoreColorVC.h
//  SAVI
//
//  Created by houming Wang on 2019/3/20.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SVDetailAttrilistModel.h"
@class SVDetailAttrilistModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVAddMoreColorVC : UIViewController
@property (nonatomic,copy)void (^colorBlock)(NSString *colorStr);
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,copy) void(^detailAttrilistModelBlock)(SVDetailAttrilistModel *model);
@end

NS_ASSUME_NONNULL_END

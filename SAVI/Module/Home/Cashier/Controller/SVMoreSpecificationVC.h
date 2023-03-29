//
//  SVMoreSpecificationVC.h
//  SAVI
//
//  Created by houming Wang on 2018/12/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSelectedGoodsModel.h"
@class SVNumBlockModel;
@interface SVMoreSpecificationVC : UIViewController
@property (nonatomic,strong) NSString *productID;
@property (nonatomic,strong) NSString *sv_p_name;
@property (nonatomic,strong) NSString *sv_p_images2;

@property (nonatomic,copy) void (^numBlock)(SVSelectedGoodsModel *model);
@end

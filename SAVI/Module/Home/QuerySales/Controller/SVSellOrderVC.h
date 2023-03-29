//
//  SVSellOrderVC.h
//  SAVI
//
//  Created by Sorgle on 2017/6/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSellOrderVC : UIViewController


//带过来的是字典
@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,copy) void (^sellOrderBlock)();

@end

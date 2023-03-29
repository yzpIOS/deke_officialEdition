//
//  SVEditShopView.h
//  SAVI
//
//  Created by houming Wang on 2021/5/12.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVOrderDetailsModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVEditShopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *tuichu;
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (nonatomic,strong) SVOrderDetailsModel * orderDetailsModel;
@property (nonatomic,strong) NSString *grade;
@property (nonatomic,strong) NSMutableDictionary * dict;
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;
@property (nonatomic,copy) void (^editShopBlock)();
@end

NS_ASSUME_NONNULL_END

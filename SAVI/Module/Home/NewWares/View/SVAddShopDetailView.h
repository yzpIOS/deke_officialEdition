//
//  SVAddShopDetailView.h
//  SAVI
//
//  Created by houming Wang on 2021/2/20.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAddShopDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancle;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleDetail;

@property (nonatomic,strong) NSArray * listArray;

@property (nonatomic,copy) void (^mianliaoBlock)();
@property (nonatomic,copy) void (^Sv_Brand_LibBlock)();
@property (nonatomic,copy) void (^GenderListBlock)();
@property (nonatomic,copy) void (^SeasonlListBlock)();
@property (nonatomic,copy) void (^StyleListBlock)();
@property (nonatomic,copy) void (^StandardListBlock)();
@property (nonatomic,copy) void (^companyBlock)();
@property (nonatomic,copy) void (^ExecutiveStandardBlock)();
//@property (nonatomic,copy) void (^mianliaoBlock)();
//@property (nonatomic,copy) void (^mianliaoBlock)();

@property (nonatomic,copy) void (^mianliaoBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^Sv_Brand_LibBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^GenderListBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^SeasonlListBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^StyleListBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^StandardListBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^CommodityYearBlock2)(NSString *year);
@property (nonatomic,copy) void (^companyBlock2)(NSDictionary *dict);
@property (nonatomic,copy) void (^ExecutiveStandardBlock2)(NSDictionary *dict);
@end

NS_ASSUME_NONNULL_END

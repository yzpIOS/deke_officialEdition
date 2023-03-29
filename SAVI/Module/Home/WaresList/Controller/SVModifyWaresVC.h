//
//  SVModifyWaresVC.h
//  SAVI
//
//  Created by Sorgle on 2017/6/3.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoShowViewController.h"
@interface SVModifyWaresVC : DemoShowViewController

//全局属性
//图片路径
@property (nonatomic,copy) NSString *imgURL;
//产品ID
@property (nonatomic,copy) NSString *product_id;

//款号
@property (nonatomic,copy) NSString *barcode;
//商品名称
@property (nonatomic,copy) NSString *waresName;
//分类
@property (nonatomic,copy) NSString *classification;

@property (nonatomic, assign) NSInteger productcategory_id;
@property (nonatomic, assign) NSInteger productsubcategory_id;
@property (nonatomic, assign) NSInteger producttype_id;

//售价
@property (nonatomic,copy) NSString *price;
//进价
@property (nonatomic,copy) NSString *purchaseprice;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice;
//库存
@property (nonatomic,copy) NSString *inventory;
//规格
@property (nonatomic,copy) NSString *specifications;

//单位
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,strong) NSString *sv_pricing_method;
//block
@property (nonatomic,copy) void (^ModifyWaresBlock)();

@property (nonatomic,strong) NSString * sv_p_memberprice1;
@property (nonatomic,strong) NSString * sv_p_memberprice2;
@property (nonatomic,strong) NSString * sv_p_memberprice3;
@property (nonatomic,strong) NSString * sv_p_memberprice4;
@property (nonatomic,strong) NSString * sv_p_memberprice5;

@property (nonatomic,strong) NSString * sv_p_tradeprice1;
@property (nonatomic,strong) NSString * sv_p_tradeprice2;
@property (nonatomic,strong) NSString * sv_p_tradeprice3;
@property (nonatomic,strong) NSString * sv_p_tradeprice4;
@property (nonatomic,strong) NSString * sv_p_tradeprice5;

@property (nonatomic,strong) NSString * sv_mnemonic_code;
@property (nonatomic,strong) NSString * sv_p_artno;
@property (nonatomic,strong) NSString * sv_p_minunitprice;
@property (nonatomic,strong) NSString * sv_p_mindiscount;
@property (nonatomic,strong) NSString * sv_guaranteeperiod;
@end

//
//  SVAddMoreSpecificationsVC.h
//  SAVI
//
//  Created by houming Wang on 2019/3/18.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DemoShowViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVAddMoreSpecificationsVC : UIViewController
/**
 *  展示原图的IMGV
 */
@property(nonatomic,strong)UIImageView *OldIMGV;
//@property (nonatomic,strong) <#type#> *<#name#>;
/**
 *  展示新图的IMGV
 */
@property(nonatomic,strong)UIImageView *NewIMGV;

/**
 *  原图，此原图挺大的
 */
@property(nonatomic,strong)UIImage *oldIMG;


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

@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *sizeTwoArray;
@property (nonatomic,strong) NSMutableArray *duoguigeArray;
@property (nonatomic,strong) NSMutableArray *firstColorArray;
@property (nonatomic,strong) NSString *attri_group;
@property (nonatomic,strong) NSMutableArray *firstSizeArray;
@property (nonatomic,strong) NSMutableArray *sizeStrArray;
@property (nonatomic,strong) NSMutableArray *allColorArray;
@property (nonatomic,strong) NSMutableArray *diffcultFirstColorArray;
@property (nonatomic,strong) NSString *sv_pricing_method;
@property (nonatomic,strong) NSMutableArray *mabiArr;
//单位
@property (nonatomic,copy) NSString *unit;

/**
 标记是编辑过来的  1是编辑过来的
 */
@property (nonatomic,assign) NSInteger editInterface;

@property (nonatomic,strong) NSString * Commission;
// 提成
@property (weak, nonatomic) IBOutlet UILabel *CommissionLabel;
// 选择商品品牌
@property (weak, nonatomic) IBOutlet UILabel *CommodityBrandLabel;
// 选择面料
@property (weak, nonatomic) IBOutlet UILabel *FabricLabel;
// 选择性别信息
@property (weak, nonatomic) IBOutlet UILabel *GenderLabel;
// 选择商品年份
@property (weak, nonatomic) IBOutlet UILabel *CommodityYearLabel;
// 选择商品季节
@property (weak, nonatomic) IBOutlet UILabel *CommoditySeasonLabel;
// 选择款式信息
@property (weak, nonatomic) IBOutlet UILabel *StyleInformationLabel;
// 选择安全标准
@property (weak, nonatomic) IBOutlet UILabel *safetyStandardsLabel;


@property (weak, nonatomic) IBOutlet UITextField *sv_product_integral;
@property (weak, nonatomic) IBOutlet UITextField *sv_p_commissionratio;

@property (nonatomic,strong) NSString * product_integral; // 积分
@property (nonatomic,strong) NSString * commissionratio; // 提成

//@property (nonatomic,strong) NSString * Commission;
@property (nonatomic,strong) NSString * CommodityBrand;
@property (nonatomic,strong) NSString * Fabric;
@property (nonatomic,strong) NSString * Gender;
@property (nonatomic,strong) NSString * CommodityYear;
@property (nonatomic,strong) NSString * CommoditySeason;
@property (nonatomic,strong) NSString * StyleInformation;
@property (nonatomic,strong) NSString * safetyStandards;
@property (nonatomic,strong) NSString * companyStr;
@property (nonatomic,strong) NSString * sv_executivestandard;

@property (nonatomic,strong) NSString * sv_product_standard_id;
@property (nonatomic,strong) NSString * sv_product_fabric_id;
@property (nonatomic,strong) NSString * sv_product_gender_id;
@property (nonatomic,strong) NSString * sv_product_season_id;
@property (nonatomic,strong) NSString * sv_product_style_id;
@property (nonatomic,strong) NSString * sv_brand_id;
@property (nonatomic,strong) NSString * company_id;
@property (nonatomic,strong) NSString * sv_suid;
@property (nonatomic,strong) NSString * sv_unit_name;// 单位
@property (nonatomic,strong) NSString * sv_executivestandard_id;
// 供应商名称
@property (nonatomic,strong) NSString * sv_suname;


@property (weak, nonatomic) IBOutlet UITextField *sv_p_storageText;

// 价格的textFiled
@property (weak, nonatomic) IBOutlet UITextField *DeliveryPrice;

@property (weak, nonatomic) IBOutlet UITextField *minimumPrice;
@property (weak, nonatomic) IBOutlet UITextField *MinimumDiscount;
@property (weak, nonatomic) IBOutlet UITextField *memberPrice;
@property (weak, nonatomic) IBOutlet UITextField *memberPrice1;
@property (weak, nonatomic) IBOutlet UITextField *memberPrice2;
@property (weak, nonatomic) IBOutlet UITextField *memberPrice3;
@property (weak, nonatomic) IBOutlet UITextField *memberPrice4;
@property (weak, nonatomic) IBOutlet UITextField *memberPrice5;

@property (nonatomic,strong) NSString * DeliveryPriceStr;
@property (nonatomic,strong) NSString * minimumPriceStr;
@property (nonatomic,strong) NSString * MinimumDiscountStr;
@property (nonatomic,strong) NSString * memberPriceStr;
@property (nonatomic,strong) NSString * memberPrice1Str;
@property (nonatomic,strong) NSString * memberPrice2Str;
@property (nonatomic,strong) NSString * memberPrice3Str;
@property (nonatomic,strong) NSString * memberPrice4Str;
@property (nonatomic,strong) NSString * memberPrice5Str;

@property (nonatomic,strong) NSString * tradePriceStr;
@property (nonatomic,strong) NSString * tradePrice1Str;
@property (nonatomic,strong) NSString * tradePrice2Str;
@property (nonatomic,strong) NSString * tradePrice3Str;
@property (nonatomic,strong) NSString * tradePrice4Str;

@property (nonatomic,strong) NSString * sv_p_remark;

@property (weak, nonatomic) IBOutlet UITextField *tradePrice;
@property (weak, nonatomic) IBOutlet UITextField *tradePrice1;
@property (weak, nonatomic) IBOutlet UITextField *tradePrice2;
@property (weak, nonatomic) IBOutlet UITextField *tradePrice3;
@property (weak, nonatomic) IBOutlet UITextField *tradePrice4;
@property (nonatomic,strong) NSArray * imageArray;

@property (nonatomic,copy) void (^editSuccessBlock)();
@property (nonatomic,copy) void (^addSuccessBlock)();

@end

NS_ASSUME_NONNULL_END

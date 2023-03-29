//
//  SVUserManager.h
//  SAVI
//
//  Created by Sorgle on 17/5/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVUserManager : NSObject<NSCoding>
/**
 账号
 */
@property (nonatomic, copy) NSString *account;
//
///**
// 用户密码
// */
@property (nonatomic, copy) NSString *passwd;
//
@property (nonatomic, copy) NSString *access_token;
//店铺ID
@property (nonatomic, copy) NSString *user_id;

/**
 用户头像
 */
@property (nonatomic, copy) NSString *sv_us_logo;

/**
 店铺名称
 */
@property (nonatomic, copy) NSString *sv_us_name;

/**
 店铺简称
 */
@property (nonatomic, copy) NSString *sv_us_shortname;

/**
 注册时间
 */
@property (nonatomic, copy) NSString *sv_ul_regdate;

/**
 座机
 */
@property (nonatomic, copy) NSString *sv_us_phone;

/**
 店主名称
 */
@property (nonatomic, copy) NSString *sv_ul_name;

/**
 手机号码
 */
@property (nonatomic, copy) NSString *sv_ul_mobile;

/**
 邮件
 */
@property (nonatomic, copy) NSString *sv_ul_email;

/**
 行业种类
 */
@property (nonatomic, copy) NSString *sv_uit_name;

//店铺地址
@property (nonatomic, copy) NSString *sv_us_address;

/**
 用户版本 version
 */
@property (nonatomic, copy) NSString *sv_versionid;
@property (nonatomic, copy) NSString *sv_versionname;

/**
 App版本号 version
 */
@property (nonatomic, copy) NSString *sv_oldVersion;
@property (nonatomic, copy) NSString *sv_newVersion;

/**
 操作员登陆权限控制
 */
@property (nonatomic, copy) NSString *sv_app_config;

@property (nonatomic, strong) NSDictionary *sv_app_config_dic;
/**
 是1的时候是代表店员登陆
 */
@property (nonatomic, copy) NSString *isStore;

@property (nonatomic, copy) NSString *sv_d_name;
/**
 是1的时候是操作员登陆  是否操作员
 */
@property (nonatomic, copy) NSString *is_SalesclerkLogin;

/**
操作员id
*/
@property (nonatomic, copy) NSString *sp_salesclerkid;


//操作员转成提成员工
@property (nonatomic, copy) NSString *sv_employeeid;
@property (nonatomic, copy) NSString *sv_employee_name;

@property (nonatomic,strong) NSString*labelPrintName;
/**
 打印的份数
 */
@property (nonatomic, copy) NSString *printerNumber;

/**
 标签打印的份数
 */
@property (nonatomic, copy) NSString *labelPrinterNumber;

/**
 标签打印机尺
 */
@property (nonatomic, copy) NSString *labelPrinterSize;

/**
 打印机尺
 */
@property (nonatomic, copy) NSString *printerSize;


/**
 城市名称
 */
@property (nonatomic,strong) NSString *cityname;
/**
 区名
 */
@property (nonatomic,strong) NSString *disname;

@property (nonatomic,strong) NSString *dec_payment_method;

/**
 是否零库存销售
 */
@property (nonatomic,strong) NSString *ZeroInventorySales_sv_detail_is_enable;

/**
 是否按可用积分晋升开关
 */
@property (nonatomic,strong) NSString *availableIntegralSwitch_sv_detail_is_enable;

/**
 是否自动拆箱
 */
@property (nonatomic,strong) NSString *SplitOpenACase_sv_detail_is_enable;

/**
 图片路径
 */
@property (nonatomic, copy) NSString *imageStr;

/**
 图片开关
 */
@property (nonatomic, copy) NSString *imageOpenOff;

/**
 快捷销售开关
 */
@property (nonatomic,strong) NSString *quickOff;
/**
 小票自定义信息
 */
@property (nonatomic, copy) NSString *CustomInformation;

/**
 小票自定义信息开关
 */
@property (nonatomic, copy) NSString *CustomInformationOpenOff;

/**
 商品大分类数组 和 ID数组
 */
//@property (nonatomic,strong) NSMutableArray *bigNameArr;
//@property (nonatomic,strong) NSMutableArray *bigIDArr;


@property (nonatomic,copy) NSString *addShop;
// 行业信息
@property (nonatomic,strong) NSString *sv_uit_cache_name;
// 行业ID
@property (nonatomic,strong) NSString *sv_uit_cache_id;

/**
 抹零设置
 */
@property (nonatomic,strong) NSDictionary *sv_uc_saletozerosetDic;


///**
// 是否零库存销售
// */
//
//@property (nonatomic,strong) NSString *ZeroInventorySales_sv_detail_is_enable;

/**
  等级晋级开关
 */
@property (nonatomic,strong) NSString *rankPromotion_sv_detail_is_enable;

///**
// 是否自动拆箱
// */
//
//@property (nonatomic,strong) NSString *SplitOpenACase_sv_detail_is_enable;
/**
 订单低于最低折扣是否允许结算
 */
@property (nonatomic,strong) NSString * Cash_Allow_Without_Discount_sv_detail_is_enable;


/**
 延长日期
 */
@property (nonatomic,strong) NSString *timeStr;
// 记录返回数据

@property (nonatomic,assign) NSInteger indexpath;

@property (nonatomic,copy) NSIndexPath * cellIndexPath;

@property (nonatomic,strong) NSDictionary *sv_uc_dixian;

@property (nonatomic,strong) NSDictionary *sv_versionpowersDict;

/**
 是否启用会员密码
 */
@property (nonatomic,strong) NSString *sv_uc_isenablepwd;

@property (nonatomic,strong) NSString *sv_ad_skiptimer;

@property (nonatomic,strong) NSString *sv_ad_skipbtn;
@property (nonatomic,strong) NSString *sv_ad_foroem;

@property (nonatomic,strong) NSString * sv_ad_canskip;
/**
 是否启用跨店消费
 */
@property (nonatomic,strong) NSString *sv_branchrelation;

/**
 存储满赠送的数组
 */
@property (nonatomic,strong) NSArray *childDetailList;

@property (nonatomic,strong) NSArray * picUrlArr;

//@property (nonatomic,strong) NSString * ConvergePay;
@property (nonatomic,strong) NSString * ConvergePay;
/**
 分类折
 */
@property (nonatomic,strong) NSArray *getUserLevel;

@property (nonatomic,strong) NSString *isAggregatePayment;
@property (nonatomic,strong) NSDictionary *launchOptions;


/**
 轮播图
 */
@property (nonatomic,strong) NSArray * bannersConfig;

@property (nonatomic,strong) NSString * product_id;
@property (nonatomic,strong) NSString * Tips;


+ (instancetype)shareInstance;


/**
 保存用户数据到沙盒
 */
+ (void)saveUserInfo;

/**
 从沙盒加载用户数据
 */
+ (void)loadUserInfo;

/**
 删除沙盒数据
 */
+ (void)removeUserInfo;

/**
 释放单例
 */
+ (void)tearDown;

//-(void)destroy;


@end

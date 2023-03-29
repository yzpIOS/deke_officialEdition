//
//  SVUserManager.m
//  SAVI
//
//  Created by Sorgle on 17/5/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVUserManager.h"

#define API_UserFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.plist"]

@implementation SVUserManager


static SVUserManager *instance = nil;

static dispatch_once_t onceToken;

+ (instancetype)shareInstance {
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}


//归档(序列化)
//对对象进行归档时,此方法执行
//对想要进行归档的所有属性,进行序列化操作
-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    //根据key去保存要保存的值
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.passwd forKey:@"passwd"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    
    [aCoder encodeObject:self.sv_us_logo forKey:@"sv_us_logo"];
    [aCoder encodeObject:self.sv_us_name forKey:@"sv_us_name"];
    [aCoder encodeObject:self.sv_us_shortname forKey:@"sv_us_shortname"];
    [aCoder encodeObject:self.sv_ul_regdate forKey:@"sv_ul_regdate"];
    [aCoder encodeObject:self.sv_us_phone forKey:@"sv_us_phone"];
    [aCoder encodeObject:self.sv_ul_name forKey:@"sv_ul_name"];
    [aCoder encodeObject:self.sv_ul_mobile forKey:@"sv_ul_mobile"];
    [aCoder encodeObject:self.sv_ul_email forKey:@"sv_ul_email"];
    [aCoder encodeObject:self.sv_uit_name forKey:@"sv_uit_name"];
    
    [aCoder encodeObject:self.sv_versionid forKey:@"sv_versionid"];
    [aCoder encodeObject:self.sv_versionname forKey:@"sv_versionname"];
    [aCoder encodeObject:self.sv_app_config forKey:@"sv_app_config"];
    [aCoder encodeObject:self.sv_app_config_dic forKey:@"sv_app_config_dic"];
    
    [aCoder encodeObject:self.isStore forKey:@"isStore"];
    [aCoder encodeObject:self.is_SalesclerkLogin forKey:@"is_SalesclerkLogin"];
    
    [aCoder encodeObject:self.sv_employeeid forKey:@"sv_employeeid"];
    [aCoder encodeObject:self.sv_employee_name forKey:@"sv_employee_name"];
    
    [aCoder encodeObject:self.printerNumber forKey:@"printerNumber"];
    [aCoder encodeObject:self.printerSize forKey:@"printerSize"];
    
    [aCoder encodeObject:self.sv_uit_cache_name forKey:@"sv_uit_cache_name"];
    [aCoder encodeObject:self.sv_uit_cache_id forKey:@"sv_uit_cache_id"];
    
    [aCoder encodeObject:self.imageStr forKey:@"imageStr"];
    [aCoder encodeObject:self.CustomInformation forKey:@"CustomInformation"];
    
    [aCoder encodeObject:self.CustomInformationOpenOff forKey:@"CustomInformationOpenOff"];
    [aCoder encodeObject:self.imageOpenOff forKey:@"imageOpenOff"];
    [aCoder encodeObject:self.quickOff forKey:@"quickOff"];
    
    [aCoder encodeObject:self.ZeroInventorySales_sv_detail_is_enable forKey:@"ZeroInventorySales_sv_detail_is_enable"];
    [aCoder encodeObject:self.SplitOpenACase_sv_detail_is_enable forKey:@"SplitOpenACase_sv_detail_is_enable"];
    [aCoder encodeObject:self.dec_payment_method forKey:@"dec_payment_method"];
    [aCoder encodeObject:self.disname forKey:@"disname"];

    [aCoder encodeObject:self.timeStr forKey:@"timeStr"];
   // @property (nonatomic,strong) SVCardRechargeInfoModel *model;
     [aCoder encodeObject:self.disname forKey:@"disname"];
    [aCoder encodeObject:self.cellIndexPath forKey:@"cellIndexPath"];
     [aCoder encodeObject:self.sv_uc_dixian forKey:@"sv_uc_dixian"];
    [aCoder encodeObject:self.sv_uc_isenablepwd forKey:@"sv_uc_isenablepwd"];
    [aCoder encodeObject:self.sv_versionpowersDict forKey:@"sv_versionpowersDict"];
    [aCoder encodeObject:self.childDetailList forKey:@"childDetailList"];
    [aCoder encodeObject:self.is_SalesclerkLogin forKey:@"is_SalesclerkLogin"];
    [aCoder encodeObject:self.sp_salesclerkid forKey:@"sp_salesclerkid"];
    [aCoder encodeObject:self.sv_branchrelation forKey:@"sv_branchrelation"];
    [aCoder encodeObject:self.sv_uc_saletozerosetDic forKey:@"sv_uc_saletozerosetDic"];
    [aCoder encodeObject:self.getUserLevel forKey:@"getUserLevel"];
    [aCoder encodeObject:self.isAggregatePayment forKey:@"isAggregatePayment"];
    [aCoder encodeObject:self.launchOptions forKey:@"launchOptions"];
    
    [aCoder encodeObject:self.rankPromotion_sv_detail_is_enable forKey:@"rankPromotion_sv_detail_is_enable"];
    [aCoder encodeObject:self.availableIntegralSwitch_sv_detail_is_enable forKey:@"availableIntegralSwitch_sv_detail_is_enable"];

    [aCoder encodeObject:self.sv_d_name forKey:@"sv_d_name"];

    [aCoder encodeObject:self.sv_ad_skiptimer forKey:@"sv_ad_skiptimer"];
    
    [aCoder encodeObject:self.sv_ad_skipbtn forKey:@"sv_ad_skipbtn"];
    
    [aCoder encodeObject:self.sv_ad_canskip forKey:@"sv_ad_canskip"];
    [aCoder encodeObject:self.sv_ad_foroem forKey:@"sv_ad_foroem"];

    [aCoder encodeObject:self.bannersConfig forKey:@"bannersConfig"];

    [aCoder encodeObject:self.product_id forKey:@"product_id"];
    [aCoder encodeObject:self.picUrlArr forKey:@"picUrlArr"];
    [aCoder encodeObject:self.ConvergePay forKey:@"ConvergePay"];
    [aCoder encodeObject:self.Tips forKey:@"Tips"];

    [aCoder encodeObject:self.Cash_Allow_Without_Discount_sv_detail_is_enable forKey:@"Cash_Allow_Without_Discount_sv_detail_is_enable"];
    
}

//反归档(反序列化)
//对对象进行反归档时,该方法执行
//创建一个新的对象,所有属性都是通过反序列化得到
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        //根据key去取出对应的值
        [SVUserManager shareInstance].account = [aDecoder decodeObjectForKey:@"account"];
        [SVUserManager shareInstance].passwd = [aDecoder decodeObjectForKey:@"passwd"];
        [SVUserManager shareInstance].access_token = [aDecoder decodeObjectForKey:@"access_token"];
        [SVUserManager shareInstance].user_id = [aDecoder decodeObjectForKey:@"user_id"];
        
        [SVUserManager shareInstance].sv_us_logo = [aDecoder decodeObjectForKey:@"sv_us_logo"];
        [SVUserManager shareInstance].sv_us_name = [aDecoder decodeObjectForKey:@"sv_us_name"];
        [SVUserManager shareInstance].sv_us_shortname = [aDecoder decodeObjectForKey:@"sv_us_shortname"];
        [SVUserManager shareInstance].sv_ul_regdate = [aDecoder decodeObjectForKey:@"sv_ul_regdate"];
        [SVUserManager shareInstance].sv_us_phone = [aDecoder decodeObjectForKey:@"sv_us_phone"];
        [SVUserManager shareInstance].sv_ul_name = [aDecoder decodeObjectForKey:@"sv_ul_name"];
        [SVUserManager shareInstance].sv_ul_mobile = [aDecoder decodeObjectForKey:@"sv_ul_mobile"];
        [SVUserManager shareInstance].sv_ul_email = [aDecoder decodeObjectForKey:@"sv_ul_email"];
        [SVUserManager shareInstance].sv_uit_name = [aDecoder decodeObjectForKey:@"sv_uit_name"];
        
        [SVUserManager shareInstance].sv_versionid = [aDecoder decodeObjectForKey:@"sv_versionid"];
        [SVUserManager shareInstance].sv_versionname = [aDecoder decodeObjectForKey:@"sv_versionname"];
        [SVUserManager shareInstance].sv_app_config = [aDecoder decodeObjectForKey:@"sv_app_config"];
        [SVUserManager shareInstance].sv_app_config_dic = [aDecoder decodeObjectForKey:@"sv_app_config_dic"];
        
        [SVUserManager shareInstance].isStore = [aDecoder decodeObjectForKey:@"isStore"];
        [SVUserManager shareInstance].is_SalesclerkLogin = [aDecoder decodeObjectForKey:@"is_SalesclerkLogin"];
        
        [SVUserManager shareInstance].sv_employeeid = [aDecoder decodeObjectForKey:@"sv_employeeid"];
        [SVUserManager shareInstance].sv_employee_name = [aDecoder decodeObjectForKey:@"sv_employee_name"];
        
        [SVUserManager shareInstance].printerNumber = [aDecoder decodeObjectForKey:@"printerNumber"];
        [SVUserManager shareInstance].printerSize = [aDecoder decodeObjectForKey:@"printerSize"];
        [SVUserManager shareInstance].sv_uit_cache_name = [aDecoder decodeObjectForKey:@"sv_uit_cache_name"];
        [SVUserManager shareInstance].sv_uit_cache_id = [aDecoder decodeObjectForKey:@"sv_uit_cache_id"];
        [SVUserManager shareInstance].imageStr = [aDecoder decodeObjectForKey:@"imageStr"];
        [SVUserManager shareInstance].CustomInformation = [aDecoder decodeObjectForKey:@"CustomInformation"];
        
        [SVUserManager shareInstance].imageOpenOff = [aDecoder decodeObjectForKey:@"imageOpenOff"];
        [SVUserManager shareInstance].CustomInformationOpenOff = [aDecoder decodeObjectForKey:@"CustomInformationOpenOff"];
        [SVUserManager shareInstance].quickOff = [aDecoder decodeObjectForKey:@"quickOff"];
        // [aCoder encodeObject:self.sv_uit_cache_id forKey:@"sv_uit_cache_id"];
        
        [SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable = [aDecoder decodeObjectForKey:@"ZeroInventorySales_sv_detail_is_enable"];
        [SVUserManager shareInstance].SplitOpenACase_sv_detail_is_enable = [aDecoder decodeObjectForKey:@"SplitOpenACase_sv_detail_is_enable"];
        [SVUserManager shareInstance].cityname = [aDecoder decodeObjectForKey:@"cityname"];
        
        [SVUserManager shareInstance].disname = [aDecoder decodeObjectForKey:@"disname"];
        [SVUserManager shareInstance].dec_payment_method = [aDecoder decodeObjectForKey:@"dec_payment_method"];

         [SVUserManager shareInstance].cellIndexPath = [aDecoder decodeObjectForKey:@"cellIndexPath"];
         [SVUserManager shareInstance].timeStr = [aDecoder decodeObjectForKey:@"timeStr"];
        [SVUserManager shareInstance].sv_uc_dixian = [aDecoder decodeObjectForKey:@"sv_uc_dixian"];
        [SVUserManager shareInstance].sv_uc_isenablepwd = [aDecoder decodeObjectForKey:@"sv_uc_isenablepwd"];
        // [aCoder encodeObject:self.sv_uit_cache_id forKey:@"sv_uit_cache_id"];

        [SVUserManager shareInstance].sv_versionpowersDict = [aDecoder decodeObjectForKey:@"sv_versionpowersDict"];
        [SVUserManager shareInstance].childDetailList = [aDecoder decodeObjectForKey:@"childDetailList"];

        [SVUserManager shareInstance].is_SalesclerkLogin = [aDecoder decodeObjectForKey:@"is_SalesclerkLogin"];
        [SVUserManager shareInstance].sp_salesclerkid = [aDecoder decodeObjectForKey:@"sp_salesclerkid"];

        [SVUserManager shareInstance].sv_branchrelation = [aDecoder decodeObjectForKey:@"sv_branchrelation"];

        [SVUserManager shareInstance].sv_uc_saletozerosetDic = [aDecoder decodeObjectForKey:@"sv_uc_saletozerosetDic"];

        [SVUserManager shareInstance].getUserLevel = [aDecoder decodeObjectForKey:@"getUserLevel"];

        
        [SVUserManager shareInstance].isAggregatePayment = [aDecoder decodeObjectForKey:@"isAggregatePayment"];

        [SVUserManager shareInstance].launchOptions = [aDecoder decodeObjectForKey:@"launchOptions"];
        
        [SVUserManager shareInstance].rankPromotion_sv_detail_is_enable = [aDecoder decodeObjectForKey:@"rankPromotion_sv_detail_is_enable"];
        [SVUserManager shareInstance].availableIntegralSwitch_sv_detail_is_enable = [aDecoder decodeObjectForKey:@"availableIntegralSwitch_sv_detail_is_enable"];

        [SVUserManager shareInstance].sv_d_name = [aDecoder decodeObjectForKey:@"sv_d_name"];

        [SVUserManager shareInstance].sv_ad_skiptimer = [aDecoder decodeObjectForKey:@"sv_ad_skiptimer"];
        
        [SVUserManager shareInstance].sv_ad_skipbtn = [aDecoder decodeObjectForKey:@"sv_ad_skipbtn"];
        
        [SVUserManager shareInstance].sv_ad_canskip = [aDecoder decodeObjectForKey:@"sv_ad_canskip"];
        
        [SVUserManager shareInstance].sv_ad_foroem = [aDecoder decodeObjectForKey:@"sv_ad_foroem"];

        [SVUserManager shareInstance].bannersConfig = [aDecoder decodeObjectForKey:@"bannersConfig"];
        
        [SVUserManager shareInstance].picUrlArr = [aDecoder decodeObjectForKey:@"picUrlArr"];
        [SVUserManager shareInstance].product_id = [aDecoder decodeObjectForKey:@"product_id"];
        [SVUserManager shareInstance].ConvergePay = [aDecoder decodeObjectForKey:@"ConvergePay"];

        [SVUserManager shareInstance].Tips = [aDecoder decodeObjectForKey:@"Tips"];

        [SVUserManager shareInstance].Cash_Allow_Without_Discount_sv_detail_is_enable = [aDecoder decodeObjectForKey:@"Cash_Allow_Without_Discount_sv_detail_is_enable"];

    }
    
    return self;
}

///  从沙盒中加载用户账号密码
+ (void)loadUserInfo{
    
    [NSKeyedUnarchiver unarchiveObjectWithFile:API_UserFilePath];
}

///  保存账号密码到沙盒中
+ (void)saveUserInfo{
    
    [NSKeyedArchiver archiveRootObject:[SVUserManager shareInstance] toFile:API_UserFilePath];
}

///  注销的时候清除沙盒文件
+ (void)removeUserInfo{
    
    [[NSFileManager defaultManager] removeItemAtPath:API_UserFilePath error:nil];
}
///   释放单例
+ (void)tearDown{
    
    instance = nil;
    
    onceToken = 0;
    
}
//单例
//static SVUserManager *instance = nil;
//static dispatch_once_t onceToken ;
//+(instancetype) shareInstance
//{
//    dispatch_once(&onceToken, ^{
//
//        instance = [[self alloc] init] ;
//
//    }) ;
//    return instance ;
//}
////注销单例
//-(void)destroy{
//    onceToken = 0;//只有置成0，GCD才会认为它从未执行过，它默认为0，这样才能保证下次再次调用shareInstance的时候，再次创建对象。
//    instance = nil;
//}


@end

//
//  SVRegisteredThreeVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRegisteredThreeVC.h"
//#import "SVLandingVC.h"
#import "SVTabBar.h"
#import "SVModuleModel.h"
#import "SVLandingVC.h"

@interface SVRegisteredThreeVC ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation SVRegisteredThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ScreenH <= 800) {
        self.icon.image = [UIImage imageNamed:@"icon_8p"];

    } else {
        self.icon.image = [UIImage imageNamed:@"icon_proMax"];
        
    }
    //去掉返回栏
    //[self.navigationItem setHidesBackButton:YES];
    
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"注册帐号";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"注册帐号";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenW, 44)];
//    image.image = [UIImage imageNamed:@"back_03"];
//    [self.view addSubview:image];
    
    self.button.layer.cornerRadius = 25;
    
   
    
}

//跳转到登陆界面
- (IBAction)jumpToLanding {
    
//    //提示登陆
//    [SVTool IndeterminateButtonAction:self.view withSing:@"登陆中…"];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [self loginInterfacePhone:self.phoneNum withPassword:self.password];
//
//    });
    self.hidesBottomBarWhenPushed = YES;
    SVLandingVC *viewController = [[SVLandingVC alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}

/**
 登陆接口请求
 
 @param phone 帐号
 @param password 密码
 */
-(void)loginInterfacePhone:(NSString *)phone withPassword:(NSString *)password{  //这里有报错  2018.1.08
    
    //    self.bgview.hidden = NO;
  
    //创建url /api/Login
    NSString *urlStr = [URLhead stringByAppendingString:@"/api/Login/UserLogin"];
    //时间戳
    NSString *timestamp = [JWXUtils genTimeStamp];
    //随机数
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random()%1000000-1];
    //密码
    NSString *pwd = password;
    //密码进行MD5加密
    NSString *pwdMD5=[JWXUtils EncodingWithMD5:pwd].uppercaseString;
    //加入数组进行排序
    NSArray *values=[[NSArray alloc]initWithObjects:pwdMD5,timestamp,nonce, nil];
    //转成字符串产生签名
    NSString  *signature=[JWXUtils asSortAndSubString:values];
    //把签名再次进行Hash MD5加密
    signature=[JWXUtils EncodingWithMD5:signature];
    //接收加密后的签名
    NSString *Signature = signature;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"userName"];
    [parameters setObject:timestamp forKey:@"timestamp"];
    // cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@",[SVUserManager shareInstance].sv_oldVersion];
    [parameters setObject:[NSString stringWithFormat:@"%@ %@",app_Name,app_Version] forKey:@"operatingPlatform"];
    [parameters setObject:[NSString stringWithFormat:@"IOS %@",phoneVersion] forKey:@"systemName"];
    [parameters setObject:nonce forKey:@"nonce"];
    [parameters setObject:Signature forKey:@"signature"];
    NSLog(@"parameters= %@",parameters);
  
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"urlStr= %@",urlStr);
        
        NSLog(@"dict54534= %@",dict);
        
        if ([dict[@"succeed"] integerValue] == 1) {
            NSDictionary *dic = [dict dictionaryForKeySafe:@"values"];
            NSDictionary *infoDic = dict[@"userInfo"];
            NSDictionary *userconfig = infoDic[@"userconfig"];
           NSString *sv_uc_dixianStr =userconfig[@"sv_uc_dixian"];
            
          
            NSString *sv_uc_isenablepwd = [NSString stringWithFormat:@"%@",userconfig[@"sv_uc_isenablepwd"]];
            if (kStringIsEmpty(sv_uc_isenablepwd)) {
                [SVUserManager shareInstance].sv_uc_isenablepwd = @"0";
            }else{
                [SVUserManager shareInstance].sv_uc_isenablepwd = sv_uc_isenablepwd;
            }
            NSLog(@"sv_uc_isenablepwd = %@",sv_uc_isenablepwd);
            
            NSData *data = [sv_uc_dixianStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *sv_uc_dixian = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
            
             [SVUserManager shareInstance].sv_uc_dixian = sv_uc_dixian;
            
            NSArray *moduleConfigList = infoDic[@"moduleConfigList"];
            if (!kArrayIsEmpty(moduleConfigList)) {
                for (NSDictionary *detaiDic in moduleConfigList) {
                    if ([detaiDic[@"sv_user_module_code"] isEqualToString:@"ZeroInventorySales"]) {
                        NSArray *childInfolist = detaiDic[@"childInfolist"];
                        if (!kArrayIsEmpty(childInfolist)) {
                            NSDictionary *dic=childInfolist[0];
                            if (!kDictIsEmpty(dic)) {
                                NSArray *childDetailList = dic[@"childDetailList"];
                                if (!kArrayIsEmpty(childDetailList)) {
                                    NSDictionary *lastDic = childDetailList[0];
                                    
                                    if (!kDictIsEmpty(lastDic)) {
                                        NSString*sv_detail_is_enable=lastDic[@"sv_detail_is_enable"];
                                        [SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable = sv_detail_is_enable;
                                    }
                                }
                              
                            }
                          
                        }
                        
                       
                        
                    }
                }
            }
       
            //用单例保存信息
            [SVUserManager shareInstance].account = phone;
            [SVUserManager shareInstance].passwd = password;
            [SVUserManager shareInstance].access_token = dic[@"access_token"];
            NSLog(@"[SVUserManager shareInstance].access_token= %@",[SVUserManager shareInstance].access_token);
            //分店权限
            [SVUserManager shareInstance].isStore = dic[@"isStore"];
//<<<<<<< HEAD
//            //  [SVUserManager shareInstance].sv_app_config = dic[@"sv_app_config"];
//            [SVUserManager shareInstance].sv_app_config_dic = dic[@"sv_app_config"];
//            NSDictionary *config_dic = [SVUserManager shareInstance].sv_app_config_dic;
//            SVModuleModel *model = [SVModuleModel mj_objectWithKeyValues:config_dic];
//            [SVUserManager shareInstance].sv_app_config = model.module;
//            NSLog(@"model.module = %@",model.module);
//=======
            
          //  [SVUserManager shareInstance].sv_app_config_dic = dic[@"sv_app_config"];
//            NSDictionary *config_dic = dic[@"sv_app_config"];
//            if (kDictIsEmpty(config_dic)) {
//                [SVUserManager shareInstance].sv_app_config = @"";
//            }else{
//                SVModuleModel *model = [SVModuleModel mj_objectWithKeyValues:config_dic];
//                [SVUserManager shareInstance].sv_app_config = model.module;
//                NSLog(@"model.module = %@",model.module);
//            }
            
            [SVUserManager shareInstance].sv_app_config_dic = dic[@"sv_app_config"];
            NSDictionary *config_dic = [SVUserManager shareInstance].sv_app_config_dic;
            SVModuleModel *model = [SVModuleModel mj_objectWithKeyValues:config_dic];
            [SVUserManager shareInstance].sv_app_config = model.module;

            NSLog(@"[SVUserManager shareInstance].sv_app_config= %@",[SVUserManager shareInstance].sv_app_config);
            
            if ([dict[@"is_SalesclerkLogin"] integerValue] == 1) {
                //操作员名字
                [SVUserManager shareInstance].sv_employee_name = [NSString stringWithFormat:@"%@",dic[@"sv_employee_name"]];
                
            }else{
                NSDictionary *dic_two = dict[@"userInfo"];
                [SVUserManager shareInstance].sv_employee_name = [NSString stringWithFormat:@"%@",dic_two[@"sv_ul_name"]];
                
            }
            
            [SVUserManager shareInstance].user_id = dic[@"user_id"];
            
            [SVUserManager saveUserInfo];

            
            //用偏好设置，保存帐号\密码\ID
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            [defaults setObject:self.textFieldOne.text forKey:@"account"];
            //            [defaults setObject:self.textFieldTwo.text forKey:@"passwd"];
            //            [defaults setObject:dic[@"access_token"] forKey:@"access_token"];
            //            [defaults setObject:dic[@"user_id"] forKey:@"user_id"];
            //            [defaults synchronize];
            
            //用户数据的请求
            [self requestUserData];
            [self requestBigClassData];
            /*
             跳转到主界面
             */
            
            //延迟1秒开始跳转，目前让数据有足够时间去请求用户数据
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //    SVTabBar *tabbar = [[SVTabBar alloc]init];
            //    window.rootViewController = tabbar;
            //    //跳转时会有动画效果，从下慢慢往上
            //    //[self presentViewController:tabbar animated:YES completion:nil];
            //});
            
            
        } else {
            
           // self.bgview.hidden = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"账号与密码不一致"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  self.bgview.hidden = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"登陆请求失败"];
    }];
    
}


#pragma mark - 用户数据请求
- (void)requestUserData{
    
    [SVUserManager loadUserInfo];
    
    //URL
    //NSString *urlStr = [URLhead stringByAppendingString:@"/system/GetUserinfo?key=%@&accountno=%@",[SVUserManager shareInstance].access_token,[SVUserManager shareInstance].account];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/system/GetUserinfo?key=%@&accountno=%@",[SVUserManager shareInstance].access_token,[SVUserManager shareInstance].account];
    NSLog(@"urlStr = %@",urlStr);
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict = %@",dict);
        
        if ([dict[@"succeed"] integerValue] == 1) {
            NSDictionary *dic = [dict dictionaryForKeySafe:@"values"];
            
            //头像
            [SVUserManager shareInstance].sv_us_logo = dic[@"sv_us_logo"];
            //店铺名称
            [SVUserManager shareInstance].sv_us_name = dic[@"sv_us_name"];
            //店铺简称
            [SVUserManager shareInstance].sv_us_shortname = dic[@"sv_us_shortname"];
            //注册时间
            [SVUserManager shareInstance].sv_ul_regdate = dic[@"sv_ul_regdate"];
            //店铺电话
            [SVUserManager shareInstance].sv_us_phone = dic[@"sv_us_phone"];
            //店主名称
            [SVUserManager shareInstance].sv_ul_name = [NSString stringWithFormat:@"%@",dic[@"sv_ul_name"]];
            //手机号码
            [SVUserManager shareInstance].sv_ul_mobile = dic[@"sv_ul_mobile"];
            //电子邮件
            [SVUserManager shareInstance].sv_ul_email = dic[@"sv_ul_email"];
            //行业种类
            [SVUserManager shareInstance].sv_uit_name = dic[@"sv_uit_name"];
            //地址
            [SVUserManager shareInstance].sv_us_address = dic[@"address"];
            //版本
            [SVUserManager shareInstance].sv_versionid = [NSString stringWithFormat:@"%@",dic[@"sv_versionid"]];
            [SVUserManager shareInstance].sv_versionname = dic[@"sv_versionname"];
        
            //行业信息
            [SVUserManager shareInstance].sv_uit_cache_name = dic[@"sv_uit_cache_name"];
            
            [SVUserManager shareInstance].sv_uit_cache_id = dic[@"sv_us_industrytype"];
            //操作员权限
            [SVUserManager shareInstance].is_SalesclerkLogin = dic[@"is_SalesclerkLogin"];
            //操作员ID
            [SVUserManager shareInstance].sv_employeeid = [NSString stringWithFormat:@"%@",dic[@"sv_employeeid"]];
//            //操作员名字
//            [SVUserManager shareInstance].sv_employee_name = [NSString stringWithFormat:@"%@",dic[@"sv_employee_name"]];
             [SVUserManager shareInstance].dec_payment_method = [NSString stringWithFormat:@"%@",dic[@"dec_payment_method"]];
            
            [SVUserManager saveUserInfo];
            
        } else {
            [SVTool TextButtonActionWithSing:@"数据出错,信息请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
}

#pragma mark - 商品大分类数据请求
-(void)requestBigClassData{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //URL
    NSString *urlStr = [URLhead stringByAppendingString:@"/product/GetFirstCategory"];
    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //将key放到字典里
    [parameters setObject:token forKey:@"key"];
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"urlStr = %@",urlStr);
        if ([dic[@"succeed"] intValue] == 1) {
            
            //NSMutableArray *valuesArr = dic[@"values"];
            
            NSArray *valuesArr= [dic arrayForKeySafe:@"values"];
            
            //偏好设置
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray *bigNameArr = [NSMutableArray array];
            NSMutableArray *bigIDArr = [NSMutableArray array];
            
            [bigNameArr addObject:@"全部商品"];
            
            [bigIDArr addObject:@"0"];
            
            if (![SVTool isEmpty:valuesArr]) {
                
                //将数组里边的字典遍历一次,就可以拿到每个字典里的东西了
                for (NSDictionary *dict in valuesArr) {
                    
                    [bigNameArr addObject:dict[@"sv_pc_name"]];
                    
                    [bigIDArr addObject:dict[@"productcategory_id"]];
                    
                }
                
            }
            
            [defaults setObject:bigNameArr forKey:@"bigName_Arr"];
            [defaults setObject:bigIDArr forKey:@"bigID_Arr"];
            
            [defaults synchronize];
            
            //跳转
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            SVTabBar *tabbar = [[SVTabBar alloc]init];
            window.rootViewController = tabbar;
        } else {
            
           // self.bgview.hidden = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"登陆数据请求失败"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  self.bgview.hidden = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"登陆数据请求失败"];
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar setTranslucent:false];
   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

@end

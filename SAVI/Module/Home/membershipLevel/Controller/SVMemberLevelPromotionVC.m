//
//  SVMemberLevelPromotionVC.m
//  SAVI
//
//  Created by 杨忠平 on 2022/7/24.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVMemberLevelPromotionVC.h"

@interface SVMemberLevelPromotionVC ()
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic,strong) NSDictionary*rankPromotion_childDetail;
@property (nonatomic,strong) UIButton *tagBtn;
@property (nonatomic,assign) BOOL integralBool;
@property (nonatomic,strong) NSDictionary*availableIntegralSwitch_childDetail;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@end

@implementation SVMemberLevelPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员等级晋级";
    self.view.backgroundColor = BlueBackgroundColor;
    [self.oneBtn setTitle:@"按累计积分晋级" forState:UIControlStateNormal];
    [self.oneBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.oneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.oneBtn.imageView.size = CGSizeMake(15, 15);
    [self.oneBtn addTarget:self action:@selector(integralClick:) forControlEvents:UIControlEventTouchUpInside];
    self.oneBtn.tag = 0;
    
    [self.twoBtn setTitle:@"按可用积分晋级" forState:UIControlStateNormal];
    [self.twoBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    [self.twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.twoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.twoBtn.imageView.size = CGSizeMake(15, 15);
    [self.twoBtn addTarget:self action:@selector(integralClick:) forControlEvents:UIControlEventTouchUpInside];
    self.twoBtn.tag = 1;
    
    [self loadGetUserModuleConfig_rankPromotion];
    [self loadGetUserModuleConfig_availableIntegralSwitch];
}
#pragma mark - 等级晋级开关
- (void)loadGetUserModuleConfig_rankPromotion{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/UserModuleConfig/GetUserModuleConfig?key=%@&moduleCode=rankPromotion",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
          //  [SVTool TextButtonAction:self.view withSing:@"删除成功"];
          //  [self.navigationController popViewControllerAnimated:YES];
            NSArray *data = dic[@"data"];
            NSDictionary *dataDict = data[0];
            NSArray *childInfolist = dataDict[@"childInfolist"];
            // 等级晋级开关
          //  if ([dic[@"sv_user_module_code"] isEqualToString:@"rankPromotion"]) {
               // NSArray *childInfolist = detaiDic[@"childInfolist"];
                if (!kArrayIsEmpty(childInfolist)) {
                    NSDictionary *dic=childInfolist[0];
                    if (!kDictIsEmpty(dic)) {
                        NSArray *childDetailList = dic[@"childDetailList"];
                        if (!kArrayIsEmpty(childDetailList)) {
                            NSDictionary *lastDic = childDetailList[0];
                            self.rankPromotion_childDetail = lastDic;
                            if (!kDictIsEmpty(lastDic)) {
                                NSString*sv_detail_is_enable = lastDic[@"sv_detail_is_enable"];
                                [SVUserManager shareInstance].rankPromotion_sv_detail_is_enable = sv_detail_is_enable;
                                
                                if (sv_detail_is_enable.intValue == 1) {
                                    [self.switchBtn setOn:YES];
                                     self.twoView.hidden = NO;
                                }else{
                                    [self.switchBtn setOn:NO];
                                    
                                
                                        self.twoView.hidden = YES;
                                 //   }
                                    
                                }
                            }
                        }
                      
                    }
                  
                }
                
           // }
          
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma mark - 可用积分晋级
- (void)loadGetUserModuleConfig_availableIntegralSwitch{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/UserModuleConfig/GetUserModuleConfig?key=%@&moduleCode=availableIntegralSwitch",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            //  [SVTool TextButtonAction:self.view withSing:@"删除成功"];
            //  [self.navigationController popViewControllerAnimated:YES];
              NSArray *data = dic[@"data"];
              NSDictionary *dataDict = data[0];
              NSArray *childInfolist = dataDict[@"childInfolist"];

            //  if ([dic[@"sv_user_module_code"] isEqualToString:@"rankPromotion"]) {
                 // NSArray *childInfolist = detaiDic[@"childInfolist"];
                  if (!kArrayIsEmpty(childInfolist)) {
                      NSDictionary *dic=childInfolist[0];
                      if (!kDictIsEmpty(dic)) {
                          NSArray *childDetailList = dic[@"childDetailList"];
                          if (!kArrayIsEmpty(childDetailList)) {
                              NSDictionary *lastDic = childDetailList[0];
                              self.availableIntegralSwitch_childDetail = lastDic;
                              if (!kDictIsEmpty(lastDic)) {
                                  NSString*sv_detail_is_enable=lastDic[@"sv_detail_is_enable"];
                                  [SVUserManager shareInstance].availableIntegralSwitch_sv_detail_is_enable = sv_detail_is_enable;
                                  if (sv_detail_is_enable.intValue == 1) {
                                      [self integralClick:self.twoBtn];
                                  }else{
                                      [self integralClick:self.oneBtn];
                                  }
                              }
                          }
                        
                      }
                    
                  }
                  
             // }
            
          }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}


#pragma mark - 点击等级晋升开关
- (void)loadSaveConfigdetailList_rankPromotion_swiOn:(BOOL)swiOn{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/UserModuleConfig/SaveConfigdetailList?key=%@&moduleCode=rankPromotion",[SVUserManager shareInstance].access_token];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"sv_detail_is_enable"] = [NSNumber numberWithBool:swiOn];
    parame[@"sv_detail_value"] = self.rankPromotion_childDetail[@"sv_detail_value"];
    parame[@"sv_remark"] = self.rankPromotion_childDetail[@"sv_remark"];
    parame[@"sv_user_config_id"] = self.rankPromotion_childDetail[@"sv_user_config_id"];
    parame[@"sv_user_configdetail_id"] = self.rankPromotion_childDetail[@"sv_user_configdetail_id"];
    parame[@"sv_user_configdetail_name"] = self.rankPromotion_childDetail[@"sv_user_configdetail_name"];
    parame[@"sv_user_module_id"] = self.rankPromotion_childDetail[@"sv_user_module_id"];
    [arrayM addObject:parame];
    
    [[SVSaviTool sharedSaviTool] POST:url parameters:arrayM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];

}
#pragma mark - 点击可用积分晋级开关
- (void)loadSaveConfigdetailList_membershipGradeGroupingIntegralBool:(BOOL)integralBool{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/UserModuleConfig/SaveConfigdetailList?key=%@&moduleCode=MembershipGradeGrouping",[SVUserManager shareInstance].access_token];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"sv_detail_is_enable"] = [NSNumber numberWithBool:integralBool];
    parame[@"sv_detail_value"] = self.availableIntegralSwitch_childDetail[@"sv_detail_value"];
    parame[@"sv_remark"] = self.availableIntegralSwitch_childDetail[@"sv_remark"];
    parame[@"sv_user_config_id"] = self.availableIntegralSwitch_childDetail[@"sv_user_config_id"];
    parame[@"sv_user_configdetail_id"] = @"109";
    parame[@"sv_user_configdetail_name"] = self.availableIntegralSwitch_childDetail[@"sv_user_configdetail_name"];
    parame[@"sv_user_module_id"] = self.availableIntegralSwitch_childDetail[@"sv_user_module_id"];
    [arrayM addObject:parame];
    
    [[SVSaviTool sharedSaviTool] POST:url parameters:arrayM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];

}
#pragma mark - 积分开关点击
- (void)integralClick:(UIButton *)btn{
    self.tagBtn.selected = NO;
          // self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
        [self.tagBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
           btn.selected = YES;
          // btn.layer.borderColor = [[UIColor clearColor] CGColor];
    //       btn.backgroundColor =
        [btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
           self.tagBtn = btn;
    if (btn.tag == 0) {// 是按累计积分晋级
       // self.type = @"1";
        [self loadSaveConfigdetailList_membershipGradeGroupingIntegralBool:false];
    }else{// 积分扣除  // 是按可用积分晋级
       // self.type = @"0";
        [self loadSaveConfigdetailList_membershipGradeGroupingIntegralBool:true];
    }
}

#pragma mark - 晋级开关点击
- (IBAction)switchClick:(UISwitch *)sender {
    if (sender.isOn == true) {
        self.twoView.hidden = NO;
    }else{
        self.twoView.hidden = YES;
    }
    [self loadSaveConfigdetailList_rankPromotion_swiOn:sender.isOn];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    titleLabel.textColor = [UIColor whiteColor];;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text=self.title;
    
    self.navigationItem.titleView = titleLabel;
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = navigationBackgroundColor;

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = [UIColor whiteColor];

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
}


@end

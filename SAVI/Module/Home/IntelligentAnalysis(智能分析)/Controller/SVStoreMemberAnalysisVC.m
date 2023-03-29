//
//  SVStoreMemberAnalysisVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVStoreMemberAnalysisVC.h"
#import "SVMemberAnalysisOneVC.h"
#import "SVRechargeReportVC.h"
#import "SVSubCardReportVC.h"
#import "SVCardSalesReportVC.h"

@interface SVStoreMemberAnalysisVC ()
@property (nonatomic,strong) NSMutableArray *titleData;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *user_id;
@end

@implementation SVStoreMemberAnalysisVC

- (void)viewDidLoad {
    
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuItemWidth = ScreenW / 4;
    self.progressHeight = 1;
    self.titleColorNormal = [UIColor colorWithHexString:@"666666"];;
    self.titleColorSelected = navigationBackgroundColor;
    
    //    self.titleSizeSelected = 17;
    //    self.titleSizeNormal = 15;
    
    //    self.iskaiguan = NO;
    self.titleFontName = @"PingFangSC-Medium";
    
    // self.title = @"盘点";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = BackgroundColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"nitifyName2" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyMemberNameAllStore:) name:@"nitifyMemberNameAllStore" object:nil];
    
    [super viewDidLoad];
    
    
   
    
}

#pragma mark - 时间晒选
-(void)notification2:(NSNotification *)noti{
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    // NSString *type = [dic objectForKey:@"type"];
    // self.type = type;
    self.dic = dic;
    
}

- (void)nitifyMemberNameAllStore:(NSNotification *)noti{
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    // NSString *type = [dic objectForKey:@"type"];
    // self.type = type;
    self.user_id = dic[@"user_id"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName2" object:nil];
}

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}



#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
        case 0:{
            
            NSString *title = self.titleData[0];
            if ([title isEqualToString:@"会员分析"]) {
                 SVMemberAnalysisOneVC *VC = [[SVMemberAnalysisOneVC alloc] init];
                 return VC;
            }else if ([title isEqualToString:@"充值报表"]){
                SVRechargeReportVC *vc = [[SVRechargeReportVC alloc] init];
                // vc.view.backgroundColor = [UIColor greenColor];
                vc.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    vc.user_id = @"";
                }else{
                    vc.user_id = self.user_id;
                }
                return vc;
            }else if ([title isEqualToString:@"售卡报表"]){
                SVCardSalesReportVC *VC = [[SVCardSalesReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }else{
                SVSubCardReportVC *VC = [[SVSubCardReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }

        }
            
            break;
            
        case 1:{
            
            NSString *title = self.titleData[1];
            if ([title isEqualToString:@"会员分析"]) {
                 SVMemberAnalysisOneVC *VC = [[SVMemberAnalysisOneVC alloc] init];
                 return VC;
            }else if ([title isEqualToString:@"充值报表"]){
                SVRechargeReportVC *vc = [[SVRechargeReportVC alloc] init];
                // vc.view.backgroundColor = [UIColor greenColor];
                vc.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    vc.user_id = @"";
                }else{
                    vc.user_id = self.user_id;
                }
                return vc;
            }else if ([title isEqualToString:@"售卡报表"]){
                SVCardSalesReportVC *VC = [[SVCardSalesReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }else{
                SVSubCardReportVC *VC = [[SVSubCardReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }
            

            
        }
            break;
            
        case 2:{
            
            
            NSString *title = self.titleData[2];
            if ([title isEqualToString:@"会员分析"]) {
                 SVMemberAnalysisOneVC *VC = [[SVMemberAnalysisOneVC alloc] init];
                 return VC;
            }else if ([title isEqualToString:@"充值报表"]){
                SVRechargeReportVC *vc = [[SVRechargeReportVC alloc] init];
                // vc.view.backgroundColor = [UIColor greenColor];
                vc.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    vc.user_id = @"";
                }else{
                    vc.user_id = self.user_id;
                }
                return vc;
            }else if ([title isEqualToString:@"售卡报表"]){
                SVCardSalesReportVC *VC = [[SVCardSalesReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }else{
                SVSubCardReportVC *VC = [[SVSubCardReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }
            

           
        }
            break;
        default:{
            
            
            NSString *title = self.titleData[3];
            if ([title isEqualToString:@"会员分析"]) {
                 SVMemberAnalysisOneVC *VC = [[SVMemberAnalysisOneVC alloc] init];
                 return VC;
            }else if ([title isEqualToString:@"充值报表"]){
                SVRechargeReportVC *vc = [[SVRechargeReportVC alloc] init];
                // vc.view.backgroundColor = [UIColor greenColor];
                vc.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    vc.user_id = @"";
                }else{
                    vc.user_id = self.user_id;
                }
                return vc;
            }else if ([title isEqualToString:@"售卡报表"]){
                SVCardSalesReportVC *VC = [[SVCardSalesReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }else{
                SVSubCardReportVC *VC = [[SVSubCardReportVC alloc] init];
                VC.dic = self.dic;
                if (kStringIsEmpty(self.user_id)) {
                    VC.user_id = @"";
                }else{
                    VC.user_id = self.user_id;
                }
                return VC;
            }

            
        }
            break;
            
            
    }
    
    
}

//- (void)oneSelect{
//    
//}
//
//- (void)twoSelect{
//    SVCardSalesReportVC *VC = [[SVCardSalesReportVC alloc] init];
//               VC.dic = self.dic;
//               if (kStringIsEmpty(self.user_id)) {
//                   VC.user_id = @"";
//               }else{
//                   VC.user_id = self.user_id;
//               }
//               return VC;
//}
//
//- (void)threeSelect{
//    
//}



- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    //    if (self.iskaiguan == NO) {
    //        return CGRectMake(0, 0, HomePageScreen / 3 *2, 64);
    //    }else{
    //        return CGRectMake(0, 0, ScreenW /3*2, 64);
    //    }
    return CGRectMake(0, 1, ScreenW, 50);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    
    return CGRectMake(0, 51, ScreenW, self.view.height - 51 - kTabbarHeight - BottomHeight);
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}




#pragma mark 标题数组
- (NSMutableArray *)titleData {
    if (!_titleData) {
        
        [SVUserManager loadUserInfo];
        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
        NSString *MemberAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"MemberAnalysis"]]; // 会员分析
         NSString *RechargeReport = [NSString stringWithFormat:@"%@",AnalyticsDic[@"RechargeReport"]];// 充值报表
        NSString *SecondaryCard_analysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"SecondaryCard_analysis"]]; // 售卡报表
        NSString *ReportForm = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ReportForm"]]; // 次卡报表
        
        _titleData = [NSMutableArray arrayWithObjects:@"会员分析", @"充值报表",@"售卡报表",@"次卡报表", nil];
        
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
            if (kDictIsEmpty(sv_versionpowersDict)) { // 会员分析
         
            }else{
               
                if (kStringIsEmpty(MemberAnalysis)) {
                }else{
                    if ([MemberAnalysis isEqualToString:@"1"]) {
                    }else{
                        [_titleData removeObject:@"会员分析"];
                    }
                }
            }
            
            
            if (kDictIsEmpty(sv_versionpowersDict)) { // 充值报表
         
            }else{
               
                if (kStringIsEmpty(RechargeReport)) {
                }else{
                    if ([RechargeReport isEqualToString:@"1"]) {
                    }else{
                        [_titleData removeObject:@"充值报表"];
                    }
                }
            }
            
            
            if (kDictIsEmpty(sv_versionpowersDict)) { // 售卡报表
         
            }else{
               
                if (kStringIsEmpty(SecondaryCard_analysis)) {
                }else{
                    if ([SecondaryCard_analysis isEqualToString:@"1"]) {
                    }else{
                        [_titleData removeObject:@"售卡报表"];
                    }
                }
            }
            
            
            if (kDictIsEmpty(sv_versionpowersDict)) { // 次卡报表
         
            }else{
               
                if (kStringIsEmpty(ReportForm)) {
                }else{
                    if ([ReportForm isEqualToString:@"1"]) {
                    }else{
                        [_titleData removeObject:@"次卡报表"];
                    }
                }
            }
            
            
        }else{
            if (kDictIsEmpty(sv_versionpowersDict)) { // 会员分析
         
            }else{
               
                if (kStringIsEmpty(MemberAnalysis)) {
                }else{
                    if ([MemberAnalysis isEqualToString:@"1"]) {
                    }else{
                        [_titleData removeObject:@"会员分析"];
                    }
                }
            }
            
            
            if (kDictIsEmpty(sv_versionpowersDict)) { // 充值报表
         
            }else{
               
                if (kStringIsEmpty(RechargeReport)) {
                }else{
                    if ([RechargeReport isEqualToString:@"1"]) {
                    }else{
                        [_titleData removeObject:@"充值报表"];
                    }
                }
            }
        }
        
//        if (kDictIsEmpty(sv_versionpowersDict)) {
//            [self setUpTitle];
//        }else{
//            if (kStringIsEmpty(MemberAnalysis) && kStringIsEmpty(RechargeReport)) {
//               [self setUpTitle];
//            }else{
//                if ([MemberAnalysis isEqualToString:@"1"] && [RechargeReport isEqualToString:@"1"]) {
//
//                   [self setUpTitle];
//                }else{
//                    if ([MemberAnalysis isEqualToString:@"0"] && [RechargeReport isEqualToString:@"0"]) {
//                        [SVUserManager loadUserInfo];
//                        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
//                            _titleData = @[@"售卡报表",@"次卡报表"];
//                        }else{
//                            _titleData = @[];
//                        }
//                    }else{
//                        if ([MemberAnalysis isEqualToString:@"1"] && kStringIsEmpty(RechargeReport)) {
//                        [self setUpTitle];
//                        }else{
//
//                            if ([MemberAnalysis isEqualToString:@"0"] && [RechargeReport isEqualToString:@"0"]) {
//                                [SVUserManager loadUserInfo];
//                                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
//                                    _titleData = @[@"售卡报表",@"次卡报表"];
//                                }else{
//                                    _titleData = @[];
//                                }
//                            }else{
//                                if ([MemberAnalysis isEqualToString:@"1"] || kStringIsEmpty(MemberAnalysis)) {
//                                  [SVUserManager loadUserInfo];
//                                     if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
//                                         _titleData = @[@"会员分析",@"售卡报表",@"次卡报表"];
//                                     }else{
//
//                                         if ([RechargeReport isEqualToString:@"1"] || kStringIsEmpty(RechargeReport)) {
//                                             _titleData = @[@"会员分析",@"充值报表"];
//                                         }else{
//                                             _titleData = @[@"会员分析"];
//                                         }
//
//                                     }
//                                }else{
//                                    if ([RechargeReport isEqualToString:@"1"] || kStringIsEmpty(RechargeReport)) {
//                                       [SVUserManager loadUserInfo];
//                                        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
//                                            _titleData = @[@"充值报表",@"售卡报表",@"次卡报表"];
//                                        }else{
//
//                                            if ([MemberAnalysis isEqualToString:@"1"] || kStringIsEmpty(MemberAnalysis)) {
//                                                _titleData = @[@"会员分析",@"充值报表"];
//                                            }else{
//                                                _titleData = @[@"充值报表"];
//                                            }
//
//
//                                        }
//                                    }
//                                }
//
//
//                            }
//
//                        }
//                }
//            }
//            }
//        }
        
        
        
    }
    return _titleData;
}

//- (void)setUpTitle{
//    [SVUserManager loadUserInfo];
//    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
//    NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
//    NSString *MemberAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"MemberAnalysis"]]; // 会员分析
//     NSString *RechargeReport = [NSString stringWithFormat:@"%@",AnalyticsDic[@"RechargeReport"]];// 充值报表
//    NSString *SecondaryCard_analysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"SecondaryCard_analysis"]]; // 售卡报表
//    NSString *ReportForm = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ReportForm"]];
//   // [SVUserManager loadUserInfo];
//    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
//       
//        if (kDictIsEmpty(sv_versionpowersDict)) {
//            _titleData = @[@"会员分析", @"充值报表",@"售卡报表",@"次卡报表"];
//        }else{
//            if (kStringIsEmpty(MemberAnalysis) && kStringIsEmpty(RechargeReport) && kStringIsEmpty(SecondaryCard_analysis) && kStringIsEmpty(ReportForm)) {
//                _titleData = @[@"会员分析", @"充值报表",@"售卡报表",@"次卡报表"];
//            }else{
//                if ([MemberAnalysis isEqualToString:@"1"] && [RechargeReport isEqualToString:@"1"] && [SecondaryCard_analysis isEqualToString:@"1"] && [ReportForm isEqualToString:@"1"]) {
//                    _titleData = @[@"会员分析", @"充值报表",@"售卡报表",@"次卡报表"];
//                }else{
//                    if ([MemberAnalysis isEqualToString:@"0"] && [RechargeReport isEqualToString:@"0"] && [SecondaryCard_analysis isEqualToString:@"0"] && [ReportForm isEqualToString:@"0"]) {
//                        _titleData = @[];
//                      //  _titleData = @[@"售卡报表",@"次卡报表"];
//                    }else{
//                        if ([MemberAnalysis isEqualToString:@"1"] && [RechargeReport isEqualToString:@"0"] && [SecondaryCard_analysis isEqualToString:@"0"] && [ReportForm isEqualToString:@"0"]) {
//                       // _titleData = @[@"门店概况"];
//                            _titleData = @[@"会员分析"];
//                        }else if ([MemberAnalysis isEqualToString:@"1"] && [RechargeReport isEqualToString:@"0"] && [SecondaryCard_analysis isEqualToString:@"0"] && [ReportForm isEqualToString:@"0"]){
//                            
//                        }
//                        
//                     if ([RechargeReport isEqualToString:@"1"]) {
//                       //  _titleData = @[@"每日对账单"];
//                         _titleData = @[@"充值报表"];
//                     }
//                        
//                        if ([SecondaryCard_analysis isEqualToString:@"1"]) {
//                          //  _titleData = @[@"每日对账单"];
//                            _titleData = @[@"售卡报表"];
//                        }
//                        
//                        if ([ReportForm isEqualToString:@"1"]) {
//                          //  _titleData = @[@"每日对账单"];
//                            _titleData = @[@"次卡报表"];
//                        }
//                }
//            }
//            }
//        }
//       
//    }else{
//      //  _titleData = @[@"会员分析", @"充值报表"];
//        if (kDictIsEmpty(sv_versionpowersDict)) {
//            _titleData = @[@"会员分析", @"充值报表"];
//        }else{
//            if (kStringIsEmpty(MemberAnalysis) && kStringIsEmpty(RechargeReport)) {
//                _titleData = @[@"会员分析", @"充值报表"];
//            }else{
//                if ([MemberAnalysis isEqualToString:@"1"] && [RechargeReport isEqualToString:@"1"]) {
//                    _titleData = @[@"会员分析", @"充值报表"];
//                }else{
//                    if ([MemberAnalysis isEqualToString:@"0"] && [RechargeReport isEqualToString:@"0"]) {
//                        _titleData = @[];
//                       // _titleData = @[@"售卡报表",@"次卡报表"];
//                    }else{
//                        if ([MemberAnalysis isEqualToString:@"1"]) {
//                       // _titleData = @[@"门店概况"];
//                            _titleData = @[@"会员分析"];
//                    }
//                        
//                     if ([RechargeReport isEqualToString:@"1"]) {
//                       //  _titleData = @[@"每日对账单"];
//                         _titleData = @[@"充值报表"];
//                     }
//                }
//            }
//            }
//        }
//    }
//}


@end

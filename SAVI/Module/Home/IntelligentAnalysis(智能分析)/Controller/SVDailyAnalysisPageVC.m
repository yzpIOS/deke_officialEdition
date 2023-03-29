//
//  SVDailyAnalysisPageVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/27.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVDailyAnalysisPageVC.h"
#import "SVDailyAnalysisVC.h"
#import "SVSmartAnalyseVC.h"
#import "SVDailyStatementVC.h"
@interface SVDailyAnalysisPageVC ()
@property (nonatomic,strong) NSArray *titleData;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *user_id;





@end

@implementation SVDailyAnalysisPageVC

- (void)viewDidLoad {
    
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
      self.menuItemWidth = ScreenW / 2;
    self.progressHeight = 1;
    self.titleColorNormal = [UIColor colorWithHexString:@"666666"];
    self.titleColorSelected = navigationBackgroundColor;
    self.menuView.backgroundColor = [UIColor whiteColor];
    //    self.titleSizeSelected = 17;
    //    self.titleSizeNormal = 15;
    
    //    self.iskaiguan = NO;
    self.titleFontName = @"PingFangSC-Medium";
    self.showOnNavigationBar = NO;
    // self.title = @"盘点";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = BackgroundColor;
    
    [super viewDidLoad];

    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"盘点记录" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
//
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"nitifyName1" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyNameAllStore:) name:@"nitifyNameAllStore" object:nil];
}

#pragma mark - 时间晒选
-(void)notification1:(NSNotification *)noti{
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
   // NSString *type = [dic objectForKey:@"type"];
   // self.type = type;
    self.dic = dic;
    
}

- (void)nitifyNameAllStore:(NSNotification *)noti{
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    // NSString *type = [dic objectForKey:@"type"];
    // self.type = type;
    self.user_id = dic[@"user_id"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName1" object:nil];
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
            if ([title isEqualToString:@"门店概况"]) {
               SVDailyAnalysisVC *VC = [[SVDailyAnalysisVC alloc] init];
                return VC;
            }else{
                SVDailyStatementVC *vc = [[SVDailyStatementVC alloc] init];
                 vc.dic = self.dic;
                 if (kStringIsEmpty(self.user_id)) {
                     vc.user_id = @"";
                 }else{
                     vc.user_id = self.user_id;
                 }
                
                 vc.view.backgroundColor = BackgroundColor;
                 return vc;
            }
            


        }
            
            break;
        default:{
            
            NSString *title = self.titleData[1];
                       if ([title isEqualToString:@"门店概况"]) {
                          SVDailyAnalysisVC *VC = [[SVDailyAnalysisVC alloc] init];
                           return VC;
                       }else{
                           SVDailyStatementVC *vc = [[SVDailyStatementVC alloc] init];
                            vc.dic = self.dic;
                            if (kStringIsEmpty(self.user_id)) {
                                vc.user_id = @"";
                            }else{
                                vc.user_id = self.user_id;
                            }
                           
                            vc.view.backgroundColor = BackgroundColor;
                            return vc;
                       }
            
//            SVDailyStatementVC *vc = [[SVDailyStatementVC alloc] init];
//            vc.dic = self.dic;
//            if (kStringIsEmpty(self.user_id)) {
//                vc.user_id = @"";
//            }else{
//                vc.user_id = self.user_id;
//            }
//
//            vc.view.backgroundColor = BackgroundColor;
//            return vc;
        }
            break;
            
            
    }
    
    
}

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
- (NSArray *)titleData {
    if (!_titleData) {
        if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
          //  DailyBill
            _titleData = @[@"每日对账单"];
        }else{
            [SVUserManager loadUserInfo];
            NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
            NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
            NSString *Generastore = [NSString stringWithFormat:@"%@",AnalyticsDic[@"Generastore"]];
             NSString *DailyBill = [NSString stringWithFormat:@"%@",AnalyticsDic[@"DailyBill"]];
            if (kDictIsEmpty(sv_versionpowersDict)) {
                _titleData = @[@"门店概况", @"每日对账单"];
            }else{
                if (kStringIsEmpty(Generastore) && kStringIsEmpty(DailyBill)) {
                    _titleData = @[@"门店概况", @"每日对账单"];
                }else{
                    if ([Generastore isEqualToString:@"1"] && [DailyBill isEqualToString:@"1"]) {
                        _titleData = @[@"门店概况", @"每日对账单"];
                    }else{
                        if ([Generastore isEqualToString:@"0"] && [DailyBill isEqualToString:@"0"]) {
                            _titleData = @[];
                        }else{
                            if ([Generastore isEqualToString:@"1"]) {
                            _titleData = @[@"门店概况"];
                        }
                            
                         if ([DailyBill isEqualToString:@"1"]) {
                             _titleData = @[@"每日对账单"];
                         }
                    }
                }
                }
            }
        }
        
    }
    return _titleData;
}




@end

//
//  SVStoreSalesAnalysisVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVStoreSalesAnalysisVC.h"
#import "SVStoreShopSaleVC.h"
#import "SVStoreShopCatageryVC.h"

@interface SVStoreSalesAnalysisVC ()
@property (nonatomic,strong) NSArray *titleData;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *user_id;


@end

@implementation SVStoreSalesAnalysisVC

- (void)viewDidLoad {
    
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuItemWidth = ScreenW / 2;
    self.progressHeight = 1;
    self.titleColorNormal = [UIColor colorWithHexString:@"666666"];
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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification3:) name:@"nitifyName3" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyShopNameAllStore:) name:@"nitifyShopNameAllStore" object:nil];
    [super viewDidLoad];
 
}

#pragma mark - 时间晒选
-(void)notification3:(NSNotification *)noti{
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    // NSString *type = [dic objectForKey:@"type"];
    // self.type = type;
    self.dic = dic;
    
}

- (void)nitifyShopNameAllStore:(NSNotification *)noti{
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    // NSString *type = [dic objectForKey:@"type"];
    // self.type = type;
    self.user_id = dic[@"user_id"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName3" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyShopNameAllStore" object:nil];
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
            if ([title isEqualToString:@"商品销售"]) {
                 SVStoreShopSaleVC *VC = [[SVStoreShopSaleVC alloc] init];
               
                 return VC;
            }else{
                SVStoreShopCatageryVC *vc = [[SVStoreShopCatageryVC alloc] init];
                //  vc.view.backgroundColor = [UIColor greenColor];
                  vc.dic = self.dic;
                  if (kStringIsEmpty(self.user_id)) {
                      vc.user_id = @"";
                  }else{
                      vc.user_id = self.user_id;
                  }
                  return vc;
            }
            

        }
            
            break;
        default:{
            
            NSString *title = self.titleData[1];
                       if ([title isEqualToString:@"商品销售"]) {
                            SVStoreShopSaleVC *VC = [[SVStoreShopSaleVC alloc] init];
                          
                            return VC;
                       }else{
                           SVStoreShopCatageryVC *vc = [[SVStoreShopCatageryVC alloc] init];
                           //  vc.view.backgroundColor = [UIColor greenColor];
                             vc.dic = self.dic;
                             if (kStringIsEmpty(self.user_id)) {
                                 vc.user_id = @"";
                             }else{
                                 vc.user_id = self.user_id;
                             }
                             return vc;
                       }
            
//            SVStoreShopCatageryVC *vc = [[SVStoreShopCatageryVC alloc] init];
//          //  vc.view.backgroundColor = [UIColor greenColor];
//            vc.dic = self.dic;
//            if (kStringIsEmpty(self.user_id)) {
//                vc.user_id = @"";
//            }else{
//                vc.user_id = self.user_id;
//            }
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
        
        [SVUserManager loadUserInfo];
                  NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                  NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
                  NSString *ShopAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ShopAnalysis"]];
                   NSString *ProductCategoryAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ProductCategoryAnalysis"]];
                  if (kDictIsEmpty(sv_versionpowersDict)) {
                     _titleData = @[@"商品销售", @"商品分类"];
                  }else{
                      if (kStringIsEmpty(ShopAnalysis) && kStringIsEmpty(ProductCategoryAnalysis)) {
                          _titleData = @[@"商品销售", @"商品分类"];
                      }else{
                          if ([ShopAnalysis isEqualToString:@"1"] && [ProductCategoryAnalysis isEqualToString:@"1"]) {
                              _titleData = @[@"商品销售", @"商品分类"];
                          }else{
                              if ([ShopAnalysis isEqualToString:@"0"] && [ProductCategoryAnalysis isEqualToString:@"0"]) {
                                  _titleData = @[];
                              }else{
                                  if ([ShopAnalysis isEqualToString:@"1"]) {
                                  _titleData = @[@"商品销售"];
                              }
                                  
                               if ([ProductCategoryAnalysis isEqualToString:@"1"]) {
                                   _titleData = @[@"商品分类"];
                               }
                          }
                      }
                      }
                  }
        
        
    }
    return _titleData;
}
@end

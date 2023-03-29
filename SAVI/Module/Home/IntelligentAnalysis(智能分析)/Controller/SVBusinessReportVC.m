//
//  SVBusinessReportVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/27.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVBusinessReportVC.h"
#import "SVDailyAnalysisVC.h"
#import "SVDailyAnalysisPageVC.h"
#import "SVStoreMemberAnalysisVC.h"
#import "SVStoreSalesAnalysisVC.h"

//选择时间
#import "SVSelectTwoDatesView.h"
#import "SVNavMemberView.h"
#import "SVShopSalesDetailsVC.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
#import "SVNavTitleView.h"
#import "SVNavShopView.h"

#import "SVNewVipVC.h"
#import "YCMenuView.h"

#define kThemeColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

@interface SVBusinessReportVC ()<UINavigationControllerDelegate>
@property (nonatomic,assign) NSInteger selectNum;
@property (nonatomic,assign) NSInteger memberNum;
@property (nonatomic,assign) NSInteger shopNum;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
//遮盖view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) SVNavTitleView *navTitleView;

@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSMutableArray *memberArray;
@property (nonatomic,strong) NSMutableArray *shopArray;

@property (nonatomic,strong) NSString *titleNumber;//用来记录是哪个模块
@property (nonatomic,strong) SVNavMemberView *navMemberView;
@property (nonatomic,strong) SVNavShopView *navShopView;
@property (nonatomic,strong) NSMutableArray *actionArray;
@property (nonatomic,strong) NSMutableArray *memberActionArray;
@property (nonatomic,strong) NSMutableArray *shopActionArray;

@end

@implementation SVBusinessReportVC

- (NSMutableArray *)actionArray
{
    if (!_actionArray) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (NSMutableArray *)memberActionArray
{
    if (!_memberActionArray) {
        _memberActionArray = [NSMutableArray array];
    }
    return _memberActionArray;
}

- (NSMutableArray *)shopActionArray
{
    if (!_shopActionArray) {
        _shopActionArray = [NSMutableArray array];
    }
    return _shopActionArray;
}

- (SVNavTitleView *)navTitleView
{
    if (!_navTitleView) {
        _navTitleView = [[NSBundle mainBundle]loadNibNamed:@"SVNavTitleView" owner:nil options:nil].lastObject;
       // _navTitleView.width = _navTitleView.image.width + _navTitleView.nameText.width;
        [SVUserManager loadUserInfo];
        NSString *sv_ul_name = [SVUserManager shareInstance].sv_us_name;
        _navTitleView.nameText.text = sv_ul_name;
        if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
            _navTitleView.image.hidden = YES;
            _navTitleView.userInteractionEnabled = NO;
        }else{
             _navTitleView.image.hidden = NO;
             _navTitleView.userInteractionEnabled = YES;
        }
       // [SVUserManager shareInstance].sv_ul_name
    }
    
    return _navTitleView;
}

- (SVNavMemberView *)navMemberView
{
    if (!_navMemberView) {
        _navMemberView = [[NSBundle mainBundle]loadNibNamed:@"SVNavMemberView" owner:nil options:nil].lastObject;
       // _navMemberView.width = _navMemberView.nameText.width + _navMemberView.image.width;
        NSString *sv_ul_name = [SVUserManager shareInstance].sv_us_name;
        _navMemberView.nameText.text = sv_ul_name;
        
        if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
            _navMemberView.image.hidden = YES;
            _navMemberView.userInteractionEnabled = NO;
        }else{
            _navMemberView.image.hidden = NO;
            _navMemberView.userInteractionEnabled = YES;
        }
    }
    
    return _navMemberView;
}

- (SVNavShopView *)navShopView
{
    if (!_navShopView) {
        _navShopView = [[NSBundle mainBundle]loadNibNamed:@"SVNavShopView" owner:nil options:nil].lastObject;
      //  _navShopView.width = _navShopView.image.width + _navShopView.nameText.width;
        NSString *sv_ul_name = [SVUserManager shareInstance].sv_us_name;
        _navShopView.nameText.text = sv_ul_name;
        
        if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
            _navShopView.image.hidden = YES;
             _navShopView.userInteractionEnabled = NO;
        }else{
            _navShopView.image.hidden = NO;
            _navShopView.userInteractionEnabled = YES;
        }
    }
    
    return _navShopView;
}

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)memberArray
{
    if (_memberArray == nil) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

- (NSMutableArray *)shopArray
{
    if (_shopArray == nil) {
        _shopArray = [NSMutableArray array];
    }
    return _shopArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.selectNum = 0;
    self.memberNum = 0;
    self.shopNum = 0;
            //创建子控制器
    SVDailyAnalysisPageVC *dailyAnalysisVC = [[SVDailyAnalysisPageVC alloc]init];
   // dailyAnalysisVC.view.backgroundColor = BackgroundColor;
    SVStoreMemberAnalysisVC *messageVC = [[SVStoreMemberAnalysisVC alloc]init];
    SVStoreSalesAnalysisVC *mineVC = [[SVStoreSalesAnalysisVC alloc]init];
    mineVC.hidesBottomBarWhenPushed = YES;
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
    NSString *ShopAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ShopAnalysis"]];
    
    NSString *ProductCategoryAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ProductCategoryAnalysis"]];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:dailyAnalysisVC,messageVC,mineVC, nil];
    NSMutableArray *childItemArray = [NSMutableArray arrayWithObjects: @{kClassKey  : @"YCHomeVC",
                                                                         kTitleKey  : @"日常分析",
                                                                         kImgKey    : @"calculator",
                                                                         kSelImgKey :       @"calculator_high"},
                                                                       
                                                                       @{kClassKey  : @"YCMessageVC",
                                                                         kTitleKey  : @"会员分析",
                                                                         kImgKey    : @"office-supplies",
                                                                         kSelImgKey : @"office-supplies_high"},
                                      @{kClassKey  : @"YCMineVC",
                                        kTitleKey  : @"商品分析",
                                        kImgKey    : @"categoryproducts",
                                        kSelImgKey : @"categoryproducts_high"}
                                      , nil];
    
  //  NSDictionary *MemberDic = sv_versionpowersDict[@"Member"];
    if (kDictIsEmpty(sv_versionpowersDict)) {
 
    }else{
        NSString *MemberAnalysis_list = [NSString stringWithFormat:@"%@",AnalyticsDic[@"MemberAnalysis_list"]];
        if (kStringIsEmpty(MemberAnalysis_list)) {
        }else{
            if ([MemberAnalysis_list isEqualToString:@"1"]) {
            }else{
                [arr removeObject:messageVC];
                [childItemArray removeObject:@{kClassKey  : @"YCMessageVC",
                                               kTitleKey  : @"会员分析",
                                               kImgKey    : @"office-supplies",
                                               kSelImgKey : @"office-supplies_high"}];
            }
        }
    }
    

    if ([ShopAnalysis isEqualToString:@"0"] && [ProductCategoryAnalysis isEqualToString:@"0"]) {
        [arr removeObject:mineVC];
        [childItemArray removeObject: @{kClassKey  : @"YCMineVC",
                                        kTitleKey  : @"商品分析",
                                        kImgKey    : @"categoryproducts",
                                        kSelImgKey : @"categoryproducts_high"}];
    }else{
        
    }
    
    
    
            //遍历数组
            [childItemArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {

                UIViewController *vc = arr[idx];
                vc.title = dic[kTitleKey];
                
                //解决渲染的方法
               // nav.navigationBar.translucent = NO;
                
              //  把状态栏(UIStatusBar)字体颜色设置为白色
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                
                //设置tabBar的图片
                UITabBarItem *item = vc.tabBarItem;
                item.tag = idx;
                self.title = dic[kTitleKey];
                item.image = [UIImage imageNamed:dic[kImgKey]];
                //[item setBackgroundImage:[UIImage imageNamed:@""]];
                //选中图使用该方法设置 避免被渲染
                item.selectedImage = [[UIImage imageNamed:dic[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName : navigationBackgroundColor} forState:UIControlStateSelected];
                vc.hidesBottomBarWhenPushed = YES;
                [self addChildViewController:vc];
                
            }];
    
    [self performSelectorOnMainThread:@selector(tabBar:didSelectItem:) withObject:[self.tabBarController.viewControllers objectAtIndex:0] waitUntilDone:NO];
  //  self.titleNumber = @"1";
    [self allStoreData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeShop_notification:) name:@"STORESHOPSALE_POST" object:nil];
}

- (void)allStoreData{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/CargoflowData/GetShopList?key=%@",token];
    NSLog(@"总店dURL = %@",dURL);
    
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"总店dic = %@",dic);
      //  if ([self.titleNumber isEqualToString:@"1"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"sv_us_name"] = @"全部店铺";
            dict[@"user_id"] = @"-1";
            [self.listArray addObject:dict];
       
        NSArray *list = dic[@"values"][@"list"];
        [self.listArray addObjectsFromArray:list];
        [self.memberArray addObjectsFromArray:list];
        [self.shopArray addObjectsFromArray:list];
       // self.listArray = dic[@"values"][@"list"];
        for (NSDictionary *dic in self.listArray) {
            YCMenuAction *action = [YCMenuAction actionWithTitle:dic[@"sv_us_name"] image:nil handler:^(YCMenuAction *action) {
                 self.navTitleView.nameText.text = dic[@"sv_us_name"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyNameAllStore" object:nil userInfo:dic];
                //调用请求
//                [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
            }];
            [self.actionArray addObject:action];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
//            [self.navigationController pushViewController:tabBar animated:YES];
         // self = self.childViewControllers[item.tag];
            NSLog(@"日常分析");
        //   = self.childViewControllers[item.tag];
         //  self.title = @"总店";
            
        
        {
            self.titleNumber = @"1";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
            
            // MyTitleView *titleView = [[MyTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,44)];
            
            self.navTitleView.intrinsicContentSize = CGSizeMake(_navTitleView.image.width + _navTitleView.nameText.width,44);
            
            self.navigationItem.titleView = self.navTitleView;
//            self.navigationItem.titleView.frame = CGRectMake(0, 0, self.navTitleView.width, 40);
            
            self.navTitleView.userInteractionEnabled = YES;
            self.navigationItem.titleView = self.navTitleView;
            self.navigationItem.titleView.userInteractionEnabled = YES;
            
            if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
             
            }else{
                [self.navTitleView addGestureRecognizer:tap];
            }
            
           
            
            //  self.navigationItem.titleView =
            if (self.selectNum == 0) {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
              //  self.navigationController.navigationBar.tintColor  = [UIColorblueColor];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"666666"];
            }else if (self.selectNum == 1){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"666666"];
            }else if (self.selectNum == 2){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"666666"];
            }else if (self.selectNum == 3){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"666666"];
            }
            
            
            
            break;
        }
            
        case 1:
            NSLog(@"会员分析");
           // self.title = @"会员分析";
        {
            self.titleNumber = @"2";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMemberClick)];
            
            // MyTitleView *titleView = [[MyTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,44)];
            
            self.navMemberView.intrinsicContentSize = CGSizeMake(_navMemberView.image.width + _navMemberView.nameText.width,44);
            
            self.navigationItem.titleView = self.navMemberView;
            
            self.navMemberView.userInteractionEnabled = YES;
            self.navigationItem.titleView = self.navMemberView;
            if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
                
            }else{
               [self.navMemberView addGestureRecognizer:tap];
            }
   
            if (self.memberNum == 0) {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
            }else if (self.memberNum == 1){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
            }else if (self.memberNum == 2){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
            }else if (self.memberNum == 3){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
            }
            
            
            break;
        }
 
        default:
            NSLog(@"商品分析");
        {
            self.titleNumber = @"3";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopClick)];
            
            // MyTitleView *titleView = [[MyTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,44)];
            
            self.navShopView.intrinsicContentSize = CGSizeMake(_navShopView.image.width + _navShopView.nameText.width,44);
            
            self.navigationItem.titleView = self.navShopView;
            
            self.navShopView.userInteractionEnabled = YES;
            self.navigationItem.titleView = self.navShopView;
            if (![[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
                
            }else{
                [self.navShopView addGestureRecognizer:tap];
            }
           // self.navigationItem.titleView.userInteractionEnabled = YES;
            
           // [self.navShopView addGestureRecognizer:tap];
            if (self.shopNum == 0) {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
               // self.navigationItem.rightBarButtonItem
            }else if (self.shopNum == 1){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
            }else if (self.shopNum == 2){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本月" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
            }else if (self.shopNum == 3){
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
            }
            
            break;
        }
       
    }
    
}

- (void)tapShopClick{
//    NSMutableArray *items = [NSMutableArray array];
//    for (NSDictionary *dict in self.listArray) {
//        YCXMenuItem *cashTitle = [YCXMenuItem menuItem:dict[@"sv_us_name"] image:nil target:self action:@selector(logout)];
//        cashTitle.foreColor = [UIColor colorWithHexString:@"666666"];
//        cashTitle.alignment = NSTextAlignmentLeft;
//        cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//        [items addObject:cashTitle];
//    }
//
//    [YCXMenu setCornerRadius:3.0f];
//    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
//    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
//    [YCXMenu setTintColor:[UIColor whiteColor]];
//    //name="state">0：查询全部，1：待入库，2：已入库
//    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(self.navShopView.centerX, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
//
//        NSDictionary *dic = self.listArray[index];
//        self.navShopView.nameText.text = dic[@"sv_us_name"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyShopNameAllStore" object:nil userInfo:dic];
//    }];
    
    [self.shopActionArray removeAllObjects];

      for (NSDictionary *dic in self.shopArray) {
                YCMenuAction *action = [YCMenuAction actionWithTitle:dic[@"sv_us_name"] image:nil handler:^(YCMenuAction *action) {
                   // self.user_id = dict[@"user_id"];
                   // self.navigationItem.rightBarButtonItem.title = dict[@"sv_us_name"];
                     self.navShopView.nameText.text = dic[@"sv_us_name"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyShopNameAllStore" object:nil userInfo:dic];
                    //调用请求
    //                [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                }];
                [self.shopActionArray addObject:action];
            }
    
    YCMenuView *view = [YCMenuView menuWithActions:self.shopActionArray width:140 atPoint:CGPointMake(SCREEN_WIDTH *0.5,TopHeight)];
    [view show];
}

- (void)tapMemberClick{
//    NSMutableArray *items = [NSMutableArray array];
//    for (NSDictionary *dict in self.listArray) {
//        YCXMenuItem *cashTitle = [YCXMenuItem menuItem:dict[@"sv_us_name"] image:nil target:self action:@selector(logout)];
//        cashTitle.foreColor = [UIColor colorWithHexString:@"666666"];
//        cashTitle.alignment = NSTextAlignmentLeft;
//        cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//        [items addObject:cashTitle];
//    }
//
//    [YCXMenu setCornerRadius:3.0f];
//    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
//    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
//    [YCXMenu setTintColor:[UIColor whiteColor]];
//    //name="state">0：查询全部，1：待入库，2：已入库
//    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(self.navMemberView.centerX, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
//
//        NSDictionary *dic = self.listArray[index];
//        self.navMemberView.nameText.text = dic[@"sv_us_name"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyMemberNameAllStore" object:nil userInfo:dic];
//    }];
    
    [self.memberActionArray removeAllObjects];
//    for (NSDictionary *dict in self.listArray) {
//        if ([[NSString stringWithFormat:@"%@",dict[@"sv_us_name"]] isEqualToString:@"全部店铺"]) {
//            [self.listArray removeObject:dict];
//            break;
//        }
//    }
      for (NSDictionary *dic in self.memberArray) {
                YCMenuAction *action = [YCMenuAction actionWithTitle:dic[@"sv_us_name"] image:nil handler:^(YCMenuAction *action) {
                   // self.user_id = dict[@"user_id"];
                   // self.navigationItem.rightBarButtonItem.title = dict[@"sv_us_name"];
                      self.navMemberView.nameText.text = dic[@"sv_us_name"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyMemberNameAllStore" object:nil userInfo:dic];
                    //调用请求
    //                [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                }];
                [self.memberActionArray addObject:action];
            }
    
    YCMenuView *view = [YCMenuView menuWithActions:self.memberActionArray width:140 atPoint:CGPointMake(SCREEN_WIDTH *0.5,TopHeight)];
    [view show];
    
    
}

- (void)tapClick{
    
    [self.actionArray removeAllObjects];
       for (NSDictionary *dic in self.listArray) {
                 YCMenuAction *action = [YCMenuAction actionWithTitle:dic[@"sv_us_name"] image:nil handler:^(YCMenuAction *action) {
                    // self.user_id = dict[@"user_id"];
                    // self.navigationItem.rightBarButtonItem.title = dict[@"sv_us_name"];
                      self.navTitleView.nameText.text = dic[@"sv_us_name"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyNameAllStore" object:nil userInfo:dic];
                     //调用请求
     //                [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                 }];
                 [self.actionArray addObject:action];
             }
    
    YCMenuView *view = [YCMenuView menuWithActions:self.actionArray width:140 atPoint:CGPointMake(SCREEN_WIDTH *0.5,TopHeight)];
         [view show];
 
}



#pragma mark - 日常分析
- (void)selectbuttonResponseEvent{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"本周" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = [UIColor colorWithHexString:@"666666"];
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"其他" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = [UIColor colorWithHexString:@"666666"];
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];
    //    NSArray *items = @[[YCXMenuItem menuItem:@"现金" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"微信" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"支付宝" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"银行卡" image:nil tag:4 userInfo:@{@"title":@"Menu"}],
    //                       ];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
               // self.payName = @"现金";
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                
                self.selectNum = 0;
                [self selectYCXMenuPayName];
                
            }
                break;
            case 1:
            {
              //  self.payName = @"微信支付";
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                 self.selectNum = 1;
                [self selectYCXMenuPayName];
            }
                break;
            case 2:
            {
               // self.payName = @"支付宝";
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                 self.selectNum = 2;
               [self selectYCXMenuPayName];
            }
                break;
            case 3:
            {
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                self.selectNum = 3;
                //self.payName = @"银行卡";
              [self selectYCXMenuPayName];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 会员分析
- (void)selectMemberButtonResponseEvent{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor = [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = [UIColor colorWithHexString:@"666666"];
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"本周" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = [UIColor colorWithHexString:@"666666"];
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"其他" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = [UIColor colorWithHexString:@"666666"];
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];
    //    NSArray *items = @[[YCXMenuItem menuItem:@"现金" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"微信" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"支付宝" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"银行卡" image:nil tag:4 userInfo:@{@"title":@"Menu"}],
    //                       ];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
                // self.payName = @"现金";
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                
                self.memberNum = 0;
                [self selectMemberYCXMenuPayName];
                
            }
                break;
            case 1:
            {
                //  self.payName = @"微信支付";
                 self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                self.memberNum = 1;
                [self selectMemberYCXMenuPayName];
            }
                break;
            case 2:
            {
                // self.payName = @"支付宝";
                 self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                self.memberNum = 2;
                [self selectMemberYCXMenuPayName];
            }
                break;
            case 3:
            {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                self.memberNum = 3;
                //self.payName = @"银行卡";
                [self selectMemberYCXMenuPayName];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 商品分析
- (void)selectShopButtonResponseEvent{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor = [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = [UIColor colorWithHexString:@"666666"];
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"本月" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = [UIColor colorWithHexString:@"666666"];
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"其他" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = [UIColor colorWithHexString:@"666666"];
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];
    //    NSArray *items = @[[YCXMenuItem menuItem:@"现金" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"微信" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"支付宝" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"银行卡" image:nil tag:4 userInfo:@{@"title":@"Menu"}],
    //                       ];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
                // self.payName = @"现金";
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
                
                self.shopNum = 0;
                [self selectYCXMenuPayNameShop];
                
            }
                break;
            case 1:
            {
                //  self.payName = @"微信支付";
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
                self.shopNum = 1;
                [self selectYCXMenuPayNameShop];
            }
                break;
            case 2:
            {
                // self.payName = @"支付宝";
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本月" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
                self.shopNum = 2;
                [self selectYCXMenuPayNameShop];
            }
                break;
            case 3:
            {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectShopButtonResponseEvent)];
                self.shopNum = 3;
                //self.payName = @"银行卡";
                [self selectYCXMenuPayNameShop];
            }
                break;
            default:
                break;
        }
    }];
}

// 日常分析
- (void)selectYCXMenuPayName{
    if (self.selectNum == 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"1";// 今天
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName1" object:nil userInfo:dic];
    }else if (self.selectNum == 1){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"-1";// 昨天
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName1" object:nil userInfo:dic];
    }else if (self.selectNum == 2){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"2";// 本周
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName1" object:nil userInfo:dic];
    }else{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
        
        [UIView animateWithDuration:.3 animations:^{
            self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
        }];
    }
    
}

#pragma mark - 会员分析
- (void)selectMemberYCXMenuPayName{
    if (self.memberNum == 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"1";// 今天
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName2" object:nil userInfo:dic];
    }else if (self.memberNum == 1){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"-1";// 昨天
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName2" object:nil userInfo:dic];
    }else if (self.memberNum == 2){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"2";// 本周
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName2" object:nil userInfo:dic];
    }else{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
        
        [UIView animateWithDuration:.3 animations:^{
            self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
        }];
    }
}


#pragma mark - 商品分析
- (void)selectYCXMenuPayNameShop{
    if (self.shopNum == 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"1";// 今天
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName3" object:nil userInfo:dic];
    }else if (self.shopNum == 1){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"2";// 昨天
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName3" object:nil userInfo:dic];
    }else if (self.shopNum == 2){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"3";// 本月
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName3" object:nil userInfo:dic];
    }else{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
        
        [UIView animateWithDuration:.3 animations:^{
            self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
        }];
    }
}

//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskView addGestureRecognizer:tap];
        
        [_maskView addSubview:_DateView];
    }
    return _maskView;
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
    
}

#pragma mark - 懒加载

-(SVSelectTwoDatesView *)DateView {
    
    if (!_DateView) {
        _DateView = [[[NSBundle mainBundle] loadNibNamed:@"SVSelectTwoDatesView" owner:nil options:nil] lastObject];
        _DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
        
        [_DateView.cancelButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_DateView.determineButton addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        NSDate *minDate = [NSDate date];
        //设置显示模式
        [_DateView.oneDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        _DateView.oneDatePicker.maximumDate = maxDate;
        _DateView.oneDatePicker.maximumDate = minDate;
        
        //设置显示模式
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        _DateView.twoDatePicker.maximumDate = maxDate;
        _DateView.twoDatePicker.maximumDate = minDate;
        
    }
    
    return _DateView;
}

- (void)twoCancelResponseEvent {
    
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        if ([self.titleNumber isEqualToString:@"1"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"type"] = @"4";// 昨天
            dic[@"oneDate"] = self.oneDate;
            dic[@"twoDate"] = self.twoDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName1" object:nil userInfo:dic];
        }else if ([self.titleNumber isEqualToString:@"2"]){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"type"] = @"3";// 其他
            dic[@"oneDate"] = self.oneDate;
            dic[@"twoDate"] = self.twoDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName2" object:nil userInfo:dic];
        }else{// 商品分析
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"type"] = @"4";// 其他
            dic[@"oneDate"] = self.oneDate;
            dic[@"twoDate"] = self.twoDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName3" object:nil userInfo:dic];
        }
     
        
    }
    
    
}


- (void)logout{
    
}
@end

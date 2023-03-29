//
//  SVHomeVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVHomeVC.h"
#import "SVHomeImgView.h"
#import "SVHomeViewCell.h"
#import "SVNewVipVC.h"
#import "SVVipListVC.h"
#import "SVOrderListVC.h"
#import "SVWaresListVC.h"
//#import "SVCashierVC.h"
#import "SVHomeViewThree.h"
//选择商品
#import "SVSelectWaresVC.h"
//快捷收银
#import "SVQuickCashierVC.h"
//查询销售
//#import "SVSalesListVC.h"
//#import "SVQuerySalesVC.h"
//选择商品
#import "SVSelectWaresVC.h"
//经济分析
#import "SVSmartAnalyseVC.h"
//支出管理
#import "SVPayManagementVC.h"
//库存盘点
#import "SVStockCheckVC.h"
//供应商
#import "SVSuppliersListVC.h"
//优惠券
#import "SVCouponVC.h"
#import "SVAddMoreSpecificationsVC.h"
#import "SVOtherLabelPrintingVC.h"

#import "SVLandingVC.h"
#import "SVLabelPrintingVC.h"
#import "SVModuleModel.h"
#import "SVNewStockCheckVC.h"
#import "SVHomeTopView.h"

#import "SVQuickDeductionVC.h"
#import "SVCardManagementVC.h"

//#import "SVIntelligentAnalysisDetailVC.h"
#import "SVSecondaryCardVC.h"
#import "SVBusinessReportVC.h"
#import "SVOnlineOrderVC.h"
#import "SVCollectionFlowVC.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#import "SVProcurementListVC.h"
#import "SVRefundGoodsVC.h"
#import "SVIntegralManagementVC.h"
#import "SVInfoNotice.h"
#import "SVMemberArrearsVC.h"
#import "IIGuideViewController.h"
#import "SVNewProductListVC.h"
#import "SVNewSupplierListVC.h"
#import "SVMembershipLevelMianList.h"

#define GetUserDefaut [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionUpdateNotice"]
#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
static NSString *tableViewCellID = @"tableViewCell";
static NSString *collectionViewID = @"collectionViewCell";
@interface SVHomeVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UINavigationControllerDelegate,IIGuideViewControllerDelegate>

@property (nonatomic,strong) SVHomeImgView *imgView;
//图片轮播
@property (nonatomic,strong) SDCycleScrollView *roastingView;
//Xib创建的三个view
@property (nonatomic,strong) SVHomeViewThree *threeView;
@property (nonatomic,strong) UICollectionView *view3;
@property (nonatomic,strong) UITableView *tableView;
//title数组
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *titleImg;
@property (nonatomic,strong) SVHomeTopView *homeTopView;
@property (nonatomic,assign) NSInteger GuidedGraph; // 等于1的时候才能调用
@end

@implementation SVHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTitleArray];
    self.view.backgroundColor = [UIColor whiteColor];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;

    NSLog(@"宽--%f，高---%f",ScreenW,ScreenH);

    
    //初始化并设置tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH  - BottomHeight - kTabbarHeight)];
    //self.tableView.backgroundColor = navigationBackgroundColor;
    //取消tableView的选中
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //指定collectionview代理
    self.view3.delegate = self;
    self.view3.dataSource = self;
    self.GuidedGraph = 1;
    //注册cell 必须，不然会崩溃
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册collectionView的cell
    [self.view3 registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewID];
    
    //    UIImageView *image = [[UIImageView alloc]init];
    //    image.image = [UIImage imageNamed:@"decerp"];
    //    [self.tableView addSubview:image];
    //    [image mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(self.tableView.mas_centerX);
    //        make.bottom.mas_equalTo(self.tableView).offset(-50);
    //    }];
    //    NSLog(@"[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)] = %@", [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)]);
    //    if (![[[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12,1)] isKindOfClass:[NSNull class]]) {
    //         [SVUserManager shareInstance].addShop = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)];
    //    }

    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
            
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
        }
        
    }

//    UIImageView *image = [[UIImageView alloc]init];
//    image.image = [UIImage imageNamed:@"decerp"];
//    [self.tableView addSubview:image];
//    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.tableView.mas_centerX);
//        make.bottom.mas_equalTo(self.tableView).offset(-50);
//    }];
//    NSLog(@"[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)] = %@", [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)]);
//    if (![[[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12,1)] isKindOfClass:[NSNull class]]) {
//         [SVUserManager shareInstance].addShop = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)];
//    }

    
    //    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
    //         [SVUserManager shareInstance].addShop = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+3,1)];
    //    }
    
    //    NSDictionary *dic =[SVUserManager shareInstance].sv_app_config_dic;
    //
    //    SVModuleModel *model = [SVModuleModel mj_objectWithKeyValues:dic];
    
    // NSLog(@"model.module = %@",model.module);
    
    //
    //  // NSString *module = dic[@"module"];
    //    NSLog(@"dicmodule = %@",[NSString stringWithFormat:@"%@",dic[@"module"]]);
    
    //  [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+number,1)]
    
    //
    
    self.navigationController.delegate = self;
    
    //提示更新
    [self checkVerionUpdate];
    
//    NSDictionary *launchOptions=[SVUserManager shareInstance].launchOptions;
//        // 点击通知打开app处理逻辑
//        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if(userInfo){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息"
//                                                                           message:[NSString stringWithFormat:@"%@", userInfo]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *act = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:act];
//            [self presentViewController:alert animated:YES completion:nil];
//            //统计客户端 通过push开启app行为
//            NSString *messageId = [userInfo objectForKey:@"_id_"];
//            if (messageId!=nil) {
//                [MiPushSDK openAppNotify:messageId];
//            }
//        }
    
    
    if (self.GuidedGraph == 1) {
         if (![NSUserDefaults.standardUserDefaults boolForKey:@"homePageSkipTutorial"]) {
             [IIGuideViewController showsInViewController:self];
        }
        
        self.GuidedGraph = 2;// 即使刷新也不要在进来
    }
       
   // [self performSelector:@selector(wangmumu:) withObject:@"100" afterDelay:1];
}

//- (void) wangmumu:(NSString *)han{
//    static dispatch_once_t hanwanjie;
//    //只执行一次
//    dispatch_once(&hanwanjie, ^{
//        [IIGuideViewController showsInViewController:self];
//    });
//    int niha = [han intValue] - 1;
//    if (niha == 10) {
//        return;
//    }
////    [self performSelector:@selector(hanwanjie:) withObject:[NSString stringWithFormat:@"%d",niha] afterDelay:1];
//}


///MARK: - IIGuideViewControllerDelegate
#pragma mark - 引导图代理方法
- (IIGuideItem *)guideViewController:(IIGuideViewController *)guideViewController itemForGuideAtIndex:(NSUInteger)index {
    CGRect frame = CGRectZero;
    CGFloat cornerRadius = 0.0;
    IIGuideItem *item = self.guideItems[index];
  
        if (index == 0) {
              frame = CGRectMake(0, ScreenH / 4, ScreenW / 4, 100);
             // frame = self.purpleView.frame;
              cornerRadius = 10.0;
          }else if (index == 1) {
              frame = CGRectMake(ScreenW / 4 *1, ScreenH / 4, ScreenW / 4, 100);
             // cornerRadius = CGRectGetHeight(frame) * 0.5;
          }
  
    item.frame = frame;
    item.cornerRadius = cornerRadius;
    return item;

}


-(void)guideViewControllerDidSelectNoLongerRemind:(IIGuideViewController *)guideViewController {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"homePageSkipTutorial"];
}

- (void)guideViewControllerDidSelectRemindMe:(IIGuideViewController *)guideViewController {
    //[J2NotificationView showWithStatus:@"下次进入App重新提醒"];
}

- (NSInteger)numberOfGuidesInGuideViewController:(IIGuideViewController *)guideViewController {
    return self.guideItems.count;
}

- (NSArray *)guideItems {
    IIGuideItem *item0 = IIGuideItem.new;
    
    item0.title = @"【新增会员】模块已迁移置【会员列表】内";
    
    IIGuideItem *item1 = IIGuideItem.new;
    item1.title = @"【新增商品】模块已迁移置【商品列表】内！";
    
   
    return @[item0,item1];
   
    
}


// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

#pragma mark - UITableViewDataSource
//展示几组
//展示几组//展示几组//展示几组
//展示几组//展示几组//展示几组
//展示几组//展示几组//展示几组
//展示几组//展示几组//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 3;
    return 2;
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
//        if (IS_iPhone_5) {
//            return 170;
//        }else{
            return ScreenH /4;
       // }
        
    } else {
//        if (IS_iPhone_5) {
//            return ScreenH-170-50-TopHeight-BottomHeight;
//        }else{
            return ScreenH-(ScreenH /4)- BottomHeight - kTabbarHeight;
       // }
        // return ScreenH-220-50-TopHeight-BottomHeight;
    }
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
    }
    

    
    //将view对号入座
    //    if (indexPath.section == 0) {
    //        [cell addSubview:self.imgView];
    //    } else if (indexPath.section == 1) {
    //        [cell addSubview:self.threeView];
    //    } else {
    //        [cell addSubview:self.view3];
    //    }
    

    if (indexPath.section == 0) {
//        [cell addSubview:self.imgView];
       
//        SVHomeTopView *view = [[NSBundle mainBundle] loadNibNamed:@"SVHomeTopView" owner:nil options:nil].lastObject;
//        view.frame = CGRectMake(0, 0, ScreenW, ScreenH /4);
         [cell addSubview:self.homeTopView];
//        [SVHomeTopView alloc] init

    } else {
        [cell addSubview:self.view3];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
    return self.titleArr.count;
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    SVHomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewID forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArr[indexPath.item];
    //    cell.img.image = self.titleImg[indexPath.item];
    cell.img.image = [UIImage imageNamed:self.titleImg[indexPath.item]];
    
    return cell;
    
}



#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {

//    return CGSizeMake (80,80);
    return CGSizeMake(ScreenW/4, 100);

}

//定义每个UICollectionView 的边距
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake (0,0,0,0);
}


#pragma mark - 点击跳转方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


    NSString *title = _titleArr[indexPath.row];
    if ([title isEqualToString:@"新增会员"]) {
         SVNewVipVC *tableVC = [[SVNewVipVC alloc]init];
         self.hidesBottomBarWhenPushed=YES;
               //跳转界面有导航栏的
        [self.navigationController pushViewController:tableVC animated:YES];
               //显示tabBar
        self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"新增商品"]){
        [SVUserManager loadUserInfo];
               if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]) {// 服装
                   SVAddMoreSpecificationsVC *addMoreSpecificationsVC = [[SVAddMoreSpecificationsVC alloc] initWithNibName:@"SVAddMoreSpecificationsVC" bundle:nil];
                                 self.hidesBottomBarWhenPushed=YES;
                                       //跳转界面有导航栏的
                                [self.navigationController pushViewController:addMoreSpecificationsVC animated:YES];
                                       //显示tabBar
                                self.hidesBottomBarWhenPushed=NO;
               }else{
                    SVNewWaresVC *tableVC = [[SVNewWaresVC alloc]init];
                   self.hidesBottomBarWhenPushed=YES;
                                       //跳转界面有导航栏的
                                [self.navigationController pushViewController:tableVC animated:YES];
                                       //显示tabBar
                                self.hidesBottomBarWhenPushed=NO;
               }
        
    }else if ([title isEqualToString:@"会员管理"]){
        [SVUserManager shareInstance].Tips = @"支付中。。。";
        [SVUserManager saveUserInfo];
       SVVipListVC *tableVC = [[SVVipListVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"日常支出"]){
        SVPayManagementVC *tableVC = [[SVPayManagementVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"商品管理"]){
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            SVNewProductListVC *tableVC = [[SVNewProductListVC alloc]init];
                 //   tableVC.controllerNum = 0;
                 self.hidesBottomBarWhenPushed=YES;
                       //跳转界面有导航栏的
                [self.navigationController pushViewController:tableVC animated:YES];
                       //显示tabBar
                self.hidesBottomBarWhenPushed=NO;
        }else{
            SVWaresListVC *tableVC = [[SVWaresListVC alloc]init];
            tableVC.controllerNum = 0;
            self.hidesBottomBarWhenPushed=YES;
            //跳转界面有导航栏的
            [self.navigationController pushViewController:tableVC animated:YES];
            //显示tabBar
            self.hidesBottomBarWhenPushed=NO;
        }

    }else if ([title isEqualToString:@"挂单列表"]){
         SVOrderListVC *tableVC = [[SVOrderListVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"库存盘点"]){
         
             SVNewStockCheckVC *tableVC = [[SVNewStockCheckVC alloc]init];
          
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"智能分析"]){
        [SVUserManager shareInstance].Tips = @"退款中。。。";
        [SVUserManager saveUserInfo];
        SVBusinessReportVC *tableVC = [[SVBusinessReportVC alloc]init];
        tableVC.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"进货"]){
        SVProcurementListVC *tableVC = [[SVProcurementListVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"退货"]){
        SVRefundGoodsVC *tableVC = [[SVRefundGoodsVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"供应商"]){
        SVSuppliersListVC *tableVC = [[SVSuppliersListVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"优惠券"]){
        SVCouponVC *tableVC = [[SVCouponVC alloc]init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"标签打印"]){
         SVLabelPrintingVC *tableVC = [[SVLabelPrintingVC alloc] init];
                         tableVC.controllerNum = 0;
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"快速扣次"]){
        [SVUserManager shareInstance].Tips = @"支付中。。。";
        [SVUserManager saveUserInfo];
       SVQuickDeductionVC *tableVC = [[SVQuickDeductionVC alloc] init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"次卡管理"]){
         SVCardManagementVC *tableVC = [[SVCardManagementVC alloc] init];
                   tableVC.view.backgroundColor = [UIColor whiteColor];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"收款流水"]){
        SVCollectionFlowVC *tableVC = [[SVCollectionFlowVC alloc] init];
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"订单核销"]){
           QQLBXScanViewController *vc = [QQLBXScanViewController new];
               vc.libraryType = [Global sharedManager].libraryType;
               vc.scanCodeType = [Global sharedManager].scanCodeType;
             //  vc.stockCheckVC = self;
               vc.style = [StyleDIY weixinStyle];
               vc.isStockPurchase = 3;
               self.hidesBottomBarWhenPushed=YES;
                     //跳转界面有导航栏的
              [self.navigationController pushViewController:vc animated:YES];
                     //显示tabBar
              self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"积分管理"]){
        [SVUserManager shareInstance].Tips = @"支付中。。。";
        [SVUserManager saveUserInfo];
        SVIntegralManagementVC *tableVC = [[SVIntegralManagementVC alloc] init];
         self.hidesBottomBarWhenPushed=YES;
               //跳转界面有导航栏的
        [self.navigationController pushViewController:tableVC animated:YES];
               //显示tabBar
        self.hidesBottomBarWhenPushed=NO;
    }else if ([title isEqualToString:@"消息公告"]){
        SVInfoNotice *tableVC = [[SVInfoNotice alloc] init];
         self.hidesBottomBarWhenPushed=YES;
               //跳转界面有导航栏的
        [self.navigationController pushViewController:tableVC animated:YES];
               //显示tabBar
        self.hidesBottomBarWhenPushed=NO;
        
    }else if ([title isEqualToString:@"会员对账"]){
        SVMemberArrearsVC *tableVC = [[SVMemberArrearsVC alloc] init];
         self.hidesBottomBarWhenPushed=YES;
               //跳转界面有导航栏的
        [self.navigationController pushViewController:tableVC animated:YES];
               //显示tabBar
        self.hidesBottomBarWhenPushed=NO;
        
    }else if([title isEqualToString:@"会员等级"]){
        
        SVMembershipLevelMianList *tableVC = [[SVMembershipLevelMianList alloc] init];
         self.hidesBottomBarWhenPushed=YES;
               //跳转界面有导航栏的
        [self.navigationController pushViewController:tableVC animated:YES];
               //显示tabBar
        self.hidesBottomBarWhenPushed=NO;
    }

    }

- (void)kaidanClick{
  
        // 给100，如果长度不够时，也可以点击
        SVSelectWaresVC *tableVC = [[SVSelectWaresVC alloc]init];
        tableVC.interface = 1;
          self.hidesBottomBarWhenPushed=YES;
                         //跳转界面有导航栏的
                  [self.navigationController pushViewController:tableVC animated:YES];
                         //显示tabBar
                  self.hidesBottomBarWhenPushed=NO;

}

- (void)shouyinClick{
    [SVUserManager shareInstance].Tips = @"支付中。。。";
    [SVUserManager saveUserInfo];
        // 给100，如果长度不够时，也可以点击
        SVQuickCashierVC *tableVC = [[SVQuickCashierVC alloc]init];
      //  [self setUpOperatorPrivilege:100 withUIViewController:tableVC];
        self.hidesBottomBarWhenPushed=YES;
                         //跳转界面有导航栏的
                  [self.navigationController pushViewController:tableVC animated:YES];
                         //显示tabBar
                  self.hidesBottomBarWhenPushed=NO;
}


-(void)setUpOperatorPrivilege:(NSInteger)number withUIViewController:(UIViewController *)VC{
    
    [SVUserManager loadUserInfo];
    NSLog(@"[SVUserManager shareInstance].sv_app_config]= %@",[SVUserManager shareInstance].sv_app_config);
    if (number == 100) {
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=YES;
        //跳转界面有导航栏的
        [self.navigationController pushViewController:VC animated:YES];
        //显示tabBar
        self.hidesBottomBarWhenPushed=NO;
        
    }else if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]){
        // NSDictionary *dic = [SVUserManager shareInstance].sv_app_config;
        NSString *nums = [SVUserManager shareInstance].sv_app_config;
        NSLog(@"nums.length = %ld",nums.length);
        
        if (number + 1 > nums.length) {
            //隐藏TabBar
            self.hidesBottomBarWhenPushed=YES;
            //跳转界面有导航栏的
            [self.navigationController pushViewController:VC animated:YES];
            //显示tabBar
            self.hidesBottomBarWhenPushed=NO;
        }else{
            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(number,1)];
            NSLog(@"num %@",num);
            
            if ([num isEqualToString:@"0"]) {
                [SVTool TextButtonAction:self.view withSing:@"亲,你还没有该权限"];
                return;
            }
            
            //隐藏TabBar
            self.hidesBottomBarWhenPushed=YES;
            //跳转界面有导航栏的
            [self.navigationController pushViewController:VC animated:YES];
            //显示tabBar
            self.hidesBottomBarWhenPushed=NO;
        }
        
    }
    
    
    
    
}

/** 点击图片回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

#pragma mark - 懒加载
- (SVHomeImgView *)imgView {
    if (!_imgView) {
        _imgView = [[SVHomeImgView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH/3)];
        _imgView.image = [UIImage imageNamed:@"banner2"];
    }
    return _imgView;
}

- (SVHomeTopView *)homeTopView{
    if (!_homeTopView) {
        _homeTopView = [[NSBundle mainBundle] loadNibNamed:@"SVHomeTopView" owner:nil options:nil].lastObject;
        _homeTopView.frame = CGRectMake(0, 0, ScreenW, ScreenH /4);
        [_homeTopView.kaidanClick addTarget:self action:@selector(kaidanClick) forControlEvents:UIControlEventTouchUpInside];
         [_homeTopView.shouyinClick addTarget:self action:@selector(shouyinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _homeTopView;
}

-(SDCycleScrollView *)roastingView{
    if (!_roastingView) {
        //        NSArray *imageNames = @[@"Carousel_162-1", @"Carousel_162-2"]; // 本地图片请填写全名
        NSArray *imageNames = @[@"Carousel_162-1"];
        if (IS_iPhone_5) {
            _roastingView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 170) shouldInfiniteLoop:NO imageNamesGroup:imageNames];
        }else{
            _roastingView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 220) shouldInfiniteLoop:NO imageNamesGroup:imageNames];
        }
        
        _roastingView.delegate = self;
        //往上播，默认是往右播
        //_roastingView.scrollDirection = UICollectionViewScrollDirectionVertical;
        //         --- 轮播时间间隔，默认1.0秒，可自定义
        _roastingView.autoScrollTimeInterval = 4.0;
    }
    return _roastingView;
}

- (SVHomeViewThree *)threeView {
    if (!_threeView) {
        _threeView = [[NSBundle mainBundle]loadNibNamed:@"SVHomeViewThree" owner:nil options:nil].lastObject;
        _threeView.frame = CGRectMake(0, 0, ScreenW, 70);
        _threeView.dateOne.textColor = RGBA(126, 126, 126, 1);
        _threeView.dateTwo.textColor = RGBA(126, 126, 126, 1);
        _threeView.dateThree.textColor = RGBA(126, 126, 126, 1);
        
        //拿到token
        [SVUserManager loadUserInfo];
        NSString *token = [SVUserManager shareInstance].access_token;
        
        //拼接URL
        NSString *urlStr = [URLhead stringByAppendingString:@"/system/index?key="];
        NSString *sURL = [urlStr stringByAppendingFormat:@"%@",token];
        //请求数据
        [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *values = dict[@"values"];
            NSString *day = values[@"day"];//今天
            NSString *tday = values[@"tday"];//昨天
            _threeView.moneyOne.text = day;
            _threeView.ratioOne.text = tday;
            NSString *week = values[@"week"];//本周
            NSString *tweek = values[@"tweek"];//上周
            _threeView.moneyTwo.text = week;
            _threeView.ratioTwo.text = tweek;
            NSString *mon = values[@"mon"];//本月
            NSString *tmon = values[@"tmon"];//上月
            _threeView.moneyThree.text = mon;
            _threeView.ratioThree.text = tmon;
            
            
            if (tday > 0) {
                _threeView.ratioOne.textColor = [UIColor redColor];
                _threeView.imgOne.image = [UIImage imageNamed:@"ic_02"];
            }else{
                _threeView.ratioOne.textColor = RGBA(26, 197, 56, 1);
                _threeView.imgOne.image = [UIImage imageNamed:@"ic_01"];
            }
            
            if (tweek > 0) {
                _threeView.ratioTwo.textColor = [UIColor redColor];
                _threeView.imgTwo.image = [UIImage imageNamed:@"ic_02"];
            }else{
                _threeView.ratioTwo.textColor = RGBA(26, 197, 56, 1);
                _threeView.imgTwo.image = [UIImage imageNamed:@"ic_01"];
            }
            
            if (tmon > 0) {
                _threeView.ratioThree.textColor = [UIColor redColor];
                _threeView.imgThree.image = [UIImage imageNamed:@"ic_02"];
            }else{
                _threeView.ratioThree.textColor = RGBA(26, 197, 56, 1);
                _threeView.imgThree.image = [UIImage imageNamed:@"ic_01"];
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
        
    }
    return _threeView;
}

- (UICollectionView *)view3 {
    if (!_view3) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置垂直间距
        layout.minimumLineSpacing = 0;
        //设置水平间距
        layout.minimumInteritemSpacing = 0;
        // 设置滚动的方向
        //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //初始化collectionview,并作设置
        _view3 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-(ScreenH / 4)- BottomHeight - kTabbarHeight) collectionViewLayout:layout];
        _view3.showsVerticalScrollIndicator = NO;
        _view3.backgroundColor = [UIColor whiteColor];
        
    }
    return _view3;
}


- (void)loadTitleArray {
//    if (!_titleArr) {

        _titleArr = [NSMutableArray array];
        _titleImg = [NSMutableArray array];
       [SVUserManager loadUserInfo];
        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        if (kDictIsEmpty(sv_versionpowersDict)) {
//               [_titleArr addObject:@"新增会员"];
//               [_titleImg addObject:@"ic_xzhy"];
//            [_titleArr addObject:@"新增商品"];
//            [_titleImg addObject:@"ic_xzsp"];
            [_titleArr addObject:@"会员管理"];
                                         [_titleImg addObject:@"huiuan"];
            [_titleArr addObject:@"商品管理"];
            [_titleImg addObject:@"shangping"];
            
            [_titleArr addObject:@"日常支出"];
            [_titleImg addObject:@"ic_zcgl"];
           
            [_titleArr addObject:@"挂单列表"];
            [_titleImg addObject:@"guidan"];
            [_titleArr addObject:@"库存盘点"];
            [_titleImg addObject:@"pandian"];
            [_titleArr addObject:@"智能分析"];
            [_titleImg addObject:@"Intelligentanalysis"];
            [_titleArr addObject:@"进货"];
            [_titleImg addObject:@"home_Purchase"];
            [_titleArr addObject:@"退货"];
            [_titleImg addObject:@"home_returngoods"];
            [_titleArr addObject:@"供应商"];
            [_titleImg addObject:@"gongyingshang"];
            [_titleArr addObject:@"优惠券"];
                                   [_titleImg addObject:@"youhuiquan"];
                            [_titleArr addObject:@"标签打印"];
                                   [_titleImg addObject:@"dayin"];
                            
                            if ([[SVUserManager shareInstance].sv_uit_cache_name containsString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name containsString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name containsString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name containsString:@"cache_name_auto_beauty"]
                                || [[SVUserManager shareInstance].sv_uit_cache_name containsString:@"cache_name_beta"]) {
                                
                                [_titleArr addObject:@"快速扣次"];
                                              [_titleImg addObject:@"kouci"];
                                       
                                [_titleArr addObject:@"次卡管理"];
                                              [_titleImg addObject:@"ic_cika"];
                            }
                            
                           
                            
                            [_titleArr addObject:@"收款流水"];
                                   [_titleImg addObject:@"liushui"];
                            [_titleArr addObject:@"订单核销"];
                            [_titleImg addObject:@"WriteOff"];
            [_titleArr addObject:@"积分管理"];
            [_titleImg addObject:@"Integralmanagement"];
            
            [_titleArr addObject:@"会员对账"];
            [_titleImg addObject:@"MemberArrears"];
            
            [_titleArr addObject:@"会员等级"];
            [_titleImg addObject:@"membershipLevel"];
            
//            [_titleArr addObject:@"消息公告"]; 搜索会员添加搜索车牌号 移动端的接口
//            [_titleImg addObject:@"Integralmanagement"];
        }else{
             NSDictionary *MemberDic = sv_versionpowersDict[@"Member"];

                    
                          NSString *MemberList = [NSString stringWithFormat:@"%@",MemberDic[@"MemberList"]];
            if ([MemberList isEqualToString:@"1"] || kStringIsEmpty(MemberList)) {
                               [_titleArr addObject:@"会员管理"];
                               [_titleImg addObject:@"huiuan"];
                          };
            
            NSDictionary *CommodityManagetDic = sv_versionpowersDict[@"CommodityManage"];
                 NSString *CommodityList = [NSString stringWithFormat:@"%@",CommodityManagetDic[@"CommodityList"]];
               if ([CommodityList isEqualToString:@"1"]) {
                       [_titleArr addObject:@"商品管理"];
                       [_titleImg addObject:@"shangping"];
                  };
                   
                    NSDictionary *DailyExpDic = sv_versionpowersDict[@"DailyExp"];
                    NSString *ExpAdd = [NSString stringWithFormat:@"%@",DailyExpDic[@"ExpAdd"]];
                     NSString *ExpInfo = [NSString stringWithFormat:@"%@",DailyExpDic[@"ExpInfo"]];
                   NSString *ExpAnalysis = [NSString stringWithFormat:@"%@",DailyExpDic[@"ExpAnalysis"]];
               
            if ([ExpAdd isEqualToString:@"1"]||[ExpInfo isEqualToString:@"1"]||[ExpAnalysis isEqualToString:@"1"]) {
                          [_titleArr addObject:@"日常支出"];
                          [_titleImg addObject:@"ic_zcgl"];
                     };
                    
                    
                    [_titleArr addObject:@"挂单列表"];
                    [_titleImg addObject:@"guidan"];
                    
                   NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
                                NSString *Inventory = [NSString stringWithFormat:@"%@",StockManageDic[@"Inventory"]];
                              if ([Inventory isEqualToString:@"1"] || kStringIsEmpty(Inventory)) {
                                      [_titleArr addObject:@"库存盘点"];
                                      [_titleImg addObject:@"pandian"];
                                 };
                    
                    
                    
                    NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
                                   NSString *DailyAnalysis = [NSString stringWithFormat:@"%@",AnalyticsDic[@"DailyAnalysis"]];
                                 if ([DailyAnalysis isEqualToString:@"1"] || kStringIsEmpty(DailyAnalysis)) {
                                        [_titleArr addObject:@"智能分析"];
                                         [_titleImg addObject:@"Intelligentanalysis"];
                                    };
//            NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
                  // StockManageDic[@"CommodityPurchase"] CommodityPurchase
            NSString *CommodityPurchase = [NSString stringWithFormat:@"%@",StockManageDic[@"CommodityPurchase"]];
            if ([CommodityPurchase isEqualToString:@"1"] || kStringIsEmpty(CommodityPurchase)) {
                [_titleArr addObject:@"进货"];
                [_titleImg addObject:@"home_Purchase"];
            }
            
            NSString *ReturnGoods = [NSString stringWithFormat:@"%@",StockManageDic[@"ReturnGoods"]];
            if ([ReturnGoods isEqualToString:@"1"] || kStringIsEmpty(ReturnGoods)) {
                  [_titleArr addObject:@"退货"];
                  [_titleImg addObject:@"home_returngoods"];
            }
                  
                    
                  //  NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
                                        NSString *PurchaseManage = [NSString stringWithFormat:@"%@",StockManageDic[@"PurchaseManage"]];
                                      if ([PurchaseManage isEqualToString:@"1"] || kStringIsEmpty(PurchaseManage)) {
                                             [_titleArr addObject:@"供应商"];
                                             [_titleImg addObject:@"gongyingshang"];
                                         };
                   
                    
                    [_titleArr addObject:@"优惠券"];
                           [_titleImg addObject:@"youhuiquan"];
                    [_titleArr addObject:@"标签打印"];
                           [_titleImg addObject:@"dayin"];
                    
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]
                        || [[SVUserManager shareInstance].sv_uit_cache_name containsString:@"cache_name_beta"]) {
                        
                        [_titleArr addObject:@"快速扣次"];
                                      [_titleImg addObject:@"kouci"];
                         
                        NSString *MembershipSetMealCard = [NSString stringWithFormat:@"%@",MemberDic[@"MembershipSetMealCard"]];
                        if (kStringIsEmpty(MembershipSetMealCard)) {
                            [_titleArr addObject:@"次卡管理"];
                            [_titleImg addObject:@"ic_cika"];
                        }else{
                            if ([MembershipSetMealCard isEqualToString:@"1"]) {
                                [_titleArr addObject:@"次卡管理"];
                                [_titleImg addObject:@"ic_cika"];
                            }else{
                               
                            }
                        }
                       
                    }
                    
                   
                    
                    [_titleArr addObject:@"收款流水"];
                           [_titleImg addObject:@"liushui"];
                    [_titleArr addObject:@"订单核销"];
                    [_titleImg addObject:@"WriteOff"];
            [_titleArr addObject:@"积分管理"];
            [_titleImg addObject:@"Integralmanagement"];
            
            [_titleArr addObject:@"会员对账"];
            [_titleImg addObject:@"MemberArrears"];
            
            [_titleArr addObject:@"会员等级"];
            [_titleImg addObject:@"membershipLevel"];
        }
      

        
  
//        _titleArr = @[@"新增会员",
//                      @"收银",
//                      @"开单",
//                      @"新增商品",
//                      @"会员管理",
//                      @"日常支出",
////                      @"查询销售",
//                      @"商品管理",
//                      @"挂单列表",
//                      @"库存盘点",
//                      @"智能分析",
//                      @"供应商",
//                      @"优惠券",
//                      @"标签打印",
//                      @"快速扣次",
//                      @"次卡管理",
//                      @"收款流水",
//                      @"订单核销",
////                      @"智能分析",
////                      @"线上订单",
//                      ];

  //  }

}



#pragma mark - 设置状态栏颜色
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    if (@available(iOS 13.0, *)) {
//          UIView *statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
//          statusBar.backgroundColor = [UIColor redColor];;
//          [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
//    }else{

}

-(void)viewWillDisappear:(BOOL)animated

{

    [super viewWillDisappear:animated];

    if (@available(iOS 13.0, *)) {

            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;//文字是黑色

    } else {

            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//文字黑色

    }

}

//并收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 判断是否需要提示更新App
-(void) checkVerionUpdate{
    
    QJCheckVersionUpdate *update = [[QJCheckVersionUpdate alloc]init];
//    [QJCheckVersionUpdate updateblock];
    [update showAlertView];
    
    
    
        //http://itunes.apple.com/CN/lookup?id=1128257396
        //http://itunes.apple.com/lookup?id=1234441733
        
//        NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",APPID];
//    //    storeString = [storeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *storeURL = [NSURL URLWithString:storeString];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
//        [request setHTTPMethod:@"POST"];
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            if ( [data length] > 0 && !error ) {
//                // Success
//                NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                NSLog(@"appData = %@",appData);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // All versions that have been uploaded to the AppStore
//                    NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
//                    NSLog(@"versionsInAppStore = %@",versionsInAppStore);
//                    /**
//                     *  以上网络请求可以改成自己封装的类
//                     */
//                    if(![versionsInAppStore count]) {
//                        //请求到的版本数据不对就走这里
//                        //NSLog(@"No versions of app in AppStore -- 在AppStore中没有应用程序版本");
//                        return;
//                    }else {
//                        NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
//
//                        [SVUserManager loadUserInfo];
//                        //旧版本
//                        [SVUserManager shareInstance].sv_oldVersion = OLDVERSION;
//                        //新版本
//                        [SVUserManager shareInstance].sv_newVersion = currentAppStoreVersion;
//                        [SVUserManager saveUserInfo];
//
////                        if ([QJCheckVersionUpdate versionlessthan:OLDVERSION Newer:currentAppStoreVersion])//[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut :
////                        {
////                            //版本号相同就走这里
////                            //NSLog(@"暂不更新");
////                        }else{
////                            //提示更新的走这里
////                          //  NSLog(@"请到appstore更新%@版本",currentAppStoreVersion);
////                            /**
////                             *  修复问题描述
////                             */
////                            [NSObject saveObj:@"YES" withKey:@"isNotFirstIn"];
////                            NSString *describeStr = [[[appData valueForKey:@"results"] valueForKey:@"releaseNotes"] objectAtIndex:0];
////                            NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
////                            if (updateblock) {
////                                updateblock(currentAppStoreVersion,dataArr);
////                            }
////                        }
//                    }
//
//                });
//            }
//
//        }];
    
    
}




@end

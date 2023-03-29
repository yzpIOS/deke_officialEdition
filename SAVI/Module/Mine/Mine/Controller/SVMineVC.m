//
//  SVMineVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVMineVC.h"
#import "SVMineOneCell.h"
#import "SVMineCell.h"
#import "SVLandingVC.h"
#import "SVInformationVC.h"
#import "SVFeedbackVC.h"
#import "SVAboutWeVC.h"
//打印设置
#import "SVBluetoothVC.h"
//版本
#import "SVVersionVC.h"

#import "SVModifyInformationVC.h"
//系统设置
#import "SVSystemSettingsVC.h"
//邀请有礼
#import "SVInvitesCourtesyVC.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#import "SVAboutUsVC.h"

#define URL [NSString stringWithFormat:@"%@",@"http://m.decerp.cn/apply.html"]

// http://m.decerp.cn/apply.html

//全局cell
static NSString *MineOneCellID = @"MineOneCell";
static NSString *MineCellID = @"MineCell";
static NSString *CycleScrollID = @"CycleScrollCell";

@interface SVMineVC ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) NSArray *arr1;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,strong) NSArray *arr2;
//@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UITableView *tableView;

//定义一个进度条属性
//@property(retain,nonatomic) UIProgressView * progressV;

@property (nonatomic,strong) SVMineOneCell *mineView;

//图片轮播
@property (nonatomic,strong) SDCycleScrollView *roastingView;

@property (nonatomic,strong) NSMutableArray *imageArr_big;

@property (nonatomic,strong) NSMutableArray *urlImageArray;
@property (nonatomic,strong) NSMutableArray *urlLinkArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation SVMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
   //  [self judgeShowAdsViewRequest];
    [SVUserManager loadUserInfo];
    //设置导航标题
    if ([SVTool isBlankString:[SVUserManager shareInstance].sv_ul_name] || [[SVUserManager shareInstance].sv_ul_name isEqualToString:@"<null>"]) {
        self.navigationItem.title = nil;
    } else {
        self.navigationItem.title = [SVUserManager shareInstance].sv_ul_name;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mineView = [[NSBundle mainBundle]loadNibNamed:@"SVMineOneCell" owner:nil options:nil].lastObject;
    self.mineView.frame = CGRectMake(0, 0, ScreenW, 85);
    
    self.mineView.iconImg.layer.cornerRadius = 27.5;
    //UIImageView切圆的时候就要用到这一句了
    self.mineView.iconImg.layer.masksToBounds = YES;
    NSString *imgURL = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_logo];
    if (![SVTool isBlankString:imgURL]) {
        [self.mineView.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:imgURL]] placeholderImage:[UIImage imageNamed:@"iconView"]];
    }
   
    
    //店名
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_name]) {
        self.mineView.Name.text = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
    } else {
        self.mineView.Name.text = @"未设置";
    }
    self.mineView.phone.text = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].user_id];
    self.mineView.version.text = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_versionname];
    self.mineView.version.layer.cornerRadius = 3;
    self.mineView.version.layer.masksToBounds = YES;
    //添加到View上
    [self.view addSubview:self.mineView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 85, ScreenW, ScreenH-TopHeight-BottomHeight-85-kTabbarHeight) style:UITableViewStyleGrouped];
    //RGBA(241, 241, 241, 1)
//    self.tableView.backgroundColor = RGBA(246, 246, 246, 1);
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = NO;
//    } else {
//        // Fallback on earlier versions
//    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    // UITableViewStyleGrouped样式时，隐藏上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    /** 去除tableview 右侧滚动条 */
    self.tableView.showsVerticalScrollIndicator = NO;
    // 设置距离左右各10的距离
//    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    //完全没有线
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //跟默认的差不多
    //_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //去掉多余的分割线,显示cell还有线
    //self.tableView.tableFooterView = [[UIView alloc]init];
    //适配ios11
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //添加到View上
    [self.view addSubview:self.tableView];
    
    //指定代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMineOneCell" bundle:nil] forCellReuseIdentifier:MineOneCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCMineCell" bundle:nil] forCellReuseIdentifier:MineCellID];
    //普通cell的注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CycleScrollID];
    
    
    //添加事件
    UIButton *touchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 85)];
    [touchButton addTarget:self action:@selector(touchButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchButton];
    
   // [SVUserManager shareInstance].bannersConfig
}




-(void)touchButtonResponseEvent {
    
    self.hidesBottomBarWhenPushed = YES;
    //------ 设置个人信息 --------//
    SVInformationVC *tableVC = [[SVInformationVC alloc]init];
    __weak typeof(self) weakSelf = self;
    tableVC.informationBlock = ^{
        [SVUserManager loadUserInfo];
        NSString *imgURL = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_logo];
        if (![SVTool isBlankString:imgURL]) {
            [weakSelf.mineView.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:imgURL]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        }
        //店名
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_name]) {
            weakSelf.mineView.Name.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
        } else {
            weakSelf.mineView.Name.text = @"未设置";
        }
        
        weakSelf.navigationItem.title = [SVUserManager shareInstance].sv_ul_name;
    };
    //跳转界面有导航栏的
    [self.navigationController pushViewController:tableVC animated:YES];
    //跳转回来显示tabBar
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
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
    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



#pragma mark - TableDataSource
//展示几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

//每组展示几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(section == 0){
//        return 2;
//    }
    if(section == 1){
        return self.arr1.count;
    }
    
    return 1;
    
}

//组与组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 85;
    }
    return 55;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SVUserManager loadUserInfo];
    if (indexPath.section == 0) {

            //创建cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CycleScrollID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CycleScrollID];
            }
            [cell addSubview:self.roastingView];
            return cell;

    }
    

    if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
        //设置字体的大小
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = self.arr1[indexPath.row];
        cell.textLabel.textColor = GlobalFontColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
//        if (indexPath.row == 1) {
//            //点击分享不高亮
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
        return cell;
    }
    
    if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:@"mine_systerm_setting_icon"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = GlobalFontColor;
        cell.textLabel.text = @"系统设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (![[SVUserManager shareInstance].sv_oldVersion isEqualToString:[SVUserManager shareInstance].sv_newVersion]){
            UILabel *Vlabel = [[UILabel alloc]init];
            Vlabel.font = [UIFont systemFontOfSize:10];
            Vlabel.backgroundColor = RGBA(200, 30, 30, 1);
            //Vlabel.text = [NSString stringWithFormat:@"  v%@  ",[SVUserManager shareInstance].sv_newVersion];
            Vlabel.text = [NSString stringWithFormat:@"  %@  ",@"NEW"];
            Vlabel.textColor = [UIColor whiteColor];
            Vlabel.layer.cornerRadius = 6;
            Vlabel.layer.masksToBounds = YES;
            [cell addSubview:Vlabel];
            [Vlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.right.mas_equalTo(cell).offset(-30);
            }];
        }
        return cell;
    }
    
    if (indexPath.section == 3){
        SVMineCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SVMineCell" owner:nil options:nil].lastObject;
        
        return cell;
    }
    

    
    return nil;
}

//设置组与的距离
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    //隐藏tabBar
    self.hidesBottomBarWhenPushed = YES;
//    //------ 设置个人信息 --------//
//    if (indexPath.section == 0 && indexPath.row == 0) {
//
//        SVInformationVC *tableVC = [[SVInformationVC alloc]init];
//        //跳转界面有导航栏的
//        [self.navigationController pushViewController:tableVC animated:YES];
//        //跳转回来显示tabBar
//        self.hidesBottomBarWhenPushed = NO;
//    }
    
    //扫码登录
    if (indexPath.section == 1 && indexPath.row == 0) {
    

        //           self.hidesBottomBarWhenPushed = YES;
        //           SVScanCodeLoginVC *VC = [[SVScanCodeLoginVC alloc]init];
        //         //  VC.interface = 1;
        //           [self.navigationController pushViewController:VC animated:YES];
        //           self.hidesBottomBarWhenPushed = NO;
                   //添加一些扫码或相册结果处理
                self.hidesBottomBarWhenPushed = YES;
                QQLBXScanViewController *vc = [QQLBXScanViewController new];
                vc.libraryType = [Global sharedManager].libraryType;
                vc.scanCodeType = [Global sharedManager].scanCodeType;
                vc.selectNumber = 1;
                vc.isStockPurchase = 4;// 0是盘点
               // vc.stockCheckVC = self;
                vc.style = [StyleDIY weixinStyle];
                [self.navigationController pushViewController:vc animated:YES];
                  self.hidesBottomBarWhenPushed = NO;
              //  self.LBXScanViewVc = vc;
              //  __weak __typeof(self) weakSelf = self;
               
    }
    //打印设置
    if (indexPath.section == 1 && indexPath.row ==1) {
        SVBluetoothVC *VC = [[SVBluetoothVC alloc]init];
            VC.interface = 1;
            [self.navigationController pushViewController:VC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
          
        //朋友分享
        //[self shareButtonResponseEvent];
        
     
    }
    //帮助中心
//    if (indexPath.section == 1 && indexPath.row == 2) {
//
//        //邀请有礼
//             SVInvitesCourtesyVC *VC = [[SVInvitesCourtesyVC alloc]init];
//             [self.navigationController pushViewController:VC animated:YES];
//             self.hidesBottomBarWhenPushed = NO;
//
//    }
    //打印设置

    //邀请有礼
    if (indexPath.section == 1 && indexPath.row == 2) {
        
//        SVWebViewVC *VC = [[SVWebViewVC alloc]init];
//        //        VC.url = @"http://www.decerp.cn";
//                VC.url = @"http://m.decerp.cn/help.html";
//                [self.navigationController pushViewController:VC animated:YES];
//                self.hidesBottomBarWhenPushed = NO;
        
        //邀请有礼
        SVInvitesCourtesyVC *VC = [[SVInvitesCourtesyVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
        //self.hidesBottomBarWhenPushed = YES;
       
    }
    //反馈问题
    if (indexPath.section == 1 && indexPath.row == 3) {
        //self.hidesBottomBarWhenPushed = YES;
//        SVAboutWeVC *VC = [[SVAboutWeVC alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
        
        SVFeedbackVC *VC = [[SVFeedbackVC alloc]init];
               [self.navigationController pushViewController:VC animated:YES];
               self.hidesBottomBarWhenPushed = NO;
        
//         SVWebViewVC *VC = [[SVWebViewVC alloc]init];
//        //        VC.url = @"http://www.decerp.cn";
//        [SVUserManager loadUserInfo];
//        NSString *urlStr = [NSString stringWithFormat:@"http://buy.decerp.cc?user_id=%@",[SVUserManager shareInstance].user_id];
//                VC.url = urlStr;
//                [self.navigationController pushViewController:VC animated:YES];
//                self.hidesBottomBarWhenPushed = NO;
    }
    
    //德客学院
    if (indexPath.section == 1 && indexPath.row == 4) {
        //self.hidesBottomBarWhenPushed = YES;
//        SVVersionVC *VC = [[SVVersionVC alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
        
        SVWebViewVC *VC = [[SVWebViewVC alloc]init];
        //        VC.url = @"http://www.decerp.cn";
                VC.url = @"https://school.decerp.cc/";
                [self.navigationController pushViewController:VC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
    }
    
    // 联系客服
    if (indexPath.section == 1 && indexPath.row == 5) {
        //self.hidesBottomBarWhenPushed = YES;
//        SVVersionVC *VC = [[SVVersionVC alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
        
        SVAboutUsVC *VC = [[SVAboutUsVC alloc]init];
        //        VC.url = @"http://www.decerp.cn";
//                VC.url = @"https://school.decerp.cc/";
                [self.navigationController pushViewController:VC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
    }
    
    //系统设置
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        SVSystemSettingsVC *VC = [[SVSystemSettingsVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }
    
    //------ 退出登陆按钮 --------//
    if (indexPath.section == 3 && indexPath.row == 0) {
        
        //隐藏
        self.hidesBottomBarWhenPushed = YES;
        //清除帐号
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"bigName_Arr"];
        [defaults removeObjectForKey:@"bigID_Arr"];
        //[defaults setObject:@"" forKey:@"account"];
        //[defaults setObject:@"" forKey:@"passwd"];
        [defaults synchronize];
        
//        //清除沙盒
//        [SVUserManager removeUserInfo];
//        ///
//        [SVUserManager tearDown];
 
        SVLandingVC *mainVC = [[SVLandingVC alloc] init];
        mainVC.selectNum = 1;
           UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
          [UIApplication sharedApplication].keyWindow.rootViewController = Nav;

    }
     



}

//分享按钮响应方法
- (void)shareButtonResponseEvent{
    
    NSArray *titlearr = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间"];
    NSArray *imageArr = @[@"share_Wechat",@"share_WechatT",@"share_qq",@"share_Qzone"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"德客" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        
//        URL = [NSString stringWithFormat:@"http://www.decerp.cc/Share?u=%@&s=iOS",[SVUserManager shareInstance].user_id];
        [SVUserManager loadUserInfo];
        if (btnTag==0) {//微信好友
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"https://itunes.apple.com/us/app/ke-shou-yin-ji-zhang-ruan/id1128257396?l=zh&ls=1&mt=8";//下载连接
            [UMSocialData defaultData].extConfig.wechatSessionData.url = URL;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"德客软件店铺管理专家";//标题
            //说明内容和设置图片/还有个回调
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatSession] content:@"店铺出入存,商品管理,智能分析,会员管理,商品管理--下载" image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                  //  NSLog(@"分享成功！");
                }
            }];
        }
        if (btnTag==1) {//微信朋友圈
//            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"https://itunes.apple.com/us/app/ke-shou-yin-ji-zhang-ruan/id1128257396?l=zh&ls=1&mt=8";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = URL;
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"德客软件店铺管理专家";
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatTimeline] content:@"店铺出入存,商品管理,智能分析,会员管理,商品管理--下载" image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                   // NSLog(@"分享成功！");
                }
            }];
        }
        if (btnTag==2) {//QQ
//            [UMSocialData defaultData].extConfig.qqData.url = @"https://itunes.apple.com/us/app/ke-shou-yin-ji-zhang-ruan/id1128257396?l=zh&ls=1&mt=8";
            [UMSocialData defaultData].extConfig.qqData.url = URL;
            
            [UMSocialData defaultData].extConfig.qqData.title = @"德客软件店铺管理专家";
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQQ] content:@"店铺出入存,商品管理,智能分析,会员管理,商品管理--下载" image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
        if (btnTag==3) {//QQ空间
//            [UMSocialData defaultData].extConfig.qzoneData.url = @"https://itunes.apple.com/us/app/ke-shou-yin-ji-zhang-ruan/id1128257396?l=zh&ls=1&mt=8";
            [UMSocialData defaultData].extConfig.qzoneData.url = URL;
            
            [UMSocialData defaultData].extConfig.qzoneData.title = @"德客软件店铺管理专家";
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQzone] content:@"店铺出入存,商品管理,智能分析,会员管理,商品管理--下载" image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
    self.hidesBottomBarWhenPushed = NO;
    
}

//并收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告");
}

#pragma mark - 懒加载
-(NSArray *)arr1{
    if (!_arr1) {

        _arr1 = @[@"扫码登录",@"打印设置",@"邀请有礼",@"反馈问题",@"德客学院",@"联系客服"];

    }
    return _arr1;
}

-(NSArray *)imageArr{
    if (!_imageArr) {

        _imageArr = @[@"diannao_small",@"mine_printer",@"mine_recommend_icon",@"mine_feedback_question_icon",@"dekeSchool",@"guanyuwomen"];
     
    }
    return _imageArr;
}

-(NSArray *)arr2{
    if (!_arr2) {
        _arr2 = @[@"开店论坛",@"打印设置",@"系统设置"];
    }
    return _arr2;
}

-(SDCycleScrollView *)roastingView{
    [SVUserManager loadUserInfo];
   NSArray *bannersConfig = [SVUserManager shareInstance].bannersConfig;
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    if (!kArrayIsEmpty(bannersConfig)) {
        for (NSDictionary *dict in bannersConfig) {
         NSString *sv_enabled = dict[@"sv_enabled"];
            if ([sv_enabled integerValue] == 1) {
                [dataArray addObject:dict];
                [imagesURLStrings addObject:dict[@"sv_ad_img"]];
            }
          
        }
    }
    
    self.dataArray = dataArray;
    
    if (!kArrayIsEmpty(dataArray)) {
        _roastingView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 85)imageURLStringsGroup:imagesURLStrings]; // 模拟网络延时情景
            //cycleScrollView2.pageControlAliment =SDCycleScrollViewPageContolAlimentRight;
             _roastingView.delegate = self;
           // cycleScrollView2.titlesGroup = titles;
           // cycleScrollView2.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
           // cycleScrollView2.placeholderImage = [UIImageimageNamed:@"placeholder"];
            // _roastingView.imageURLStringsGroup = imagesURLStrings;
    }else{
        NSArray *imageNames = @[@"Carousel_agent"]; // 本地图片请填写全名
               _roastingView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 85) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
             _roastingView.delegate = self;
             //往上播，默认是往右播
             //_roastingView.scrollDirection = UICollectionViewScrollDirectionVertical;
             //         --- 轮播时间间隔，默认1.0秒，可自定义
             _roastingView.autoScrollTimeInterval = 4.0;
    }
        
    
    //

    return _roastingView;
}



/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (kArrayIsEmpty(self.dataArray)) {
        [SVUserManager loadUserInfo];
       // if (kArrayIsEmpty(self.urlImageArray)) {
             self.hidesBottomBarWhenPushed = YES;
                   SVWebViewVC *webViewVC = [[SVWebViewVC alloc]init];
                   webViewVC.url = URL;
                   [self.navigationController pushViewController:webViewVC animated:YES];
                   self.hidesBottomBarWhenPushed = NO;
    }else{
        NSDictionary *dict =self.dataArray[index];
        NSString *sv_ad_canskip=dict[@"sv_ad_canskip"];
        if ([sv_ad_canskip intValue] == 1) {
            NSString *sv_ad_link = dict[@"sv_ad_link"];
             self.hidesBottomBarWhenPushed = YES;
                   SVWebViewVC *webViewVC = [[SVWebViewVC alloc]init];
                   webViewVC.url = sv_ad_link;
                   [self.navigationController pushViewController:webViewVC animated:YES];
                   self.hidesBottomBarWhenPushed = NO;
        }
      
    }
    

}

- (NSMutableArray *)urlImageArray{
    if (!_urlImageArray) {
        _urlImageArray = [NSMutableArray array];
    }
    return _urlImageArray;
}

- (NSMutableArray *)urlLinkArray{
    if (!_urlLinkArray) {
        _urlLinkArray = [NSMutableArray array];
    }
    return _urlLinkArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

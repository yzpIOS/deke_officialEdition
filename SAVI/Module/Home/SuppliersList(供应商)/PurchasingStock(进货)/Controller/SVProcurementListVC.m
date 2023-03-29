//
//  SVProcurementListVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVProcurementListVC.h"
//详情
#import "SVPurchaseDeteilsVC.h"
//日期XIB
#import "SVDatePickerView.h"
//cell
#import "SVProcurementListCell.h"
//新增进货
#import "SVaddPurchaseVC.h"

static NSString *ProcurementCellID = @"ProcurementCell";
@interface SVProcurementListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIButton *addButton;

//四个按钮
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;

//时间三个按钮
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIButton *oneDateButton;
@property (weak, nonatomic) IBOutlet UIButton *twoDateButton;
@property (weak, nonatomic) IBOutlet UIButton *queryButton;

//四个数组对应该四个按钮点击事件
@property(nonatomic, strong) NSMutableArray *oneModelArr;
@property(nonatomic, strong) NSMutableArray *twoModelArr;
@property(nonatomic, strong) NSMutableArray *threeModelArr;
@property(nonatomic, strong) NSMutableArray *fourModelArr;

@property (nonatomic,strong) NSMutableDictionary *dicCell;
@property (nonatomic,strong) NSMutableDictionary *dicRefund;

//记录刷新次数
@property (nonatomic,assign) NSInteger onePage;
@property (nonatomic,assign) NSInteger twoPage;
@property (nonatomic,assign) NSInteger threePage;
@property (nonatomic,assign) NSInteger fourPage;

//记录点击的按钮
@property (nonatomic,assign) NSInteger buttonNum;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *oneDatePicker;

//遮盖view
@property (nonatomic,strong) UIView *maskTwoView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *twoDatePicker;
@property (nonatomic,assign) BOOL isLookPrice;
/*
 1.第一次请求
 2.上拉刷新请求
 3.四个按钮请求
 4.筛选请求
 5.一键入库后重新刷新请求
 */

@end

@implementation SVProcurementListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
    NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
    if ([StockManage isEqualToString:@"0"]) {
        self.isLookPrice = NO;
    }else{
        self.isLookPrice = YES;
    }
    
    //显示tabBar
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"进货管理";
    
   
    
    //时间选择
    NSString *date = [NSString stringWithFormat:@"  %@",[SVTool timeAcquireCurrentDate]];
    
    [self.oneDateButton setTitle:date forState:UIControlStateNormal];
    self.oneDateButton.layer.cornerRadius = 1;
    self.oneDateButton.layer.borderColor = RGBA(223, 223, 223, 1).CGColor;
    self.oneDateButton.layer.borderWidth = 0.5f;
    self.oneDateButton.layer.masksToBounds = YES;
    
    [self.twoDateButton setTitle:date forState:UIControlStateNormal];
    self.twoDateButton.layer.cornerRadius = 1;
    self.twoDateButton.layer.borderColor = RGBA(223, 223, 223, 1).CGColor;
    self.twoDateButton.layer.borderWidth = 0.5f;
    self.twoDateButton.layer.masksToBounds = YES;
    
    self.queryButton.layer.cornerRadius = 1;
    self.queryButton.layer.masksToBounds = YES;
    
    self.dateView.hidden = YES;
    //默认选中今天按钮
    [self.oneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.oneButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //取消tableView的选中
    //tableView.allowsSelection = NO;
    //滚动条
    self.tableView.showsVerticalScrollIndicator = YES;
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVProcurementListCell" bundle:nil] forCellReuseIdentifier:ProcurementCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-64-40));
        make.top.mas_equalTo(self.oneButton.mas_bottom);
    }];
    
    if (!(self.controllerNum == 1)) {
        //正确创建方式，这样显示的图片就没有问题了
//        UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"screening_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfoButtonResponseEvent)];
//        self.navigationItem.rightBarButtonItem = rightButon;
        
        //底部按钮
        UIButton *button = [[UIButton alloc]init];
        button.layer.cornerRadius = 22.5;
        [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
        [button addTarget:self action:@selector(addButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.bottom.mas_equalTo(self.view).offset(-30);
            make.right.mas_equalTo(self.view).offset(-30);
        }];
    }
    
    
    self.onePage = 1;
    self.twoPage = 1;
    self.threePage = 1;
    self.fourPage = 1;
    self.buttonNum = 1;
#pragma mark -  第一次请求
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
//    [self requestDay:@"1" StartDate:nil EndDate:nil State:self.oneState Page:self.onePage Top:20];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    //调用请求
    [self requestDay:@"0" StartDate:currentTimeString EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.oneState Page:self.onePage Top:20];
    
#pragma mark -  下拉刷新请求
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        if (self.buttonNum == 1) {
            self.onePage = 1;
            if (!(self.controllerNum == 1)) {
                self.oneState = 0;
            }
            [self.oneModelArr removeAllObjects];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            NSDate *datenow = [NSDate date];
            
            //----------将nsdate按formatter格式转成nsstring
            
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            //调用请求
            [self requestDay:@"0" StartDate:currentTimeString EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.oneState Page:self.onePage Top:20];
        }
        if (self.buttonNum == 2) {
            self.twoPage = 1;
            if (!(self.controllerNum == 1)) {
                self.twoState = 0;
            }
            [self.twoModelArr removeAllObjects];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            // NSDate *datenow = [NSDate date];
            
            NSDate *date = [NSDate date];//当前时间
            
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
            
            NSString *currentTimeString = [formatter stringFromDate:lastDay];
            //调用请求
            [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",currentTimeString] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.twoState Page:self.twoPage Top:20];
        }
        if (self.buttonNum == 3) {
            self.threePage = 1;
            if (!(self.controllerNum == 1)) {
                self.threeState = 0;
            }
            [self.threeModelArr removeAllObjects];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            NSDate *datenow = [NSDate date];
            
            //----------将nsdate按formatter格式转成nsstring
            
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            
            //调用请求
            NSString *week = [self currentScopeWeek];
                   //提示加载中
                //   [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
                   [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",week] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.threeState Page:self.threePage Top:20];
          //  [self requestDay:@"0" StartDate:nil EndDate:nil State:self.threeState Page:self.threePage Top:20];
        }
        if (self.buttonNum == 4) {
            self.fourPage = 1;
            if (!(self.controllerNum == 1)) {
                self.fourState = 0;
            }
            [self.fourModelArr removeAllObjects];
            [self dateRequestResponseEvent];
        }
        
    }];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    //[header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //[header setImages:pullingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    //[header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    //header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    //header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
#pragma mark -  上拉刷新请求
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        if (self.buttonNum == 1) {
            self.onePage ++;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                       
                       // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                       
                       [formatter setDateFormat:@"yyyy-MM-dd"];
                       
                       //现在时间,你可以输出来看下是什么格式
                       
                       NSDate *datenow = [NSDate date];
                       
                       //----------将nsdate按formatter格式转成nsstring
                       
                       NSString *currentTimeString = [formatter stringFromDate:datenow];
            //调用请求
            [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",currentTimeString] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.oneState Page:self.onePage Top:20];
        }
        if (self.buttonNum == 2) {
            self.twoPage ++;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            // NSDate *datenow = [NSDate date];
            
            NSDate *date = [NSDate date];//当前时间
            
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
            
            NSString *currentTimeString = [formatter stringFromDate:lastDay];
            //调用请求
           [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",currentTimeString] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.twoPage Page:self.twoPage Top:20];
        }
        if (self.buttonNum == 3) {
            self.threePage ++;
            //调用请求
//            [self requestDay:@"0" StartDate:nil EndDate:nil State:self.threeState Page:self.threePage Top:20];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            NSDate *datenow = [NSDate date];
            
            //----------将nsdate按formatter格式转成nsstring
            
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            
            //调用请求
            NSString *week = [self currentScopeWeek];
                   //提示加载中
                //   [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
                   [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",week] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.threeState Page:self.threePage Top:20];
        }
        if (self.buttonNum == 4) {
            self.fourPage ++;
            
            [self dateRequestResponseEvent];
        }
        
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    
    // 设置正在刷新状态的动画图片
    [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
  //  [self setUpNav];
    
}

#pragma mark - 添加导航栏的右侧两个右侧按钮
- (void)setUpNav{
    UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [informationCardBtn addTarget:self action:@selector(sousuoRightBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    
    [informationCardBtn setImage:[UIImage imageNamed:@"sousuo_black"] forState:UIControlStateNormal];
    
    [informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];

    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 15;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(shaixuanRightBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"screening_icon_black"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];

    self.navigationItem.rightBarButtonItems  = @[informationCardItem,fixedSpaceBarButtonItem,settingBtnItem];
}

- (void)sousuoRightBtnCLick{
    
}

- (void)shaixuanRightBtnCLick{
    
}

# pragma mark - 请求数据
-(void)requestDay:(NSString *)day StartDate:(NSString *)start_date EndDate:(NSString *)end_date State:(NSInteger)state Page:(NSInteger)page Top:(NSInteger)top{
    
    //提示加载中
    //    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Repertory/get_procurement?key=%@&day=%@&start_date=%@&end_data=%@&date=&page=%ld&top=%ld&mintotal=0.0&maxtotal=1000000.0&keywards=",token,day,start_date,end_date,(long)page,(long)top];
    NSLog(@"strURL = %@",strURL);
    
    NSString *utf = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *Arr = dic[@"values"];
        
        //        //当=1的时候
        //        if (self.onePage == 1 && self.buttonNum == 1 && ![SVTool isEmpty:self.oneModelArr]) {
        //            [self.oneModelArr removeAllObjects];
        //        }
        //        if (self.twoPage == 1 && self.buttonNum == 2 && ![SVTool isEmpty:self.twoModelArr]) {
        //            [self.twoModelArr removeAllObjects];
        //        }
        //        if (self.threePage == 1 && self.buttonNum == 3 && ![SVTool isEmpty:self.threeModelArr]) {
        //            [self.threeModelArr removeAllObjects];
        //        }
        //        if (self.fourPage == 1 && self.buttonNum == 4 && ![SVTool isEmpty:self.fourModelArr]) {
        //            [self.fourModelArr removeAllObjects];
        //        }
        
        if (![SVTool isEmpty:Arr]) {
            
            for (NSDictionary *diction in Arr) {
                
                NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                [dataDict setObject:diction[@"sv_suname"] forKey:@"sv_suname"];
                [dataDict setObject:diction[@"sv_pc_cdate"] forKey:@"sv_pc_cdate"];
                [dataDict setObject:diction[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
                [dataDict setObject:diction[@"sv_pc_total"] forKey:@"sv_pc_total"];
                [dataDict setObject:diction[@"sv_pc_statestr"] forKey:@"sv_pc_statestr"];
                [dataDict setObject:diction[@"sv_productname"] forKey:@"sv_productname"];
                [dataDict setObject:diction[@"prlist"] forKey:@"Prlist"];
                [dataDict setObject:diction[@"sv_orgwarehouse_id"] forKey:@"sv_orgwarehouse_id"];
                [dataDict setObject:diction[@"sv_suid"] forKey:@"sv_suid"];
                [dataDict setObject:diction[@"sv_pc_note"] forKey:@"sv_pc_note"];
                [dataDict setObject:diction[@"sv_pc_combined"] forKey:@"sv_pc_combined"];
                [dataDict setObject:diction[@"sv_pc_costs"] forKey:@"sv_pc_costs"];
                [dataDict setObject:diction[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
                [dataDict setObject:diction[@"sv_pc_state"] forKey:@"sv_pc_state"];//判断是否入库
                [dataDict setObject:diction[@"sv_pc_realpay"] forKey:@"sv_pc_realpay"];
                [dataDict setObject:diction[@"sv_associated_code"] forKey:@"sv_associated_code"];
                
                
                if (self.buttonNum == 1) {
                    [self.oneModelArr addObject:dataDict];
                }
                if (self.buttonNum == 2) {
                    [self.twoModelArr addObject:dataDict];
                }
                if (self.buttonNum == 3) {
                    [self.threeModelArr addObject:dataDict];
                }
                if (self.buttonNum == 4) {
                    [self.fourModelArr addObject:dataDict];
                }
                
            }
            
            
            
            //            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            //                /** 普通闲置状态 */
            //                self.tableView.mj_footer.state = MJRefreshStateIdle;
            //            }
            
        } else {
            /** 所有数据加载完毕，没有更多的数据了 */
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        [self.tableView reloadData];
        
        //是否正在刷新
        if ([self.tableView.mj_header isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }
        
        //是否正在刷新
        if ([self.tableView.mj_footer isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}

#pragma mark - 四个按钮的响应方法
#pragma mark -  四个按钮请求
- (IBAction)oneButtonResponseEvent {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    self.dateView.hidden = YES;
    //高亮
    [self setSelectedButton:self.oneButton];
    
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.threeButton];
    [self setDefaultButton:self.fourButton];
    
    self.buttonNum = 1;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    
    if ([SVTool isEmpty:self.oneModelArr]) {
        self.onePage = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",currentTimeString] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.onePage Page:self.onePage Top:20];
    }
    [self.tableView reloadData];
}

- (IBAction)twoButtonResponseEvent {// 昨天
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    // NSDate *datenow = [NSDate date];
    
    NSDate *date = [NSDate date];//当前时间
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    
    NSString *currentTimeString = [formatter stringFromDate:lastDay];
    
    self.dateView.hidden = YES;
    //高亮
    [self setSelectedButton:self.twoButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.threeButton];
    [self setDefaultButton:self.fourButton];
    
    self.buttonNum = 2;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    
    if ([SVTool isEmpty:self.twoModelArr]) {
        self.twoPage = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",currentTimeString] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.twoState Page:self.twoPage Top:20];
    }
    [self.tableView reloadData];
    
}

- (IBAction)threeButtonResponseEvent { // 本周
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    self.dateView.hidden = YES;
    //高亮
    [self setSelectedButton:self.threeButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.fourButton];
    
    self.buttonNum = 3;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    
    if ([SVTool isEmpty:self.threeModelArr]) {
        self.threePage = 1;
         NSString *week = [self currentScopeWeek];
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",week] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",currentTimeString] State:self.threeState Page:self.threePage Top:20];
    }
    [self.tableView reloadData];
    
}

/**
 当前周的日期范围
 
 @return 结果字符串
 */
- (NSString *)currentScopeWeek {
    // 默认周一为第一天，1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    return [self currentScopeWeek:2 dateFormat:@"yyyy-MM-dd"];
}

- (NSString *)currentScopeWeek:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    // 1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    calendar.firstWeekday = firstWeekday;
    
    // 日历单元
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    unsigned unitNewFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowComponents = [calendar components:unitFlag fromDate:nowDate];
    // 获取今天是周几，需要用来计算
    NSInteger weekDay = [nowComponents weekday];
    // 获取今天是几号，需要用来计算
    NSInteger day = [nowComponents day];
    // 计算今天与本周第一天的间隔天数
    NSInteger countDays = 0;
    // 特殊情况，本周第一天firstWeekday比当前星期weekDay小的，要回退7天
    if (calendar.firstWeekday > weekDay) {
        countDays = 7 + (weekDay - calendar.firstWeekday);
    } else {
        countDays = weekDay - calendar.firstWeekday;
    }
    // 获取这周的第一天日期
    NSDateComponents *firstComponents = [calendar components:unitNewFlag fromDate:nowDate];
    [firstComponents setDay:day - countDays];
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    
    // 获取这周的最后一天日期
    NSDateComponents *lastComponents = firstComponents;
    [lastComponents setDay:firstComponents.day + 6];
    NSDate *lastDate = [calendar dateFromComponents:lastComponents];
    
    // 输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *firstDay = [formatter stringFromDate:firstDate];
    NSString *lastDay = [formatter stringFromDate:lastDate];
    
    return [NSString stringWithFormat:@"%@",firstDay];
}


- (IBAction)fourButtonResponseEvent {
    
    self.dateView.hidden = NO;
    //高亮
    [self setSelectedButton:self.fourButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.threeButton];
    
    self.buttonNum = 4;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    
    [self.tableView reloadData];
}

-(void)setSelectedButton:(UIButton *)btn {
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
    
    if (self.dateView.hidden == YES) {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-64-40));
            make.top.mas_equalTo(self.oneButton.mas_bottom);
        }];
        
    } else {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-64-40-50));
            make.top.mas_equalTo(self.oneButton.mas_bottom).offset(50);
        }];
        
    }
}

//改变按钮字体颜色
-(void)setDefaultButton:(UIButton *)btn {
    //默认
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateNormal];
    
}

//选择第一个时间
- (IBAction)oneDayButtonResponseEvent {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.oneDatePicker];
    
}

//选择第二个时间
- (IBAction)twoDayButtonResponseEvent {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.twoDatePicker];
    
}

//时间查询按钮响应方法
- (IBAction)queryButtonResponseEvent {
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDateButton.titleLabel.text format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDateButton.titleLabel.text format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        
        NSString *oneD = [self.oneDateButton.titleLabel.text substringWithRange:NSMakeRange(2, 10)];
        NSString *twoD = [self.twoDateButton.titleLabel.text substringWithRange:NSMakeRange(2, 10)];
        
        [self.fourModelArr removeAllObjects];
        
        //调用请求
        self.fourPage = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",oneD] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",twoD] State:self.fourState Page:self.fourPage Top:20];
        [self.tableView reloadData];
    }
    
}

//新增进货
-(void)addButtonResponseEvent {
    SVaddPurchaseVC *VC = [[SVaddPurchaseVC alloc]init];
    VC.selectNumber = 1;// 进货的
    __weak typeof(self) weakSelf = self;
    VC.addPurchaseBlock = ^{
        [weakSelf.oneModelArr removeAllObjects];
        [weakSelf oneButtonResponseEvent];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -  筛选请求
//右上角反应方法
-(void)releaseInfoButtonResponseEvent {
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"   已入库" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = GlobalFontColor;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:15.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"   待审核" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = GlobalFontColor;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:15.0f];
    
    NSArray *items = @[menuTitle,logoutItem];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:GreyFontColor];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待审核，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
                self.onePage = 1;
                self.twoPage = 1;
                self.threePage = 1;
                self.fourPage = 1;
                
                self.oneState = 2;
                self.twoState = 2;
                self.threeState = 2;
                self.fourState = 2;
                
                if (self.buttonNum == 1) {
                    self.onePage = 1;
                    [self.oneModelArr removeAllObjects];
                    [self requestDay:@"1" StartDate:nil EndDate:nil State:2 Page:1 Top:20];
                }
                if (self.buttonNum == 2) {
                    [self.twoModelArr removeAllObjects];
                    [self requestDay:@"-1" StartDate:nil EndDate:nil State:2 Page:1 Top:20];
                    
                }
                if (self.buttonNum == 3) {
                    [self.threeModelArr removeAllObjects];
                    [self requestDay:@"2" StartDate:nil EndDate:nil State:2 Page:1 Top:20];
                }
                if (self.buttonNum == 4) {
                    [self.fourModelArr removeAllObjects];
                    [self dateRequestResponseEvent];
                }
            }
                break;
                
            case 1:
            {
                self.onePage = 1;
                self.twoPage = 1;
                self.threePage = 1;
                self.fourPage = 1;
                
                self.oneState = 1;
                self.twoState = 1;
                self.threeState = 1;
                self.fourState = 1;
                
                if (self.buttonNum == 1) {
                    self.onePage = 1;
                    [self.oneModelArr removeAllObjects];
                    [self requestDay:@"1" StartDate:nil EndDate:nil State:1 Page:1 Top:20];
                }
                if (self.buttonNum == 2) {
                    [self.twoModelArr removeAllObjects];
                    [self requestDay:@"-1" StartDate:nil EndDate:nil State:1 Page:1 Top:20];
                    
                }
                if (self.buttonNum == 3) {
                    [self.threeModelArr removeAllObjects];
                    [self requestDay:@"2" StartDate:nil EndDate:nil State:1 Page:1 Top:20];
                }
                if (self.buttonNum == 4) {
                    [self.fourModelArr removeAllObjects];
                    [self dateRequestResponseEvent];
                }
            }
                break;
            default:
                break;
        }
    }];
    
}

- (void)dateRequestResponseEvent {
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDateButton.titleLabel.text format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDateButton.titleLabel.text format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        
        NSString *oneD = [self.oneDateButton.titleLabel.text substringWithRange:NSMakeRange(2, 10)];
        NSString *twoD = [self.twoDateButton.titleLabel.text substringWithRange:NSMakeRange(2, 10)];
        //调用请求
        // [self requestDay:@"3" StartDate:oneD EndDate:twoD State:self.fourState Page:self.fourPage Top:20];
        [self requestDay:@"0" StartDate:[NSString stringWithFormat:@"%@ 00:00:00",oneD] EndDate:[NSString stringWithFormat:@"%@ 23:59:59",twoD] State:self.fourState Page:self.fourPage Top:20];
    }
    
}

-(void)logout {
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.buttonNum == 1) {
        return self.oneModelArr.count;
    }
    if (self.buttonNum == 2) {
        return self.twoModelArr.count;
    }
    if (self.buttonNum == 3) {
        return self.threeModelArr.count;
    }
    //    if (self.buttonNum == 4) {
    return self.fourModelArr.count;
    //    }
    
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVProcurementListCell *cell = [tableView dequeueReusableCellWithIdentifier:ProcurementCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVProcurementListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProcurementCellID];
    }
    
    if (self.buttonNum == 1) {
        if (self.oneModelArr.count > indexPath.row) {
            self.dicCell = self.oneModelArr[indexPath.row];
            //            cell.sv_pc_noid.text = self.dicCell[@"sv_pc_noid"];
            //            cell.sv_pc_statestr.text = self.dicCell[@"sv_pc_statestr"];
            //            cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            //            cell.sv_suname.text = self.dicCell[@"sv_suname"];
            cell.sv_pc_noid.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_noid"]];
            if ([self.dicCell[@"sv_pc_statestr"] containsString:@"待审核"]) {
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = NO;
            }else{
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = YES;
            }
            
            if (self.isLookPrice == true) {
                cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            }else{
                cell.sv_pc_total.text = @"****";
            }
            
            //            cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            if ([SVTool isBlankString:self.dicCell[@"sv_suname"]]) {
                cell.sv_suname.text = nil;
            } else {
                cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            }
        }
    }
    if (self.buttonNum == 2) {
        if (self.twoModelArr.count > indexPath.row) {
            self.dicCell = self.twoModelArr[indexPath.row];
            //            cell.sv_pc_noid.text = self.dicCell[@"sv_pc_noid"];
            //            cell.sv_pc_statestr.text = self.dicCell[@"sv_pc_statestr"];
            //            cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            //            cell.sv_suname.text = self.dicCell[@"sv_suname"];
            cell.sv_pc_noid.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_noid"]];
            // cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
            // NSString *a = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
            // a containsString:<#(nonnull NSString *)#>
            if ([self.dicCell[@"sv_pc_statestr"] containsString:@"待审核"]) {
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = NO;
            }else{
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = YES;
            }
         //   cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            if (self.isLookPrice == true) {
                           cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
                       }else{
                           cell.sv_pc_total.text = @"****";
                       }
            //            cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            if ([SVTool isBlankString:self.dicCell[@"sv_suname"]]) {
                cell.sv_suname.text = nil;
            } else {
                cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            }
        }
    }
    if (self.buttonNum == 3) {
        if (self.threeModelArr.count > indexPath.row) {
            self.dicCell = self.threeModelArr[indexPath.row];
            //            cell.sv_pc_noid.text = self.dicCell[@"sv_pc_noid"];
            //            cell.sv_pc_statestr.text = self.dicCell[@"sv_pc_statestr"];
            //            cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            //            cell.sv_suname.text = self.dicCell[@"sv_suname"];
            cell.sv_pc_noid.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_noid"]];
            //  cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
            if ([self.dicCell[@"sv_pc_statestr"] containsString:@"待审核"]) {
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = NO;
            }else{
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = YES;
            }
          //  cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            if (self.isLookPrice == true) {
                           cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
                       }else{
                           cell.sv_pc_total.text = @"****";
                       }
            //            cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            if ([SVTool isBlankString:self.dicCell[@"sv_suname"]]) {
                cell.sv_suname.text = nil;
            } else {
                cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            }
        }
    }
    if (self.buttonNum == 4) {
        if (self.fourModelArr.count > indexPath.row) {
            self.dicCell = self.fourModelArr[indexPath.row];
            //            cell.sv_pc_noid.text = self.dicCell[@"sv_pc_noid"];
            //            cell.sv_pc_statestr.text = self.dicCell[@"sv_pc_statestr"];
            //            cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            //            cell.sv_suname.text = self.dicCell[@"sv_suname"];
            cell.sv_pc_noid.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_noid"]];
            // cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
            if ([self.dicCell[@"sv_pc_statestr"] containsString:@"待审核"]) {
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = NO;
            }else{
                cell.sv_pc_statestr.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_pc_statestr"]];
                cell.caogaoLabel.hidden = YES;
            }
           // cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
            if (self.isLookPrice == true) {
                           cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
                       }else{
                           cell.sv_pc_total.text = @"****";
                       }
            //            cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            if ([SVTool isBlankString:self.dicCell[@"sv_suname"]]) {
                cell.sv_suname.text = nil;
            } else {
                cell.sv_suname.text = [NSString stringWithFormat:@"%@",self.dicCell[@"sv_suname"]];
            }
        }
    }
    
    //cell.sv_pc_noid.text = self.dicCell[@"sv_pc_noid"];
    //cell.sv_pc_statestr.text = self.dicCell[@"sv_pc_statestr"];
    //cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"] floatValue]];
    //cell.sv_suname.text = self.dicCell[@"sv_suname"];
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark -  一键入库后重新刷新请求
//点击响应方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SVPurchaseDeteilsVC *VC = [[SVPurchaseDeteilsVC alloc]init];
    
    __weak typeof(self) weakSelf = self;
    if (self.buttonNum == 1) {
        if (self.controllerNum == 1) {
            
            if (self.procurementListBlock) {
                self.procurementListBlock(self.oneModelArr[indexPath.row]);
            }
            //返回上一控制器
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            VC.dic = self.oneModelArr[indexPath.row];
            VC.purchaseDeteilsBlock = ^{
                weakSelf.onePage = 1;
                [weakSelf.oneModelArr removeAllObjects];
                [weakSelf requestDay:@"1" StartDate:nil EndDate:nil State:weakSelf.oneState Page:weakSelf.onePage Top:20];
                
            };
            
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if (self.buttonNum == 2) {
        if (self.controllerNum == 1) {
            if (self.procurementListBlock) {
                self.procurementListBlock(self.twoModelArr[indexPath.row]);
            }
            //返回上一控制器
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            VC.dic = self.twoModelArr[indexPath.row];
            VC.purchaseDeteilsBlock = ^{
                weakSelf.twoPage = 1;
                [weakSelf.twoModelArr removeAllObjects];
                [weakSelf requestDay:@"-1" StartDate:nil EndDate:nil State:weakSelf.twoState Page:weakSelf.twoPage Top:20];
            };
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    if (self.buttonNum == 3) {
        if (self.controllerNum == 1) {
            if (self.procurementListBlock) {
                self.procurementListBlock(self.threeModelArr[indexPath.row]);
            }
            //返回上一控制器
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            VC.dic = self.threeModelArr[indexPath.row];
            VC.purchaseDeteilsBlock = ^{
                weakSelf.threePage = 1;
                [weakSelf.threeModelArr removeAllObjects];
                [weakSelf requestDay:@"2" StartDate:nil EndDate:nil State:weakSelf.threeState Page:weakSelf.threePage Top:20];
            };
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    if (self.buttonNum == 4) {
        if (self.controllerNum == 1) {
            if (self.procurementListBlock) {
                self.procurementListBlock(self.fourModelArr[indexPath.row]);
            }
            //返回上一控制器
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            VC.dic = self.fourModelArr[indexPath.row];
            VC.purchaseDeteilsBlock = ^{
                weakSelf.fourPage = 1;
                [weakSelf.fourModelArr removeAllObjects];
                
                NSInteger temp = [SVDateTool cTimestampFromString:weakSelf.oneDateButton.titleLabel.text format:@"yyyy-MM-dd"];
                NSInteger tempi = [SVDateTool cTimestampFromString:weakSelf.twoDateButton.titleLabel.text format:@"yyyy-MM-dd"];
                if (temp > tempi) {
                    [SVTool TextButtonAction:weakSelf.view withSing:@"输入时间有误"];
                } else {
                    NSString *oneD = [weakSelf.oneDateButton.titleLabel.text substringWithRange:NSMakeRange(2, 10)];
                    NSString *twoD = [weakSelf.twoDateButton.titleLabel.text substringWithRange:NSMakeRange(2, 10)];
                    //调用请求
                    [weakSelf requestDay:@"3" StartDate:oneD EndDate:twoD State:weakSelf.fourState Page:weakSelf.fourPage Top:20];
                }
            };
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    
    
}

#pragma mark - 懒加载
-(NSMutableArray *)oneModelArr{
    if (!_oneModelArr) {
        _oneModelArr = [NSMutableArray array];
    }
    return _oneModelArr;
}
-(NSMutableArray *)twoModelArr{
    if (!_twoModelArr) {
        _twoModelArr = [NSMutableArray array];
    }
    return _twoModelArr;
}
-(NSMutableArray *)threeModelArr{
    if (!_threeModelArr) {
        _threeModelArr = [NSMutableArray array];
    }
    return _threeModelArr;
}
-(NSMutableArray *)fourModelArr{
    if (!_fourModelArr) {
        _fourModelArr = [NSMutableArray array];
    }
    return _fourModelArr;
}

-(NSMutableDictionary *)dicCell{
    if (!_dicCell) {
        _dicCell = [NSMutableDictionary dictionary];
    }
    return _dicCell;
}

-(SVDatePickerView *)oneDatePicker{
    if (!_oneDatePicker) {
        _oneDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _oneDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _oneDatePicker.center = CGPointMake(ScreenW/2, ScreenH/2);
        _oneDatePicker.backgroundColor = [UIColor whiteColor];
        _oneDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_oneDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _oneDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _oneDatePicker.datePickerView.maximumDate = minDate;
        
        [_oneDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_oneDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneDatePicker;
}

/**
 日期遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

//点击手势的点击事件
- (void)dateDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.oneDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:self.oneDatePicker.datePickerView.date]];
    [self.oneDateButton setTitle:date forState:UIControlStateNormal];
    
    
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.oneDatePicker removeFromSuperview];
}


/**
 第二个日期选择
 */
-(SVDatePickerView *)twoDatePicker{
    if (!_twoDatePicker) {
        _twoDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _twoDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _twoDatePicker.center = CGPointMake(ScreenW/2, ScreenH/2);
        _twoDatePicker.backgroundColor = [UIColor whiteColor];
        _twoDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_twoDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _twoDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _twoDatePicker.datePickerView.maximumDate = minDate;
        
        [_twoDatePicker.dateCancel addTarget:self action:@selector(twotwoDateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_twoDatePicker.dateDetermine addTarget:self action:@selector(twoDateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoDatePicker;
}

//日期遮盖View
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twotwoDateCancelResponseEvent)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}

//点击手势的点击事件
- (void)twoDateCancelResponseEvent {
    
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:self.twoDatePicker.datePickerView.date]];
    [self.twoDateButton setTitle:date forState:UIControlStateNormal];
    
}

//点击手势的点击事件
- (void)twotwoDateCancelResponseEvent {
    
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    
}



@end

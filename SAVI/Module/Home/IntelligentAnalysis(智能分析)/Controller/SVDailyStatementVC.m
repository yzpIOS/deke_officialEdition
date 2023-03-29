//
//  SVDailyStatementVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/4.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVDailyStatementVC.h"
#import "SVColorCell.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"
//字体大小
#define TextFont    14
#define BigFont    15
#define CentreFont  12
#define SmallFont   11

//现金
#define colorA  RGBA(226, 134, 207, 1)
//微信
#define colorB  RGBA(130, 131, 214, 1)
//银行卡
#define colorC  RGBA(250, 193, 103, 1)
//储值卡
#define colorD  RGBA(129, 211, 38, 1)
//支付宝
#define colorE  RGBA(141, 228, 51, 1)
//美团
#define colorF  RGBA(182, 232, 241, 1)
//口碑
#define colorG  RGBA(215, 210, 190, 1)
//闪惠
#define colorH  RGBA(178, 178, 170, 1)
//赊账
#define colorI  RGBA(168, 145, 163, 1)

// 美团
#define colorJ  RGBA(34, 195, 188, 1)
// 口碑
#define colorK  RGBA(228, 69, 30, 1)

#define WeakSelf __block __weak typeof(self)weakSelf = self;

static NSString *const ColorCellID = @"SVColorCell";
@interface SVDailyStatementVC ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>{
     JWBluetoothManage * manage;
}

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *sixView;

@property (nonatomic,strong) NSMutableArray *colorArrM_3;
@property (nonatomic,strong) NSMutableArray *moneyArrM_3;
@property (nonatomic,strong) NSMutableArray *item3_array;
@property (weak, nonatomic) IBOutlet UIView *payChartView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//饼图属性
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic, strong) PNPieChart *conmusePieChart;
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;
@property (weak, nonatomic) IBOutlet UILabel *dingdanNum;
@property (weak, nonatomic) IBOutlet UILabel *tuikuanMoney;
@property (weak, nonatomic) IBOutlet UILabel *xinzengMember;
@property (weak, nonatomic) IBOutlet UILabel *countNumber;
@property (weak, nonatomic) IBOutlet UILabel *miandanjine;// 免单金额
@property (weak, nonatomic) IBOutlet UILabel *zhekoujine;// 折扣金额
@property (weak, nonatomic) IBOutlet UILabel *xianjinjieyu;// 现金结余
@property (nonatomic,strong) NSMutableArray *consumeData;
@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *memberBottmView;
@property (weak, nonatomic) IBOutlet UIView *consumeBottomView;
@property (weak, nonatomic) IBOutlet UIView *consumeView;

@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;

@property (weak, nonatomic) IBOutlet UIView *memberBigView;

@property (weak, nonatomic) IBOutlet UIView *consumeBigView;

@property (nonatomic,strong) UITableView *twoTableView;
@property (nonatomic,strong) UITableView *threeTableView;

@property (weak, nonatomic) IBOutlet UIView *memberStoredValueView;
@property (weak, nonatomic) IBOutlet UIView *SufficientTimeView;
@property (nonatomic,strong) NSArray *memberChargeDataArray;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (nonatomic,strong) NSMutableArray *livemodelArray;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;
@property (nonatomic,strong) NSDictionary *dailyDict;
@property (weak, nonatomic) IBOutlet UIView *cikaObjectView;

@property (weak, nonatomic) IBOutlet UILabel *cikaNum;
@property (weak, nonatomic) IBOutlet UILabel *cikaMoney;
@property (weak, nonatomic) IBOutlet UILabel *chuzhiMoney; //储值和充次合计

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberStoreHeight;
//@property (weak, nonatomic) IBOutlet UIView *sufficientHight;
//@property (weak, nonatomic) IBOutlet UIView *fourViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sufficientHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cikaObjectHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveViewHeight;

@property (weak, nonatomic) IBOutlet UIView *refundView;
@property (weak, nonatomic) IBOutlet UILabel *tuihuoMoney;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixViewHeight;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;

@property (weak, nonatomic) IBOutlet UIView *threeSmallView;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSDictionary *timeDict;
//@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *operation;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixViewTopConst;

@end

@implementation SVDailyStatementVC

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message = nil;
    switch (central.state) {
        case 1:
            message = @"该设备不支持蓝牙功能,请检查系统设置";
            break;
        case 2:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 3:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 4:
            message = @"蓝牙未打开";
            break;
        case 5:
            message = @"蓝牙已经成功开启，可以打印";
            break;
        default:
            break;
    }
    if([message isEqualToString:@"蓝牙未打开"]) {
        [SVTool TextButtonAction:self.view withSing:message];
    } else {
//        //用延迟来作提示
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([SVTool isBlankString:self.printeName]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:message];
            }
       // });
    }
}



- (NSArray *)memberChargeDataArray
{
    if (!_memberChargeDataArray) {
        _memberChargeDataArray = [NSArray array];
    }
    
    return _memberChargeDataArray;
}

- (NSMutableArray *)livemodelArray
{
    if (!_livemodelArray) {
        _livemodelArray = [NSMutableArray array];
    }
    
    return _livemodelArray;
}

- (NSMutableArray *)consumeData
{
    if (!_consumeData) {
        _consumeData = [NSMutableArray array];
    }
    
    return _consumeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.colorArray = [NSMutableArray arrayWithObjects:@"f79c2c",@"3992f9",@"54e58b",@"fcd866",@"f16093",@"60d1f1",@"d1f160",@"f17460", nil];
    
//    self.moneyArrM_3 = [NSMutableArray arrayWithObjects:@"44",@"323",@"545",@"223", nil];
//    self.colorArrM_3 = [NSMutableArray arrayWithObjects:colorA,colorB,colorC,colorD, nil];
    // 获取智能分析权限管理 是否允许查看整店数据
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSString *Is_SalesclerkLogin = [SVUserManager shareInstance].is_SalesclerkLogin;
    NSString *sp_salesclerkid = [SVUserManager shareInstance].sp_salesclerkid;
    if (kDictIsEmpty(sv_versionpowersDict)){
        self.operation = nil;
    }else{
        // 判断是否允许查看整店数据开关开了没有
       
       NSString *Query_DailyBill = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Analytics"][@"Query_DailyBill"]];
        if (kStringIsEmpty(Query_DailyBill)) {
            self.operation = nil;
        }else{
            if (Query_DailyBill.intValue == 1) {// 看全部
                self.operation = nil;
            }else{
                if (Is_SalesclerkLogin.intValue == 1) { // 是操作员
                    self.operation = sp_salesclerkid;
                }else{
                    self.operation = nil;
                }
            }
        }
        
        
    }
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    
    self.fourView.layer.cornerRadius = 10;
    self.fourView.layer.masksToBounds = YES;
    
    self.fiveView.layer.cornerRadius = 10;
    self.fiveView.layer.masksToBounds = YES;
    
    self.sixView.layer.cornerRadius = 10;
    self.sixView.layer.masksToBounds = YES;
    
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.consumeBottomView.hidden = YES;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString = %@",currentTimeString);
    self.type = 1;
    [self setUpData];

    if (kDictIsEmpty(self.dic)) {
        self.timeLabel.text = @"今天";
        [self setUpDataBeginData:@"" endData:@"" operation:@"" day:self.type type:1 user_id:self.user_id];// 今天
    }else{
        NSString *type = [self.dic objectForKey:@"type"];
        if ([type isEqualToString:@"2"]) {// 本周
            self.type = type.integerValue;
            self.timeLabel.text = @"本周";
            self.oneDate = @"";
            self.twoDate = @"";
            //  self.page = 1;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSDateFormatter *formatter_two = [[NSDateFormatter alloc] init];
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"YYYY-MM"];
            [formatter_two setDateFormat:@"yyyy-MM-dd"];
            //现在时间,你可以输出来看下是什么格式
            
            NSDate *datenow = [NSDate date];
            
            //----------将nsdate按formatter格式转成nsstring
            
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            NSString *start = [NSString stringWithFormat:@"%@-01",currentTimeString];
            NSString *currentTimeString_two = [formatter_two stringFromDate:datenow];
            
            [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
            
            //        NSLog(@"currentTimeString = %@",currentTimeString);
            //        [self shopSalesTopStart:start end:currentTimeString_two];
            //        [self memberSaleCountInfoStart:start end:currentTimeString_two];
            //
            //        [self GetMemberSalesAnalysisStart:start end:currentTimeString_two];
            //        [self PaymentStructureSType:1 date:start date2:currentTimeString_two];
            //        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        }else if ([type isEqualToString:@"1"]){// 是今天
            self.type = type.integerValue;
            self.timeLabel.text = @"今天";
            self.oneDate = @"";
            self.twoDate = @"";
            // self.page = 1;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            NSDate *datenow = [NSDate date];
            
            //----------将nsdate按formatter格式转成nsstring
            
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            
            [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
            //        [self shopSalesTopStart:currentTimeString end:currentTimeString];
            //        [self memberSaleCountInfoStart:currentTimeString end:currentTimeString];
            //
            //        [self GetMemberSalesAnalysisStart:currentTimeString end:currentTimeString];
            //        [self PaymentStructureSType:1 date:currentTimeString date2:currentTimeString];
            //        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        }else if ([type isEqualToString:@"-1"]){// 昨天
            self.type = type.integerValue;
            self.timeLabel.text = @"昨天";
            self.oneDate = @"";
            self.twoDate = @"";
            // self.page = 1;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            // NSDate *datenow = [NSDate date];
            
            NSDate *date = [NSDate date];//当前时间
            
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
            
            NSString *currentTimeString = [formatter stringFromDate:lastDay];
            NSLog(@"currentTimeString = %@",currentTimeString);
            
            [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
            
     
        }else{
            self.type = type.integerValue;
            self.oneDate = [self.dic objectForKey:@"oneDate"];
            self.twoDate = [self.dic objectForKey:@"twoDate"];
            //  self.page = 1;
            self.type = 4;// 4是其他
            self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.oneDate,self.twoDate];
            [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
            //        [self shopSalesTopStart:self.oneDate end:self.twoDate];
            //        [self memberSaleCountInfoStart:self.oneDate end:self.twoDate];
            //
            //        [self GetMemberSalesAnalysisStart:self.oneDate end:self.twoDate];
            //        [self PaymentStructureSType:1 date:self.oneDate date2:self.twoDate];
            //        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        }
    }
    
    //初始化对象，设置代理
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    //创建蓝牙
    manage = [JWBluetoothManage sharedInstance];
    WeakSelf
    //开始搜索
    [manage beginScanPerpheralSuccess:^(NSArray<CBPeripheral *> *peripherals, NSArray<NSNumber *> *rssis) {
        weakSelf.dataSource = [NSMutableArray arrayWithArray:peripherals];
        weakSelf.rssisArray = [NSMutableArray arrayWithArray:rssis];
        
    } failure:^(CBManagerState status) {
        //        [SVTool TextButtonAction:weakSelf.view withSing:[weakSelf getBluetoothErrorInfo:status]];
        
    }];
    //断开连接的block回调
    manage.disConnectBlock = ^(CBPeripheral *perpheral, NSError *error) {
        
    };
    
    [self dayin];
    
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"nitifyName1" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyNameAllStore:) name:@"nitifyNameAllStore" object:nil];
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
           self.fiveViewHeight.constant = 250;
    }else{
        self.fiveViewHeight.constant = 0;
    }
}

#pragma mark - 全部商店的id
- (void)nitifyNameAllStore:(NSNotification *)noti{
    
    NSDictionary  *dic = [noti userInfo];
    NSString *user_id = dic[@"user_id"];
    NSLog(@"user_id = %@",user_id);
    self.user_id = user_id;
    
    if (self.type ==2) {// 本周
        self.timeLabel.text = @"本周";
        self.oneDate = @"";
        self.twoDate = @"";
        //  self.page = 1;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter_two = [[NSDateFormatter alloc] init];
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"YYYY-MM"];
        [formatter_two setDateFormat:@"yyyy-MM-dd"];
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        NSString *start = [NSString stringWithFormat:@"%@-01",currentTimeString];
        NSString *currentTimeString_two = [formatter_two stringFromDate:datenow];
        
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
        
    }else if (self.type ==1){// 是今天
        self.timeLabel.text = @"今天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:user_id];
        
    }else if (self.type ==-1){// 昨天
        self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        NSLog(@"currentTimeString = %@",currentTimeString);
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:user_id];
        
        
    }else{
        if (kDictIsEmpty(self.dic)) {
            self.oneDate = @"";
            self.twoDate = @"";
            //  self.page = 1;
            self.type = 4;
            self.timeLabel.text = @"今天";
            [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:user_id];
        }else{
            self.oneDate = [self.dic objectForKey:@"oneDate"];
            self.twoDate = [self.dic objectForKey:@"twoDate"];
            //  self.page = 1;
            self.type = 4;
            self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.oneDate,self.twoDate];
            [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:user_id];
        }
        
        
    }
    
    
}


- (void)setUpData{
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
        
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.scrollView.mj_header = header;
}

- (void)dayin{
    //    WeakSelf
    //自动连接上次连接的蓝牙
    [manage autoConnectLastPeripheralCompletion:^(CBPeripheral *perpheral, NSError *error) {
      
    }];
}

#pragma mark - 蓝牙相关方法
-(NSString *)getBluetoothErrorInfo:(CBManagerState)status{
    NSString * tempStr = @"未知错误";
    switch (status) {
        case CBManagerStateUnknown:
            tempStr = @"未知错误";
            break;
        case CBManagerStateResetting:
            tempStr = @"正在重置";
            break;
        case CBManagerStateUnsupported:
            tempStr = @"设备不支持蓝牙";
            break;
        case CBManagerStateUnauthorized:
            tempStr = @"蓝牙未被授权";
            break;
        case CBManagerStatePoweredOff:
            tempStr = @"蓝牙可用，未打开";
            break;
        default:
            break;
    }
    return tempStr;
}


#pragma mark - 时间晒选
-(void)notification1:(NSNotification *)noti{
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    self.dic = dic;
    NSString *type = [dic objectForKey:@"type"];
    self.type = type.integerValue;
    if ([type isEqualToString:@"2"]) {// 本周
        self.timeLabel.text = @"本周";
        self.oneDate = @"";
        self.twoDate = @"";
      //  self.page = 1;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter_two = [[NSDateFormatter alloc] init];
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"YYYY-MM"];
        [formatter_two setDateFormat:@"yyyy-MM-dd"];
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        NSString *start = [NSString stringWithFormat:@"%@-01",currentTimeString];
        NSString *currentTimeString_two = [formatter_two stringFromDate:datenow];
        
         [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.timeLabel.text = @"今天";
        self.oneDate = @"";
        self.twoDate = @"";
       // self.page = 1;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];

    }else if ([type isEqualToString:@"-1"]){// 昨天
        self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
       // self.page = 1;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        NSLog(@"currentTimeString = %@",currentTimeString);
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];
        
        
    }else{
        self.oneDate = [self.dic objectForKey:@"oneDate"];
        self.twoDate = [self.dic objectForKey:@"twoDate"];
      //  self.page = 1;
        self.type = 4;
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.oneDate,self.twoDate];
        [self setUpDataBeginData:self.oneDate endData:self.twoDate operation:@"" day:self.type type:1 user_id:self.user_id];

    }
    NSLog(@"接收 userInfo传递的消息：%@",type);
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName1" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyNameAllStore" object:nil];
    
}

- (IBAction)sureClick:(id)sender {
    
    [SVUserManager loadUserInfo];
//    if ([[SVUserManager shareInstance].quickOff isEqualToString:@"1"]) {
        //延迟1秒，等待蓝牙连接后，再作打印
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVUserManager loadUserInfo];
            if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                [SVUserManager shareInstance].printerNumber = @"1";
                [SVUserManager saveUserInfo];
            }
            
            
            [SVUserManager loadUserInfo];
         
                if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                    [self fiftyEightPrinting];
                }
                
                if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                    //[self eightyPrinting];
                  //  [self eightyPrinting];
                }
  
}


- (void)setUpDataBeginData:(NSString *)beginDate endData:(NSString *)endDate operation:(NSString *)operation day:(NSInteger)day type:(NSInteger)type user_id:(NSString *)user_id
{
     [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL;
    if (kStringIsEmpty(self.operation)) {
        dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetDailyBill?key=%@&beginDate=%@&endDate=%@&day=%ld&type=%ld&user_id=%@",token,beginDate,endDate,day,type,user_id];
    }else{
        dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetDailyBill?key=%@&beginDate=%@&endDate=%@&day=%ld&type=%ld&user_id=%@&operation=%@",token,beginDate,endDate,day,type,user_id,self.operation];
    }
     
    NSLog(@"每日对账单dURL = %@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"succeed"] intValue] == 1) {
         [self.memberStoredValueView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [self.SufficientTimeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [self.cikaObjectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [self.refundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSLog(@"dic每日对账单 = %@",dic);
        self.dailyDict = dic[@"values"];
       // self.timeLabel.text = dic[@"result"];
        NSDictionary *dict = dic[@"values"];
       NSArray *totalDataArray = dict[@"totalData"];
        NSLog(@"totalDataArray = %@",totalDataArray);
        NSDictionary *dataDic = totalDataArray[0];
        
        self.totleMoney.text = [NSString stringWithFormat:@"%.2f",[dataDic[@"amount"] doubleValue]];
        
        NSDictionary *dataDic1 = totalDataArray[1];
        
        self.dingdanNum.text = [NSString stringWithFormat:@"%.2f",[dataDic1[@"amount"] doubleValue]];
        
        NSDictionary *dataDic2 = totalDataArray[2];
        
        self.tuikuanMoney.text = [NSString stringWithFormat:@"%.2f",[dataDic2[@"amount"]doubleValue]];
        
        NSDictionary *dataDic3 = totalDataArray[3];
        
        self.xinzengMember.text = [NSString stringWithFormat:@"%.2f",[dataDic3[@"amount"]doubleValue]];
        
        NSDictionary *dataDic4 = totalDataArray[4];
        
        self.countNumber.text = [NSString stringWithFormat:@"%.2f",[dataDic4[@"amount"] doubleValue]];
        
        NSDictionary *dataDic5 = totalDataArray[5];
        
        self.miandanjine.text = [NSString stringWithFormat:@"%.2f",[dataDic5[@"amount"] doubleValue]];
        
        NSDictionary *dataDic6 = totalDataArray[6];
        
        self.zhekoujine.text = [NSString stringWithFormat:@"%.2f",[dataDic6[@"amount"] doubleValue]];
        
        NSDictionary *dataDic7 = totalDataArray[7];
        
        self.xianjinjieyu.text = [NSString stringWithFormat:@"%.2f",[dataDic7[@"amount"] doubleValue]];
        
        NSDictionary *individualConsumeData = dict[@"individualConsumeData"];
        
        NSDictionary *memberConsumeData = dict[@"memberConsumeData"];
        
        NSDictionary *livemodel = dict[@"livemodel"];
        // 散客
        self.consumeData = individualConsumeData[@"consumeData"];
        self.memberChargeDataArray = memberConsumeData[@"consumeData"];// 会员
        self.livemodelArray = livemodel[@"livemodel"];
          //  self.livemodelArray
        // 人数
            if (kDictIsEmpty(memberConsumeData)) {
                self.memberLabel.text= @"会员0人";
            }else{
                self.memberLabel.text= memberConsumeData[@"head"];
            }
            
            if (kDictIsEmpty(individualConsumeData)) {
                self.consumeLabel.text= @"散客0人";
            }else{
                self.consumeLabel.text= individualConsumeData[@"head"];
            }
        
       // self.consumeLabel.text= individualConsumeData[@"head"];
        
        // 两个圈圈
            
            [self.payChartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.consumeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            NSDictionary *dicValues = dic[@"values"];
            
            NSMutableArray *item_Array  = [NSMutableArray array];
            NSMutableArray *item_ArrayTwo  = [NSMutableArray array];
           // NSArray *bynicklist=dicValues[@"bynicklist"];
            if (kArrayIsEmpty(self.memberChargeDataArray)) {
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.payChartView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.payChartView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
                
            }else{
                double Count = 0.0;
                
                // 添加UIsrollView
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.payChartView addSubview:scrollView];
                scrollView.delegate = self;
               
                CGFloat maxY = 0;
              //  for (NSDictionary *dict in self.memberChargeDataArray) {
                    
                    for (int i = 0; i < self.memberChargeDataArray.count; i++) {
                        NSDictionary *dict = self.memberChargeDataArray[i];
                            UIColor * randomColor;
                            if (i > self.colorArray.count - 1) {
                                randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                            }else{
                                randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                            }
                        
                    [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"amount"]doubleValue] color:randomColor]];
                    Count += [dict[@"amount"]doubleValue];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
                    // view.backgroundColor = [UIColor yellowColor];
                    
                    UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                    cicleView.backgroundColor = randomColor;
                    [view addSubview:cicleView];
                    UILabel *memLabel = [[UILabel alloc] init];
                    [view addSubview:memLabel];
                    memLabel.text = [NSString stringWithFormat:@"%@   ￥%.2f",dict[@"payment"],[dict[@"amount"]doubleValue]];
                    // 设置Label的字体 HelveticaNeue  Courier
                    UIFont *fnt = [UIFont systemFontOfSize:12];
                    memLabel.textColor= [UIColor colorWithHexString:@"666666"];
                    memLabel.font = fnt;
                    // 根据字体得到NSString的尺寸
                    CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat nameH = size.height;
                    // 名字的W
                    CGFloat nameW = size.width;
                    memLabel.frame = CGRectMake(CGRectGetMaxX(cicleView.frame) + 5,0, nameW,nameH);
                    memLabel.centerY = cicleView.centerY;
                    
                    
                    maxY = CGRectGetMaxY(view.frame);
                    // cicleView.centerY = view.centerY;
                    [scrollView addSubview:view];
                    
                }
                 scrollView.contentSize = CGSizeMake(0, maxY);
                
                // 历史会员圈圈
                PNPieChart *chart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_Array];
                chart.descriptionTextColor = [UIColor whiteColor];
                chart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                chart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                chart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                chart.showOnlyValues = YES; // 只显示数值不显示内容描述
                
                chart.innerCircleRadius = 0;
                
                
                [chart strokeChart];
                
                //设置标注
                chart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                chart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                [self.payChartView addSubview:chart];
                
                
                
                
                //总消费额
                UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabel.text = @"总金额";
                V3sumlabel.textAlignment = NSTextAlignmentCenter;
                V3sumlabel.font = [UIFont systemFontOfSize:12];
                V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabel.adjustsFontSizeToFitWidth = YES;
                V3sumlabel.minimumScaleFactor = 0.5;
                [self.payChartView  addSubview:V3sumlabel];
                
                
                UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabel.text = [NSString stringWithFormat:@"%.2f",[memberConsumeData[@"amount"]doubleValue]];
                sumtextlabel.textAlignment = NSTextAlignmentCenter;
                sumtextlabel.font = [UIFont systemFontOfSize:14];
                sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
                [self.payChartView  addSubview:sumtextlabel];
            }
            
            // 散客
            
          //  NSArray *bymoneylist = dicValues[@"bymoneylist"];
            
            if (kArrayIsEmpty(self.consumeData)) {
                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.consumeView addSubview:img_two];
                [img_two mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.consumeView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
            }else{
                
                // 第二个
                
                UIScrollView *scrollViewTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.consumeView addSubview:scrollViewTwo];
                scrollViewTwo.delegate = self;
                
                CGFloat maxYTwo = 0;
                float sexMoneyCount = 0;
//                for (NSDictionary *dict in self.consumeData) {
//                    UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                
                for (int i = 0; i < self.consumeData.count; i++) {
                    NSDictionary *dict = self.consumeData[i];
                    UIColor * randomColor;
                    if (i > self.colorArray.count - 1) {
                        randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                    }else{
                        randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                    }
                    
                    [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"amount"]doubleValue] color:randomColor]];
                    sexMoneyCount += [dict[@"amount"]doubleValue];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxYTwo, ScreenW - 20 -170 - 20, 30)];
                    // view.backgroundColor = [UIColor yellowColor];
                    
                    UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                    cicleView.backgroundColor = randomColor;
                    [view addSubview:cicleView];
                    UILabel *memLabel = [[UILabel alloc] init];
                    [view addSubview:memLabel];
                    memLabel.text = [NSString stringWithFormat:@"%@   ￥%.2f",dict[@"payment"],[dict[@"amount"]doubleValue]];
                    // 设置Label的字体 HelveticaNeue  Courier
                    UIFont *fnt = [UIFont systemFontOfSize:12];
                    memLabel.textColor= [UIColor colorWithHexString:@"666666"];
                    memLabel.font = fnt;
                    // 根据字体得到NSString的尺寸
                    CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat nameH = size.height;
                    // 名字的W
                    CGFloat nameW = size.width;
                    memLabel.frame = CGRectMake(CGRectGetMaxX(cicleView.frame) + 5,0, nameW,nameH);
                    memLabel.centerY = cicleView.centerY;
                    
                    
                    maxYTwo = CGRectGetMaxY(view.frame);
                    // cicleView.centerY = view.centerY;
                    [scrollViewTwo addSubview:view];
                    
                }
                scrollViewTwo.contentSize = CGSizeMake(0, maxYTwo);
                
                // 第二个圈圈
                PNPieChart *addChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_ArrayTwo];
                addChart.descriptionTextColor = [UIColor whiteColor];
                addChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                addChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                addChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                addChart.showOnlyValues = YES; // 只显示数值不显示内容描述
                
                addChart.innerCircleRadius = 0;
                
                
                [addChart strokeChart];
                
                //设置标注
                addChart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                addChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                [self.consumeView addSubview:addChart];
                
                //总消费额
                //总消费额
                UILabel*V3sumlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabelTwo.text = @"总金额";
                V3sumlabelTwo.textAlignment = NSTextAlignmentCenter;
                V3sumlabelTwo.font = [UIFont systemFontOfSize:12];
                V3sumlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabelTwo.adjustsFontSizeToFitWidth = YES;
                V3sumlabelTwo.minimumScaleFactor = 0.5;
                [self.consumeView addSubview:V3sumlabelTwo];
                
                UILabel *sumtextlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(15, 87, 130, 12)];
                sumtextlabelTwo.text = [NSString stringWithFormat:@"%.2f",[individualConsumeData[@"amount"]doubleValue]];
                sumtextlabelTwo.textAlignment = NSTextAlignmentCenter;
                sumtextlabelTwo.font = [UIFont systemFontOfSize:14];
                sumtextlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                [self.consumeView addSubview:sumtextlabelTwo];
            }
            
//        [self.tableView reloadData];
//        [self.twoTableView reloadData];
//        [self.threeTableView reloadData];
//
        // 新增会员统计
            [self.threeSmallView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            NSMutableArray *item_ArrayThree = [NSMutableArray array];
            // NSArray *bynicklist=dicValues[@"bynicklist"];
            NSMutableArray *liveArrayM = [NSMutableArray array];
            for (int i = 0; i < self.self.livemodelArray.count; i++) {
                NSDictionary *dict = self.self.livemodelArray[i];
                if ([dict[@"count"] doubleValue] > 0) {
                    [liveArrayM addObject:dict];
                }
                
            }
            if (kArrayIsEmpty(liveArrayM)) {
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.threeSmallView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.threeSmallView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
                
            }else{
               // float Count = 0.0;
                
                // 添加UIsrollView
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.threeSmallView addSubview:scrollView];
                scrollView.delegate = self;
                
                CGFloat maxY = 0;
              //  for (NSDictionary *dict in self.livemodelArray) {
                    
                    for (int i = 0; i < liveArrayM.count; i++) {
                        NSDictionary *dict = liveArrayM[i];
                        if ([dict[@"count"] doubleValue] > 0) {
                        UIColor * randomColor;
                        if (i > self.colorArray.count - 1) {
                            randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                        }else{
                            randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                        }
//                        UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                       // NSString *str1 = dict[@"count"];
                        // NSString *str3 = [str1 substringToIndex:str1.length];//str3 = "this"
                        // NSLog(@"str3.integerValue = %ld",str3.integerValue);
                        
                        [item_ArrayThree addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"count"] doubleValue] color:randomColor]];
                        // Count += [dict[@"amount"]doubleValue];
                        // 2.截取从0位到第n为（第n位不算在内）
                        
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
                        // view.backgroundColor = [UIColor yellowColor];
                        
                        UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                        cicleView.backgroundColor = randomColor;
                        [view addSubview:cicleView];
                        UILabel *memLabel = [[UILabel alloc] init];
                        [view addSubview:memLabel];
                        memLabel.text = [NSString stringWithFormat:@"%@   %@人",dict[@"name"],dict[@"count"]];
                        // 设置Label的字体 HelveticaNeue  Courier
                        UIFont *fnt = [UIFont systemFontOfSize:12];
                        memLabel.textColor= [UIColor colorWithHexString:@"666666"];
                        memLabel.font = fnt;
                        // 根据字体得到NSString的尺寸
                        CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                        // 名字的H
                        CGFloat nameH = size.height;
                        // 名字的W
                        CGFloat nameW = size.width;
                        memLabel.frame = CGRectMake(CGRectGetMaxX(cicleView.frame) + 5,0, nameW,nameH);
                        memLabel.centerY = cicleView.centerY;
                        
                        
                        maxY = CGRectGetMaxY(view.frame);
                        // cicleView.centerY = view.centerY;
                        [scrollView addSubview:view];
                    }
                    
                }
                scrollView.contentSize = CGSizeMake(0, maxY);
                
                // 历史会员圈圈
                PNPieChart *chart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_ArrayThree];
                chart.descriptionTextColor = [UIColor whiteColor];
                chart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                chart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                chart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                chart.showOnlyValues = YES; // 只显示数值不显示内容描述
                
                chart.innerCircleRadius = 0;
                
                
                [chart strokeChart];
                
                //设置标注
                chart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                chart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                [self.threeSmallView addSubview:chart];
                
                
                
                
                //总消费额
                UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabel.text = @"新增会员";
                V3sumlabel.textAlignment = NSTextAlignmentCenter;
                V3sumlabel.font = [UIFont systemFontOfSize:12];
                V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabel.adjustsFontSizeToFitWidth = YES;
                V3sumlabel.minimumScaleFactor = 0.5;
                [self.threeSmallView  addSubview:V3sumlabel];
                
                
                UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabel.text = [NSString stringWithFormat:@"%.0f",[livemodel[@"liveCount"]doubleValue]];
                sumtextlabel.textAlignment = NSTextAlignmentCenter;
                sumtextlabel.font = [UIFont systemFontOfSize:14];
                sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
                [self.threeSmallView  addSubview:sumtextlabel];
            }
            
            
            
        
        
        // 会员储值金额
        NSDictionary *membeRechargeData = dict[@"membeRechargeData"];
        NSArray *memberChargeDataArray = membeRechargeData[@"consumeData"];
        
        CGFloat maxY = 0;
        for (NSDictionary *memDic in memberChargeDataArray) {
            
            UILabel *memLabel = [[UILabel alloc]init];
            memLabel.text = memDic[@"payment"];
            // 设置Label的字体 HelveticaNeue  Courier
            UIFont *fnt = [UIFont systemFontOfSize:15];
            memLabel.textColor= [UIColor colorWithHexString:@"666666"];
            memLabel.font = fnt;
            // 根据字体得到NSString的尺寸
            CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameH = size.height;
            // 名字的W
            CGFloat nameW = size.width;
            memLabel.frame = CGRectMake(0,maxY, nameW,nameH);
            [self.memberStoredValueView addSubview:memLabel];
            
            
            
            UILabel *memLabelAmount = [[UILabel alloc] init];
            memLabelAmount.text = [NSString stringWithFormat:@"%.2f",[memDic[@"amount"] doubleValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            UIFont *fntMount = [UIFont systemFontOfSize:15];
            memLabelAmount.textColor= [UIColor colorWithHexString:@"666666"];
            memLabelAmount.font = fntMount;
            // 根据字体得到NSString的尺寸
            CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameHM = sizeMount.height;
            // 名字的W
            CGFloat nameWM = sizeMount.width;
            memLabelAmount.frame = CGRectMake(self.memberStoredValueView.width - nameWM,maxY, nameWM,nameHM);
           
            [self.memberStoredValueView addSubview:memLabelAmount];
            maxY = CGRectGetMaxY(memLabel.frame) + 20;
        }
        
        
        
        UILabel *memLabel = [[UILabel alloc]init];
        memLabel.text = @"累计充值";
        // 设置Label的字体 HelveticaNeue  Courier
        UIFont *fnt = [UIFont systemFontOfSize:15];
        memLabel.textColor= [UIColor colorWithHexString:@"666666"];
        memLabel.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // 名字的H
        CGFloat nameH = size.height;
        // 名字的W
        CGFloat nameW = size.width;
        memLabel.frame = CGRectMake(0,maxY, nameW,nameH);
        [self.memberStoredValueView addSubview:memLabel];
        
        UILabel *memLabelAmount = [[UILabel alloc] init];
        memLabelAmount.text = [NSString stringWithFormat:@"%.2f",[membeRechargeData[@"amount"] doubleValue]];
        // 设置Label的字体 HelveticaNeue  Courier
        UIFont *fntMount = [UIFont systemFontOfSize:15];
        memLabelAmount.textColor= [UIColor colorWithHexString:@"666666"];
        memLabelAmount.font = fntMount;
        // 根据字体得到NSString的尺寸
        CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
        // 名字的H
        CGFloat nameHM = sizeMount.height;
        // 名字的W
        CGFloat nameWM = sizeMount.width;
        memLabelAmount.frame = CGRectMake(self.memberStoredValueView.width - nameWM,maxY, nameWM,nameHM);
        
        [self.memberStoredValueView addSubview:memLabelAmount];
        
        self.memberStoreHeight.constant = maxY + nameHM + 20;
        
        
        // 充次金额
        NSDictionary *membeChargeSubData = dict[@"membeChargeSubData"];
          self.chuzhiMoney.text = [NSString stringWithFormat:@"%.2f",[membeRechargeData[@"amount"]doubleValue] + [membeChargeSubData[@"amount"]doubleValue]];
        NSArray *membeChargeSubDataArray = membeChargeSubData[@"consumeData"];
        CGFloat CCmaxY = 0;
        for (NSDictionary *memDic in membeChargeSubDataArray) {
            
            UILabel *memLabel = [[UILabel alloc]init];
            memLabel.text = memDic[@"payment"];
            // 设置Label的字体 HelveticaNeue  Courier
            UIFont *fnt = [UIFont systemFontOfSize:15];
            memLabel.textColor= [UIColor colorWithHexString:@"666666"];
            memLabel.font = fnt;
            // 根据字体得到NSString的尺寸
            CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameH = size.height;
            // 名字的W
            CGFloat nameW = size.width;
            memLabel.frame = CGRectMake(0,CCmaxY, nameW,nameH);
            [self.SufficientTimeView addSubview:memLabel];
            
            
            
            UILabel *memLabelAmount = [[UILabel alloc] init];
            memLabelAmount.text = [NSString stringWithFormat:@"%.2f",[memDic[@"amount"] doubleValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            UIFont *fntMount = [UIFont systemFontOfSize:15];
            memLabelAmount.textColor= [UIColor colorWithHexString:@"666666"];
            memLabelAmount.font = fntMount;
            // 根据字体得到NSString的尺寸
            CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameHM = sizeMount.height;
            // 名字的W
            CGFloat nameWM = sizeMount.width;
            memLabelAmount.frame = CGRectMake(self.SufficientTimeView.width - nameWM,CCmaxY, nameWM,nameHM);
            
            [self.SufficientTimeView addSubview:memLabelAmount];
            CCmaxY = CGRectGetMaxY(memLabel.frame) + 20;
        }
        
        UILabel *CchongciMemLabel = [[UILabel alloc]init];
        CchongciMemLabel.text = @"累计充次";
        // 设置Label的字体 HelveticaNeue  Courier
       // UIFont *fnt = [UIFont systemFontOfSize:15];
        CchongciMemLabel.textColor= [UIColor colorWithHexString:@"666666"];
        CchongciMemLabel.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize chongcisize = [CchongciMemLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // 名字的H
        CGFloat chongcinameH = chongcisize.height;
        // 名字的W
        CGFloat chongcinameW = chongcisize.width;
        CchongciMemLabel.frame = CGRectMake(0,CCmaxY, chongcinameW,chongcinameH);
        [self.SufficientTimeView addSubview:CchongciMemLabel];
        
        
        
        UILabel *chongcimemLabelAmount = [[UILabel alloc] init];
        chongcimemLabelAmount.text = [NSString stringWithFormat:@"%.2f",[membeChargeSubData[@"amount"] doubleValue]];
        // 设置Label的字体 HelveticaNeue  Courier
       // UIFont *fntMount = [UIFont systemFontOfSize:15];
        chongcimemLabelAmount.textColor= [UIColor colorWithHexString:@"666666"];
        chongcimemLabelAmount.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize chongcisizeMount = [chongcimemLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // 名字的H
        CGFloat chongcinameHM = chongcisizeMount.height;
        // 名字的W
        CGFloat chongcinameWM = chongcisizeMount.width;
        chongcimemLabelAmount.frame = CGRectMake(self.SufficientTimeView.width - chongcinameWM,CCmaxY, chongcinameWM,chongcinameHM);
        
        [self.SufficientTimeView addSubview:chongcimemLabelAmount];
        
        self.sufficientHight.constant = CCmaxY + chongcinameHM + 20;
        
        self.fourViewHeight.constant = self.sufficientHight.constant + self.memberStoreHeight.constant + 177;
        
        
        // 次卡售卡
        NSDictionary *subcardsalescarddata = self.dailyDict[@"subcardsalescarddata"];
        NSArray *subcardsalescarddataArray = subcardsalescarddata[@"subcardsalescard"];
      
        CGFloat maY = 20.0;
        float number = 0.0;
        for (NSDictionary *dict in subcardsalescarddataArray) {
            UIFont *fnt = [UIFont systemFontOfSize:15];
            UIColor *color = [UIColor colorWithHexString:@"666666"];
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(8, maY, 150, 20)];
            nameL.text = dict[@"name"];
            nameL.textColor = color;
            nameL.font = fnt;
            
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame), maY, (ScreenW -208) /2, 20)];
            numL.textAlignment = NSTextAlignmentCenter;
             numL.textColor = color;
            numL.font = fnt;
            numL.text = [NSString stringWithFormat:@"%.2f",[dict[@"number"]doubleValue]];
            UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numL.frame), maY, (ScreenW -208) /2, 20)];
            moneyL.text = [NSString stringWithFormat:@"%.2f",[dict[@"amount"]doubleValue]];
            moneyL.font = fnt;
            moneyL.textColor = color;
            moneyL.textAlignment = NSTextAlignmentRight;
            
            [self.cikaObjectView addSubview:nameL];
            [self.cikaObjectView addSubview:numL];
            [self.cikaObjectView addSubview:moneyL];
             maY = CGRectGetMaxY(nameL.frame) + 20;
            number += [dict[@"number"]doubleValue];
        }
        self.cikaObjectHeight.constant = maY;
            [SVUserManager loadUserInfo];
              if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_maternal_supplies"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_pleasure_ground"] || [[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {
                    self.fiveViewHeight.constant = self.cikaObjectHeight.constant + 159;
                  //self.fiveView.hidden = NO;
              }else{
                  self.fiveViewHeight.constant = 0;
                  self.sixViewTopConst.constant = 0;
                  //self.fiveView.hidden = YES;
              }
      //  self.fiveViewHeight.constant = self.cikaObjectHeight.constant + 159;
        
        self.cikaNum.text= [NSString stringWithFormat:@"%.2f",number];
        self.cikaMoney.text = [NSString stringWithFormat:@"%.2f",[subcardsalescarddata[@"amount"] doubleValue]];
        
        // 退货金额
        NSDictionary *refundData = self.dailyDict[@"refundData"];
        NSArray *refundDataArray = refundData[@"consumeData"];
        CGFloat refundmaxY = 0;
        self.tuihuoMoney.text = [NSString stringWithFormat:@"%.2f",[refundData[@"amount"] doubleValue]];
        for (NSDictionary *memDic in refundDataArray) {
            
            UILabel *memLabel = [[UILabel alloc]init];
            memLabel.text = memDic[@"payment"];
            // 设置Label的字体 HelveticaNeue  Courier
            UIFont *fnt = [UIFont systemFontOfSize:15];
            memLabel.textColor= [UIColor colorWithHexString:@"666666"];
            memLabel.font = fnt;
            // 根据字体得到NSString的尺寸
            CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameH = size.height;
            // 名字的W
            CGFloat nameW = size.width;
            memLabel.frame = CGRectMake(0,refundmaxY, nameW,nameH);
            [self.refundView addSubview:memLabel];
            
            
            
            UILabel *memLabelAmount = [[UILabel alloc] init];
            memLabelAmount.text = [NSString stringWithFormat:@"%.2f",[memDic[@"amount"] doubleValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            UIFont *fntMount = [UIFont systemFontOfSize:15];
            memLabelAmount.textColor= [UIColor colorWithHexString:@"666666"];
            memLabelAmount.font = fntMount;
            // 根据字体得到NSString的尺寸
            CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameHM = sizeMount.height;
            // 名字的W
            CGFloat nameWM = sizeMount.width;
            memLabelAmount.frame = CGRectMake(self.SufficientTimeView.width - nameWM,refundmaxY, nameWM,nameHM);
            
            [self.refundView addSubview:memLabelAmount];
            refundmaxY = CGRectGetMaxY(memLabel.frame) + 20;
        }
            
        
        self.refundViewHeight.constant = refundmaxY;
        self.sixViewHeight.constant = self.refundViewHeight.constant + 58;
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)fiftyEightPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
        // self.title = @"结算";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    
    //显示时间
   // NSString *timeString = self.dailyDict[@"result"];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
     [printer appendText:@"每日对账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    [printer appendTitle:@"时间：" value: self.timeLabel.text];
    [SVUserManager loadUserInfo];
    NSArray *totalData = self.dailyDict[@"totalData"];
    [printer appendSeperatorLine];
    for (NSDictionary *dict in totalData) {
//        [printer appendTitle:dict[@"payment"] value:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]]];
        [printer appendLeftText:dict[@"payment"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
   [printer appendSeperatorLine];
    [printer appendText:@"支付消费统计" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员" value:@""];
    NSDictionary *memberConsumeData = self.dailyDict[@"memberConsumeData"];
    NSArray *consumeDataMemberArray = memberConsumeData[@"consumeData"];
    for (NSDictionary *dict in consumeDataMemberArray) {
           [printer appendLeftText:dict[@"payment"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
     [printer appendLeftText:memberConsumeData[@"head"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[memberConsumeData[@"amount"] doubleValue]] isTitle:NO];
    
    [printer appendNewLine];
    // 散客
    [printer appendTitle:@"散客" value:@""];
     NSDictionary *individualConsumeData = self.dailyDict[@"individualConsumeData"];
    NSArray *consumeDataArray = individualConsumeData[@"consumeData"];
    for (NSDictionary *dict in consumeDataArray) {
        [printer appendLeftText:dict[@"payment"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
    [printer appendLeftText:individualConsumeData[@"head"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[individualConsumeData[@"amount"] doubleValue]] isTitle:NO];
     [printer appendSeperatorLine];
    
    // 新增会员统计
     [printer appendText:@"新增会员统计" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
     NSDictionary *livemodel = self.dailyDict[@"livemodel"];
    NSArray *livemodelArray = livemodel[@"livemodel"];
    for (NSDictionary *dict in livemodelArray) {
        if ([dict[@"count"]doubleValue] > 0) {
            [printer appendLeftText:dict[@"name"] middleText:@"" rightText:dict[@"count"] isTitle:NO];
        }
        
    }
    [printer appendLeftText:@"合计" middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[livemodel[@"liveCount"] doubleValue]] isTitle:NO];
    [printer appendSeperatorLine];
    
    // 会员充值金额
    [printer appendText:@"会员储值金额" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    NSDictionary *membeRechargeData = self.dailyDict[@"membeRechargeData"];
    NSArray *membeRechargeDataArray = membeRechargeData[@"consumeData"];
    for (NSDictionary *dict in membeRechargeDataArray) {
        [printer appendLeftText:dict[@"payment"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
    [printer appendLeftText:membeRechargeData[@"head"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[membeRechargeData[@"amount"] doubleValue]] isTitle:NO];
//    [printer appendTitle:membeRechargeData[@"head"] value:[NSString stringWithFormat:@"%.2f",[membeRechargeData[@"amount"] doubleValue]]];
    
  //  - (void)appendTitle:(NSString *)title value:(NSString *)value;
    // 充次金额
     [printer appendText:@"充次金额" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    NSDictionary *membeChargeSubData = self.dailyDict[@"membeChargeSubData"];
    NSArray *membeChargeSubDataArray = membeChargeSubData[@"consumeData"];
    for (NSDictionary *dict in membeChargeSubDataArray) {
        [printer appendLeftText:dict[@"payment"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
    [printer appendLeftText:membeChargeSubData[@"head"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[membeChargeSubData[@"amount"] doubleValue]] isTitle:NO];
    [printer appendLeftText:@"合计" middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[membeRechargeData[@"amount"]doubleValue] + [membeChargeSubData[@"amount"]doubleValue]] isTitle:NO];
    
    
    
     [printer appendSeperatorLine];
    
    // 次卡售卡
    [printer appendText:@"次卡售卡统计" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    NSDictionary *subcardsalescarddata = self.dailyDict[@"subcardsalescarddata"];
    NSArray *subcardsalescarddataArray = subcardsalescarddata[@"subcardsalescard"];
     [printer appendLeftText:@"项目名称" middleText:@"数量" rightText:@"金额" isTitle:NO];
    for (NSDictionary *dict in subcardsalescarddataArray) {
        [printer appendLeftText:dict[@"name"] middleText:[NSString stringWithFormat:@"%.0f",[dict[@"number"] doubleValue]] rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
    [printer appendLeftText:subcardsalescarddata[@"head"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[subcardsalescarddata[@"amount"] doubleValue]] isTitle:NO];

     [printer appendSeperatorLine];
    
    // 退货金额
    [printer appendText:@"退货金额" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    NSDictionary *refundData = self.dailyDict[@"refundData"];
    NSArray *refundDataArray = refundData[@"consumeData"];
    for (NSDictionary *dict in refundDataArray) {
         [printer appendLeftText:dict[@"payment"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]] isTitle:NO];
    }
    [printer appendLeftText:refundData[@"head"] middleText:@"" rightText:[NSString stringWithFormat:@"%.2f",[refundData[@"amount"] doubleValue]] isTitle:NO];
    
    
    
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer cutter];
    NSData *mainData = [printer getFinalData];
    __weak typeof(self) weakSelf = self;
    [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            [SVTool TextButtonAction:self.view withSing:@"打印成功"];
            NSLog(@"打印成功");
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        
        // weakSelf.title = @"结算";
    }];
}


- (IBAction)memberBtnClick:(id)sender {
    self.consumeView.hidden = YES;
    // self.consumeBigView.hidden = YES;
    self.consumeBottomView.hidden = YES;
    
    self.memberBottmView.hidden = NO;
    self.memberBigView.hidden = NO;
    self.payChartView.hidden = NO;
}


- (IBAction)consumeBtnClick:(id)sender {
    self.consumeView.hidden = NO;
    self.consumeBigView.hidden = NO;
    self.consumeBottomView.hidden = NO;
    
    self.memberBottmView.hidden = YES;
    //self.memberBigView.hidden = YES;
    self.payChartView.hidden = YES;
}

//- (void)memberLabelClick{
//
//}
//
//- (void)consumeLabelClick{
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.memberChargeDataArray.count;
    }else if (tableView == self.twoTableView){
        return self.consumeData.count;
    }else{
        return self.livemodelArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVColorCell *cell = [tableView dequeueReusableCellWithIdentifier:ColorCellID];
    if (!cell) {
        cell = [[SVColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ColorCellID];
    }
    
    if (tableView == self.tableView) {
         cell.consumeDict = self.memberChargeDataArray[indexPath.row];
    }else if (tableView == self.twoTableView){
         cell.consumeDict = self.consumeData[indexPath.row];
    }else{
        cell.memberDict = self.livemodelArray[indexPath.row];
    }
   
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSMutableArray *)item3_array{
    if (_item3_array == nil) {
        _item3_array = [NSMutableArray array];
    }
    return _item3_array;
}

- (NSMutableArray *)colorArrM_3
{
    if (!_colorArrM_3) {
        _colorArrM_3 = [NSMutableArray array];
    }
    
    return _colorArrM_3;
}

- (NSMutableArray *)moneyArrM_3
{
    if (!_moneyArrM_3) {
        _moneyArrM_3 = [NSMutableArray array];
    }
    return _moneyArrM_3;
}

@end

//
//  SVCardSalesReportVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/16.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCardSalesReportVC.h"
#import "SVCardSalesFlowChartCell.h"
#import "SVStoreLineView.h"
#import "SVAddCustomView.h"
#import "ZJViewShow.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;
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
static NSString *const ID = @"SVCardSalesFlowChartCell";
@interface SVCardSalesReportVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (nonatomic,strong) NSMutableArray *dataList;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoHeight;
// 售卡金额
@property (weak, nonatomic) IBOutlet UIView *saleCardMoneyBottomView;
// 售卡次数
@property (weak, nonatomic) IBOutlet UIView *saleCardCountBottomView;

@property (weak, nonatomic) IBOutlet UIView *saleCardMoneyView;
@property (weak, nonatomic) IBOutlet UIView *saleCardCountView;
@property (nonatomic,strong) NSMutableArray *valuesArray;

@property (weak, nonatomic) IBOutlet UIView *buyMoneyBottomView;
@property (weak, nonatomic) IBOutlet UIView *buyCountBottomView;
@property (weak, nonatomic) IBOutlet UIView *buyMoneyView;
@property (weak, nonatomic) IBOutlet UIView *buyCountView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourHeight;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) SVAddCustomView *addCustomView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic,assign) BOOL isAggregatePayment;
//@property (strong,nonatomic) CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用
@property (nonatomic,strong) NSDictionary * result;
@property(strong,nonatomic) CBCentralManager *CM;
@end

@implementation SVCardSalesReportVC

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
            message = @"未打开";
            break;
        case 5:
            message = @"蓝牙已经成功开启,请稍后再试";
            break;
        default:
            break;
    }
    if([message isEqualToString:@"未打开"]) {
        
    } else {
        //用延迟来作提示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![message containsString:@"蓝牙已经成功开启,请稍后再试"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"未连接蓝牙,打印失败"];
             //   self.title = @"结算";
            }
        });
    }
}

- (NSMutableArray *)valuesArray
{
    if (!_valuesArray) {
        _valuesArray = [NSMutableArray array];
    }
    return _valuesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    self.fourView.layer.cornerRadius = 10;
    self.fourView.layer.masksToBounds = YES;
    
    self.saleCardCountView.hidden = YES;
    self.saleCardCountBottomView.hidden = YES;
    
    self.buyCountView.hidden = YES;
    self.buyCountBottomView.hidden = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVCardSalesFlowChartCell" bundle:nil] forCellReuseIdentifier:ID];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    if (kDictIsEmpty(self.dic)) {
        
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        // self.page = 1;
        self.type = 1; // 默认是今天
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
        
    }else{
        NSString *type = [self.dic objectForKey:@"type"];
        if ([type isEqualToString:@"2"]) {// 本周
            self.type = type.integerValue;
            
            NSString *str = [self currentScopeWeek];
            //  NSString *string =@"sdfsfsfsAdfsdf";
            NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
            NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
            NSString *str1 = array[0];
            NSLog(@"本周str = %@",str1);
            
            [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];
            
        }else if ([type isEqualToString:@"1"]){// 是今天
            self.type = type.integerValue;
            [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
            
        }else if ([type isEqualToString:@"-1"]){// 昨天
            self.type = type.integerValue;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            // NSDate *datenow = [NSDate date];
            
            NSDate *date = [NSDate date];//当前时间
            
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
            
            NSString *currentTimeString = [formatter stringFromDate:lastDay];
            
            [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
            
            
            
        }else{
            self.type = type.integerValue;
            
            
            NSString *oneDate = [self.dic objectForKey:@"oneDate"];
            NSString *twoDate = [self.dic objectForKey:@"twoDate"];
            
            [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"nitifyName2" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyMemberNameAllStore:) name:@"nitifyMemberNameAllStore" object:nil];
    
  //  [self setUpData];
        //增加监听，当键盘出现或改变时收出消息
           [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(keyboardWillShow:)
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
           
           //增加监听，当键退出时收出消息
           [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(keyboardWillHide:)
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    
    [self AggregatePayment];
    
    self.dataSource = @[].mutableCopy;
    self.rssisArray = @[].mutableCopy;
    
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


- (void)fiftyEightPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
      //  self.title = @"结算";
     //   [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"sv_created_date"] substringToIndex:10],[self.result[@"sv_created_date"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"补打充次账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"会员卡号:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mr_cardno"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员名称:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mr_name"]] fontSize:HLFontSizeTitleSmalle];
  //  [printer appendTitle:@"会员电话:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_card"]] fontSize:HLFontSizeTitleSmalle];
   // [printer appendTitle:@"储值余额:" value:[NSString stringWithFormat:@"%.2f",self.storedValue] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"操作员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"次卡名称:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_p_name"]] fontSize:HLFontSizeTitleSmalle];
//    [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
//    [printer appendTitle:@"收银员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
 
   
    [printer appendSeperatorLine];
    
    [printer appendLeftText:@"项目" middleText:@"购买数" rightText:@"赠送数" isTitle:NO];
    for (NSDictionary *dict in [self.result objectForKey:@"setmealrechargedetail"]) {

        [printer appendLeftText:dict[@"sv_p_name"] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_purchase_count"] doubleValue]] rightText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_give_count"]doubleValue]] isTitle:NO];
            
        }
        
        
  //  }
    [printer appendSeperatorLine];
    
    [printer appendTitle:@"付款金额:" value:[NSString stringWithFormat:@"%.2f",[self.result[@"amount"] doubleValue]] fontSize:HLFontSizeTitleSmalle];
//    if (!kStringIsEmpty(self.paymentStr)) {
//        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.paymentStr] fontSize:HLFontSizeTitleSmalle];
//        self.paymentStr = nil;
//    }else{
        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mcr_payment"]] fontSize:HLFontSizeTitleSmalle];
  //  }
    
    [printer appendSeperatorLine];
    
 

    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
    }
    
    [printer appendSeperatorLine];
    

    
//    [SVUserManager loadUserInfo];
//    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
//    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
//        [printer appendSeperatorLine];
//        [printer setLineSpace:60];
//        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
//       // [printer appendBarCodeWithInfo:self.queryId];
//        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:500];
//        self.queryId = nil;
//    }
    [printer appendFooter:nil];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
  //  [printer cutter];
    NSData *mainData = [printer getFinalData];
    WeakSelf
    [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            [SVTool TextButtonAction:self.view withSing:@"打印成功"];
            NSLog(@"打印成功");
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        
        weakSelf.title = @"结算";
    }];
}

- (void)eightyPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"sv_created_date"] substringToIndex:10],[self.result[@"sv_created_date"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"补打充次账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"会员卡号:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mr_cardno"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员名称:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_name"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员电话:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_card"]] fontSize:HLFontSizeTitleSmalle];
   // [printer appendTitle:@"储值余额:" value:[NSString stringWithFormat:@"%.2f",self.storedValue] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"操作员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"次卡名称:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_p_name"]] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendSeperatorLine80];
    
    [printer eightAppendLeftText:@"项目" middleText:@"购买数" rightText:@"赠送数" isTitle:NO];
    for (NSDictionary *dict in [self.result objectForKey:@"setmealrechargedetail"]) {
        [printer eightAppendLeftText:dict[@"sv_p_name"] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_purchase_count"] doubleValue]] rightText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_give_count"]doubleValue]] isTitle:NO];
    }

    [printer appendSeperatorLine80];
    
    
    [printer appendTitle:@"付款金额:" value:[NSString stringWithFormat:@"%.2f",[self.result[@"amount"] doubleValue]] fontSize:HLFontSizeTitleSmalle];

        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mcr_payment"]] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendSeperatorLine80];

    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
    }
    

    
//    [SVUserManager loadUserInfo];
//    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
//    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
//        [printer appendSeperatorLine80];
//        [printer setLineSpace:60];
//        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
//       // [printer appendBarCodeWithInfo:self.queryId];
//        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:500];
//        self.queryId = nil;
//    }
    [printer appendFooter:nil];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer cutter];
    NSData *mainData = [printer getFinalData];
    WeakSelf
    [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            [SVTool TextButtonAction:self.view withSing:@"打印成功"];
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        weakSelf.title = @"结算";
    }];
}

    - (void)keyboardWillShow:(NSNotification *)aNotification
    {
        //获取键盘的高度
        
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        int width = keyboardRect.size.width;
        self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
        NSLog(@"键盘高度是  %d",height);
        NSLog(@"键盘宽度是  %d",width);
        
        
    }

    //当键退出时调用
    - (void)keyboardWillHide:(NSNotification *)aNotification
    {
         [self.addCustomView.textView becomeFirstResponder];// 2
    }


#pragma mark - 时间晒选
-(void)notification2:(NSNotification *)noti{
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    NSString *type = [dic objectForKey:@"type"];
    self.type = type.integerValue;
    self.dic = dic;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    if ([type isEqualToString:@"2"]) {// 本周
        NSString *str = [self currentScopeWeek];
        NSLog(@"本周str = %@",str);
        
        // NSString *str = [self currentScopeWeek];
        //  NSString *string =@"sdfsfsfsAdfsdf";
        NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
        NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
        NSString *str1 = array[0];
        NSLog(@"本周str = %@",str1);
        
        [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"1"]){
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"-1"]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else{
        NSString *oneDate = [dic objectForKey:@"oneDate"];
        NSString *twoDate = [dic objectForKey:@"twoDate"];
        
        [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName2" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyMemberNameAllStore" object:nil];
}

- (void)nitifyMemberNameAllStore:(NSNotification *)noti{
    NSDictionary  *dic = [noti userInfo];
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
    //    self.dic = dic;
    
    self.user_id = dic[@"user_id"];
    
   // self.type = type.integerValue;
    NSString *type = [NSString stringWithFormat:@"%ld",self.type];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    if ([type isEqualToString:@"2"]) {// 本周
        NSString *str = [self currentScopeWeek];
        NSLog(@"本周str = %@",str);
        
        // NSString *str = [self currentScopeWeek];
        //  NSString *string =@"sdfsfsfsAdfsdf";
        NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
        NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
        NSString *str1 = array[0];
        NSLog(@"本周str = %@",str1);
        
        [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"1"]){
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"-1"]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else{
        if (kDictIsEmpty(self.dic)) {
            NSString *oneDate = @"";
            NSString *twoDate = @"";
            
            [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
        }else{
            NSString *oneDate = [self.dic objectForKey:@"oneDate"];
            NSString *twoDate = [self.dic objectForKey:@"twoDate"];
            
            [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
        }
     
    }
    
}

/**
 当前周的日期范围
 
 @return 结果字符串
 */
- (NSString *)currentScopeWeek {
    // 默认周一为第一天，1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    return [self currentScopeWeek:2 dateFormat:@"YYYY.MM.dd"];
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
    
    return [NSString stringWithFormat:@"%@ - %@",firstDay,lastDay];
}

- (void)setUpDataStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//
//    //现在时间,你可以输出来看下是什么格式
//
//    NSDate *datenow = [NSDate date];
//
//    //----------将nsdate按formatter格式转成nsstring
//
//    NSString *currentTimeString = [formatter stringFromDate:datenow];
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.page = 1;
   // self.type = 1; // 默认是今天
    //    [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
   
    // 会员购卡情况
    [self GetMemberBuySetmealRechargeAnalysisStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
    
    // 售卡汇总
    [self GetMemberCardSetmealRechargeInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
    
     [self GetSetmealRechargeSerialInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
    
        // 会员购卡情况
        [self GetMemberBuySetmealRechargeAnalysisStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
        // 售卡汇总
        [self GetMemberCardSetmealRechargeInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
        [self GetSetmealRechargeSerialInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
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
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //  self.isSelect = YES;
        //调用请求
        //        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@""];
     
        
        // 会员购卡情况
        [self GetMemberBuySetmealRechargeAnalysisStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
        // 售卡汇总
        [self GetMemberCardSetmealRechargeInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
        [self GetSetmealRechargeSerialInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
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
    
    self.scrollView.mj_footer.hidden = YES;
    
    self.scrollView.mj_footer = footer;
}
// 售卡金额
- (IBAction)salemoneyClick:(id)sender {
    self.saleCardCountBottomView.hidden = YES;
    self.saleCardCountView.hidden = YES;
    
    self.saleCardMoneyView.hidden = NO;
    self.saleCardMoneyBottomView.hidden = NO;
}
// 售卡次数
- (IBAction)saleCardCountClick:(id)sender {
    self.saleCardCountBottomView.hidden = NO;
    self.saleCardCountView.hidden = NO;
    
    self.saleCardMoneyView.hidden = YES;
    self.saleCardMoneyBottomView.hidden = YES;
}

- (IBAction)buyMoneyClick:(id)sender {
    self.buyCountView.hidden = YES;
    self.buyCountBottomView.hidden = YES;
    
    self.buyMoneyView.hidden = NO;
    self.buyMoneyBottomView.hidden = NO;
}

- (IBAction)buyCountClick:(id)sender {
    
    self.buyCountView.hidden = NO;
    self.buyCountBottomView.hidden = NO;
    
    self.buyMoneyView.hidden = YES;
    self.buyMoneyBottomView.hidden = YES;
}



#pragma mark - 会员购卡情况
- (void)GetMemberBuySetmealRechargeAnalysisStart:(NSString *)start end:(NSString *)end page:(NSInteger)page pageSize:(NSInteger)pageSize day:(NSString *)day user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberBuySetmealRechargeAnalysis?key=%@&start=%@&end=%@&page=%ld&pagesize=%ld&day=%@&storeid=%@",token,start,[NSString stringWithFormat:@"%@ 23:59:59",end],page,pageSize,day,user_id];
    
     NSLog(@"会员购卡情况url = %@",dURL);
    
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dic会员购卡情况 = %@",dic);
        NSDictionary *values = dic[@"values"];
        NSMutableArray *item_Array = [NSMutableArray array];
        NSMutableArray *item_ArrayTwo = [NSMutableArray array];
        if ([values[@"newmembersalescount"]floatValue] >0) {
            [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[values[@"newmembersalescount"]floatValue] color:colorA]];
        }
        
        if ([values[@"oldmembertotal"]floatValue] >0) {
            [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[values[@"oldmembertotal"]floatValue] color:colorB]];
        }
        
        
        if ([values[@"newmembersalescount"]floatValue] >0) {
            [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[values[@"newmembersalescount"]floatValue] color:colorC]];
        }
        
        if ([values[@"oldmembersalescount"]floatValue] >0) {
            [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[values[@"oldmembersalescount"]floatValue] color:colorD]];
        }
        
        UIFont *fnt = [UIFont systemFontOfSize:12];
        if (kArrayIsEmpty(item_Array)) {
            
            [self.buyMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            
            [self.buyMoneyView addSubview:img];
            // [self.saleCardMoneyView addSubview:img_two];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.buyMoneyView);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
            
        }else{
            [self.buyMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
            [self.buyMoneyView addSubview:scrollView];
            scrollView.delegate = self;
            scrollView.contentSize = CGSizeMake(0, item_Array.count *30);
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20 -170 - 20, 30)];
            
            UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
            cicleView.backgroundColor = colorA;
            [view addSubview:cicleView];
            UILabel *memLabel = [[UILabel alloc] init];
            [view addSubview:memLabel];
            memLabel.text = [NSString stringWithFormat:@"%@   ￥%.f",@"新会员销售",[values[@"newmembertotal"]floatValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            
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
            [scrollView addSubview:view];
            
            
            UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), ScreenW - 20 -170 - 20, 30)];
            
            UIView *cicleViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
            cicleViewTwo.backgroundColor = colorB;
            [viewTwo addSubview:cicleViewTwo];
            UILabel *memLabelTwo = [[UILabel alloc] init];
            [viewTwo addSubview:memLabelTwo];
            memLabelTwo.text = [NSString stringWithFormat:@"%@   ￥%.f",@"历史会员销售",[values[@"oldmembertotal"]floatValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            // UIFont *fnt = [UIFont systemFontOfSize:12];
            memLabelTwo.textColor= [UIColor colorWithHexString:@"666666"];
            memLabelTwo.font = fnt;
            // 根据字体得到NSString的尺寸
            CGSize sizeTwo = [memLabelTwo.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameHTwo = sizeTwo.height;
            // 名字的W
            CGFloat nameWTwo = sizeTwo.width;
            memLabelTwo.frame = CGRectMake(CGRectGetMaxX(cicleViewTwo.frame) + 5,0, nameWTwo,nameHTwo);
            memLabelTwo.centerY = cicleViewTwo.centerY;
            
            // cicleView.centerY = view.centerY;
            
            [scrollView addSubview:viewTwo];
            
            
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
            [self.buyMoneyView addSubview:chart];
            
            
            //总消费额
            UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
            V3sumlabel.text = @"会员总购卡金额";
            V3sumlabel.textAlignment = NSTextAlignmentCenter;
            V3sumlabel.font = [UIFont systemFontOfSize:12];
            V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
            V3sumlabel.adjustsFontSizeToFitWidth = YES;
            V3sumlabel.minimumScaleFactor = 0.5;
            [self.buyMoneyView  addSubview:V3sumlabel];
            
            
            UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
            sumtextlabel.text = [NSString stringWithFormat:@"%.2f",[values[@"allmembertotal"] floatValue]];
            sumtextlabel.textAlignment = NSTextAlignmentCenter;
            sumtextlabel.font = [UIFont systemFontOfSize:14];
            sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
            [self.buyMoneyView  addSubview:sumtextlabel];
        }
        
        
        
        if (kArrayIsEmpty(item_ArrayTwo)) {
            [self.buyCountView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            
            [self.buyCountView addSubview:img];
            // [self.saleCardMoneyView addSubview:img_two];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.buyCountView);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
        }else{
            
            [self.buyCountView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            
            UIScrollView *scrollViewTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
            [self.buyCountView addSubview:scrollViewTwo];
            scrollViewTwo.delegate = self;
            scrollViewTwo.contentSize = CGSizeMake(0, item_ArrayTwo.count *30);
            
            UIView *viewthree = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20 -170 - 20, 30)];
            
            UIView *cicleViewThree = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
            cicleViewThree.backgroundColor = colorC;
            [viewthree addSubview:cicleViewThree];
            UILabel *memLabelThree = [[UILabel alloc] init];
            [viewthree addSubview:memLabelThree];
            memLabelThree.text = [NSString stringWithFormat:@"%@   %.f次",@"新会员销售",[values[@"newmembersalescount"]floatValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            // UIFont *fnt = [UIFont systemFontOfSize:12];
            memLabelThree.textColor= [UIColor colorWithHexString:@"666666"];
            memLabelThree.font = fnt;
            // 根据字体得到NSString的尺寸
            CGSize sizeThree = [memLabelThree.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameHThree = sizeThree.height;
            // 名字的W
            CGFloat nameWThree = sizeThree.width;
            memLabelThree.frame = CGRectMake(CGRectGetMaxX(cicleViewThree.frame) + 5,0, nameWThree,nameHThree);
            memLabelThree.centerY = cicleViewThree.centerY;
            [scrollViewTwo addSubview:viewthree];
            
            
            UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewthree.frame), ScreenW - 20 -170 - 20, 30)];
            
            UIView *cicleViewFour = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
            cicleViewFour.backgroundColor = colorD;
            [viewFour addSubview:cicleViewFour];
            UILabel *memLabelFour = [[UILabel alloc] init];
            [viewFour addSubview:memLabelFour];
            memLabelFour.text = [NSString stringWithFormat:@"%@   %.f次",@"历史会员销售",[values[@"oldmembersalescount"]floatValue]];
            // 设置Label的字体 HelveticaNeue  Courier
            // UIFont *fnt = [UIFont systemFontOfSize:12];
            memLabelFour.textColor= [UIColor colorWithHexString:@"666666"];
            memLabelFour.font = fnt;
            // 根据字体得到NSString的尺寸
            CGSize sizeFour = [memLabelFour.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
            // 名字的H
            CGFloat nameHFour = sizeFour.height;
            // 名字的W
            CGFloat nameWFour = sizeFour.width;
            memLabelFour.frame = CGRectMake(CGRectGetMaxX(cicleViewFour.frame) + 5,0, nameWFour,nameHFour);
            memLabelFour.centerY = cicleViewFour.centerY;
            
            // cicleView.centerY = view.centerY;
            
            [scrollViewTwo addSubview:viewFour];
            
            
            //
            // 历史会员圈圈
            PNPieChart *chartTwo = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_ArrayTwo];
            chartTwo.descriptionTextColor = [UIColor whiteColor];
            chartTwo.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
            chartTwo.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
            chartTwo.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
            chartTwo.showOnlyValues = YES; // 只显示数值不显示内容描述
            
            chartTwo.innerCircleRadius = 0;
            
            
            [chartTwo strokeChart];
            
            //设置标注
            chartTwo.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
            chartTwo.legendFont = [UIFont boldSystemFontOfSize:12.0f];
            [self.buyCountView addSubview:chartTwo];
            
            
            
            
            //总消费额
            UILabel*V3sumlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
            V3sumlabelTwo.text = @"会员总购卡数量";
            V3sumlabelTwo.textAlignment = NSTextAlignmentCenter;
            V3sumlabelTwo.font = [UIFont systemFontOfSize:12];
            V3sumlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
            V3sumlabelTwo.adjustsFontSizeToFitWidth = YES;
            V3sumlabelTwo.minimumScaleFactor = 0.5;
            [self.buyCountView  addSubview:V3sumlabelTwo];
            
            
            UILabel *sumtextlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
            sumtextlabelTwo.text = [NSString stringWithFormat:@"%.2f",[values[@"allmembersalescount"] floatValue]];
            sumtextlabelTwo.textAlignment = NSTextAlignmentCenter;
            sumtextlabelTwo.font = [UIFont systemFontOfSize:14];
            sumtextlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
            [self.buyCountView  addSubview:sumtextlabelTwo];
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 售卡汇总
- (void)GetMemberCardSetmealRechargeInfoStart:(NSString *)start end:(NSString *)end page:(NSInteger)page pageSize:(NSInteger)pageSize day:(NSString *)day user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberCardSetmealRechargeInfo?key=%@&start=%@&end=%@&page=%ld&pagesize=%ld&day=%@&storeid=%@",token,start,[NSString stringWithFormat:@"%@ 23:59:59",end],page,pageSize,day,user_id];
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic售卡汇总 = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.valuesArray removeAllObjects];
            }
            
            NSArray *valuesArray = dic[@"values"][@"dataList"];
            if (!kArrayIsEmpty(valuesArray)) {
                 [self.valuesArray addObjectsFromArray:valuesArray];
                if (!kArrayIsEmpty(self.valuesArray)) {
                    
                    float order_receivable= 0.0;
                    float order_receivable_salescount = 0.0;
                    for (NSDictionary *dict in self.valuesArray) {
                        order_receivable += [dict[@"sv_favorablepricetotal"] floatValue];
                        order_receivable_salescount += [dict[@"salescount"] floatValue];
                    }
                    
                    CGFloat maxY = 0;
                    CGFloat MaxYTwo = 0;
                    
                    CGFloat maxHeight = 0;
                    [self.saleCardMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [self.saleCardCountView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    for (int i = 0; i < self.valuesArray.count ; i++) {
                        
                        NSDictionary *dictLeval = self.valuesArray[i];
                        
                        if ([dictLeval[@"sv_favorablepricetotal"] floatValue] == 0) {//数据为0时
                            
                        }else{
                            
                            SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(0, maxY, self.saleCardMoneyView.width, 48)];
                            maxHeight += 48;
                            rankingsV.namelabel.text = dictLeval[@"sv_p_name"];
                            rankingsV.moneylabel.text = [NSString stringWithFormat:@"￥%.2f",[dictLeval[@"sv_favorablepricetotal"]floatValue]];
                            if (order_receivable != 0) {
                                float twoWide = 210 * [dictLeval[@"sv_favorablepricetotal"]floatValue] / order_receivable;
                                
                                [UIView animateWithDuration:1 animations:^{
                                    rankingsV.colorView.width = twoWide;
                                }];
                                rankingsV.colorView.height = 15;
                                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                                //  maxY = maxY;
                                maxY = CGRectGetMaxY(rankingsV.frame);
                                [self.saleCardMoneyView addSubview:rankingsV];
                            }
                        }
                        
                        
                        if ([dictLeval[@"salescount"] floatValue] == 0) {//数据为0时
                            
                        }else{
                            
                            SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(0, MaxYTwo, self.saleCardMoneyView.width, 48)];
                            maxHeight += 48;
                            rankingsV.namelabel.text = dictLeval[@"sv_p_name"];
                            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[dictLeval[@"salescount"]floatValue]];
                            if (order_receivable != 0) {
                                float twoWide = 210 * [dictLeval[@"salescount"]floatValue] / order_receivable_salescount;
                                
                                [UIView animateWithDuration:1 animations:^{
                                    rankingsV.colorView.width = twoWide;
                                }];
                                rankingsV.colorView.height = 15;
                                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                                //  maxY = maxY;
                                MaxYTwo = CGRectGetMaxY(rankingsV.frame);
                                [self.saleCardCountView addSubview:rankingsV];
                            }
                        }
                        
                    }
                    self.twoHeight.constant = maxY + 113;
                }else{
                    [self.saleCardCountView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    [self.saleCardMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    self.twoHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    
                    UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    
                    [self.saleCardCountView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.saleCardCountView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                    
                    [self.saleCardMoneyView addSubview:img_two];
                    [img_two mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.saleCardMoneyView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }
            }else{
                if (kArrayIsEmpty(self.valuesArray)) {
                    [self.saleCardCountView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                     [self.saleCardMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    self.twoHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.saleCardCountView addSubview:img];
                    [self.saleCardMoneyView addSubview:img_two];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.saleCardCountView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                    
                    [img_two mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.saleCardMoneyView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }
            }

            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {

            [self.scrollView.mj_header endRefreshing];
        }

        if ([self.scrollView.mj_footer isRefreshing]) {

            [self.scrollView.mj_footer endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 次卡充次流水表
- (void)GetSetmealRechargeSerialInfoStart:(NSString *)start end:(NSString *)end page:(NSInteger)page pageSize:(NSInteger)pageSize day:(NSString *)day user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetSetmealRechargeSerialInfo?key=%@&dt1=%@&dt2=%@&page=%ld&pagesize=%ld&day=%@&storeid=%@",token,start,[NSString stringWithFormat:@"%@ 23:59:59",end],(long)page,(long)pageSize,day,user_id];
    //当URL拼接里有中文时，需要进行编码一下
    NSLog(@"次卡充次流水表url = %@",dURL);
    NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic次卡充次流水表 = %@",dic);
        self.oneLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"memberCardSetmealCount"]floatValue]];
        self.twoLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"salesCount"]floatValue]];
       self.threeLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"totalamount"]floatValue]];
        
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataList removeAllObjects];
            }
            
            NSArray *dataList = dic[@"values"][@"dataList"];
            if (!kArrayIsEmpty(dataList)) {
                [self.dataList addObjectsFromArray:dataList];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
              //  self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            self.fourHeight.constant = self.dataList.count *50 + 80 + 20;
        }else{
             [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVCardSalesFlowChartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVCardSalesFlowChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
  
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.dict = self.dataList[indexPath.row];
    cell.cancleBtn.tag = indexPath.row;
    cell.cancleBtn.sd_indexPath = indexPath;
    cell.Printingbtn.tag = indexPath.row;
    [cell.cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Printingbtn addTarget:self action:@selector(PrintingbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 点击打印小票按钮
- (void)PrintingbtnClick:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定补打小票吗?"];
    //设置文本颜色
    [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 8)];
    //设置文本字体大小
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,8)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.result = self.dataList[btn.tag];
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].quickOff isEqualToString:@"1"]) {
            //            [manage autoConnectLastPeripheralCompletion:^(CBPeripheral *perpheral, NSError *error) {
            //                if (!error) {
           // weakSelf.title = @"正在打印小票...";
            //  weakSelf.printeName = [NSString stringWithFormat:@"%@",perpheral.name];
            //延迟1秒，等待蓝牙连接后，再作打印
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVUserManager loadUserInfo];
                if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                    [SVUserManager shareInstance].printerNumber = @"1";
                    [SVUserManager saveUserInfo];
                }
                
                
                [SVUserManager loadUserInfo];
                for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                    if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                        [self fiftyEightPrinting];
                    }
                    
                    if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                        //[self eightyPrinting];
                        [self eightyPrinting];
                    }
                    //                    }
                    
                }
                
            });
            
        }else{
            
        }
    
    }];
    [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 验证聚合支付开关
- (void)AggregatePayment{
    [SVUserManager loadUserInfo];

    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL1=[URLhead stringByAppendingFormat:@"/api/UserModuleConfig?key=%@&moduleCode=Refund_Password_Manage",token];
    [[SVSaviTool sharedSaviTool] GET:dURL1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic9999 == %@",dic);
        NSArray *childInfolist = dic[@"data"][@"childInfolist"];
        if (!kArrayIsEmpty(childInfolist)) {
            for (NSDictionary *dict in childInfolist) {
                NSString *sv_user_config_code = dict[@"sv_user_config_code"];
                if ([sv_user_config_code isEqualToString:@"Refund_Password_Switch"]) {

                    NSArray *childDetailList = dict[@"childDetailList"];
                    if (kArrayIsEmpty(childDetailList)) {

                        self.isAggregatePayment = false;
                    }else{
                        NSDictionary *dict1 = childDetailList[0];
                        NSString *sv_detail_is_enable = [NSString stringWithFormat:@"%@",dict1[@"sv_detail_is_enable"]];

                        if (sv_detail_is_enable.intValue == 1) {
//                            [self oneCancelResponseEvent];
//                            //      [self.singleView.determineButton setEnabled:NO];
//                            [self.addCustomView removeFromSuperview];
//                            self.selectWholeOrder = 0;//0是单品1是整单
//                            [self.addCustomView.textView becomeFirstResponder];// 2
//                            [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
//                            [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
                            self.isAggregatePayment = true;
                        }else{
                            self.isAggregatePayment = false;
                        }
                    }

                    break;
                }else{
                    self.isAggregatePayment = false;
                }
            }
        }else{
            self.isAggregatePayment = false;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 决定撤销
- (void)cancleClick:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定撤销吗?"];
    //设置文本颜色
    [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 6)];
    //设置文本字体大小
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,6)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dict = self.dataList[btn.tag];
        self.btn = btn;
        self.dict = dict;
        NSString *sv_mcr_payment = self.dict[@"sv_mcr_payment"];
        NSArray *setmealrechargedetail=dict[@"setmealrechargedetail"];
     //   NSString *sv_mcr_payment;
//        if (!kArrayIsEmpty(setmealrechargedetail)) {
//            sv_mcr_payment =setmealrechargedetail[0][@"sv_mcr_payment"];
//        }
        
                    [SVUserManager loadUserInfo];
                     // NSString *token = [SVUserManager shareInstance].access_token;
                      NSString *dec_payment_method =[SVUserManager shareInstance].dec_payment_method;
                      
        [SVUserManager loadUserInfo];
        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
        if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && ([sv_mcr_payment isEqualToString:@"微信"] || [sv_mcr_payment isEqualToString:@"支付宝"] || [sv_mcr_payment isEqualToString:@"云闪付"] || [sv_mcr_payment isEqualToString:@"龙支付"])) {// 开通了聚合支付
           [SVUserManager loadUserInfo];
                    NSString *token = [SVUserManager shareInstance].access_token;
           NSString *dURL1=[URLhead stringByAppendingFormat:@"/api/UserModuleConfig?key=%@&moduleCode=Refund_Password_Manage",token];
           // NSString *utf = [dURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[SVSaviTool sharedSaviTool] GET:dURL1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"dic9999 == %@",dic);
                if ([dic[@"code"] intValue] == 1) {
                    NSArray *childInfolist = dic[@"data"][@"childInfolist"];
                    if (!kArrayIsEmpty(childInfolist)) {
                        for (NSDictionary *dict in childInfolist) {
                            NSString *sv_user_config_code = dict[@"sv_user_config_code"];
                            if ([sv_user_config_code isEqualToString:@"Refund_Password_Switch"]) {
                                
                                NSArray *childDetailList = dict[@"childDetailList"];
                                if (kArrayIsEmpty(childDetailList)) {
                                    [self tuihuoFuction];
    //                                [SVTool TextButtonActionWithSing:@"没有开通密码开关"];
                                }else{
                                   NSDictionary *dict1 = childDetailList[0];
                                    
                                   NSString *sv_detail_is_enable = [NSString stringWithFormat:@"%@",dict1[@"sv_detail_is_enable"]];
                                    
                                    if (sv_detail_is_enable.intValue == 1)  {
                                        
                                        [self.addCustomView.textView becomeFirstResponder];// 2
                                        [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                                        [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
                                    }else{
                                       // [SVTool TextButtonActionWithSing:@"没有开通密码开关"];
                                        [self tuihuoFuction];
                                    }
                                    
                                }
                                
                                
                                break;
                            }else{
                                [self tuihuoFuction];
                            }
                        }
                    }else{
                        [self tuihuoFuction];
                    }
                }else{
                    NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                    [SVTool TextButtonActionWithSing:kStringIsEmpty(errmsg)?@"网络开小差":errmsg];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //隐藏提示框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
             
        }else if (self.isAggregatePayment == TRUE &&dec_payment_method.doubleValue == 5 && ([sv_mcr_payment isEqualToString:@"微信"] || [sv_mcr_payment isEqualToString:@"支付宝"] || [sv_mcr_payment isEqualToString:@"云闪付"] || [sv_mcr_payment isEqualToString:@"龙支付"])){// 开通了聚合支付
            [SVUserManager loadUserInfo];
                     NSString *token = [SVUserManager shareInstance].access_token;
            NSString *dURL1=[URLhead stringByAppendingFormat:@"/api/UserModuleConfig?key=%@&moduleCode=Refund_Password_Manage",token];

             [[SVSaviTool sharedSaviTool] GET:dURL1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                         NSLog(@"dic9999 == %@",dic);
                 if ([dic[@"code"] intValue] == 1) {
                     NSArray *childInfolist = dic[@"data"][@"childInfolist"];
                     if (!kArrayIsEmpty(childInfolist)) {
                         for (NSDictionary *dict in childInfolist) {
                             NSString *sv_user_config_code = dict[@"sv_user_config_code"];
                             if ([sv_user_config_code isEqualToString:@"Refund_Password_Switch"]) {
                                 
                                 NSArray *childDetailList = dict[@"childDetailList"];
                                 if (kArrayIsEmpty(childDetailList)) {
                                     [self tuihuoFuction];
     //                                [SVTool TextButtonActionWithSing:@"没有开通密码开关"];
                                 }else{
                                    NSDictionary *dict1 = childDetailList[0];
                                     
                                    NSString *sv_detail_is_enable = [NSString stringWithFormat:@"%@",dict1[@"sv_detail_is_enable"]];
                                     
                                     if (sv_detail_is_enable.intValue == 1)  {
                                         
                                         [self.addCustomView.textView becomeFirstResponder];// 2
                                         [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                                         [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
                                     }else{
                                        // [SVTool TextButtonActionWithSing:@"没有开通密码开关"];
                                         [self tuihuoFuction];
                                     }
                                     
                                 }
                                 
                                 
                                 break;
                             }else{
                                 [self tuihuoFuction];
                             }
                         }
                     }else{
                         [self tuihuoFuction];
                     }
                 }else{
                     NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                     [SVTool TextButtonActionWithSing:kStringIsEmpty(errmsg)?@"网络开小差":errmsg];
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     //隐藏提示框
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
             }];
              
         }else{
            [self tuihuoFuction];
        }
  
    
    }];
    [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 退货
- (void)tuihuoFuction{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/CancelSetmealRecharge?key=%@&serialnumber=%@",token,[NSString stringWithFormat:@"%@",self.dict[@"sv_serialnumber"]]];
    [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"succeed"] intValue] == 1) {
            SVCardSalesFlowChartCell *cell = [self.tableView cellForRowAtIndexPath:self.btn.sd_indexPath];
            [cell.cancleBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            cell.cancleBtn.userInteractionEnabled = NO;
            [cell.cancleBtn setTitle:@"已撤销" forState:UIControlStateNormal];
        }else{
           NSString *errmsg= [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
            if (!kStringIsEmpty(errmsg)) {
                [SVTool TextButtonActionWithSing:errmsg];
            }else{
                [SVTool TextButtonActionWithSing:@"撤销失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 自定义弹框的确定按钮
- (void)sureBtnClick{
  
    if (!kStringIsEmpty(self.addCustomView.textView.text)) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"正在撤销中...";
        hud.label.textColor = [UIColor whiteColor];//字体颜色
        hud.bezelView.color = [UIColor blackColor];//背景颜色
        hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
        hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
        //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
        hud.yOffset = -50.0f;
              [SVUserManager loadUserInfo];
               // NSString *token = [SVUserManager shareInstance].access_token;
                    NSString *passWord = self.addCustomView.textView.text;
                    //密码进行MD5加密
                       NSString *pwdMD5=[JWXUtils EncodingWithMD5:passWord].uppercaseString;
                    [SVUserManager loadUserInfo];
                         // NSDictionary *dict = self.dataList[btn.tag];
                          NSString *token = [SVUserManager shareInstance].access_token;
                          NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/CancelSetmealRecharge?key=%@&serialnumber=%@&refundPassword=%@",token,[NSString stringWithFormat:@"%@",self.dict[@"sv_serialnumber"]],pwdMD5];
                          [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                              if ([dic[@"succeed"] intValue] == 1) {
                                  
                                  [SVUserManager loadUserInfo];
                                  NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
                                  if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {
                                      NSString *order_number = [NSString stringWithFormat:@"%@",dic[@"order_number"]];
                                      self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
                                     // self.showView.center = self.view.center;
                                      //  self.showView.delegate = self;
                                      self.showView.center = self.view.center;
                                      [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
                                      // [self.view addSubview:self.showView];
                                      
                                      //按钮实现倒计时
                                      __block int timeout=60; //倒计时时间
                                      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                      dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                                      dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                                      dispatch_source_set_event_handler(_timer, ^{
                                          if(timeout<=0){ //倒计时结束，关闭
                                              dispatch_source_cancel(_timer);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.showView removeFromSuperview];
                                                  
                                              });
                                          }else{
                                              [self refundResultQueryId:order_number _timer:_timer];
                                              int seconds = timeout;
                                              NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                                              NSLog(@"strTime = %@",strTime);
                                              
                                              timeout--;
                                          }
                                      });
                                      dispatch_resume(_timer);
                                      
                                      self.showView.selectCancleBlock = ^{
                                          dispatch_source_cancel(_timer);
                                      };
                                  }else{
//                                      NSString *errmsg= [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
//                                      [SVTool TextButtonActionWithSing:errmsg];
                                      hud.mode = MBProgressHUDModeText;
                                      hud.label.text = @"撤销成功";
                                      hud.label.textColor = [UIColor whiteColor];//字体颜色
                                      
                                      SVCardSalesFlowChartCell *cell = [self.tableView cellForRowAtIndexPath:self.btn.sd_indexPath];
                                     [cell.cancleBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                                     [cell.cancleBtn setTitle:@"已撤销" forState:UIControlStateNormal];
                                     cell.cancleBtn.userInteractionEnabled = NO;
                                  }
                                
                              }else{
                                  NSString *errmsg= [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                                  if (kStringIsEmpty(errmsg)) {
                                      [SVTool TextButtonActionWithSing:errmsg];
                                      hud.mode = MBProgressHUDModeText;
                                      hud.label.text = @"撤销失败";
                                      hud.label.textColor = [UIColor whiteColor];//字体颜色
                                  }else{
                                     // [SVTool TextButtonActionWithSing:@"撤销失败"];
                                      hud.mode = MBProgressHUDModeText;
                                      hud.label.text = errmsg;
                                      hud.label.textColor = [UIColor whiteColor];//字体颜色
                                  }
                              }
                              //隐藏提示
                              //                 //用延迟来移除提示框
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  //隐藏提示
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  //返回上一控制器
//                                  [self.navigationController popViewControllerAnimated:YES];
                              });
                            //  ss
                              
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              //隐藏提示框
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                          }];
                   
    }else{
        [SVTool TextButtonActionWithSing:@"请输入密码"];
    }
                   
            
            [self.addCustomView.textView endEditing:YES];
            [self vipCancelResponseEvent];
            
            self.addCustomView.textView.text = nil;
    

  
}


#pragma mark - 查询退款结果 轮训
- (void)refundResultQueryId:(NSString *)queryId _timer:(dispatch_source_t)_timer{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/Refund/%@?key=%@",queryId,[SVUserManager shareInstance].access_token];
    NSLog(@"url = %@",url);
   // NSString *utf = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

          NSLog(@"dic查询退款结果 == %@",dic);
         if ([dic[@"code"] integerValue] == 1) {
             NSString *action = [NSString stringWithFormat:@"%@",dic[@"data"][@"action"]];
             NSString *msg = dic[@"data"][@"msg"];
             if (action.integerValue == -1) {// 停止轮训
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
                 [SVTool TextButtonActionWithSing:!kStringIsEmpty(msg)?msg:@"退款有误"];
             }else if(action.integerValue == 1){// 1:Success,取到结果;
                 [SVTool TextButtonActionWithSing:@"退款成功"];
                 
                 SVCardSalesFlowChartCell *cell = [self.tableView cellForRowAtIndexPath:self.btn.sd_indexPath];
                [cell.cancleBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [cell.cancleBtn setTitle:@"已撤销" forState:UIControlStateNormal];
                cell.cancleBtn.userInteractionEnabled = NO;
//                hud.mode = MBProgressHUDModeText;
//                hud.label.text = @"撤销成功";
//                hud.label.textColor = [UIColor whiteColor];//字体颜色
//                 if (self.RevokeBlock) {
//                     self.RevokeBlock();
//                 }
                 
                 //隐藏提示
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
                 
//                 //用延迟来移除提示框
//                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                     //隐藏提示
//                     [MBProgressHUD hideHUDForView:self animated:YES];
//                     //返回上一控制器
//                     [self.navigationController popViewControllerAnimated:YES];
//                 });
                 
             }else{// 2:Continue,继续轮询;

             }
         }else{

         }


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.name.text = @"输入密码";
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}
- (void)cancleBtnClick{
  //  [self sureBtnClick];
    [self vipCancelResponseEvent];
}

//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
   // [self.vipPickerView removeFromSuperview];
    [self.addCustomView removeFromSuperview];
  //  [self.setUserdItemView removeFromSuperview];
    
    //[self.tableView reloadData];
    
}

/**
 等级遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}
@end

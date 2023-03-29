//
//  SVPaySuccessVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVPaySuccessVC.h"
#import "SVHomeVC.h"

//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;
@interface SVPaySuccessVC () <CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property(nonatomic,strong) NSTimer *clockTimer;
@property(nonatomic,assign) NSInteger seconds;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;

//@property (strong,nonatomic) CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;
@end

@implementation SVPaySuccessVC

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
                self.title = @"结算";
            }
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn.layer.cornerRadius = 20;
    self.btn.layer.masksToBounds = YES;
    _seconds = 3;
    self.payMoney.text = [NSString stringWithFormat:@"￥%.2f",self.money];
     [self.btn setTitle:@"返回首页(3s)" forState:UIControlStateNormal];
    _clockTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(oneSecondPass) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_clockTimer forMode:NSDefaultRunLoopMode];
    
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
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].quickOff isEqualToString:@"1"]) {
        //            [manage autoConnectLastPeripheralCompletion:^(CBPeripheral *perpheral, NSError *error) {
        //                if (!error) {
        weakSelf.title = @"正在打印小票...";
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
        self.title = @"结算";
     //   [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"mcr_date"] substringToIndex:10],[self.result[@"mcr_date"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"充次账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"会员卡号:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_card"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员名称:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_name"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员电话:" value:[NSString stringWithFormat:@"%@",self.member_tel] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"储值余额:" value:[NSString stringWithFormat:@"%.2f",self.storedValue] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"操作员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"次卡名称:" value:[NSString stringWithFormat:@"%@",self.sv_p_name] fontSize:HLFontSizeTitleSmalle];
//    [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
//    [printer appendTitle:@"收银员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
 
   
    [printer appendSeperatorLine];
    
    [printer appendLeftText:@"项目" middleText:@"购买数" rightText:@"赠送数" isTitle:NO];
    for (NSDictionary *dict in [self.result objectForKey:@"MembercardRechargeList"]) {

        [printer appendLeftText:dict[@"sv_mcr_productname"] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_purchase_number"] doubleValue]] rightText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_give_number"]doubleValue]] isTitle:NO];
            
        }
        
        
  //  }
    [printer appendSeperatorLine];
    
    [printer appendTitle:@"付款金额:" value:[NSString stringWithFormat:@"%.2f",[self.result[@"favorableprice"] doubleValue]] fontSize:HLFontSizeTitleSmalle];
    if (!kStringIsEmpty(self.paymentStr)) {
        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.paymentStr] fontSize:HLFontSizeTitleSmalle];
        self.paymentStr = nil;
    }else{
        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.result[@"mcr_payment"]] fontSize:HLFontSizeTitleSmalle];
    }
    
    [printer appendSeperatorLine];
    
 

    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
    }
    
    [printer appendSeperatorLine];
    

    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
        [printer appendSeperatorLine];
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:500];
        self.queryId = nil;
    }
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
        self.title = @"结算";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"order_datetime"] substringToIndex:10],[self.result[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"充次账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"会员卡号:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_card"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员名称:" value:[NSString stringWithFormat:@"%@",self.result[@"menber_name"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"会员电话:" value:[NSString stringWithFormat:@"%@",self.member_tel] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"储值余额:" value:[NSString stringWithFormat:@"%.2f",self.storedValue] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"操作员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"次卡名称:" value:[NSString stringWithFormat:@"%@",self.sv_p_name] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendSeperatorLine80];
    
    [printer eightAppendLeftText:@"项目" middleText:@"购买数" rightText:@"赠送数" isTitle:NO];
    for (NSDictionary *dict in [self.result objectForKey:@"prlist"]) {
        [printer eightAppendLeftText:dict[@"sv_mcr_productname"] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_purchase_number"] doubleValue]] rightText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_give_number"]doubleValue]] isTitle:NO];
    }

    [printer appendSeperatorLine80];
    
    [printer appendTitle:@"付款金额:" value:[NSString stringWithFormat:@"%.2f",[self.result[@"favorableprice"] doubleValue]] fontSize:HLFontSizeTitleSmalle];
    if (!kStringIsEmpty(self.paymentStr)) {
        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.paymentStr] fontSize:HLFontSizeTitleSmalle];
        self.paymentStr = nil;
    }else{
        [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.result[@"mcr_payment"]] fontSize:HLFontSizeTitleSmalle];
    }
    
    [printer appendSeperatorLine80];

    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
    }
    

    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
        [printer appendSeperatorLine80];
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:500];
        self.queryId = nil;
    }
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

//
//- (NSArray *)array
//{
//    if (_array == nil) {
//        _array = [NSArray array];
//    }
//    return _array;
//}

- (void)oneSecondPass{
    if (_seconds > 1) {
        _seconds =_seconds-1;
        [self.btn setTitle:[NSString stringWithFormat:@"返回首页(0%lds)",_seconds] forState:UIControlStateNormal];
    } else{
        [_clockTimer invalidate];
        _clockTimer = nil;
        // 返回到任意界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[SVHomeVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
    }
}
- (IBAction)btnClick:(id)sender {
    [_clockTimer invalidate];
    _clockTimer = nil;
    // 返回到任意界面
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SVHomeVC class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }

}


@end

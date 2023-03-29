//
//  SVShowCheckoutVC.m
//  SAVI
//
//  Created by Sorgle on 2017/5/25.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVShowCheckoutVC.h"
#import "SVSelectWaresVC.h"
#import "SVOrderListVC.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;

@interface SVShowCheckoutVC () <CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}

@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *payWay;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

//@property (strong,nonatomic) CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;
@property (nonatomic,strong) NSString *values;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) NSDictionary *result;
@end

@implementation SVShowCheckoutVC

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
    //设置导航标题
    self.title = @"结算";
    
    self.dataSource = @[].mutableCopy;
    self.rssisArray = @[].mutableCopy;
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.amount.text = [NSString stringWithFormat:@"￥%@",self.money];
    self.payWay.text = [NSString stringWithFormat:@"%@ 交易成功",self.pay];
    
    self.oneButton.layer.cornerRadius = ButtonCorner;
    self.twoButton.layer.cornerRadius = ButtonCorner;
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
    
    if (self.selectNumber == 1) { // 聚合支付的
        self.result = self.md_two;
        NSLog(@"self.md = %@",self.md);
    }else{
        self.result = self.md_two;
        NSLog(@"self.md = %@",self.md);
    }
    
    
    
    if (self.interface == 4) {
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
        
    }else{
        
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
                
                
            }
            
        });
        
    }
  
    
}

- (void)setUpUI{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/HardwareStore/GetUserModuleConfig?key=%@&code=PrintSet_ExtraInfo",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        self.values = dic[@"values"];
        NSLog(@"dic889898 = %@",dic);
        
        NSArray *array = [NSArray array];
        if ([self.values containsString:@"<br/>"]) {
            array  = [self.values componentsSeparatedByString:@"<br/>"];
            
        }
        self.array = array;
        NSLog(@"array = %@",array);
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (IBAction)determineRespondEvents {
    
    if (self.interface == 1 || self.interface == 2) {
        
        // 返回到任意界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[SVSelectWaresVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
    } else if (self.interface == 4){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (self.interface == 3) {
        
        // 返回到任意界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[SVOrderListVC class]]) {
                
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
    }else{
        // 返回到任意界面
              for (UIViewController *temp in self.navigationController.viewControllers) {
                  if ([temp isKindOfClass:[SVSelectWaresVC class]]) {
                      [self.navigationController popToViewController:temp animated:YES];
                  }
              }
    }
    
}

- (IBAction)newVipRespondEvents {
    NSString *nums = [SVUserManager shareInstance].sv_app_config;
    if (0 >= nums.length) {
        SVNewVipVC *VC = [[SVNewVipVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
            NSString *nums = [SVUserManager shareInstance].sv_app_config;
            
            if (0 + 1 > nums.length) {
                //隐藏TabBar
                SVNewVipVC *VC = [[SVNewVipVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(0,1)];
                NSLog(@"num %@",num);
                
                if ([num isEqualToString:@"0"]) {
                    [SVTool TextButtonAction:self.view withSing:@"亲,你还没有该权限"];
                    return;
                }
                SVNewVipVC *VC = [[SVNewVipVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
            
        }
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
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"order_datetime"] substringToIndex:10],[self.result[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"结账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.result[@"order_running_id"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"收银员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        [printer appendLeftText:@"品名/款号" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }else{
        [printer appendLeftText:@"品名/条码" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }
   
    [printer appendSeperatorLine];
    
    CGFloat total = 0.0;
    CGFloat totle_Discount_money = 0.0;
    CGFloat totle_count = 0.0;
    CGFloat totle_count_total = 0.0;
    for (SVProductResultslList *resultslModel in self.productResultsData.productResults) {

            NSString *product_name = resultslModel.productName;
            // dict[@"sv_p_specs"] sepcs
            if (kStringIsEmpty(resultslModel.sepcs)) {
                [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
            }else{
                [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, resultslModel.sepcs] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
            }
            
           // if ([dict[@"product_total_bak"] doubleValue] == 0) {
                [printer appendLeftText:[NSString stringWithFormat:@"%@",resultslModel.barCode] middleText:[NSString stringWithFormat:@"%.2f",resultslModel.price] rightText:[NSString stringWithFormat:@"%.1f",resultslModel.number] priceText:[NSString stringWithFormat:@"%.2f",resultslModel.totalMoney] isTitle:NO];

            
        
            if (resultslModel.orderCouponMoney > 0) {
                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",resultslModel.orderCouponMoney] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
            }
        
    }
    
    
    [printer appendSeperatorLine];
    
    [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.f",self.productResultsData.dealNumber] priceText:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] isTitle:NO];
    [printer appendSeperatorLine];
    
    /**
     优惠
     */
    if (self.productResultsData.couponMoney > 0) {
        [printer appendTitle:@"优惠：" value:[NSString stringWithFormat:@"%.2f",self.productResultsData.couponMoney]];//order_money
    }
    
  //  if (self.productResultsData.totalMoney >0) {
        [printer appendTitle:@"应收：" value:[NSString stringWithFormat:@"%.2f",self.productResultsData.totalMoney]];
  //  }
    
    
    if (self.productResultsData.freeZeroMoney != 0) {
        [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.2f",self.productResultsData.freeZeroMoney]];
    }
    
    
    [printer appendTitle:[NSString stringWithFormat:@"%@：",self.result[@"order_payment"]] value:[NSString stringWithFormat:@"%.2f",[self.result[@"order_money"] doubleValue]]];
    
    
    if (![self.result[@"order_payment2"] isEqualToString:@"待收"]) {
        [printer appendTitle:[NSString stringWithFormat:@"%@：",self.result[@"order_payment2"]] value:[NSString stringWithFormat:@"%.2f",[self.result[@"order_money2"] doubleValue]]];
    }
    
    if ([self.result[@"order_change"] doubleValue] != 0) {
        [printer appendTitle:@"现金找零：" value:[NSString stringWithFormat:@"%.2f",[self.result[@"order_change"] doubleValue]]];
    }
    
    
    if (!kStringIsEmpty(self.vipName)) {
        [printer appendSeperatorLine];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mr_name"]]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.md_two[@"sv_mr_cardno"]]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.storedValue doubleValue]]];
        
        [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.order_integral doubleValue]]];
        
        [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",[self.order_integral doubleValue] + [self.member_Cumulative doubleValue]]];
        
    }
    [printer appendSeperatorLine];



    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
    }
    
    if (!kStringIsEmpty(self.sv_remarks)) {
        [printer appendTitle:@"备注：" value:self.sv_remarks];
    }
    
    if ([[SVUserManager shareInstance].imageOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].imageStr)) {
            NSString *str = [URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].imageStr];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            UIImage *image = [UIImage imageWithData:data];
            [printer appendImage:image alignment:HLTextAlignmentCenter maxWidth:200];
        }
    }
    
    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            [printer appendNewLine];
            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
        }
    }
    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
        [printer appendSeperatorLine];
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:500];
        self.queryId = nil;
    }
    
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
    
    [printer appendText:@"结账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.result[@"order_running_id"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"收银员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine80];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        
        [printer eightAppendLeftText:@"品名/款号" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }else{
        
        [printer eightAppendLeftText:@"品名/条码" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }
    [printer appendSeperatorLine80];
    
    CGFloat total = 0.0;
    CGFloat totle_Discount_money = 0.0;
    CGFloat totle_count = 0.0;
    CGFloat totle_count_total = 0.0;
    for (SVProductResultslList *resultslModel in self.productResultsData.productResults) {
       // if (![dict[@"product_name"] containsString:@"(套餐)"]) {
            
//            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
//            // dict[@"sv_p_specs"]
//            if (kStringIsEmpty(dict[@"sv_p_specs"])) {
//                [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
//            }else{
//                [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
//            }
//
//
//            [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"PrintingDiscount"] doubleValue]] rightText:[NSString stringWithFormat:@"%.1f",[dict[@"product_num"] doubleValue]] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total"] doubleValue]] isTitle:NO];
//
//
//            totle_count = [dict[@"product_num"] doubleValue] + [dict[@"sv_p_weight"] doubleValue];
//            totle_count_total += [dict[@"product_num"] doubleValue] + [dict[@"sv_p_weight"] doubleValue];
//
//            CGFloat orderCouponMoney = [dict[@"orderCouponMoney"] doubleValue];
//            if (orderCouponMoney > 0) {
//                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",orderCouponMoney] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
//            }
//
//        }
        
        NSString *product_name = resultslModel.productName;
        // dict[@"sv_p_specs"] sepcs
        if (kStringIsEmpty(resultslModel.sepcs)) {
            [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
        }else{
            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, resultslModel.sepcs] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
        }
        
       // if ([dict[@"product_total_bak"] doubleValue] == 0) {
            [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",resultslModel.barCode] middleText:[NSString stringWithFormat:@"%.2f",resultslModel.price] rightText:[NSString stringWithFormat:@"%.1f",resultslModel.number] priceText:[NSString stringWithFormat:@"%.2f",resultslModel.totalMoney] isTitle:NO];

        
    
        if (resultslModel.orderCouponMoney > 0) {
            [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",resultslModel.orderCouponMoney] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
        }
    }
    [printer appendSeperatorLine80];
    
    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.f",self.productResultsData.dealNumber] priceText:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] isTitle:NO];
    [printer appendSeperatorLine80];
    
    /**
     优惠
     */
    if (self.productResultsData.couponMoney > 0) {
        [printer appendTitle:@"优惠：" value:[NSString stringWithFormat:@"%.1f",self.productResultsData.couponMoney]];//order_money
    }
    
  //  if (self.productResultsData.totalMoney >0) {
        [printer appendTitle:@"应收：" value:[NSString stringWithFormat:@"%.1f",self.productResultsData.totalMoney]];
  //  }
    
    
    if (self.productResultsData.freeZeroMoney != 0) {
        [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.1f",self.productResultsData.freeZeroMoney]];
    }
    
    
    [printer appendTitle:[NSString stringWithFormat:@"%@：",self.result[@"order_payment"]] value:[NSString stringWithFormat:@"%.1f",[self.result[@"order_money"] doubleValue]]];
    
    
    if (![self.result[@"order_payment2"] isEqualToString:@"待收"]) {
        [printer appendTitle:[NSString stringWithFormat:@"%@：",self.result[@"order_payment2"]] value:[NSString stringWithFormat:@"%.1f",[self.result[@"order_money2"] doubleValue]]];
    }
    
    if ([self.result[@"order_change"] doubleValue] != 0) {
        [printer appendTitle:@"现金找零：" value:[NSString stringWithFormat:@"%.2f",[self.result[@"order_change"] doubleValue]]];
    }
    
    if (!kStringIsEmpty(self.vipName)) {
        [printer appendSeperatorLine80];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.result[@"sv_mr_name"]]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.md_two[@"sv_mr_cardno"]]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.storedValue doubleValue]]];
        
        [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.order_integral doubleValue]]];
        [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",[self.order_integral doubleValue] + [self.member_Cumulative doubleValue]]];
        
    }
    [printer appendSeperatorLine80];
    // [printer setLineSpace:60];
    
    //    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
    //        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_ul_mobile];
    //    }
    //
    //    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
    //        [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
    //    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
    }
    
    if (!kStringIsEmpty(self.sv_remarks)) {
        [printer appendTitle:@"备注：" value:self.sv_remarks];
    }
    
    if ([[SVUserManager shareInstance].imageOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].imageStr)) {
            NSString *str = [URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].imageStr];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            UIImage *image = [UIImage imageWithData:data];
            [printer appendImage:image alignment:HLTextAlignmentCenter maxWidth:200];
        }
    }
    
    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            [printer appendNewLine];
            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
        }
    }
    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
        [printer appendSeperatorLine80];
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:500];
        self.queryId = nil;
    }
    
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


- (NSArray *)array
{
    if (_array == nil) {
        _array = [NSArray array];
    }
    return _array;
}

@end

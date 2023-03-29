//
//  SVOnlineOrderDetailVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/3/18.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVOnlineOrderDetailVC.h"
#import "SVMoveOrderModel.h"
#import "SVOrderDetailCell.h"
#import "SVOrderProductListModel.h"

//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;

static NSString *const ID = @"SVOrderDetailCell";
@interface SVOnlineOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}
/**
 付款方式
 */
@property (weak, nonatomic) IBOutlet UILabel *labelOne;

/**
 付款状态
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;

/**
 收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
/**
 配送方式
 */
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
/**
 收货电话
 */
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
/**
 收货地址
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
/**
 销售单号
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
/**
下单时间
 */
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
/**
 应收金额
 */
@property (weak, nonatomic) IBOutlet UILabel *AmountReceivable;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

//@property (strong,nonatomic) CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;

//@property (nonatomic,strong) NSDictionary *moveOrder;

@property (nonatomic,strong) NSDictionary *prdata_dic;
@end

@implementation SVOnlineOrderDetailVC

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
               // self.title = @"结算";
            }
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"订单详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVOrderDetailCell" bundle:nil] forCellReuseIdentifier:ID];
     self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
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
    
    
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    
    [button setImage:[UIImage imageNamed:@"dayin_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    
    
   // self.tableViewHeight.constant = self.dataArray.count *60;
           
    [self.tableView reloadData];
   // [self setUPData];
}
#pragma mark - 订单明细打印
- (void)addWaresButton{
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
}

//- (void)setUPData{
//    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
//    [SVUserManager loadUserInfo];
//    NSString *token = [SVUserManager shareInstance].access_token;
//    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/OnlineOrder/GetMoveOrderDetail?key=%@&orderId=%@",token,self.orderId];
//    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dic订单详情 = %@",dic);
//        NSDictionary *moveOrder = dic[@"values"][@"moveOrder"];
//        SVMoveOrderModel *model = [SVMoveOrderModel mj_objectWithKeyValues:moveOrder];
//        self.prdata_dic = moveOrder;
//        self.labelOne.text = model.order_payment;
//        if (model.order_state == 0) {// 待付款
//            self.labelTwo.text = @"代付款";
//        }else if (model.order_state == 1){
//            self.labelTwo.text = @"已付款";
//        }else{
//            self.labelTwo.text = @"已取消";
//        }
//        
//        self.labelThree.text = model.sv_receipt_name;
//        if ([model.sv_shipping_methods isEqualToString:@"0"]) {
//            self.labelFour.text = @"到店自提";
//        }else{
//            self.labelFour.text = @"商家配送";
//        }
//        
//        self.labelFive.text = model.sv_receipt_phone;
//        self.labelSix.text = model.getShopAddress;
//        self.labelSeven.text = model.sv_order_number;
//        self.labelEight.text = model.sv_order_adddate;
//        self.AmountReceivable.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable doubleValue]];
//        /**
//         免运费
//         */
//        if (model.sv_prduct_freight > 0) {
//            self.yunfeiLabel.text = [NSString stringWithFormat:@"其中包含运费%.2f元",model.sv_prduct_freight];
//        }else{
//            self.yunfeiLabel.text = @"免运费";
//        }
//        
//        self.dataArray = moveOrder[@"productList"];
////        if (!kArrayIsEmpty(productList)) {
////             = [SVOrderProductListModel mj_objectArrayWithKeyValuesArray:productList];
////        }
//        
//        self.tableViewHeight.constant = self.dataArray.count *60;
//        
//        [self.tableView reloadData];
//        
//        //隐藏提示框
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //隐藏提示框
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//    }];
//    
//}

//58打印
-(void)fiftyEightPrinting {
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.prdata_dic[@"sv_order_adddate"] substringToIndex:10],[self.prdata_dic[@"sv_order_adddate"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"线上订单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"单号：" value:[NSString stringWithFormat:@"%@",self.prdata_dic[@"sv_order_number"]] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间：" value:timeString fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"收银员：" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        [printer appendLeftText:@"品名/款号" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }else{
        
        [printer appendLeftText:@"品名/条码" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }
    
    [printer appendSeperatorLine];
    
    double total = 0.0;
    double totle_Discount_money = 0.0;
    double totle_numcount = 0.0;
    double totle_numcount_all = 0.0;
    for (NSDictionary *dict in self.dataArray) {
 
           totle_numcount = [dict[@"sv_product_num"] doubleValue];
            
            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
        NSString *sv_p_specs = dict[@"sv_p_specs"];
        if (kStringIsEmpty(sv_p_specs)) {
             [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
        }else{
             [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
        }
        
            [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] doubleValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_product_total"] doubleValue]] isTitle:NO];
            
            //            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
            
            CGFloat Discount_money = [dict[@"product_price"] doubleValue] * totle_numcount - [dict[@"sv_product_unitprice"] doubleValue] * totle_numcount;
            if (Discount_money > 0) {
                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
            }
       Discount_money = [dict[@"sv_product_total"]doubleValue];
            totle_Discount_money += Discount_money;
            totle_numcount_all += totle_numcount;

    }
    
    
    [printer appendSeperatorLine];
    [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",totle_Discount_money] isTitle:NO];
    [printer appendSeperatorLine];
    
    /**
     优惠
     */
   
        [printer appendTitle:@"支付方式：" value:self.prdata_dic[@"order_payment"]];//order_money
   
    [printer appendSeperatorLine];
    // [printer setLineSpace:60];
    
   
        [printer appendTitle:@"收货人：" value:self.prdata_dic[@"sv_receipt_name"]];
    [printer appendTitle:@"收货电话：" value:self.prdata_dic[@"sv_receipt_phone"]];
    
    [printer appendTitle:@"收货地址：" value:self.prdata_dic[@"getShopAddress"]];

    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            [printer appendNewLine];
            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
        }
    }
    
    // [printer appendFooter:nil];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer cutter];
    NSData *mainData = [printer getFinalData];
    WeakSelf
    [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            NSLog(@"打印成功");
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
    }];
}

//80打印
-(void)eightyPrinting {

    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.prdata_dic[@"sv_order_adddate"] substringToIndex:10],[self.prdata_dic[@"sv_order_adddate"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"补打单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.prdata_dic[@"sv_order_number"]] fontSize:HLFontSizeTitleSmalle];
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
    
    //    CGFloat total = 0.0;
    //    CGFloat totle_Discount_money = 0.0;
    CGFloat total = 0.0;
    CGFloat totle_Discount_money = 0.0;
    CGFloat totle_numcount = 0.0;
    CGFloat totle_numcount_all = 0.0;
    for (NSDictionary *dict in self.dataArray) {
      //  if (![dict[@"product_name"] containsString:@"(套餐)"]) {
//            CGFloat sv_p_weight = 0.0;
//            CGFloat product_num = 0.0;
//            NSString *sv_p_weight_bak = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight_bak"]];
//            NSString *product_num_bak = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
//            if (kStringIsEmpty(sv_p_weight_bak)) {
//                sv_p_weight = 0.0;
//            }else{
//                sv_p_weight = [sv_p_weight_bak floatValue];
//            }
//
//            if (kStringIsEmpty(product_num_bak)) {
//                product_num = 0.0;
//            }else{
//                product_num = [product_num_bak floatValue];
//            }
//
//            totle_numcount = sv_p_weight + product_num;
//
//            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
//
//            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
//            [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
//
//            //            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
//
//            CGFloat Discount_money = [dict[@"product_price"] floatValue] * totle_numcount - [dict[@"product_unitprice"] floatValue] * totle_numcount;
//            if (Discount_money > 0) {
//                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
//            }
//
//            totle_Discount_money += Discount_money;
//            totle_numcount_all += totle_numcount;
//       // }
//
//        totle_numcount = [dict[@"sv_product_num"] doubleValue];
        
        NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
        NSString *sv_p_specs = dict[@"sv_p_specs"];
        if (kStringIsEmpty(sv_p_specs)) {
            [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
        }else{
            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
        }
        
        [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] doubleValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_product_total"] doubleValue]] isTitle:NO];
        
        //            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
        
        CGFloat Discount_money = [dict[@"product_price"] doubleValue] * totle_numcount - [dict[@"sv_product_unitprice"] doubleValue] * totle_numcount;
        if (Discount_money > 0) {
            [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
        }
        Discount_money = [dict[@"sv_product_total"]doubleValue];
        totle_Discount_money += Discount_money;
        totle_numcount_all += totle_numcount;
    }
    
    [printer appendSeperatorLine80];
    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",totle_Discount_money] isTitle:NO];
    [printer appendSeperatorLine];
    
    /**
     优惠
     */
    
    [printer appendTitle:@"支付方式：" value:self.prdata_dic[@"order_payment"]];//order_money
    
    [printer appendSeperatorLine];
    // [printer setLineSpace:60];
    
    
    [printer appendTitle:@"收货人：" value:self.prdata_dic[@"sv_receipt_name"]];
    [printer appendTitle:@"收货电话：" value:self.prdata_dic[@"sv_receipt_phone"]];
    
    [printer appendTitle:@"收货地址：" value:self.prdata_dic[@"getShopAddress"]];
    
    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            [printer appendNewLine];
            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
        }
    }
    
    
//
//    [printer appendSeperatorLine80];
//    //    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%@",self.dict[@"numcount"]] priceText:[NSString stringWithFormat:@"%.1f",total] isTitle:NO];
//    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",[self.prdata_dic[@"order_receivable_bak"] floatValue]] isTitle:NO];
//    [printer appendSeperatorLine];
//
//    /**
//     优惠
//     */
//    if (totle_Discount_money > 0) {
//        [printer appendTitle:@"优惠：" value:[NSString stringWithFormat:@"%.1f",totle_Discount_money]];//order_money
//    }
//
//    [printer appendTitle:@"应收：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_receivable_bak"] floatValue]]];
//
//    if ([self.prdata_dic[@"free_change_bak"] floatValue] != 0) {
//        [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"free_change_bak"] floatValue]]];
//    }
//
//
//    [printer appendTitle:[NSString stringWithFormat:@"%@：",self.prdata_dic[@"order_payment"]] value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_money_bak"] floatValue]]];
//
//    if ([self.prdata_dic[@"sv_give_change"] floatValue] != 0) {
//        [printer appendTitle:@"找零：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"sv_give_change"] floatValue]]];
//    }
//
//
//    if (![self.prdata_dic[@"order_payment2"] isEqualToString:@"待收"]) {
//        [printer appendTitle:[NSString stringWithFormat:@"%@：",self.prdata_dic[@"order_payment2"]] value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_money2_bak"] floatValue]]];
//    }
//
//
////    if ([[NSString stringWithFormat:@"%@",self.prdata_dic[@"discounttype"]] isEqualToString:@"会员类型"]) {
////        [printer appendSeperatorLine80];
////        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.prdata_dic[@"sv_mr_name"]]];
////        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.prdata_dic[@"sv_mr_cardno"]]];
////        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availableamount"] floatValue]]];
////
////        [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_integral"] floatValue]]];
////        [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availablepoint"] floatValue]]];
////
////    }
//    [printer appendSeperatorLine80];
//    // [printer setLineSpace:60];
//
//    //    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
//    //        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_ul_mobile];
//    //    }
//    //
//    //    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
//    //        [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
//    //    }
//    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_phone)) {
//        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
//    }
//
//    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
//        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
//    }
//
//    if ([[SVUserManager shareInstance].imageOpenOff isEqualToString:@"1"]) {
//        if (!kStringIsEmpty([SVUserManager shareInstance].imageStr)) {
//            NSString *str = [URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].imageStr];
//            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
//            UIImage *image = [UIImage imageWithData:data];
//            [printer appendImage:image alignment:HLTextAlignmentCenter maxWidth:200];
//        }
//    }
//
//    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
//        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
//            [printer appendNewLine];
//            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
//        }
//    }
    
    // [printer appendFooter:nil];
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
            NSLog(@"打印成功");
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dict = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//- (NSMutableArray *)dataArray
//{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}

@end

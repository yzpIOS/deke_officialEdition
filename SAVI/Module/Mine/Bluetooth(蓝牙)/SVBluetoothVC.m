//
//  SVBluetoothVC.m
//  SAVI
//
//  Created by houming Wang on 2018/5/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBluetoothVC.h"
#import "JWBluetoothManage.h"

#import "SVPrinterSizeCell.h"
#import "SVSeveralCopiesCell.h"
#import "SVSmallTicketQRcodeCell.h"
#import "SVSmallTicketCustomInfoCell.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

static NSString *BluetoothID = @"BluetoothColl";
static NSString *BluetoothXIBID = @"BluetoothXIBColl";
static NSString *BluetoothNumXIBID = @"BluetoothNumXIBColl";
static NSString *PrintBluetoothID = @"PrintBluetoothColl";
static NSString *SmallTicketQRcodeID = @"SVSmallTicketQRcodeCell";
static NSString *SmallTicketCustomInfoID = @"SVSmallTicketCustomInfoCell";
@interface SVBluetoothVC () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>{
    JWBluetoothManage * manage;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,assign) NSInteger three;

@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property(strong,nonatomic)CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用
@property (nonatomic,strong) NSString *values;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) SVSmallTicketQRcodeCell *imageCell;


@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSIndexPath * indexPath_two;
/*
 事情不是想着怎么去抱怨，而是想着怎么去解决。
 */

@end

@implementation SVBluetoothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"dict = %@",self.dict);

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索蓝牙" style:UIBarButtonItemStylePlain target:self action:@selector(searchBluetooth)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.dataSource = @[].mutableCopy;
    self.rssisArray = @[].mutableCopy;
    [SVUserManager loadUserInfo];
    if ([SVTool isBlankString:[SVUserManager shareInstance].printerSize]) {
        [SVUserManager shareInstance].printerSize = [NSString stringWithFormat:@"%d",58];
        [SVUserManager saveUserInfo];
    }
    if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
        [SVUserManager shareInstance].printerNumber = @"1";
        [SVUserManager saveUserInfo];
    }

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-BottomViewHeight-TopHeight) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //RGBA(241, 241, 241, 1)
    self.tableView.backgroundColor = BackgroundColor;
    // UITableViewStyleGrouped样式时，隐藏上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右距离
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 44, 0, 0)];
    /** 去除tableview 右侧滚动条 */
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //添加到View上
    [self.view addSubview:self.tableView];
    
    //普通cell的注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BluetoothID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PrintBluetoothID];
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVPrinterSizeCell" bundle:nil] forCellReuseIdentifier:BluetoothXIBID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSeveralCopiesCell" bundle:nil] forCellReuseIdentifier:BluetoothNumXIBID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSmallTicketQRcodeCell" bundle:nil] forCellReuseIdentifier:SmallTicketQRcodeID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSmallTicketCustomInfoCell" bundle:nil] forCellReuseIdentifier:SmallTicketCustomInfoID];
    
    if (self.interface == 1) {
        self.title = @"打印设置";
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-BottomViewHeight-TopHeight, ScreenW, BottomViewHeight)];
        [self.view addSubview:bottomView];
        bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *threadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        threadView.backgroundColor = threadColor;
        [bottomView addSubview:threadView];
        
        UIButton *bottomButton = [[UIButton alloc]init];
        bottomButton.layer.cornerRadius = ButtonCorner;
        bottomButton.backgroundColor = navigationBackgroundColor;
        [bottomButton setTitle:@"测试打印" forState:UIControlStateNormal];
        [bottomButton setTintColor:[UIColor whiteColor]];
        [bottomButton addTarget:self action:@selector(textPrinte) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.left.mas_equalTo(bottomView).offset(20);
            make.size.mas_equalTo(CGSizeMake(ScreenW-40, BottomButtonHeight));
        }];
        
    } else {
        // [self loadData];
        self.title = @"打印小票";
        //底部按钮
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-BottomViewHeight-TopHeight, ScreenW, BottomViewHeight)];
        [self.view addSubview:bottomView];
        bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *threadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        threadView.backgroundColor = threadColor;
        [bottomView addSubview:threadView];
        
        UIButton *bottomButton = [[UIButton alloc]init];
        bottomButton.layer.cornerRadius = ButtonCorner;
        bottomButton.backgroundColor = navigationBackgroundColor;
        [bottomButton setTitle:@"打印" forState:UIControlStateNormal];
        [bottomButton setTintColor:[UIColor whiteColor]];
        [bottomButton addTarget:self action:@selector(printe) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.left.mas_equalTo(bottomView).offset(20);
            make.size.mas_equalTo(CGSizeMake(ScreenW-40, BottomButtonHeight));
        }];
        
        
    }
    [self.tableView reloadData];
    
    //创建蓝牙
    manage = [JWBluetoothManage sharedInstance];
    [self searchBluetooth];
    WeakSelf
    //断开连接的block回调
    manage.disConnectBlock = ^(CBPeripheral *perpheral, NSError *error) {
        weakSelf.three = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    };
    
    // [self setUpUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!kStringIsEmpty([SVUserManager shareInstance].imageStr)){
            SVSmallTicketQRcodeCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
            
            NSString *str = [URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].imageStr];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            UIImage *image = [UIImage imageWithData:data];
            [cell.addImagebtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        if (kStringIsEmpty([SVUserManager shareInstance].imageOpenOff)) {
            SVSmallTicketQRcodeCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
            [SVUserManager shareInstance].imageOpenOff = @"1";
            [SVUserManager saveUserInfo];
            [cell.addImageSwitch setOn:YES];
        }else{
            if ([[SVUserManager shareInstance].imageOpenOff isEqualToString:@"1"]) {
                SVSmallTicketQRcodeCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
                [cell.addImageSwitch setOn:YES];
            }else{
                SVSmallTicketQRcodeCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
                [cell.addImageSwitch setOn:NO];
            }
        }
        
        if (kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            SVSmallTicketCustomInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath_two];
            
            cell.textView_text.text = @"谢谢惠顾，欢迎下次光临！";
            [SVUserManager shareInstance].CustomInformation = @"谢谢惠顾，欢迎下次光临！";
            [SVUserManager saveUserInfo];
        }else{
            SVSmallTicketCustomInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath_two];
            cell.textView_text.text = [SVUserManager shareInstance].CustomInformation;
        }
        
        if (kStringIsEmpty([SVUserManager shareInstance].CustomInformationOpenOff)) {
            SVSmallTicketCustomInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath_two];
            [SVUserManager shareInstance].CustomInformationOpenOff = @"1";
            [cell.textView_switch setOn:YES];
            [SVUserManager saveUserInfo];
        }else{
            if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
                SVSmallTicketCustomInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath_two];
                [cell.textView_switch setOn:YES];
            }else{
                SVSmallTicketCustomInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath_two];
                [cell.textView_switch setOn:NO];
            }
        }
        
        
        [self.tableView reloadData];
    });
    
    
}





- (void)loadData{
    [SVUserManager loadUserInfo];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/intelligent/SalesLogPrint?order_id=%@&key=%@",[NSString stringWithFormat:@"%@",self.dict[@"order_id"]],[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic = %@",dic);
        NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
        if ([suc isEqualToString:@"1"]) {
            self.dic = dic[@"values"];
            self.prdata_dic = dic[@"values"][@"prdata"];
            // NSLog(@"dic = %@",dic);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)setUpUI{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/HardwareStore/GetUserModuleConfig?key=%@&code=PrintSet_ExtraInfo",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        self.values = dic[@"values"];
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
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

-(void)searchBluetooth {
    WeakSelf
    //开始搜索
    [SVTool IndeterminateButtonAction:self.view withSing:@"蓝牙搜索中..."];
    [manage beginScanPerpheralSuccess:^(NSArray<CBPeripheral *> *peripherals, NSArray<NSNumber *> *rssis) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.dataSource = [NSMutableArray arrayWithArray:peripherals];
        weakSelf.rssisArray = [NSMutableArray arrayWithArray:rssis];
        [weakSelf.tableView reloadData];
    } failure:^(CBManagerState status) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [SVTool TextButtonAction:weakSelf.view withSing:[weakSelf getBluetoothErrorInfo:status]];
    }];
    
    
    //用延迟来作提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"没有搜索到附近的蓝牙设置"];
        }
    });
}

-(void)viewWillAppear:(BOOL)animated{
    WeakSelf
    [super viewWillAppear:animated];
    //自动连接上次连接的蓝牙
    [manage autoConnectLastPeripheralCompletion:^(CBPeripheral *perpheral, NSError *error) {
        if (!error) {
            weakSelf.currPeripheral = perpheral;
            weakSelf.printeName = [NSString stringWithFormat:@"%@",perpheral.name];
            weakSelf.three = 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else{
            [SVTool TextButtonAction:weakSelf.view withSing:error.domain];
        }
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

- (void)printe{
    
    NSLog(@"[SVUserManager shareInstance].printerSize = %@",[SVUserManager shareInstance].printerSize);
    
    [SVUserManager loadUserInfo];
    for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
        if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
            [self fiftyEightPrinting];
        }
        
        if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
            //[self eightyPrinting];
            [self eightyPrinting];
        }
        
        if ([[SVUserManager shareInstance].printerSize intValue] == 110) {
            //[self eightyPrinting];
            [self OneHundredTenPrinting];
        }
        
    }
    
}

#pragma mark - 测试打印
- (void)textPrinte{
    
    [SVUserManager loadUserInfo];
    for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
        if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
            [self fiftyEightPrinting];
        }
        
        if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
            //[self eightyPrinting];
            [self eightyPrinting];
        }
        
        if ([[SVUserManager shareInstance].printerSize intValue] == 110) {
            //[self eightyPrinting];
          //  [self OneHundredTenPrinting];
         
        }
    }
}




//58打印
-(void)fiftyEightPrinting {
    
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
  //  [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"补打单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    
//   NSString *order_serial_number =[NSString stringWithFormat:@"%@",self.dict[@"order_serial_number"]];
//    if (!kStringIsEmpty(order_serial_number)) {
//        [printer appendTitle:@"流水号:" value:[NSString stringWithFormat:@"%@",self.dict[@"order_serial_number"]] fontSize:HLFontSizeTitleSmalle];
//    }
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.dict[@"order_running_id"]] fontSize:HLFontSizeTitleSmalle];
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
    CGFloat totle_numcount = 0.0;
     CGFloat totle_numcount_all = 0.0;
  
    for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
        if (![dict[@"product_name"] containsString:@"(套餐)"]) {
          
            CGFloat sv_p_weight = 0.0;
            CGFloat product_num = 0.0;
            NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
            NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];

            sv_p_weight = [sv_p_weightstr doubleValue];
            product_num = [product_numstr doubleValue];
            totle_numcount = sv_p_weight + product_num;
            
            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
            
            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
            [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
            
//            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
            
            CGFloat Discount_money = [dict[@"product_price"] floatValue] * totle_numcount - [dict[@"product_unitprice"] floatValue] * totle_numcount;
            if (Discount_money > 0) {
                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
            }
            
            totle_Discount_money += Discount_money;
            totle_numcount_all += totle_numcount;
        }
        
    }
    
    
    [printer appendSeperatorLine];
    [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",[self.dict[@"order_receivable"] floatValue]] isTitle:NO];
    [printer appendSeperatorLine];
    
    /**
     优惠
     */
    if (totle_Discount_money > 0) {
        [printer appendTitle:@"优惠：" value:[NSString stringWithFormat:@"%.2f",totle_Discount_money]];//order_money
    }
    
    [printer appendTitle:@"应收：" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"order_receivable"] floatValue]]];
    
    if ([self.dict[@"free_change_bak"] floatValue] != 0) {
        [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"free_change"] floatValue]]];
    }
    
    
    [printer appendTitle:[NSString stringWithFormat:@"%@：",self.dict[@"order_payment"]] value:[NSString stringWithFormat:@"%.2f",[self.dict[@"order_money"] floatValue]]];
    
    if ([self.dict[@"sv_give_change"] floatValue] != 0) {
        [printer appendTitle:@"找零：" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"sv_give_change"] floatValue]]];
    }
    
    
    if (![self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
        [printer appendTitle:[NSString stringWithFormat:@"%@：",self.dict[@"order_payment2"]] value:[NSString stringWithFormat:@"%.2f",[self.dict[@"order_money2"] floatValue]]];
    }
    
    
    if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
        [printer appendSeperatorLine];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availableamount"] floatValue]]];
        
        [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
        [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availablepoint"] floatValue]]];
        
    }
    [printer appendSeperatorLine];
    // [printer setLineSpace:60];
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[NSString stringWithFormat:@"%@%@%@",kStringIsEmpty([SVUserManager shareInstance].cityname)?@"":[SVUserManager shareInstance].cityname,kStringIsEmpty([SVUserManager shareInstance].disname)?@"":[SVUserManager shareInstance].disname,[SVUserManager shareInstance].sv_us_address]];
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
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"补打单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
//    NSString *order_serial_number =[NSString stringWithFormat:@"%@",self.dict[@"order_serial_number"]];
//     if (!kStringIsEmpty(order_serial_number)) {
//         [printer appendTitle:@"流水号:" value:[NSString stringWithFormat:@"%@",self.dict[@"order_serial_number"]] fontSize:HLFontSizeTitleSmalle];
//     }
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.dict[@"order_running_id"]] fontSize:HLFontSizeTitleSmalle];
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
    for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
        if (![dict[@"product_name"] containsString:@"(套餐)"]) {
       
            CGFloat sv_p_weight = 0.0;
            CGFloat product_num = 0.0;
            NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
            NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];

            sv_p_weight = [sv_p_weightstr doubleValue];
            product_num = [product_numstr doubleValue];
            totle_numcount = sv_p_weight + product_num;
            
            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
            
            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
            [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
            
            //            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
            
            CGFloat Discount_money = [dict[@"product_price"] floatValue] * totle_numcount - [dict[@"product_unitprice"] floatValue] * totle_numcount;
            if (Discount_money > 0) {
                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
            }
            
            totle_Discount_money += Discount_money;
            totle_numcount_all += totle_numcount;
        }
    }
    
    
    [printer appendSeperatorLine80];
    //    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%@",self.dict[@"numcount"]] priceText:[NSString stringWithFormat:@"%.1f",total] isTitle:NO];
    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",[self.dict[@"order_receivable"] floatValue]] isTitle:NO];
    [printer appendSeperatorLine];
    
    /**
     优惠
     */
    if (totle_Discount_money > 0) {
        [printer appendTitle:@"优惠：" value:[NSString stringWithFormat:@"%.1f",totle_Discount_money]];//order_money
    }
    
    [printer appendTitle:@"应收：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_receivable"] floatValue]]];
    
    if ([self.dict[@"free_change"] floatValue] != 0) {
        [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"free_change"] floatValue]]];
    }
    
    
    [printer appendTitle:[NSString stringWithFormat:@"%@：",self.dict[@"order_payment"]] value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_money"] floatValue]]];
    
    if ([self.dict[@"sv_give_change"] floatValue] != 0) {
        [printer appendTitle:@"找零：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"sv_give_change"] floatValue]]];
    }
    
    
    if (![self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
        [printer appendTitle:[NSString stringWithFormat:@"%@：",self.dict[@"order_payment2"]] value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_money2"] floatValue]]];
    }
    
    
    if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
        [printer appendSeperatorLine80];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availableamount"] floatValue]]];
        
        [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
        [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availablepoint"] floatValue]]];
        
    }
    [printer appendSeperatorLine80];
    // [printer setLineSpace:60];
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
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


#pragma mark - 110打印
-(void)OneHundredTenPrinting {

    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.prdata_dic[@"order_datetime"] substringToIndex:10],[self.prdata_dic[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"补打单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];

    CGFloat total = 0.0;
    CGFloat totle_Discount_money = 0.0;
    CGFloat totle_numcount = 0.0;
    CGFloat totle_numcount_all = 0.0;
    for (NSDictionary *dict in [self.prdata_dic objectForKey:@"prlist"]) {
        if (![dict[@"product_name"] containsString:@"(套餐)"]) {
//            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
//
//            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
//            [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f",[dict[@"product_num"] floatValue] + [dict[@"sv_p_weight_bak"] intValue]] priceText:[NSString stringWithFormat:@"%.1f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
//
//            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
//
//            CGFloat Discount_money = [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]) - [dict[@"product_unitprice"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
//            if (Discount_money > 0) {
//                [printer appendText:[NSString stringWithFormat:@"优惠：%.1f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
//            }
//
//            totle_Discount_money += Discount_money;
            
            CGFloat sv_p_weight = 0.0;
            CGFloat product_num = 0.0;
            NSString *sv_p_weight_bak = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight_bak"]];
            NSString *product_num_bak = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
            if (kStringIsEmpty(sv_p_weight_bak)) {
                sv_p_weight = 0.0;
            }else{
                sv_p_weight = [sv_p_weight_bak floatValue];
            }
            
            if (kStringIsEmpty(product_num_bak)) {
                product_num = 0.0;
            }else{
                product_num = [product_num_bak floatValue];
            }
            
            totle_numcount = sv_p_weight + product_num;
            
            NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
            
            [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
            [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
            
            //            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
            
            CGFloat Discount_money = [dict[@"product_price"] floatValue] * totle_numcount - [dict[@"product_unitprice"] floatValue] * totle_numcount;
            if (Discount_money > 0) {
                [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
            }
            
            totle_Discount_money += Discount_money;
            totle_numcount_all += totle_numcount;
        }
    }
    
    
    [printer appendSeperatorLine80];
//    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%@",self.dict[@"numcount"]] priceText:[NSString stringWithFormat:@"%.1f",total] isTitle:NO];
     [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",[self.prdata_dic[@"order_receivable_bak"] floatValue]] isTitle:NO];
    [printer appendSeperatorLine];
    
    /**
     优惠
     */
    if (totle_Discount_money > 0) {
        [printer appendTitle:@"优惠：" value:[NSString stringWithFormat:@"%.1f",totle_Discount_money]];//order_money
    }
    
    [printer appendTitle:@"应收：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_receivable_bak"] floatValue]]];
    
    if ([self.prdata_dic[@"free_change_bak"] floatValue] != 0) {
        [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"free_change_bak"] floatValue]]];
    }
    
    
    [printer appendTitle:[NSString stringWithFormat:@"%@：",self.prdata_dic[@"order_payment"]] value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_money_bak"] floatValue]]];
    
    if ([self.prdata_dic[@"sv_give_change"] floatValue] != 0) {
        [printer appendTitle:@"找零：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"sv_give_change"] floatValue]]];
    }
    
    
    if (![self.prdata_dic[@"order_payment2"] isEqualToString:@"待收"]) {
        [printer appendTitle:[NSString stringWithFormat:@"%@：",self.prdata_dic[@"order_payment2"]] value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_money2_bak"] floatValue]]];
    }
    
    
    if ([[NSString stringWithFormat:@"%@",self.prdata_dic[@"discounttype"]] isEqualToString:@"会员类型"]) {
        [printer appendSeperatorLine80];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.prdata_dic[@"sv_mr_name"]]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.prdata_dic[@"sv_mr_cardno"]]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availableamount"] floatValue]]];
        
        [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.prdata_dic[@"order_integral"] floatValue]]];
        [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",[self.dic[@"myuser"][@"sv_mw_availablepoint"] floatValue]]];
        
    }
    [printer appendSeperatorLine80];

    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_ul_mobile];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
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

#pragma mark - tableVeiw
//让section头部不停留在顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    if (section == 0) {
        headerView.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = GreyFontColor;
    titleLabel.text = self.titleArr[section];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerView);
        make.left.mas_equalTo(headerView).offset(20);
    }];
    
    return headerView;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){
        return 100;
        
    }else if (indexPath.section == 2){
        return 100;
    }
    return 50;
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 4) {
        return self.three;
    }
    
    if (section == 5) {
        return self.dataSource.count;
    }
    return 1;
    
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SVUserManager loadUserInfo];
    if (indexPath.section == 0) {
        //xib的cell的创建
        SVPrinterSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:BluetoothXIBID forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[SVPrinterSizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BluetoothXIBID];
        }
        //取消高亮
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //去除按钮的按下效果（阴影）
        [cell.ontButton setAdjustsImageWhenHighlighted:NO];
        [cell.twoButton setAdjustsImageWhenHighlighted:NO];
        
        //WeakSelf
        cell.printerSixeCellBlock = ^(NSInteger num) {
            [SVUserManager shareInstance].printerSize = [NSString stringWithFormat:@"%ld",(long)num];
            [SVUserManager saveUserInfo];
        };
        
        return cell;
    }else if (indexPath.section == 1){
        self.imageCell = [tableView dequeueReusableCellWithIdentifier:SmallTicketQRcodeID];
        
        if (!self.imageCell) {
            self.imageCell = [[SVSmallTicketQRcodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallTicketQRcodeID];
            
        }
        
        self.indexPath = indexPath;
        
        [self.imageCell.addImagebtn addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageCell.addImageSwitch addTarget:self action:@selector(addImageSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        return self.imageCell;
        
    }else if (indexPath.section == 2){

        SVSmallTicketCustomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallTicketCustomInfoID];

        
        if (!cell) {
            cell = [[SVSmallTicketCustomInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallTicketCustomInfoID];
            
        }
        self.indexPath_two = indexPath;
        
        [cell.textView_switch addTarget:self action:@selector(textView_switchClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.textView_text.delegate = self;
        
        return cell;
        
        
    }else if (indexPath.section == 3) {
        SVSeveralCopiesCell *cell = [tableView dequeueReusableCellWithIdentifier:BluetoothNumXIBID forIndexPath:indexPath];
        if (!cell) {
            cell = [[SVSeveralCopiesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BluetoothNumXIBID];
        }
        //WeakSelf
        cell.severalCopiesCellBlock = ^(NSInteger num) {
            [SVUserManager shareInstance].printerNumber = [NSString stringWithFormat:@"%ld",(long)num];
            [SVUserManager saveUserInfo];
        };
        return cell;
    } else if (indexPath.section == 4) {
        //普通cell的创建
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BluetoothID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BluetoothID];
        }
        cell.imageView.image = [UIImage imageNamed:@"ic_yixuan.png"];
        cell.textLabel.text = self.printeName;
        cell.textLabel.textColor = GlobalFontColor;
        cell.detailTextLabel.text = @"已连接";
        cell.detailTextLabel.textColor = selectedColor;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PrintBluetoothID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PrintBluetoothID];
        }
        if (indexPath.row < self.dataSource.count) {
            cell.imageView.image = [UIImage imageNamed:@"ic_mo-ren"];
            CBPeripheral *peripherral = [self.dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",peripherral.name];
            cell.textLabel.textColor = GlobalFontColor;
        }
        return cell;
    }
    
}

#pragma mark - 小票二维码开关
- (void)addImageSwitch:(UISwitch *)swi{
    if (swi.isOn) { // 开着
        [SVUserManager shareInstance].imageOpenOff = @"1";
        [SVUserManager saveUserInfo];
    }else{
        [SVUserManager shareInstance].imageOpenOff = @"0";
        [SVUserManager saveUserInfo];
    }
}

#pragma mark - 小票自定义开关
- (void)textView_switchClick:(UISwitch *)swi{
    if (swi.isOn) { // 开着
        [SVUserManager shareInstance].CustomInformationOpenOff = @"1";
        [SVUserManager saveUserInfo];
    }else{
        [SVUserManager shareInstance].CustomInformationOpenOff = @"0";
        [SVUserManager saveUserInfo];
    }
}

#pragma mark - textView的完成
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [SVUserManager shareInstance].CustomInformation = textView.text;
    [SVUserManager saveUserInfo];
}


#pragma mark -小票二维码的点击
- (void)addImageClick{
    
    ///**
    // *  弹出提示框
    // */
    ////初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //赋值图片
    //    [self.imgCell.imgButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
    //赋值图片
    SVSmallTicketQRcodeCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    [cell.addImagebtn setBackgroundImage:newPhoto forState:UIControlStateNormal];
    [self.tableView reloadData];
    //  self.imageCell.image = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(saveImage:) withObject:newPhoto afterDelay:0.5];
    
}

#pragma mark - 上传图片的方法
- (void)saveImage:(UIImage *)image {
    
    [SVUserManager loadUserInfo];
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在压缩图片"];
    NSString *loadImage_path = @"/system/UploadImg";
    
    NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
    
    [YQImageCompressTool CompressToDataAtBackgroundWithImage:image ShowSize:self.NewIMGSize FileSize:200 block:^(NSData *resultData) {
        UIImage *newIMG = [UIImage imageWithData:resultData];
        
        NSData *newIMGData = UIImageJPEGRepresentation(newIMG,1);
        
        //获取主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                //                NSData *data = [NSUtil dataWithOriginalImage:newImage];
                
                //上传的参数(上传图片，以文件流的格式)
                [formData appendPartWithFileData:newIMGData
                 
                                            name:@"icon"
                 
                                        fileName:@"icon.jpg"
                 
                                        mimeType:@"image/jpeg"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"succeed"] integerValue] == 1) {
                    
                    //                    [SVTool ];
                    if ([self changeImagePath:dic[@"values"]].length <= 0) {
                        [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
                    }else{
                        self.imgURL = [self changeImagePath:dic[@"values"]];
                        
                        [SVUserManager shareInstance].imageStr = self.imgURL;
                        
                        [SVUserManager saveUserInfo];
                        NSLog(@"self.imgURL = %@",self.imgURL);
                    }
                    
                } else {
                    
                    [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
                    
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //        [SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
            
        });
    }];
}
//截掉图片拼接路径
-(NSString*)changeImagePath:(NSString*)path{
    return  [path stringByReplacingOccurrencesOfString:URLHeadPortrait withString:@""];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 5) {
        WeakSelf
        CBPeripheral *peripheral = [self.dataSource objectAtIndex:indexPath.row];
        [SVTool IndeterminateButtonAction:self.view withSing:@"蓝牙连接中..."];
        //连接外设
        [manage connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                weakSelf.printeName = [NSString stringWithFormat:@"%@",perpheral.name];
                weakSelf.currPeripheral = perpheral;
                weakSelf.three = 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            }else{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [SVTool TextButtonAction:weakSelf.view withSing:error.domain];
            }
        }];
        
    } else if (indexPath.section == 4) {
        //取消某个设备的连接
        [manage cancelPeripheralConnection:self.currPeripheral];
        
    } else {
        
    }
    
    
    
}


#pragma mark - 懒加载
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"打印机尺寸",
                      @"小票二维码",
                      @"小票自定义信息",
                      @"打印份数",
                      @"已配对设备",
                      @"搜索到的设备",
                      ];
    }
    return _titleArr;
    
}

- (NSArray *)array
{
    if (_array == nil) {
        _array = [NSArray array];
    }
    return _array;
}



@end

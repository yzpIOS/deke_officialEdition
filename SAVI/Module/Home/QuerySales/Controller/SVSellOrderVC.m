//
//  SVSellOrderVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSellOrderVC.h"
#import "SVDetailsHistoryCell.h"
//单件退货view
#import "SVSinglePieceView.h"
#import "SVBluetoothVC.h"
#import "SVCarnoMoModel.h"
#import "SVInputBoxView.h"
#import "SVAddCustomView.h"
#import "SVPromptRenewalView.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"
#import "ZJViewShow.h"
#define WeakSelf __block __weak typeof(self)weakSelf = self;
@interface SVSellOrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *twoTime;
@property (weak, nonatomic) IBOutlet UILabel *vipName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *paytitle;
// 新的页面
@property (weak, nonatomic) IBOutlet UILabel *actualHarvestLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceL;
@property (weak, nonatomic) IBOutlet UILabel *salesOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethod;
@property (weak, nonatomic) IBOutlet UILabel *saleTime;
@property (weak, nonatomic) IBOutlet UILabel *consumerObject;
@property (weak, nonatomic) IBOutlet UILabel *remarks;
//tableView
//@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;
//商品名
@property (nonatomic,strong) NSMutableArray *waresNameArr;
//单价
@property (nonatomic,strong) NSMutableArray *moneyArr;
//件数
@property (nonatomic,strong) NSMutableArray *numberArr;
//判断是否有退货
@property (nonatomic,strong) NSMutableArray *order_stutiaArr;
//订单id
@property (nonatomic,copy) NSString *order_id;
//产品ID
@property (nonatomic,assign) NSNumber *product_id;

@property (nonatomic,assign) NSNumber *order_product_id;
//所谓的产品ID
@property (nonatomic,strong) NSMutableArray *waresID;
//记录单件退商品的总件数
@property (nonatomic,assign) NSNumber *num;
@property (nonatomic,strong) SVInputBoxView *boxView;
//单件退货view
@property (nonatomic,strong) SVSinglePieceView *singleView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//退货原因
@property (nonatomic,strong) NSString *whyString;

@property (nonatomic,strong) SVCarnoMoModel *carnoModel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (nonatomic,strong) UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *salepeple;
@property (nonatomic,strong) SVAddCustomView *addCustomView;
//遮盖view
//@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,assign) NSInteger selectWholeOrder;
@property (nonatomic,assign) NSInteger cardno;
@property (weak, nonatomic) IBOutlet UILabel *PreferentialAmountLabel;
@property (nonatomic,strong) SVPromptRenewalView *promptRenewalView;

@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;
/**
 会员储值
 */
@property (nonatomic,assign) double sv_mw_availableamount;

/**
 可用积分
 */
@property (nonatomic,assign) double sv_mw_availablepoint;
@property (nonatomic,strong) NSString * sv_remarks;
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic,assign) BOOL isAggregatePayment;
@property (nonatomic,strong) NSString * queryId;
@property (nonatomic,assign) BOOL ReturnPolicy;

@property (nonatomic,strong) SVSalesDetails *salesDetails;


@end

@implementation SVSellOrderVC

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
              //  [SVTool TextButtonAction:self.view withSing:@"未连接蓝牙,打印失败"];
              //  self.title = @"结算";
            }
        });
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


- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"销售详情";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"销售详情";
    self.hidesBottomBarWhenPushed = YES;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+ 20, ScreenW, ScreenH - TopHeight - CGRectGetMaxY(self.topView.frame)- 20 - BottomViewHeight)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSLog(@"self.dict  = %@",self.dict);
    
    SVCarnoMoModel *carnoModel = [SVCarnoMoModel mj_objectWithKeyValues:self.dict];
    NSLog(@"carnoModel.sv_mr_cardno = %ld",carnoModel.sv_mr_cardno);
    self.carnoModel = carnoModel;

    NSString *return_type = [NSString stringWithFormat:@"%@",self.dict[@"return_type"]];
    if ([return_type isEqualToString:@"1"]) {// 退货单
        self.offerLabel.hidden = YES;
        self.PreferentialAmountLabel.hidden = YES;
//        self.tuiLabel.hidden = NO;
//        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
//        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable_bak floatValue]];
    }else if ([return_type isEqualToString:@"2"]){
        self.offerLabel.hidden = YES;
        self.PreferentialAmountLabel.hidden = YES;
//        self.tuiLabel.hidden = NO;
//        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
//        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable_bak floatValue]];
    }else if ([return_type isEqualToString:@"3"]){
//        self.tuiLabel.hidden = NO;
//        self.tuiLabel.text = @"换";
//        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
//        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable_bak floatValue]];
        
//        self.offerLabel.hidden = YES;
//        self.PreferentialAmountLabel.hidden = YES;
        self.offerLabel.hidden = YES;
        self.PreferentialAmountLabel.hidden = YES;
    }else{
//        self.tuiLabel.hidden = YES;
//        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
//        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable_bak floatValue]];
    }
    
    
   
    

    NSString *str3 = [NSString stringWithFormat:@"%@",self.dict[@"sv_remarks"]];

    str3 = [str3 stringByReplacingOccurrencesOfString:@"%"withString:@"\\"];

  //  NSLog(@"str3 = %@",str3);
    if (kStringIsEmpty(str3) || [str3 containsString:@"<null>"]) {
         self.remarks.text = @"无";
    }else{
         self.remarks.text = [self replaceUnicode:str3];
         self.sv_remarks = [self replaceUnicode:str3];
    }

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVDetailsHistoryCell" bundle:nil] forCellReuseIdentifier:@"DetailsHistoryCell"];

    //会员
    self.vipName.backgroundColor = RGBA(255, 192, 0, 1);
    self.vipName.layer.cornerRadius = 4;
    self.vipName.layer.masksToBounds = YES;
  
    /**
     数据解析
     */
    
    //订单id
    self.order_id = self.dict[@"order_id"];
    //    self.order_id = self.dic[@"order_id"];
    
    NSMutableArray *prlistArr = [self.dict objectForKey:@"prlist"];
    double product_price = 0;
    for (NSDictionary *dict in prlistArr) {
        
        //        [self.waresNameArr addObject:dict[@"product_name"]];
        //        [self.moneyArr addObject:dict[@"product_price"]];
        //        [self.numberArr addObject:dict[@"product_num"]];
        //判断商品退货状态
        [self.order_stutiaArr addObject:dict[@"order_stutia"]];
        //ID
        [self.waresID addObject:dict[@"id"]];
        NSLog(@"prlistArr = %@",prlistArr);
        
        //给模型赋值
        NSString *sv_preferential_data= dict[@"sv_preferential_data"];
        
       // NSString *result=dict[@"combination_new"];
        NSArray *arr = [NSMutableArray array];
        if (!kStringIsEmpty(sv_preferential_data)) {
            NSData *data = [sv_preferential_data dataUsingEncoding:NSUTF8StringEncoding];
            if (data != nil) {
                arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
            }
       
        }
        product_price += [dict[@"product_price"] doubleValue] *[dict[@"product_num"] doubleValue];
        NSLog(@"arr = %@",arr);
        SVDetailsHistoryModel *model = [SVDetailsHistoryModel mj_objectWithKeyValues:dict];
        model.sv_preferential_data = arr;
        
        [self.modelArr addObject:model];
        
    }
 
    
    self.tableViewHeight.constant = self.modelArr.count * 80;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    [self.tableView reloadData];
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
    NSString *ReturnPolicy = [NSString stringWithFormat:@"%@",AnalyticsDic[@"ReturnPolicy"]];
    if (kDictIsEmpty(sv_versionpowersDict)) {
        self.ReturnPolicy = YES;
    }else{
        if ([ReturnPolicy isEqualToString:@"1"]) {
            self.ReturnPolicy = YES;
        }else{
            self.ReturnPolicy = NO;
        }
    }
    
   
    
    //判断是否整单退
    if (!([self.dict[@"order_state"] integerValue] == 2) && ![return_type isEqualToString:@"3"]) {
        //底部按钮
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-BottomViewHeight-TopHeight, ScreenW, BottomViewHeight)];
        [self.view addSubview:bottomView];
        
        UIView *threadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        threadView.backgroundColor = threadColor;
        [bottomView addSubview:threadView];
        self.tableViewBottom.constant = BottomViewHeight;
        //    UIButton *bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, ScreenW-60, 50)];
        UIButton *bottomButton = [[UIButton alloc]init];
        bottomButton.layer.cornerRadius = ButtonCorner;
        bottomButton.backgroundColor = navigationBackgroundColor;
        [bottomButton setTitle:@"打印小票" forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize: 15];
        [bottomButton setTintColor:[UIColor whiteColor]];
        [bottomButton addTarget:self action:@selector(printe) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButton];
        
      
        
        //底部按钮
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"整单退货" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 15];
        button.layer.cornerRadius = ButtonCorner;
        [button setBackgroundColor:navigationBackgroundColor];
        [button addTarget:self action:@selector(wholeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        if (self.ReturnPolicy == NO) {
            [button setEnabled:NO];
            [button setBackgroundColor:[UIColor grayColor]];
        }else{
            [button setEnabled:YES];
            [button setBackgroundColor:navigationBackgroundColor];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.right.mas_equalTo(bottomView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(BottomButtomWidth, BottomButtonHeight));
        }];
        
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.left.mas_equalTo(bottomView).offset(20);
            make.size.mas_equalTo(CGSizeMake(BottomButtomWidth, BottomButtonHeight));
        }];
    } else {
        
        //底部按钮
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-BottomViewHeight-TopHeight, ScreenW, BottomViewHeight)];
        [self.view addSubview:bottomView];
        
        UIView *threadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        threadView.backgroundColor = threadColor;
        [bottomView addSubview:threadView];
        self.tableViewBottom.constant = BottomViewHeight;
        //    UIButton *bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, ScreenW-60, 50)];
        UIButton *bottomButton = [[UIButton alloc]init];
        bottomButton.layer.cornerRadius = ButtonCorner;
        bottomButton.backgroundColor = navigationBackgroundColor;
        [bottomButton setTitle:@"打印小票" forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize: 15];
        [bottomButton setTintColor:[UIColor whiteColor]];
        [bottomButton addTarget:self action:@selector(printe) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButton];
//        //底部按钮
//        UIButton *button = [[UIButton alloc]init];
//        [button setTitle:@"整单退货" forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize: 15];
//        button.layer.cornerRadius = ButtonCorner;
//        [button setBackgroundColor:navigationBackgroundColor];
//        [button addTarget:self action:@selector(wholeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:button];
//
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(bottomView);
//            make.right.mas_equalTo(bottomView).offset(-20);
//            make.size.mas_equalTo(CGSizeMake(BottomButtomWidth, BottomButtonHeight));
//        }];
        
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.left.mas_equalTo(bottomView).offset(20);
            make.size.mas_equalTo(CGSizeMake(ScreenW -40, BottomButtonHeight));
        }];

    }

    //退货原因选择
    [self oneButtonResponseEvent];
    
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
    
    [SVUserManager shareInstance].Tips = @"退款中...";
    [SVUserManager saveUserInfo];
    
    [self loadMemberDetailDataReturn_type:return_type];
  
    [self AggregatePayment];
    

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

- (void)loadMemberDetailDataReturn_type:(NSString *)return_type{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *setURL = @"";
    if (return_type.integerValue == 1 || return_type.integerValue == 2) {
        setURL = [URLhead stringByAppendingFormat:@"/api/CashierBill/GetCashierInfo?key=%@&u_id=%@&id=%@&type=2",token,[SVUserManager shareInstance].user_id,[NSString stringWithFormat:@"%@",self.dict[@"order_id"]]];
    }else{
        setURL = [URLhead stringByAppendingFormat:@"/api/CashierBill/GetCashierInfo?key=%@&u_id=%@&id=%@&type=1",token,[SVUserManager shareInstance].user_id,[NSString stringWithFormat:@"%@",self.dict[@"order_id"]]];
    }
    
    [[SVSaviTool sharedSaviTool] GET:setURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
        
        SVHTTPResponse *hTTPResponse = [SVHTTPResponse mj_objectWithKeyValues:dic];
        if (hTTPResponse.code == PSResponseStatusSuccessCode) {
            SVSalesDetails *salesDetails = [SVSalesDetails mj_objectWithKeyValues:hTTPResponse.data];
            NSArray *list =[SVSalesDetailsList mj_objectArrayWithKeyValuesArray:salesDetails.list];
            salesDetails.list = list;
            self.salesDetails = salesDetails;
            
            self.salepeple.text = self.salesDetails.salesperson;

            //分析数据
            //显示时间
//            NSString *timeString = self.dict[@"order_datetime"];
//            NSString *time1 = [timeString substringToIndex:10];
//            NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
            

            if ([self.salesDetails.order_payment2 isEqualToString:@"待收"]) {
                self.paymentMethod.text = self.salesDetails.order_payment;
            } else {
                self.paymentMethod.text = [NSString stringWithFormat:@"%@(%.2f),%@(%.2f)",self.salesDetails.order_payment,self.salesDetails.order_money,self.salesDetails.order_payment2,self.salesDetails.order_money2];
            }
            
           
            
            self.salesOrderNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"order_running_id"]];
            self.saleTime.text = self.salesDetails.order_datetime;
            
            if (![SVTool isBlankString:self.salesDetails.sv_mr_name]) {
                self.consumerObject.text = self.salesDetails.sv_mr_name;
                self.cardno = 1;
            } else {
                //self.vipName.hidden = YES;
                self.consumerObject.text = [NSString stringWithFormat:@"%@",@"散客"];
                self.cardno = 0;
            }
            
            /**
             实收金额
             */
            self.actualHarvestLabel.text = [NSString stringWithFormat:@"%.2f",self.salesDetails.order_money + self.salesDetails.order_money2];
            /**
             优惠金额
             */
            self.offerLabel.text = [NSString stringWithFormat:@"%.2f",self.salesDetails.order_receivable_bak_new-(self.salesDetails.order_money + self.salesDetails.order_money2)];
            /**
             应收金额
             */
            self.originalPriceL.text = [NSString stringWithFormat:@"%.2f",self.salesDetails.order_receivable_bak_new];
   
            
//            double deserved_cash = [self.dict[@"sv_order_total_money"]doubleValue] - [self.dict[@"order_receivable_bak"] doubleValue];
            
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:hTTPResponse.msg];
        }
        
//        if ([dic[@"succeed"] intValue] == 1) {
//            NSDictionary *values = dic[@"values"];
//            self.sv_mw_availableamount = [values[@"sv_mw_availableamount"] doubleValue];
//            self.sv_mw_availablepoint = [values[@"sv_mw_availablepoint"] doubleValue];
//        }else{
//
//        }
        
        [self.tableView reloadData];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma mark - 58的小票打印 打印小票的按钮
- (void)fiftyEightPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
      // [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
//        [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
//        return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
           // return;
        });
    }else{
        //显示时间
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
        
        JWPrinter *printer = [[JWPrinter alloc] init];
      //  [printer defaultSetting];
        
        [SVUserManager loadUserInfo];
        
        [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
        
        if ([self.dict[@"return_type"]doubleValue] == 1 || [self.dict[@"return_type"]doubleValue] == 2) {//退货单
            [printer appendText:@"退货单（补打）" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
            [printer appendNewLine];
        }else{
            [printer appendText:@"补打单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
            [printer appendNewLine];
        }
        
         
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
        double product_total_bak = 0.0;
        for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
            if (![dict[@"product_name"] containsString:@"(套餐)"]) {
                
                if ([self.dict[@"return_type"]doubleValue] == 1 || [self.dict[@"return_type"]doubleValue] == 2) {//退货单
                    NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
                    NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
                    NSString *product_num_bakstr = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
                    
                        CGFloat sv_p_weight = 0.0;
                        CGFloat product_num_bak = 0.0;
                      

                        sv_p_weight = [sv_p_weightstr doubleValue];
                        product_num_bak = [product_num_bakstr doubleValue];
                        totle_numcount = sv_p_weight + product_num_bak;
                        
                        NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
                        
                        [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                        [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] doubleValue]] isTitle:NO];
                        product_total_bak += [dict[@"product_total_bak"] doubleValue];
          
                        totle_numcount_all += totle_numcount;
                }else{
                    CGFloat sv_p_weight = 0.0;
                    CGFloat product_num = 0.0;
                    NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
                    NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];

                    sv_p_weight = [sv_p_weightstr doubleValue];
                    product_num = [product_numstr doubleValue];
                    totle_numcount = sv_p_weight + product_num;
                    
                    NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
                    
                    [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                    [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
                    
        //            total += [dict[@"product_price"] floatValue] * ([dict[@"product_num_bak"] intValue] + [dict[@"sv_p_weight_bak"] intValue]);
                    
                    CGFloat Discount_money = [dict[@"product_price"] floatValue] * totle_numcount - [dict[@"product_unitprice"] floatValue] * totle_numcount;
                    if (Discount_money > 0) {
                        [printer appendText:[NSString stringWithFormat:@"优惠：%.2f",Discount_money] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle];
                    }
                    
                    totle_Discount_money += Discount_money;
                    totle_numcount_all += totle_numcount;
                }
               

            }
            
        }
        
        
       
        
        if ([self.dict[@"return_type"]doubleValue] == 1 || [self.dict[@"return_type"]doubleValue] == 2) {//退货单
            [printer appendSeperatorLine];
            [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",product_total_bak] isTitle:NO];
            [printer appendSeperatorLine];
            [printer appendTitle:@"退货金额：" value:[NSString stringWithFormat:@"%.2f",product_total_bak]];
            if ([self.dict[@"free_change_bak"] floatValue] != 0) {
                [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"free_change"] floatValue]]];
            }
            
            if ([self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
               // self.paymentMethod.text = [NSString stringWithFormat:@"%@",self.dict[@"order_payment"]];
                [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
            } else {
        //        self.paymentMethod.text = [NSString stringWithFormat:@"%@(%.2f),%@(%.2f)",self.dict[@"order_payment"],[self.dict[@"order_money"]doubleValue],self.dict[@"order_payment2"],[self.dict[@"order_money2"]doubleValue]];
                
                [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@，%@",self.dict[@"order_payment"],self.dict[@"order_payment2"]]];
            }
          //  [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        }else{
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
            
        }
        

        if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
            [printer appendSeperatorLine];
            [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
            [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
            [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availableamount]];
            
           // [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
            [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availablepoint]];
            
        }
        
        
        
        [printer appendSeperatorLine];
        // [printer setLineSpace:60];
        
        if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
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
        //
    //    if (([self.dict[@"return_type"]doubleValue] == 1 || [self.dict[@"return_type"]doubleValue] == 2) && kStringIsEmpty(self.queryId)) {//退货单
    //        [printer appendBarCodeWithInfo:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter maxWidth:300];
    //        [printer appendText:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    //    }
        
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
            [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
            self.queryId = nil;
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
                [SVTool TextButtonActionWithSing:@"打印成功"];
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
        }];
        
    }
    
 
}

#pragma mark - 80的小票打印
- (void)eightyPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
//        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
//        [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
//        return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
          //  return;
        });
    }else{
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
                [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] floatValue]] isTitle:NO];
                
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
            [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availableamount]];
            
         //   [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
            [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availablepoint]];
            
        }
        [printer appendSeperatorLine80];
        // [printer setLineSpace:60];
        
        if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
            [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_us_phone];
        }
        
        if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
            [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
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
            [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
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
                NSLog(@"打印成功");
                [SVTool TextButtonActionWithSing:@"打印成功"];
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
        }];
    }
    
    
    
}



- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    self.boxView.center = CGPointMake(ScreenW / 2, ScreenH - height - 100);
    self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
     [self.addCustomView.textView becomeFirstResponder];// 2
}


//解码

-(NSString *)replaceUnicode:(NSString*)unicodeStr{
    NSString *tempStr1=[unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3=[[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData=[tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr =[NSPropertyListSerialization propertyListFromData:tempData
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:NULL
                                                          errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

#pragma mark - 打印小票
-(void)printe {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.promptRenewalView];
    self.promptRenewalView.renewLabel.text = @"确定补打小票吗？";
    [self.promptRenewalView.renewBtn setTitle:@"补打" forState:UIControlStateNormal];
   
}

- (SVPromptRenewalView *)promptRenewalView{
    if (_promptRenewalView == nil) {
        _promptRenewalView = [[NSBundle mainBundle] loadNibNamed:@"SVPromptRenewalView" owner:nil options:nil].lastObject;
       _promptRenewalView.frame = CGRectMake(40, 20, ScreenW - 80, 250);
       _promptRenewalView.layer.cornerRadius = 10;
       _promptRenewalView.layer.masksToBounds = YES;
      
       _promptRenewalView.centerY = ScreenH/2;
        
        [_promptRenewalView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
         [_promptRenewalView.renewBtn addTarget:self action:@selector(goLoginClick) forControlEvents:UIControlEventTouchUpInside];
         [_promptRenewalView.clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    }
     return _promptRenewalView;
}

- (void)loginBtnClick{
    
}

#pragma mark - 点击补打小票
- (void)goLoginClick{
    [self.maskOneView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        
  //  });
    
}

#pragma mark - 点击取消弹框
- (void)clearClick{
    [self.maskOneView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.waresNameArr.count;
    return self.salesDetails.list.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVDetailsHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsHistoryCell" forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVDetailsHistoryCell" owner:nil options:nil].lastObject;
        
    }
    
    if (self.ReturnPolicy == NO) {
        [cell.returnButton setEnabled:NO];
        [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
    }else{
//        [cell.returnButton setEnabled:YES];
//        [cell.returnButton setImage:[UIImage imageNamed:@"returnWares"] forState:UIControlStateNormal];
        NSString *state = [NSString stringWithFormat:@"%@",self.order_stutiaArr[indexPath.row]];
        float order_stutia = [state floatValue];
        NSString *return_type = [NSString stringWithFormat:@"%@",self.dict[@"return_type"]];
        if ([return_type isEqualToString:@"2"]) {
            //设置按钮不可点击returnWares
            [cell.returnButton setEnabled:NO];

            [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
        }else if ([return_type isEqualToString:@"3"]){
            [cell.returnButton setEnabled:NO];

            [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
        }else{
    //        [cell.returnButton setEnabled:YES];
    //        [cell.returnButton setImage:[UIImage imageNamed:@"returnWares"] forState:UIControlStateNormal];
                    if (order_stutia == 2) {

                        //设置按钮不可点击returnWares
                        [cell.returnButton setEnabled:NO];

                        [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
                        self.button.userInteractionEnabled = NO;
                        [self.button setBackgroundColor:GreyFontColor];

                    }else if (order_stutia == 5){
                        //设置按钮不可点击returnWares
                        [cell.returnButton setEnabled:NO];

                        [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
                        self.button.userInteractionEnabled = NO;
                        [self.button setBackgroundColor:GreyFontColor];
                    }else if (order_stutia == 1){
                        [cell.returnButton setEnabled:NO];

                        [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
                        self.button.userInteractionEnabled = NO;
                        [self.button setBackgroundColor:GreyFontColor];
                    }else if (order_stutia == 4){
                        [cell.returnButton setEnabled:NO];

                        [cell.returnButton setImage:[UIImage imageNamed:@"returnGoods"] forState:UIControlStateNormal];
                        self.button.userInteractionEnabled = NO;
                        [self.button setBackgroundColor:GreyFontColor];
                    }else {

    //                    self.button.userInteractionEnabled = YES;
    //                    [self.button setBackgroundColor:na];
                        //设置按钮不可点击returnWares
                        [cell.returnButton setEnabled:YES];
                        [cell.returnButton setImage:[UIImage imageNamed:@"returnWares"] forState:UIControlStateNormal];

                    }
        }
    }
   
    
   
//    cell.returnButton.hidden = YES;
    cell.cardno = self.cardno;
   // cell.sv_mr_name = [NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]];
    //用模型数组给cell赋值
//    cell.detalisHistoryModel = self.modelArr[indexPath.row];
    cell.salesDetailsListModel = self.salesDetails.list[indexPath.row];
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.returnButton.tag = indexPath.row;
    
   
    
    //设置单件退货
    [cell.returnButton addTarget:self action:@selector(singleButtonResponseEvent:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    self.hidesBottomBarWhenPushed=YES;
    //    SVSellOrderVC *VC = [[SVSellOrderVC alloc]init];
    //
    //    VC.prlistArr = self.prlistArr;
    //
    //    //跳转界面有导航栏的
    //    [self.navigationController pushViewController:VC animated:YES];
    //    self.hidesBottomBarWhenPushed=YES;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];// 1
    [self.boxView.textField becomeFirstResponder];// 2
}

#pragma mark - 整单退按钮
//整单退货
-(void)wholeButtonResponseEvent{
    self.selectWholeOrder = 1;
//    model.sv_mp_id.intValue > 0 && !kStringIsEmpty(model.sv_activity_depict)
    
  //  self.boxView.center = CGPointMake(ScreenW / 2, ScreenH - 300);
//    self.selectWholeOrder = 1;
//    if ([self.paymentMethod.text containsString:@"微信"] || [self.paymentMethod.text containsString:@"支付宝"] || [self.paymentMethod.text containsString:@"龙支付"]) {
//        if ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"11"] ) {
//            [self.boxView.textField becomeFirstResponder];// 2
//            [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
//            [[UIApplication sharedApplication].keyWindow addSubview:self.boxView];
//
//        }else{
//            [self tuihuo];
//        }
//    }else{
//        [self tuihuo];
//    }
    [self tuihuoluoji];

}

#pragma mark - 整单退货处理
- (void)tuihuo{
    int sv_mp_id_num = 0;
    NSString *sv_activity_depict;
    for (SVDetailsHistoryModel *model in self.modelArr) {
        if (model.sv_mp_id.intValue > 0 && !kStringIsEmpty(model.sv_activity_depict)) {
            sv_mp_id_num = model.sv_mp_id.intValue;
            sv_activity_depict = model.sv_activity_depict;
            break;
        }else{
            sv_mp_id_num = model.sv_mp_id.intValue;
            sv_activity_depict = model.sv_activity_depict;
        }
    }
    
    
    if (sv_mp_id_num > 0 && !kStringIsEmpty(sv_activity_depict)) {
        [SVTool TextButtonAction:self.view withSing:@"含有促销活动商品，不能退"];
    }else{
        
        NSString *state_two;
        for (NSString *state in self.order_stutiaArr) {
            NSString *aa = [NSString stringWithFormat:@"%@",state];
            if ([aa isEqualToString:@"2"]) {
                state_two = aa;
                break;
            }else{
                state_two = aa;
            }
            
        }
        // float stateNum = [state_two floatValue];
        if ([state_two isEqualToString:@"2"]) {
            [SVTool TextButtonAction:self.view withSing:@"单品退过了，不能整单退"];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要整单退吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *order_payment = self.dict[@"order_payment"];
                NSString *order_payment2 = self.dict[@"order_payment2"];
                [SVUserManager loadUserInfo];
                NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
                if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && self.isAggregatePayment == false){
                    if ([order_payment isEqualToString:@"支付宝支付"]&& [order_payment2 isEqualToString:@"待收"]) {
                        //用延迟来移除提示框
                        return [SVTool TextButtonActionWithSing:@"请先设置退款密码"];
                    }else if ([order_payment isEqualToString:@"微信支付"]&& [order_payment2 isEqualToString:@"待收"]){
                        //用延迟来移除提示框
                        return [SVTool TextButtonActionWithSing:@"请先设置退款密码"];
                    }else{
                        [self zhengdanzhifu];
                    }
                   
                }else{
                    [self zhengdanzhifu];
                }
                

            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:derAction];
            
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

- (void)zhengdanzhifu{
    NSString *sv_mcr_payment = [NSString stringWithFormat:@"%@",self.dict[@"order_payment"]];

            
    [SVUserManager loadUserInfo];
               // NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dec_payment_method =[SVUserManager shareInstance].dec_payment_method;
                
    if ([dec_payment_method isEqualToString:@"5"] && ([sv_mcr_payment isEqualToString:@"支付宝"] || [sv_mcr_payment isEqualToString:@"微信"] || [sv_mcr_payment isEqualToString:@"微信支付"])) {

        [SVUserManager loadUserInfo];
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                        
                            [self tuihuoFuction];
                        }else{
                           NSDictionary *dict1 = childDetailList[0];
                            
                           NSString *sv_detail_is_enable = [NSString stringWithFormat:@"%@",dict1[@"sv_detail_is_enable"]];
                            
                            if (sv_detail_is_enable.intValue == 1)  {
                                
                                [self.addCustomView.textView becomeFirstResponder];// 2
                                [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                                [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
                            }else{
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
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }else{
        [self tuihuoFuction];
    }
}


#pragma mark - 整单退货
- (void)tuihuoFuction{
   
    [SVUserManager loadUserInfo];
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    //        [SVProgressHUD showWithStatus:@"正在提交中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    NSString *order_payment = self.dict[@"order_payment"];
    NSString *order_payment2 = self.dict[@"order_payment2"];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    NSString *strURL = [[NSString alloc] init];
    if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) {// 开通了聚合支付
        strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
    }else{
        strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
    }
                      
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"其它原因" forKey:@"return_cause"];
    [parameters setObject:self.order_id forKey:@"order_id"];
    [parameters setObject:@"" forKey:@"return_remark"];
    //        [parameters setObject:self.product_id forKey:@"order_product_id"];
    [parameters setObject:@"0" forKey:@"return_type"];
    [parameters setObject:@"301" forKey:@"sv_operation_source"];
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            [SVUserManager loadUserInfo];
            NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
            if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) {// 开通了聚合支付
                NSDictionary *values = dic[@"values"];
                int refundSuccess = [values[@"refundSuccess"] intValue];
                if (refundSuccess == 1) { // 订单提交上去了
                    self.dict = dic[@"values"][@"prdata"];
                    NSString *order_number = [NSString stringWithFormat:@"%@",self.dict[@"order_number"]];
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                   // self.showView.title = @"退款中。。。";
                    self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
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
                    if (refundSuccess == -1) {
                        [SVTool TextButtonAction:self.view withSing:@"密码错误"];
                    }else{
                        if (self.sellOrderBlock) {
                            self.sellOrderBlock();
                        }
                        [SVTool TextButtonActionWithSing:@"退款成功"];
                        [SVUserManager loadUserInfo];
                        if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                            [SVUserManager shareInstance].printerNumber = @"1";
                            [SVUserManager saveUserInfo];
                        }
                        
                        
                        [SVUserManager loadUserInfo];
                        for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                            if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                                [self danpinFiftyEightPrinting];
                            }
                            
                            if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                                [self danpinEightyPrinting];
                            }
                            
                            
                        }
                        
                        //用延迟来移除提示框
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //隐藏提示
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.maskOneView removeFromSuperview];
                            [self.singleView removeFromSuperview];
                            
                            //返回上一控制器
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }
                
                //隐藏提示
              //  [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                if (self.sellOrderBlock) {
                    self.sellOrderBlock();
                }
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"退货成功";
                hud.label.textColor = [UIColor whiteColor];//字体颜色
                self.dict = dic[@"values"][@"prdata"];
                NSDictionary *myuser = dic[@"values"][@"myuser"];
                self.sv_mw_availableamount = [myuser[@"sv_mw_availableamount"] doubleValue];
                
                self.sv_mw_availablepoint = [myuser[@"sv_mw_availablepoint"] doubleValue];
                
                [SVUserManager loadUserInfo];
                if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                    [SVUserManager shareInstance].printerNumber = @"1";
                    [SVUserManager saveUserInfo];
                }
                
                
                [SVUserManager loadUserInfo];
                for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                    if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                        [self zhengdanFiftyEightPrinting];
                    }
                    
                    if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                        //[self eightyPrinting];
                        [self zhengdanEightyPrinting];
                    }
                    
                    
                }
                
                
                //用延迟来移除提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //返回上一控制器
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
            
            
        }else{
            //                            if (self.sellOrderBlock) {
            //                                self.sellOrderBlock();
            //                            }
            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
            hud.mode = MBProgressHUDModeText;
            if (kStringIsEmpty(errmsg)) {
                hud.label.text = errmsg;
            }else{
                hud.label.text = @"退货不成功";
            }
            
            hud.label.textColor = [UIColor whiteColor];//字体颜色
            
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //                                //返回上一控制器
                //                                [self.navigationController popViewControllerAnimated:YES];
            });
        }

                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];

                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //            [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                        }];
}

#pragma mark - 查询退款结果 轮训
- (void)refundResultQueryId:(NSString *)queryId _timer:(dispatch_source_t)_timer{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/Refund/%@?key=%@",queryId,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

          NSLog(@"dic查询退款结果 == %@",dic);
         if ([dic[@"code"] integerValue] == 1) {
             NSString *action = [NSString stringWithFormat:@"%@",dic[@"data"][@"action"]];
             NSString *msg = dic[@"data"][@"msg"];
             if (action.integerValue == -1) {// 停止轮训
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
                 [SVTool TextButtonActionWithSing:msg?:@"停止轮训"];
                 [self.singleView.determineButton setEnabled:YES];
                 //隐藏提示
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }else if(action.integerValue == 1){// 1:Success,取到结果;
                 [self.singleView.determineButton setEnabled:YES];
                 [SVTool TextButtonActionWithSing:@"退款成功"];
                 if (self.sellOrderBlock) {
                     self.sellOrderBlock();
                 }
                 
                 self.queryId = queryId;
                 if (self.selectWholeOrder == 0) { // 是单品退
                     [SVUserManager loadUserInfo];
                     if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                         [SVUserManager shareInstance].printerNumber = @"1";
                         [SVUserManager saveUserInfo];
                     }
                     
                     
                     [SVUserManager loadUserInfo];
                     for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                         if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                             [self danpinFiftyEightPrinting];
                         }
                         
                         if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                             [self danpinEightyPrinting];
                         }
                         
                         
                     }
                 }else{
                     [SVUserManager loadUserInfo];
                     if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                         [SVUserManager shareInstance].printerNumber = @"1";
                         [SVUserManager saveUserInfo];
                     }
                     
                     
                     [SVUserManager loadUserInfo];
                     for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                         if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                             [self zhengdanFiftyEightPrinting];
                         }
                         
                         if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                             //[self eightyPrinting];
                             [self zhengdanEightyPrinting];
                         }
                         
                         
                     }
                 }
                 
 
                 //隐藏提示
              //   [MBProgressHUD hideHUDForView:self.view animated:YES];
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
                 
                 //用延迟来移除提示框
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     //隐藏提示
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //返回上一控制器
                     [self.navigationController popViewControllerAnimated:YES];
                 });
                 
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


#pragma mark - 整单退货58小票打印
- (void)zhengdanFiftyEightPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
      // [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
//        [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
//        return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
           
        });
    }else{
        //显示时间
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
        
        JWPrinter *printer = [[JWPrinter alloc] init];
      //  [printer defaultSetting];
        
        [SVUserManager loadUserInfo];
        
        [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
        

            [printer appendText:@"退货单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
            [printer appendNewLine];
     
        
         
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
        double product_total_bak = 0.0;
        for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
            if (![dict[@"product_name"] containsString:@"(套餐)"]) {
                
       
                    NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
                    NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
                    NSString *product_num_bakstr = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
                    
                        CGFloat sv_p_weight = 0.0;
                        CGFloat product_num_bak = 0.0;
                      

                        sv_p_weight = [sv_p_weightstr doubleValue];
                        product_num_bak = [product_num_bakstr doubleValue];
                        totle_numcount = sv_p_weight + product_num_bak;
                        
                        NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
                        
                        [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                        [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] doubleValue]] isTitle:NO];
                        product_total_bak += [dict[@"product_total_bak"] doubleValue];
          
                        totle_numcount_all += totle_numcount;
                }
               

          
            
        }
        
        [printer appendSeperatorLine];
        [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",product_total_bak] isTitle:NO];
        [printer appendSeperatorLine];
        
            [printer appendTitle:@"退货金额：" value:[NSString stringWithFormat:@"%.2f",product_total_bak]];
            if ([self.dict[@"free_change_bak"] floatValue] != 0) {
                [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"free_change"] floatValue]]];
            }
          //  [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        if ([self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
           // self.paymentMethod.text = [NSString stringWithFormat:@"%@",self.dict[@"order_payment"]];
            [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        } else {
    //        self.paymentMethod.text = [NSString stringWithFormat:@"%@(%.2f),%@(%.2f)",self.dict[@"order_payment"],[self.dict[@"order_money"]doubleValue],self.dict[@"order_payment2"],[self.dict[@"order_money2"]doubleValue]];
            
          //  [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@，%@",self.dict[@"order_payment"],self.dict[@"order_payment2"]]];
        }
        
        if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
            [printer appendSeperatorLine];
            [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
            [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
            [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availableamount]];
            
           // [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
            [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availablepoint]];
            
        }
        
        
        
        [printer appendSeperatorLine];
        // [printer setLineSpace:60];
        
        if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
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
            [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
            self.queryId = nil;
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
                [SVTool TextButtonActionWithSing:@"打印成功"];
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
        }];
        
    }
   
 
}

#pragma mark - 整单退货80的小票打印
- (void)zhengdanEightyPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
//        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
           // return;
        });
       
    }else{
        //显示时间
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
        
        JWPrinter *printer = [[JWPrinter alloc] init];
        [printer defaultSetting];
        
        [SVUserManager loadUserInfo];
        
        [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
        
        [printer appendText:@"退货单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
        [printer appendNewLine];
    //    NSString *order_serial_number =[NSString stringWithFormat:@"%@",self.dict[@"order_serial_number"]];
    //     if (!kStringIsEmpty(order_serial_number)) {
    //         [printer appendTitle:@"流水号:" value:[NSString stringWithFormat:@"%@",self.dict[@"order_serial_number"]] fontSize:HLFontSizeTitleSmalle];
    //     }
        [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.dict[@"order_running_id"]] fontSize:HLFontSizeTitleSmalle];
        [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
        [printer appendTitle:@"收银员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
        [printer appendSeperatorLine80];
//        [printer eightAppendLeftText:@"品名/款号" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
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
        double product_total_bak = 0.0;
        for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
            if (![dict[@"product_name"] containsString:@"(套餐)"]) {
                
                
                NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
                NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
                NSString *product_num_bakstr = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
                
                    CGFloat sv_p_weight = 0.0;
                    CGFloat product_num_bak = 0.0;
                  

                    sv_p_weight = [sv_p_weightstr doubleValue];
                    product_num_bak = [product_num_bakstr doubleValue];
                    totle_numcount = sv_p_weight + product_num_bak;
                    
                    NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
                    
                    [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                    [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] doubleValue]] isTitle:NO];
                    product_total_bak += [dict[@"product_total_bak"] doubleValue];
      
                    totle_numcount_all += totle_numcount;
            }
        }
        
        
        [printer appendSeperatorLine80];
        [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",product_total_bak] isTitle:NO];
        [printer appendSeperatorLine80];
        
            [printer appendTitle:@"退货金额：" value:[NSString stringWithFormat:@"%.2f",product_total_bak]];
            if ([self.dict[@"free_change_bak"] floatValue] != 0) {
                [printer appendTitle:@"抹零：" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"free_change"] floatValue]]];
            }
           // [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        if ([self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
           // self.paymentMethod.text = [NSString stringWithFormat:@"%@",self.dict[@"order_payment"]];
            [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        } else {
    //        self.paymentMethod.text = [NSString stringWithFormat:@"%@(%.2f),%@(%.2f)",self.dict[@"order_payment"],[self.dict[@"order_money"]doubleValue],self.dict[@"order_payment2"],[self.dict[@"order_money2"]doubleValue]];
            
          //  [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@，%@",self.dict[@"order_payment"],self.dict[@"order_payment2"]]];
        }
        
        if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
            [printer appendSeperatorLine80];
            [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
            [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
            [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availableamount]];
            
           // [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
            [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availablepoint]];
            
        }
        
        
        
        [printer appendSeperatorLine80];
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
        
    //    [printer appendBarCodeWithInfo:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter maxWidth:300];
    //    [printer appendText:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
        
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
            [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
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
                NSLog(@"打印成功");
                [SVTool TextButtonActionWithSing:@"打印成功"];
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
        }];
    }
    
   
    
}



#pragma mark - 单品退货自定义弹框的确定按钮   这个是旧的密码框
- (void)orderSureBtnClick{
    if (self.selectWholeOrder == 0) {// 0是单品
        if (!kStringIsEmpty(self.addCustomView.textView.text)){
            
            [SVUserManager loadUserInfo];
            
            //不用交互
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
            //提示在支付中
            //        [SVProgressHUD showWithStatus:@"正在提交中"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = @"正在提交中...";
            hud.label.textColor = [UIColor whiteColor];//字体颜色
            hud.bezelView.color = [UIColor blackColor];//背景颜色
            hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
            hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
            //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
            hud.yOffset = -50.0f;
            NSString *passWord = self.addCustomView.textView.text;
            //密码进行MD5加密
            NSString *pwdMD5=[JWXUtils EncodingWithMD5:passWord].uppercaseString;
            NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@&refundPassword=%@",[SVUserManager shareInstance].access_token,pwdMD5];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:self.whyString forKey:@"return_cause"];
            [parameters setObject:self.order_id forKey:@"order_id"];
            [parameters setObject:self.singleView.note.text forKey:@"return_remark"];
            [parameters setObject:self.singleView.number.text forKey:@"return_num"];
            [parameters setObject:self.order_product_id forKey:@"order_product_id"];
            //    [parameters setObject:self.order_id forKey:@"order_product_id"];
            [parameters setObject:@"1" forKey:@"return_type"];
            [parameters setObject:@"301" forKey:@"sv_operation_source"];
            NSLog(@"parameters = %@",parameters);
            NSLog(@"strURL = %@",strURL);
            
            
            [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                
                if ([dic[@"succeed"] integerValue] == 1) {
                    
                    if (self.sellOrderBlock) {
                        self.sellOrderBlock();
                    }
                    
                    self.dict = dic[@"values"][@"prdata"];
                    NSDictionary *myuser = dic[@"values"][@"myuser"];
                   self.sv_mw_availableamount = [myuser[@"sv_mw_availableamount"] doubleValue];
                    
                    self.sv_mw_availablepoint = [myuser[@"sv_mw_availablepoint"] doubleValue];
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"退货成功";
                    hud.label.textColor = [UIColor whiteColor];//字体颜色
                    
                    [SVUserManager loadUserInfo];
                    if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                        [SVUserManager shareInstance].printerNumber = @"1";
                        [SVUserManager saveUserInfo];
                    }
                    
                    
                    [SVUserManager loadUserInfo];
                    for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                        if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                            [self danpinFiftyEightPrinting];
                        }
                        
                        if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                            [self danpinEightyPrinting];
                        }
                        
                        
                    }
                    //用延迟来移除提示框
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //隐藏提示
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.maskOneView removeFromSuperview];
                        [self.singleView removeFromSuperview];
                        //返回上一控制器
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else{
//                    if (self.sellOrderBlock) {
//                        self.sellOrderBlock();
//                    }
//
                    
                   NSString *errmsg=[NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                    if (kStringIsEmpty(errmsg)) {
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = @"退货不成功";
                        hud.label.textColor = [UIColor whiteColor];//字体颜色
                    }else{
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = errmsg;
                        hud.label.textColor = [UIColor whiteColor];//字体颜色
                    }
                    
                    //用延迟来移除提示框
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //隐藏提示
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.maskOneView removeFromSuperview];
                        [self.singleView removeFromSuperview];
//                        //返回上一控制器
//                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //        [SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
            }];
        }else{
            [SVTool TextButtonActionWithSing:@"请输入密码"];
        }
         
    }else{
        
          if (!kStringIsEmpty(self.addCustomView.textView.text)){
        NSString *passWord = self.addCustomView.textView.text;
                           //密码进行MD5加密
                              NSString *pwdMD5=[JWXUtils EncodingWithMD5:passWord].uppercaseString;
                           [SVUserManager loadUserInfo];
                           
                           //不用交互
                           [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
                           //提示在支付中
                           //        [SVProgressHUD showWithStatus:@"正在提交中"];
                           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                           hud.mode = MBProgressHUDModeIndeterminate;
                           hud.label.text = @"正在提交中...";
                           hud.label.textColor = [UIColor whiteColor];//字体颜色
                           hud.bezelView.color = [UIColor blackColor];//背景颜色
                           hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
                           hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
                           //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
                           hud.yOffset = -50.0f;
                           
                           NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@&refundPassword=%@",[SVUserManager shareInstance].access_token,pwdMD5];
                           
                           NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                           
                           [parameters setObject:@"其它原因" forKey:@"return_cause"];
                           [parameters setObject:self.order_id forKey:@"order_id"];
                           [parameters setObject:@"" forKey:@"return_remark"];
                           //        [parameters setObject:self.product_id forKey:@"order_product_id"];
                           [parameters setObject:@"0" forKey:@"return_type"];
                           [parameters setObject:@"301" forKey:@"sv_operation_source"];
                           
                           
                           [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               
                               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                               
                               
                               if ([dic[@"succeed"] integerValue] == 1) {
                                   
                                   if (self.sellOrderBlock) {
                                       self.sellOrderBlock();
                                   }
                                   
                                   self.dict = dic[@"values"][@"prdata"];
                                   NSDictionary *myuser = dic[@"values"][@"myuser"];
                                  self.sv_mw_availableamount = [myuser[@"sv_mw_availableamount"] doubleValue];
                                   
                                   self.sv_mw_availablepoint = [myuser[@"sv_mw_availablepoint"] doubleValue];
                                   
                                   hud.mode = MBProgressHUDModeText;
                                   hud.label.text = @"退货成功";
                                   hud.label.textColor = [UIColor whiteColor];//字体颜色
                                   
                                   [SVUserManager loadUserInfo];
                                   if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                                       [SVUserManager shareInstance].printerNumber = @"1";
                                       [SVUserManager saveUserInfo];
                                   }
                                   
                                   
                                   [SVUserManager loadUserInfo];
                                   for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                                       if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                                           [self zhengdanFiftyEightPrinting];
                                       }
                                       
                                       if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                                           [self zhengdanEightyPrinting];
                                       }
                                       
                                       
                                   }
                                   
                                   //用延迟来移除提示框
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       //隐藏提示
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       //返回上一控制器
                                       [self.navigationController popViewControllerAnimated:YES];
                                   });
                                   
                               }else{
                                   NSString *errmsg=[NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                                   if (kStringIsEmpty(errmsg)) {
                                       hud.mode = MBProgressHUDModeText;
                                       hud.label.text = @"退货不成功";
                                       hud.label.textColor = [UIColor whiteColor];//字体颜色
                                   }else{
                                       hud.mode = MBProgressHUDModeText;
                                       hud.label.text = errmsg;
                                       hud.label.textColor = [UIColor whiteColor];//字体颜色
                                   }
                                   //用延迟来移除提示框
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       //隐藏提示
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       [self.maskOneView removeFromSuperview];
                                       [self.singleView removeFromSuperview];
                                       //                        //返回上一控制器
                                       //                        [self.navigationController popViewControllerAnimated:YES];
                                   });
                                   
                                                      
                               }
                               
                               //开启交互
                               [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                               
                               //隐藏提示
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               //隐藏提示
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               //            [SVTool requestFailed];
                               [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                               //开启交互
                               [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                           }];
              
          }else{
              [SVTool TextButtonActionWithSing:@"请输入密码"];
          }
    }
    

    [self.addCustomView.textView endEditing:YES];
    [self vipCancelResponseEvent];
    //隐藏提示
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.addCustomView.textView.text = nil;
}

#pragma mark - 验证退货逻辑
- (void)tuihuoluoji{
    [SVUserManager loadUserInfo];
    NSString *order_payment = self.dict[@"order_payment"];
    NSString *order_payment2 = self.dict[@"order_payment2"];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 &&  self.isAggregatePayment == TRUE && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) {// 聚合支付-----验证退款密码
        [self.boxView.textField becomeFirstResponder];// 2
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
        self.boxView.nameLabel.text = @"退回该笔交易金额需要验证当前账号退款密码";
        [[UIApplication sharedApplication].keyWindow addSubview:self.boxView];
    }else if ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"11"] && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))){ // 不是聚合支付----验证登录密码
        [self.boxView.textField becomeFirstResponder];// 2
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
        self.boxView.nameLabel.text = @"退回该笔交易金额需要验证当前账号登录密码";
        [[UIApplication sharedApplication].keyWindow addSubview:self.boxView];
    }else if ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"5"] &&self.isAggregatePayment == TRUE && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))){
        // 不是聚合支付----验证退款密码
        [self.boxView.textField becomeFirstResponder];// 2
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
        self.boxView.nameLabel.text = @"退回该笔交易金额需要验证当前账号退款密码";
        [[UIApplication sharedApplication].keyWindow addSubview:self.boxView];
    }else{
        if (self.selectWholeOrder == 0) { // 是单品退货
            if ([self.singleView.number.text integerValue] == 0) {
                [SVTool TextButtonAction:self.view withSing:@"请输入退货数量"];
                return;
            }

            if ([self.singleView.number.text integerValue] > [self.num integerValue]) {
                [SVTool TextButtonAction:self.view withSing:@"数量过大"];
                return;
            }
            [self danpintuihuoFuction];
        }else{// 整单退货
            [self tuihuo];
        }
    }
}

#pragma mark - 需要输入会员密码确定按钮的点击
- (void)sureBtnClick{
    if ([self.boxView.nameLabel.text isEqualToString:@"退回该笔交易金额需要验证当前账号退款密码"]) {
        [self refundPass];
    }else{
        // 输入登录密码时调用
        [self SignInPass];
    }

}

#pragma mark - 输入退款密码
- (void)refundPass{
    if (self.selectWholeOrder == 0) { // 是单品退货

            if ([self.singleView.number.text integerValue] == 0) {
                [SVTool TextButtonAction:self.view withSing:@"请输入退货数量"];
                return;
            }

            if ([self.singleView.number.text integerValue] > [self.num integerValue]) {
                [SVTool TextButtonAction:self.view withSing:@"数量过大"];
                return;
            }


            
            [self danpintuihuoFuction];

//        }else{
//            [self oneCancelResponseEvent];
//            [SVTool TextButtonActionWithSing:@"密码有误"];
//        }
    }else{
        // 1是整单退货
//        [SVUserManager loadUserInfo];
//        if ( [[SVUserManager shareInstance].passwd isEqualToString:self.boxView.textField.text]) {
          //  [self tuihuo];
            
            int sv_mp_id_num = 0;
            NSString *sv_activity_depict;
            for (SVDetailsHistoryModel *model in self.modelArr) {
                if (model.sv_mp_id.intValue > 0 && !kStringIsEmpty(model.sv_activity_depict)) {
                    sv_mp_id_num = model.sv_mp_id.intValue;
                    sv_activity_depict = model.sv_activity_depict;
                    break;
                }else{
                    sv_mp_id_num = model.sv_mp_id.intValue;
                    sv_activity_depict = model.sv_activity_depict;
                }
            }
            
            
            if (sv_mp_id_num > 0 && !kStringIsEmpty(sv_activity_depict)) {
                [SVTool TextButtonAction:self.view withSing:@"含有促销活动商品，不能退"];
            }else{
                
                NSString *state_two;
                for (NSString *state in self.order_stutiaArr) {
                    NSString *aa = [NSString stringWithFormat:@"%@",state];
                    if ([aa isEqualToString:@"2"]) {
                        state_two = aa;
                        break;
                    }else{
                        state_two = aa;
                    }
                    
                }
                // float stateNum = [state_two floatValue];
                if ([state_two isEqualToString:@"2"]) {
                    [SVTool TextButtonAction:self.view withSing:@"单品退过了，不能整单退"];
                }else{
                    
                    

                        [SVUserManager loadUserInfo];
                        
                        //不用交互
                        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
                        //提示在支付中
                        //        [SVProgressHUD showWithStatus:@"正在提交中"];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeIndeterminate;
                        hud.label.text = @"正在提交中...";
                        hud.label.textColor = [UIColor whiteColor];//字体颜色
                        hud.bezelView.color = [UIColor blackColor];//背景颜色
                        hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
                        hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
                        //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
                        hud.yOffset = -50.0f;
                    
                    NSString *strURL = [[NSString alloc] init];
                                        [SVUserManager loadUserInfo];
                    [SVUserManager loadUserInfo];
                    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
                    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) || ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"5"])) {// 开通了聚合支付
                        NSString *passWord = self.boxView.textField.text;
                        NSLog(@"passWord = %@",passWord);
                        //密码进行MD5加密
                        NSString *pwdMD5=[JWXUtils EncodingWithMD5:passWord];
                      //  NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@&refundPassword=%@",[SVUserManager shareInstance].access_token,pwdMD5];
                        strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@&refundPassword=%@",[SVUserManager shareInstance].access_token,pwdMD5];
                    }else{
                       strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
                    }
                        
                     //   NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
                        
                        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                        [parameters setObject:@"其它原因" forKey:@"return_cause"];
                        [parameters setObject:self.order_id forKey:@"order_id"];
                        [parameters setObject:@"" forKey:@"return_remark"];
                        [parameters setObject:@"0" forKey:@"return_type"];
                        [parameters setObject:@"301" forKey:@"sv_operation_source"];
                        [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            
                            
                            if ([dic[@"succeed"] integerValue] == 1) {
                                
                                [SVUserManager loadUserInfo];
                                NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
                                if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) || ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"5"])) {// 开通了聚合支付
                                    NSDictionary *values = dic[@"values"];
                                    int refundSuccess = [values[@"refundSuccess"] intValue];
                                    if (refundSuccess == 1) { // 订单提交上去了
                                        //隐藏提示
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        self.dict = dic[@"values"][@"prdata"];
                                        NSString *order_number = [NSString stringWithFormat:@"%@",self.dict[@"order_number"]];
                                        self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
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
                                        if (refundSuccess == -1) {
                                            [SVTool TextButtonAction:self.view withSing:@"密码错误"];
                                        }else{
                                            if (self.sellOrderBlock) {
                                                self.sellOrderBlock();
                                            }
                                            [SVTool TextButtonActionWithSing:@"退款成功"];
                                            [SVUserManager loadUserInfo];
                                            if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                                                [SVUserManager shareInstance].printerNumber = @"1";
                                                [SVUserManager saveUserInfo];
                                            }
                                            
                                            
                                            [SVUserManager loadUserInfo];
                                            for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                                                if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                                                    [self danpinFiftyEightPrinting];
                                                }
                                                
                                                if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                                                    [self danpinEightyPrinting];
                                                }
                                                
                                                
                                            }
                                            
                                            //用延迟来移除提示框
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                //隐藏提示
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                [self.maskOneView removeFromSuperview];
                                                [self.singleView removeFromSuperview];
                                                
                                                //返回上一控制器
                                                [self.navigationController popViewControllerAnimated:YES];
                                            });
                                        }
                                    }
                                }else{
                                
                                if (self.sellOrderBlock) {
                                    self.sellOrderBlock();
                                }
                                
                                hud.mode = MBProgressHUDModeText;
                                NSString *refundSuccess = [NSString stringWithFormat:@"%@",dic[@"values"][@"refundSuccess"]];
                                if ([refundSuccess isEqualToString:@"0"]) {
                                    hud.label.text = @"未进行退款操作";
                                }else if ([refundSuccess isEqualToString:@"1"]){
                                    hud.label.text = @"退款成功";
                                }else if ([refundSuccess isEqualToString:@"-1"]){
                                    hud.label.text = @"退款失败";
                                }
                                
                                hud.label.textColor = [UIColor whiteColor];//字体颜色
                                
                                //用延迟来移除提示框
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //隐藏提示
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    //返回上一控制器
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                                
                            }
                            }else{
                                //dispatch_source_cancel(_timer);
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                                [self.showView removeFromSuperview];
                                [SVTool TextButtonActionWithSing:!kStringIsEmpty(errmsg)?errmsg:@"密码有误"];
                                //用延迟来移除提示框
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //隐藏提示
                                  
                                    //返回上一控制器
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                                
                            }
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //            [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                        }];
                    }

            }
            
            [self oneCancelResponseEvent];
            
//        }else{
//            [self oneCancelResponseEvent];
//            [SVTool TextButtonActionWithSing:@"密码有误"];
//
//        }
    }
}

#pragma mark - 输入登录密码
- (void)SignInPass{
    if (self.selectWholeOrder == 0) { // 是单品退货
        [SVUserManager loadUserInfo];
        if ( [[SVUserManager shareInstance].passwd isEqualToString:self.boxView.textField.text]) {
            
            if ([self.singleView.number.text integerValue] == 0) {
                [SVTool TextButtonAction:self.view withSing:@"请输入退货数量"];
                return;
            }

            if ([self.singleView.number.text integerValue] > [self.num integerValue]) {
                [SVTool TextButtonAction:self.view withSing:@"数量过大"];
                return;
            }
            [self danpintuihuoFuction];

        }else{
            [self oneCancelResponseEvent];
            [SVTool TextButtonActionWithSing:@"密码有误"];
        }
    }else{
        // 1是整单退货
        [SVUserManager loadUserInfo];
        if ( [[SVUserManager shareInstance].passwd isEqualToString:self.boxView.textField.text]) {
          //  [self tuihuo];
            
            int sv_mp_id_num = 0;
            NSString *sv_activity_depict;
            for (SVDetailsHistoryModel *model in self.modelArr) {
                if (model.sv_mp_id.intValue > 0 && !kStringIsEmpty(model.sv_activity_depict)) {
                    sv_mp_id_num = model.sv_mp_id.intValue;
                    sv_activity_depict = model.sv_activity_depict;
                    break;
                }else{
                    sv_mp_id_num = model.sv_mp_id.intValue;
                    sv_activity_depict = model.sv_activity_depict;
                }
            }
            
            
            if (sv_mp_id_num > 0 && !kStringIsEmpty(sv_activity_depict)) {
                [SVTool TextButtonAction:self.view withSing:@"含有促销活动商品，不能退"];
            }else{
                
                NSString *state_two;
                for (NSString *state in self.order_stutiaArr) {
                    NSString *aa = [NSString stringWithFormat:@"%@",state];
                    if ([aa isEqualToString:@"2"]) {
                        state_two = aa;
                        break;
                    }else{
                        state_two = aa;
                    }
                    
                }
                // float stateNum = [state_two floatValue];
                if ([state_two isEqualToString:@"2"]) {
                    [SVTool TextButtonAction:self.view withSing:@"单品退过了，不能整单退"];
                }else{
                    
                    

                        [SVUserManager loadUserInfo];
                        
                        //不用交互
                        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
                        //提示在支付中
                        //        [SVProgressHUD showWithStatus:@"正在提交中"];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeIndeterminate;
                        hud.label.text = @"正在提交中...";
                        hud.label.textColor = [UIColor whiteColor];//字体颜色
                        hud.bezelView.color = [UIColor blackColor];//背景颜色
                        hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
                        hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
                        //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
                        hud.yOffset = -50.0f;
                        
                        NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
                        
                        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                        
                        [parameters setObject:@"其它原因" forKey:@"return_cause"];
                        [parameters setObject:self.order_id forKey:@"order_id"];
                        [parameters setObject:@"" forKey:@"return_remark"];
                        //        [parameters setObject:self.product_id forKey:@"order_product_id"];
                        [parameters setObject:@"0" forKey:@"return_type"];
                        [parameters setObject:@"301" forKey:@"sv_operation_source"];
                        
                        
                        [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            
                            
                            if ([dic[@"succeed"] integerValue] == 1) {
                                
                                if (self.sellOrderBlock) {
                                    self.sellOrderBlock();
                                }
                                
                                hud.mode = MBProgressHUDModeText;
                                NSString *refundSuccess = [NSString stringWithFormat:@"%@",dic[@"values"][@"refundSuccess"]];
                                if ([refundSuccess isEqualToString:@"0"]) {
                                    hud.label.text = @"未进行退款操作";
                                }else if ([refundSuccess isEqualToString:@"1"]){
                                    hud.label.text = @"退款成功";
                                }else if ([refundSuccess isEqualToString:@"-1"]){
                                    hud.label.text = @"退款失败";
                                }
                                
                                hud.label.textColor = [UIColor whiteColor];//字体颜色
                                
                                //用延迟来移除提示框
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //隐藏提示
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    //返回上一控制器
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                                
                            }
                            
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //            [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                        }];
                    }

            }
            
            [self oneCancelResponseEvent];
            
        }else{
            [self oneCancelResponseEvent];
            [SVTool TextButtonActionWithSing:@"密码有误"];
            
        }
    }
}


#pragma mark - 单件退货弹框
-(void)singleButtonResponseEvent:(UIButton *)button{
    NSString *order_payment = self.dict[@"order_payment"];
    NSString *order_payment2 = self.dict[@"order_payment2"];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && self.isAggregatePayment == false){ //请先设置退款密码
        
        if ([order_payment isEqualToString:@"支付宝支付"]&& [order_payment2 isEqualToString:@"待收"]) {
            //用延迟来移除提示框
            return [SVTool TextButtonActionWithSing:@"请先设置退款密码"];
        }else if ([order_payment isEqualToString:@"微信支付"]&& [order_payment2 isEqualToString:@"待收"]){
            //用延迟来移除提示框
            return [SVTool TextButtonActionWithSing:@"请先设置退款密码"];
        }else{
            SVDetailsHistoryModel *model = self.modelArr[button.tag];
            
            if (model.sv_mp_id.intValue > 0 && !kStringIsEmpty(model.sv_activity_depict)) {
                [SVTool TextButtonAction:self.view withSing:@"促销活动商品"];
            }else{
                self.singleView.number.text = @"1";
                self.singleView.note.text = nil;
                self.singleView.waresName.text = model.product_name;
               // self.product_id = self.waresID[button.tag];
                self.product_id = model.product_id;
                self.order_product_id = self.waresID[button.tag];
                self.num = model.product_num;
                self.selectWholeOrder = 0;
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.singleView];
            }
        }
        
    //    return [SVTool TextButtonActionWithSing:@"请先设置退款密码"];
        }else{
            SVDetailsHistoryModel *model = self.modelArr[button.tag];
            
            if (model.sv_mp_id.intValue > 0 && !kStringIsEmpty(model.sv_activity_depict)) {
                [SVTool TextButtonAction:self.view withSing:@"促销活动商品"];
            }else{
                self.singleView.number.text = @"1";
                self.singleView.note.text = nil;
                self.singleView.waresName.text = model.product_name;
               // self.product_id = self.waresID[button.tag];
                self.product_id = model.product_id;
                self.order_product_id = self.waresID[button.tag];
                self.num = model.product_num;
                self.selectWholeOrder = 0;
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.singleView];
            }
        }
   

}


#pragma mark - 单件退货确定按钮
-(void)oneDetermineResponseEvent{
    
    [self tuihuoluoji];
}

#pragma mark - 单品退货
- (void)danpintuihuoFuction{
   
    [self.singleView.determineButton setEnabled:NO];
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    //    [SVProgressHUD showWithStatus:@"正在提交中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    NSString *strURL = [[NSString alloc] init];
    NSString *order_payment = self.dict[@"order_payment"];
    NSString *order_payment2 = self.dict[@"order_payment2"];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
//    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) || ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"5"])) {// 开通了聚合支付
    
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) || ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"5"] && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"])))) {//
        NSString *passWord = self.boxView.textField.text;
        NSLog(@"passWord = %@",passWord);
        //密码进行MD5加密
        NSString *pwdMD5=[JWXUtils EncodingWithMD5:passWord];
      //  NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@&refundPassword=%@",[SVUserManager shareInstance].access_token,pwdMD5];
        strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@&refundPassword=%@",[SVUserManager shareInstance].access_token,pwdMD5];
    }else{
       strURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
    }
                       
                        
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.whyString forKey:@"return_cause"];
    [parameters setObject:self.order_id forKey:@"order_id"];
    [parameters setObject:self.singleView.note.text forKey:@"return_remark"];
    [parameters setObject:self.singleView.number.text forKey:@"return_num"];
    [parameters setObject:self.order_product_id forKey:@"order_product_id"];
    //    [parameters setObject:self.order_id forKey:@"order_product_id"];
    [parameters setObject:@"1" forKey:@"return_type"];
    [parameters setObject:@"301" forKey:@"sv_operation_source"];
    
    NSLog(@"parameters = %@",parameters);
    NSLog(@"strURL = %@",strURL);
    
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            [SVUserManager loadUserInfo];
            NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
            if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1 && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) || ([[SVUserManager shareInstance].dec_payment_method isEqualToString:@"5"] && (([order_payment isEqualToString:@"支付宝"] || [order_payment2 isEqualToString:@"支付宝"]) || ([order_payment isEqualToString:@"微信支付"] || [order_payment2 isEqualToString:@"微信支付"]))) ) {// 开通了聚合支付
                NSDictionary *values = dic[@"values"];
                int refundSuccess = [values[@"refundSuccess"] intValue];
                if (refundSuccess == 1) { // 订单提交上去了
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                    self.dict = dic[@"values"][@"prdata"];
                    NSString *order_number = [NSString stringWithFormat:@"%@",self.dict[@"order_number"]];
                    self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
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
                    if (refundSuccess == -1) {
                        [SVTool TextButtonAction:self.view withSing:@"密码错误"];
                    }else{
                        if (self.sellOrderBlock) {
                            self.sellOrderBlock();
                        }
                        [SVTool TextButtonActionWithSing:@"退款成功"];
                        [SVUserManager loadUserInfo];
                        if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                            [SVUserManager shareInstance].printerNumber = @"1";
                            [SVUserManager saveUserInfo];
                        }
                        
                        
                        [SVUserManager loadUserInfo];
                        for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                            if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                                [self danpinFiftyEightPrinting];
                            }
                            
                            if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                                [self danpinEightyPrinting];
                            }
                            
                            
                        }
                        
                        //用延迟来移除提示框
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //隐藏提示
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.maskOneView removeFromSuperview];
                            [self.singleView removeFromSuperview];
                            
                            //返回上一控制器
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                    
                }
            }else{
                if (self.sellOrderBlock) {
                    self.sellOrderBlock();
                }
                self.dict = dic[@"values"][@"prdata"];
                NSDictionary *myuser = dic[@"values"][@"myuser"];
                self.sv_mw_availableamount = [myuser[@"sv_mw_availableamount"] doubleValue];
                
                self.sv_mw_availablepoint = [myuser[@"sv_mw_availablepoint"] doubleValue];
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"退货成功";
                hud.label.textColor = [UIColor whiteColor];//字体颜色
                
                [SVUserManager loadUserInfo];
                if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                    [SVUserManager shareInstance].printerNumber = @"1";
                    [SVUserManager saveUserInfo];
                }
                
                
                [SVUserManager loadUserInfo];
                for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                    if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                        [self danpinFiftyEightPrinting];
                    }
                    
                    if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                        [self danpinEightyPrinting];
                    }
                    
                    
                }
                //用延迟来移除提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.maskOneView removeFromSuperview];
                    [self.singleView removeFromSuperview];
                    
                    //返回上一控制器
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
            
        }else{
            //dispatch_source_cancel(_timer);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
            [self.showView removeFromSuperview];
            [SVTool TextButtonActionWithSing:!kStringIsEmpty(errmsg)?errmsg:@"密码有误"];
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
             //   [MBProgressHUD hideHUDForView:self.view animated:YES];
                //返回上一控制器
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //        [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                        }];
    
    [self oneCancelResponseEvent];
}

#pragma mark - 单品退货的58的小票打印
- (void)danpinFiftyEightPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
      // [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
//        [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
//        return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
           // return;
        });
    }else{
        //显示时间
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
        
        JWPrinter *printer = [[JWPrinter alloc] init];
      //  [printer defaultSetting];
        
        [SVUserManager loadUserInfo];
        
        [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
        
    //    if ([self.dict[@"return_type"]doubleValue] == 1 || [self.dict[@"return_type"]doubleValue] == 2) {//退货单
            [printer appendText:@"退货单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
            [printer appendNewLine];

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
        double product_total_bak = 0.0;
        for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
            if (![dict[@"product_name"] containsString:@"(套餐)"]) {
                NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
                NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
                NSString *product_num_bakstr = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
                
                if ([[NSString stringWithFormat:@"%@",self.product_id] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"product_id"]]]) { // 判断是否是退货商品
                    CGFloat sv_p_weight = 0.0;
                    CGFloat product_num_bak = 0.0;
                  

                    sv_p_weight = [sv_p_weightstr doubleValue];
                    product_num_bak = [product_num_bakstr doubleValue];
                    totle_numcount = sv_p_weight + product_num_bak;
                    
                    NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
                    
                    [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                    [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] doubleValue]] isTitle:NO];
                    product_total_bak = [dict[@"product_total_bak"] doubleValue];

                    totle_numcount_all += totle_numcount;
                }

               
            }
            
        }
        
        
        [printer appendSeperatorLine];
        [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",product_total_bak] isTitle:NO];
        [printer appendSeperatorLine];
        
        [printer appendTitle:@"退货金额：" value:[NSString stringWithFormat:@"%.2f",product_total_bak]];
        
        
        if ([self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
           // self.paymentMethod.text = [NSString stringWithFormat:@"%@",self.dict[@"order_payment"]];
            [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        } else {
    //        self.paymentMethod.text = [NSString stringWithFormat:@"%@(%.2f),%@(%.2f)",self.dict[@"order_payment"],[self.dict[@"order_money"]doubleValue],self.dict[@"order_payment2"],[self.dict[@"order_money2"]doubleValue]];
            
    //        [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@，%@",self.dict[@"order_payment"],self.dict[@"order_payment2"]]];
        }
        

        if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
            [printer appendSeperatorLine];
            [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
            [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
            [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availableamount]];
            
           // [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
            [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availablepoint]];
            
        }
        
        
        
        [printer appendSeperatorLine];
        // [printer setLineSpace:60];
        
        if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
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
        
    //    [printer appendBarCodeWithInfo:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter maxWidth:300];
    //    [printer appendText:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
        
        [SVUserManager loadUserInfo];
        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
        if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
            [printer appendSeperatorLine];
            [printer setLineSpace:60];
            [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
           // [printer appendBarCodeWithInfo:self.queryId];
            [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
            self.queryId = nil;
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
                [SVTool TextButtonActionWithSing:@"打印成功"];
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
        }];
        
    }
   
 
}

#pragma mark - 单品退货的80的小票打印
- (void)danpinEightyPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"结算";
//        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
//        [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
//        return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVTool TextButtonActionWithSing:@"您还未连接任何设备"];
           // return;
        });
    }else{
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dict[@"order_datetime"] substringToIndex:10],[self.dict[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
        
        JWPrinter *printer = [[JWPrinter alloc] init];
        [printer defaultSetting];
        
        [SVUserManager loadUserInfo];
        
        [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
        
        [printer appendText:@"退货单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
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
        double product_total_bak = 0.0;
        for (NSDictionary *dict in [self.dict objectForKey:@"prlist"]) {
            if (![dict[@"product_name"] containsString:@"(套餐)"]) {
                NSString *sv_p_weightstr = [NSString stringWithFormat:@"%@",dict[@"sv_p_weight"]];
                NSString *product_numstr = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
                NSString *product_num_bakstr = [NSString stringWithFormat:@"%@",dict[@"product_num_bak"]];
                
                if ([[NSString stringWithFormat:@"%@",self.product_id] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"product_id"]]]) { // 判断是否是退货商品
                    CGFloat sv_p_weight = 0.0;
                    CGFloat product_num_bak = 0.0;
                  

                    sv_p_weight = [sv_p_weightstr doubleValue];
                    product_num_bak = [product_num_bakstr doubleValue];
                    totle_numcount = sv_p_weight + product_num_bak;
                    
                    NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"product_name"]];
                    
                    [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                    [printer eightAppendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.2f",[dict[@"product_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f", totle_numcount] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"product_total_bak"] doubleValue]] isTitle:NO];
                    product_total_bak = [dict[@"product_total_bak"] doubleValue];

                    totle_numcount_all += totle_numcount;
                }

               
            }
            
        }
        
        
        [printer appendSeperatorLine80];
        [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_numcount_all] priceText:[NSString stringWithFormat:@"%.2f",product_total_bak] isTitle:NO];
        [printer appendSeperatorLine80];
        
        [printer appendTitle:@"退货金额：" value:[NSString stringWithFormat:@"%.2f",product_total_bak]];

       // [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        if ([self.dict[@"order_payment2"] isEqualToString:@"待收"]) {
           // self.paymentMethod.text = [NSString stringWithFormat:@"%@",self.dict[@"order_payment"]];
            [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@",self.dict[@"order_payment"]]];
        } else {
    //        self.paymentMethod.text = [NSString stringWithFormat:@"%@(%.2f),%@(%.2f)",self.dict[@"order_payment"],[self.dict[@"order_money"]doubleValue],self.dict[@"order_payment2"],[self.dict[@"order_money2"]doubleValue]];
            
           // [printer appendTitle:@"退货方式：" value:[NSString stringWithFormat:@"%@，%@",self.dict[@"order_payment"],self.dict[@"order_payment2"]]];
        }

        if ([[NSString stringWithFormat:@"%@",self.dict[@"discounttype"]] isEqualToString:@"会员类型"]) {
            [printer appendSeperatorLine80];
            [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_name"]]];
            [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.dict[@"sv_mr_cardno"]]];
            [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availableamount]];
            
           // [printer appendTitle:@"本次积分：" value:[NSString stringWithFormat:@"%.1f",[self.dict[@"order_integral"] floatValue]]];
            [printer appendTitle:@"可用积分：" value:[NSString stringWithFormat:@"%.1f",self.sv_mw_availablepoint]];
            
        }
        
        
        
        [printer appendSeperatorLine80];
        // [printer setLineSpace:60];
        
        if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
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
        
    //    [printer appendBarCodeWithInfo:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter maxWidth:300];
    //    [printer appendText:self.dict[@"order_running_id"] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
        
        [SVUserManager loadUserInfo];
        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
        if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
            [printer appendSeperatorLine80];
            [printer setLineSpace:60];
            [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
           // [printer appendBarCodeWithInfo:self.queryId];
            [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
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
                NSLog(@"打印成功");
                [SVTool TextButtonActionWithSing:@"打印成功"];
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
        }];
    }
    
    //显示时间
   
    
}




#pragma mark - 懒加载


-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)waresID{
    if (!_waresID) {
        _waresID = [NSMutableArray array];
    }
    return _waresID;
}

-(NSMutableArray *)waresNameArr{
    if (!_waresNameArr) {
        _waresNameArr = [NSMutableArray array];
    }
    return _waresNameArr;
}

-(NSMutableArray *)moneyArr{
    if (!_moneyArr) {
        _moneyArr = [NSMutableArray array];
    }
    return _moneyArr;
}

-(NSMutableArray *)numberArr{
    if (!_numberArr) {
        _numberArr = [NSMutableArray array];
    }
    return _numberArr;
}

-(NSMutableArray *)order_stutiaArr{
    if (!_order_stutiaArr) {
        _order_stutiaArr = [NSMutableArray array];
    }
    return _order_stutiaArr;
}


-(SVSinglePieceView *)singleView{
    if (!_singleView) {
        _singleView = [[NSBundle mainBundle] loadNibNamed:@"SVSinglePieceView" owner:nil options:nil].lastObject;
        CGFloat W = 320;
        CGFloat H = 400;
        
        CGFloat x = (ScreenW - W) / 2;
        CGFloat y = (ScreenH - H) / 2;
        
        _singleView.frame = CGRectMake(x, y, W, H);
        _singleView.layer.cornerRadius = 10;
        _singleView.determineButton.layer.cornerRadius = 10;
        //
        [_singleView.exitButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_singleView.determineButton addTarget:self action:@selector(oneDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_singleView.oneButton addTarget:self action:@selector(oneButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_singleView.twoButton addTarget:self action:@selector(twoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_singleView.threeButton addTarget:self action:@selector(threeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _singleView;
}



- (SVInputBoxView *)boxView
{
    if (!_boxView) {
        _boxView = [[NSBundle mainBundle] loadNibNamed:@"SVInputBoxView" owner:nil options:nil].lastObject;
        _boxView.textField.delegate = self;
        _boxView.frame = CGRectMake(10, 10, ScreenW - 20, 170);
        _boxView.layer.cornerRadius = 10;
        _boxView.layer.masksToBounds = YES;
        _boxView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_boxView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
         [_boxView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _boxView;
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    self.boxView.textField.text = nil;
    [self.maskOneView removeFromSuperview];
    [self.singleView removeFromSuperview];
    [self.boxView removeFromSuperview];
    
}

- (void)cancleBtnClick{
    
    [self oneCancelResponseEvent];
    [self vipCancelResponseEvent];
}

-(void)oneButtonResponseEvent{
    
    self.singleView.oneButton.selected = YES;
    self.singleView.twoButton.selected = NO;
    self.singleView.threeButton.selected = NO;
    
    [self.singleView.oneButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    self.whyString = self.singleView.oneButton.titleLabel.text;
    
}

-(void)twoButtonResponseEvent{
    
    self.singleView.oneButton.selected = NO;
    self.singleView.twoButton.selected = YES;
    self.singleView.threeButton.selected = NO;
    
    [self.singleView.twoButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    self.whyString = self.singleView.twoButton.titleLabel.text;
    
}

-(void)threeButtonResponseEvent{
    
    self.singleView.oneButton.selected = NO;
    self.singleView.twoButton.selected = NO;
    self.singleView.threeButton.selected = YES;
    
    [self.singleView.threeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    self.whyString = self.singleView.threeButton.titleLabel.text;
    
    
}

- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.name.text = @"输入密码";
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(orderSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}


//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
   // [self.vipPickerView removeFromSuperview];
    [self.addCustomView removeFromSuperview];
  //  [self.setUserdItemView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
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

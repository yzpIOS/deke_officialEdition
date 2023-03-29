//
//  SVSubCardRechargeVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/26.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSubCardRechargeVC.h"
#import "SVCardRechargeInfoModel.h"
#import "SVVipSelectVC.h"
//操作员
#import "SVUnitPickerView.h"
#import "SVSecondaryCardVC.h"
#import "SVPaySuccessVC.h"
#import "ZJViewShow.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
@interface SVSubCardRechargeVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameAndCard;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UILabel *storedValue;
@property (weak, nonatomic) IBOutlet UILabel *sv_mw_sumpoint;
@property (weak, nonatomic) IBOutlet UILabel *totlePoint;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *SubCardName;
@property (weak, nonatomic) IBOutlet UILabel *subCardMoney;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *subCardView;
//自定义pickerView
@property(nonatomic,strong) SVUnitPickerView *pickerView;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
@property (nonatomic, strong) NSMutableArray *sv_employee_idArr;
@property (nonatomic, strong) NSMutableArray *sv_employee_nameArr;
//销售人员
@property (nonatomic, copy) NSString *sv_employee_id;
@property (weak, nonatomic) IBOutlet UILabel *SalePerson;
@property (weak, nonatomic) IBOutlet UIView *allPayView;
@property (weak, nonatomic) IBOutlet UIView *cashView;
@property (weak, nonatomic) IBOutlet UIView *SweepCodeView;
@property (weak, nonatomic) IBOutlet UIView *StoredValueView;
@property (weak, nonatomic) IBOutlet UIView *BankView;
@property (weak, nonatomic) IBOutlet UIImageView *cashImage;
@property (weak, nonatomic) IBOutlet UIImageView *saomaImage;
@property (weak, nonatomic) IBOutlet UIImageView *sales_storedImage;
@property (weak, nonatomic) IBOutlet UIImageView *sales_unionpayImage;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *saomaLabel;
@property (weak, nonatomic) IBOutlet UILabel *storedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unionpayLabel;
@property (nonatomic,strong) NSMutableArray *infoDataArray;
@property (nonatomic,strong) NSString *member_id;
@property (weak, nonatomic) IBOutlet UITextField *beizhu;
@property (nonatomic,strong) NSString *payment;

@property (nonatomic,strong) NSString *member_name;
@property (nonatomic,strong) NSString *memberCardNumber;
@property (nonatomic,strong) NSString *authcode;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;

@property (nonatomic,strong) NSString *is_sms;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,assign) dispatch_source_t _timerGG;
@property (nonatomic,assign) double sv_p_totaloriginalprice;
@property (nonatomic,strong) ZJViewShow *showView;

@property (nonatomic,strong) NSString * sv_p_unitprice;

@property (nonatomic,assign) BOOL isAggregatePayment;
@property (nonatomic,strong) NSDictionary * parame;
@property (nonatomic,strong) NSString * phone;
//@property (nonatomic,strong) NSString *queryId;

@end

@implementation SVSubCardRechargeVC
- (NSMutableArray *)infoDataArray
{
    if (!_infoDataArray) {
        _infoDataArray = [NSMutableArray array];
    }
    return _infoDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"次卡充次";
    self.memberName.hidden = YES;
    self.SubCardName.text = self.model.sv_p_name;
    self.subCardMoney.text = self.model.sv_p_unitprice;
    UITapGestureRecognizer *selectViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewTapClick)];
    [self.selectView addGestureRecognizer:selectViewTap];
    self.topView.layer.cornerRadius = 10;
    self.topView.layer.masksToBounds = YES;
    UITapGestureRecognizer *subCardViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subCardViewTapClick)];
    [self.subCardView addGestureRecognizer:subCardViewTap];
    [self loadData];
    self.allPayView.userInteractionEnabled = NO;
    
    // 现金
    UITapGestureRecognizer *cashViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cashViewTapClick)];
    [self.cashView addGestureRecognizer:cashViewTap];
//    self.cashImage.image = [UIImage imageNamed:@"sales_xianjin"];
//    self.salesLabel.textColor = BackgroundColor;
    
    // 扫码付
    UITapGestureRecognizer *SweepCodeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SweepCodeViewTapClick)];
    [self.SweepCodeView addGestureRecognizer:SweepCodeViewTap];
//    self.saomaImage.image = [UIImage imageNamed:@"sales_saoyisao"];
//    self.saomaLabel.textColor = BackgroundColor;
    // 储值卡
    UITapGestureRecognizer *StoredValueViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StoredValueViewTapClick)];
    [self.StoredValueView addGestureRecognizer:StoredValueViewTap];
//    self.sales_storedImage.image = [UIImage imageNamed:@"sales_chuzhika"];
//    self.storedLabel.textColor = BackgroundColor;
    // 银行卡
    UITapGestureRecognizer *BankViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BankViewTapClick)];
    [self.BankView addGestureRecognizer:BankViewTap];
//     self.sales_unionpayImage.image = [UIImage imageNamed:@"sales_yinhangka"];
//    self.unionpayLabel.textColor = BackgroundColor;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self loadInfoProduct];
    [self.openSwitch addTarget:self action:@selector(openSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    self.is_sms = @"1";
    self.isAggregatePayment = false;
  //  [self AggregatePayment];
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

- (void)openSwitchClick:(UISwitch *)swi{
    
    if (swi.isOn) {// 开着
         self.is_sms = @"1";
    }else{
         self.is_sms = @"0";
    }
}

- (void)loadInfoProduct{
    [SVUserManager loadUserInfo];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/GetSelectMemberCardSetmealInfo?key=%@&productid=%@",[SVUserManager shareInstance].access_token,self.model.product_id];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
//        NSArray *dataArray=dic[@"values"];
//        if (!kArrayIsEmpty(dataArray)) {
//            [self.infoDataArray addObjectsFromArray:dataArray];
//        }sv_p_unitprice
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic888---%@",dic);
        NSString *result=dic[@"values"][0][@"combination_new"];
        if (!kStringIsEmpty(result)) {
            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"arr = %@",arr);
            self.sv_p_totaloriginalprice = 0.0;
            for (NSDictionary *dict in arr) {
                self.sv_p_totaloriginalprice += [dict[@"sv_p_totaloriginalprice"] doubleValue];
            }
            self.infoDataArray = arr;
        }
       
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}
// 现金
- (void)cashViewTapClick{
    self.payment = @"现金";
    [self loadDataPayMent:self.payment authcode:@"" is_sms:self.is_sms];
}
// 扫码付
- (void)SweepCodeViewTapClick{
    [self Scan];
    
}

// 储值卡
- (void)StoredValueViewTapClick{
    self.payment = @"储值卡";
    if (self.storedValue.text.doubleValue < self.subCardMoney.text.doubleValue) {
        [SVTool TextButtonAction:self.view withSing:@"会员储值余额不足"];
    }else{
        [self loadDataPayMent:self.payment authcode:@"" is_sms:self.is_sms];
    }
    
}

// 银行卡
- (void)BankViewTapClick{
    self.payment = @"银行卡";
    [self loadDataPayMent:self.payment authcode:@"" is_sms:self.is_sms];
}

- (void)loadDataPayMent:(NSString *)payment authcode:(NSString *)authcode is_sms:(NSString *)is_sms{
    [SVUserManager loadUserInfo];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/SetmealProductChargeAdd?key=%@&authcode=%@&is_sms=%@",[SVUserManager shareInstance].access_token,authcode,is_sms];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    NSMutableArray *MembercardRechargeList = [NSMutableArray array];
    float sv_p_totaloriginalprice = 0.0;
     double sv_mcr_moneyTotle = 0.0;
    double money_total = 0;
    for (int i = 0; i < self.infoDataArray.count; i++){
        NSDictionary *dic = self.infoDataArray[i];
        sv_p_totaloriginalprice += [dic[@"sv_p_totaloriginalprice"] floatValue];
        NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
        detailDic[@"product_list_id"] = [NSNumber numberWithInt:0];
       NSString *product_list_id=dic[@"product_list_id"];
        int product_list_id_int = product_list_id.intValue;
        detailDic[@"product_id"] = [NSNumber numberWithInt:product_list_id_int];
        
        NSString *sv_give_count=[NSString stringWithFormat:@"%@",dic[@"sv_give_count"]];
        int sv_give_count_int = sv_give_count.intValue;
        detailDic[@"sv_give_number"] = [NSNumber numberWithInt:sv_give_count_int];
        double result;
        if (self.sv_p_totaloriginalprice == 0) {
          result = 0;
        }else{
          result = self.subCardMoney.text.doubleValue / self.sv_p_totaloriginalprice;
        }
            
           
//            if (result == 1) {
//               // NSString *sv_p_unitprice=dic[@"sv_per_price"];
//                double sv_p_unitprice_int = [dic[@"sv_per_price"] doubleValue];
//                detailDic[@"sv_mcr_money"] = [NSNumber numberWithDouble:sv_p_unitprice_int];
//
//            }else{
                
             double sv_mcr_money = result * [dic[@"sv_p_unitprice"] doubleValue];
           
                if (i < self.infoDataArray.count-1) {
                  // double last_sv_mcr_money = self.subCardMoney.text.doubleValue - sv_mcr_moneyTotle;
                 //   detailDic[@"sv_mcr_money"] = [NSNumber numberWithDouble:last_sv_mcr_money];
                    detailDic[@"sv_mcr_money"] = [NSNumber numberWithDouble:sv_mcr_money];
                    money_total += sv_mcr_money;
                }else{
                //    sv_mcr_moneyTotle += sv_mcr_money;
                    double sub = self.subCardMoney.text.doubleValue - money_total;
                    detailDic[@"sv_mcr_money"] = [NSNumber numberWithDouble:sub];
                }

        detailDic[@"sv_mcr_productname"] = dic[@"sv_p_name"];
        NSString *product_number_str = [NSString stringWithFormat:@"%@",dic[@"product_number"]];
        int product_number_int = product_number_str.intValue;
        detailDic[@"sv_purchase_number"] =[NSNumber numberWithInt:product_number_int];
        
        NSString *timeRangeType = [NSString stringWithFormat:@"%@",dic[@"sv_eff_rangetype"]];
        NSString *timeStr = [NSString stringWithFormat:@"%@",dic[@"sv_eff_range"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
         NSDate *datenow = [NSDate date];

         //----------将nsdate按formatter格式转成nsstring

         NSString *currentTimeString = [formatter stringFromDate:datenow];

         NSLog(@"currentTimeString =  %@",currentTimeString);
        NSDate *date = [formatter dateFromString:currentTimeString];
        
        NSDate *newdate = [NSDate date];
        if ([timeRangeType isEqualToString:@"3"]) { // 年
            //                    self.time.text = [NSString stringWithFormat:@"%@年",timeStr];
            newdate =[self getLaterDateFromDate:date withYear:timeStr.integerValue month:0 day:0];
        }else if ([timeRangeType isEqualToString:@"2"]){ // 月
            newdate =[self getLaterDateFromDate:date withYear:0 month:timeStr.integerValue day:0];
        }else if([timeRangeType isEqualToString:@"1"]){// 天
            newdate =[self getLaterDateFromDate:date withYear:0 month:0 day:timeStr.integerValue];
        }
      
        NSString *validity_date = [formatter stringFromDate:newdate];
       // return date;
        detailDic[@"validity_date"] = validity_date;
        [MembercardRechargeList addObject:detailDic];
    }
   // NSString *MembercardRechargeListString = [self arrayToJSONString:MembercardRechargeList];
    parame[@"MembercardRechargeList"] = MembercardRechargeList;
    if (kStringIsEmpty(self.sv_employee_id)) {
        parame[@"commissionemployes"] = @"";
    }else{
        parame[@"commissionemployes"] = self.sv_employee_id;
    }
   
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    if (self.model.sv_p_unitprice.floatValue == 0) {
        parame[@"favorable"]= [NSNumber numberWithFloat:0];
    }else{
        NSString *fav =[NSString stringWithFormat:@"%.2f",(sv_p_totaloriginalprice / self.model.sv_p_unitprice.floatValue)];
        float favorable = fav.floatValue;
      parame[@"favorable"]= [NSNumber numberWithFloat:favorable];
    }

    parame[@"favorableprice"] = self.model.sv_p_unitprice;
    parame[@"mcr_date"] = dateString;
    parame[@"mcr_payment"] = self.payment;
    parame[@"member_id"] = self.member_id;
    parame[@"menber_card"] = self.memberCardNumber;
    parame[@"menber_name"] = self.member_name;
    parame[@"originalprice"] = self.model.sv_p_unitprice;
    NSString *product_id = self.model.product_id;
    int product_id_int = product_id.intValue;
    parame[@"product_id"] = [NSNumber numberWithInt:product_id_int];
    parame[@"sv_remark"] = self.beizhu.text;
    parame[@"userid"] = [SVUserManager shareInstance].user_id;
    self.parame = parame;
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            self.dict = dict;
            NSLog(@"dict00000 == %@",dict);
            [SVUserManager loadUserInfo];
            NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
            if ([dict[@"succeed"] intValue] == 1) {
                if ((ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) && self.isAggregatePayment == TRUE && [self.payment isEqualToString:@"扫码支付"]) {
                   NSDictionary *values = dict[@"values"];
                    if (!kDictIsEmpty(values)) {
                       NSString *queryId = values[@"serialNumber"];
                        
                        self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
                        //  self.showView.delegate = self;
                        self.showView.center = self.view.center;
                        [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
//                         [self.view addSubview:self.showView];
                        
//                        //开启交互
//                        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
//
//                       // NSString *queryId = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                          [self ConvergePayB2CQueryId:queryId md:parame];
                        
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
                                [self ConvergePayQueryId:queryId _timer:_timer];
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
                    }
                }else{
                    if ([dict[@"succeed"] intValue] == 1) {
                        SVPaySuccessVC *vc = [[SVPaySuccessVC alloc] init];
                        vc.storedValue = self.storedValue.text.doubleValue - self.model.sv_p_unitprice.doubleValue;
                        vc.result = self.parame;
                        vc.member_tel = self.phone;
                        vc.sv_p_name = self.model.sv_p_name;
                        vc.money = [self.subCardMoney.text floatValue];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        //               [SVTool TextButtonAction:self.view withSing:@"充值失败"];
                        NSString *errmsg = dict[@"errmsg"];
                        if ([errmsg containsString:@"未开启"]) {
                            [SVTool TextButtonActionWithSing:errmsg];
                            //隐藏提示框
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }else{
                            [self countdown];
                        }
                        
                    }
                }
                
            }else{
                NSString *errmsg = [NSString stringWithFormat:@"%@",dict[@"errmsg"]];
                [SVTool TextButtonActionWithSing:!kStringIsEmpty(errmsg)?errmsg:@"网络开小差了"];
            }
            
            
            
//            //用延迟来移除提示框
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //隐藏提示
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            });
               
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
 
    
}


#pragma mark - 聚合支付轮训
- (void)ConvergePayQueryId:(NSString *)queryId _timer:(dispatch_source_t)_timer{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ConvergePay/%@?key=%@",queryId,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"dic-----聚合支付轮训 = %@",dic);
               NSLog(@"surl聚合支付轮训 = %@",url);
        if ([dic[@"code"] integerValue] == 1) {
            NSString *action = [NSString stringWithFormat:@"%@",dic[@"data"][@"action"]];
            NSString *msg = dic[@"msg"];
            if (action.integerValue == -1) {// 停止轮训
                dispatch_source_cancel(_timer);
                [SVTool TextButtonActionWithSing:!kStringIsEmpty(msg)?msg:@"支付有误"];
                [self.showView removeFromSuperview];
            }else if(action.integerValue == 1){// 1:Success,取到结果;
                SVPaySuccessVC *vc = [[SVPaySuccessVC alloc] init];
                NSDictionary *data = dic[@"data"];
                int paymentType = [data[@"paymentType"] intValue];
                NSString *paymentStr = [[NSString alloc] init];
                if (paymentType == 1) {
                    paymentStr = @"扫码支付";
                }else if (paymentType == 2){
                    paymentStr = @"微信支付";
                }else if (paymentType == 3){
                    paymentStr = @"支付宝";
                }else if (paymentType == 4){
                    paymentStr = @"龙支付";
                }
                vc.result = self.parame;
                vc.paymentStr = paymentStr;
                vc.member_tel = self.phone;
                vc.sv_p_name = self.model.sv_p_name;
                vc.storedValue = self.storedValue.text.doubleValue - self.model.sv_p_unitprice.doubleValue;
                vc.queryId = queryId;
                vc.money = [self.subCardMoney.text floatValue];
                [self.navigationController pushViewController:vc animated:YES];
                dispatch_source_cancel(_timer);
                [self.showView removeFromSuperview];
            }else{// 2:Continue,继续轮询;
                
            }
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - 按钮实现倒计时
-(void)countdown{
    //按钮实现倒计时
        __block int timeout=120; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    self._timerGG = _timer;
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //每秒执行
    //不用交互
                      [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    int seconds = timeout;

                   NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];

                   NSLog(@"strTime = %@",strTime);
                      //提示在支付中
                      //        [SVProgressHUD showWithStatus:@"正在提交中"];
                      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                      hud.mode = MBProgressHUDModeIndeterminate;
                      hud.label.text = @"等待用户支付";
                      hud.label.textColor = [UIColor whiteColor];//字体颜色
                      hud.bezelView.color = [UIColor blackColor];//背景颜色
                      hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
                      hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
                      //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
                      hud.yOffset = -50.0f;
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
//                    [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//                    self.getCodeBtn.userInteractionEnabled = YES;
//                    self.attainButton.backgroundColor = [UIColor purpleColor];

                });
            }else{
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    //让按钮变为不可点击的灰色
//                    self.attainButton.backgroundColor = [UIColor grayColor];
                   // self.getCodeBtn.userInteractionEnabled = NO;
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
//                    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    
                  
                    
                   NSString *values = self.dict[@"values"];
    
                    if (!kStringIsEmpty(values)) {
                        NSString *urlStr = [URLhead stringByAppendingFormat:@"/rechargeable/QueryMemberRechargeOrder?key=%@&orderNumber=%@&barCodePay=true",[SVUserManager shareInstance].access_token,values];
                        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            NSLog(@"dict6666 = %@",dict);
                            if ([dict[@"succeed"] intValue] == 1) {
                                hud.mode = MBProgressHUDModeText;
                                hud.label.text = @"成功";
                                hud.label.textColor = [UIColor whiteColor];//字体颜色
                                //隐藏提示
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 dispatch_source_cancel(_timer);
                                SVPaySuccessVC *vc = [[SVPaySuccessVC alloc] init];
                                vc.money = [self.subCardMoney.text floatValue];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示框
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      //[SVTool requestFailed];
                                      [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        }];

                        [UIView commitAnimations];
                    }

                    
                });
                timeout = timeout - 2;
            }
        });
        dispatch_resume(_timer);
}


- (NSDate *)getLaterDateFromDate:(NSDate *)date withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *comps = nil;
  comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
  NSDateComponents *adcomps = [[NSDateComponents alloc] init];
  [adcomps setYear:year];
  [adcomps setMonth:month];
  [adcomps setDay:day];
  NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
  return newdate;
}


//扫码结算调用
-(void)Scan{
    //移除
    //[self handlePan];
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        if ([SVTool deptNumInputShouldNumber:name]) {
//            weakSelf.authcode = name;
//            weakSelf.payment = @"扫码支付";
//            [weakSelf loadDataPayMent:weakSelf.payment authcode:weakSelf.authcode is_sms:weakSelf.is_sms];
//
//
//        } else {
//            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
//        }
//
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
    
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        
        if ([SVTool deptNumInputShouldNumber:resultStr]) {
            weakSelf.authcode = resultStr;
            weakSelf.payment = @"扫码支付";
            [weakSelf loadDataPayMent:weakSelf.payment authcode:weakSelf.authcode is_sms:weakSelf.is_sms];
          
         
        } else {
            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
        }
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)selectViewTapClick{
    [self operatorResponseEvent];
    
}

- (void)subCardViewTapClick{
    SVSecondaryCardVC *vc = [[SVSecondaryCardVC alloc] init];
    vc.selectCount = 1;
    vc.model_block = ^(SVCardRechargeInfoModel * _Nonnull model) {
        self.model = model;
        self.SubCardName.text = self.model.sv_p_name;
        self.subCardMoney.text = self.model.sv_p_unitprice;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//单位
-(void)operatorResponseEvent{
    
    //退出编辑状态
    //pickerView指定代理
    self.pickerView.unitPicker.delegate = self;
    self.pickerView.unitPicker.dataSource = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    
}

/**
 单位选择
 */
-(SVUnitPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[NSBundle mainBundle] loadNibNamed:@"SVUnitPickerView" owner:nil options:nil].lastObject;
        _pickerView.frame = CGRectMake(0, 0, 320, 230);
        _pickerView.center = self.view.center;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.layer.cornerRadius = 10;
        
        [_pickerView.unitCancel addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.unitDetermine addTarget:self action:@selector(unitDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerView;
}



- (IBAction)chooseMemberClick:(id)sender {
    SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
    
   // __weak typeof(self) weakSelf = self;
    
    VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
        
        self.member_id = member_id;
        self.allPayView.userInteractionEnabled = YES;
        self.member_name = name;
        self.memberCardNumber = sv_mr_cardno;
        self.phone = phone;
        self.cashImage.image = [UIImage imageNamed:@"sales_cash"];
        self.salesLabel.textColor = GlobalFontColor;
        
        self.saomaImage.image = [UIImage imageNamed:@"saoma"];
        self.saomaLabel.textColor = GlobalFontColor;
        
        self.sales_storedImage.image = [UIImage imageNamed:@"sales_stored"];
        self.storedLabel.textColor = GlobalFontColor;
        
        self.sales_unionpayImage.image = [UIImage imageNamed:@"sales_unionpay"];
        self.unionpayLabel.textColor = GlobalFontColor;
        
        //设置view的圆角
        self.icon.layer.cornerRadius = 22.5;
        //UIImageView切圆的时候就要用到这一句了
        self.icon.layer.masksToBounds = YES;
        self.nameAndCard.text = [NSString stringWithFormat:@"%@.%@",name,level];
        self.cardNumber.text = [NSString stringWithFormat:@"%@",sv_mr_cardno];
        self.storedValue.text = [NSString stringWithFormat:@"%@",storedValue];
        self.sv_mw_sumpoint.text = [NSString stringWithFormat:@"%@",sv_mw_availablepoint];// 积分
        self.totlePoint.text = [NSString stringWithFormat:@"%@",sv_mw_sumpoint];
        self.birthday.text = [sv_mr_birthday substringWithRange:NSMakeRange(5,5)];
        
        if (![SVTool isBlankString:headimg]) {
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
            self.memberName.hidden = YES;
        } else {
            if (![SVTool isBlankString:name]) {
                self.memberName.text = [name substringToIndex:1];
                self.memberName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                self.icon.image = [UIImage imageNamed:@"icon_black"];
                self.memberName.hidden = NO;
            }
            
        }
        
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sv_employee_idArr.count;
}


#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //self.unit = self.pickViewArr[row];
    
    return self.sv_employee_nameArr[row];
}

#pragma mark -  请求计算提成的人
- (void)loadData {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/GetEmployeePageList?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
//        if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employeeid] || [[SVUserManager shareInstance].sv_employeeid isEqualToString:@"<null>"]) {
//            [self.sv_employee_idArr addObject:@""];
//        } else {
//            [self.sv_employee_idArr addObject:[SVUserManager shareInstance].sv_employeeid];
//        }
//        if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
//            [self.sv_employee_nameArr addObject:@""];
//        } else {
//            [self.sv_employee_nameArr addObject:[SVUserManager shareInstance].sv_employee_name];
//        }
        if ([dict[@"succeed"]integerValue]==1) {
            if (![SVTool isEmpty:[dict objectForKey:@"values"]]) {
                for (NSDictionary *dic in [dict objectForKey:@"values"]) {
                    [self.sv_employee_idArr addObject:dic[@"sv_employee_id"]];
                    [self.sv_employee_nameArr addObject:dic[@"sv_employee_name"]];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

//点击手势的点击事件
- (void)unitDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    //获取pickerView中第0列的选中值
    NSInteger row=[self.pickerView.unitPicker selectedRowInComponent:0];
    if (!kArrayIsEmpty(self.sv_employee_nameArr)) {
        self.SalePerson.text = [self.sv_employee_nameArr objectAtIndex:row];
    }
    
    if (!kArrayIsEmpty(self.sv_employee_idArr)) {
        self.sv_employee_id = [NSString stringWithFormat:@"%@",[self.sv_employee_idArr objectAtIndex:row]];
    }
    //self.threeCellText = self.threeLabel.text;
    
}

/**
 遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unitCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

-(NSMutableArray *)sv_employee_idArr {
    if (!_sv_employee_idArr) {
        _sv_employee_idArr = [NSMutableArray array];
    }
    return _sv_employee_idArr;
}

-(NSMutableArray *)sv_employee_nameArr {
    if (!_sv_employee_nameArr) {
        _sv_employee_nameArr = [NSMutableArray array];
    }
    return _sv_employee_nameArr;
}

- (void)unitCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    
    [self.pickerView removeFromSuperview];
    
}

@end

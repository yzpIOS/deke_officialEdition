//
//  SVCollectionRefundVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/5/21.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCollectionRefundVC.h"
#import "SVForgetRefundPasswordVC.h"
#import "NSDictionary+SVMutabledictionary.h"
#import "SVCollectionFlowVC.h"
#import "ZJViewShow.h"
#import "JWXUtils.h"

//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;
@interface SVCollectionRefundVC () <CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}


@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;


@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UITextField *oneText;// 退款金额
@property (weak, nonatomic) IBOutlet UITextField *twoText; // 退款密码
@property (weak, nonatomic) IBOutlet UILabel *passWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic,assign) BOOL isAggregatePayment;
@end

@implementation SVCollectionRefundVC


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
    self.title = @"退款";
    self.determineBtn.layer.cornerRadius = 25;
    self.determineBtn.layer.masksToBounds = YES;

    self.oneView.layer.cornerRadius = 5;
    self.oneView.layer.masksToBounds = YES;

    self.oneView.layer.borderColor = BackgroundColor.CGColor;
    self.oneView.layer.borderWidth = 1;

    self.twoView.layer.cornerRadius = 5;
    self.twoView.layer.masksToBounds = YES;

    self.twoView.layer.borderColor = BackgroundColor.CGColor;
    self.twoView.layer.borderWidth = 1;

    //适配ios11偏移问题
          UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
          self.navigationItem.backBarButtonItem = backltem;
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
        double surplus= [self.dict[@"money"]doubleValue] - [self.dict[@"refundMoney"]doubleValue];
         self.oneText.text = [NSString stringWithFormat:@"%.2f",surplus];
    }else{
        double surplus= [self.dict[@"orderMoney"]doubleValue] - [self.dict[@"refundMoney"]doubleValue];
         self.oneText.text = [NSString stringWithFormat:@"%.2f",surplus];
    }
 

   // self.oneText.keyboardType = UIKeyboardTypeASCIICapable;
      self.twoText.keyboardType = UIKeyboardTypeASCIICapable;
    
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

#pragma mark - 切换明暗文
- (IBAction)DarkTextClick:(UIButton*)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
     // 切换按钮的状态
     sender.selected = !sender.selected;

     if (sender.selected) { // 按下去了就是暗文
         NSString *tempPwdStr = self.twoText.text;
                  self.twoText.text = @""; // 这句代码可以防止切换的时候光标偏移
                  self.twoText.secureTextEntry = NO;
                  self.twoText.text = tempPwdStr;
                [self.selectBtn setImage:[UIImage imageNamed:@"Plaintext"] forState:UIControlStateNormal];

     } else { // 明文
    NSString *tempPwdStr = self.twoText.text;
            self.twoText.text = @"";
            self.twoText.secureTextEntry = YES;
            self.twoText.text = tempPwdStr;
            [self.selectBtn setImage:[UIImage imageNamed:@"DarkText"] forState:UIControlStateNormal];

     }
}


#pragma mark - 忘记密码
- (IBAction)forgetClick:(id)sender {
    SVForgetRefundPasswordVC *VC = [[SVForgetRefundPasswordVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 确定退款
- (IBAction)determineClick:(id)sender {

    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
        self.determineBtn.userInteractionEnabled = NO;
              [SVUserManager loadUserInfo];
              NSString *token = [SVUserManager shareInstance].access_token;
              NSString *ShopId = [SVUserManager shareInstance].user_id;

        if (kStringIsEmpty(self.oneText.text)) {
               return [SVTool TextButtonAction:self.view withSing:@"请输入金额"];
           }

        if (kStringIsEmpty(self.twoText.text)) {
            return [SVTool TextButtonAction:self.view withSing:@"请输入密码"];
        }

        [SVTool IndeterminateButtonAction:self.view withSing:@"处理中…"];
        NSString *payment = [NSString stringWithFormat:@"%@",self.dict[@"paymentTypeString"]];
        if ([payment containsString:@"微信支付"] || [payment containsString:@"支付宝"] || [payment containsString:@"微信"]) {
             NSString *dURL=[URLhead stringByAppendingFormat:@"/api/Refund/v2?key=%@",token];
                     NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                     parame[@"shopId"] = [NSString stringWithFormat:@"%@",self.dict[@"shopId"]];
                     parame[@"payOrderId"] = [NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]];
                     NSString*queryId = self.dict[@"queryId"];
                     parame[@"queryId"] = queryId;
                      NSString *refundPassword = [NSString stringWithFormat:@"%@",self.twoText.text];
                     NSString *refundPassword_md5 = [JWXUtils EncodingWithMD5:refundPassword];
                     parame[@"refundPassword"] = refundPassword_md5;
                    double money = self.oneText.text.doubleValue;
                     parame[@"refundMoney"] = [NSNumber numberWithDouble:money];
                    [[SVSaviTool sharedSaviTool] POST:dURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                             NSLog(@"dic6666 == %@",dic);
                        if ([dic[@"code"] integerValue] == 1) {

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
                                    [self refundResultQueryId:queryId _timer:_timer];
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
                           NSString *msg= dic[@"msg"];
                            [SVTool TextButtonActionWithSing:msg?:@"请求错误"];
            //                [SVTool TextButtonAction:self.view withSing:dic[@"msg"]];
                        }
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        self.determineBtn.userInteractionEnabled = YES;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示框
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        self.determineBtn.userInteractionEnabled = YES;
                    }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.determineBtn.userInteractionEnabled = YES;
        }
    }else{
        self.determineBtn.userInteractionEnabled = NO;
              [SVUserManager loadUserInfo];
              NSString *token = [SVUserManager shareInstance].access_token;
              NSString *ShopId = [SVUserManager shareInstance].user_id;

        if (kStringIsEmpty(self.oneText.text)) {
               return [SVTool TextButtonAction:self.view withSing:@"请输入金额"];
           }

        if (kStringIsEmpty(self.twoText.text)) {
            return [SVTool TextButtonAction:self.view withSing:@"请输入密码"];
        }

        [SVTool IndeterminateButtonAction:self.view withSing:@"处理中…"];
        NSString *payment = [NSString stringWithFormat:@"%@",self.dict[@"payment"]];
        if ([payment containsString:@"微信支付"] || [payment containsString:@"支付宝"] || [payment containsString:@"微信"]) {
             NSString *dURL=[URLhead stringByAppendingFormat:@"/api/Refund/v1?key=%@",token];
                     NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                     parame[@"shopId"] = ShopId;
                     parame[@"payOrderId"] = [NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]];
                     parame[@"refundPassword"] = [NSString stringWithFormat:@"%@",self.twoText.text];
                    double money = self.oneText.text.doubleValue;
                     parame[@"refundMoney"] = [NSNumber numberWithDouble:money];
                    [[SVSaviTool sharedSaviTool] POST:dURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                             NSLog(@"dic6666 == %@",dic);
                        if ([dic[@"code"] integerValue] == 1) {
                            [SVTool TextButtonActionWithSing:@"退款成功"];
                          if ([self.delegate respondsToSelector:@selector(CollectionRefundCellClick)]) {
                                  [self.delegate CollectionRefundCellClick];
                              }
            //                [self.navigationController popViewControllerAnimated:YES];

                            // 返回到任意界面
                             for (UIViewController *temp in self.navigationController.viewControllers) {
                                 if ([temp isKindOfClass:[SVCollectionFlowVC class]]) {
                                     [self.navigationController popToViewController:temp animated:YES];
                                 }
                             }
                        }else{
                            [SVTool TextButtonActionWithSing:dic[@"msg"]];
            //                [SVTool TextButtonAction:self.view withSing:dic[@"msg"]];
                        }
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        self.determineBtn.userInteractionEnabled = YES;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //隐藏提示框
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        self.determineBtn.userInteractionEnabled = YES;
                    }];
        }else{

        }
    }
    
    
    
   


}

#pragma mark - 查询退款结果
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
             }else if(action.integerValue == 1){// 1:Success,取到结果;
                 [SVTool TextButtonActionWithSing:@"退款成功"];
                 if ([self.delegate respondsToSelector:@selector(CollectionRefundCellClick)]) {
                     [self.delegate CollectionRefundCellClick];
                 }
                 
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

                 // 返回到任意界面
                 for (UIViewController *temp in self.navigationController.viewControllers) {
                     if ([temp isKindOfClass:[SVCollectionFlowVC class]]) {
                         [self.navigationController popToViewController:temp animated:YES];
                     }
                 }
                 //隐藏提示
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
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



#pragma mark - 打印小票
- (void)fiftyEightPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
       // self.title = @"会员充值";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer setLineSpace:20];
    [SVUserManager loadUserInfo];
    [printer appendText:@"退款小票" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    [printer appendNewLine];
    [printer appendTitle:@"退款时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine];
    [printer setLineSpace:60];
    [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.dict[@"paymentTypeString"]] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendTitle:@"撤销金额:" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"money"]doubleValue]] fontSize:HLFontSizeTitleSmalle];
    
   
    
    NSString*queryId = self.dict[@"queryId"];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(queryId)) {// 开通了聚合支付
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:queryId alignment:HLTextAlignmentCenter maxWidth:300];
      //  self.queryId  = nil;
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
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        //        weakSelf.title = @"结算";
    }];
    
}

- (void)eightyPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
      //  self.title = @"会员充值";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer setLineSpace:20];
    [SVUserManager loadUserInfo];
    [printer appendText:@"充值小票" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    [printer appendNewLine];
    
    [printer appendTitle:@"退款时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    //    [printer appendTitle:@"流水号:" value:@"AA202" fontSize:HLFontSizeTitleMiddle];
    [printer appendSeperatorLine80];
    [printer setLineSpace:60];
    [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",self.dict[@"paymentTypeString"]] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendTitle:@"撤销金额:" value:[NSString stringWithFormat:@"%.2f",[self.dict[@"money"]doubleValue]] fontSize:HLFontSizeTitleSmalle];
    
   
    NSString*queryId = self.dict[@"queryId"];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(queryId)) {// 开通了聚合支付
        
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:queryId alignment:HLTextAlignmentCenter maxWidth:300];
        //self.queryId  = nil;
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
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        //        weakSelf.title = @"结算";
    }];
    
}


//-(NSMutableDictionary *)mutableDicDeepCopy{
//
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
//
//    NSArray *keys=[self allKeys];
//    for(id key in keys)
//    {
//    //循环读取复制每一个元素
//        id value=[self objectForKey:key];
//        id copyValue;
//
//        // 如果是字典，递归调用
//        if ([value isKindOfClass:[NSDictionary class]]) {
//
//            copyValue=[value mutableDicDeepCopy];
//
//            //如果是数组，数组数组深拷贝
//        }else if([value isKindOfClass:[NSArray class]])
//
//        {
//            copyValue=[value mutableArrayDeeoCopy];
//        }else{
//
//            copyValue = value;
//        }
//
//        [dict setObject:copyValue forKey:key];
//
//    }
//    return dict;
//
//}



//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"退款";
//    self.determineBtn.layer.cornerRadius = 25;
//    self.determineBtn.layer.masksToBounds = YES;
//
//    self.oneView.layer.cornerRadius = 5;
//    self.oneView.layer.masksToBounds = YES;
//
//    self.oneView.layer.borderColor = BackgroundColor.CGColor;
//    self.oneView.layer.borderWidth = 1;
//
//    self.twoView.layer.cornerRadius = 5;
//    self.twoView.layer.masksToBounds = YES;
//
//    self.twoView.layer.borderColor = BackgroundColor.CGColor;
//    self.twoView.layer.borderWidth = 1;
//
//    //适配ios11偏移问题
//          UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
//          self.navigationItem.backBarButtonItem = backltem;
//   double surplus= [self.dict[@"orderMoney"]doubleValue] - [self.dict[@"refundMoney"]doubleValue];
//    self.oneText.text = [NSString stringWithFormat:@"%.2f",surplus];
//
//   // self.oneText.keyboardType = UIKeyboardTypeASCIICapable;
//      self.twoText.keyboardType = UIKeyboardTypeASCIICapable;
//}
//
//#pragma mark - 切换明暗文
//- (IBAction)DarkTextClick:(UIButton*)sender {
//    // 前提:在xib中设置按钮的默认与选中状态的背景图
//     // 切换按钮的状态
//     sender.selected = !sender.selected;
//
//     if (sender.selected) { // 按下去了就是暗文
//         NSString *tempPwdStr = self.twoText.text;
//                  self.twoText.text = @""; // 这句代码可以防止切换的时候光标偏移
//                  self.twoText.secureTextEntry = NO;
//                  self.twoText.text = tempPwdStr;
//                [self.selectBtn setImage:[UIImage imageNamed:@"Plaintext"] forState:UIControlStateNormal];
//
//     } else { // 明文
//    NSString *tempPwdStr = self.twoText.text;
//            self.twoText.text = @"";
//            self.twoText.secureTextEntry = YES;
//            self.twoText.text = tempPwdStr;
//            [self.selectBtn setImage:[UIImage imageNamed:@"DarkText"] forState:UIControlStateNormal];
//
//     }
//}
//
//
//#pragma mark - 忘记密码
//- (IBAction)forgetClick:(id)sender {
//    SVForgetRefundPasswordVC *VC = [[SVForgetRefundPasswordVC alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
//}
//
//#pragma mark - 确定退款
//- (IBAction)determineClick:(id)sender {
//    self.determineBtn.userInteractionEnabled = NO;
//          [SVUserManager loadUserInfo];
//          NSString *token = [SVUserManager shareInstance].access_token;
//          NSString *ShopId = [SVUserManager shareInstance].user_id;
//
//    if (kStringIsEmpty(self.oneText.text)) {
//           return [SVTool TextButtonAction:self.view withSing:@"请输入金额"];
//       }
//
//    if (kStringIsEmpty(self.twoText.text)) {
//        return [SVTool TextButtonAction:self.view withSing:@"请输入密码"];
//    }
//
//    [SVTool IndeterminateButtonAction:self.view withSing:@"处理中…"];
//    NSString *payment = [NSString stringWithFormat:@"%@",self.dict[@"payment"]];
//    if ([payment containsString:@"微信支付"] || [payment containsString:@"支付宝"] || [payment containsString:@"微信"]) {
//         NSString *dURL=[URLhead stringByAppendingFormat:@"/api/Refund/v1?key=%@",token];
//                 NSMutableDictionary *parame = [NSMutableDictionary dictionary];
//                 parame[@"shopId"] = ShopId;
//                 parame[@"payOrderId"] = [NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]];
//                 parame[@"refundPassword"] = [NSString stringWithFormat:@"%@",self.twoText.text];
//                double money = self.oneText.text.doubleValue;
//                 parame[@"refundMoney"] = [NSNumber numberWithDouble:money];
//                [[SVSaviTool sharedSaviTool] POST:dURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                         NSLog(@"dic6666 == %@",dic);
//                    if ([dic[@"code"] integerValue] == 1) {
//                        [SVTool TextButtonActionWithSing:@"退款成功"];
//                      if ([self.delegate respondsToSelector:@selector(CollectionRefundCellClick)]) {
//                              [self.delegate CollectionRefundCellClick];
//                          }
//        //                [self.navigationController popViewControllerAnimated:YES];
//
//                        // 返回到任意界面
//                         for (UIViewController *temp in self.navigationController.viewControllers) {
//                             if ([temp isKindOfClass:[SVCollectionFlowVC class]]) {
//                                 [self.navigationController popToViewController:temp animated:YES];
//                             }
//                         }
//                    }else{
//                        [SVTool TextButtonActionWithSing:dic[@"msg"]];
//        //                [SVTool TextButtonAction:self.view withSing:dic[@"msg"]];
//                    }
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    self.determineBtn.userInteractionEnabled = YES;
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        //隐藏提示框
//                             [MBProgressHUD hideHUDForView:self.view animated:YES];
//                             [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//                    self.determineBtn.userInteractionEnabled = YES;
//                }];
//    }else{
//
//    }
//
//
//}

//
////-(NSMutableDictionary *)mutableDicDeepCopy{
////
////    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
////
////    NSArray *keys=[self allKeys];
////    for(id key in keys)
////    {
////    //循环读取复制每一个元素
////        id value=[self objectForKey:key];
////        id copyValue;
////
////        // 如果是字典，递归调用
////        if ([value isKindOfClass:[NSDictionary class]]) {
////
////            copyValue=[value mutableDicDeepCopy];
////
////            //如果是数组，数组数组深拷贝
////        }else if([value isKindOfClass:[NSArray class]])
////
////        {
////            copyValue=[value mutableArrayDeeoCopy];
////        }else{
////
////            copyValue = value;
////        }
////
////        [dict setObject:copyValue forKey:key];
////
////    }
////    return dict;
////
////}




@end

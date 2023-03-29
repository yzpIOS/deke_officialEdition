//
//  SVVipChargeVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/6.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVipChargeVC.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"
#import "ZJViewShow.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
//#define myDotNumbers     @"0123456789.\n"
//#define myNumbers          @"0123456789\n"

#define WeakSelf __block __weak typeof(self)weakSelf = self;
@interface SVVipChargeVC ()<UITextFieldDelegate,CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}
//余额
@property (weak, nonatomic) IBOutlet UILabel *money;

//设置代理
@property (weak, nonatomic) IBOutlet UITextField *fillingLabel;
@property (weak, nonatomic) IBOutlet UITextField *realLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteLabel;

//选择支付方式
@property (weak, nonatomic) IBOutlet UIView *pay;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (nonatomic,strong) NSString *payTypeText;
//遮盖
@property (nonatomic,strong) UIView * maskTheView;
//选择支付View
@property (nonatomic,strong) UIView * payView;

//短信按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *button;

//充值金额
@property (nonatomic,copy) NSString *filling;
//赠送金额
@property (nonatomic,copy) NSString *real;
//备注
@property (weak,nonatomic) NSString *note;
// 满赠送的钱
@property (nonatomic,assign) double FullGiftMoney;
// 满赠送的积分
@property (nonatomic,assign) double FullGiftIntegral;

//记录是否要发短信
@property (nonatomic,assign) BOOL SMS;


//@property (strong,nonatomic) CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;
//判断是否开启支付
@property (nonatomic,copy) NSString *sv_enable_alipay;//支付宝
@property (nonatomic,copy) NSString *sv_enable_wechatpay;//微信
//扫一扫码证码
@property (nonatomic,copy) NSString *authcode;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *timerTwo;

@property (weak, nonatomic) IBOutlet UILabel *DiscountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountViewHeight;

@property (nonatomic,strong) NSArray *childDetailList;

@property (weak, nonatomic) IBOutlet UILabel *discountText;

@property (nonatomic,assign) int sv_user_givingtype;//1送积分，2送现金，
@property (nonatomic,assign) double sv_detail_value;// 赠送金额
@property (nonatomic,assign) double sv_detali_proportionalue; // 比例
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic,assign) BOOL isAggregatePayment;
@property (nonatomic,strong) NSString *queryId;
@property (nonatomic,strong) NSString * paymentStr;
@end

@implementation SVVipChargeVC
- (NSArray *)childDetailList{
    if (_childDetailList == nil) {
        _childDetailList = [NSArray array];
    }
    return _childDetailList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"会员充值";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"会员充值";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //将按钮设置为圆
    self.button.layer.cornerRadius = 6;
    
    self.money.text = [NSString stringWithFormat:@"%@",self.balance];
    
    self.fillingLabel.delegate = self;
    self.realLabel.delegate = self;
    self.noteLabel.delegate = self;
    
//    [self.fillingLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.selectButton setImage:[UIImage imageNamed:@"ic_xz"] forState:UIControlStateNormal];
    self.SMS = YES;
    
    //添加支付手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payResponseEvent)];
    [self.pay addGestureRecognizer:tap];
    
    self.FullGiftMoney = 0;// 赠送的钱
    self.FullGiftIntegral  = 0; // 赠送的积分
    self.sv_user_givingtype = -1;
    self.sv_detail_value = -1;
    self.sv_detali_proportionalue = -1;
    
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
    
    //调请求
    [self requestMethodOfPayment];

   [SVUserManager loadUserInfo];
        NSArray*childDetailList = [SVUserManager shareInstance].childDetailList;
      NSLog(@"777childDetailList = %@",childDetailList);

        self.childDetailList = [childDetailList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

            NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2

            return [obj2[@"sv_detali_proportionalue"] compare:obj1[@"sv_detali_proportionalue"]]; //降序

        }];

        NSLog(@"self.childDetailList=%@",self.childDetailList);

   // }
    self.discountViewHeight.constant = 0;
    #pragma mark - 只要是收银的都不需要判断是否开通了聚合支付的密码开关  这里self.isAggregatePayment = false 是默认不开通的意思 都走聚合支付 懒得改其他代码了  以后再改
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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    titleLabel.textColor = [UIColor whiteColor];;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text=self.title;
    
    self.navigationItem.titleView = titleLabel;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = navigationBackgroundColor;

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = [UIColor whiteColor];

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
}

#pragma mark - UITextFieldDelegate
//编辑完成时调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
        {
           double money = textField.text.doubleValue;
             double amoney = 0;
            self.filling = textField.text;
            for (int i = 0; i < self.childDetailList.count; i++) {
               NSDictionary *dict = self.childDetailList[i];
                if ([dict[@"sv_detail_is_enable"] intValue] == 1) { // 开关开
                    if ([dict[@"sv_user_givingtype"] intValue] == 2) { // 1是赠送钱
                        if (self.memberlevel_id == [dict[@"sv_user_leveltype_id"] intValue]) {
                            if (money >= [dict[@"sv_detali_proportionalue"] doubleValue]) {
                                if ([dict[@"sv_p_commissiontype"] intValue] == 0) {//// 直送 sv_detail_value
                                    amoney = [dict[@"sv_detail_value"] doubleValue];
                                }else if ([dict[@"sv_p_commissiontype"] intValue] == 1){// 按%
                                    double v = [dict[@"sv_detail_value"] doubleValue];
                                    amoney = v *0.01;
                                }
                                // 满赠送的钱
                               // self.FullGiftMoney = amoney;
                                self.realLabel.text = [NSString stringWithFormat:@"%.2f",amoney];
                                self.discountViewHeight.constant = 50;
                                self.DiscountLabel.text = [NSString stringWithFormat:@"%@",dict[@"sv_remark"]];
                                self.discountText.text = @"优惠信息";
                                //sv_user_givingtype，sv_detail_value，sv_detali_proportionalue
                                self.sv_user_givingtype = [dict[@"sv_user_givingtype"] intValue];
                                self.sv_detail_value = amoney;
                                self.sv_detali_proportionalue = [dict[@"sv_detali_proportionalue"] doubleValue];
                                
                                break;
                            }else{
                                self.discountViewHeight.constant = 0;
                                self.DiscountLabel.text = @"";
                                self.discountText.text = @"";
                            }
                        }
                    }else if ([dict[@"sv_user_givingtype"] intValue] == 1){
                        // 满赠送积分
                        if (self.memberlevel_id == [dict[@"sv_user_leveltype_id"] intValue]) {
                            NSString *sv_detali_proportionalue = [NSString stringWithFormat:@"%@",dict[@"sv_detali_proportionalue"]];
                            if (money >= [sv_detali_proportionalue doubleValue]) {
                                 amoney = [dict[@"sv_detail_value"] doubleValue];
                                self.FullGiftIntegral = amoney;
                                self.discountViewHeight.constant = 50;
                                self.DiscountLabel.text = [NSString stringWithFormat:@"%@",dict[@"sv_remark"]];
                                self.discountText.text = @"优惠信息";
                                
                                self.sv_user_givingtype = [dict[@"sv_user_givingtype"] intValue];
                                self.sv_detail_value = amoney;
                                self.sv_detali_proportionalue = [dict[@"sv_detali_proportionalue"] doubleValue];
                                break;
                            }else{
                                self.discountViewHeight.constant = 0;
                                self.DiscountLabel.text = @"";
                                self.discountText.text = @"";
                            }
                        }
                    }
                }
            }
            
        }
            break;
        case 1:
            self.real = textField.text;
            break;
        case 2:
            self.note = textField.text;
            break;
            
        default:
            break;
    }
}

//-(void)textFieldDidChange :(UITextField *)theTextField {
//
//    self.realLabel.placeholder = @"0";
//
//    if (![SVTool isBlankString:self.realLabel.text]) {
//        self.realLabel.text = nil;
//    }
//
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.fillingLabel || textField == self.realLabel) {
        // 判断是否输入内容，或者用户点击的是键盘的删除按钮
        if (![string isEqualToString:@""]) {
            NSCharacterSet *cs;
            // 小数点在字符串中的位置 第一个数字从0位置开始
            
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            
            // 判断字符串中是否有小数点，并且小数点不在第一位
            
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            
            if (dotLocation == NSNotFound && range.location != 0) {
                
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                
                /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 */
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 9) {
                    
                    if ([string isEqualToString:@"."] && range.location == 9) {
                        return YES;
                    }
                    return NO;
                }
            }else {
                
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
                
            }
            // 按cs分离出数组,数组按@""分离出字符串
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            BOOL basicTest = [string isEqualToString:filtered];
            
            if (!basicTest) {
                
                return NO;
                
            }
            
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                
                return NO;
            }
            if (textField.text.length > 11) {
                
                return NO;
                
            }
        }
    }
    
    if ([textField isEqual:self.noteLabel]) {
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        NSInteger pointLength = existedLength - selectedLength + replaceLength;
        
        if (pointLength > 30) {
            return NO;
        } else {
            return YES;
        }
        
    }
    
    return YES;
}

//是否发短信按钮
- (IBAction)selectButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self.selectButton setImage:[UIImage imageNamed:@"ic_moren"] forState:UIControlStateNormal];
        
        self.SMS = NO;
        
    } else {
        
        [self.selectButton setImage:[UIImage imageNamed:@"ic_xz"] forState:UIControlStateNormal];
        
        self.SMS = YES;
        
    }
}

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
      //  [SVTool TextButtonAction:self.view withSing:message];
    } else {
        //用延迟来作提示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([SVTool isBlankString:self.printeName]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
              //  [SVTool TextButtonAction:self.view withSing:message];
            }
        });
    }
}



- (void)dayin{
    //    WeakSelf
    //自动连接上次连接的蓝牙
    [manage autoConnectLastPeripheralCompletion:^(CBPeripheral *perpheral, NSError *error) {
        //        if (!error) {
        ////            weakSelf.title = @"正在打印小票...";
        //            weakSelf.printeName = [NSString stringWithFormat:@"%@",perpheral.name];
        //            //延迟1秒，等待蓝牙连接后，再作打印
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                [SVUserManager loadUserInfo];
        //                if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
        //                    [SVUserManager shareInstance].printerNumber = @"1";
        //                    [SVUserManager saveUserInfo];
        //                }
        //
        //                for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
        //                    [weakSelf printeA];
        //                }
        //
        //            });
        //        }else{
        //
        //            [SVTool TextButtonAction:weakSelf.view withSing:error.domain];
        //        }
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
#pragma mark - 打印小票
- (void)fiftyEightPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
        self.title = @"会员充值";
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
    
    //    [printer appendTitle:@"流水号:" value:@"AA202" fontSize:HLFontSizeTitleMiddle];
    [printer appendTitle:@"会员姓名:" value:[NSString stringWithFormat:@"%@",self.nameText] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendTitle:@"会员卡号:" value:[NSString stringWithFormat:@"%@",self.careNum] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendSeperatorLine];
    [printer setLineSpace:60];
    
    [printer appendTitle:@"充值类型:" value:@"会员充值" fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"充值金额:" value:[NSString stringWithFormat:@"￥%@",self.fillingLabel.text] fontSize:HLFontSizeTitleSmalle];

    if (kStringIsEmpty(self.realLabel.text)) {
         [printer appendTitle:@"赠送金额:" value:[NSString stringWithFormat:@"￥%.2f",self.FullGiftMoney] fontSize:HLFontSizeTitleSmalle];
         [printer appendTitle:@"充值后余额:" value:[NSString stringWithFormat:@"￥%.2f",[self.money.text floatValue] + self.FullGiftMoney + [self.fillingLabel.text floatValue]] fontSize:HLFontSizeTitleSmalle];
    }else{
        [printer appendTitle:@"赠送金额:" value:[NSString stringWithFormat:@"￥%.2f",self.realLabel.text.doubleValue] fontSize:HLFontSizeTitleSmalle];
        
         [printer appendTitle:@"充值后余额:" value:[NSString stringWithFormat:@"￥%.2f",[self.money.text floatValue] + self.realLabel.text.doubleValue + [self.fillingLabel.text floatValue]] fontSize:HLFontSizeTitleSmalle];
    }

    if (!kStringIsEmpty(self.paymentStr)) {
        [printer appendTitle:@"付款方式:" value:[NSString stringWithFormat:@"%@",self.paymentStr] fontSize:HLFontSizeTitleSmalle];
    }else{
        [printer appendTitle:@"付款方式:" value:[NSString stringWithFormat:@"%@",self.payLabel.text] fontSize:HLFontSizeTitleSmalle];
    }
   
    self.paymentStr = nil;
    
    [printer appendTitle:@"充值前余额:" value:[NSString stringWithFormat:@"%@",self.money.text] fontSize:HLFontSizeTitleSmalle];
   
    
    [printer appendTitle:@"充值时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    if (self.noteLabel.text.length <= 0) {
        
    }else{
        [printer appendTitle:@"备注:" value:[NSString stringWithFormat:@"%@",self.noteLabel.text] fontSize:HLFontSizeTitleSmalle];
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
        self.title = @"会员充值";
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
    
    //    [printer appendTitle:@"流水号:" value:@"AA202" fontSize:HLFontSizeTitleMiddle];
    [printer appendTitle:@"会员姓名:" value:[NSString stringWithFormat:@"%@",self.nameText] fontSize:HLFontSizeTitleSmalle];
    //    CGFloat total = 0.0;
    
    [printer appendTitle:@"会员卡号:" value:[NSString stringWithFormat:@"%@",self.careNum] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendSeperatorLine80];
    [printer setLineSpace:60];
    
    [printer appendTitle:@"充值类型:" value:@"会员充值" fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"充值金额:" value:[NSString stringWithFormat:@"￥%@",self.fillingLabel.text] fontSize:HLFontSizeTitleSmalle];
    
//    double money =self.realLabel.text.doubleValue + self.FullGiftMoney;
//    if (money <=0) {
//
//    }else{
//        [printer appendTitle:@"赠送金额:" value:[NSString stringWithFormat:@"￥%.2f",money] fontSize:HLFontSizeTitleSmalle];
//    }
    if (kStringIsEmpty(self.realLabel.text)) {
          [printer appendTitle:@"赠送金额:" value:[NSString stringWithFormat:@"￥%.2f",self.FullGiftMoney] fontSize:HLFontSizeTitleSmalle];
          [printer appendTitle:@"充值后余额:" value:[NSString stringWithFormat:@"￥%.2f",[self.money.text floatValue] + self.FullGiftMoney + [self.fillingLabel.text floatValue]] fontSize:HLFontSizeTitleSmalle];
     }else{
         [printer appendTitle:@"赠送金额:" value:[NSString stringWithFormat:@"￥%.2f",self.realLabel.text.doubleValue] fontSize:HLFontSizeTitleSmalle];
         
          [printer appendTitle:@"充值后余额:" value:[NSString stringWithFormat:@"￥%.2f",[self.money.text floatValue] + self.realLabel.text.doubleValue + [self.fillingLabel.text floatValue]] fontSize:HLFontSizeTitleSmalle];
     }
    
    
  //  [printer appendTitle:@"付款方式:" value:[NSString stringWithFormat:@"%@",self.payLabel.text] fontSize:HLFontSizeTitleSmalle];
    
    if (!kStringIsEmpty(self.paymentStr)) {
        [printer appendTitle:@"付款方式:" value:[NSString stringWithFormat:@"%@",self.paymentStr] fontSize:HLFontSizeTitleSmalle];
    }else{
        [printer appendTitle:@"付款方式:" value:[NSString stringWithFormat:@"%@",self.payLabel.text] fontSize:HLFontSizeTitleSmalle];
    }
   
    self.paymentStr = nil;
    
    [printer appendTitle:@"充值前余额:" value:[NSString stringWithFormat:@"%@",self.money.text] fontSize:HLFontSizeTitleSmalle];
//    [printer appendTitle:@"充值后余额:" value:[NSString stringWithFormat:@"￥%.2f",[self.balance floatValue] + money + [self.fillingLabel.text floatValue]] fontSize:HLFontSizeTitleSmalle];
    
    [printer appendTitle:@"充值时间:" value:[NSString stringWithFormat:@"%@",timeString] fontSize:HLFontSizeTitleSmalle];
    if (self.noteLabel.text.length <= 0) {
        
    }else{
        [printer appendTitle:@"备注:" value:[NSString stringWithFormat:@"%@",self.noteLabel.text] fontSize:HLFontSizeTitleSmalle];
    }
    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE && !kStringIsEmpty(self.queryId)) {// 开通了聚合支付
        [printer appendSeperatorLine80];
        [printer setLineSpace:60];
        [printer appendTitle:@"支付凭证:" value:[NSString stringWithFormat:@"%@",self.queryId] fontSize:HLFontSizeTitleSmalle];
       // [printer appendBarCodeWithInfo:self.queryId];
        [printer appendBarCodeWithInfo:self.queryId alignment:HLTextAlignmentCenter maxWidth:300];
        self.queryId  = nil;
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



//确定收钱
- (IBAction)collectionButton {
    
    
    if ([SVTool isBlankString:self.fillingLabel.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入充值金额"];
        
        return;
        
    }
    
    if ([self.payTypeText isEqualToString:@"扫码支付"]) {
        if ([SVTool isBlankString:self.authcode]) {
            [SVTool TextButtonAction:self.view withSing:@"请先扫码再收款"];
            return;
        }
    
    }
    
    if (kStringIsEmpty(self.memberID)) {
        [SVTool TextButtonAction:self.view withSing:@"操作异常"];
        return;
    }

    self.button.userInteractionEnabled =NO;
//    //不用交互
   [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中..."];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;

 //sv_mrr_money：充值金额，sv_mrr_present：赠送金额
    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *strURL;
    if ([self.payTypeText isEqualToString:@"扫码支付"]) {
       
        //授权码
        [parameters setObject:self.authcode forKey:@"authcode"];
        
        if (self.sv_user_givingtype != -1) {
             [parameters setObject:[NSNumber numberWithInt:self.sv_user_givingtype] forKey:@"sv_user_givingtype"];
        }
       
        if (self.sv_detail_value != -1) {
                   [parameters setObject:[NSNumber numberWithDouble:self.sv_detail_value] forKey:@"sv_detail_value"];
        }
        
        if (self.sv_detali_proportionalue != -1) {
                    [parameters setObject:[NSNumber numberWithDouble:self.sv_detali_proportionalue] forKey:@"sv_detali_proportionalue"];
               }
        
      //  [parameters setObject:self.authcode forKey:@"authcode"];
        
        [parameters setObject:self.memberID forKey:@"member_id"];
        //0代表充值
        [parameters setObject:@"0" forKey:@"sv_mrr_type"];
        //支付方式
        [parameters setObject:self.payLabel.text forKey:@"sv_mrr_payment"];
        //充值金额
        [parameters setObject:self.fillingLabel.text forKey:@"sv_mrr_amountbefore"];
        [parameters setValue:self.fillingLabel.text forKey:@"sv_mrr_money"];
       // [parameters setObject:self.fillingLabel.text forKey:@"sv_mrr_money"];
        //赠送金额
        double money =self.realLabel.text.doubleValue + self.FullGiftMoney;
        if (money <= 0) {
            [parameters setObject:@"0" forKey:@"sv_mrr_present"];
        } else {
            [parameters setObject:[NSNumber numberWithDouble:money] forKey:@"sv_mrr_present"];
        }
        
        //过渡app端储值算法字段
        [parameters setObject:@"true" forKey:@"is_version_flat"];
        
        //充值说明
        [parameters setObject:self.noteLabel.text  forKey:@"sv_mrr_desc"];
        //是否发短信
        [parameters setObject:[NSNumber numberWithBool:self.SMS] forKey:@"issendmes"];
        
        strURL = [URLhead stringByAppendingFormat:@"/rechargeable/AppRecharge?key=%@",[SVUserManager shareInstance].access_token];
        
        
        
    } else {
        
//        //创建可变字典
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        // 1送积分，2送现金
        if (self.sv_user_givingtype != -1) {
                   [parameters setObject:[NSNumber numberWithInt:self.sv_user_givingtype] forKey:@"sv_user_givingtype"];
              }
             
        // 赠送金额，
              if (self.sv_detail_value != -1) {
                         [parameters setObject:[NSNumber numberWithDouble:self.sv_detail_value] forKey:@"sv_detail_value"];
              }
              
        // 比例(如活动配置充值100送20积分)，
              if (self.sv_detali_proportionalue != -1) {
                          [parameters setObject:[NSNumber numberWithDouble:self.sv_detali_proportionalue] forKey:@"sv_detali_proportionalue"];
                     }
        
        //会员ID
        [parameters setObject:self.memberID forKey:@"member_id"];
        //0代表充值
        [parameters setObject:@"0" forKey:@"sv_mrr_type"];
        //支付方式
        [parameters setObject:self.payLabel.text forKey:@"sv_mrr_payment"];
        //充值金额
        [parameters setObject:self.fillingLabel.text forKey:@"sv_mrr_amountbefore"];
        [parameters setValue:self.fillingLabel.text forKey:@"sv_mrr_money"];

        if (kStringIsEmpty(self.realLabel.text)) {
             [parameters setObject:[NSNumber numberWithDouble:self.FullGiftMoney] forKey:@"sv_mrr_present"];
         }else{
             [parameters setObject:[NSNumber numberWithDouble:self.realLabel.text.doubleValue] forKey:@"sv_mrr_present"];
         }
        
        //过渡app端储值算法字段
        [parameters setObject:@"true" forKey:@"is_version_flat"];
        
        //充值说明
        [parameters setObject:self.noteLabel.text  forKey:@"sv_mrr_desc"];
        //是否发短信
        [parameters setObject:[NSNumber numberWithBool:self.SMS] forKey:@"issendmes"];
        
        strURL = [URLhead stringByAppendingFormat:@"/rechargeable?key=%@",token];
        
    }
    
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [SVUserManager loadUserInfo];
        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
        if ([dic[@"succeed"] intValue] == 1) {
            if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE) {
                if ([self.payTypeText isEqualToString:@"扫码支付"]) {
                    NSDictionary *values = (NSDictionary *)dic[@"values"];
                    if (!kDictIsEmpty(values)) {
                        NSString *queryId = values[@"serialNumber"];
                        self.queryId = queryId;
                         [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                        //        //隐藏提示
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
                        self.showView.center = self.view.center;
                        //  self.showView.delegate = self;
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
                }else{
                    NSString *orderNumber = [NSString stringWithFormat:@"%@",dic[@"values"]];
                    [SVTool TextButtonAction:self.view withSing:orderNumber];
                }
                }else{
                    //        NSLog(@"dic = %@",dic);
                    NSString *orderNumber = [NSString stringWithFormat:@"%@",dic[@"values"]];
                    NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                    if ([errmsg containsString:@"等待"]) {
                        //每隔一分钟执行一次打印
                        // GCD定时器
                        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:12.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                        self.timer = timer;
                        
                        static dispatch_source_t _timer;
                        //设置时间间隔
                        NSTimeInterval period = 6.f;
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
                        // 事件回调
                        dispatch_source_set_event_handler(_timer, ^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                NSString *urlStr = [URLhead stringByAppendingFormat:@"/rechargeable/QueryMemberRechargeOrder?key=%@&orderNumber=%@&barCodePay=false",[SVUserManager shareInstance].access_token,orderNumber];
                                
                                [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                    NSLog(@"dic3333 = %@",dic);
                                    
                                    if ([dic[@"succeed"] integerValue] == 1) {
                                        if (self.vipChargeBlock) {
                                            self.vipChargeBlock();
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
                                        
                                        //隐藏提示
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        [SVTool TextButtonAction:self.view withSing:@"充值成功"];
                                        
                                        //            self.money.text = [NSString stringWithFormat:@"￥%.2f",[self.balance floatValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue];
                                        
                                        
                                        if (kStringIsEmpty(self.realLabel.text)) {
                                            self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.fillingLabel.text floatValue] + self.FullGiftMoney];
                                        }else{
                                            self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue]];
                                        }
                                        
                                        //  self.money.text
                                        // 关闭定时器 self.realLabel.text.doubleValue + self.FullGiftMoney
                                        dispatch_source_cancel(_timer);
                                        [timer invalidate];
                                        
                                        self.fillingLabel.text = nil;
                                        self.realLabel.text = nil;
                                        self.noteLabel.text = nil;
                                        self.button.userInteractionEnabled = YES;
                                    }else{
                                        //隐藏提示
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    }
                                    
                                    
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    //隐藏提示
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    //        [SVTool requestFailed];
                                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                                    //开启交互
                                    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                                }];
                            });
                        });
                        
                        // 开启定时器
                        dispatch_resume(_timer);

                           }else{
                               
                               if ([dic[@"succeed"] integerValue] == 1) {
                                   
                                   if (self.vipChargeBlock) {
                                       self.vipChargeBlock();
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
                                   
                                   //隐藏提示
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   [SVTool TextButtonAction:self.view withSing:@"充值成功"];
                                   
                                   //            self.money.text = [NSString stringWithFormat:@"￥%.2f",[self.balance floatValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue];
                                   if (kStringIsEmpty(self.realLabel.text)) {
                                       self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] +  [self.fillingLabel.text floatValue]+ self.FullGiftMoney];
                                   }else{
                                      self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue]];
                                   }
                                   
                                 //  self.balance = self.money.text;
                                   
                                   self.fillingLabel.text = nil;
                                   self.realLabel.text = nil;
                                   self.noteLabel.text = nil;
                                   self.button.userInteractionEnabled = YES;
                                   
                                   
                               } else {
                                   //隐藏提示
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   [SVTool TextButtonAction:self.view withSing:@"数据出错，充值失败"];
                               }
                           }
                }
            }else{
                //        NSLog(@"dic = %@",dic);
                NSString *orderNumber = [NSString stringWithFormat:@"%@",dic[@"values"]];
                NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                if ([errmsg containsString:@"等待"]) {
                    //每隔一分钟执行一次打印
                    // GCD定时器
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:12.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                    self.timer = timer;
                    
                    static dispatch_source_t _timer;
                    //设置时间间隔
                    NSTimeInterval period = 6.f;
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
                    // 事件回调
                    dispatch_source_set_event_handler(_timer, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSString *urlStr = [URLhead stringByAppendingFormat:@"/rechargeable/QueryMemberRechargeOrder?key=%@&orderNumber=%@&barCodePay=false",[SVUserManager shareInstance].access_token,orderNumber];
                            
                            [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                NSLog(@"dic3333 = %@",dic);
                                
                                if ([dic[@"succeed"] integerValue] == 1) {
                                    if (self.vipChargeBlock) {
                                        self.vipChargeBlock();
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
                                    
                                    //隐藏提示
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [SVTool TextButtonAction:self.view withSing:@"充值成功"];
                                    
                                    //            self.money.text = [NSString stringWithFormat:@"￥%.2f",[self.balance floatValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue];
                                    
                                    
                                    if (kStringIsEmpty(self.realLabel.text)) {
                                        self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.fillingLabel.text floatValue] + self.FullGiftMoney];
                                    }else{
                                        self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue]];
                                    }
                                    
                                    //  self.money.text
                                    // 关闭定时器 self.realLabel.text.doubleValue + self.FullGiftMoney
                                    dispatch_source_cancel(_timer);
                                    [timer invalidate];
                                    
                                    self.fillingLabel.text = nil;
                                    self.realLabel.text = nil;
                                    self.noteLabel.text = nil;
                                    self.button.userInteractionEnabled = YES;
                                }else{
                                    //隐藏提示
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                }
                                
                                
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                //隐藏提示
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                //        [SVTool requestFailed];
                                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                                //开启交互
                                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                            }];
                        });
                    });
                    
                    // 开启定时器
                    dispatch_resume(_timer);

                       }else{
                           
                           if ([dic[@"succeed"] integerValue] == 1) {
                               
                               if (self.vipChargeBlock) {
                                   self.vipChargeBlock();
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
                               
                               //隐藏提示
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               [SVTool TextButtonAction:self.view withSing:@"充值成功"];
                               
                               //            self.money.text = [NSString stringWithFormat:@"￥%.2f",[self.balance floatValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue];
                               if (kStringIsEmpty(self.realLabel.text)) {
                                   self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] +  [self.fillingLabel.text floatValue]+ self.FullGiftMoney];
                               }else{
                                  self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue]];
                               }
                               
                             //  self.balance = self.money.text;
                               
                               self.fillingLabel.text = nil;
                               self.realLabel.text = nil;
                               self.noteLabel.text = nil;
                               self.button.userInteractionEnabled = YES;
                               
                               
                           } else {
                               //隐藏提示
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               [SVTool TextButtonAction:self.view withSing:@"数据出错，充值失败"];
                           }
                       }
            }
        }else{
            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
            [SVTool TextButtonActionWithSing:kStringIsEmpty(errmsg)?@"请求有误":errmsg];
        }
                     
       
        
      
        
       // [self.navigationController popViewControllerAnimated:YES];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
        //隐藏提示
      //  [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
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
            NSString *msg = dic[@"data"][@"msg"];
            if (action.integerValue == -1) {// 停止轮训
                dispatch_source_cancel(_timer);
                [self.showView removeFromSuperview];
            [SVTool TextButtonActionWithSing:!kStringIsEmpty(msg)?msg:@"支付有误"];
            }else if(action.integerValue == 1){// 1:Success,取到结果;
//                SVPaySuccessVC *vc = [[SVPaySuccessVC alloc] init];
//                vc.money = [self.subCardMoney.text floatValue];
//                [self.navigationController pushViewController:vc animated:YES];
                NSDictionary *data = dic[@"data"];
                int paymentType = [data[@"paymentType"] intValue];
                if (paymentType == 1) {
                    self.paymentStr = @"扫码支付";
                }else if (paymentType == 2){
                    self.paymentStr = @"微信支付";
                }else if (paymentType == 3){
                    self.paymentStr = @"支付宝";
                }else if (paymentType == 4){
                    self.paymentStr = @"龙支付";
                }
                if (self.vipChargeBlock) {
                    self.vipChargeBlock();
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
                
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"充值成功"];
                
                //            self.money.text = [NSString stringWithFormat:@"￥%.2f",[self.balance floatValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue];
                if (kStringIsEmpty(self.realLabel.text)) {
                    self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] +  [self.fillingLabel.text floatValue]+ self.FullGiftMoney];
                }else{
                   self.money.text = [NSString stringWithFormat:@"%.2f",[self.money.text doubleValue] + [self.realLabel.text floatValue] + [self.fillingLabel.text floatValue]];
                }
                
              //  self.balance = self.money.text;
                
                self.fillingLabel.text = nil;
                self.realLabel.text = nil;
                self.noteLabel.text = nil;
                self.button.userInteractionEnabled = YES;
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

- (void)delayMethod{
    [self.timer invalidate];
    // 关闭定时器
    dispatch_source_cancel(_timer);
}

//选择支付响应方法
-(void)payResponseEvent{
    
    //去掉响应者
    [self.fillingLabel resignFirstResponder];
    [self.realLabel resignFirstResponder];
    [self.noteLabel resignFirstResponder];
   // [self.payView removeFromSuperview];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
    NSArray *imageNameArr = [NSArray array];
    NSArray *nameArr = [NSArray array];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE) {
        imageNameArr = @[@"icon_cash",
                         @"icon_scan",
                                  //                          @"icon_scan", //扫一扫
                                  @"icon_bankCard"];
        
        nameArr = @[@"现金",@"扫码付",@"银行卡"];
    }else{
        imageNameArr = @[@"icon_PayTreasure",
                                  @"icon_WeChat",
                                  @"icon_cash",
                                  //                          @"icon_scan", //扫一扫
                                  @"icon_bankCard"];
        
        nameArr = @[@"支付宝",@"微信",@"现金",@"银行卡"];
    }
   
    
    CGFloat spacing = 10;
    
    CGFloat bgViewWidth = (ScreenW - spacing * 4) / 3;
    
    CGFloat bgHeight = bgViewWidth;
    
    for (int i = 0; i < imageNameArr.count; i++) {
        
        CGFloat col = i % 3;
        
        CGFloat rol = i / 3;
        
        CGFloat bgViewX = col * bgViewWidth + (col + 1) * spacing;
        
        CGFloat bgViewY = rol * bgHeight + (rol + 1) * spacing;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewWidth, bgHeight)];
        
        bgView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick:)];
        
        [bgView addGestureRecognizer:tap];
        
       
        
        
        CGFloat imageViewWidth = 54;
        
        CGFloat imageViewHeight = imageViewWidth;
        
        CGFloat imageViewX = (bgViewWidth - imageViewWidth) / 2;
        
        CGFloat imageViewY = 20;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight)];
        
        imageView.image = [UIImage imageNamed:imageNameArr[i]];
        
        [bgView addSubview:imageView];
        
        
        CGFloat labelX = imageViewX;
        CGFloat labelY = imageViewY + imageViewHeight;
        CGFloat labelWidth = imageViewWidth;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, 21)];
        
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        nameLabel.font = [UIFont systemFontOfSize:13];
        
        nameLabel.text = nameArr[i];
        
        [bgView addSubview:nameLabel];
        
        [self.payView addSubview:bgView];
    }
    
    
}


#pragma mark - 请求是否打开支付通道
- (void)requestMethodOfPayment {
    
    [SVTool IndeterminateButtonActionWithSing:nil];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Payment/PaymentUseCheck?key=%@",token];
    
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //隐藏提示
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"succeed"] integerValue] == 1) {
            NSDictionary *values = dic[@"values"];
            
            if ([values[@"sv_enable_alipay"] integerValue] == 1) {
                self.sv_enable_alipay = [NSString stringWithFormat:@"%@",values[@"sv_enable_alipay"]];
            } else {
                self.sv_enable_alipay = @"0";
            }
            
            if ([values[@"sv_enable_wechatpay"] integerValue] == 1) {
                self.sv_enable_wechatpay = [NSString stringWithFormat:@"%@",values[@"sv_enable_wechatpay"]];
            } else {
                self.sv_enable_wechatpay = @"0";
            }
            
        } else {
            [SVTool TextButtonActionWithSing:@"扫码支付请求失败"];
            self.sv_enable_alipay = @"0";
            self.sv_enable_wechatpay = @"0";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [SVTool TextButtonActionWithSing:@"扫码支付请求失败"];
        self.sv_enable_alipay = @"0";
        self.sv_enable_wechatpay = @"0";
    }];
    
}

- (void)bgViewClick:(UITapGestureRecognizer *)tap {
    
    [self.maskTheView removeFromSuperview];
    [self.payView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.payView removeFromSuperview];
    
    UIView *view = (UIView *)tap.view;
    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE) {
        switch (view.tag) {
            case 0:
                self.payTypeText = @"现金";
                self.payLabel.text = @"现金";
                break;
                
                break;
            case 1:
                
            {
                //if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
                    self.payTypeText = @"扫码支付";
                    self.payLabel.text = @"扫码支付";
                    [self Scan];
//                }else{
//                    self.payLabel.text = @"微信";
//                }
            }
                break;
            case 2:
                self.payTypeText = @"银行卡";
                self.payLabel.text = @"银行卡";
                break;
                
            default:
                break;
        }
    }else{
        switch (view.tag) {
            case 0:
            {
                if ([self.sv_enable_alipay isEqualToString:@"1"]){
                    self.payTypeText = @"扫码支付";
                    self.payLabel.text = @"支付宝";
                    [self Scan];
                }else{
                    self.payLabel.text = @"支付宝";
                }
            }
                
                break;
            case 1:
                
            {
                if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
                    self.payTypeText = @"扫码支付";
                    self.payLabel.text = @"微信";
                    [self Scan];
                }else{
                    self.payLabel.text = @"微信";
                }
            }
                break;
            case 2:
                self.payTypeText = @"现金";
                self.payLabel.text = @"现金";
                break;
            case 3:
                self.payTypeText = @"银行卡";
                self.payLabel.text = @"银行卡";
                break;
                
            default:
                break;
        }
    }
   
    
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
//
//            [self collectionButton];
//        } else {
//            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
//        }
//
//    };
    
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
            
            [self collectionButton];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
        }
        };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 懒加载
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskClickGesture)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

-(UIView *)payView{
    
    if (!_payView) {
        
        CGFloat payViewHeight = 300;
        
        CGFloat payViewY = ScreenH - payViewHeight;
        
        _payView = [[UIView alloc] initWithFrame:CGRectMake(0, payViewY, ScreenW, payViewHeight)];
        
        _payView.backgroundColor = [UIColor whiteColor];
    }
    return _payView;
}

-(void)maskClickGesture{
    [self.payView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.payView removeFromSuperview];
    [self.maskTheView removeFromSuperview];
    
    
}


@end

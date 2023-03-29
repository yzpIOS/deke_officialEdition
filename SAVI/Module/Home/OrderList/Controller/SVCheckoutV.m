//
//  SVCheckoutV.m
//  SAVI
//
//  Created by houming Wang on 2018/6/7.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCheckoutV.h"
//结算界面
#import "SVShowCheckoutVC.h"
//选择会员
#import "SVVipSelectVC.h"
//操作员
#import "SVUnitPickerView.h"
//模型
#import "SVOrderDetailsModel.h"
#import "SVDetailsCell.h"
#import "SVCheckoutOneCell.h"
#import "SVCheckoutThreeCell.h"
#import "SVCheckoutFourCell.h"
#import "PaymentMethodModel.h"
#import "SVHomeViewCell.h"
#import "SVNumBlockModel.h"
#import "CustomPaymentModel.h"
#import "SVSettlementTimesCountModel.h"
#import "SVTimingCardCell.h"
#import "SVAddShopFlowLayout.h"
#import "SVDetaildraftFirmOfferCell.h"
#import "SVCouponListVC.h"
#import "SVCouponListModel.h"
#import "SVIntegralDeductionCell.h"
#import "SVIntegralInputVIew.h"
#import "SVAddCustomView.h"
#import "SVPriceRevisionCell.h"
#import "ZJViewShow.h"
#import "SVSettlementCommodityCell.h"
#import "SVPortfolioPaymentVC.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

static NSString *checkoutOneID = @"checkoutOneCell";
static NSString *checkoutTwoID = @"checkoutTwoCell";
static NSString *checkoutThreeID = @"checkoutThreeCell";
static NSString *checkoutFourID = @"checkoutFourCell";
//static NSString *checkoutFiveID = @"checkoutFiveCell";
static NSString *const collectionViewCellID = @"SVPriceRevisionCell";
static NSString *CheckoutPayID = @"checkoutPayCell";
static NSString *TimingCardCellID = @"timingCardCell";
static NSString *IntegralDeductionCellID = @"SVIntegralDeductionCell";

@interface SVCheckoutV ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *vipTitleArr;
@property (nonatomic,strong) NSMutableArray *vipTitleImg;
// 计次卡collectionView
@property (nonatomic,strong) UICollectionView *timeCollectionView;

//支付方式
@property (nonatomic,copy) NSString *payName;
// 判断是否是第一个支付方式
@property (nonatomic,copy) NSString *firstPayName;
//判断是否开启支付
@property (nonatomic,copy) NSString *sv_enable_alipay;//支付宝
@property (nonatomic,copy) NSString *sv_enable_wechatpay;//微信
//扫一扫码证码
@property (nonatomic,copy) NSString *authcode;

@property (nonatomic,strong) SVCheckoutOneCell *vipCell;
@property (nonatomic,strong) SVCheckoutFourCell *oneCell;
@property (nonatomic,strong) SVCheckoutFourCell *twoCell;
@property (nonatomic,strong) SVCheckoutFourCell *threeCell;
@property (nonatomic,strong) SVCheckoutFourCell *fourCell;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,strong) UILabel *threeLabel;
@property (nonatomic,strong) SVIntegralDeductionCell *IntegralDeductionCell;

@property (nonatomic,strong) SVIntegralInputVIew *IntegralInputVIew;

@property (nonatomic,strong) ZJViewShow *showView;

//销售人员
@property (nonatomic, copy) NSString *sv_employee_id;
@property (nonatomic, strong) NSMutableArray *sv_employee_idArr;
@property (nonatomic, strong) NSMutableArray *sv_employee_nameArr;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;

@property (nonatomic,strong) UIView *maskTheView_two;
//自定义pickerView
@property(nonatomic,strong) SVUnitPickerView *pickerView;

//收款按钮
@property (nonatomic,strong) UIButton *footerButton;
//选择会员
//@property (nonatomic,strong) UIButton *vipButton;

//件数
@property (nonatomic,assign) double sumCount;
//总价格
@property (nonatomic,assign) double sumMoney;
/**
 整单折的价格
 */
@property (nonatomic,copy) NSString *sumMoneyTwo;
//折扣
@property (nonatomic,copy) NSString *oneCellText;
//人员名
@property (nonatomic,copy) NSString *threeCellText;
//备注
@property (nonatomic,copy) NSString *noteCellText;

@property (nonatomic,strong) PaymentMethodModel *paymentMethodModel;
//cell的个数
@property (nonatomic,assign) NSInteger cellCount;
/**
 整单折扣
 */
@property (nonatomic,strong) NSString *WholeSingleDiscount;
//@property (nonatomic,assign) double WholeSingleDiscount;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *iconArr;

@property (nonatomic,strong) NSMutableArray *titleArr_member;
@property (nonatomic,strong) NSMutableArray *iconArr_member;

@property (nonatomic,strong) NSMutableArray *timesCountArr;
@property (nonatomic,assign) NSInteger indexPathRow;

@property (nonatomic,strong) NSMutableArray *goodsArr;
////遮盖view
//@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) UIButton *icon_button;
@property (nonatomic,strong) UICollectionView *PrintingCollectionView;

@property (nonatomic,strong) NSString *everyday_serialnumber;

@property (nonatomic,strong) SVCouponListModel *couponListModel;
@property (nonatomic,strong) NSString *sv_coupon_amount;
@property (nonatomic,strong) NSString *sv_coupon_discount;
@property (nonatomic,strong) NSString *sv_record_id;
@property (assign, nonatomic) NSIndexPath       *selIndex;      //单选选中的行
@property (nonatomic,assign) double totleMoney;
@property (nonatomic,strong) NSDictionary *sv_uc_dixian;
@property (nonatomic,strong) NSString *autoStr;
@property (nonatomic,strong) NSString *whether;
//@property (nonatomic,strong) NSString *integralCount;
//@property (nonatomic,strong) NSString *integralMoney;
@property (nonatomic,strong) SVAddCustomView *addCustomView;

@property (nonatomic,assign) NSInteger integralCount;
@property (nonatomic,assign) NSInteger integralMoney;
/**
 积分
 */
@property (nonatomic,strong) NSString *integral;

@property (nonatomic,assign) BOOL isSelectIntegralCircle;
//NSInteger count = self.member_Cumulative.integerValue / self.autoStr.integerValue;
//NSLog(@"count = %ld",count);
//NSInteger money = count * self.autoStr.integerValue;
/**
 小于号的
 */
//@property (nonatomic,assign) NSInteger integralMoneyTwo;
@property (nonatomic,strong) NSDictionary *sv_uc_saletozerosetDic;

@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,assign) BOOL isPriceChange;
@property (nonatomic,assign) double zeroNumber;
@property (nonatomic,strong) NSMutableArray * selectMoneyArray;
@property (nonatomic,assign) BOOL isAggregatePayment;
@end

@implementation SVCheckoutV




- (void)viewDidLoad {
    [super viewDidLoad];
    [SVUserManager loadUserInfo];
    self.zeroNumber = 0;
    self.sv_uc_dixian = [SVUserManager shareInstance].sv_uc_dixian;
    self.sv_uc_saletozerosetDic = [SVUserManager shareInstance].sv_uc_saletozerosetDic;
    [self loadData];
    self.autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
    self.whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];
    self.threeLabel = [[UILabel alloc]init];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - TopHeight - 50- BottomHeight, ScreenW, 50)];
    bottomView.backgroundColor = navigationBackgroundColor;
    [self.view addSubview:bottomView];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.centerX.mas_equalTo(bottomView.mas_centerX);
    }];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
   // titleLabel.center = bottomView.center;
    titleLabel.text = @"组合支付";
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"back2"];
    [bottomView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-10);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
    }];
    
    self.footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
     // NSString *sting1 = [NSString stringWithFormat:@"收款￥%.2f",self.sumMoney];
     // [self.footerButton setTitle:sting1 forState:UIControlStateNormal];
      [self.footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:self.footerButton];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView.mas_left);
        make.right.mas_equalTo(bottomView.mas_right);
        make.top.mas_equalTo(bottomView.mas_top);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
    }];
    
    [SVUserManager shareInstance].Tips = @"支付中。。。";
    [SVUserManager saveUserInfo];
   
      //设置背景色
    //  self.footerButton.backgroundColor = navigationBackgroundColor;
      [self.footerButton addTarget:self action:@selector(footerButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
   //   [self.footerButton setTitle:@"组合支付" forState:UIControlStateNormal];
    
   // [self.footerButton setImage:[UIImage imageNamed:@"brithdaySmall"] forState:UIControlStateNormal];

  //  rightBtn.frame = CGRectMake(0, 0, 80, 30);
  //  self.footerButton.titleLabel.adjustsFontSizeToFitWidth = YES;

 
  //  [self.footerButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
   // self.footerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
  //  [self.footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.footerButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.footerButton.titleLabel.frame.size.width - self.footerButton.frame.size.width);
      //  self.navigationItem.rightBarButtonItem = rightBarItem;
    //  [self.view addSubview:self.footerButton];
    
     self.integralCount = self.member_Cumulative.integerValue / self.autoStr.integerValue;
    self.threeCellText = @"选择销售人";
    self.navigationItem.title = @"结算";
    self.view.backgroundColor = BackgroundColor;
    self.isSelectIntegralCircle = NO;
   
    // 一进来是1
    self.WholeSingleDiscount = @"1";
    
    //加载后台支付
    [self loadpayButton];
    
    //    self.payName_2 = @"储值卡";
    //footerButton
  
    
    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVPriceRevisionCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
    self.PrintingCollectionView.delegate = self;
    self.PrintingCollectionView.dataSource = self;
    
    //  是否有会员id
    if (![SVTool isBlankString:self.member_id]) {
        [self loadUserMemberId:self.member_id];
          NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
       NSInteger count = self.member_Cumulative.integerValue / autoStr.integerValue;
        NSLog(@"count = %ld",count);
        NSInteger money = count * autoStr.integerValue;
        self.IntegralDeductionCell.textName.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%ld元",money,count];
        
    }
    
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
    
    self.totleMoney = 0.0;
    NSLog(@"resultArr = %@",self.resultArr);
    for (NSMutableDictionary *dic in self.resultArr) {
        self.totleMoney += [dic[@"sv_p_unitprice"] doubleValue] *[dic[@"product_num"] doubleValue];
    }
    
    //调请求
    [self requestMethodOfPayment];
    
    [self loadOddsMembers];
    
    [self data];
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

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    self.IntegralInputVIew.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    //获取键盘的高度
    self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];// 1
    [self.IntegralInputVIew.textFiled becomeFirstResponder];// 2
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
}

#pragma mark - 加载单号
- (void)loadOddsMembers{
    [SVUserManager loadUserInfo];
    [SVTool IndeterminateButtonActionWithSing:nil];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetDailySerialNumber?key=%@&plusone=true",[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"6565656dic = %@",dic);
        //dic[@"values"][@"sv_uc_serialnumberset"];
        // self.model = [OddMemberModel mj_objectWithKeyValues:dic[@"values"][@"sv_uc_serialnumberset"]];
        //        self.qingchuView.OddNumbersL.text = model.nomber;
        //        NSLog(@"model.nomber = %@",model.nomber);
        self.everyday_serialnumber = dic[@"values"];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [DKTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}



- (void)loadpayButton{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/HardwareStore/GetUserModuleConfigDetail?key=%@&code=CashPaymentMethodConfig",[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr6565 = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic56756765 = %@",dic);
        NSDictionary *dict = dic[@"values"];
        if (![dict isEqual:[NSNull null]]) {
            
            if ([dict[@"sv_detail_is_enable"] integerValue] == 1) {
                
                PaymentMethodModel *model = [PaymentMethodModel mj_objectWithKeyValues:dict[@"sv_detail_value"]];
                self.paymentMethodModel = model;
                NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
                NSMutableArray *titleArr = [NSMutableArray array];
                NSMutableArray *iconArr = [NSMutableArray array];
                NSMutableArray *titleArrTwo = [NSMutableArray array];
                NSMutableArray *iconArrTwo = [NSMutableArray array];
                NSMutableArray *titleArr_member = [NSMutableArray array];
                NSMutableArray *iconArr_member = [NSMutableArray array];
                NSMutableArray *titleArr_memberTwo = [NSMutableArray array];
                NSMutableArray *iconArr_memberTwo = [NSMutableArray array];
                
             
                
                if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {
                    titleArr = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"扫码支付",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArr = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                    
                    //如果后台支付配置出错时使用
                    titleArrTwo = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"扫码支付",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArrTwo = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                    // 处理选择会员的情况
                   titleArr_member = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"扫码支付",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                   iconArr_member = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                    
                     //选择会员如果后台支付配置出错时使用
                    titleArr_memberTwo = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"扫码支付",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArr_memberTwo = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                }else{
                    titleArr = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArr = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                    
                    //如果后台支付配置出错时使用
                    titleArrTwo = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArrTwo = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                    // 处理选择会员的情况
                   titleArr_member = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArr_member = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                    
                     //选择会员如果后台支付配置出错时使用
                    titleArr_memberTwo = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                    iconArr_memberTwo = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                }
                
                
                NSMutableArray *array = [NSMutableArray array]; // 这是选择会员的数组
                if ([model.p_cashpay containsString:@"true"]) {
                    [array addObject:model.p_cashpay];
                    
                }else{
                    [titleArr removeObject:@"现金"];
                    [iconArr removeObject:@"sales_cash"];
                    
                    [titleArr_member removeObject:@"现金"];
                    [iconArr_member removeObject:@"sales_cash"];
                    
                }
                
                if (![model.p_cardpay containsString:@"true"]){
                    [titleArr_member removeObject:@"储值卡"];
                    [iconArr_member removeObject:@"sales_stored"];
                    
                    [titleArr removeObject:@"储值卡"];
                    [iconArr removeObject:@"sales_stored"];
                    
                }else if ([SVTool isBlankString:self.member_id]){
                    [titleArr removeObject:@"储值卡"];
                    [iconArr removeObject:@"sales_stored"];
                }
                
                if ([model.p_scanpay containsString:@"true"]) {
                    [array addObject:model.p_scanpay];
                }else{
                    [titleArr removeObject:@"扫码支付"];
                    [iconArr removeObject:@"saoma"];
                    
                    [titleArr_member removeObject:@"扫码支付"];
                    [iconArr_member removeObject:@"saoma"];
                }
                
                if ([model.p_alipay containsString:@"true"]) {
                    [array addObject:model.p_alipay];
                }else{
                    [titleArr removeObject:@"支付宝"];
                    [iconArr removeObject:@"sales_treasure"];
                    
                    [titleArr_member removeObject:@"支付宝"];
                    [iconArr_member removeObject:@"sales_treasure"];
                }
                
                if ([model.p_weChatpay containsString:@"true"]) {
                    [array addObject:model.p_weChatpay];
                }else{
                    [titleArr removeObject:@"微信"];
                    [iconArr removeObject:@"sales_wechat"];
                    
                    [titleArr_member removeObject:@"微信"];
                    [iconArr_member removeObject:@"sales_wechat"];
                }
                
                if ([model.p_bank containsString:@"true"]) {
                    [array addObject:model.p_coupon];
                }else{
                    [titleArr removeObject:@"银行卡"];
                    [iconArr removeObject:@"sales_unionpay"];
                    
                    [titleArr_member removeObject:@"银行卡"];
                    [iconArr_member removeObject:@"sales_unionpay"];
                }
                
                if ([model.p_coupon containsString:@"true"]) {
                    [array addObject:model.p_bank];
                }else{
                    [titleArr removeObject:@"优惠券"];
                    [iconArr removeObject:@"sales_coupons"];
                    
                    [titleArr_member removeObject:@"优惠券"];
                    [iconArr_member removeObject:@"sales_coupons"];
                }

                if ([model.p_meituan55 containsString:@"true"]) {
                    [array addObject:model.p_meituan55];
                }else{
                    [titleArr removeObject:@"闪惠"];
                    [iconArr removeObject:@"sales_shanhui"];
                    
                    [titleArr_member removeObject:@"闪惠"];
                    [iconArr_member removeObject:@"sales_shanhui"];
                }
                
                if (![model.p_shezhang containsString:@"true"]){
                    [titleArr_member removeObject:@"赊账"];
                    [iconArr_member removeObject:@"sales_owe"];
                    
                    [titleArr removeObject:@"赊账"];
                    [iconArr removeObject:@"sales_owe"];
                    
                }else if ([SVTool isBlankString:self.member_id]){
                    [titleArr removeObject:@"赊账"];
                    [iconArr removeObject:@"sales_owe"];
                }
                
                
                if (model.c_custorm_payment.count >0) {
                    for (CustomPaymentModel *c_custormModel in model.c_custorm_payment) {
                        
                        if ([c_custormModel.enable containsString:@"true"]) {
                            if ([c_custormModel.icon containsString:@"xe636"]) {
                                [iconArr addObject:@"saoma"];
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"saoma"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                                
                            }else if ([c_custormModel.icon containsString:@"xe607"]){
                                [iconArr addObject:@"sales_coupons"];
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"sales_coupons"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                            }else if ([c_custormModel.icon containsString:@"xe61a"]){
                                [iconArr addObject:@"sales_regiment"];
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"sales_regiment"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                            }else if ([c_custormModel.icon containsString:@"xe65f"]){
                                [iconArr addObject:@"sales_publicpraise"];
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"sales_publicpraise"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                            }else if ([c_custormModel.icon containsString:@"xe600"]){
                                [iconArr addObject:@"sales_shanhui"];
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"sales_shanhui"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                            }else if ([c_custormModel.icon containsString:@"xe627"]){
                                [iconArr addObject:@"sales_unionpay"];
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"sales_unionpay"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                            }else{
                                [iconArr addObject:@"tv_inadvance_print_pressed"]; // 一个也不是的时候
                                [titleArr addObject:c_custormModel.name];
                                
                                [iconArr_member addObject:@"tv_inadvance_print_pressed"];
                                [titleArr_member addObject:c_custormModel.name];
                                
                            }
                        }
                        
                    }
                }
                
                // 这是没有选择会员的数组
                self.iconArr = iconArr;
                self.titleArr = titleArr;
                NSLog(@"iconArr = %@",iconArr);
                NSLog(@"titleArr = %@",titleArr);
                if (kArrayIsEmpty(iconArr)) {
                   self.vipTitleArr = titleArrTwo;
                   self.vipTitleImg = iconArrTwo;
                }else{
                    // 这是没有选择会员的数组
                    self.vipTitleArr = self.titleArr;
                    self.vipTitleImg = self.iconArr;
                }
               
                if (kArrayIsEmpty(titleArr_member)) {
                     // 这是选择会员的数组
                    self.titleArr_member = titleArr_memberTwo;
                    self.iconArr_member = iconArr_memberTwo;
                }else{
                    // 这是选择会员的数组
                    self.titleArr_member = titleArr_member;
                    self.iconArr_member = iconArr_member;
                }
               
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                //设置垂直间距
                layout.minimumLineSpacing = 1;
                //设置水平间距
                layout.minimumInteritemSpacing = 0;
                // 计算高度
                if (![SVTool isBlankString:self.member_id]) {
                    
                    int num = (int) ceil(self.titleArr_member.count / 4.0);
                    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, num * 80 + num + 1) collectionViewLayout:layout];
                    self.collectionView.backgroundColor = BackgroundColor;
                    //指定collectionview代理
                    self.collectionView.delegate = self;
                    self.collectionView.dataSource = self;
                    //注册collectionView的cell
                    [self.collectionView registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:CheckoutPayID];
                    
                    [self.collectionView reloadData];

                }else{
                    int num = (int) ceil(self.vipTitleArr.count / 4.0);
                    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, num * 80 + num + 1) collectionViewLayout:layout];
                    self.collectionView.backgroundColor = BackgroundColor;
                    //指定collectionview代理
                    self.collectionView.delegate = self;
                    self.collectionView.dataSource = self;
                    //注册collectionView的cell
                    [self.collectionView registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:CheckoutPayID];
                    [self.collectionView reloadData];
                }
                
                NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
                NSString *whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];
                if (kStringIsEmpty(self.member_Cumulative)) {
                    self.cellCount = (int)self.modelArr.count + 10;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                    self.cellCount = (int)self.modelArr.count + 10;
                }
                else{
                    self.cellCount = (int)self.modelArr.count + 11;
                }
                
               
                NSLog(@"self.cellCount = %ld",self.cellCount);
                
                self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight - 50-BottomHeight) style:UITableViewStylePlain];
                self.tableView.backgroundColor = BackgroundColor;
                //去分割线
                //   self.tableView.tableFooterView = [[UIView alloc]init];
                //改变cell分割线的颜色
                [self.tableView setSeparatorColor:cellSeparatorColor];
                /** 去除tableview 右侧滚动条 */
                self.tableView.showsVerticalScrollIndicator = NO;
                //适配ios11
                self.tableView.estimatedRowHeight = 0;
                self.tableView.estimatedSectionHeaderHeight = 0;
                self.tableView.estimatedSectionFooterHeight = 0;
                [self.view addSubview:self.tableView];
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                //注册cell
                [self.tableView registerNib:[UINib nibWithNibName:@"SVCheckoutOneCell" bundle:nil] forCellReuseIdentifier:checkoutOneID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVSettlementCommodityCell" bundle:nil] forCellReuseIdentifier:checkoutTwoID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVCheckoutThreeCell" bundle:nil] forCellReuseIdentifier:checkoutThreeID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVCheckoutFourCell" bundle:nil] forCellReuseIdentifier:checkoutFourID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVIntegralDeductionCell" bundle:nil] forCellReuseIdentifier:IntegralDeductionCellID];
                //普通cell的注册
                [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CheckoutCell"];
            }else{
                
                NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"现金",@"扫码支付",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",nil];
                NSMutableArray *iconArr = [NSMutableArray arrayWithObjects:@"sales_cash",@"saoma",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",nil];
                
                //如果后台支付配置出错时使用
                NSMutableArray *titleArrTwo = titleArr;
                NSMutableArray *iconArrTwo = iconArr;
                // 处理选择会员的情况
                NSMutableArray *titleArr_member = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"扫码支付",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                NSMutableArray *iconArr_member = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                 //如果后台支付配置出错时使用
                NSMutableArray *titleArr_memberTwo = titleArr_member;
                NSMutableArray *iconArr_memberTwo = iconArr_member;
                
                // 这是没有选择会员的数组
                self.iconArr = iconArr;
                self.titleArr = titleArr;
                NSLog(@"iconArr = %@",iconArr);
                NSLog(@"titleArr = %@",titleArr);
                if (kArrayIsEmpty(iconArr)) {
                    self.vipTitleArr = titleArrTwo;
                    self.vipTitleImg = iconArrTwo;
                }else{
                    // 这是没有选择会员的数组
                    self.vipTitleArr = self.titleArr;
                    self.vipTitleImg = self.iconArr;
                }
                
                if (kArrayIsEmpty(titleArr_member)) {
                    // 这是选择会员的数组
                    self.titleArr_member = titleArr_memberTwo;
                    self.iconArr_member = iconArr_memberTwo;
                }else{
                    // 这是选择会员的数组
                    self.titleArr_member = titleArr_member;
                    self.iconArr_member = iconArr_member;
                }
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                //设置垂直间距
                layout.minimumLineSpacing = 1;
                //设置水平间距
                layout.minimumInteritemSpacing = 0;
                // 计算高度
                if (![SVTool isBlankString:self.member_id]) {
                    
                    int num = (int) ceil(self.titleArr_member.count / 4.0);
                    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, num * 80 + num + 1) collectionViewLayout:layout];
                    self.collectionView.backgroundColor = BackgroundColor;
                    //指定collectionview代理
                    self.collectionView.delegate = self;
                    self.collectionView.dataSource = self;
                    //注册collectionView的cell
                    [self.collectionView registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:CheckoutPayID];
                    
                    [self.collectionView reloadData];
                    
//                    for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
//                        if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
//                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
//                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
//                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                            break;
//                        }else{
////                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
////                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
////                            self.firstPayName = self.payName;
//                        }
//
//                    }
                    
                    
                    
                }else{
                    int num = (int) ceil(self.vipTitleArr.count / 4.0);
                    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, num * 80 + num + 1) collectionViewLayout:layout];
                    self.collectionView.backgroundColor = BackgroundColor;
                    //指定collectionview代理
                    self.collectionView.delegate = self;
                    self.collectionView.dataSource = self;
                    //注册collectionView的cell
                    [self.collectionView registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:CheckoutPayID];
                    
                    
                    [self.collectionView reloadData];
                    
//                    self.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
//                    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                    [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                    self.firstPayName = self.payName; // 如果第一个默认选择的支付方式是支付宝或者微信的话。就进行下一步处理
                    //                    }
                    
                    
                }
                
                NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
                NSString *whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];
                if (kStringIsEmpty(self.member_Cumulative)) {
                    self.cellCount = (int)self.modelArr.count + 10;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                    self.cellCount = (int)self.modelArr.count + 10;
                }
                else{
                    self.cellCount = (int)self.modelArr.count + 11;
                }
              //  self.cellCount = (int)self.modelArr.count + 10;
                NSLog(@"self.cellCount = %ld",self.cellCount);
                
                self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight - 50-BottomHeight) style:UITableViewStylePlain];
                self.tableView.backgroundColor = BackgroundColor;
                //去分割线
                //   self.tableView.tableFooterView = [[UIView alloc]init];
                //改变cell分割线的颜色
                [self.tableView setSeparatorColor:cellSeparatorColor];
                /** 去除tableview 右侧滚动条 */
                self.tableView.showsVerticalScrollIndicator = NO;
                //适配ios11
                self.tableView.estimatedRowHeight = 0;
                self.tableView.estimatedSectionHeaderHeight = 0;
                self.tableView.estimatedSectionFooterHeight = 0;
                [self.view addSubview:self.tableView];
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                //注册cell
                [self.tableView registerNib:[UINib nibWithNibName:@"SVCheckoutOneCell" bundle:nil] forCellReuseIdentifier:checkoutOneID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVSettlementCommodityCell" bundle:nil] forCellReuseIdentifier:checkoutTwoID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVCheckoutThreeCell" bundle:nil] forCellReuseIdentifier:checkoutThreeID];
                [self.tableView registerNib:[UINib nibWithNibName:@"SVCheckoutFourCell" bundle:nil] forCellReuseIdentifier:checkoutFourID];
                //普通cell的注册
                [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CheckoutCell"];
                
                [self.tableView registerNib:[UINib nibWithNibName:@"SVIntegralDeductionCell" bundle:nil] forCellReuseIdentifier:IntegralDeductionCellID];
                
            }
        }else{
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)data {
    self.sumCount = 0;
    self.sumMoney = 0;
    [self.modelArr removeAllObjects];
    for (NSMutableDictionary *dic in self.resultArr) {
        //会员ID
        if (![SVTool isBlankString:self.member_id]) {
            [dic setObject:self.member_id forKey:@"member_id"];
            [dic setObject:self.discount forKey:@"discount"];
        } else {
            [dic setObject:@"" forKey:@"member_id"];
            [dic setObject:@"" forKey:@"discount"];
        }
      
        [self optimizeSettlementDict:dic];
    }
            
    double result = [self molingReceiveMoney:self.sumMoney];
    if (self.isOpen == YES) {
        
//        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",result] forState:UIControlStateNormal];
        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",result];
    }else{
        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",self.sumMoney] forState:UIControlStateNormal];
    }

}

#pragma mark - 优化结算代码的地方
- (void)optimizeSettlementDict:(NSDictionary *)dict{
    
    SVOrderDetailsModel *model = [SVOrderDetailsModel mj_objectWithKeyValues:dict];
    [self.modelArr addObject:model];
    NSLog(@"dict = %@",dict);
    NSLog(@"self.discount = %@",self.discount);
    NSLog(@"---%@",model.sv_p_memberprice);
    
    if ([dict[@"sv_pricing_method"] integerValue] == 1) {
        self.sumCount += 1;
    }else{
        self.sumCount += [dict[@"product_num"] doubleValue];
    }
    
    // 设置分类折
    double Discountedvalue = 0.0;
    BOOL isCategoryDisCount = false;
    for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
        if (isCategoryDisCount == false) {
        double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
        NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
        if (typeflag == 1) { // 是1的话就说明是一级分类
            if ([dict[@"productcategory_id"] isEqualToString:Discountedpar]) {
                isCategoryDisCount = true;//有分类折跳出循环
                Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                break;
            }
        }
        
        if (typeflag == 2) { // 是2的话就说明是二级分类
            NSArray *comdiscounted = dictClassifiedBook[@"comdiscounted"];
            if (!kArrayIsEmpty(comdiscounted)) {
                for (NSDictionary * dictComdiscounted in comdiscounted) {
                NSString *comdiscounted2 = [NSString stringWithFormat:@"%@",dictComdiscounted[@"comdiscounted"]];
                if ([dict[@"productsubcategory_id"] isEqualToString:comdiscounted2]) {
                    isCategoryDisCount = true;//有分类折跳出循环
                    Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                    break;
                }
                }
            }
            }
            
        }
    }
    
    //单价
        double grade = 0.0;
        if (!kStringIsEmpty(self.grade)) {
            if ([self.grade isEqualToString:@"1"]) {
                grade=[dict[@"sv_p_memberprice1"] doubleValue];
            }else if ([self.grade isEqualToString:@"2"]){
                grade=[dict[@"sv_p_memberprice2"] doubleValue];
            }else if ([self.grade isEqualToString:@"3"]){
                grade=[dict[@"sv_p_memberprice3"] doubleValue];
            }else if ([self.grade isEqualToString:@"4"]){
                grade=[dict[@"sv_p_memberprice4"] doubleValue];
            }else {
                grade=[dict[@"sv_p_memberprice5"] doubleValue];
            }
        }
    double money;
    double sv_p_minunitprice = 0.0;// 最低售价
    double sv_p_mindiscount = 0.0; // 最低折
    // 最低价
    sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
    // 最低折
    sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
    
    if ([model.isPriceChange isEqualToString:@"1"]) {// 是

        money = [dict[@"priceChange"] doubleValue];

    }else if (grade > 0){
        money = grade;
    }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dict[@"sv_p_memberprice"] doubleValue] > 0){
        
        /**
         场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
         注：有以上这三种情况下，就没有会员折一说，会员折无效
         */
        if ([SVTool isBlankString:self.member_id]) {
            money = [dict[@"sv_p_unitprice"] doubleValue];
        }else{
            if ([dict[@"sv_p_memberprice"] doubleValue] > 0) {
                money = [dict[@"sv_p_memberprice"] doubleValue];
            }else if (sv_p_mindiscount > 0 && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                 //场景二：最低折【8折】、会员折【9折】同时存在，按折比，取数字大的算【按9折算】
                if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                    money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                }else{
                    if (sv_p_mindiscount > self.discount.doubleValue && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                        money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                    }else if (self.discount.doubleValue > sv_p_mindiscount && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                        money = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                    }else{
                        money = [dict[@"sv_p_unitprice"] doubleValue];
                    }
                }
                   
            }else if (sv_p_minunitprice > 0 && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){// 场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                    money = sv_p_minunitprice;
                }else{
                    double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                    if (memberPrice > sv_p_minunitprice  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                        money = memberPrice;
                    }else if (sv_p_minunitprice > memberPrice && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                        money = sv_p_minunitprice;
                    }else{
                        money = [dict[@"sv_p_unitprice"] doubleValue];
                    }
                }

                }else{
                       money = [dict[@"sv_p_unitprice"] doubleValue];
                }
            }
    }else if (Discountedvalue > 0){
         money = [dict[@"sv_p_unitprice"] doubleValue]*Discountedvalue*0.1;
    }else if ( self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
        double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
        money = memberPrice;
    }else{
         money = [dict[@"sv_p_unitprice"] doubleValue];
    }
 
    self.sumMoney += [dict[@"product_num"] doubleValue] * money;
    
   
}

#pragma mark - 设置抹零
- (double)molingReceiveMoney:(double)money{
   double receive = money;
   NSString *whether = [NSString stringWithFormat:@"%@",self.sv_uc_saletozerosetDic[@"whether"]];
    int anto = [self.sv_uc_saletozerosetDic[@"auto"] intValue];
    NSString *result;
    if (whether.intValue == 1) {
        self.isOpen = YES;
        switch (anto) {
            case -1: // 精度保留到分，保留2位小数
            {
                result = [NSString stringWithFormat:@"%.2f",receive];
            }
                break;
                
                case 0: // 摸角
            {
                int receiveInt = (int)floorf(receive);
                result = [NSString stringWithFormat:@"%d",receiveInt];
                NSLog(@"receiveInt = %d",receiveInt);
                NSLog(@"result = %@",result);
            }
                break;
                
                case 1: // 摸分
            {
               // result = [NSString stringWithFormat:@"%.0f",receive];
//                double receiveInt = (double)floorf(receive);
//                result = [NSString stringWithFormat:@"%.1f",receiveInt];
//                NSLog(@"receiveInt = %.1f",receiveInt);
//                NSLog(@"result = %@",result);
             result=[self notRounding:receive afterPoint:1];
                 NSLog(@"result = %@",result);
                
            }
                break;
                
                case 5: // 四舍五入到角  保留一位小数  四舍五入到“角”
            {
                result = [NSString stringWithFormat:@"%.1f",receive];
            }
                break;
                
                case 6: // 四舍五入到元 取整  四舍五入到“元”
            {
               result = [NSString stringWithFormat:@"%.0f",receive];
            }
                break;
                
        }
        
       
    }else{
        self.isOpen = NO;
    }
    
    
     return [result doubleValue];
}


-(NSString*)notRounding:(double)price afterPoint:(int)position{
 NSLog(@"price = %f",price);
  NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

NSDecimalNumber *ouncesDecimal;

NSDecimalNumber *roundedOunces;

 ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];

roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

return [NSString stringWithFormat:@"%@",roundedOunces];

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
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [SVTool TextButtonActionWithSing:@"扫码支付请求失败"];
        self.sv_enable_alipay = @"0";
        self.sv_enable_wechatpay = @"0";
    }];
    
}

#pragma mark -  请求计算提成的人
- (void)loadData {
    [SVTool IndeterminateButtonActionWithSing:nil];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/GetEmployeePageList?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_cosmetology"]) {// 美业
            if ([dict[@"succeed"]integerValue]==1) {
                if (![SVTool isEmpty:[dict objectForKey:@"values"]]) {
                    for (NSDictionary *dic in [dict objectForKey:@"values"]) {
                        [self.sv_employee_idArr addObject:dic[@"sv_employee_id"]];
                        [self.sv_employee_nameArr addObject:dic[@"sv_employee_name"]];
                    }
                }
            }
        }else{
            NSString *sv_employeeid = [SVUserManager shareInstance].sv_employeeid;
            if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employeeid] || [[SVUserManager shareInstance].sv_employeeid isEqualToString:@"<null>"] || sv_employeeid.doubleValue == 0) {
                [self.sv_employee_idArr addObject:[SVUserManager shareInstance].user_id];
            } else {
                [self.sv_employee_idArr addObject:[SVUserManager shareInstance].sv_employeeid];
            }
            if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
                [self.sv_employee_nameArr addObject:@""];
            } else {
                [self.sv_employee_nameArr addObject:[SVUserManager shareInstance].sv_employee_name];
            }
            
            if ([dict[@"succeed"]integerValue]==1) {
                if (![SVTool isEmpty:[dict objectForKey:@"values"]]) {
                    for (NSDictionary *dic in [dict objectForKey:@"values"]) {
                        [self.sv_employee_idArr addObject:dic[@"sv_employee_id"]];
                        [self.sv_employee_nameArr addObject:dic[@"sv_employee_name"]];
                    }
                }
            }
            
            if (!kArrayIsEmpty(self.sv_employee_nameArr) && !kArrayIsEmpty(self.sv_employee_idArr)) {
                self.threeLabel.text = self.sv_employee_nameArr[0];
                self.threeCellText = self.threeLabel.text;
                self.sv_employee_id = [NSString stringWithFormat:@"%@",self.sv_employee_idArr[0]];
                
            }
            
        }

        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}


#pragma mark -  收款响应方法 这里变成了组合支付的按钮
-(void)footerButtonResponseEvent{
     [SVUserManager loadUserInfo];

    SVPortfolioPaymentVC *VC = [[SVPortfolioPaymentVC alloc] init];
    VC.stored = self.stored;
    if (kStringIsEmpty(self.member_id)) {
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *vipTitleImg = [NSMutableArray array];
        for (NSString *title in self.vipTitleArr) {
            [titleArray addObject:title];
        }
       // titleArray = (NSMutableArray *)[self.vipTitleArr copy];
       // vipTitleImg = (NSMutableArray *)[self.vipTitleImg copy];
        for (NSString *image in self.vipTitleImg) {
            [vipTitleImg addObject:image];
        }
        
        for (NSString *title in titleArray) {
            if ([title isEqualToString:@"优惠券"]) {
                [titleArray removeObject:title];
                break;
            }
        }
        
        for (NSString *image in vipTitleImg) {
            if ([image isEqualToString:@"sales_coupons"]) {
                [vipTitleImg removeObject:image];
                break;
            }
        }
        
        VC.titleArray = titleArray;
        VC.imageArray = vipTitleImg;

    }else{
//        VC.titleArray = self.titleArr_member;
//        VC.imageArray = self.iconArr_member;
        
        NSMutableArray *titleArr_member = [NSMutableArray array];
        NSMutableArray *iconArr_member = [NSMutableArray array];
//        titleArr_member = (NSMutableArray *)[self.titleArr_member copy];
//        iconArr_member = (NSMutableArray *)[self.iconArr_member copy];
        
        for (NSString *title in self.titleArr_member) {
            [titleArr_member addObject:title];
        }
       // titleArray = (NSMutableArray *)[self.vipTitleArr copy];
       // vipTitleImg = (NSMutableArray *)[self.vipTitleImg copy];
        for (NSString *image in self.iconArr_member) {
            [iconArr_member addObject:image];
        }
        
        for (NSString *title in titleArr_member) {
            if ([title isEqualToString:@"优惠券"]) {
                [titleArr_member removeObject:title];
                break;
            }
        }
        
        for (NSString *image in iconArr_member) {
            if ([image isEqualToString:@"sales_coupons"]) {
                [iconArr_member removeObject:image];
                break;
            }
        }
        
        VC.titleArray = titleArr_member;
        VC.imageArray = iconArr_member;
    }
    VC.money = self.sumMoneyTwo;
    __weak typeof(self) weakSelf = self;
    VC.selectMoneyArrayBlock = ^(NSMutableArray * _Nonnull array) {
        weakSelf.selectMoneyArray = array;
        NSLog(@"weakSelf.selectMoneyArray = %@",weakSelf.selectMoneyArray);
        NSDictionary *dict1 = array[0];
        NSDictionary *dict2 = array[1];
        NSString *title1 = dict1[@"title"];
        NSString *title2 = dict2[@"title"];
        if ([title1 isEqualToString:@"支付宝"]) {
            if ([self.sv_enable_alipay isEqualToString:@"1"]){
                self.payName = @"扫码支付";
                [self Scan];
            }else{
                self.payName = @"支付宝记账";
                [self footerNext];
            }
            
        }else if ([title1 isEqualToString:@"微信"]){
            if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
                self.payName = @"扫码支付";
                [self Scan];
            }else{
                self.payName = @"微信记账";
                [self footerNext];
            }
        }else if ([title2 isEqualToString:@"支付宝"]){
            if ([self.sv_enable_alipay isEqualToString:@"1"]){
                self.payName = @"扫码支付";
                [self Scan];
            }else{
                self.payName = @"支付宝记账";
                [self footerNext];
            }
        }else if ([title2 isEqualToString:@"微信"]){
            if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
                self.payName = @"扫码支付";
                [self Scan];
            }else{
                self.payName = @"微信记账";
                [self footerNext];
            }
        }else if ([title1 isEqualToString:@"扫码支付"]){
            self.payName = @"扫码支付";
            [self Scan];
        }else if ([title2 isEqualToString:@"扫码支付"]){
            self.payName = @"扫码支付";
            [self Scan];
        }else{
            self.payName = nil;
            [self footerNext];
        }
            
      
      
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)footerNext{
    if ([SVTool isEmpty:self.resultArr]) {
         //  [SVTool TextButtonAction:self.view withSing:@"商品数据异常..."];
        [SVTool TextButtonActionWithSing:@"商品数据异常..."];
           return;
       }

       if ([self.twoCell.threeTextField.text doubleValue] > [self.stored doubleValue] && [self.payName isEqualToString:@"储值卡"]) {
//           [SVTool TextButtonAction:self withSing:@"储值余额不足"];
           [SVTool TextButtonActionWithSing:@"储值余额不足"];
           return;
       }
       
       if ([self.payName isEqualToString:@"储值卡"]) {
           if ( [[SVUserManager shareInstance].sv_uc_isenablepwd isEqualToString:@"0"] || kStringIsEmpty(self.sv_mr_pwd)) {
               [self loadPayMethod];
           }else{
               
               [self.addCustomView.textView becomeFirstResponder];// 2
               
               [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
               [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
           }
       }else{
            [self loadPayMethod];
       }
}

- (void)loadPayMethod{
        //让按钮不可点
        [self.footerButton setEnabled:NO];
        //不用交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
        //提示在支付中
        [SVTool IndeterminateButtonAction:self.view withSing:@"等待用户支付中..."];
       
      //  [SVTool IndeterminateButtonActionWithSing:@"等待用户支付中..."];
    
        NSString *sURL = [URLhead stringByAppendingFormat:@"/System/GetUserPage?key=%@",[SVUserManager shareInstance].access_token];
        //取单号
        [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    
            if ([dic[@"succeed"] integerValue] == 1) {
                NSDictionary *values = dic[@"values"];
                NSDictionary *sv_uc_serialnumberset = [SVTool dictionaryWithJsonString:values[@"sv_uc_serialnumberset"]];
    
                //取到订单后，提交订单
                [self receiptRequest:sv_uc_serialnumberset[@"nomber"]];
            } else {
                [SVTool TextButtonAction:self.view withSing:@"订单提交失败"];
                //让按钮可点
                [self.footerButton setEnabled:YES];
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:self.view withSing:@"网络出错,结算失败"];
            //让按钮可点
            [self.footerButton setEnabled:YES];
            //开启交互
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
        }];
}




#pragma mark - 我要搜索的
-(void)receiptRequest:(NSString *)order_running_id {
    
    NSMutableDictionary *md=[NSMutableDictionary dictionary];
    //判断是否是挂单结算   string  order_running_id
    if (![SVTool isBlankString:self.order_running_id]) {
        [md setObject:self.order_running_id forKey:@"order_running_id"];
        [md setObject:self.sv_without_list_id forKey:@"sv_without_list_id"];
    } else {
        [md setObject:order_running_id forKey:@"order_running_id"];
    }
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    [md setObject:dateString forKey:@"order_datetime"];
    
    //会员卡号（实给会员ID)    string    user_cardno    没有会员，就给死@“0”
    if ([SVTool isBlankString:self.member_id]) {
        //会员卡号（实给会员ID)
        [md setObject:@"0" forKey:@"user_cardno"];
        
    } else {
        //会员卡号（实给会员ID)
        [md setObject:self.member_id forKey:@"user_cardno"];
        
        //会员折扣
        if ([self.discount isEqualToString:@"0"]) {
            [md setObject:@"1" forKey:@"sv_member_discount"];
        } else {
            NSString *vipfold = [NSString stringWithFormat:@"%.2f",[self.discount doubleValue]*0.1];
            [md setObject:vipfold forKey:@"sv_member_discount"];
        }
        
    }
    
    if (!kStringIsEmpty(self.name)) {
        [md setObject:self.name forKey:@"sv_mr_name"];
    }
    
    if (!kStringIsEmpty(self.sv_mr_cardno)) {
        [md setObject:self.sv_mr_cardno forKey:@"sv_mr_cardno"];
    }
    
    // 流水单号
    if (!kStringIsEmpty(self.everyday_serialnumber)) {
        [md setObject:self.everyday_serialnumber forKey:@"everyday_serialnumber"];
    }
    double DiscountCalculation;
    //整单折扣
    if ([SVTool isBlankString:self.oneCellText]) {
        [md setObject:@"1" forKey:@"order_discount"];
        [md setObject:@"1" forKey:@"order_discount_new"];
        // 折扣计算
        DiscountCalculation = 1;
    } else {
        
        [md setObject:@"1" forKey:@"order_discount"];
        [md setObject:self.oneCellText forKey:@"order_discount_new"];
        // 折扣计算
       DiscountCalculation = self.oneCellText.doubleValue *0.1;
    }
    /**
     积分抵扣
     */
    if (!kStringIsEmpty(self.integral)) {
        [md setObject:self.integral forKey:@"integral"];
    }
   
    [md setObject:self.sumMoneyTwo forKey:@"order_receivable"];
  
    // self.sumMoney
    NSString *deserved_cash = [NSString stringWithFormat:@"%.2f",self.totleMoney - self.sumMoneyTwo.doubleValue];
    
    [md setObject:[NSString stringWithFormat:@"%.2f",self.totleMoney] forKey:@"sv_order_total_money"];
    
    [md setObject:deserved_cash forKey:@"deserved_cash"];
    // 开启积分模式
    [md setObject:@"true" forKey:@"MembershipGradeGroupingIsON"];
    
    //应收原金额    decimal    order_receivabley
    [md setObject:[NSString stringWithFormat:@"%.2f",self.sumMoney] forKey:@"order_receivabley"];
    
   
    if (self.selectMoneyArray.count == 2) {
        NSDictionary *dict1 = self.selectMoneyArray[0];
        NSDictionary *dict2 = self.selectMoneyArray[1];
        NSString *order_payment = dict1[@"title"];
        NSString *order_payment2 = dict2[@"title"];
        NSString *order_money = dict1[@"money"];
        NSString *order_money2 = dict2[@"money"];
            //收款方式    string    order_payment
            [md setObject:order_payment forKey:@"order_payment"];
            //付款金额    decimal    order_money
            [md setObject:order_money forKey:@"order_money"];
            
            //收款方式    string    order_payment2    给死@“待收”
            [md setObject:order_payment2 forKey:@"order_payment2"];
            
            //付款金额    decimal    order_money2    给死@“0”
            [md setObject:order_money2 forKey:@"order_money2"];
//        double subtractionNum = self.sumMoneyTwo.doubleValue - order_money.doubleValue;
//        double subtractionNum2 = self.sumMoneyTwo.doubleValue - order_money2.doubleValue;
//        if ([order_payment isEqualToString:@"现金"] && subtractionNum < 0) {
//            double num = self.sumMoneyTwo.doubleValue - order_money2.doubleValue;
//            double order_change = order_money.doubleValue - num;
//            //找零金额    decimal    order_change    给死@“0”
//            [md setObject:[NSString stringWithFormat:@"%.2f",order_change] forKey:@"order_change"];
//        }else if ([order_payment2 isEqualToString:@"现金"] && subtractionNum2 < 0){
//            double num = self.sumMoneyTwo.doubleValue - order_money.doubleValue;
//            double order_change = order_money2.doubleValue- num;
//            //找零金额    decimal    order_change    给死@“0”
//            [md setObject:[NSString stringWithFormat:@"%.2f",order_change] forKey:@"order_change"];
//        }else{
            //找零金额    decimal    order_change    给死@“0”
          
      //  }
       
    }else{
        //收款方式    string    order_payment
        [md setObject:self.payName forKey:@"order_payment"];
        //付款金额    decimal    order_money
        [md setObject:self.sumMoneyTwo forKey:@"order_money"];
        
        //收款方式    string    order_payment2    给死@“待收”
        [md setObject:@"待收" forKey:@"order_payment2"];
        
        //付款金额    decimal    order_money2    给死@“0”
        [md setObject:@"0" forKey:@"order_money2"];
        
       
    }
    //找零金额    decimal    order_change    给死@“0”
    [md setObject:@"0" forKey:@"order_change"];
    // 店铺id来用处理跨店会员积分显示问题
    NSString *user_id = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].user_id];
    if (!kStringIsEmpty(user_id)) {
        [md setObject:user_id forKey:@"user_id"];
    }
    // 抹零金额
    
     [md setObject:[NSNumber numberWithDouble:self.zeroNumber] forKey:@"free_change"];
    
    if (!kStringIsEmpty(self.sv_coupon_amount)) {
        [md setObject:self.sv_coupon_amount forKey:@"sv_coupon_amount"];
        [md setObject:@"0" forKey:@"sv_coupon_discount"];
    }
    
    if (!kStringIsEmpty(self.sv_coupon_discount)) {
        [md setObject:self.sv_coupon_discount forKey:@"sv_coupon_discount"];
        [md setObject:@"0" forKey:@"sv_coupon_amount"];
    }
    
    if (!kStringIsEmpty(self.sv_record_id)) {
        [md setObject:self.sv_record_id forKey:@"sv_record_id"];
    }
    
    //提成员工ID
    if ([SVTool isBlankString:self.sv_employee_id]) {
        [md setObject:@"0" forKey:@"sv_commissionemployes"];
    } else {
        [md setObject:self.sv_employee_id forKey:@"sv_commissionemployes"];
    }
    
    [md setObject:@"102" forKey:@"sv_source_type"];
    //备注
    if ([SVTool isBlankString:self.noteCellText]) {
        [md setObject:@"" forKey:@"sv_remarks"];
    } else {
        [md setObject:self.noteCellText forKey:@"sv_remarks"];
    }
     
    [md setObject:@"102" forKey:@"sv_source_type"];
    // 成交价
    double TransactionPrice = 0.00;
    if (![SVTool isEmpty:self.resultArr]) {
        NSLog(@"self.resultArr55555 = %@",self.resultArr);
        NSMutableArray *guaDanArr = [NSMutableArray array];
        NSMutableArray *sv_preferential_dataArray = [NSMutableArray array];
        #pragma mark - plist列表
        for (NSInteger i = 0; i < self.resultArr.count; i++) {
            NSMutableDictionary *dict = self.resultArr[i];
            NSMutableDictionary *guaDanDic = [NSMutableDictionary dictionary];
            NSLog(@"dict = %@",dict);
            double sv_p_mindiscount_one = [dict[@"sv_p_mindiscount"]doubleValue];
            double sv_p_minunitprice_one = [dict[@"sv_p_minunitprice"]doubleValue];
            if (sv_p_mindiscount_one > 0) {
                if (sv_p_mindiscount_one > DiscountCalculation *10) {
              
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //让按钮可点
                    [self.footerButton setEnabled:YES];
                    //开启交互
                    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                    return [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"不能低于%.2f折",sv_p_mindiscount_one]];
                }
            }else if (sv_p_minunitprice_one > 0){
                double money = [dict[@"sv_p_unitprice"] doubleValue];
                //double totleMoney;
               // 用折扣计算
                double totleMoney = money * DiscountCalculation;
               
               
                if (sv_p_minunitprice_one > totleMoney) {
                   // return [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"不能低于%.2f元",sv_p_minunitprice_one]];
                    
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //[SVTool requestFailed];
                   // [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    //让按钮可点
                    [self.footerButton setEnabled:YES];
                    //开启交互
                    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                    return [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"不能低于%.2f元",sv_p_minunitprice_one]];
                }
                
            }else{
                
            }
            //商品ID
            [guaDanDic setObject:dict[@"product_id"] forKey:@"product_id"];
            //商品名
            [guaDanDic setObject:dict[@"sv_p_name"] forKey:@"product_name"];
            //数量
            [guaDanDic setObject:dict[@"product_num"] forKey:@"product_num"];
            // 商品款号
            if (!kStringIsEmpty(dict[@"sv_p_barcode"])) {
                [guaDanDic setObject:dict[@"sv_p_barcode"] forKey:@"sv_p_barcode"];
            }else{
                [guaDanDic setObject:@"" forKey:@"sv_p_barcode"];
            }
            
            [guaDanDic setObject:dict[@"sv_pricing_method"] forKey:@"sv_pricing_method"];
            
            //套餐类型
            [guaDanDic setObject:dict[@"sv_product_type"] forKey:@"sv_product_type"];
            
          
            
            
            // 特殊字段 用来打印优惠
           NSString *sv_p_unitprice =[NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]];
            if (kStringIsEmpty(sv_p_unitprice)) {
                [guaDanDic setObject:@"0" forKey:@"PrintingDiscount"];
            }else{
                [guaDanDic setObject:sv_p_unitprice forKey:@"PrintingDiscount"];
            }
           
            // 设置分类折
            double Discountedvalue = 0.0;
            BOOL isCategoryDisCount = false;
            for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
                if (isCategoryDisCount == false) {
                double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
                NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
                if (typeflag == 1) { // 是1的话就说明是一级分类
                    if ([dict[@"productcategory_id"] isEqualToString:Discountedpar]) {
                        isCategoryDisCount = true;//有分类折跳出循环
                        Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                        break;
                    }
                }
                
                if (typeflag == 2) { // 是2的话就说明是二级分类
                    NSArray *comdiscounted = dictClassifiedBook[@"comdiscounted"];
                    if (!kArrayIsEmpty(comdiscounted)) {
                        for (NSDictionary * dictComdiscounted in comdiscounted) {
                        NSString *comdiscounted2 = [NSString stringWithFormat:@"%@",dictComdiscounted[@"comdiscounted"]];
                        if ([dict[@"productsubcategory_id"] isEqualToString:comdiscounted2]) {
                            isCategoryDisCount = true;//有分类折跳出循环
                            Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                            break;
                        }
                        }
                    }
                    }
                    
                }
            }
            SVOrderDetailsModel *model = [SVOrderDetailsModel mj_objectWithKeyValues:dict];
            //单价
                double grade = 0.0;
                if (!kStringIsEmpty(self.grade)) {
                    if ([self.grade isEqualToString:@"1"]) {
                        grade=[dict[@"sv_p_memberprice1"] doubleValue];
                    }else if ([self.grade isEqualToString:@"2"]){
                        grade=[dict[@"sv_p_memberprice2"] doubleValue];
                    }else if ([self.grade isEqualToString:@"3"]){
                        grade=[dict[@"sv_p_memberprice3"] doubleValue];
                    }else if ([self.grade isEqualToString:@"4"]){
                        grade=[dict[@"sv_p_memberprice4"] doubleValue];
                    }else {
                        grade=[dict[@"sv_p_memberprice5"] doubleValue];
                    }
                }
            double money;
            double sv_p_minunitprice = 0.0;// 最低售价
            double sv_p_mindiscount = 0.0; // 最低折
            // 最低价
            sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
            // 最低折
            sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
            
            if ([model.isPriceChange isEqualToString:@"1"]) {// 是
                    money = [dict[@"priceChange"] doubleValue];
            }else if (grade > 0){
                money = grade;
            }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dict[@"sv_p_memberprice"] doubleValue] > 0){
                NSLog(@"sv_p_minunitprice = %f",sv_p_minunitprice);
                NSLog(@"sv_p_mindiscount = %f",sv_p_mindiscount);
                NSLog(@"sv_p_memberprice = %f",[dict[@"sv_p_memberprice"] doubleValue]);
                /**
                 场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
                 注：有以上这三种情况下，就没有会员折一说，会员折无效
                 */
                if ([SVTool isBlankString:self.member_id]) {
                    money = [dict[@"sv_p_unitprice"] doubleValue];
                }else{
                    if ([dict[@"sv_p_memberprice"] doubleValue] > 0) {
                        money = [dict[@"sv_p_memberprice"] doubleValue];
                    }else if (sv_p_mindiscount > 0){
                         //场景二：最低折【8折】、会员折【9折】同时存在，按折比，取数字大的算【按9折算】
                        if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                            money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                        }else{
                            if (sv_p_mindiscount > self.discount.doubleValue  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                                money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                            }else if (self.discount.doubleValue > sv_p_mindiscount && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                                money = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                            }else{
                                money = [dict[@"sv_p_unitprice"] doubleValue];
                            }
                        }
                           
                    }else if (sv_p_minunitprice > 0){// 场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                        if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                            money = sv_p_minunitprice;
                        }else{
                            double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                            if (memberPrice > sv_p_minunitprice  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                                money = memberPrice;
                            }else if (sv_p_minunitprice > memberPrice && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                                money = sv_p_minunitprice;
                            }else{
                                money = [dict[@"sv_p_unitprice"] doubleValue];
                            }
                        }

                        }else{
                               money = [dict[@"sv_p_unitprice"] doubleValue];
                        }
                    }

            }else if (Discountedvalue > 0){
                 money = [dict[@"sv_p_unitprice"] doubleValue]*Discountedvalue*0.1;
            }else if (self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                money = memberPrice;
            }
            else{
                money = [dict[@"sv_p_unitprice"] doubleValue];
            }
  
            // 商品规格
            if (!kStringIsEmpty(dict[@"sv_p_specs"])) {
                [guaDanDic setObject:dict[@"sv_p_specs"] forKey:@"sv_p_specs"];
            }else{
                [guaDanDic setObject:@"" forKey:@"sv_p_specs"];
            }
            
            
            
            
            // 进货价
            [guaDanDic setObject:dict[@"sv_purchaseprice"] forKey:@"sv_purchaseprice"];
            //会员折后每件商品的总价
            if ([SVTool isBlankString:self.oneCellText]) {

                    self.oneCellText = @"1";
                    DiscountCalculation = 1;
                
            }
            
            NSString *total;
            if ([dict[@"isTimeCare"] isEqualToString:@"1"]) {// 是使用次卡的商品
                total = @"0";
                //会员折后的单价
                [guaDanDic setObject:@"0" forKey:@"product_unitprice"];
                [guaDanDic setObject:@"true" forKey:@"type"];//扣次类型
                guaDanDic[@"sv_serialnumber"] = dict[@"sv_serialnumber"];
                guaDanDic[@"userecord_id"] = dict[@"userecord_id"];
                
                NSString *sv_preferential_data = [self dicountproduct_unitprice:0 sv_p_unitprice:[dict[@"sv_p_unitprice"] doubleValue] dict:dict grade:grade Discountedvalue:Discountedvalue];
                if (!kStringIsEmpty(sv_preferential_data)) {
                   // NSString *sv_preferential_data = [self dictionaryToJson:memberdicM];
                    [guaDanDic setValue:sv_preferential_data forKey:@"sv_preferential_data"];
                   
                }
            }else{
                
                total = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"] doubleValue] * money *DiscountCalculation] ;
                //会员折后的单价
                [guaDanDic setObject:[NSString stringWithFormat:@"%.2f",money] forKey:@"product_unitprice"];
                // 计算折扣
                NSString *sv_preferential_data = [self dicountproduct_unitprice:money* DiscountCalculation sv_p_unitprice:[dict[@"sv_p_unitprice"] doubleValue] dict:dict grade:grade Discountedvalue:Discountedvalue];
                if (!kStringIsEmpty(sv_preferential_data)) {
                   // NSString *sv_preferential_data = [self dictionaryToJson:memberdicM];
                    [guaDanDic setValue:sv_preferential_data forKey:@"sv_preferential_data"];
                   
                }
            }
            
            TransactionPrice += [total doubleValue];
            
            if (i == self.resultArr.count - 1) {
                NSMutableDictionary * dic_last = self.resultArr[i];
                if ([dic_last[@"isTimeCare"] isEqualToString:@"1"]) { // 是用了次卡的商品
                    [guaDanDic setObject:@"0" forKey:@"product_total"];
                    
                    [guaDanDic setObject:@"0" forKey:@"product_unitprice"];
                    // 新折扣字段
                  //  if (self.oneCellText.doubleValue != 1) {
                        
                    [guaDanDic setObject:[NSString stringWithFormat:@"%f",DiscountCalculation]  forKey:@"product_discount_new"];

                    
                    guaDanDic[@"sv_serialnumber"] = dict[@"sv_serialnumber"];
                    // }
                    
                    // if (!kStringIsEmpty(selectModel.userecord_id)) {
                    guaDanDic[@"userecord_id"] = dict[@"userecord_id"];
                    
                    NSString *sv_preferential_data = [self dicountproduct_unitprice:0 sv_p_unitprice:[dict[@"sv_p_unitprice"] doubleValue] dict:dict grade:grade Discountedvalue:Discountedvalue];
                    if (!kStringIsEmpty(sv_preferential_data)) {
                       // NSString *sv_preferential_data = [self dictionaryToJson:memberdicM];
                        [guaDanDic setValue:sv_preferential_data forKey:@"sv_preferential_data"];
                       
                    }
                    
                    [guaDanArr addObject:guaDanDic];
                }else{
                    // 最后一个商品的差价
                    double chajia = 0.00;
                    chajia = [self.sumMoneyTwo doubleValue] - TransactionPrice;
                    double lastShopPrice = 0.00;
                    lastShopPrice = ([total doubleValue] + chajia) / [dict[@"product_num"] doubleValue];
                    
                    [guaDanDic setObject:[NSString stringWithFormat:@"%.2f",([total doubleValue] + chajia)] forKey:@"product_total"];
                    
                    [guaDanDic setObject:[NSString stringWithFormat:@"%.2f",lastShopPrice] forKey:@"product_unitprice"];
                    // 新折扣字段
                   // [guaDanDic setObject:[NSString stringWithFormat:@"%f",[self.oneCellText doubleValue]]  forKey:@"product_discount_new"];
                    // 新折扣字段
                  //  if (self.oneCellText.doubleValue != 1) {
                        [guaDanDic setObject:[NSString stringWithFormat:@"%f",DiscountCalculation]  forKey:@"product_discount_new"];
                    
                    NSString *sv_preferential_data = [self dicountproduct_unitprice:lastShopPrice sv_p_unitprice:[dict[@"sv_p_unitprice"] doubleValue] dict:dict grade:grade Discountedvalue:Discountedvalue];
                    if (!kStringIsEmpty(sv_preferential_data)) {
                       // NSString *sv_preferential_data = [self dictionaryToJson:memberdicM];
                        [guaDanDic setValue:sv_preferential_data forKey:@"sv_preferential_data"];
                       
                    }

                    [guaDanArr addObject:guaDanDic];
                }
                
            }else{
                [guaDanDic setObject:total forKey:@"product_total"];
                //得出成交价
                NSString *transactionPriceTwo = [NSString stringWithFormat:@"%.2f",[total doubleValue]/ [dict[@"product_num"] doubleValue]];
                
                [guaDanDic setObject:transactionPriceTwo forKey:@"product_unitprice"];
                // 新折扣字段
               // [guaDanDic setObject:[NSString stringWithFormat:@"%f",[self.oneCellText doubleValue]]  forKey:@"product_discount_new"];
                // 新折扣字段
            //    if (self.oneCellText.doubleValue != 1) {
                    [guaDanDic setObject:[NSString stringWithFormat:@"%f",DiscountCalculation]  forKey:@"product_discount_new"];
                
//                NSString *product_unitprice = transactionPriceTwo;
//                 NSString *product_num = dict[@"product_num"];
//                 double m =sv_p_unitprice.doubleValue*product_num.doubleValue - product_unitprice.doubleValue*product_num.doubleValue;
//                 NSMutableDictionary *memberdicM = [NSMutableDictionary dictionary];
                
                NSString *sv_preferential_data = [self dicountproduct_unitprice:transactionPriceTwo.doubleValue sv_p_unitprice:[dict[@"sv_p_unitprice"] doubleValue] dict:dict grade:grade Discountedvalue:Discountedvalue];
                if (!kStringIsEmpty(sv_preferential_data)) {
                   // NSString *sv_preferential_data = [self dictionaryToJson:memberdicM];
                    
                    [guaDanDic setValue:sv_preferential_data forKey:@"sv_preferential_data"];
                   
                }
       
                [guaDanArr addObject:guaDanDic];
            }
        
         
          //  [guaDanArr addObject:guaDanDic];
            
        }
        
        
        
        [md setObject:guaDanArr forKey:@"prlist"];
    }
    
    NSString *sURL;
    [SVUserManager loadUserInfo];
    if ([self.payName isEqualToString:@"扫码支付"]) {
        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
        if ((!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) && self.isAggregatePayment == TRUE) {
            //授权码
            [md setObject:self.authcode forKey:@"authcode"];
            sURL = [URLhead stringByAppendingFormat:@"/api/ConvergePay/Settle/WithoutList?key=%@",[SVUserManager shareInstance].access_token];
        }else{
            //授权码
            [md setObject:self.authcode forKey:@"authcode"];
            sURL = [URLhead stringByAppendingFormat:@"/api/PayMent?key=%@",[SVUserManager shareInstance].access_token];
        }
        
        
    } else {
        
        sURL = [URLhead stringByAppendingFormat:@"/order?r=1&key=%@",[SVUserManager shareInstance].access_token];
        
    }
    
    NSLog(@"md = %@",md);
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic----- = %@",dic);
        NSLog(@"surl = %@",sURL);
        // sv_remarks
       
            if ([dic[@"succeed"] integerValue] == 1) {
                       
                       //回调清除选择商品数据
                       if (self.selectWaresBlock) {
                           self.selectWaresBlock();
                       }
                       
                       // 发出通知
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:@"1"];
                       
                       //隐藏提示
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
                       SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];
                       VC.money = self.sumMoneyTwo;
                       VC.interface = self.interface;
                       VC.vipName = self.name;
                NSString *order_payment = md[@"order_payment"];
                NSString *order_payment2 = md[@"order_payment2"];
//                NSString *order_money = md[@"order_money"];
//                NSString *order_money2 = md[@"order_money2"];
//                if (self.selectMoneyArray.count == 2) {
//                    VC.pay = [NSString stringWithFormat:@"%@,%@",order_payment,order_payment2];
//                }else{
//                    VC.pay = self.payName;
//                }
                
                if (self.selectMoneyArray.count == 2) {
                    
                  //  if ([order_payment isEqualToString:@"扫码支付"]) {
                        md[@"order_payment"] = [NSString stringWithFormat:@"%@",dic[@"values"][@"order_payment"]];
                        
                        md[@"order_payment2"] = [NSString stringWithFormat:@"%@",dic[@"values"][@"order_payment2"]];

                    VC.pay = [NSString stringWithFormat:@"%@,%@",md[@"order_payment"],md[@"order_payment2"]];
                }else{
                    md[@"order_payment"] = [NSString stringWithFormat:@"%@",dic[@"values"][@"order_payment"]];
                    VC.pay = md[@"order_payment"];
                }
                
                
                      
                       VC.member_Cumulative = self.member_Cumulative;
                       VC.sv_remarks = self.noteCellText;
                       NSString *order_integral = [NSString stringWithFormat:@"%@",dic[@"result"][@"order_integral"]];
                       if (kStringIsEmpty(order_integral)) {
                       VC.order_integral = @"0";
                      }else{
                       VC.order_integral = order_integral;
                      }
                     
                       VC.md_two = md;
                       if (![SVTool isBlankString:self.member_id]) {
                           VC.sv_mr_cardno = self.sv_mr_cardno;
                           
                           if ([self.payName isEqualToString:@"储值卡"]) {
                               VC.storedValue = [NSString stringWithFormat:@"%.2f",[self.stored doubleValue] - [self.twoCell.threeTextField.text doubleValue]];
                               
                             //  self.stored = [NSString stringWithFormat:@"%.2f",[self.stored doubleValue] - [self.twoCell.threeTextField.text doubleValue]];
                           } else {
                               VC.storedValue = self.stored;
                           }
                       }
                       
                       [self.navigationController pushViewController:VC animated:YES];
                       
                       //开启交互
                       [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                       
                   } else {
                       //隐藏提示
                     //[MBProgressHUD hideHUDForView:self.view animated:YES];  [SVUserManager shareInstance].ConvergePay
                      
                       if ([self.payName isEqualToString:@"扫码支付"]) {
                           NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                           [SVTool TextButtonAction:self.view withSing:errmsg];
                           
                       } else {
                           
                           NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"values"]];
                           [SVTool TextButtonAction:self.view withSing:errmsg];
                           
                       }
                       
                       //让按钮可点
                       [self.footerButton setEnabled:YES];
                       //开启交互
                       [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                   }
        
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        #pragma mark - 这里是聚合支付的返回
        if ([dic[@"code"] integerValue] == 1) {
            //回调清除选择商品数据
            if (self.selectWaresBlock) {
                self.selectWaresBlock();
            }
            
                NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                if (code.doubleValue == 1) {
                    //开启交互
                    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                    
                  NSString *queryId = [NSString stringWithFormat:@"%@",dic[@"data"]];
                    [self ConvergePayB2CQueryId:queryId md:md];

                }
            
            
                  
        }else{
            
        }
              
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //让按钮可点
        [self.footerButton setEnabled:YES];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
}


/**
 优惠折扣类型
 */
#pragma mark - 优惠折扣类型
- (NSString *)dicountproduct_unitprice:(double)product_unitprice sv_p_unitprice:(double)sv_p_unitprice dict:(NSDictionary *)dict grade:(double)grade Discountedvalue:(double)Discountedvalue
{
    /**
     t={1会员折扣，2分类折，3促销，4会员价，5最低单价，6最低折扣价}
     v={t1会员折，,t2分类折,t3成交价*数量,t4会员价,t5最低单价，t6最低折扣价}


     [{"t":"优惠类型","v":"对应优惠的折或促销值","m":"优惠金额","s":"优惠说明,会员折9折丶整单折8折丶满减活动满100减5元"}]
     */
  // dict[@"discount"];
   // NSString *product_unitpriceStr = [NSString stringWithFormat:@"%.2f",product_unitprice];
     NSString *product_num = dict[@"product_num"];
     double m =sv_p_unitprice*product_num.doubleValue - product_unitprice*product_num.doubleValue;
    // 最低价
    double sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
    // 最低折
    double sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
     NSMutableDictionary *memberdicM = [NSMutableDictionary dictionary];
    NSMutableArray *memberdicArray = [NSMutableArray array];
    if ([dict[@"isPriceChange"] isEqualToString:@"1"]) {

        memberdicM[@"t"] = @"4"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",product_unitprice]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"改价";
        [memberdicArray addObject:memberdicM];
    }else if (grade > 0){
     
        memberdicM[@"t"] = @"4"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",grade]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = [NSString stringWithFormat:@"多会员价%@:",self.grade];
        [memberdicArray addObject:memberdicM];
    }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dict[@"sv_p_memberprice"] doubleValue] > 0){
        NSLog(@"sv_p_minunitprice = %f",sv_p_minunitprice);
        NSLog(@"sv_p_mindiscount = %f",sv_p_mindiscount);
        NSLog(@"sv_p_memberprice = %f",[dict[@"sv_p_memberprice"] doubleValue]);
        /**
         场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
         注：有以上这三种情况下，就没有会员折一说，会员折无效
         */
        if ([SVTool isBlankString:self.discount]) {
            if (m > 0) { // 没选会员打了整单折也要显示
                memberdicM[@"t"] = @"6"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",self.oneCellText.doubleValue]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"整单折";
                [memberdicArray addObject:memberdicM];
            }
        }else{
            if ([dict[@"sv_p_memberprice"] doubleValue] > 0) {
               // money = [dict[@"sv_p_memberprice"] doubleValue];
                memberdicM[@"t"] = @"4"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",[dict[@"sv_p_memberprice"]doubleValue]]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"会员价";
                [memberdicArray addObject:memberdicM];
            }else if (sv_p_mindiscount > 0  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                 //场景二：最低折【8折】、会员折【9折】同时存在，按折比，取数字大的算【按9折算】
                if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                 //   money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                    memberdicM[@"t"] = @"6"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",sv_p_mindiscount * 0.1]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"最低折";
                    [memberdicArray addObject:memberdicM];
                }else{
                    if (sv_p_mindiscount > self.discount.doubleValue  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                        memberdicM[@"t"] = @"6"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",sv_p_mindiscount * 0.1]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"最低折";
                        [memberdicArray addObject:memberdicM];
                    }else if (self.discount.doubleValue > sv_p_mindiscount && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                        memberdicM[@"t"] = @"1"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",[dict[@"discount"] doubleValue] * 0.1]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"会员折";
                        [memberdicArray addObject:memberdicM];
                    }else{
                        
                    }
                }
                   
            }else if (sv_p_minunitprice > 0){// 场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                  //  money = sv_p_minunitprice;
                    memberdicM[@"t"] = @"5"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",sv_p_minunitprice]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"最低价";
                    [memberdicArray addObject:memberdicM];
                }else{
                    double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                    if (memberPrice > sv_p_minunitprice  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                        memberdicM[@"t"] = @"5"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",sv_p_minunitprice]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"最低价";
                        [memberdicArray addObject:memberdicM];
                    }else if (sv_p_minunitprice > memberPrice  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                        memberdicM[@"t"] = @"1"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",[dict[@"discount"] doubleValue] * 0.1]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"会员折";
                        [memberdicArray addObject:memberdicM];
                    }else{
                        
                    }
                }

                }else{
                     //  money = [dict[@"sv_p_unitprice"] doubleValue];
                }
            }

    }else if (Discountedvalue > 0){
    
        memberdicM[@"t"] = @"2"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",Discountedvalue]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"分类折";
        [memberdicArray addObject:memberdicM];
     
    }else if (self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
        memberdicM[@"t"] = @"1"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",[dict[@"discount"] doubleValue] * 0.1]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"会员折";
        [memberdicArray addObject:memberdicM];
    }else if (m > 0){
       // 没选会员打了整单折也要显示
            memberdicM[@"t"] = @"6"; memberdicM[@"v"] = [NSString stringWithFormat:@"%.2f",self.oneCellText.doubleValue]; memberdicM[@"m"] = [NSString stringWithFormat:@"%.2f",m]; memberdicM[@"s"] = @"整单折";
            [memberdicArray addObject:memberdicM];
       // }
    }
    
    NSLog(@"memberdicArray = %@",memberdicArray);
    if (!kArrayIsEmpty(memberdicArray)) {
        NSString *sv_preferential_data = [self arrayToJSONString:memberdicArray];
       // [guaDanDic setValue:sv_preferential_data forKey:@"sv_preferential_data"];
        return sv_preferential_data;
    }else{
        return nil;
    }

}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonResult;
}

#pragma mark - B2C支付
- (void)ConvergePayB2CQueryId:(NSString *)queryId md:(NSMutableDictionary *)md{
    [SVUserManager loadUserInfo];
   // NSString *url = [NSString stringWithFormat:@"%@%@",URLhead,@"/api/ConvergePay/B2C?key=%@",NSString *url = [SVUserManager shareInstance].access_token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"authCode"] = self.authcode;
   
    NSString *order_payment = md[@"order_payment"];
    NSString *order_payment2 = md[@"order_payment2"];
    NSString *order_money = md[@"order_money"];
    NSString *order_money2 = md[@"order_money2"];
    if ([order_payment isEqualToString:@"扫码支付"]) {
        parame[@"money"] = [NSString stringWithFormat:@"%.2f",order_money.doubleValue];
    }else if ([order_payment2 isEqualToString:@"扫码支付"]){
        parame[@"money"] = [NSString stringWithFormat:@"%.2f",order_money2.doubleValue];
    }else{
        parame[@"money"] = [NSString stringWithFormat:@"%.2f",self.sumMoneyTwo.doubleValue];
    }
    parame[@"subject"] = [SVUserManager shareInstance].sv_employee_name;
    parame[@"businessType"] = [NSNumber numberWithInteger:3];
    parame[@"queryId"] = queryId;
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ConvergePay/B2C?key=%@",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                   NSLog(@"dic-----B2C支付 = %@",dic);
                   NSLog(@"surlB2C支付 = %@",url);
        if ([dic[@"code"] integerValue] == 1) {
            self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
            //  self.showView.delegate = self;
            self.showView.center = self.view.center;
            [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
            //按钮实现倒计时
            __block int timeout=3000; //倒计时时间
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
                    [self ConvergePayQueryId:queryId _timer:_timer md:md];
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
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               //[SVTool requestFailed];
               [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}



#pragma mark - 聚合支付轮训
- (void)ConvergePayQueryId:(NSString *)queryId _timer:(dispatch_source_t)_timer md:(NSMutableDictionary *)md{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ConvergePay/%@?key=%@",queryId,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"dic-----聚合支付轮训 = %@",dic);
               NSLog(@"surl聚合支付轮训 = %@",url);
        if ([dic[@"code"] integerValue] == 1) {

            // 发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:@"1"];
            
            NSString *action = [NSString stringWithFormat:@"%@",dic[@"data"][@"action"]];
            NSString *msg = [NSString stringWithFormat:@"%@",dic[@"data"][@"msg"]];
            if (action.integerValue == -1) {// 停止轮训
                dispatch_source_cancel(_timer);
                [SVTool TextButtonActionWithSing:!kStringIsEmpty(msg)?msg:@"支付有误"];
                [self.showView removeFromSuperview];
            }else if(action.integerValue == 1){// 1:Success,取到结果;
                NSDictionary *dataDict = dic[@"data"];
                NSString *orderJson = [NSString stringWithFormat:@"%@",dataDict[@"orderJson"]];
                
                NSData *data = [orderJson dataUsingEncoding:NSUTF8StringEncoding];
                if (data != NULL) {
                     NSMutableDictionary *orderJsonDic = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                    [md setValue:orderJsonDic[@"order_integral"] forKey:@"order_integral"];
                    [md setValue:orderJsonDic[@"order_payment"] forKey:@"order_payment"];
                    //NSDictionary *orderJsonDic =[SVTool dictionaryWithJsonString:orderJson];
                    SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];
                    VC.money = self.sumMoneyTwo;
                    VC.interface = self.interface;
                    VC.vipName = self.name;
                    NSString *order_payment = md[@"order_payment"];
                    NSString *order_payment2 = md[@"order_payment2"];
    //                NSString *order_money = md[@"order_money"];
    //                NSString *order_money2 = md[@"order_money2"];
                    if (self.selectMoneyArray.count == 2) {
                        
                        if ([order_payment isEqualToString:@"扫码支付"]) {
                            int paymentType = [dataDict[@"paymentType"] intValue];
                            if (paymentType == 1) {
                                md[@"order_payment"] = @"扫码支付";
                            }else if (paymentType == 2){
                                md[@"order_payment"] = @"微信支付";
                            }else if (paymentType == 3){
                                md[@"order_payment"] = @"支付宝";
                            }else if (paymentType == 4){
                                md[@"order_payment"] = @"龙支付";
                            }
                            
                        }else if ([order_payment2 isEqualToString:@"扫码支付"]){
                            int paymentType = [dataDict[@"paymentType"] intValue];
                            if (paymentType == 1) {
                                md[@"order_payment2"] = @"扫码支付";
                            }else if (paymentType == 2){
                                md[@"order_payment2"] = @"微信支付";
                            }else if (paymentType == 3){
                                md[@"order_payment2"] = @"支付宝";
                            }else if (paymentType == 4){
                                md[@"order_payment2"] = @"龙支付";
                            }
                        }
                        
                        VC.pay = [NSString stringWithFormat:@"%@,%@",md[@"order_payment"],md[@"order_payment2"]];
                    }else{
                        int paymentType = [dataDict[@"paymentType"] intValue];
                        if (paymentType == 1) {
                            md[@"order_payment"] = @"扫码支付";
                        }else if (paymentType == 2){
                            md[@"order_payment"] = @"微信支付";
                        }else if (paymentType == 3){
                            md[@"order_payment"] = @"支付宝";
                        }else if (paymentType == 4){
                            md[@"order_payment"] = @"龙支付";
                        }
                        VC.pay = md[@"order_payment"];
                    }
                   // VC.pay = orderJsonDic[@"order_payment"];
                    
                    VC.member_Cumulative = self.member_Cumulative;
                    VC.sv_remarks = self.noteCellText;
                   // VC.md = dic;
                    VC.selectNumber = 1;
                    VC.md_two = md;
                    VC.storedValue = self.stored;
                    VC.isAggregatePayment = self.isAggregatePayment;
                    VC.queryId = queryId;
                    [self.navigationController pushViewController:VC animated:YES];
//                    //回调清除选择商品数据
//                    if (self.selectWaresBlock) {
//                        self.selectWaresBlock();
//                    }
                    NSLog(@"orderJson666666 = %@",orderJsonDic);
                }
   
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



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return self.cellCount;
    
    NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
    NSString *whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];

    if (kArrayIsEmpty(self.timesCountArr)) {
        if (self.modelArr.count < 4) {
            
                if (kStringIsEmpty(self.member_Cumulative)) {
                    self.cellCount = (int)self.modelArr.count + 10;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                    self.cellCount = (int)self.modelArr.count + 10;
                }
                else{
                     self.cellCount = (int)self.modelArr.count + 10 + 1;
                }
            
        } else {
            if (self.isSelect == YES) {
                if (kStringIsEmpty(self.member_Cumulative)) {
                    self.cellCount = (int)self.modelArr.count + 10;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                    self.cellCount = (int)self.modelArr.count + 10;
                }
                else{
                    self.cellCount = (int)self.modelArr.count + 10 + 1;
                }
                
            } else {
                
                if (kStringIsEmpty(self.member_Cumulative)) {
                   self.cellCount = 13;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                    self.cellCount = 13;
                }
                else{
                   self.cellCount = 14;
                }
                
            }
        }
        NSLog(@"self.cellCount88 = %ld",self.cellCount);
   
        return self.cellCount;
        
    }else{
        if (self.modelArr.count < 4) {
                if (kStringIsEmpty(self.member_Cumulative)) {
                   self.cellCount = (int)self.modelArr.count + 11;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                   self.cellCount = (int)self.modelArr.count + 11;
                }
                else{
                    self.cellCount = (int)self.modelArr.count + 12;
                }
            
        } else {
            if (self.isSelect == YES) {
                if (kStringIsEmpty(self.member_Cumulative)) {
                    self.cellCount = (int)self.modelArr.count + 11;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                    self.cellCount = (int)self.modelArr.count + 11;
                }
                else{
                    self.cellCount = (int)self.modelArr.count + 12;
                }
                
            } else {
                
                if (kStringIsEmpty(self.member_Cumulative)) {
                    self.cellCount = 14;
                }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                   self.cellCount = 14;
                }
                else{
                    self.cellCount = 15;
                }
                
            }
        }
        NSLog(@"self.cellCount66 = %ld",self.cellCount);
        
  
        return self.cellCount;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
    NSString *whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];
    //    if (kStringIsEmpty(self.member_Cumulative)) {
    //        return self.cellCount;
    //    }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
    //        return self.cellCount;
    //    }
    //    else{
    //        return self.cellCount + 1;
    //    }
    
    if (kArrayIsEmpty(self.timesCountArr)) {
        
            if (kStringIsEmpty(self.member_Cumulative)) {
               // return self.cellCount;
                if (indexPath.row == 0) {
                    return 65;
                }
                if (indexPath.row == self.cellCount-7) {
                    return 40;
                }
                if (indexPath.row == self.cellCount-8) {
                    return 0.5;
                }
                if (indexPath.row == 1 || indexPath.row == self.cellCount-6) {
                    return 10;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    if (![SVTool isBlankString:self.member_id]) {
                        int num = (int) ceil(self.titleArr_member.count / 4.0);
                        return num * 80 + num + 1;
                    }else{
                        int num = (int) ceil(self.vipTitleArr.count / 4.0);
                        return num * 80 + num + 1;
                    }
                }
                return 60;
                
            }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
             //   return self.cellCount;
                
                if (indexPath.row == 0) {
                    return 65;
                }
                if (indexPath.row == self.cellCount-7) {
                    return 40;
                }
                if (indexPath.row == self.cellCount-8) {
                    return 0.5;
                }
                if (indexPath.row == 1 || indexPath.row == self.cellCount-6) {
                    return 10;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    if (![SVTool isBlankString:self.member_id]) {
                        int num = (int) ceil(self.titleArr_member.count / 4.0);
                        return num * 80 + num + 1;
                    }else{
                        int num = (int) ceil(self.vipTitleArr.count / 4.0);
                        return num * 80 + num + 1;
                    }
                }
                return 60;
            }
            else{
               // return self.cellCount + 1;
                
                if (indexPath.row == 0) {
                    return 65;
                }
                if (indexPath.row == self.cellCount-8) {
                    return 40;
                }
                if (indexPath.row == self.cellCount-9) {
                    return 0.5;
                }
                if (indexPath.row == 1 || indexPath.row == self.cellCount-7) {
                    return 10;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    if (![SVTool isBlankString:self.member_id]) {
                        int num = (int) ceil(self.titleArr_member.count / 4.0);
                        return num * 80 + num + 1;
                    }else{
                        int num = (int) ceil(self.vipTitleArr.count / 4.0);
                        return num * 80 + num + 1;
                    }
                }
                return 60;
            }
     
    
    }else{
        
            if (kStringIsEmpty(self.member_Cumulative)) {
                if (indexPath.row == 0) {
                    return 65;
                }
                if (indexPath.row == self.cellCount-8) {
                    return 40;
                }
                if (indexPath.row == self.cellCount-9) {
                    return 0.5;
                }
                if (indexPath.row == 1 || indexPath.row == self.cellCount-7) {
                    return 10;
                }
                
                // 模拟有计次卡的情况
                if (indexPath.row == self.cellCount - 2) {
                    int num = (int) ceil(self.timesCountArr.count / 2.0);
                    return num * 80 + num *10 + 10 + 30;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    if (![SVTool isBlankString:self.member_id]) {
                        int num = (int) ceil(self.titleArr_member.count / 4.0);
                        return num * 80 + num + 1;
                    }else{
                        int num = (int) ceil(self.vipTitleArr.count / 4.0);
                        return num * 80 + num + 1;
                    }
                }
                return 60;
            }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                if (indexPath.row == 0) {
                    return 65;
                }
                if (indexPath.row == self.cellCount-8) {
                    return 40;
                }
                if (indexPath.row == self.cellCount-9) {
                    return 0.5;
                }
                if (indexPath.row == 1 || indexPath.row == self.cellCount-7) {
                    return 10;
                }
                
                // 模拟有计次卡的情况
                if (indexPath.row == self.cellCount - 2) {
                    int num = (int) ceil(self.timesCountArr.count / 2.0);
                    return num * 80 + num *10 + 10 + 30;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    if (![SVTool isBlankString:self.member_id]) {
                        int num = (int) ceil(self.titleArr_member.count / 4.0);
                        return num * 80 + num + 1;
                    }else{
                        int num = (int) ceil(self.vipTitleArr.count / 4.0);
                        return num * 80 + num + 1;
                    }
                }
                return 60;
            }
            else{
                if (indexPath.row == 0) {
                    return 65;
                }
                if (indexPath.row == self.cellCount-9) {
                    return 40;
                }
                if (indexPath.row == self.cellCount-10) {
                    return 0.5;
                }
                if (indexPath.row == 1 || indexPath.row == self.cellCount-8) {
                    return 10;
                }
                
                // 模拟有计次卡的情况
                if (indexPath.row == self.cellCount - 2) {
                    int num = (int) ceil(self.timesCountArr.count / 2.0);
                    return num * 80 + num *10 + 10 + 30;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    if (![SVTool isBlankString:self.member_id]) {
                        int num = (int) ceil(self.titleArr_member.count / 4.0);
                        return num * 80 + num + 1;
                    }else{
                        int num = (int) ceil(self.vipTitleArr.count / 4.0);
                        return num * 80 + num + 1;
                    }
                }
                return 60;
            }
     
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kArrayIsEmpty(self.timesCountArr)) {
        
            if (kStringIsEmpty(self.member_Cumulative)) {
              //  return self.cellCount;
                if (indexPath.row == 0) {
                    self.vipCell = [tableView dequeueReusableCellWithIdentifier:checkoutOneID forIndexPath:indexPath];
                    if (!self.vipCell) {
                        self.vipCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutOneCell" owner:nil options:nil].lastObject;
                    }
                    if (![SVTool isBlankString:self.member_id]) {
                        self.vipCell.vipView.hidden = YES;
                    } else {
                        self.vipCell.vipView.hidden = NO;
                    }
                    if (self.vipBool == YES) {
                        self.vipCell.deleteVipB.hidden = YES;
                    }
                    //设置cell选中不高亮
                    self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //设置view的圆角
                    self.vipCell.iconImg.layer.cornerRadius = 22.5;
                    //UIImageView切圆的时候就要用到这一句了vipPhone
                    self.vipCell.iconImg.layer.masksToBounds = YES;
                    if (![SVTool isBlankString:self.headimg]) {
                        [self.vipCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                        self.vipCell.nameLabel.hidden = YES;
                    } else {
                        self.vipCell.nameLabel.text = [self.name substringToIndex:1];
                        self.vipCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                        self.vipCell.iconImg.image = [UIImage imageNamed:@"icon_black"];
                        self.vipCell.nameLabel.hidden = NO;
                    }
                    self.vipCell.vipName.text = self.name;
                    self.vipCell.storedValue.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
                    
                    self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];
                    
                    [SVUserManager loadUserInfo];
                    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                    if (kDictIsEmpty(sv_versionpowersDict)) {
                        self.vipCell.vipPhone.text = self.phone;
                    }else{
                        NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Member"][@"MobilePhoneShow"]];
                        if ([MobilePhoneShow isEqualToString:@"1"]) {
                            self.vipCell.vipPhone.text = self.phone;
                        }else{
                                 if (self.phone.length < 11) {
                                     self.vipCell.vipPhone.text = self.phone;
                                 }else{
                                    self.vipCell.vipPhone.text = [self.phone stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
                                 }
                          
                        }
                    }
                                
                    // self.vipCell.vipPhone.text = self.phone;
                    
                    [self.vipCell.deleteVipB addTarget:self action:@selector(deleteVipBResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                    
                    return self.vipCell;
                }
                
                if (indexPath.row == 1 || indexPath.row == self.cellCount-8 || indexPath.row == self.cellCount-6) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = BackgroundColor;
                    //设置cell不能点击
                    cell.userInteractionEnabled = NO;
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-7) {
                    SVCheckoutThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutThreeID forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutThreeCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%.2f",self.sumCount];
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                    
                    if (self.modelArr.count < 4) {
                        cell.lookLabel.hidden = YES;
                    } else {
                        cell.lookLabel.hidden = NO;
                        if (self.isSelect == YES) {
                            cell.lookLabel.text = @"收起";
                        } else {
                            cell.lookLabel.text = @"更多";
                        }
                    }
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-5) {
                    self.oneCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.oneCell) {
                        self.oneCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.oneCell.threeTextField.placeholder = @"10";
                    self.oneCell.threeTextField.text = self.oneCellText;
                    self.oneCell.threeTextField.textColor = GlobalFontColor;
                    self.oneCell.threeTextField.tag = 1;
                    self.oneCell.oneLabel.text = @"整单折扣";
                    self.oneCell.twoLabel.text = @"折";
                    self.oneCell.threeTextField.delegate = self;
                    self.oneCell.fourLabel.hidden = YES;
                    //整单打折
                    [self.oneCell.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.oneCell;
                }
                
                if (indexPath.row == self.cellCount-4) {
                    self.twoCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.twoCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.twoCell.oneLabel.text = @"本单实收";
                    self.twoCell.threeTextField.placeholder = @"0";
                    self.twoCell.threeTextField.tag = 2;
                    self.twoCell.threeTextField.delegate = self;
                    self.twoCell.threeTextField.textColor = [UIColor redColor];
                    self.twoCell.threeTextField.text = self.sumMoneyTwo;
//                    if (self.isOpen == YES) {
//                        self.twoCell.fourLabel.hidden = NO;
//                    }else{
//                        self.twoCell.fourLabel.hidden = YES;
//                    }
                    double result = [self molingReceiveMoney:self.sumMoney];
                    if (self.isOpen == YES) {
                    
                            self.twoCell.fourLabel.hidden = NO;
                            double zeroNumber = self.sumMoney - result;
                        self.zeroNumber = zeroNumber;
                            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                      
                       
                    }else{
                        self.twoCell.fourLabel.hidden = YES;
                    }
                    //本单实收
                    [self.twoCell.threeTextField addTarget:self action:@selector(moneyFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.twoCell;
                }
                
                if (indexPath.row == self.cellCount-3) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *oneLabel = [[UILabel alloc]init];
                    oneLabel.text = @"销售人员";
                    oneLabel.textColor = RGBA(85, 85, 85, 1);
                    oneLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:oneLabel];
                    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell).offset(10);
                    }];
                    
                    UIImageView *img = [[UIImageView alloc]init];
                    img.image = [UIImage imageNamed:@"brithdaySmall"];
                    [cell.contentView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.right.mas_equalTo(cell).offset(-10);
                    }];
                    
                    if (kStringIsEmpty(self.sv_employee_id)) {
                        self.threeLabel.text = @"选择销售人";
                    }else{
                        self.threeLabel.text =self.threeCellText;
                    }
                    self.threeLabel.textColor = GlobalFontColor;
                    self.threeLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:self.threeLabel];
                    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.right.mas_equalTo(img.mas_left).offset(-5);
                    }];
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-2) {
                    self.fourCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.fourCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.fourCell.oneLabel.text = @"备        注";
                    self.fourCell.threeTextField.placeholder = @"限制于100字";
                    self.fourCell.threeTextField.text = self.noteCellText;
                    self.fourCell.threeTextField.textColor = GlobalFontColor;
                    self.fourCell.threeTextField.tag = 3;
                    self.fourCell.threeTextField.delegate = self;
                    self.fourCell.threeTextField.keyboardType = UIKeyboardTypeDefault;
                    //本单实收
                    [self.fourCell.threeTextField addTarget:self action:@selector(noteFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.fourCell;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = [UIColor redColor];
                    cell.userInteractionEnabled = YES;
                    [cell.contentView addSubview:self.collectionView];
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    return cell;
                }
                
                
            }else if (self.member_Cumulative.doubleValue < self.autoStr.doubleValue || [self.whether isEqualToString:@"0"]){
              //  return self.cellCount;
                
                if (indexPath.row == 0) {
                    self.vipCell = [tableView dequeueReusableCellWithIdentifier:checkoutOneID forIndexPath:indexPath];
                    if (!self.vipCell) {
                        self.vipCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutOneCell" owner:nil options:nil].lastObject;
                    }
                    if (![SVTool isBlankString:self.member_id]) {
                        self.vipCell.vipView.hidden = YES;
                    } else {
                        self.vipCell.vipView.hidden = NO;
                    }
                    if (self.vipBool == YES) {
                        self.vipCell.deleteVipB.hidden = YES;
                    }
                    //设置cell选中不高亮
                    self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //设置view的圆角
                    self.vipCell.iconImg.layer.cornerRadius = 22.5;
                    //UIImageView切圆的时候就要用到这一句了vipPhone
                    self.vipCell.iconImg.layer.masksToBounds = YES;
                    if (![SVTool isBlankString:self.headimg]) {
                        [self.vipCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                        self.vipCell.nameLabel.hidden = YES;
                    } else {
                        self.vipCell.nameLabel.text = [self.name substringToIndex:1];
                        self.vipCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                        self.vipCell.iconImg.image = [UIImage imageNamed:@"icon_black"];
                        self.vipCell.nameLabel.hidden = NO;
                    }
                    self.vipCell.vipName.text = self.name;
                    self.vipCell.storedValue.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
                     self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];

                    [SVUserManager loadUserInfo];
                                  NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                                  if (kDictIsEmpty(sv_versionpowersDict)) {
                                      self.vipCell.vipPhone.text = self.phone;
                                  }else{
                                      NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Member"][@"MobilePhoneShow"]];
                                      if ([MobilePhoneShow isEqualToString:@"1"]) {
                                          self.vipCell.vipPhone.text = self.phone;
                                      }else{
                                        self.vipCell.vipPhone.text = [self.phone stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
                                      }
                                  }
                    
                    [self.vipCell.deleteVipB addTarget:self action:@selector(deleteVipBResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                    
                    return self.vipCell;
                }
                
                if (indexPath.row == 1 || indexPath.row == self.cellCount-8 || indexPath.row == self.cellCount-6) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = BackgroundColor;
                    //设置cell不能点击
                    cell.userInteractionEnabled = NO;
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-7) {
                    SVCheckoutThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutThreeID forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutThreeCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%.2f",self.sumCount];
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                    
                    if (self.modelArr.count < 4) {
                        cell.lookLabel.hidden = YES;
                    } else {
                        cell.lookLabel.hidden = NO;
                        if (self.isSelect == YES) {
                            cell.lookLabel.text = @"收起";
                        } else {
                            cell.lookLabel.text = @"更多";
                        }
                    }
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-5) {
                    self.oneCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.oneCell) {
                        self.oneCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.oneCell.threeTextField.placeholder = @"10";
                    self.oneCell.threeTextField.text = self.oneCellText;
                  //  self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.0f",self.oneCellText.doubleValue *10] ;
                    self.oneCell.threeTextField.textColor = GlobalFontColor;
                    self.oneCell.threeTextField.tag = 1;
                    self.oneCell.oneLabel.text = @"整单折扣";
                    self.oneCell.twoLabel.text = @"折";
                    self.oneCell.threeTextField.delegate = self;
                    //整单打折
                    [self.oneCell.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.oneCell;
                }
                
                if (indexPath.row == self.cellCount-4) {
                    self.twoCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.twoCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.twoCell.oneLabel.text = @"本单实收";
                    self.twoCell.threeTextField.placeholder = @"0";
                    self.twoCell.threeTextField.tag = 2;
                    self.twoCell.threeTextField.delegate = self;
                    self.twoCell.threeTextField.textColor = [UIColor redColor];
                    self.twoCell.threeTextField.text = self.sumMoneyTwo;
                    
                    double result = [self molingReceiveMoney:self.sumMoney];
                    if (self.isOpen == YES) {
                        
//                         self.twoCell.fourLabel.hidden = NO;
//                        double zeroNumber = self.sumMoney - result;
//                        self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                        
                   
                            self.twoCell.fourLabel.hidden = NO;
                            double zeroNumber = self.sumMoney - result;
                        self.zeroNumber = zeroNumber;
                            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                        
                        
                    }else{
                       self.twoCell.fourLabel.hidden = YES;
                    }
                    
                    //本单实收
                    [self.twoCell.threeTextField addTarget:self action:@selector(moneyFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.twoCell;
                }
                
                if (indexPath.row == self.cellCount-3) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *oneLabel = [[UILabel alloc]init];
                    oneLabel.text = @"销售人员";
                    oneLabel.textColor = RGBA(85, 85, 85, 1);
                    oneLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:oneLabel];
                    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell).offset(10);
                    }];
                    
                    UIImageView *img = [[UIImageView alloc]init];
                    img.image = [UIImage imageNamed:@"brithdaySmall"];
                    [cell.contentView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.right.mas_equalTo(cell).offset(-10);
                    }];
                    
                 //   self.threeLabel = [[UILabel alloc]init];

                    if (kStringIsEmpty(self.sv_employee_id)) {
                        self.threeLabel.text = @"选择销售人";
                    }else{
                        self.threeLabel.text =self.threeCellText;
                    }
                    self.threeLabel.textColor = GlobalFontColor;
                    self.threeLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:self.threeLabel];
                    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.right.mas_equalTo(img.mas_left).offset(-5);
                    }];
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-2) {
                    self.fourCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.fourCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.fourCell.oneLabel.text = @"备        注";
                    self.fourCell.threeTextField.placeholder = @"限制于100字";
                    self.fourCell.threeTextField.text = self.noteCellText;
                    self.fourCell.threeTextField.textColor = GlobalFontColor;
                    self.fourCell.threeTextField.tag = 3;
                    self.fourCell.threeTextField.delegate = self;
                    self.fourCell.threeTextField.keyboardType = UIKeyboardTypeDefault;
                    //本单实收
                    [self.fourCell.threeTextField addTarget:self action:@selector(noteFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.fourCell;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    
                    [cell.contentView addSubview:self.collectionView];
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    return cell;
                }
            }else{
              //  return self.cellCount + 1;
                if (indexPath.row == 0) {
                    self.vipCell = [tableView dequeueReusableCellWithIdentifier:checkoutOneID forIndexPath:indexPath];
                    if (!self.vipCell) {
                        self.vipCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutOneCell" owner:nil options:nil].lastObject;
                    }
                    if (![SVTool isBlankString:self.member_id]) {
                        self.vipCell.vipView.hidden = YES;
                    } else {
                        self.vipCell.vipView.hidden = NO;
                    }
                    if (self.vipBool == YES) {
                        self.vipCell.deleteVipB.hidden = YES;
                    }
                    //设置cell选中不高亮
                    self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //设置view的圆角
                    self.vipCell.iconImg.layer.cornerRadius = 22.5;
                    //UIImageView切圆的时候就要用到这一句了vipPhone
                    self.vipCell.iconImg.layer.masksToBounds = YES;
                    if (![SVTool isBlankString:self.headimg]) {
                        [self.vipCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                        self.vipCell.nameLabel.hidden = YES;
                    } else {
                        self.vipCell.nameLabel.text = [self.name substringToIndex:1];
                        self.vipCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                        self.vipCell.iconImg.image = [UIImage imageNamed:@"icon_black"];
                        self.vipCell.nameLabel.hidden = NO;
                    }
                    self.vipCell.vipName.text = self.name;
                    self.vipCell.storedValue.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
                     self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];

                    [SVUserManager loadUserInfo];
                                  NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                                  if (kDictIsEmpty(sv_versionpowersDict)) {
                                      self.vipCell.vipPhone.text = self.phone;
                                  }else{
                                      NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Member"][@"MobilePhoneShow"]];
                                      if ([MobilePhoneShow isEqualToString:@"1"]) {
                                          self.vipCell.vipPhone.text = self.phone;
                                      }else{
                                          if (self.phone.length < 11) {
                                              self.vipCell.vipPhone.text = self.phone;
                                          }else{
                                              self.vipCell.vipPhone.text = [self.phone stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
                                          }
                                      }
                                  }
                    
                    [self.vipCell.deleteVipB addTarget:self action:@selector(deleteVipBResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                    
                    return self.vipCell;
                }
                
                
                if (indexPath.row == 1 || indexPath.row == self.cellCount-9 || indexPath.row == self.cellCount-7) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = BackgroundColor;
                    //设置cell不能点击
                    cell.userInteractionEnabled = NO;
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-8) {
                    SVCheckoutThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutThreeID forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutThreeCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%.2f",self.sumCount];
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                    
                    if (self.modelArr.count < 4) {
                        cell.lookLabel.hidden = YES;
                    } else {
                        cell.lookLabel.hidden = NO;
                        if (self.isSelect == YES) {
                            cell.lookLabel.text = @"收起";
                        } else {
                            cell.lookLabel.text = @"更多";
                        }
                    }
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-6) {
                    self.oneCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.oneCell) {
                        self.oneCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.oneCell.threeTextField.placeholder = @"10";
                    self.oneCell.threeTextField.text = self.oneCellText;
                   // self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.0f",self.oneCellText.doubleValue *10] ;
                    self.oneCell.threeTextField.textColor = GlobalFontColor;
                    self.oneCell.threeTextField.tag = 1;
                    self.oneCell.oneLabel.text = @"整单折扣";
                    self.oneCell.twoLabel.text = @"折";
                    self.oneCell.threeTextField.delegate = self;
                    //整单打折
                    [self.oneCell.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.oneCell;
                }
                
                if (indexPath.row == self.cellCount-5) {
                    self.twoCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.twoCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.twoCell.oneLabel.text = @"本单实收";
                    self.twoCell.threeTextField.placeholder = @"0";
                    self.twoCell.threeTextField.tag = 2;
                    self.twoCell.threeTextField.delegate = self;
                    self.twoCell.threeTextField.textColor = [UIColor redColor];
                    self.twoCell.threeTextField.text = self.sumMoneyTwo;
//                    self.twoCell.fourLabel.hidden = NO;
//                    double result = [self molingReceiveMoney:self.sumMoney];
//                    double zeroNumber = self.sumMoney - result;
//                    self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                    double result = [self molingReceiveMoney:self.sumMoney];
                    if (self.isOpen == YES) {
                        
                    
                            self.twoCell.fourLabel.hidden = NO;
                            double zeroNumber = self.sumMoney - result;
                        self.zeroNumber = zeroNumber;
                            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                        
                        
//                        self.twoCell.fourLabel.hidden = NO;
//                        double zeroNumber = self.sumMoney - result;
//                        self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                    }else{
                        self.twoCell.fourLabel.hidden = YES;
                    }
                    //本单实收
                    [self.twoCell.threeTextField addTarget:self action:@selector(moneyFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.twoCell;
                }
                
                if (indexPath.row == self.cellCount-4) {
                    self.IntegralDeductionCell = [tableView dequeueReusableCellWithIdentifier:IntegralDeductionCellID forIndexPath:indexPath];
                    if (!self.IntegralDeductionCell) {
                        self.IntegralDeductionCell = [[NSBundle mainBundle]loadNibNamed:@"SVIntegralDeductionCell" owner:nil options:nil].lastObject;
                    }
                    
                    self.IntegralDeductionCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
                   
                    NSLog(@"count = %ld",self.integralCount);
                    self.integralMoney = self.integralCount * self.autoStr.integerValue;
                    self.IntegralDeductionCell.textName.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%ld元",self.integralMoney,self.integralCount];
                    

                    [self.IntegralDeductionCell.circleBtn addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.IntegralDeductionCell.integralBtn addTarget:self action:@selector(integralBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    return self.IntegralDeductionCell;
                    
                    
                }
                
                if (indexPath.row == self.cellCount-3) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *oneLabel = [[UILabel alloc]init];
                    oneLabel.text = @"销售人员";
                    oneLabel.textColor = RGBA(85, 85, 85, 1);
                    oneLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:oneLabel];
                    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell).offset(10);
                    }];
                    
                    UIImageView *img = [[UIImageView alloc]init];
                    img.image = [UIImage imageNamed:@"brithdaySmall"];
                    [cell.contentView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.right.mas_equalTo(cell).offset(-10);
                    }];
                    
                 //   self.threeLabel = [[UILabel alloc]init];
//                    [SVUserManager loadUserInfo];
//                    self.sv_employee_id = [SVUserManager shareInstance].sv_employeeid;
//                    if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
//                        self.threeLabel.text = self.threeCellText;
//                    } else {
//                        self.threeLabel.text = [SVUserManager shareInstance].sv_employee_name;
//
//                    }
                    if (kStringIsEmpty(self.sv_employee_id)) {
                        self.threeLabel.text = @"选择销售人";
                    }else{
                        self.threeLabel.text =self.threeCellText;
                    }
                   
                   // self.threeLabel.text = @"选择销售人";  self.sv_employee_id
                    self.threeLabel.textColor = GlobalFontColor;
                    self.threeLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:self.threeLabel];
                    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.right.mas_equalTo(img.mas_left).offset(-5);
                    }];
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-2) {
                    self.fourCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.fourCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.fourCell.oneLabel.text = @"备        注";
                    self.fourCell.threeTextField.placeholder = @"限制于100字";
                    self.fourCell.threeTextField.text = self.noteCellText;
                    self.fourCell.threeTextField.textColor = GlobalFontColor;
                    self.fourCell.threeTextField.tag = 3;
                    self.fourCell.threeTextField.delegate = self;
                    self.fourCell.threeTextField.keyboardType = UIKeyboardTypeDefault;
                    //本单实收
                    [self.fourCell.threeTextField addTarget:self action:@selector(noteFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.fourCell;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    
                    [cell.contentView addSubview:self.collectionView];
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    return cell;
                }
                
            }

    
        SVSettlementCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutTwoID forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SVSettlementCommodityCell" owner:nil options:nil].lastObject;
        }
        //设置cell选中不高亮
        int i = (int)indexPath.row - 2;
        // cell.userInteractionEnabled = NO;
        cell.chahaoBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"self.modelArr = %@",self.modelArr);
        NSLog(@"i = %d",i);
        cell.grade = self.grade;
        cell.sv_discount_configArray = self.sv_discount_configArray;
        cell.orderDetailsModel = self.modelArr[i];
        
        return cell;
    }else{
        
        
            if (kStringIsEmpty(self.member_Cumulative)) {
                if (indexPath.row == 0) {
                    self.vipCell = [tableView dequeueReusableCellWithIdentifier:checkoutOneID forIndexPath:indexPath];
                    if (!self.vipCell) {
                        self.vipCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutOneCell" owner:nil options:nil].lastObject;
                    }
                    if (![SVTool isBlankString:self.member_id]) {
                        self.vipCell.vipView.hidden = YES;
                    } else {
                        self.vipCell.vipView.hidden = NO;
                    }
                    if (self.vipBool == YES) {
                        self.vipCell.deleteVipB.hidden = YES;
                    }
                    //设置cell选中不高亮
                    self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //设置view的圆角
                    self.vipCell.iconImg.layer.cornerRadius = 22.5;
                    //UIImageView切圆的时候就要用到这一句了
                    self.vipCell.iconImg.layer.masksToBounds = YES;
                    if (![SVTool isBlankString:self.headimg]) {
                        [self.vipCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                        self.vipCell.nameLabel.hidden = YES;
                    } else {
                        self.vipCell.nameLabel.text = [self.name substringToIndex:1];
                        self.vipCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                        self.vipCell.iconImg.image = [UIImage imageNamed:@"icon_black"];
                        self.vipCell.nameLabel.hidden = NO;
                    }
                    self.vipCell.vipName.text = self.name;
                    // self.vipCell.storedValue.text = self.stored;
                    self.vipCell.storedValue.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
                    self.vipCell.vipPhone.text = self.phone;
                     self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];
                    self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];
                    
                    [self.vipCell.deleteVipB addTarget:self action:@selector(deleteVipBResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                    
                    return self.vipCell;
                }
                
                if (indexPath.row == 1 || indexPath.row == self.cellCount-9 || indexPath.row == self.cellCount-7) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = BackgroundColor;
                    //设置cell不能点击
                    cell.userInteractionEnabled = NO;
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-8) {
                    SVCheckoutThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutThreeID forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutThreeCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%d",self.sumCount];
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.3f",self.sumMoney];
                    
                    if (self.modelArr.count < 4) {
                        cell.lookLabel.hidden = YES;
                    } else {
                        cell.lookLabel.hidden = NO;
                        if (self.isSelect == YES) {
                            cell.lookLabel.text = @"收起";
                        } else {
                            cell.lookLabel.text = @"更多";
                        }
                    }
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount - 6) {
                    self.oneCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.oneCell) {
                        self.oneCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.oneCell.threeTextField.placeholder = @"10";
                    self.oneCell.threeTextField.text = self.oneCellText;
                   // self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.0f",self.oneCellText.doubleValue *10] ;
                    self.oneCell.threeTextField.textColor = GlobalFontColor;
                    self.oneCell.threeTextField.tag = 1;
                    self.oneCell.oneLabel.text = @"整单折扣";
                    self.oneCell.twoLabel.text = @"折";
                    self.oneCell.threeTextField.delegate = self;
                    //整单打折
                    [self.oneCell.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.oneCell;
                }
                
                if (indexPath.row == self.cellCount-5) {
                    
                    self.twoCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.twoCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.twoCell.oneLabel.text = @"本单实收";
                    self.twoCell.threeTextField.placeholder = @"0";
                    self.twoCell.threeTextField.tag = 2;
                    self.twoCell.threeTextField.delegate = self;
                    self.twoCell.threeTextField.textColor = [UIColor redColor];
                    self.twoCell.threeTextField.text = self.sumMoneyTwo;
                    double result = [self molingReceiveMoney:self.sumMoney];
                    if (self.isOpen == YES) {
//                         self.twoCell.fourLabel.hidden = NO;
//                        double zeroNumber = self.sumMoney - result;
//                        self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                 
                            self.twoCell.fourLabel.hidden = NO;
                            double zeroNumber = self.sumMoney - result;
                        self.zeroNumber = zeroNumber;
                            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];

                    }else{
                       self.twoCell.fourLabel.hidden = YES;
                    }
                    //本单实收
                    [self.twoCell.threeTextField addTarget:self action:@selector(moneyFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.twoCell;
                }
                if (indexPath.row == self.cellCount-4) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *oneLabel = [[UILabel alloc]init];
                    oneLabel.text = @"销售人员";
                    oneLabel.textColor = RGBA(85, 85, 85, 1);
                    oneLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:oneLabel];
                    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell).offset(10);
                    }];
                    
                    UIImageView *img = [[UIImageView alloc]init];
                    img.image = [UIImage imageNamed:@"brithdaySmall"];
                    [cell.contentView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.right.mas_equalTo(cell).offset(-10);
                    }];
                    
                 //   self.threeLabel = [[UILabel alloc]init];
//                    [SVUserManager loadUserInfo];
//                    self.sv_employee_id = [SVUserManager shareInstance].sv_employeeid;
//                    if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
//                        self.threeLabel.text = self.threeCellText;
//                    } else {
//                        self.threeLabel.text = [SVUserManager shareInstance].sv_employee_name;
//
//                    }
                   // self.threeLabel.text = @"选择销售人";
                    if (kStringIsEmpty(self.sv_employee_id)) {
                        self.threeLabel.text = @"选择销售人";
                    }else{
                        self.threeLabel.text =self.threeCellText;
                    }
                    self.threeLabel.textColor = GlobalFontColor;
                    self.threeLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:self.threeLabel];
                    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.right.mas_equalTo(img.mas_left).offset(-5);
                    }];
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-3) {
                    self.fourCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.fourCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.fourCell.oneLabel.text = @"备        注";
                    self.fourCell.threeTextField.placeholder = @"限制于100字";
                    self.fourCell.threeTextField.text = self.noteCellText;
                    self.fourCell.threeTextField.textColor = GlobalFontColor;
                    self.fourCell.threeTextField.tag = 3;
                    self.fourCell.threeTextField.delegate = self;
                    self.fourCell.threeTextField.keyboardType = UIKeyboardTypeDefault;
                    //本单实收
                    [self.fourCell.threeTextField addTarget:self action:@selector(noteFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.fourCell;
                    
                }
                
                if (indexPath.row == self.cellCount-2) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //  cell.userInteractionEnabled = NO;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenW - 20, 20)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = [UIColor colorWithHexString:@"555555"];
                    label.text = @"本单可用次卡";
                    [cell.contentView addSubview:label];
                    [cell.contentView addSubview:self.timeCollectionView];
                    
                    cell.backgroundColor = BackgroundColor;
                    return cell;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    
                    [cell.contentView addSubview:self.collectionView];
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    return cell;
                }
                
                
                
                SVSettlementCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutTwoID forIndexPath:indexPath];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"SVSettlementCommodityCell" owner:nil options:nil].lastObject;
                }
                //设置cell选中不高亮
                int i = (int)indexPath.row - 2;
                // cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.grade = self.grade;
                cell.sv_discount_configArray = self.sv_discount_configArray;
                cell.orderDetailsModel = self.modelArr[i];
                NSLog(@"self.modelArr434343 = %@",self.modelArr);
                return cell;
            }else if (self.member_Cumulative.doubleValue < self.autoStr.doubleValue || [self.whether isEqualToString:@"0"]){
               // return self.cellCount;
                
                if (indexPath.row == 0) {
                    self.vipCell = [tableView dequeueReusableCellWithIdentifier:checkoutOneID forIndexPath:indexPath];
                    if (!self.vipCell) {
                        self.vipCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutOneCell" owner:nil options:nil].lastObject;
                    }
                    if (![SVTool isBlankString:self.member_id]) {
                        self.vipCell.vipView.hidden = YES;
                    } else {
                        self.vipCell.vipView.hidden = NO;
                    }
                    if (self.vipBool == YES) {
                        self.vipCell.deleteVipB.hidden = YES;
                    }
                    //设置cell选中不高亮
                    self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //设置view的圆角
                    self.vipCell.iconImg.layer.cornerRadius = 22.5;
                    //UIImageView切圆的时候就要用到这一句了
                    self.vipCell.iconImg.layer.masksToBounds = YES;
                    if (![SVTool isBlankString:self.headimg]) {
                        [self.vipCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                        self.vipCell.nameLabel.hidden = YES;
                    } else {
                        self.vipCell.nameLabel.text = [self.name substringToIndex:1];
                        self.vipCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                        self.vipCell.iconImg.image = [UIImage imageNamed:@"icon_black"];
                        self.vipCell.nameLabel.hidden = NO;
                    }
                    self.vipCell.vipName.text = self.name;
                    // self.vipCell.storedValue.text = self.stored;
                    self.vipCell.storedValue.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
                    self.vipCell.vipPhone.text = self.phone;
                     self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];
                    [self.vipCell.deleteVipB addTarget:self action:@selector(deleteVipBResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                    
                    return self.vipCell;
                }
                
                if (indexPath.row == 1 || indexPath.row == self.cellCount-9 || indexPath.row == self.cellCount-7) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = BackgroundColor;
                    //设置cell不能点击
                    cell.userInteractionEnabled = NO;
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-8) {
                    SVCheckoutThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutThreeID forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutThreeCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%f",self.sumCount];
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                    
                    if (self.modelArr.count < 4) {
                        cell.lookLabel.hidden = YES;
                    } else {
                        cell.lookLabel.hidden = NO;
                        if (self.isSelect == YES) {
                            cell.lookLabel.text = @"收起";
                        } else {
                            cell.lookLabel.text = @"更多";
                        }
                    }
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount - 6) {
                    self.oneCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.oneCell) {
                        self.oneCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.oneCell.threeTextField.placeholder = @"10";
                    self.oneCell.threeTextField.text = self.oneCellText;
                  //  self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.0f",self.oneCellText.doubleValue *10] ;
                    self.oneCell.threeTextField.textColor = GlobalFontColor;
                    self.oneCell.threeTextField.tag = 1;
                    self.oneCell.oneLabel.text = @"整单折扣";
                    self.oneCell.twoLabel.text = @"折";
                    self.oneCell.threeTextField.delegate = self;
                    //整单打折
                    [self.oneCell.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.oneCell;
                }
                
                if (indexPath.row == self.cellCount-5) {
                    
                    self.twoCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.twoCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.twoCell.oneLabel.text = @"本单实收";
                    self.twoCell.threeTextField.placeholder = @"0";
                    self.twoCell.threeTextField.tag = 2;
                    self.twoCell.threeTextField.delegate = self;
                    self.twoCell.threeTextField.textColor = [UIColor redColor];
                    self.twoCell.threeTextField.text = self.sumMoneyTwo;
                    double result = [self molingReceiveMoney:self.sumMoney];
                    if (self.isOpen == YES) {
//                         self.twoCell.fourLabel.hidden = NO;
//                        double zeroNumber = self.sumMoney - result;
//                        self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                    
                            self.twoCell.fourLabel.hidden = NO;
                            double zeroNumber = self.sumMoney - result;
                        self.zeroNumber = zeroNumber;
                            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                    
                    }else{
                       self.twoCell.fourLabel.hidden = YES;
                    }
                    //本单实收
                    [self.twoCell.threeTextField addTarget:self action:@selector(moneyFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.twoCell;
                }
                if (indexPath.row == self.cellCount-4) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *oneLabel = [[UILabel alloc]init];
                    oneLabel.text = @"销售人员";
                    oneLabel.textColor = RGBA(85, 85, 85, 1);
                    oneLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:oneLabel];
                    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell).offset(10);
                    }];
                    
                    UIImageView *img = [[UIImageView alloc]init];
                    img.image = [UIImage imageNamed:@"brithdaySmall"];
                    [cell.contentView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.right.mas_equalTo(cell).offset(-10);
                    }];
                    
                //    self.threeLabel = [[UILabel alloc]init];
//                    [SVUserManager loadUserInfo];
//                    self.sv_employee_id = [SVUserManager shareInstance].sv_employeeid;
//                    if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
//                        self.threeLabel.text = self.threeCellText;
//                    } else {
//                        self.threeLabel.text = [SVUserManager shareInstance].sv_employee_name;
//
//                    }
                    if (kStringIsEmpty(self.sv_employee_id)) {
                        self.threeLabel.text = @"选择销售人";
                    }else{
                        self.threeLabel.text =self.threeCellText;
                    }
                    self.threeLabel.textColor = GlobalFontColor;
                    self.threeLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:self.threeLabel];
                    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.right.mas_equalTo(img.mas_left).offset(-5);
                    }];
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-3) {
                    self.fourCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.fourCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.fourCell.oneLabel.text = @"备        注";
                    self.fourCell.threeTextField.placeholder = @"限制于100字";
                    self.fourCell.threeTextField.text = self.noteCellText;
                    self.fourCell.threeTextField.textColor = GlobalFontColor;
                    self.fourCell.threeTextField.tag = 3;
                    self.fourCell.threeTextField.delegate = self;
                    self.fourCell.threeTextField.keyboardType = UIKeyboardTypeDefault;
                    //本单实收
                    [self.fourCell.threeTextField addTarget:self action:@selector(noteFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.fourCell;
                    
                }
                
                if (indexPath.row == self.cellCount-2) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //  cell.userInteractionEnabled = NO;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenW - 20, 20)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = [UIColor colorWithHexString:@"555555"];
                    label.text = @"本单可用次卡";
                    [cell.contentView addSubview:label];
                    [cell.contentView addSubview:self.timeCollectionView];
                    
                    cell.backgroundColor = BackgroundColor;
                    return cell;
                }
                
                if (indexPath.row == self.cellCount - 1) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    
                    [cell.contentView addSubview:self.collectionView];
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    return cell;
                }
                
                
                
                SVSettlementCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutTwoID forIndexPath:indexPath];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"SVSettlementCommodityCell" owner:nil options:nil].lastObject;
                }
                //设置cell选中不高亮
                int i = (int)indexPath.row - 2;
                // cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.grade = self.grade;
                cell.sv_discount_configArray = self.sv_discount_configArray;
                cell.orderDetailsModel = self.modelArr[i];
                NSLog(@"self.modelArr434343 = %@",self.modelArr);
                return cell;
            }
            else{
                
                if (indexPath.row == 0) {
                    self.vipCell = [tableView dequeueReusableCellWithIdentifier:checkoutOneID forIndexPath:indexPath];
                    if (!self.vipCell) {
                        self.vipCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutOneCell" owner:nil options:nil].lastObject;
                    }
                    if (![SVTool isBlankString:self.member_id]) {
                        self.vipCell.vipView.hidden = YES;
                    } else {
                        self.vipCell.vipView.hidden = NO;
                    }
                    if (self.vipBool == YES) {
                        self.vipCell.deleteVipB.hidden = YES;
                    }
                    //设置cell选中不高亮
                    self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //设置view的圆角
                    self.vipCell.iconImg.layer.cornerRadius = 22.5;
                    //UIImageView切圆的时候就要用到这一句了
                    self.vipCell.iconImg.layer.masksToBounds = YES;
                    if (![SVTool isBlankString:self.headimg]) {
                        [self.vipCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                        self.vipCell.nameLabel.hidden = YES;
                    } else {
                        self.vipCell.nameLabel.text = [self.name substringToIndex:1];
                        self.vipCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                        self.vipCell.iconImg.image = [UIImage imageNamed:@"icon_black"];
                        self.vipCell.nameLabel.hidden = NO;
                    }
                    self.vipCell.vipName.text = self.name;
                    // self.vipCell.storedValue.text = self.stored;
                    self.vipCell.storedValue.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
                    self.vipCell.vipPhone.text = self.phone;
                     self.vipCell.integralLabel.text = [NSString stringWithFormat:@"积分：%.2f",self.member_Cumulative.doubleValue];
                    [self.vipCell.deleteVipB addTarget:self action:@selector(deleteVipBResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                    
                    return self.vipCell;
                }
                
                if (indexPath.row == 1 || indexPath.row == self.cellCount-10 || indexPath.row == self.cellCount-8) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.backgroundColor = BackgroundColor;
                    //设置cell不能点击
                    cell.userInteractionEnabled = NO;
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount-9) {
                    SVCheckoutThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutThreeID forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutThreeCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%d",self.sumCount];
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                    
                    if (self.modelArr.count < 4) {
                        cell.lookLabel.hidden = YES;
                    } else {
                        cell.lookLabel.hidden = NO;
                        if (self.isSelect == YES) {
                            cell.lookLabel.text = @"收起";
                        } else {
                            cell.lookLabel.text = @"更多";
                        }
                    }
                    
                    return cell;
                }
                
                if (indexPath.row == self.cellCount - 7) {
                    self.oneCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.oneCell) {
                        self.oneCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.oneCell.threeTextField.placeholder = @"10";
                    self.oneCell.threeTextField.text = self.oneCellText;
                   // self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.0f",self.oneCellText.doubleValue *10] ;
                    self.oneCell.threeTextField.textColor = GlobalFontColor;
                    self.oneCell.threeTextField.tag = 1;
                    self.oneCell.oneLabel.text = @"整单折扣";
                    self.oneCell.twoLabel.text = @"折";
                    self.oneCell.threeTextField.delegate = self;
                    //整单打折
                    [self.oneCell.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.oneCell;
                }
                
                if (indexPath.row == self.cellCount-6) {
                    
                    self.twoCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.twoCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.twoCell.oneLabel.text = @"本单实收";
                    self.twoCell.threeTextField.placeholder = @"0";
                    self.twoCell.threeTextField.tag = 2;
                    self.twoCell.threeTextField.delegate = self;
                    self.twoCell.threeTextField.textColor = [UIColor redColor];
                    self.twoCell.threeTextField.text = self.sumMoneyTwo;
                    double result = [self molingReceiveMoney:self.sumMoney];
                    if (self.isOpen == YES) {
//                         self.twoCell.fourLabel.hidden = NO;
//                        double zeroNumber = self.sumMoney - result;
//                        self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                        
                     
                            self.twoCell.fourLabel.hidden = NO;
                            double zeroNumber = self.sumMoney - result;
                        self.zeroNumber = zeroNumber;
                            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
                      
                    }else{
                       self.twoCell.fourLabel.hidden = YES;
                    }
                    //本单实收
                    [self.twoCell.threeTextField addTarget:self action:@selector(moneyFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.twoCell;
                }
                if (indexPath.row == self.cellCount-5) {
                    
                    self.IntegralDeductionCell = [tableView dequeueReusableCellWithIdentifier:IntegralDeductionCellID forIndexPath:indexPath];
                    if (!self.IntegralDeductionCell) {
                        self.IntegralDeductionCell = [[NSBundle mainBundle]loadNibNamed:@"SVIntegralDeductionCell" owner:nil options:nil].lastObject;
                    }
                    
                    self.IntegralDeductionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [self.IntegralDeductionCell.circleBtn addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                      [self.IntegralDeductionCell.integralBtn addTarget:self action:@selector(integralBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
//                    self.integralCount = self.member_Cumulative.integerValue / self.autoStr.integerValue;
                    NSLog(@"count = %ld",self.integralCount);
                    self.integralMoney = self.integralCount * self.autoStr.integerValue;
                    self.IntegralDeductionCell.textName.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%ld元",self.integralMoney,self.integralCount];
                    
                    return self.IntegralDeductionCell;

                }
                
                if (indexPath.row == self.cellCount-4) {
                    self.fourCell = [tableView dequeueReusableCellWithIdentifier:checkoutFourID forIndexPath:indexPath];
                    if (!self.fourCell) {
                        self.twoCell = [[NSBundle mainBundle]loadNibNamed:@"SVCheckoutFourCell" owner:nil options:nil].lastObject;
                    }
                    //设置cell选中不高亮
                    self.fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.fourCell.oneLabel.text = @"备        注";
                    self.fourCell.threeTextField.placeholder = @"限制于100字";
                    self.fourCell.threeTextField.text = self.noteCellText;
                    self.fourCell.threeTextField.textColor = GlobalFontColor;
                    self.fourCell.threeTextField.tag = 3;
                    self.fourCell.threeTextField.delegate = self;
                    self.fourCell.threeTextField.keyboardType = UIKeyboardTypeDefault;
                    //本单实收
                    [self.fourCell.threeTextField addTarget:self action:@selector(noteFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    return self.fourCell;
                    
                    


                }
                
                if (indexPath.row == self.cellCount-3) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    //设置cell选中不高亮
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *oneLabel = [[UILabel alloc]init];
                    oneLabel.text = @"销售人员";
                    oneLabel.textColor = RGBA(85, 85, 85, 1);
                    oneLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:oneLabel];
                    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell).offset(10);
                    }];
                    
                    UIImageView *img = [[UIImageView alloc]init];
                    img.image = [UIImage imageNamed:@"brithdaySmall"];
                    [cell.contentView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.right.mas_equalTo(cell).offset(-10);
                    }];
                    
                //    self.threeLabel = [[UILabel alloc]init];
//                    [SVUserManager loadUserInfo];
//                    self.sv_employee_id = [SVUserManager shareInstance].sv_employeeid;
//                    if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
//                        self.threeLabel.text = self.threeCellText;
//                    } else {
//                        self.threeLabel.text = [SVUserManager shareInstance].sv_employee_name;
//
//                    }
                   if (kStringIsEmpty(self.sv_employee_id)) {
                        self.threeLabel.text = @"选择销售人";
                    }else{
                        self.threeLabel.text =self.threeCellText;
                    }
                    self.threeLabel.textColor = GlobalFontColor;
                    self.threeLabel.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:self.threeLabel];
                    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.right.mas_equalTo(img.mas_left).offset(-5);
                    }];
                    
                    return cell;
                    
                   
                }
                
                if (indexPath.row == self.cellCount - 2) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //  cell.userInteractionEnabled = NO;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenW - 20, 20)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = [UIColor colorWithHexString:@"555555"];
                    label.text = @"本单可用次卡";
                    [cell.contentView addSubview:label];
                    [cell.contentView addSubview:self.timeCollectionView];
                    
                    cell.backgroundColor = BackgroundColor;
                    return cell;
                }
                
                if (indexPath.row == self.cellCount - 1) {

                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckoutCell"];
                    }
                    
                    [cell.contentView addSubview:self.collectionView];
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    return cell;
                }
                
                
                
                SVSettlementCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:checkoutTwoID forIndexPath:indexPath];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"SVSettlementCommodityCell" owner:nil options:nil].lastObject;
                }
                //设置cell选中不高亮
                int i = (int)indexPath.row - 2;
                // cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.grade = self.grade;
                cell.sv_discount_configArray = self.sv_discount_configArray;
                cell.orderDetailsModel = self.modelArr[i];
                NSLog(@"self.modelArr434343 = %@",self.modelArr);
                return cell;
               // return self.cellCount + 1;
            }

       
    }
    
}

#pragma mark - 点击积分按钮
- (void)integralBtnClick{
    if (self.IntegralDeductionCell.circleBtn.selected == YES) {
        self.IntegralDeductionCell.circleBtn.selected = !self.IntegralDeductionCell.circleBtn.selected;
            [self.IntegralDeductionCell.circleBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
        self.IntegralDeductionCell.integralView.hidden = YES;
            double money = self.sumMoneyTwo.doubleValue + self.integralCount;
            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",money];
//            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",money] forState:UIControlStateNormal];
        self.isSelectIntegralCircle = NO;
        self.integral = nil;
        [self.tableView reloadData];
    }
    
     [self.IntegralInputVIew.textFiled becomeFirstResponder];// 2
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.IntegralInputVIew];
}

#pragma mark - 抵扣积分圈圈点击
- (void)circleBtnClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.isSelectIntegralCircle = YES;
        [self.IntegralDeductionCell.circleBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateNormal];
        if (self.integralCount > self.sumMoneyTwo.integerValue) {
          //  double money = 0.0;
            NSInteger integralMoney = self.sumMoneyTwo.integerValue;
           // self.integralMoneyTwo = integralMoney;
            double integral = self.sumMoneyTwo.doubleValue;
            self.IntegralDeductionCell.integralLabel.text = [NSString stringWithFormat:@"积分抵扣%ld元",integralMoney];
            self.IntegralDeductionCell.integralView.hidden = NO;
            self.integralCount = integralMoney;
            /**
             积分抵扣字段
             */
            self.integral = [NSString stringWithFormat:@"%ld",integralMoney];
            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",integral - integralMoney];
//            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",integral - integralMoney] forState:UIControlStateNormal];
        }else{
            self.isSelectIntegralCircle = YES;
            double money = self.sumMoneyTwo.doubleValue - self.integralCount;
            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",money];
//            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",money] forState:UIControlStateNormal];
            self.IntegralDeductionCell.integralLabel.text = [NSString stringWithFormat:@"积分抵扣%ld元",self.integralCount];
            /**
             积分抵扣字段
             */
            self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
            
            self.IntegralDeductionCell.integralView.hidden = NO;
        }
       
        
       // self.SMS = NO;
        [self.tableView reloadData];
    } else {
        self.integral = nil;
            self.isSelectIntegralCircle = NO;
            [self.IntegralDeductionCell.circleBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
            
            double money = self.sumMoneyTwo.doubleValue + self.integralCount;
            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",money];
//            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",money] forState:UIControlStateNormal];
            self.IntegralDeductionCell.integralView.hidden = YES;

        // self.SMS = NO;
        [self.tableView reloadData];
       // self.SMS = YES;
        
    }
}



- (UIButton *)icon_button
{
    if (_icon_button == nil) {
        _icon_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon_button.frame = CGRectMake(
                                        ScreenW /2 - 20, CGRectGetMaxY(_PrintingCollectionView.frame) - 20, 40, 40);
        [_icon_button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_icon_button addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _icon_button;
}


#pragma mark - 点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
    NSString *whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];
  
    if (kArrayIsEmpty(self.timesCountArr)) {
            if (kStringIsEmpty(self.member_Cumulative)) {
                if (2 <=indexPath.row && indexPath.row < self.cellCount-8) {
                    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView_two];
                    NSInteger count = indexPath.row -2;
                    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                    [self.PrintingCollectionView reloadData];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                }
            }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                if (2 <=indexPath.row && indexPath.row < self.cellCount-8) {
                    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView_two];
                    NSInteger count = indexPath.row -2;
                    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                    [self.PrintingCollectionView reloadData];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                }
            }
            else{
                if (2 <=indexPath.row && indexPath.row < self.cellCount-9) {
                    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView_two];
                    NSInteger count = indexPath.row -2;
                    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                    [self.PrintingCollectionView reloadData];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                }
            }
      
    }else{
        
            if (kStringIsEmpty(self.member_Cumulative)) {
                if (2 <=indexPath.row && indexPath.row < self.cellCount-9) {
                    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView_two];
                    NSInteger count = indexPath.row -2;
                    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                    [self.PrintingCollectionView reloadData];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                }
            }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                if (2 <=indexPath.row && indexPath.row < self.cellCount-9) {
                    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView_two];
                    NSInteger count = indexPath.row -2;
                    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                    [self.PrintingCollectionView reloadData];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                }
            }
            else{
                if (2 <=indexPath.row && indexPath.row < self.cellCount-10) {
                    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView_two];
                    NSInteger count = indexPath.row -2;
                    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                    [self.PrintingCollectionView reloadData];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                }
            }
        
    
    }
    
    
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row == 0 && self.vipBool == NO) {
        SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        //        VC.vipBlock = ^(NSString *name,NSString *phone,NSString *level,NSString *discount,NSString *member_id,NSString *storedValue,NSString *headimg,NSString *sv_mr_cardno,NSString *sv_mw_availablepoint){
        //
        //
        //
        //
        //        };
        
       
        #pragma mark - 点击会员回调
        VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
            for (NSDictionary *dict in self.getUserLevelArray) {
                NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                    NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                    NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                    if (data != NULL) {
                         self.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                        NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
                    }
                    
                    break;
                }
            }
            weakSelf.name = name;
            weakSelf.phone = phone;
            if ([SVTool isBlankString:discount]) {
                discount = @"0";
            }else{
                weakSelf.discount = discount;
            }
          //  weakSelf.grade = grade;
//            if ([SVUserManager shareInstance].rankPromotion_sv_detail_is_enable.doubleValue == 1) { // 开关开了
                weakSelf.grade = grade;
//            }else{
//                weakSelf.grade = nil;
//            }
            weakSelf.member_id = member_id;
            weakSelf.stored = storedValue;
            weakSelf.headimg = headimg;
            weakSelf.sv_mr_cardno = sv_mr_cardno;
            weakSelf.member_Cumulative = sv_mw_availablepoint;
            weakSelf.sv_mr_pwd = sv_mr_pwd;
            if (self.chooseMemberBlock) {
                self.chooseMemberBlock(name, phone, level, discount, member_id, storedValue, headimg, sv_mr_cardno,sv_mw_availablepoint,grade,ClassifiedBookArray,memberlevel_id);
            }
            // 次卡
            [self loadUserMemberId:member_id];
            
            [weakSelf.modelArr removeAllObjects];
            weakSelf.sumCount = 0;
            weakSelf.sumMoney = 0;
            for (NSMutableDictionary *dict in weakSelf.resultArr) {
                //会员ID
                if (![SVTool isBlankString:weakSelf.member_id]) {
                    [dict setObject:member_id forKey:@"member_id"];
                    
                    [dict setObject:discount forKey:@"discount"];
                } else {
                    [dict setObject:@"" forKey:@"member_id"];
                    [dict setObject:@"" forKey:@"discount"];
                }
                
                [self optimizeSettlementDict:dict];
            }
            weakSelf.oneCellText = nil;
            
            double result = [self molingReceiveMoney:self.sumMoney];
               if (self.isOpen == YES) {
//                   [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",result] forState:UIControlStateNormal];
                   self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",result];
               }else{
//                   self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//                   [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",self.sumMoney] forState:UIControlStateNormal];
                   weakSelf.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",weakSelf.sumMoney];
//                   [weakSelf.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",weakSelf.sumMoney] forState:UIControlStateNormal];
               }
            
            
            weakSelf.integralCount = weakSelf.member_Cumulative.integerValue / weakSelf.autoStr.integerValue;
            [weakSelf.tableView reloadData];
            [weakSelf.collectionView reloadData];
            
            if (self.titleArr_member.count <= 0) {
                self.collectionView.frame = CGRectMake(0, 0, ScreenW, 163);
            }else{
                int num = (int) ceil(self.titleArr_member.count / 4.0);
                self.collectionView.frame = CGRectMake(0, 0, ScreenW, num * 80 + num + 1);
            }
            
//            if (![SVTool isBlankString:self.member_id]){
//
//                for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
//                    if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
//                        self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
//                        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
//                        [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                        break;
//                    }else{
////                        self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
////                        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                        [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                    }
//                    //                        }
//
//                }
//
//            }else{
//                //刷新后，再设置默认选中，才有效果
////                weakSelf.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
////                NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                [weakSelf.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//            }
        };
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (kArrayIsEmpty(self.timesCountArr)) {
        if (kStringIsEmpty(self.member_Cumulative)) {
            if (indexPath.row == self.cellCount-3) {
                [self operatorResponseEvent];
            }
            
            if (indexPath.row == self.cellCount-7) {
                self.isSelect = !self.isSelect;
                [self.tableView reloadData];
            }
        }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
            if (indexPath.row == self.cellCount-3) {
                [self operatorResponseEvent];
            }
            
            if (indexPath.row == self.cellCount-7) {
                self.isSelect = !self.isSelect;
                [self.tableView reloadData];
            }
        }
        else{
            if (indexPath.row == self.cellCount-3) {
                [self operatorResponseEvent];
            }
            
            if (indexPath.row == self.cellCount-8) {
                self.isSelect = !self.isSelect;
                [self.tableView reloadData];
            }
        }
      
    }else{
        
            if (kStringIsEmpty(self.member_Cumulative)) {
                if (indexPath.row == self.cellCount-4) {
                    [self operatorResponseEvent];
                }
                
                if (indexPath.row == self.cellCount-8) {
                    self.isSelect = !self.isSelect;
                    [self.tableView reloadData];
                }
            }else if (self.member_Cumulative.doubleValue < autoStr.doubleValue || [whether isEqualToString:@"0"]){
                if (indexPath.row == self.cellCount-4) {
                    [self operatorResponseEvent];
                }
                
                if (indexPath.row == self.cellCount-8) {
                    self.isSelect = !self.isSelect;
                    [self.tableView reloadData];
                }
            }
            else{
                if (indexPath.row == self.cellCount-3) {
                    [self operatorResponseEvent];
                }
                
                if (indexPath.row == self.cellCount-9) {
                    self.isSelect = !self.isSelect;
                    [self.tableView reloadData];
                }
            }
        //        indexPath.row == self.cellCount-2
     
        
    }
    
}

#pragma mark - 加载计次卡
- (void)loadUserMemberId:(NSString *)memberId{
    
    [self.timesCountArr removeAllObjects];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/ACharge?key=%@&id=%@",[SVUserManager shareInstance].access_token,memberId];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *timesCountArr = [SVSettlementTimesCountModel mj_objectArrayWithKeyValuesArray:dic[@"values"]];
        NSLog(@"dic6666 = %@",dic);
        for (NSInteger i = 0; i < self.resultArr.count; i++) {
            NSString *product_id = self.resultArr[i][@"product_id"];
            // NSLog(@"product_id = %@",product_id);
            // NSDate *currentDate = [NSDate date];
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
            NSString *str = [formatter stringFromDate:date];
            for (SVSettlementTimesCountModel *model in timesCountArr) {
                NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
                [dateformater setDateFormat:@"yyyy-MM-dd"];
                NSDate *dta = [[NSDate alloc] init];
                NSDate *dtb = [[NSDate alloc] init];
                
                dta = [dateformater dateFromString:str];
                NSString *string = [model.validity_date substringToIndex:10];//（length为7）
                dtb = [dateformater dateFromString:string];
                NSComparisonResult result = [dta compare:dtb];
                
                if (model.product_id == [product_id integerValue] && model.sv_mcc_leftcount > 0 &&(result!=NSOrderedDescending)) {
                    NSMutableDictionary *dic = self.resultArr[i];
                    [dic setObject:model.sv_p_name forKey:@"sv_p_name_cikaName"];
                    [dic setObject:[NSString stringWithFormat:@"%ld",model.sv_mcc_leftcount] forKey:@"sv_mcc_leftcount"];
                    [dic setObject:[NSString stringWithFormat:@"%ld",model.product_id] forKey:@"product_id_cikaName"];
                    self.resultArr[i] = dic;
                    [self.timesCountArr addObject:model];
                }
            }
            
        }
        
        NSLog(@"self.timesCountArr = %@",self.timesCountArr);
        
        NSLog(@"self.resultArr6666 = %@",self.resultArr);
        
        // self.timesCountArr = timesCountArr;
        //  [self.timesCountArr addObjectsFromArray:timesCountArr];
        if (!kArrayIsEmpty(self.timesCountArr)) {
            //实现多选必须实现这个方法
            self.timeCollectionView.allowsMultipleSelection = YES;
            //            self.indexPathRow = 0;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            //设置垂直间距
            layout.minimumLineSpacing = 10;
            //设置水平间距
            layout.minimumInteritemSpacing = 0;
            
            int num = (int) ceil(self.timesCountArr.count / 2.0);
            self.timeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, ScreenW, num * 80 + num *10 + 10) collectionViewLayout:layout];
            self.timeCollectionView.backgroundColor = BackgroundColor;
            //指定collectionview代理
            self.timeCollectionView.delegate = self;
            self.timeCollectionView.dataSource = self;
            //注册collectionView的cell
            [self.timeCollectionView registerNib:[UINib nibWithNibName:@"SVTimingCardCell" bundle:nil] forCellWithReuseIdentifier:TimingCardCellID];
            
            [self.timeCollectionView reloadData];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 删除会员
- (void)deleteVipBResponseEvent {
    self.name = nil;
    self.phone = nil;
    self.discount = nil;
    self.member_id = nil;
    self.stored = nil;
    self.headimg = nil;
    self.sv_mr_cardno = nil;
    self.oneCellText = nil;
    self.member_Cumulative = nil;
    self.sv_mr_pwd = nil;
    self.grade = nil;
    self.sv_discount_configArray = nil;
    
    [self data];
    int num = (int) ceil(self.vipTitleArr.count / 4.0);
    self.collectionView.frame = CGRectMake(0, 0, ScreenW, num * 80 + num + 1);
    [self.timesCountArr removeAllObjects];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    //    self.payName = @"现金";
    //    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if (self.deleteMemberBlock) {
        self.deleteMemberBlock();
    }
    if (![SVTool isBlankString:self.member_id]){
        //刷新后，再设置默认选中，才有效果
        for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
            if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
                self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
                NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                break;
            }else{
//                self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
//                NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }else{
        
        // [self.modelArr removeAllObjects];
        // [self.timesCountArr removeAllObjects];
        [self loadUserMemberId:self.member_id];
        // [self.modelArr removeAllObjects];
        
        [self.vipTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"储值卡"]) {
                [self.vipTitleArr removeObject:@"储值卡"];
                [self.vipTitleImg removeObject:@"sales_stored"];
            }else if ([obj isEqualToString:@"赊账"]){
                [self.vipTitleArr removeObject:@"赊账"];
                [self.vipTitleImg removeObject:@"sales_owe"];
            }
        }];
        
//        if (kArrayIsEmpty(self.vipTitleArr)) {
//
//        }else{
//            self.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
//        }
//
//        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
    }
}

//单位
-(void)operatorResponseEvent{
    
    //退出编辑状态
    [self.tableView endEditing:YES];
    
    //pickerView指定代理
    self.pickerView.unitPicker.delegate = self;
    self.pickerView.unitPicker.dataSource = self;
    
    //为空是提示
    //    if ([SVTool isEmpty:self.pickViewArr]) {
    //        [SVTool TextButtonAction:self.view withSing:@"单位数据为空，可到电脑端添加单位"];
    //        return;
    //    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    
}


#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
    
    if (kArrayIsEmpty(self.timesCountArr)) {
        if (collectionView == self.collectionView) {
            if (![SVTool isBlankString:self.member_id]) { // 是会员
                
                return self.titleArr_member.count;
                
            }else{
                return self.vipTitleArr.count;
            }
        }else if (collectionView == self.PrintingCollectionView){
            return self.modelArr.count;
        }else{
            return self.timesCountArr.count;
        }
    }else{
        if (collectionView == self.timeCollectionView) {
            return self.timesCountArr.count;
        }else if (collectionView == self.PrintingCollectionView){
            return self.modelArr.count;
        }else{
            if (![SVTool isBlankString:self.member_id]) { // 是会员
                
                return self.titleArr_member.count;
                
            }else{
                return self.vipTitleArr.count;
            }
        }
    }
    
    
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - 每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        SVHomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CheckoutPayID forIndexPath:indexPath];
        
        if (![SVTool isBlankString:self.member_id]) {
            cell.titleLabel.text = self.titleArr_member[indexPath.item];
            cell.img.image = [UIImage imageNamed:self.iconArr_member[indexPath.item]];
            
            //cell.backgroundColor = [UIColor colorWithRed:((double)arc4random_uniform(256) / 255.0) green:((double)arc4random_uniform(256) / 255.0) blue:((double)arc4random_uniform(256) / 255.0) alpha:1.0];
            if (cell.isSelected) {
                cell.backgroundColor = clickButtonBackgroundColor;
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }else{
            
            if (kArrayIsEmpty(self.vipTitleArr)){
                
            }else{
                cell.titleLabel.text = self.vipTitleArr[indexPath.item];
                cell.img.image = [UIImage imageNamed:self.vipTitleImg[indexPath.item]];
            }
            
            
            //cell.backgroundColor = [UIColor colorWithRed:((double)arc4random_uniform(256) / 255.0) green:((double)arc4random_uniform(256) / 255.0) blue:((double)arc4random_uniform(256) / 255.0) alpha:1.0];
            if (cell.isSelected) {
                cell.backgroundColor = clickButtonBackgroundColor;
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        
        
        return cell;
    }else if (collectionView == self.PrintingCollectionView){
        
        
      //  SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
        
        SVPriceRevisionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
        cell.dict = self.resultArr[indexPath.row];
        cell.sureBtn.tag = indexPath.row;
        __weak typeof(self) weakSelf = self;
        cell.sureBtnClickBlock_dict = ^(NSInteger selctCount, NSMutableDictionary * _Nonnull dict) {
            if (selctCount+ 1 == weakSelf.resultArr.count) {
                //  [self.modelArr removeAllObjects];
                [weakSelf.resultArr replaceObjectAtIndex:selctCount withObject:dict];
                //                self.modelArr = [SVOrderDetailsModel mj_objectArrayWithKeyValuesArray:weakSelf.resultArr];
               
                [weakSelf handlePan];
                //             [weakSelf.PrintingCollectionView reloadData];
            }else{
                [weakSelf.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                // [weakSelf.PrintingCollectionView reloadData];
            }
        };

        return cell;
        
    }else{
        //这里？更改的地方 SVSelectedGoodsModel
        __weak typeof(self) weakSelf = self;
        SVTimingCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TimingCardCellID forIndexPath:indexPath];
        
        cell.model = self.timesCountArr[indexPath.row];
        //  cell.dic = self.resultArr[indexPath.row];
        
        cell.selctModelBlock = ^(SVSettlementTimesCountModel *model) {
            int sumCount = 0;
            double sumMoney = 0;
            //   NSInteger moreThanCount = 0;
            if (weakSelf.goodsArr.count == 0 && [model.selectIndex isEqualToString:@"1"]) {// 数组为空是添加
                [weakSelf.goodsArr addObject:model];
                
                
            }else{
                for (SVSettlementTimesCountModel *modell in weakSelf.goodsArr) {
                    if (modell.product_id == model.product_id) {
                        [weakSelf.goodsArr removeObject:modell];
                        break;
                    }
                }
                
                // 当计次卡次数不为零时添加
                if ([model.selectIndex isEqualToString:@"1"]) {
                    [weakSelf.goodsArr addObject:model];
                }
                
            }
            
            NSLog(@"weakSelf.goodsArr = %@",weakSelf.goodsArr);
            NSLog(@"weakSelf.resultArr = %@",weakSelf.resultArr);
            
            if (weakSelf.goodsArr.count > 0) {
                
                for (NSMutableDictionary *dic in weakSelf.resultArr) {
                    BOOL flag = false;
                    // BOOL moreFlag = false;
                    for (SVSettlementTimesCountModel *modeTwo in weakSelf.goodsArr) {
                        
                        if ([dic[@"product_id_cikaName"] integerValue] == modeTwo.product_id &&!flag) {
                            // 用来记录商品是否用了次卡
                            dic[@"isTimeCare"] = @"1";
                            if (kStringIsEmpty(modeTwo.sv_serialnumber)) {
                                dic[@"sv_serialnumber"] = @"";
                            }else{
                                dic[@"sv_serialnumber"] = modeTwo.sv_serialnumber;
                            }
                            
                            if (kStringIsEmpty(modeTwo.userecord_id)) {
                                dic[@"userecord_id"] = @"";
                            }else{
                                dic[@"userecord_id"] = modeTwo.userecord_id;
                            }

                            flag = true;
                            
                            NSLog(@"1111");
                            
              
                        }
                        
                    }
                    if (!flag) {
                        // 用来记录商品是否用了次卡
                        dic[@"isTimeCare"] = @"0";
                        // 计算价格
                        NSLog(@"非计次卡的条目");
                        sumCount += [dic[@"product_num"] intValue];
                        NSLog(@"sumCount = %d",weakSelf.sumCount);
                        double money;
                        //单价
                        double grade = 0.0;
                        if (!kStringIsEmpty(self.grade)) {
                            if ([self.grade isEqualToString:@"1"]) {
                                grade=[dic[@"sv_p_memberprice1"] doubleValue];
                            }else if ([self.grade isEqualToString:@"2"]){
                                grade=[dic[@"sv_p_memberprice2"] doubleValue];
                            }else if ([self.grade isEqualToString:@"3"]){
                                grade=[dic[@"sv_p_memberprice3"] doubleValue];
                            }else if ([self.grade isEqualToString:@"4"]){
                                grade=[dic[@"sv_p_memberprice4"] doubleValue];
                            }else {
                                grade=[dic[@"sv_p_memberprice5"] doubleValue];
                            }
                        }
                        if ([dic[@"isPriceChange"] isEqualToString:@"1"]) {// 是改价那边来的
                            money = [dic[@"sv_p_unitprice"] doubleValue];
                        }else{
                            if (grade > 0) {
                                money = grade;
                            }else{
                                if ([SVTool isBlankString:weakSelf.member_id]) {
                                    money = [dic[@"sv_p_unitprice"] doubleValue];
                                } else {
                                    if ([dic[@"sv_p_memberprice"] doubleValue] > 0) {
                                        money = [dic[@"sv_p_memberprice"] doubleValue];
                                    } else if ([dic[@"sv_p_memberprice"] doubleValue] == 0) {
                                        if ([weakSelf.discount doubleValue] == 0) {
                                            money = [dic[@"sv_p_unitprice"] doubleValue];
                                        } else {
                                            money = [dic[@"sv_p_unitprice"] doubleValue]*[weakSelf.discount doubleValue]*0.1;
                                        }
                                    } else {
                                        money = [dic[@"sv_p_unitprice"] doubleValue];
                                    }
                                }
                            }
                       
                        }
                       
                        NSLog(@"money = %f",money);
                        sumMoney += [dic[@"product_num"] integerValue] * money;
                        
                        NSLog(@"sumMoney6565 = %f",sumMoney);
                    }
                    
                    
                }
                double totleMoney = 0.0;
                if (self.IntegralDeductionCell.circleBtn.selected == YES) {
                    totleMoney = sumMoney - self.integralCount;
                }else{
                    totleMoney = sumMoney;
                }
                weakSelf.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",totleMoney];
//                [weakSelf.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",totleMoney] forState:UIControlStateNormal];
                
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf data];
                [weakSelf.tableView reloadData];
            }
            
        };
        
        return cell;
    }
    
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        return CGSizeMake((ScreenW-3)/4, 80);
    }else if (collectionView == self.PrintingCollectionView){
        return CGSizeMake(ScreenW / 4 *3, 470);
    }else{
        return CGSizeMake((ScreenW-30)/2, 80);
    }
    
}
//self.minimumLineSpacing = 30;
//self.sectionInset = UIEdgeInsetsMake(40, 35, 0, 35);
//定义每个UICollectionView 的边距
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake (1,0,0,0);
    }else if (collectionView == self.PrintingCollectionView){
        return UIEdgeInsetsMake(40, 35, 0, 35);
    }
    else{
        return UIEdgeInsetsMake (10,10,10,10);
    }
    
}

//当你取消某项的选择的时候来触发
- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        //        SVTimingCardCell* cell = (SVTimingCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //        cell.iconImage.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
}

#pragma mark - 点击跳转方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        [self.selectMoneyArray removeAllObjects];
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        if (cell.isSelected) {
            cell.backgroundColor = clickButtonBackgroundColor;
        }
        
        if ([SVTool isBlankString:self.member_id]) {//  没有选择会员的时候
            self.payName = self.vipTitleArr[indexPath.row];
            if ([self.vipTitleArr[indexPath.row] isEqualToString:@"支付宝"]) {
                if ([self.sv_enable_alipay isEqualToString:@"1"]){
                   // self.payName = @"扫码支付";
                    [self Scan];
                }else{
                    self.payName = @"支付宝记账";
                    [self footerNext];
                }
            }else if([self.vipTitleArr[indexPath.row] isEqualToString:@"微信"]) {
                if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
                  //  self.payName = @"扫码支付";
                    [self Scan];
                }else{
                    self.payName = @"微信记账";
                    [self footerNext];
                }
            }else if ([self.vipTitleArr[indexPath.row] isEqualToString:@"扫码支付"]) {
              //  self.payName = @"扫码支付";
                [self Scan];
            }else if ([self.vipTitleArr[indexPath.row] isEqualToString:@"优惠券"]) {
                SVCouponListVC *vc = [[SVCouponListVC alloc] init];
                vc.totle_money = self.twoCell.threeTextField.text;
                vc.selIndex = self.selIndex;
                vc.member_id = self.member_id;
                [self.navigationController pushViewController:vc animated:YES];
                
                [self.collectionView reloadData];

                if (![SVTool isBlankString:self.member_id]){
                    
                    for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
                        if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                            break;
                        }else{
                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                        }
                        //                        }
                        
                    }
                    
                }else{
                    //刷新后，再设置默认选中，才有效果
                    self.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
                    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }

                vc.couponBlock = ^(SVCouponListModel * _Nonnull model, NSIndexPath * _Nonnull selectIndex) {
                    self.selIndex = selectIndex;
                    if ([model.sv_coupon_type isEqualToString:@"0"]) {// 代金券
                        // footerButton
                        if (model.sv_coupon_money.doubleValue > self.twoCell.threeTextField.text.doubleValue) {// 如果优惠金额大于实收金额
                            NSString *coupon_money;
                            self.sumMoneyTwo = @"0";
                            coupon_money = @"0";
                            
                            // double discount = (coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
                            self.oneCell.threeTextField.text = @"0.00";
                            
                            self.oneCellText = @"0";
                            
//                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",@"0"] forState:UIControlStateNormal];
                        }else{
                            NSString *coupon_money;
                            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
                            coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
                            
                            double discount = (coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
                            self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",discount *10];
                            
                            self.oneCellText = [NSString stringWithFormat:@"%.4f",discount *10];
                            
//                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
                            
                            
                        }
                        
                        self.sv_coupon_amount = model.sv_coupon_money;
                        self.sv_record_id = model.sv_record_id;
                        
                    }else{// 折扣卷
                        //  self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01;
                        NSString *coupon_money;
                        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
                        coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
                        
                        self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",coupon_money.doubleValue];
                        
                        self.oneCellText = [NSString stringWithFormat:@"%.2f",[self.oneCell.threeTextField.text doubleValue] * 0.1];
                        
//                        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
                        self.sv_coupon_discount = model.sv_coupon_money;
                        self.sv_record_id = model.sv_record_id;
                        
                        //  self.couponListModel = model;
                    }
                };
                
                
            }else{
                [self footerNext];
            }
            
            
            
        }else{
            self.payName = self.titleArr_member[indexPath.row];
            
            if ([self.titleArr_member[indexPath.row] isEqualToString:@"支付宝"]) {
                if ([self.sv_enable_alipay isEqualToString:@"1"]){
                    self.payName = @"扫码支付";
                    [self Scan];
                }else{
                    self.payName = @"支付宝记账";
                    [self footerNext];
                }
            }else if ([self.titleArr_member[indexPath.row] isEqualToString:@"微信"]) {
                if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
                    self.payName = @"扫码支付";
                    [self Scan];
                }else{
                    self.payName = @"微信记账";
                    [self footerNext];
                }
            }else if ([self.titleArr_member[indexPath.row] isEqualToString:@"扫码支付"]) {
                self.payName = @"扫码支付";
                [self Scan];

            }else if ([self.titleArr_member[indexPath.row] isEqualToString:@"优惠券"]) {

                SVCouponListVC *vc = [[SVCouponListVC alloc] init];
                vc.totle_money = self.twoCell.threeTextField.text;
                vc.member_id = self.member_id;
                vc.selIndex = self.selIndex;
                [self.navigationController pushViewController:vc animated:YES];
                //  vc.model = self.couponListModel;
                [self.collectionView reloadData];
//                if (![SVTool isBlankString:self.member_id]){
//
//                    for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
//                        if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
//                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
//                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
//                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                            break;
//                        }else{
////                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
////                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                        }
//                        //                        }
//
//                    }
//
//                }else{
//                    //刷新后，再设置默认选中，才有效果
////                    self.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
////                    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                    [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                }
                
                vc.couponBlock = ^(SVCouponListModel * _Nonnull model, NSIndexPath * _Nonnull selectIndex) {
                    self.selIndex = selectIndex;
                    if ([model.sv_coupon_type isEqualToString:@"0"]) {// 代金券
                        // footerButton
                        
                        if (model.sv_coupon_money.doubleValue > self.twoCell.threeTextField.text.doubleValue) {// 如果优惠金额大于实收金额
                            NSString *coupon_money;
                            self.sumMoneyTwo = @"0";
                            coupon_money = @"0";
                            
                            // double discount = (coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
                            self.oneCell.threeTextField.text = @"0.00";
                            
                            self.oneCellText = @"0";
                            
//                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",@"0"] forState:UIControlStateNormal];
                            
                        }else{
                            NSString *coupon_money;
                            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
                            coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
                            
                            // double discount = (model.sv_coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
                            double discount = (coupon_money.doubleValue / self.sumMoney);
                            self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",discount *10];
                            self.oneCellText =[NSString stringWithFormat:@"%.4f",discount *10];
                            
                          //  [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
                            
                            self.twoCell.threeTextField.text = coupon_money;

                            // @property (nonatomic,strong) NSString *sv_coupon_amount;
                            //  @property (nonatomic,strong) NSString *sv_coupon_discount;
                            // self.couponListModel = model;
                            
                        }
                        
                        self.sv_coupon_amount = model.sv_coupon_money;
                        self.sv_record_id = model.sv_record_id;
                        
                    }else{// 折扣卷
                        //  self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01;
                        NSString *coupon_money;
                        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
                        coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
                        
                        // self.oneCell.threeTextField.text = model.sv_coupon_money;
                        self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",model.sv_coupon_money.doubleValue *0.1];

                        self.oneCellText = [NSString stringWithFormat:@"%.2f",[self.oneCell.threeTextField.text doubleValue]];
                      //  [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
//=======
//                        self.oneCellText = [NSString stringWithFormat:@"%.2f",[self.oneCell.threeTextField.text doubleValue] * 0.1];
////                        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
//>>>>>>> origin/oem_deduction_zuhezhifu
                        self.sv_coupon_discount = model.sv_coupon_money;
                        self.sv_record_id = model.sv_record_id;
                        
                        //  self.couponListModel = model;
                    }
                };
      
            }else{
                [self footerNext];
            }
        }
    }else if (collectionView == self.PrintingCollectionView){
        
    }else{
        if (self.isSelectIntegralCircle == NO) {
            SVTimingCardCell* cell = (SVTimingCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
            //cell.model = self.timesCountArr[indexPath.row];
            SVSettlementTimesCountModel *model = self.timesCountArr[indexPath.row];
            
            for (NSMutableDictionary *dic in self.resultArr) {
                if ([dic[@"product_id_cikaName"] integerValue] == model.product_id) {
                    
                    if ([model.selectIndex isEqualToString:@"1"]) {
                        model.sv_mcc_leftcount = model.sv_mcc_leftcount + [dic[@"product_num"] integerValue];
                        model.selectIndex = @"0";
                    }else{
                        if ([dic[@"product_num"] integerValue] > model.sv_mcc_leftcount) {
                            [SVTool TextButtonAction:self.view withSing:@"商品数多于次卡数量"];
                        }else{
                            model.sv_mcc_leftcount = model.sv_mcc_leftcount - [dic[@"product_num"] integerValue];
                            model.selectIndex = @"1";
                        }
                        
                    }
                }
                
            }
            cell.model = model;
        }else{
            ALERT(@"请先用次卡，再用积分抵扣");
        }
    }
    
}

#pragma mark - 整单打折
-(void)textFieldDidChange :(UITextField *)theTextField{
   
    if ([theTextField isEqual:self.oneCell.threeTextField]) {
        if ([SVTool isBlankString:theTextField.text]) {
//            self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//            double result = [self molingReceiveMoney:self.sumMoney];
            
            NSString *money = [NSString stringWithFormat:@"%.2f",self.sumMoney];
            double result = [self molingReceiveMoney:money.doubleValue];
            if (self.isOpen == YES) {
                 self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",result];
                //            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",self.twoCell.threeTextField.text] forState:UIControlStateNormal];
                //            self.sumMoneyTwo = self.twoCell.threeTextField.text;
//                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",result] forState:UIControlStateNormal];
                            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",result];
                            
                            double zeroNumber = money.doubleValue - result;
                self.zeroNumber = zeroNumber;
                self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
            }else{
//                self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//                [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",self.twoCell.threeTextField.text] forState:UIControlStateNormal];
                self.sumMoneyTwo = self.twoCell.threeTextField.text;
            }
           
           
        } else {
            NSString *money = [NSString stringWithFormat:@"%.2f",self.sumMoney * [theTextField.text doubleValue] * 0.1];
            double result = [self molingReceiveMoney:money.doubleValue];
//            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",self.twoCell.threeTextField.text] forState:UIControlStateNormal];
//            self.sumMoneyTwo = self.twoCell.threeTextField.text;
            
            if (self.isOpen == YES) {
                self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",result];
//                  [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",result] forState:UIControlStateNormal];
                  self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",result];
                  
                //  double result = [self molingReceiveMoney:self.sumMoney];
                  double zeroNumber = money.doubleValue - result;
                self.zeroNumber = zeroNumber;
                  self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
            }else{
                self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",self.sumMoney * [theTextField.text doubleValue] * 0.1];
//                [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",self.twoCell.threeTextField.text] forState:UIControlStateNormal];
                self.sumMoneyTwo = self.twoCell.threeTextField.text;
            }
            
        }
        self.oneCellText = [NSString stringWithFormat:@"%.2f",[theTextField.text doubleValue]];
        NSLog(@"self.oneCellText = %@",self.oneCellText);
    }
}

#pragma mark - 本单实收
-(void)moneyFieldDidChange :(UITextField *)theTextField{
   
    if ([theTextField isEqual:self.twoCell.threeTextField]) {
        self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.3f",[theTextField.text doubleValue] / self.sumMoney  * 10];
        /**
         没有四舍五入的整单折扣
         */
        //        self.WholeSingleDiscount = [NSString stringWithFormat:@"%.25f", [theTextField.text doubleValue] / self.sumMoney];
      // double result = [self molingReceiveMoney:self.twoCell.threeTextField.text.doubleValue];
//        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",self.twoCell.threeTextField.text] forState:UIControlStateNormal];
        self.sumMoneyTwo = theTextField.text;
        
        //        NSLog(@"self.oneCell.threeTextField.text = %@",self.oneCell.threeTextField.text);
       // double zekou = [self.oneCell.threeTextField.text doubleValue] *0.1;
        // NSLog(@"zekou = %f",zekou);
        double zekou = [self.oneCell.threeTextField.text doubleValue];
        NSString *zekouStr = [NSString stringWithFormat:@"%f",zekou];
        //  NSLog(@"zekouStr = %@",zekouStr);
        self.oneCellText = zekouStr;
        NSLog(@"self.oneCellText = %@",self.oneCellText);
    }
}

-(void)noteFieldDidChange:(UITextField *)theTextField {
    if ([theTextField isEqual:self.fourCell.threeTextField]) {
        self.noteCellText = theTextField.text;
    }
}


//限制只能输入一定长度的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        if ([textField isEqual:self.oneCell.threeTextField]) {//判断是否时我们想要限定的那个输入框
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
            if ([toBeString doubleValue] > 10) {
                [SVTool TextButtonAction:self.view withSing:@"不能高于10折"];
                self.oneCell.threeTextField.text = @"10";

                self.twoCell.threeTextField.text = [NSString stringWithFormat:@"%.3f",self.sumMoney];
              //  [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",self.twoCell.threeTextField.text] forState:UIControlStateNormal];

                return NO;
            }
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            // 判断字符串中是否有小数点，并且小数点不在第一位
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            if (dotLocation == NSNotFound && range.location != 0) {
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                /*
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 */
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 4) {
                    
                    if ([string isEqualToString:@"."] && range.location == 4) {
                        return NO;
                    }
                    
                    return YES;
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
            
            if (dotLocation != NSNotFound && range.location > dotLocation + 3) {
                return NO;
            }
            
            if (textField.text.length > 11) {
                return NO;
            }
        }
        if ([textField isEqual:self.twoCell.threeTextField]) {//判断是否时我们想要限定的那个输入框
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            // 判断字符串中是否有小数点，并且小数点不在第一位
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            if (dotLocation == NSNotFound && range.location != 0) {
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                /*
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
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
        if ([textField isEqual:self.fourCell.threeTextField]) {
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            NSInteger pointLength = existedLength - selectedLength + replaceLength;
            
            //超过80位 就不能在输入了
            if (pointLength > 100) {
                return NO;
            }else{
                return YES;
            }
        }
    }
    return YES;
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


//扫码结算调用
#pragma mark - 扫码结算调用
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
//             self.payName = @"扫码支付";
//            [self footerNext];
//           // [self footerButtonResponseEvent];
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
                     self.payName = @"扫码支付";
                    [self footerNext];
                   // [self footerButtonResponseEvent];
                } else {
                    [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
                }
        
            };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
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

#pragma mark - 会员密码输入
- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.textView.keyboardType = UIKeyboardTypeASCIICapable;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.name.text = @"输入会员密码";
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(addMemberPwdsureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}

#pragma mark - 输入密码确定按钮点击
- (void)addMemberPwdsureBtnClick{
    if ([self.addCustomView.textView.text isEqualToString:self.sv_mr_pwd]) {
       // [SVTool TextButtonActionWithSing:@"密码正确"];
         [self unitCancelResponseEvent];
            //让按钮不可点
         [self loadPayMethod];
        
    }else{
        [SVTool TextButtonActionWithSing:@"密码错误"];
        [self unitCancelResponseEvent];
    }
}

/**
 销售人员
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

#pragma mark - 调整积分使用弹出view
- (SVIntegralInputVIew *)IntegralInputVIew
{
    if (!_IntegralInputVIew) {
        _IntegralInputVIew = [[NSBundle mainBundle]loadNibNamed:@"SVIntegralInputVIew" owner:nil options:nil].lastObject;
        _IntegralInputVIew.textFiled.delegate = self;
        _IntegralInputVIew.frame = CGRectMake(20, 20, ScreenW - 40, 220);
        _IntegralInputVIew.layer.cornerRadius = 10;
        _IntegralInputVIew.layer.masksToBounds = YES;
        _IntegralInputVIew.center = CGPointMake(ScreenW / 2, ScreenH);
        [_IntegralInputVIew.deleteBtn addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_IntegralInputVIew.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _IntegralInputVIew;
}

#pragma mark - 修改积分确认按钮
- (void)sureBtnClick{
   // self.integralMoney = self.integralCount * self.autoStr.integerValue;
    if (self.IntegralInputVIew.textFiled.text.integerValue < self.autoStr.integerValue) {
        [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"最少使用%@积分",self.autoStr]];
        [self unitCancelResponseEvent];
    }else if (self.IntegralInputVIew.textFiled.text.integerValue > self.member_Cumulative.integerValue){
        [SVTool TextButtonActionWithSing:@"输入积分大于可用积分"];
         [self unitCancelResponseEvent];
    }else{
        NSString*member_Cumulative = self.IntegralInputVIew.textFiled.text;
        NSLog(@"self.member_Cumulative = %@",member_Cumulative);
        self.integralCount = member_Cumulative.integerValue / self.autoStr.integerValue;
        [self.tableView reloadData];
        [self unitCancelResponseEvent];
    }
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

#pragma mark - 点击手势的点击事件
- (void)unitDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    //获取pickerView中第0列的选中值
    NSInteger row=[self.pickerView.unitPicker selectedRowInComponent:0];
    self.threeLabel.text = [self.sv_employee_nameArr objectAtIndex:row];
    self.threeCellText = self.threeLabel.text;
    self.sv_employee_id = [NSString stringWithFormat:@"%@",[self.sv_employee_idArr objectAtIndex:row]];
}

- (void)unitCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.IntegralInputVIew removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.addCustomView removeFromSuperview];
    self.addCustomView.textView.text = nil;
    self.IntegralInputVIew.textFiled.text = nil;
}

#pragma mark - 退出蒙版
- (void)handlePan{
    self.sumCount = 0;
    self.sumMoney = 0;
   // self.oneCellText = 0;
    self.oneCellText = @"";
    [self.modelArr removeAllObjects];
    for (NSMutableDictionary *dic in self.resultArr) {
        //会员ID
        if (![SVTool isBlankString:self.member_id]) {
            [dic setObject:self.member_id forKey:@"member_id"];
            [dic setObject:self.discount forKey:@"discount"];
        } else {
            [dic setObject:@"" forKey:@"member_id"];
            [dic setObject:@"" forKey:@"discount"];
        }
        [self optimizeSettlementDict:dic];
    
    }
    
    double result = [self molingReceiveMoney:self.sumMoney];
    if (self.isOpen == YES) { // 开了抹零开关
    
            self.twoCell.fourLabel.hidden = NO;
            double zeroNumber = self.sumMoney - result;
        self.zeroNumber = zeroNumber;
            self.twoCell.fourLabel.text = [NSString stringWithFormat:@"抹零：%.2f",zeroNumber];
//      self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//      [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",self.sumMoney] forState:UIControlStateNormal];
//      self.twoCell.fourLabel.hidden = YES;
//       [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",result] forState:UIControlStateNormal];
       self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",result];
    }else{
        self.twoCell.fourLabel.hidden = YES;
        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",self.sumMoney] forState:UIControlStateNormal];
        self.twoCell.fourLabel.hidden = YES;
    }
    
//    self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.sumMoney];
//    [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",self.sumMoney] forState:UIControlStateNormal];
//    self.twoCell.fourLabel.hidden = YES;
    
    [self.tableView reloadData];
    [self.maskTheView_two removeFromSuperview];
    [self.icon_button removeFromSuperview];
    [self.PrintingCollectionView removeFromSuperview];
    
    if (self.tuichuMengbanBlock) {
        self.tuichuMengbanBlock();
    }
    
    
}

/**
 遮盖
 */
-(UIView *)maskTheView_two{
    if (!_maskTheView_two) {
        
        _maskTheView_two = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView_two.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView_two addGestureRecognizer:tap];
        
    }
    
    return _maskTheView_two;
    
}


- (UICollectionView *)PrintingCollectionView
{
    if (_PrintingCollectionView == nil) {
        SVAddShopFlowLayout *layout = [[SVAddShopFlowLayout alloc] init];
        
        _PrintingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight,ScreenW, 550) collectionViewLayout:layout];
        // _PrintingCollectionView.automaticallyAdjustsScrollViewInsets = false;
        _PrintingCollectionView.backgroundColor = [UIColor clearColor];
        // _PrintingCollectionView.showsVerticalScrollIndicator = NO;
        _PrintingCollectionView.showsHorizontalScrollIndicator = NO;
        
    }
    
    
    
    return _PrintingCollectionView;
}

- (NSMutableArray *)timesCountArr
{
    if (!_timesCountArr) {
        _timesCountArr = [NSMutableArray array];
    }
    
    return _timesCountArr;
}

- (NSMutableArray *)selectMoneyArray
{
    if (!_selectMoneyArray) {
        _selectMoneyArray = [NSMutableArray array];
    }
    
    return _selectMoneyArray;
}

-(NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

@end

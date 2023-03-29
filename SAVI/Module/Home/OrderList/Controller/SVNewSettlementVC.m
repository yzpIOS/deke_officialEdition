//
//  SVNewSettlementVC.m
//  SAVI
//
//  Created by houming Wang on 2021/5/10.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewSettlementVC.h"
#import "SVNavShopView.h"
#import "SVNewSettlementCell.h"
#import "SVVipSelectVC.h"
#import "SVOrderDetailsModel.h"
#import "SVWholeAndSingleView.h"
#import "SVEditShopView.h"
#import "SVPromptRenewalView.h"
#import "SVUnitPickerView.h"
#import "SVAddCustomView.h"
#import "SVCouponListVC.h"
#import "SVIntegralInputVIew.h"
#import "SVVipChargeVC.h"
#import "SVSettlementCollectionView.h"
#import "PaymentMethodModel.h"
#import "SVHomeViewCell.h"
#import "SVPortfolioPaymentVC.h"
#import "ZJViewShow.h"
#import "SVShowCheckoutVC.h"
#import "SVOrderDetailsModel.h"
#import "SVCouponListModel.h"
#import "NSString+Utility.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#define num  ScreenH / 2
#define editShopViewHeight  340
#define rowHeight  85
static NSString *const ID = @"SVNewSettlementCell";
static NSString *CheckoutPayID = @"SVHomeViewCell";
@interface SVNewSettlementVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,strong) SVNavShopView *navShopView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopViewHeight;

@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopViewTopHeight;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,assign) BOOL isOpen;
/**
 整单折的价格
 */
@property (nonatomic,copy) NSString *sumMoneyTwo;
//件数
@property (nonatomic,assign) double sumCount;
//总价格
@property (nonatomic,assign) double sumMoney;
//总优惠
@property (nonatomic,assign) double sumDiscount;

@property (nonatomic,strong) NSDictionary *sv_uc_dixian;
@property (nonatomic,strong) NSString *autoStr;
@property (nonatomic,strong) NSString *whether;
@property (nonatomic,strong) NSDictionary *sv_uc_saletozerosetDic;
@property (weak, nonatomic) IBOutlet UIButton *RechargeBtn;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;

@property (nonatomic,strong) SVWholeAndSingleView * wholeAndSingleView;
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) SVEditShopView * editShopView;
@property (nonatomic,strong) UIView * maskTheViewTwo;
@property (nonatomic,strong) SVPromptRenewalView *promptRenewalView;
@property (nonatomic,strong) SVAddCustomView *addCustomView;
// 会员内容
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeText;
@property (weak, nonatomic) IBOutlet UILabel *discode;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumption;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *memberGrade;

@property (weak, nonatomic) IBOutlet UIView *salesmanView;
@property (weak, nonatomic) IBOutlet UIView *OrderNotesView;
//自定义pickerView
@property(nonatomic,strong) SVUnitPickerView *pickerView;
//销售人员
@property (nonatomic, copy) NSString *sv_employee_id;
@property (nonatomic, strong) NSMutableArray *sv_employee_idArr;
@property (nonatomic, strong) NSMutableArray *sv_employee_nameArr;
@property (weak, nonatomic) IBOutlet UILabel *salesman;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *integralView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *integralViewHeight;
@property (nonatomic,strong) SVIntegralInputVIew *IntegralInputVIew;
//收集支付方式的数组
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *iconArr;

@property (nonatomic,strong) NSMutableArray *titleArr_member;
@property (nonatomic,strong) NSMutableArray *iconArr_member;

@property (nonatomic,strong) NSMutableArray *vipTitleArr;
@property (nonatomic,strong) NSMutableArray *vipTitleImg;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Width;
@property (nonatomic,strong) NSString *everyday_serialnumber;

///**
// 积分
// */
@property (nonatomic,strong) NSString *integral;

@property (nonatomic,assign) BOOL isSelectIntegralCircle;

@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (nonatomic,strong) SVSettlementCollectionView *settlementCollectionView;
@property (nonatomic,strong) PaymentMethodModel *paymentMethodModel;
@property (nonatomic,strong) NSMutableArray * selectMoneyArray;
//判断是否开启支付
@property (nonatomic,copy) NSString *sv_enable_alipay;//支付宝
@property (nonatomic,copy) NSString *sv_enable_wechatpay;//微信

//支付方式
@property (nonatomic,copy) NSString *payName;
//扫一扫码证码
@property (nonatomic,copy) NSString *authcode;
@property (weak, nonatomic) IBOutlet UILabel *TotalAmount;
@property (nonatomic,assign) BOOL isAggregatePayment;
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic,assign) double wholeOrderDiscount;
@property (nonatomic,assign) double totleMoney;
/**
 数量合计
 */
@property (weak, nonatomic) IBOutlet UILabel *TotalQuantity;
@property (nonatomic,assign) double zeroNumber;
@property (nonatomic,strong) NSString *sv_coupon_amount;
@property (nonatomic,strong) NSString *sv_coupon_discount;
@property (nonatomic,strong) NSString *sv_record_id; // 优惠券id
@property (assign, nonatomic) NSIndexPath       *selIndex;      //单选选中的行
// 整单备注
@property (weak, nonatomic) IBOutlet UILabel *NotesForWholeOrder;
// 优惠信息
@property (weak, nonatomic) IBOutlet UILabel *OfferInformation;

@property (weak, nonatomic) IBOutlet UILabel *IntegralInformation;
@property (nonatomic,assign) double integralCount;
@property (nonatomic,assign) NSInteger integralMoney;
@property (nonatomic,strong) NSString * memberlevel_id;
//@property (nonatomic,assign) NSInteger integralCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewContanct;
@property (weak, nonatomic) IBOutlet UILabel *icon_name;
/**
 优惠券名称
 */
@property (weak, nonatomic) IBOutlet UILabel *couponName;
/**
 优惠券金额
 */
@property (weak, nonatomic) IBOutlet UILabel *couponMoney;

@property (nonatomic,strong) SVProductResultsData *productResultsData;


@end

@implementation SVNewSettlementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomViewContanct.constant = BottomHeight;
    self.zeroNumber = 0;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopClick)];
    [SVUserManager shareInstance].Tips = @"支付中。。。";
    [SVUserManager saveUserInfo];
    self.totleMoney = 0.0;
    NSLog(@"resultArr = %@",self.resultArr);
    for (NSMutableDictionary *dic in self.resultArr) {
        self.totleMoney += [dic[@"sv_p_unitprice"] doubleValue] *[dic[@"product_num"] doubleValue];
    }
    
    self.topView.backgroundColor = navigationBackgroundColor;
    
    self.sv_uc_dixian = [SVUserManager shareInstance].sv_uc_dixian;
    self.sv_uc_saletozerosetDic = [SVUserManager shareInstance].sv_uc_saletozerosetDic;
    self.autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
    self.whether = [NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"whether"]];
    [self loadData];
    self.RechargeBtn.layer.cornerRadius = 3;
    self.RechargeBtn.layer.masksToBounds = YES;
    self.RechargeBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    self.RechargeBtn.layer.borderWidth = 1;
    [self.RechargeBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    self.memberGrade.layer.cornerRadius = 3;
    self.memberGrade.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    self.fourView.layer.cornerRadius = 10;
    self.fourView.layer.masksToBounds = YES;
    
  //  [self data];
    
    self.icon.layer.cornerRadius = 20;
    //UIImageView切圆的时候就要用到这一句了vipPhone
    self.icon.layer.masksToBounds = YES;
    if (![SVTool isBlankString:self.headimg]) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        self.icon_name.hidden = YES;
    } else {
        self.icon_name.text = [self.name substringToIndex:1];
        self.icon_name.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.icon.image = [UIImage imageNamed:@"icon_black"];
        self.icon_name.hidden = NO;
    }
    
    if (kStringIsEmpty(self.member_id)) {
        self.integralViewHeight.constant = 40;
        self.integralView.hidden = YES;
        
        self.memberViewHeight.constant = 0;
        self.memberView.hidden = YES;

    }else{
        if (self.member_Cumulative.doubleValue < self.autoStr.doubleValue || [self.whether isEqualToString:@"0"]) {
            self.integralViewHeight.constant = 40;
            self.integralView.hidden = YES;
        }else{
            self.integralViewHeight.constant = 80;
            self.integralView.hidden = NO;
            
         NSString *autoStr=[NSString stringWithFormat:@"%@",self.sv_uc_dixian[@"auto"]];
         NSInteger count = self.member_Cumulative.integerValue / autoStr.integerValue;
          NSLog(@"count = %ld",count);
          NSInteger money = count * autoStr.integerValue;
          self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%ld元",money,count];
            self.integralCount = self.member_Cumulative.integerValue / self.autoStr.integerValue;
        }
        
        self.memberViewHeight.constant = 128;
        self.memberView.hidden = NO;
        
        self.nameLabel.text = self.name;
        self.codeText.text = self.phone;
        if ([SVTool isBlankString:self.discount]) {
            self.discount = @"0";
            self.discode.hidden = YES;
        }else{
            self.discode.hidden = NO;
            self.discode.text = [NSString stringWithFormat:@"%.2f折",self.discount.doubleValue];
        }
        
        self.memberViewHeight.constant = 128;
        self.memberView.hidden = NO;
        
        self.balance.text = [NSString stringWithFormat:@"%.2f",self.stored.doubleValue];
        self.integralLabel.text = self.sv_mw_availablepoint;
        self.consumption.text = self.sv_mw_sumpoint;
        if (kStringIsEmpty(self.sv_mr_birthday)) {
            self.birthday.text = @"-/-";
        }else{
            self.birthday.text = [self.sv_mr_birthday substringToIndex:10];
          //  self.birthday.text = sv_mr_birthday;
        }
        
        self.memberGrade.text = self.level;
        
    }
    
    self.navShopView.intrinsicContentSize = CGSizeMake(_navShopView.image.width + _navShopView.nameText.width,44);
    
    self.navigationItem.titleView = self.navShopView;
    
    self.navShopView.userInteractionEnabled = YES;
    self.navigationItem.titleView = self.navShopView;
    [self.navShopView addGestureRecognizer:tap];
    self.memberView.layer.cornerRadius = 10;
    self.memberView.layer.masksToBounds = YES;
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"整单优惠" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    

    // view2的优惠view点击
    UITapGestureRecognizer *view1Tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view1Click)];
    [self.view1 addGestureRecognizer:view1Tag];
    
    // view2的优惠view点击
    UITapGestureRecognizer *view2Tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view2Click)];
    [self.view2 addGestureRecognizer:view2Tag];

    // view3的点击
    UITapGestureRecognizer *view3Tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view3Click)];
    [self.view3 addGestureRecognizer:view3Tag];
    self.view3.backgroundColor = navigationBackgroundColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewSettlementCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.scrollEnabled = NO;

    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self data];
    
    UITapGestureRecognizer *salesmanViewTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(salesmanViewClick)];
    [self.salesmanView addGestureRecognizer:salesmanViewTag];
    
    UITapGestureRecognizer *OrderNotesViewTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OrderNotesViewClick)];
    [self.OrderNotesView addGestureRecognizer:OrderNotesViewTag];
    
    //优惠券的手势添加
    UITapGestureRecognizer *couponViewTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponViewClick)];
    [self.couponView addGestureRecognizer:couponViewTag];
    // 积分的点击
    UITapGestureRecognizer *integralViewTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(integralViewClick)];
    [self.integralView addGestureRecognizer:integralViewTag];
    
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
    // 整单折扣一开始等于1
    self.wholeOrderDiscount = 1;
    [self loadOddsMembers];
    [self loadpayButton];
    self.isAggregatePayment = false;
   // [self AggregatePayment];
    [self requestMethodOfPayment];
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

#pragma mark - 加载单号
- (void)loadOddsMembers{
    [SVUserManager loadUserInfo];
   // [SVTool IndeterminateButtonActionWithSing:nil];
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetDailySerialNumber?key=%@&plusone=true",[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"6565656dic = %@",dic);
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
#pragma mark - 进来就加载数据
- (void)data{

    [self loadSettleCaleIsWholeOrder:false];
    
}
#pragma mark - 演算接口
- (void)loadSettleCaleIsWholeOrder:(BOOL)isWholeOrder{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Settle/Cale?key=%@",[SVUserManager shareInstance].access_token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];

        if (![SVTool isEmpty:self.resultArr]) {
            double IntegralAverageDiscount = 1.00;
            NSMutableArray *buySteps = [NSMutableArray array];
            for (NSInteger i = 0; i < self.resultArr.count; i++) {
                NSMutableDictionary *dict = self.resultArr[i];
                SVOrderDetailsModel *model = [SVOrderDetailsModel mj_objectWithKeyValues:dict];
              //  NSMutableDictionary *dict = self.resultArr[i];
                NSString *product_num = model.product_num;
                NSMutableArray *commissions = [NSMutableArray array];
                NSMutableDictionary *buyStepsDict = [NSMutableDictionary dictionary];
                [buyStepsDict setObject:[NSNumber numberWithInteger:i+1] forKey:@"index"];
                [buyStepsDict setObject:[NSString stringWithFormat:@"%.2f",product_num.doubleValue] forKey:@"number"];
                [buyStepsDict setObject:model.product_id forKey:@"productId"];
                [buyStepsDict setObject:commissions forKey:@"commissions"];
                if (model.isPriceChange.integerValue == 1) {
                    [buyStepsDict setObject:[NSString stringWithFormat:@"%.2f",model.priceChange.doubleValue] forKey:@"productChangePrice"];
                }
                [buySteps addObject:buyStepsDict];
            }
            
            if (isWholeOrder == true) {
                [parame setObject:[NSString stringWithFormat:@"%.2f",self.sumMoney] forKey:@"orderChangeMoney"];
            }else{
                if (![SVTool isBlankString:self.member_id]) {
                    //会员卡号（实给会员ID)
                    [parame setObject:self.member_id forKey:@"memberId"];

                }
                
                if (![SVTool isBlankString:self.integral]) {
                    // 积分字段
                    [parame setObject:self.integral forKey:@"memberPoint"];

                }
                
                if (![SVTool isBlankString:self.sv_record_id]) {
                    // 优惠券id
                    [parame setObject:self.sv_record_id forKey:@"couponRecordId"];

                }
                
//                self.sv_record_id
            }
          
            [parame setObject:buySteps forKey:@"buySteps"];
        }
    
   
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SVHTTPResponse * response = [SVHTTPResponse responseWithObject:responseDict];
        if (response.code == PSResponseStatusSuccessCode) {
            SVProductResultsData *model = [SVProductResultsData mj_objectWithKeyValues:response.data];
            NSArray *productResultslModelList = [SVProductResultslList mj_objectArrayWithKeyValuesArray:model.productResults];
            NSArray *orderPromotionsModelList = [SVOrderPromotions mj_objectArrayWithKeyValuesArray:model.orderPromotions];
           
            model.productResults = productResultslModelList;
            model.orderPromotions = orderPromotionsModelList;
            
           // for (SVProductResultslList *productResultslModelList in model.productResults) {
                for (int i = 0; i < model.productResults.count; i++) {
                    SVProductResultslList *productResultslModelList = model.productResults[i];
                    NSMutableDictionary *dict = self.resultArr[i];
                    SVOrderDetailsModel *model = [SVOrderDetailsModel mj_objectWithKeyValues:dict];
                    productResultslModelList.sv_p_images = model.sv_p_images;
                    
                    SVOrderPromotions *orderPromotions = [SVOrderPromotions mj_objectWithKeyValues:productResultslModelList.buyStepPromotion];
                    SVPromotionDescription *promotionDescription = orderPromotions.promotionDescription;
                    orderPromotions.promotionDescription = promotionDescription;
                    productResultslModelList.buyStepPromotion = orderPromotions;
                    
                    if (productResultslModelList.orderPromotions.count > 0) {
                        NSArray *orderPromotionsArray = [SVOrderPromotions mj_objectArrayWithKeyValuesArray:productResultslModelList.orderPromotions];
                        productResultslModelList.orderPromotions = orderPromotionsArray;

                        NSString *preferential = @"";
                        double discountAmount = 0.0;
                        for (int i = 0; i < orderPromotionsArray.count; i++) {
                            SVOrderPromotions *orderPromotions = orderPromotionsArray[i];
                            SVPromotionDescription *promotionDescription = [SVPromotionDescription mj_objectWithKeyValues:orderPromotions.promotionDescription];
                            orderPromotions.promotionDescription = promotionDescription;
                            preferential = [preferential stringByAppendingString:promotionDescription.s];
                            discountAmount += promotionDescription.m;
                           
                        }
                        productResultslModelList.preferential = preferential;
                        productResultslModelList.discountAmount = discountAmount;
                        
                    }
                }
                
               // orderPromotions.promotionDescription = orderPromotions.promotionDescription;
          //  }
            
            self.productResultsData = model;
            
            self.TotalAmount.text = [NSString stringWithFormat:@"%.2f",model.dealMoney];
            self.OfferInformation.text = [NSString stringWithFormat:@"%.2f",model.couponMoney];
            self.TotalQuantity.text = [NSString stringWithFormat:@"%.2f",model.dealNumber];
        }else{
            
        }
        
        self.shopViewHeight.constant = 48 + self.productResultsData.productResults.count * rowHeight;
        [self.tableView reloadData];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}



#pragma mark - 加载支付方式
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
                    titleArr = [NSMutableArray arrayWithObjects:@"现金",@"储值卡",@"扫码支付",@"银行卡",@"闪惠",@"赊账",nil];
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

#pragma mark - view3收款的点击
- (void)view3Click{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheViewTwo];
    [[UIApplication sharedApplication].keyWindow addSubview:self.settlementCollectionView];
    //实现弹出方法
    [UIView animateWithDuration:.3 animations:^{
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        //设置垂直间距
//        layout.minimumLineSpacing = 1;
//        //设置水平间距
//        layout.minimumInteritemSpacing = 0;
        // 计算高度
        if (![SVTool isBlankString:self.member_id]) {
            
            int number = (int) ceil(self.titleArr_member.count / 4.0);
            self.settlementCollectionView.collectionView.frame = CGRectMake(0, 0, ScreenW, number * 80 + number + 1);
            self.settlementCollectionView.frame = CGRectMake(0, ScreenH - (number * 80 + number + 1 + 108), ScreenW, number * 80 + number + 1 + 108);
    
          [self.settlementCollectionView.collectionView reloadData];

        }else{
            int number = (int) ceil(self.vipTitleArr.count / 4.0);
            self.settlementCollectionView.collectionView.frame = CGRectMake(0, 0, ScreenW, number * 80 + number + 1);
            self.settlementCollectionView.frame = CGRectMake(0, ScreenH - (number * 80 + number + 1 + 108), ScreenW, number * 80 + number + 1 + 108);
           // self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, num * 80 + num + 1) collectionViewLayout:layout];
//            self.collectionView.backgroundColor = BackgroundColor;
//            //指定collectionview代理
//            self.collectionView.delegate = self;
//            self.collectionView.dataSource = self;
//            //注册collectionView的cell
//            [self.collectionView registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:CheckoutPayID];
//            [self.collectionView reloadData];
            [self.settlementCollectionView.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
    if (![SVTool isBlankString:self.member_id]) { // 是会员
        
        return self.titleArr_member.count;
        
    }else{
        return self.vipTitleArr.count;
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
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW-3)/4, 80);
}

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake (1,0,0,0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
//            SVCouponListVC *vc = [[SVCouponListVC alloc] init];
//            vc.totle_money = self.twoCell.threeTextField.text;
//            vc.selIndex = self.selIndex;
//            vc.member_id = self.member_id;
//            [self.navigationController pushViewController:vc animated:YES];
//
//            [self.collectionView reloadData];
//
//            if (![SVTool isBlankString:self.member_id]){
//
//                for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
//                    if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
//                        self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
//                        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
//                        [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                        break;
//                    }else{
//                        self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
//                        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                        [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//                    }
//                    //                        }
//
//                }
//
//            }else{
//                //刷新后，再设置默认选中，才有效果
//                self.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
//                NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            }

//            vc.couponBlock = ^(SVCouponListModel * _Nonnull model, NSIndexPath * _Nonnull selectIndex) {
//                self.selIndex = selectIndex;
//                if ([model.sv_coupon_type isEqualToString:@"0"]) {// 代金券
//                    // footerButton
//                    if (model.sv_coupon_money.doubleValue > self.twoCell.threeTextField.text.doubleValue) {// 如果优惠金额大于实收金额
//                        NSString *coupon_money;
//                        self.sumMoneyTwo = @"0";
//                        coupon_money = @"0";
//
//                        // double discount = (coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
//                        self.oneCell.threeTextField.text = @"0.00";
//
//                        self.oneCellText = @"0";
//
////                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",@"0"] forState:UIControlStateNormal];
//                    }else{
//                        NSString *coupon_money;
//                        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
//                        coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
//
//                        double discount = (coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
//                        self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",discount *10];
//
//                        self.oneCellText = [NSString stringWithFormat:@"%.4f",discount *10];
//
////                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
//
//
//                    }
//
//                    self.sv_coupon_amount = model.sv_coupon_money;
//                    self.sv_record_id = model.sv_record_id;
//
//                }else{// 折扣卷
//                    //  self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01;
//                    NSString *coupon_money;
//                    self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
//                    coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
//
//                    self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",coupon_money.doubleValue];
//
//                    self.oneCellText = [NSString stringWithFormat:@"%.2f",[self.oneCell.threeTextField.text doubleValue] * 0.1];
//
////                        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
//                    self.sv_coupon_discount = model.sv_coupon_money;
//                    self.sv_record_id = model.sv_record_id;
//
//                    //  self.couponListModel = model;
//                }
//            };
            
            
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

//            SVCouponListVC *vc = [[SVCouponListVC alloc] init];
//            vc.totle_money = self.twoCell.threeTextField.text;
//            vc.member_id = self.member_id;
//            vc.selIndex = self.selIndex;
//            [self.navigationController pushViewController:vc animated:YES];
//            //  vc.model = self.couponListModel;
//            [self.collectionView reloadData];
////                if (![SVTool isBlankString:self.member_id]){
////
////                    for (NSInteger i = 0; i < self.titleArr_member.count; i++) {
////                        if ([self.titleArr_member[i] isEqualToString:@"储值卡"]) {
////                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[i]];
////                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
////                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
////                            break;
////                        }else{
//////                            self.payName = [NSString stringWithFormat:@"%@",self.titleArr_member[0]];
//////                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//////                            [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
////                        }
////                        //                        }
////
////                    }
////
////                }else{
////                    //刷新后，再设置默认选中，才有效果
//////                    self.payName = [NSString stringWithFormat:@"%@",self.vipTitleArr[0]];
//////                    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//////                    [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
////                }
//
//            vc.couponBlock = ^(SVCouponListModel * _Nonnull model, NSIndexPath * _Nonnull selectIndex) {
//                self.selIndex = selectIndex;
//                if ([model.sv_coupon_type isEqualToString:@"0"]) {// 代金券
//                    // footerButton
//
//                    if (model.sv_coupon_money.doubleValue > self.twoCell.threeTextField.text.doubleValue) {// 如果优惠金额大于实收金额
//                        NSString *coupon_money;
//                        self.sumMoneyTwo = @"0";
//                        coupon_money = @"0";
//
//                        // double discount = (coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
//                        self.oneCell.threeTextField.text = @"0.00";
//
//                        self.oneCellText = @"0";
//
////                            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",@"0"] forState:UIControlStateNormal];
//
//                    }else{
//                        NSString *coupon_money;
//                        self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
//                        coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue - model.sv_coupon_money.doubleValue];
//
//                        // double discount = (model.sv_coupon_money.doubleValue / self.twoCell.threeTextField.text.doubleValue);
//                        double discount = (coupon_money.doubleValue / self.sumMoney);
//                        self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",discount *10];
//                        self.oneCellText =[NSString stringWithFormat:@"%.4f",discount *10];
//
//                      //  [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
//
//                        self.twoCell.threeTextField.text = coupon_money;
//
//                        // @property (nonatomic,strong) NSString *sv_coupon_amount;
//                        //  @property (nonatomic,strong) NSString *sv_coupon_discount;
//                        // self.couponListModel = model;
//
//                    }
//
//                    self.sv_coupon_amount = model.sv_coupon_money;
//                    self.sv_record_id = model.sv_record_id;
//
//                }else{// 折扣卷
//                    //  self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01;
//                    NSString *coupon_money;
//                    self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
//                    coupon_money = [NSString stringWithFormat:@"%.2f",self.twoCell.threeTextField.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
//
//                    // self.oneCell.threeTextField.text = model.sv_coupon_money;
//                    self.oneCell.threeTextField.text = [NSString stringWithFormat:@"%.2f",model.sv_coupon_money.doubleValue *0.1];
//
//                    self.oneCellText = [NSString stringWithFormat:@"%.2f",[self.oneCell.threeTextField.text doubleValue]];
//                  //  [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
////=======
////                        self.oneCellText = [NSString stringWithFormat:@"%.2f",[self.oneCell.threeTextField.text doubleValue] * 0.1];
//////                        [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%@",coupon_money] forState:UIControlStateNormal];
////>>>>>>> origin/oem_deduction_zuhezhifu
//                    self.sv_coupon_discount = model.sv_coupon_money;
//                    self.sv_record_id = model.sv_record_id;
//
//                    //  self.couponListModel = model;
//                }
//            };
  
        }else{
            [self footerNext];
        }
    }
}

#pragma mark - view2优惠view的点击
- (void)view2Click{
    
}

#pragma mark - view1总金额的点击
- (void)view1Click{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.wholeAndSingleView];
    self.wholeAndSingleView.totleMoney = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
    // 是整单优惠
    self.wholeAndSingleView.zhengdanOrdanpin = 1;
    __weak typeof(self) weakSelf = self;
    // 折扣
    self.wholeAndSingleView.WholeOrderDiscountBlock = ^(double discount) {

        weakSelf.sumMoney = weakSelf.productResultsData.dealMoney *discount * 0.1;
        [weakSelf loadSettleCaleIsWholeOrder:true];
        
        [weakSelf dateCancelResponseEvent];
    };
    // 现金
    self.wholeAndSingleView.WholeOrderMoneyBlock = ^(double money) {
        
 
        weakSelf.sumMoney = money;
        [weakSelf loadSettleCaleIsWholeOrder:true];
        
        [weakSelf dateCancelResponseEvent];
        
    };
}



#pragma mark - 点击会员充值
- (IBAction)RechargeClick:(id)sender {
//    [self.viewOne setBackgroundColor:clickButtonBackgroundColor];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        SVVipChargeVC *VC = [[SVVipChargeVC alloc]init];
        VC.nameText = self.nameLabel.text;
        VC.careNum = self.codeText.text;
        VC.balance = self.balance.text;
        VC.memberID = self.member_id;
        VC.memberlevel_id = self.memberlevel_id.integerValue;
        
        __weak typeof(self) weakSelf = self;
        VC.vipChargeBlock = ^{
            [weakSelf loadMemberStoreValue];
          //  [weakSelf requestData];
//            if (weakSelf.VipDetailsBlock) {
//                weakSelf.VipDetailsBlock();
//            }
        };
        
        [self.navigationController pushViewController:VC animated:YES];
        
      //  [self.viewOne setBackgroundColor:[UIColor clearColor]];
        
//    });
}

#pragma mark - 加载会员储值金额
- (void)loadMemberStoreValue{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *setURL = [URLhead stringByAppendingFormat:@"/api/user/%@?key=%@",self.member_id,token];
    
    [[SVSaviTool sharedSaviTool] GET:setURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            NSDictionary *values = dic[@"values"];
            if (![SVTool isBlankDictionary:values]) {
                        //积分
        NSString *sv_mw_availablepoint = [NSString stringWithFormat:@"%.2f",[values[@"sv_mw_availablepoint"] doubleValue]];
        self.member_Cumulative = sv_mw_availablepoint;
        
        //储值余额
        NSString *sv_mw_availableamount = [NSString stringWithFormat:@"%@",values[@"sv_mw_availableamount"]];
        self.balance.text = [NSString stringWithFormat:@"%.2f",[sv_mw_availableamount doubleValue]];
 
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
    }];
}

#pragma mark - 删除会员
- (IBAction)removeMemberClick:(id)sender {
//    self.view2Width.constant = 0;
//    self.view2.hidden = YES;
    self.sumCount = 0;
    self.sumMoney = 0;
    self.sumDiscount= 0;
    self.name = nil;
    self.phone = nil;
    self.discount = nil;
    self.member_id = nil;
    self.stored = nil;
    self.headimg = nil;
    self.sv_mr_cardno = nil;
  //  self.oneCellText = nil;
    self.member_Cumulative = nil;
    self.sv_mr_pwd = nil;
    self.grade = nil;
    self.sv_discount_configArray = nil;
    self.memberViewHeight.constant = 0;
    self.memberView.hidden = YES;
    
    self.integralViewHeight.constant = 40;
    self.integralView.hidden = YES;

    
    self.couponMoney.text = @"选择优惠券";
    self.couponMoney.textColor = an_gradeColor;
    self.couponName.text = @"优惠券";
    self.couponName.textColor = an_blackColor;

    if (self.deleteMemberBlock) {
        self.deleteMemberBlock();
    }

    
    [self loadSettleCaleIsWholeOrder:false];
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
    self.IntegralInputVIew.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];// 1
//    [self.addCustomView.textView becomeFirstResponder];// 2
//
//}
- (void)dealloc{
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
}

#pragma mark - 点击积分圈圈按钮
- (IBAction)circleBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.isSelectIntegralCircle = YES;
        [self.circleBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateNormal];
        if (self.integralCount > self.productResultsData.dealMoney) {
            double integralMoney = self.productResultsData.dealMoney;
            double integral = self.productResultsData.dealMoney;
            self.integralCount = integralMoney;
            
            self.integralMoney = self.integralCount * self.autoStr.integerValue;
            self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%.2f元",self.integralMoney,self.integralCount];
            /**
             积分抵扣字段
             */
            self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
          
           
        }else{
            self.isSelectIntegralCircle = YES;
            double money = self.productResultsData.dealMoney - self.integralCount;
           // self.sumMoney = money;
            /**
             积分抵扣字段
             */
            self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
        
         
        }
       
        
       // self.SMS = NO;
      //  [self.tableView reloadData];
    } else {
        self.integral = nil;
            self.isSelectIntegralCircle = NO;
            [self.circleBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
            
          
    }
    
    [self loadSettleCaleIsWholeOrder:false];
}


#pragma mark - 点击积分view
- (void)integralViewClick{
//    if (self.circleBtn.selected == YES) {
//        self.circleBtn.selected = !self.circleBtn.selected;
//            [self.circleBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
//        self.IntegralDeductionCell.integralView.hidden = YES;
//            double money = self.sumMoneyTwo.doubleValue + self.integralCount;
//            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",money];
////            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",money] forState:UIControlStateNormal];
//        self.isSelectIntegralCircle = NO;
//        self.integral = nil;
//        [self.tableView reloadData];
//    }
    if (self.circleBtn.selected == YES) {
        self.circleBtn.selected = !self.circleBtn.selected;
            [self.circleBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
       // self.IntegralDeductionCell.integralView.hidden = YES;
            double money = self.sumMoneyTwo.doubleValue + self.integralCount;
            self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",money];
//            [self.footerButton setTitle:[NSString stringWithFormat:@"收款￥%.2f",money] forState:UIControlStateNormal];
        self.isSelectIntegralCircle = NO;
        self.integral = nil;
       // [self.tableView reloadData];
        NSLog(@"count = %f",self.integralCount);
        self.integralMoney = self.integralCount * self.autoStr.integerValue;
        self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%.2f元",self.integralMoney,self.integralCount];
    }
     [self.IntegralInputVIew.textFiled becomeFirstResponder];// 2
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.IntegralInputVIew];
}




#pragma mark -  请求计算提成的人
- (void)loadData {
  //  [SVTool IndeterminateButtonActionWithSing:nil];
    //提示在支付中
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
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
              //  [self.sv_employee_idArr addObject:[SVUserManager shareInstance].user_id];
            } else {
               // [self.sv_employee_idArr addObject:[SVUserManager shareInstance].sv_employeeid];
            }
            if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
               // [self.sv_employee_nameArr addObject:@""];
            } else {
              //  [self.sv_employee_nameArr addObject:[SVUserManager shareInstance].sv_employee_name];
            }
            
            if ([dict[@"succeed"]integerValue]==1) {
                if (![SVTool isEmpty:[dict objectForKey:@"values"]]) {
                    for (NSDictionary *dic in [dict objectForKey:@"values"]) {
                        [self.sv_employee_idArr addObject:dic[@"sv_employee_id"]];
                        [self.sv_employee_nameArr addObject:dic[@"sv_employee_name"]];
                    }
                }
            }
            
//            if (!kArrayIsEmpty(self.sv_employee_nameArr) && !kArrayIsEmpty(self.sv_employee_idArr)) {
////                self.threeLabel.text = self.sv_employee_nameArr[0];
////                self.threeCellText = self.threeLabel.text;
//                self.sv_employee_id = [NSString stringWithFormat:@"%@",self.sv_employee_idArr[0]];
//
//            }
            
        }

        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark - 点击销售人员view
- (void)salesmanViewClick{
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
    return self.sv_employee_nameArr[row];
}

#pragma mark - 点击整单备注view
- (void)OrderNotesViewClick{
    [self.addCustomView.textView becomeFirstResponder];// 2
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
    self.addCustomView.name.text = @"整单备注";
    if (![self.NotesForWholeOrder.text isEqualToString:@"整单备注"]) {
        self.addCustomView.textView.text = self.NotesForWholeOrder.text;
    }
    
}

#pragma mark - 点击选择会员
- (void)tapShopClick{
    SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
    
    __weak typeof(self) weakSelf = self;
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
    weakSelf.memberlevel_id = memberlevel_id;
    if ([SVTool isBlankString:discount]) {
        discount = @"0";
    }else{
        weakSelf.discount = discount;
    }
    
   
    
  //  weakSelf.grade = grade;
//            if ([SVUserManager shareInstance].rankPromotion_sv_detail_is_enable.doubleValue == 1) { // 开关开了
    weakSelf.grade = grade;
    weakSelf.member_id = member_id;
    weakSelf.stored = storedValue;
    weakSelf.headimg = headimg;
    weakSelf.sv_mr_cardno = sv_mr_cardno;
    weakSelf.member_Cumulative = sv_mw_availablepoint;
    weakSelf.sv_mr_pwd = sv_mr_pwd;
    weakSelf.integralCount = weakSelf.member_Cumulative.doubleValue / weakSelf.autoStr.doubleValue;
    if (self.chooseMemberBlock) {
        self.chooseMemberBlock(name, phone, level, discount, member_id, storedValue, headimg, sv_mr_cardno,sv_mw_availablepoint,grade,ClassifiedBookArray,memberlevel_id,sv_mw_sumpoint,sv_mr_birthday);
    }
    
    
    self.icon.layer.cornerRadius = 20;
    //UIImageView切圆的时候就要用到这一句了vipPhone
    self.icon.layer.masksToBounds = YES;
    if (![SVTool isBlankString:self.headimg]) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        self.icon_name.hidden = YES;
    } else {
        self.icon_name.text = [self.name substringToIndex:1];
        self.icon_name.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.icon.image = [UIImage imageNamed:@"icon_black"];
        self.icon_name.hidden = NO;
    }
    
    if (kStringIsEmpty(weakSelf.member_id)) {
        weakSelf.integralViewHeight.constant = 40;
        weakSelf.integralView.hidden = YES;
    }else{
        if (self.member_Cumulative.doubleValue < self.autoStr.doubleValue || [self.whether isEqualToString:@"0"]) {
            weakSelf.integralViewHeight.constant = 40;
            weakSelf.integralView.hidden = YES;
        }else{
            weakSelf.integralViewHeight.constant = 80;
            weakSelf.integralView.hidden = NO;
        
            self.integralMoney = self.integralCount * self.autoStr.integerValue;
            self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%.2f元",self.integralMoney,self.integralCount];
        }
        
    }
    // 次卡
   // [self loadUserMemberId:member_id];
    // 给会员信息赋值
   // self.icon.image
    self.nameLabel.text = name;
    self.codeText.text = phone;
    if ([SVTool isBlankString:discount]) {
        discount = @"0";
        self.discode.hidden = YES;
    }else{
        self.discode.hidden = NO;
        self.discode.text = [NSString stringWithFormat:@"%.2f折",discount.doubleValue];
    }
    
    self.memberViewHeight.constant = 128;
    self.memberView.hidden = NO;
    
    self.balance.text = [NSString stringWithFormat:@"%.2f",storedValue.doubleValue];
    self.integralLabel.text = sv_mw_availablepoint;
    self.consumption.text = sv_mw_sumpoint;
    if (kStringIsEmpty(sv_mr_birthday)) {
        self.birthday.text = @"-/-";
    }else{
        self.birthday.text = [sv_mr_birthday substringToIndex:10];
    }
    
    self.memberGrade.text = level;
   

    
    [self loadSettleCaleIsWholeOrder:false];

};
    
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 删除优惠的按钮方法
- (IBAction)DeleteOfferClick:(id)sender {
//    self.view2Width.constant = 0;
//    self.view2.hidden = YES;
    self.sumCount = 0;
    self.sumMoney = 0;
    self.sumDiscount = 0;
    self.name = nil;
    self.phone = nil;
    self.discount = nil;
    self.member_id = nil;
    self.stored = nil;
    self.headimg = nil;
    self.sv_mr_cardno = nil;
  //  self.oneCellText = nil;
    self.member_Cumulative = nil;
    self.sv_mr_pwd = nil;
    self.grade = nil;
    self.sv_discount_configArray = nil;
    self.memberViewHeight.constant = 0;
    self.memberView.hidden = YES;
    // 整单折扣一开始等于1
    self.wholeOrderDiscount = 1;
    
    self.integralViewHeight.constant = 40;
    self.integralView.hidden = YES;
    
    self.couponMoney.text = @"选择优惠券";
    self.couponMoney.textColor = an_gradeColor;
    self.couponName.text = @"优惠券";
    self.couponName.textColor = an_blackColor;
  //  [self.tableView reloadData];
    
    [self loadSettleCaleIsWholeOrder:false];
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
                CGFloat roundA = roundf(receive);
               result = [NSString stringWithFormat:@"%.2f",roundA];
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

#pragma mark - 整单优惠右上角
- (void)selectbuttonResponseEvent{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.wholeAndSingleView];
    self.wholeAndSingleView.totleMoney = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
    // 是整单优惠
    self.wholeAndSingleView.zhengdanOrdanpin = 1;
    __weak typeof(self) weakSelf = self;
    // 折扣
    self.wholeAndSingleView.WholeOrderDiscountBlock = ^(double discount) {

        weakSelf.sumMoney = weakSelf.productResultsData.dealMoney *discount * 0.1;
        [weakSelf loadSettleCaleIsWholeOrder:true];
        
        [weakSelf dateCancelResponseEvent];
    };
    // 现金
    self.wholeAndSingleView.WholeOrderMoneyBlock = ^(double money) {
        
 
        weakSelf.sumMoney = money;
        [weakSelf loadSettleCaleIsWholeOrder:true];
        
        [weakSelf dateCancelResponseEvent];
        
    };
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
  //  [self addSearchBar];
    [self.addCustomView.textView becomeFirstResponder];// 2
    [self.IntegralInputVIew.textFiled becomeFirstResponder];// 2
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

- (SVNavShopView *)navShopView
{
    if (!_navShopView) {
        _navShopView = [[NSBundle mainBundle]loadNibNamed:@"SVNavShopView" owner:nil options:nil].lastObject;
      //  _navShopView.width = _navShopView.image.width + _navShopView.nameText.width;
       // NSString *sv_ul_name = [SVUserManager shareInstance].sv_us_name;
        _navShopView.image.image = [UIImage imageNamed:@"back2"];
        _navShopView.backgroundColor = navigationBackgroundColor;
        _navShopView.nameText.text = @"选择会员";
        _navShopView.nameText.textColor = [UIColor whiteColor];
        
    }
    
    return _navShopView;
}

#pragma mark - 清空按钮的点击
- (IBAction)emptyClick:(id)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.promptRenewalView];
    _promptRenewalView.renewLabel.text = @"确定清空吗？";
    [_promptRenewalView.renewBtn setTitle:@"清空" forState:UIControlStateNormal];
}

#pragma mark - TableView 的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return self.modelArr.count;
    NSLog(@"self.productResultsData.productResults = %@",self.productResultsData.productResults);
    return self.productResultsData.productResults.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVNewSettlementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVNewSettlementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.grade = self.grade;
    cell.sv_discount_configArray = self.sv_discount_configArray;
  //  cell.orderDetailsModel = self.modelArr[indexPath.row];
    cell.productResultslList = self.productResultsData.productResults[indexPath.row];
    cell.clearBtn.tag = indexPath.row;
    [cell.clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark - 点击删除按钮
- (void)clearBtnClick:(UIButton *)btn{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.promptRenewalView];
    _promptRenewalView.renewLabel.text = @"确定删除吗？";
    [_promptRenewalView.renewBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.promptRenewalView.renewBtn.tag = btn.tag;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheViewTwo];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editShopView];
    self.editShopView.grade = self.grade;
    self.editShopView.sv_discount_configArray = self.sv_discount_configArray;
    NSMutableDictionary *dict =self.resultArr[indexPath.row];
    self.editShopView.dict = dict;
    __weak typeof(self) weakSelf = self;
//    self.editShopView.editShopBlock = ^{
//      //  [weakSelf.tableView reloadData];
////        weakSelf.sumMoney = 0;
////        weakSelf.sumCount = 0;
////        weakSelf.sumDiscount = 0;
////        [weakSelf.maskTheViewTwo removeFromSuperview];
//
//
//        [weakSelf loadSettleCaleIsWholeOrder:false];
//        [weakSelf handlePan];
//
//        // 退出蒙版 刷新选择商品页面的数据
//        if (weakSelf.tuichuMengbanBlock) {
//            weakSelf.tuichuMengbanBlock();
//        }
//
//    };
    
    self.editShopView.editShopBlock = ^() {
        [weakSelf loadSettleCaleIsWholeOrder:false];
        [weakSelf handlePan];
        
        // 退出蒙版 刷新选择商品页面的数据
        if (weakSelf.tuichuMengbanBlock) {
            weakSelf.tuichuMengbanBlock();
        }
    };
    //实现弹出方法
    [UIView animateWithDuration:.3 animations:^{
        self.editShopView.frame = CGRectMake(0, ScreenH - editShopViewHeight, ScreenW, editShopViewHeight);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

#pragma mark - 点击组合支付按钮
- (void)PortfolioPaymentClick{
    [SVUserManager loadUserInfo];

   SVPortfolioPaymentVC *VC = [[SVPortfolioPaymentVC alloc] init];
   VC.stored = self.stored;
    [self handlePan];
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
  
    
  //
    NSString *money = [NSString stringWithFormat:@"%.2f",[self molingReceiveMoney:self.productResultsData.dealMoney]];
    if (self.isOpen == YES) {
        VC.money = money;
    }else{
        VC.money = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
    }
    
   __weak typeof(self) weakSelf = self;
   VC.selectMoneyArrayBlock = ^(NSMutableArray * _Nonnull array) {
       weakSelf.selectMoneyArray = array;
       NSLog(@"weakSelf.selectMoneyArray = %@",weakSelf.selectMoneyArray);
       NSMutableDictionary *dict1 = array[0];
       NSMutableDictionary *dict2 = array[1];
       NSString *title1 = dict1[@"title"];
       NSString *title2 = dict2[@"title"];
       if ([title1 isEqualToString:@"支付宝"]) {
           if ([self.sv_enable_alipay isEqualToString:@"1"]){
               self.payName = @"扫码支付";
               [self Scan];
           }else{
               self.payName = @"支付宝记账";
               dict1[@"title"] = @"支付宝记账";
               [self footerNext];
           }
           
       }else if ([title1 isEqualToString:@"微信"]){
           if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
               self.payName = @"扫码支付";
               [self Scan];
           }else{
               self.payName = @"微信记账";
               dict1[@"title"] = @"微信记账";
               [self footerNext];
           }
       }else if ([title2 isEqualToString:@"支付宝"]){
           if ([self.sv_enable_alipay isEqualToString:@"1"]){
               self.payName = @"扫码支付";
               [self Scan];
           }else{
               self.payName = @"支付宝记账";
               dict2[@"title"] = @"支付宝记账";
               [self footerNext];
           }
       }else if ([title2 isEqualToString:@"微信"]){
           if ([self.sv_enable_wechatpay isEqualToString:@"1"]){
               self.payName = @"扫码支付";
               [self Scan];
           }else{
               self.payName = @"微信记账";
               dict2[@"title"] = @"微信记账";
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

       if ([self.balance.text doubleValue] > [self.stored doubleValue] && [self.payName isEqualToString:@"储值卡"]) {
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
               self.addCustomView.name.text = @"请输入会员密码";
               [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
           }
       }else{
            [self loadPayMethod];
       }
}


- (void)loadPayMethod{
    //让按钮不可点
    self.view3.userInteractionEnabled = NO;
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
            self.view3.userInteractionEnabled = YES;
            //开启交互
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络出错,结算失败"];
        //让按钮可点
        self.view3.userInteractionEnabled = YES;
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
}

#pragma mark - 结算
-(void)receiptRequest:(NSString *)order_running_id {
    [self handlePan];
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


    /**
     积分抵扣
     */
    if (!kStringIsEmpty(self.integral)) {
        [md setObject:self.integral forKey:@"integral"];
    }

   // [md setObject:self.sumMoneyTwo forKey:@"order_receivable"];
    [md setObject:@"4" forKey:@"order_receivable"];
    // self.sumMoney
    NSString *deserved_cash = [NSString stringWithFormat:@"%.2f",self.totleMoney - self.sumMoneyTwo.doubleValue];

   // [md setObject:[NSString stringWithFormat:@"%.2f",self.totleMoney] forKey:@"sv_order_total_money"];

    [md setObject:deserved_cash forKey:@"deserved_cash"];
    // 开启积分模式
    [md setObject:@"true" forKey:@"MembershipGradeGroupingIsON"];

    //应收原金额    decimal    order_receivabley
  //  [md setObject:[NSString stringWithFormat:@"%.2f",self.sumMoney] forKey:@"order_receivabley"];


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

    }else{
        //收款方式    string    order_payment
        [md setObject:self.payName forKey:@"order_payment"];
        //付款金额    decimal    order_money
        [md setObject:[NSNumber numberWithDouble:self.productResultsData.dealMoney] forKey:@"order_money"];

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
    if ([self.NotesForWholeOrder.text isEqualToString:@"整单备注"]) {
        [md setObject:@"" forKey:@"sv_remarks"];
    } else {
        [md setObject:self.NotesForWholeOrder.text forKey:@"sv_remarks"];
    }

    [md setObject:@"102" forKey:@"sv_source_type"];

    // 成交价
    double TransactionPrice = 0.00;
    
    if (![SVTool isEmpty:self.productResultsData.productResults]) {
//        NSLog(@"self.resultArr55555 = %@",self.resultArr);
        NSMutableArray *guaDanArr = [NSMutableArray array];
        NSMutableArray *sv_preferential_dataArray = [NSMutableArray array];
        [SVUserManager loadUserInfo];
        double IntegralAverageDiscount = 1.00;
        if (self.integralCount > 0 && self.isSelectIntegralCircle == YES) {
            IntegralAverageDiscount = 1 - self.integralCount / self.sumMoney;
        }
        #pragma mark - plist列表
        for (NSInteger i = 0; i < self.productResultsData.productResults.count; i++) {
            SVProductResultslList *productResultslList = self.productResultsData.productResults[i];
            NSMutableDictionary *guaDanDic = [NSMutableDictionary dictionary];
          
            //商品ID
            [guaDanDic setObject:productResultslList.productId forKey:@"product_id"];
            //商品名
            [guaDanDic setObject:productResultslList.productName forKey:@"product_name"];
            //优惠
            [guaDanDic setObject:[NSNumber numberWithDouble:productResultslList.orderCouponMoney] forKey:@"orderCouponMoney"];
            //数量
            [guaDanDic setObject:[NSNumber numberWithDouble:productResultslList.number] forKey:@"product_num"];
            // 商品款号
            if (!kStringIsEmpty(productResultslList.barCode)) {
                [guaDanDic setObject:productResultslList.barCode forKey:@"sv_p_barcode"];
            }else{
                [guaDanDic setObject:@"" forKey:@"sv_p_barcode"];
            }

            // 特殊字段 用来打印优惠
           NSString *sv_p_unitprice =[NSString stringWithFormat:@"%.2f",productResultslList.price];
            if (kStringIsEmpty(sv_p_unitprice)) {
                [guaDanDic setObject:@"0" forKey:@"PrintingDiscount"];
            }else{
                [guaDanDic setObject:sv_p_unitprice forKey:@"PrintingDiscount"];
            }

            // 设置分类折
  
            // 商品规格
            if (!kStringIsEmpty(productResultslList.sepcs)) {
                [guaDanDic setObject:productResultslList.sepcs forKey:@"sv_p_specs"];
            }else{
                [guaDanDic setObject:@"" forKey:@"sv_p_specs"];
            }


          
            [guaDanDic setObject:[NSNumber numberWithDouble:productResultslList.totalMoney] forKey:@"product_total"];


            [guaDanDic setObject:[NSNumber numberWithDouble:productResultslList.dealPrice] forKey:@"product_unitprice"];
 

            [guaDanArr addObject:guaDanDic];


        }



        [md setObject:guaDanArr forKey:@"prlist"];
    }
    
    
    
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    NSMutableDictionary *caleDto = [NSMutableDictionary dictionary];
    NSMutableArray *buySteps = [NSMutableArray array];
    NSMutableArray *payments = [NSMutableArray array];
    if (![SVTool isEmpty:self.productResultsData.productResults]) {
        double IntegralAverageDiscount = 1.00;
      
        for (NSInteger i = 0; i < self.productResultsData.productResults.count; i++) {
            SVProductResultslList *productResultslList = self.productResultsData.productResults[i];
          //  NSMutableDictionary *dict = self.resultArr[i];
           // NSString *product_num = ;
            NSMutableArray *commissions = [NSMutableArray array];
            NSMutableDictionary *buyStepsDict = [NSMutableDictionary dictionary];
            [buyStepsDict setObject:[NSNumber numberWithInteger:productResultslList.index] forKey:@"index"];
            [buyStepsDict setObject:[NSString stringWithFormat:@"%.2f",productResultslList.number] forKey:@"number"];
            [buyStepsDict setObject:productResultslList.productId forKey:@"productId"];
            if (productResultslList.productChangePrice > 0) {
                [buyStepsDict setObject:[NSString stringWithFormat:@"%.2f",productResultslList.productChangePrice] forKey:@"productChangePrice"];
            }
           
            
            //提成员工ID
            if ([SVTool isBlankString:self.sv_employee_id]) {
               // [parames setObject:@"0" forKey:@"sv_commissionemployes"];
            } else {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                [dictM setObject:self.sv_employee_id forKey:@"employeeId"];
                [commissions addObject:dictM];
            }
            [buyStepsDict setObject:commissions forKey:@"commissions"];
            
            [buySteps addObject:buyStepsDict];
        }
    }
    [caleDto setObject:buySteps forKey:@"buySteps"];
    [caleDto setObject:[NSNumber numberWithInteger:3] forKey:@"currentStep"];
    if (self.productResultsData.orderChangeMoney > 0) {
        [caleDto setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.orderChangeMoney] forKey:@"orderChangeMoney"];
    }else if (self.productResultsData.orderChangeMoney == 0 && self.productResultsData.dealMoney == 0){
        [caleDto setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.orderChangeMoney] forKey:@"orderChangeMoney"];
    }
    if (![SVTool isBlankString:self.integral]) {
        // 积分字段
        [caleDto setObject:self.integral forKey:@"memberPoint"];

    }
    
    //会员卡号（实给会员ID)    string    user_cardno    没有会员，就给死@“0”
    if (![SVTool isBlankString:self.member_id]) {
        //会员卡号（实给会员ID)
        [caleDto setObject:self.member_id forKey:@"memberId"];

    }
    
    if (![SVTool isBlankString:self.sv_record_id]) {
        // 优惠券id
        [caleDto setObject:self.sv_record_id forKey:@"couponRecordId"];

    }
    
    if (self.selectMoneyArray.count == 2) {
        NSDictionary *dict1 = self.selectMoneyArray[0];
        NSDictionary *dict2 = self.selectMoneyArray[1];
        
        NSMutableDictionary *payment1 = [NSMutableDictionary dictionary];
        NSMutableDictionary *payment2 = [NSMutableDictionary dictionary];
        
        NSString *order_payment = dict1[@"title"];
        NSString *order_payment2 = dict2[@"title"];
        NSString *order_money = dict1[@"money"];
        NSString *order_money2 = dict2[@"money"];
            //收款方式    string    order_payment
        [payment1 setObject:order_payment forKey:@"name"];
            //付款金额    decimal    order_money
        [payment1 setObject:[NSNumber numberWithDouble:order_money.doubleValue] forKey:@"money"];

            //收款方式    string    order_payment2    给死@“待收”
        [payment2 setObject:order_payment2 forKey:@"name"];

            //付款金额    decimal    order_money2    给死@“0”
        [payment2 setObject:[NSNumber numberWithDouble:order_money2.doubleValue] forKey:@"money"];
        
        [payments addObject:payment1];
        [payments addObject:payment2];

    }else{
        //收款方式    string    order_payment
        NSMutableDictionary *payment1 = [NSMutableDictionary dictionary];
        [payment1 setObject:self.payName forKey:@"name"];
        //付款金额    decimal    order_money
       double money = [self molingReceiveMoney:self.productResultsData.dealMoney];
        if (self.isOpen == YES) {
            [payment1 setObject:[NSString stringWithFormat:@"%.2f",money] forKey:@"money"];
           
        }else{
            [payment1 setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] forKey:@"money"];
        }
        
       // [payment1 setObject:self.sumMoneyTwo forKey:@"money"];
        [payments addObject:payment1];

    }
    
    [parames setObject:caleDto forKey:@"caleDto"];
    [parames setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] forKey:@"dealMoney"];
//    [parames setObject:[NSString stringWithFormat:@"%.2f",self.totleMoney] forKey:@"totalMoney"];
    [parames setObject:@"0" forKey:@"exchangeMoney"];
    [parames setObject:[NSNumber numberWithBool:true] forKey:@"isSettle"];
    [parames setObject:payments forKey:@"payments"];
    [parames setObject:[NSNumber numberWithInteger:102] forKey:@"sourceType"];
    //判断是否是挂单结算   string  order_running_id
    if (![SVTool isBlankString:self.order_running_id]) {
       // [parames setObject:self.order_running_id forKey:@"orderRunningId"];
        [parames setObject:self.sv_without_list_id forKey:@"svWithoutListId"];
    } else {
       // [parames setObject:order_running_id forKey:@"orderRunningId"];orderRunningId
    }
  
    //备注
    if ([self.NotesForWholeOrder.text isEqualToString:@"整单备注"]) {
      //  [md setObject:@"" forKey:@"sv_remarks"];
    } else {
//        [md setObject:self.NotesForWholeOrder.text forKey:@"sv_remarks"];
        [parames setObject:self.NotesForWholeOrder.text forKey:@"remark"];
    }
    
    
    
    
    NSMutableDictionary *sbmitDict = [NSMutableDictionary dictionary];
    NSString *sURL;
    [SVUserManager loadUserInfo];
//    if ([self.payName isEqualToString:@"扫码支付"]) {
//        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
//        if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {
//            //授权码
//            [md setObject:self.authcode forKey:@"authcode"];
//            sURL = [URLhead stringByAppendingFormat:@"/api/ConvergePay/Settle/WithoutList?key=%@",[SVUserManager shareInstance].access_token];
//        }else{
//            //授权码
//            [md setObject:self.authcode forKey:@"authcode"];
//            sURL = [URLhead stringByAppendingFormat:@"/api/PayMent?key=%@",[SVUserManager shareInstance].access_token];
//        }
//
//        sbmitDict = md;
//    } else {
        NSString *timeStr = [SVTool timeAcquireCurrentDateSfm];
         /**
          字符串转时间戳

          @param timeStr 字符串时间
          @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
          @return 返回时间戳的字符串
          */
//            +(NSInteger)cTimestampFromString:(NSString *)timeStr
//                                      format:(NSString *)format;
        NSInteger timeInteger= [SVDateTool cTimestampFromString:timeStr format:@"yyyy-MM-dd HH:mm:ss"];
    [parames setObject:timeStr forKey:@"order_datetime"];
         //授权码
      //   [parames setObject:self.authcode forKey:@"authcode"];
    sURL = [URLhead stringByAppendingFormat:@"/api/Settle/Save?key=%@&Forbid=%ld",[SVUserManager shareInstance].access_token,(long)timeInteger];
        
        sbmitDict = parames;
//        sURL = [URLhead stringByAppendingFormat:@"/order?r=1&key=%@",[SVUserManager shareInstance].access_token];

  //  }

    NSLog(@"md = %@",parames);

    [[SVSaviTool sharedSaviTool] POST:sURL parameters:sbmitDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic----- = %@",dic);
        NSLog(@"surl = %@",sURL);
        // sv_remarks

            if ([dic[@"code"] integerValue] == 1) {

                //回调清除选择商品数据
                if (self.selectWaresBlock) {
                    self.selectWaresBlock();
                }
                
                // 发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:@"1"];
                
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                NSString *order_payment = md[@"order_payment"];
                NSString *order_payment2 = md[@"order_payment2"];
                NSString *order_money = md[@"order_money"];
                NSString *order_money2 = md[@"order_money2"];
               

               

                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];

                
                if ([order_payment isEqualToString:@"扫码支付"] || [order_payment2 isEqualToString:@"扫码支付"]) {
                    //回调清除选择商品数据
                    if (self.selectWaresBlock) {
                        self.selectWaresBlock();
                    }

//                        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
//                        if (code.doubleValue == 1) {
                            //开启交互
                            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                    SVSalesResultData *data = [SVSalesResultData mj_objectWithKeyValues:dic[@"data"]];
                        //  NSString *queryId = [NSString stringWithFormat:@"%@",dic[@"data"]];
                            [self ConvergePayB2CQueryId:data.queryId md:md];

                       // }
                }else{
                    SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];
                    VC.productResultsData = self.productResultsData;
                    double money =[self molingReceiveMoney:self.productResultsData.dealMoney];
                    if (self.isOpen == YES) {
                        VC.money =  [NSString stringWithFormat:@"%.2f",money];
                    }else{
                        VC.money = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
                    }
                    
                    
                    VC.interface = self.interface;
                    VC.vipName = self.name;

                    if (self.selectMoneyArray.count == 2) {
                        VC.pay = [NSString stringWithFormat:@"%@,%@",order_payment,order_payment2];
                    }else{
                        VC.pay = self.payName;
                    }

                    VC.member_Cumulative = self.member_Cumulative;
             //备注
             if ([self.NotesForWholeOrder.text isEqualToString:@"整单备注"]) {
                 VC.sv_remarks = @"";
             } else {
                 VC.sv_remarks = self.NotesForWholeOrder.text;
             }

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
                            VC.storedValue = [NSString stringWithFormat:@"%.2f",[self.stored doubleValue] - self.TotalAmount.text.doubleValue];

                        } else {
                            VC.storedValue = self.stored;
                        }
                    }
                    [self.navigationController pushViewController:VC animated:YES];
                }

                   } else {
                       //隐藏提示
                     //[MBProgressHUD hideHUDForView:self.view animated:YES];  [SVUserManager shareInstance].ConvergePay

                       if ([self.payName isEqualToString:@"扫码支付"]) {
                           NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                           if (![errmsg containsString:@"null"]) {
                               [SVTool TextButtonAction:self.view withSing:kStringIsEmpty(errmsg)?@"支付有误":errmsg];
                           }
                         

                       } else {

                           NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                           [SVTool TextButtonAction:self.view withSing:kStringIsEmpty(errmsg)?@"支付有误":errmsg];
                           
                           

                       }
                       
                       
//                       NSMutableDictionary *param = [NSMutableDictionary dictionary];
//                       param[@"createTime"] = [SVTool timeAcquireCurrentDateSfm];
//                       NSString *parameStr = [NSString jsonStringWithObject:parames];
//                       [param setObject:parameStr forKey:@"content"];
//
//                      NSString *url = [URLhead stringByAppendingFormat:@"/Log/Commit"];
//                       [[SVSaviTool sharedSaviTool] POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//                           if ([dic[@"succeed"] integerValue] == 1) {
//
//                           }
//
//                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                           //隐藏提示
//                           [MBProgressHUD hideHUDForView:self.view animated:YES];
//                           //[SVTool requestFailed];
//                           [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//                           //让按钮可点
//                           self.view3.userInteractionEnabled = YES;
//                           //开启交互
//                           [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
//                       }];
                           

                       //让按钮可点
                       self.view3.userInteractionEnabled = YES;
                       //开启交互
                       [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                   }

       
        #pragma mark - 这里是聚合支付的返回
//        if ([dic[@"code"] integerValue] == 1) {
//            //回调清除选择商品数据
//            if (self.selectWaresBlock) {
//                self.selectWaresBlock();
//            }
//
//                NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
//                if (code.doubleValue == 1) {
//                    //开启交互
//                    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
//
//                  NSString *queryId = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                    [self ConvergePayB2CQueryId:queryId md:md];
//
//                }
//
//        }else{
//
//        }
        
        //隐藏提示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //让按钮可点
        self.view3.userInteractionEnabled = YES;
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
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
        parame[@"money"] = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
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
                    VC.money = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
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
                 //   VC.sv_remarks = self.noteCellText;
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


//扫码结算调用
#pragma mark - 扫码结算调用
-(void)Scan{
    //移除
    [self handlePan];
    
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

- (SVWholeAndSingleView *)wholeAndSingleView{
    if (!_wholeAndSingleView) {
        _wholeAndSingleView = [[NSBundle mainBundle]loadNibNamed:@"SVWholeAndSingleView" owner:nil options:nil].lastObject;
        _wholeAndSingleView.frame = CGRectMake(30, 0, ScreenW -60,490);
       // .center = self.view.center;
        _wholeAndSingleView.titleLabel.text = @"整单优惠";
        _wholeAndSingleView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _wholeAndSingleView.layer.cornerRadius = 10;
        _wholeAndSingleView.layer.masksToBounds = YES;
        [_wholeAndSingleView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wholeAndSingleView;
}

#pragma mark - 收款view
- (SVSettlementCollectionView *)settlementCollectionView{
    if (!_settlementCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置垂直间距
        layout.minimumLineSpacing = 1;
        //设置水平间距
        layout.minimumInteritemSpacing = 0;
        _settlementCollectionView = [[NSBundle mainBundle]loadNibNamed:@"SVSettlementCollectionView" owner:nil options:nil].lastObject;
        _settlementCollectionView.frame =  CGRectMake(0, ScreenH, ScreenW, num);
      //  _editShopView.View1.backgroundColor = RGBA(0, 0, 0, 0.5);
       // .center = self.view.center;
       // _editShopView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _settlementCollectionView.collectionView.collectionViewLayout = layout;
        _settlementCollectionView.collectionView.delegate = self;
        _settlementCollectionView.collectionView.dataSource = self;
        [_settlementCollectionView.collectionView registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:CheckoutPayID];
        [_settlementCollectionView.PortfolioPaymentBtn addTarget:self action:@selector(PortfolioPaymentClick) forControlEvents:UIControlEventTouchUpInside];
        _settlementCollectionView.layer.cornerRadius = 10;
        _settlementCollectionView.layer.masksToBounds = YES;
        _settlementCollectionView.PortfolioPaymentView.layer.cornerRadius = 5;
        _settlementCollectionView.PortfolioPaymentView.layer.masksToBounds = YES;
        [_settlementCollectionView.tuichu addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _settlementCollectionView;
}

#pragma mark - 商品编辑view
- (SVEditShopView *)editShopView{
    if (!_editShopView) {
        _editShopView = [[NSBundle mainBundle]loadNibNamed:@"SVEditShopView" owner:nil options:nil].lastObject;
        _editShopView.frame =  CGRectMake(0, ScreenH, ScreenW, editShopViewHeight);
      //  _editShopView.View1.backgroundColor = RGBA(0, 0, 0, 0.5);
       // .center = self.view.center;
       // _editShopView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _editShopView.layer.cornerRadius = 10;
        _editShopView.layer.masksToBounds = YES;
        [_editShopView.tuichu addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editShopView;
}

//移除
- (void)handlePan{
    [self.maskTheViewTwo removeFromSuperview];
    [UIView animateWithDuration:.5 animations:^{
        self.editShopView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-num);
    }];
    
    [UIView animateWithDuration:.3 animations:^{
        self.settlementCollectionView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-num);
    }];
    
}

//SVEditShopView

/**
 日期遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

-(UIView *)maskTheViewTwo{
    if (!_maskTheViewTwo) {
        _maskTheViewTwo = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheViewTwo.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheViewTwo addGestureRecognizer:tap];
    }
    return _maskTheViewTwo;
}


//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.wholeAndSingleView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
    [self.addCustomView removeFromSuperview];
    [self.IntegralInputVIew removeFromSuperview];
  
}
#pragma mark - 确定删除的提示view
- (SVPromptRenewalView *)promptRenewalView{
    if (_promptRenewalView == nil) {
        _promptRenewalView = [[NSBundle mainBundle] loadNibNamed:@"SVPromptRenewalView" owner:nil options:nil].lastObject;
       _promptRenewalView.frame = CGRectMake(40, 20, ScreenW - 80, 250);
       _promptRenewalView.layer.cornerRadius = 10;
       _promptRenewalView.layer.masksToBounds = YES;
        _promptRenewalView.renewLabel.text = @"确定删除吗？";
       _promptRenewalView.centerY = ScreenH/2;
        [_promptRenewalView.renewBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [_promptRenewalView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_promptRenewalView.renewBtn addTarget:self action:@selector(goLoginClick:) forControlEvents:UIControlEventTouchUpInside];
         [_promptRenewalView.clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    }
     return _promptRenewalView;
}

#pragma mark - 点击个别商品删除按钮
- (void)goLoginClick:(UIButton *)btn{
    
    
    if ([_promptRenewalView.renewLabel.text isEqualToString:@"确定删除吗？"]) {
        [self.maskTheView removeFromSuperview];
        [self.promptRenewalView removeFromSuperview];
        [self.resultArr removeObjectAtIndex:btn.tag];
        
        
        
        if (self.resultArr.count == 0) {
            [self setUpBottomAddBtn];
        }else{
            self.shopViewHeight.constant = 33 + self.resultArr.count * rowHeight;
       
            
            // 退出蒙版 刷新选择商品页面的数据
            if (self.tuichuMengbanBlock) {
                self.tuichuMengbanBlock();
            }
        }
        
        
//        if (self.integralCount > self.productResultsData.dealMoney) {
//            double integralMoney = self.productResultsData.dealMoney;
//            double integral = self.productResultsData.dealMoney;
//            self.integralCount = integralMoney;
//
//            self.integralMoney = self.integralCount * self.autoStr.integerValue;
//            self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%f元",self.integralMoney,self.integralCount];
//            /**
//             积分抵扣字段
//             */
//            self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
//
//
//        }else{
//            self.isSelectIntegralCircle = YES;
//            double money = self.productResultsData.dealMoney - self.integralCount;
//           // self.sumMoney = money;
//            /**
//             积分抵扣字段
//             */
//            self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
//
//
//        }
        
        if (self.circleBtn.selected == YES) {
            if (self.integralCount > self.productResultsData.dealMoney) {
                double integralMoney = self.productResultsData.dealMoney;
                double integral = self.productResultsData.dealMoney;
                self.integralCount = integralMoney;
                
                self.integralMoney = self.integralCount * self.autoStr.integerValue;
                self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%.2f元",self.integralMoney,self.integralCount];
                /**
                 积分抵扣字段
                 */
                self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
//                self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",integral - integralMoney];
//                self.TotalAmount.text = [NSString stringWithFormat:@"%.2f",integral - integralMoney];
            }else{
                self.isSelectIntegralCircle = YES;
              //  double money = self.productResultsData.dealMoney - self.integralCount;
//                self.sumMoneyTwo = [NSString stringWithFormat:@"%.2f",money];
                /**
                 积分抵扣字段
                 */
                self.integral = [NSString stringWithFormat:@"%ld",self.integralMoney];
//                self.TotalAmount.text = [NSString stringWithFormat:@"%.2f",money];
             
            }
        }
        
        [self loadSettleCaleIsWholeOrder:false];
    }else{
       [self.maskTheView removeFromSuperview];
       [self.promptRenewalView removeFromSuperview];
        [self.resultArr  removeAllObjects];

        [self setUpBottomAddBtn];
        
    }
    
}

- (void)setUpBottomAddBtn{
    
    if (self.tuichuMengbanBlock) {
        self.tuichuMengbanBlock();
    }
    
    if (self.deleteMemberBlock) {
        self.deleteMemberBlock();
    }
    
    //添加按钮
    UIButton* addButton = [[UIButton alloc] init];
   // self.addButton.hidden = YES;
    addButton.layer.cornerRadius = 6;
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [addButton setTitle:@"+ 添加商品" forState:UIControlStateNormal];
    [addButton setBackgroundColor:navigationBackgroundColor];
    [addButton addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    backView.backgroundColor = BackgroundColor;
    [self.view addSubview:backView];
    [backView addSubview:addButton];
    //addButtonFrame
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 45));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

- (void)addWaresButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击取消弹框
- (void)clearClick{
    [self.maskTheView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
}

#pragma mark - 销售人员
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

#pragma mark - 点击手势的点击事件
- (void)unitDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    //获取pickerView中第0列的选中值
    NSInteger row=[self.pickerView.unitPicker selectedRowInComponent:0];
    self.salesman.text = [self.sv_employee_nameArr objectAtIndex:row];
   // self.threeCellText = self.threeLabel.text;
    self.sv_employee_id = [NSString stringWithFormat:@"%@",[self.sv_employee_idArr objectAtIndex:row]];
}

- (void)unitCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.IntegralInputVIew removeFromSuperview];
    [self.pickerView removeFromSuperview];
    
//    [self.addCustomView removeFromSuperview];
//    self.addCustomView.textView.text = nil;
//    self.IntegralInputVIew.textFiled.text = nil;
}
#pragma mark - 点击优惠券
- (void)couponViewClick
{
    SVCouponListVC *vc = [[SVCouponListVC alloc] init];
    vc.totle_money = self.TotalAmount.text;
    vc.selIndex = self.selIndex;
    vc.member_id = self.member_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.couponBlock = ^(SVCouponListModel * _Nonnull model, NSIndexPath * _Nonnull selectIndex) {
        self.selIndex = selectIndex;
        if ([model.sv_coupon_type isEqualToString:@"0"]) {// 代金券
            self.couponName.text = model.sv_coupon_name;

                NSString *coupon_money;
                self.couponMoney.text = [NSString stringWithFormat:@"-￥%.2f", model.sv_coupon_money.doubleValue];
                
                self.couponMoney.textColor = an_redColor;

            self.sv_coupon_amount = model.sv_coupon_money;
            self.sv_record_id = model.sv_record_id;

        }else{// 折扣卷
            self.couponName.text = model.sv_coupon_name;
            

            self.couponMoney.text = [NSString stringWithFormat:@"-￥%.2f",self.TotalAmount.text.doubleValue - self.TotalAmount.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
            NSString *money = [NSString stringWithFormat:@"%.2f",self.TotalAmount.text.doubleValue - self.TotalAmount.text.doubleValue * model.sv_coupon_money.doubleValue *0.01];
            
            self.couponMoney.textColor = an_redColor;
            
            self.wholeOrderDiscount = model.sv_coupon_money.doubleValue * 0.1;

            self.sv_coupon_discount = model.sv_coupon_money;
            self.sv_record_id = model.sv_record_id;
            


        }
        [self loadSettleCaleIsWholeOrder:false];
        
    };
    
    
}

- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.name.text = @"整单备注";
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}

#pragma mark - 整单备注自定义弹框的确定按钮
- (void)sureBtnClick{
    if ([self.addCustomView.name.text isEqualToString:@"请输入会员密码"]) {
        if ([self.addCustomView.textView.text isEqualToString:self.sv_mr_pwd]) {
           // [SVTool TextButtonActionWithSing:@"密码正确"];
             [self dateCancelResponseEvent];
                //让按钮不可点
             [self loadPayMethod];
            
        }else{
            [SVTool TextButtonActionWithSing:@"密码错误"];
            [self dateCancelResponseEvent];
        }
    }else{
        if (!kStringIsEmpty(self.addCustomView.textView.text)) {
            [self.addCustomView.textView endEditing:YES];
            [self dateCancelResponseEvent];
            self.NotesForWholeOrder.text = self.addCustomView.textView.text;
            self.NotesForWholeOrder.textColor = an_blackColor;
            self.addCustomView.textView.text = nil;
        }else{
        [self.addCustomView.textView endEditing:YES];
        [self dateCancelResponseEvent];
        self.NotesForWholeOrder.text = @"整单备注";
        self.NotesForWholeOrder.textColor = an_gradeColor;
            self.addCustomView.textView.text = nil;
        }
    }
  
  
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
        [_IntegralInputVIew.sureBtn addTarget:self action:@selector(integralInputVIewSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _IntegralInputVIew;
}
#pragma mark - 点击积分弹出框确定按钮
- (void)integralInputVIewSureBtnClick{
    
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
        self.integralMoney = self.integralCount * self.autoStr.integerValue;
       // [self.tableView reloadData];
       // self.integralMoney = self.integralCount * self.autoStr.integerValue;
        self.IntegralInformation.text = [NSString stringWithFormat:@"可使用%ld积分抵扣%.2f元",(long)self.integralMoney,self.integralCount];
        [self unitCancelResponseEvent];
    }
}


- (void)cancleBtnClick{
    [self dateCancelResponseEvent];
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

- (NSMutableArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)iconArr{
    if (_iconArr == nil) {
        _iconArr = [NSMutableArray array];
    }
    return _iconArr;
}

- (NSMutableArray *)titleArr_member{
    if (_titleArr_member == nil) {
        _titleArr_member = [NSMutableArray array];
    }
    return _titleArr_member;
}

- (NSMutableArray *)iconArr_member{
    if (_iconArr_member == nil) {
        _iconArr_member = [NSMutableArray array];
    }
    return _iconArr_member;
}

- (NSMutableArray *)vipTitleArr{
    if (_vipTitleArr == nil) {
        _vipTitleArr = [NSMutableArray array];
    }
    return _vipTitleArr;
}

- (NSMutableArray *)vipTitleImg{
    if (_vipTitleImg == nil) {
        _vipTitleImg = [NSMutableArray array];
    }
    return _vipTitleImg;
}

- (NSMutableArray *)selectMoneyArray
{
    if (!_selectMoneyArray) {
        _selectMoneyArray = [NSMutableArray array];
    }
    
    return _selectMoneyArray;
}
@end

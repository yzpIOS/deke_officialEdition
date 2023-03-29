//
//  SVRightScreenVIew.m
//  SAVI
//
//  Created by houming Wang on 2020/11/20.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVRightScreenVIew.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVvipPickerView.h"
#import "SVgenderPickerView.h"
#import "PaymentMethodModel.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)

#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

#define backColor [UIColor colorWithHexString:@"f7f7f7"]

#define btnWidth  [UIScreen mainScreen].bounds.size.width / 6 *5 - 50

@interface SVRightScreenVIew()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *PaymentMethod;
@property (weak, nonatomic) IBOutlet UIView *StoreInquiryView;
@property (weak, nonatomic) IBOutlet UIView *memberInfoView;

@property (weak, nonatomic) IBOutlet UIView *SerialNumberView;
@property (weak, nonatomic) IBOutlet UIView *commodityInfoView;
@property (weak, nonatomic) IBOutlet UIView *OperatorView;
@property (nonatomic,strong) NSMutableArray *ConsumersArray;
@property (nonatomic,strong) NSMutableArray *SourcesOfConsumptionArray;

@property (weak, nonatomic) IBOutlet UIView *paymentMethodView;
@property (weak, nonatomic) IBOutlet UIView *ConsumersView;
@property (weak, nonatomic) IBOutlet UIView *SourcesOfConsumptionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentMethodViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentMethodViewBigHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConsumersViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConsumersViewBigHeight;

@property (weak, nonatomic) IBOutlet UIView *SourcesOfConsumptionViewBig;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soucesBigViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soucesViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic,strong) UIButton *PaymentMethodBtn;
@property (nonatomic,strong) UIButton *ConsumersBtn;
@property (nonatomic,strong) UIButton *SourcesBtn;


@property (weak, nonatomic) IBOutlet UITextField *memberInfoText;
@property (weak, nonatomic) IBOutlet UITextField *SerialNumberText;
@property (weak, nonatomic) IBOutlet UITextField *commodityInfoText;


//vippickerView
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
@property (nonatomic,strong) SVgenderPickerView *genderPickerView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSArray *letter;
@property (nonatomic,strong) UIView *maskTheView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OnetopHeight;

@property (nonatomic,assign) CGFloat height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollView_top_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storetopHeight;
@property (weak, nonatomic) IBOutlet UIView *storeView;
@property (weak, nonatomic) IBOutlet UIImageView *sanjianxing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewTop;

@end
@implementation SVRightScreenVIew

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.storeView.layer.cornerRadius = 19;
    self.storeView.layer.masksToBounds = YES;
    self.storeView.layer.borderWidth = 1;
    self.storeView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.StoreInquiryView.layer.cornerRadius = 19;
    self.StoreInquiryView.layer.masksToBounds = YES;
    self.StoreInquiryView.layer.borderWidth = 1;
    self.StoreInquiryView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.memberInfoView.layer.cornerRadius = 19;
    self.memberInfoView.layer.masksToBounds = YES;
    self.memberInfoView.layer.borderWidth = 1;
    self.memberInfoView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.SerialNumberView.layer.cornerRadius = 19;
    self.SerialNumberView.layer.masksToBounds = YES;
    self.SerialNumberView.layer.borderWidth = 1;
    self.SerialNumberView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.commodityInfoView.layer.cornerRadius = 19;
    self.commodityInfoView.layer.masksToBounds = YES;
    self.commodityInfoView.layer.borderWidth = 1;
    self.commodityInfoView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.OperatorView.layer.cornerRadius = 19;
    self.OperatorView.layer.masksToBounds = YES;
    self.OperatorView.layer.borderWidth = 1;
    self.OperatorView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.cancleBtn.layer.cornerRadius = 19;
    self.cancleBtn.layer.masksToBounds = YES;
    self.cancleBtn.layer.borderWidth = 1;
    self.cancleBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    
    
//    self.rightScreenVIew.payName = self.payName;
//    // 选了什么关键字
//  //  @property (nonatomic,copy) NSString *searchSelectName;
//    // 散客会员
//    self.rightScreenVIew.type = self.type;
//    // 订单号关键字
//    self.rightScreenVIew.liushui = self.liushui;
//    // 店铺查询
//    self.rightScreenVIew.storeid = self.storeid;
//    // 操作员信息关键字
//  //  self.rightScreenVIew.seller = self.seller;
//    // 指定会员的会员ID
//   // vc.memberId = self.memberId;
//    // 订单来源
//    self.rightScreenVIew.orderSource = self.orderSource;
//    // 商品信息
//    self.rightScreenVIew.product = self.product;
//    // 搜索会员信息
//    self.rightScreenVIew.seachMemberStr = self.seachMemberStr;
//    self.sv_employee_id = @"";
//    self.rightScreenVIew.sv_employee_id = self.sv_employee_id;
//
//    self.rightScreenVIew.operationLabel.text = @"请选择操作人员";
//    self.rightScreenVIew.operationLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    
   // self.storeid = [SVUserManager shareInstance].user_id;// 当前店铺
//    self.memberId = @"";// 会员信息
//    self.payName = @""; // 支付方式
//    self.type = @""; // 消费对象
//    self.orderSource = @""; // 消费来源
//    self.liushui = @""; // 流水单号
//    self.product = @""; // 商品信息
//   // self.sv_employee_id = @""; // 操作人员
//    self.seachMemberStr = @"";
//    self.sv_employee_id = @"";
//  
//    self.shopId = [SVUserManager shareInstance].user_id;// 当前店铺;
//   // self.rightScreenVIew.shopId = self.storeid;
//    self.shopInfoLabel.text =  [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
//    
//    
//    self.operationLabel.text = @"请选择操作人员";
//    self.operationLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    
//    self.memberInfoText.text = self.seachMemberStr;
//    self.SerialNumberText.text = self.liushui;
//    self.commodityInfoText.text = self.product;
//    if (!kStringIsEmpty(self.seller)) {
//        self.operationLabel.text = self.seller;
//    }
    

    if (ScreenH == 812) {
       // images = @[@"GuidePages_1_1", @"GuidePages_2_2", @"GuidePages_3_3", @"GuidePages_4_4",@"GuidePages_5_5"];
        self.oneViewTop.constant = 45;

    } else {
      //  images = @[@"GuidePages_1", @"GuidePages_2", @"GuidePages_3", @"GuidePages_4",@"GuidePages_5"];
        self.oneViewTop.constant = 30;
    }

    self.sv_employee_id = @"";
    self.orderSource = @"";
    self.payName = @"";
    self.type = @"";
   // self.seller = @"";
    self.memberId = @"";
    self.liushui = @"";
    self.product = @"";
       self.memberInfoText.text = self.memberId;
       self.SerialNumberText.text = self.liushui;
       self.commodityInfoText.text = self.product;
       self.operationLabel.text = @"请选择操作人员";
    
    self.shopInfoLabel.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
    self.shopId = [SVUserManager shareInstance].user_id;// 当前店铺;

    
    self.sureBtn.layer.cornerRadius = 20;
    self.sureBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StoreInquiryViewClick)];
    [self.storeView addGestureRecognizer:tag];
    
    UITapGestureRecognizer *OperatorViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OperatorViewClick)];
       [self.OperatorView addGestureRecognizer:OperatorViewtag];
    
  
    [self loadpayButton];
   // self.navigationItem.title = @"账单搜索";
    // 加载按钮
    [self setUpConsumersView];
    [self setUpSourcesOfConsumptionView];
    [self allStoreData];
    [self loadoperationData];
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    if (kDictIsEmpty(sv_versionpowersDict)) {
       
     
    }else{
        NSDictionary *StockManage = sv_versionpowersDict[@"StockManage"];
        if (kDictIsEmpty(StockManage)) {
//            self.JurisdictionNum = 1;// 不用显示*号
//            self.cleanMemberNum = 1; //不删除会员
           
        }else{
            // 是否显示完整手机号
           NSString *StorEquery_Jurisdiction = [NSString stringWithFormat:@"%@",StockManage[@"StorEquery_Jurisdiction"]];
            if (kStringIsEmpty(StorEquery_Jurisdiction)) {
                // self.JurisdictionNum = 1;// 不用显示*号
            }else{
                if ([StorEquery_Jurisdiction isEqualToString:@"1"]) {
                   // self.JurisdictionNum = 1;// 不用显示*号
                }else{
                   // self.JurisdictionNum = 0;// 显示*号
                    self.shopInfoLabel.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
                    self.shopInfoLabel.textColor = [UIColor colorWithHexString:@"999999"];
                    self.sanjianxing.image = [UIImage imageNamed:@"sanjiaoxing_huise"];
                    self.storeView.userInteractionEnabled = NO;
                    
                }
            }
        }
    }
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
               // self.paymentMethodModel = model;
                NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"全部",@"现金",@"储值卡",@"扫码支付",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                NSMutableArray *iconArr = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
                
               
                // 处理选择会员的情况
                NSMutableArray *titleArr_member = [NSMutableArray arrayWithObjects:@"全部",@"现金",@"储值卡",@"扫码支付",@"支付宝",@"微信",@"银行卡",@"优惠券",@"闪惠",@"赊账",nil];
                NSMutableArray *iconArr_member = [NSMutableArray arrayWithObjects:@"sales_cash",@"sales_stored",@"saoma",@"sales_treasure",@"sales_wechat",@"sales_unionpay",@"sales_coupons",@"sales_shanhui",@"sales_owe",nil];
             
                
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
                
//                if ([model.p_meituan containsString:@"true"]) {
//                    [array addObject:model.p_meituan];
//                }else{
//                    [titleArr removeObject:@"美团"];
//                    [iconArr removeObject:@"sales_regiment"];
//
//                    [titleArr_member removeObject:@"美团"];
//                    [iconArr_member removeObject:@"sales_regiment"];
//                }
//
//                if ([model.p_koubei containsString:@"true"]) {
//                    [array addObject:model.p_koubei];
//                }else{
//                    [titleArr removeObject:@"口碑"];
//                    [iconArr removeObject:@"sales_publicpraise"];
//
//                    [titleArr_member removeObject:@"口碑"];
//                    [iconArr_member removeObject:@"sales_publicpraise"];
//                }
                
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
                
                self.PaymentMethod = titleArr;
                [self setUpAllUI];
//
        }else{
            
        }
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
}

#pragma mark - 全部店铺
- (void)allStoreData{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/CargoflowData/GetShopList?key=%@",token];
    NSLog(@"总店dURL = %@",dURL);
    
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"总店dic = %@",dic);
        NSArray *list = dic[@"values"][@"list"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"user_id"] = @"-1";
        dict[@"sv_us_name"] = @"全部店铺";
        [self.listArray addObject:dict];
        [self.listArray addObjectsFromArray:list];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self animated:YES];
        [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
}

- (void)loadoperationData{
    [SVUserManager loadUserInfo];
      NSString *token = [SVUserManager shareInstance].access_token;
      NSString *dURL=[URLhead stringByAppendingFormat:@"/api/Salesclerk/GetSalesclerkInfo?key=%@",token];
      NSLog(@"总店dURL = %@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"操作员dic = %@",dic);
        
        NSString *code=dic[@"code"];
        NSString *msg=dic[@"msg"];
        if ([code isEqual:@1]) {
            NSArray *list = dic[@"data"][@"list"];
             self.letter = list;
        }else{
            [SVTool TextButtonActionWithSing:msg?:@"获取失败"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
               [MBProgressHUD hideHUDForView:self animated:YES];
               [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
}
#pragma mark - 确定按钮
- (IBAction)determineClick:(id)sender {
    if (self.InquirySalesBlock) {
        self.InquirySalesBlock(self.shopId, self.memberInfoText.text, self.PaymentMethodBtn.titleLabel.text, self.ConsumersBtn.titleLabel.text, self.SourcesBtn.titleLabel.text, self.SerialNumberText.text, self.commodityInfoText.text,self.sv_employee_id);
    }
    self.operationLabel.text = @"请选择操作人员";
    self.operationLabel.textColor = [UIColor colorWithHexString:@"999999"];
    //  [self.navigationController popViewControllerAnimated:YES];
}

- (void)StoreInquiryViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
}

- (void)OperatorViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.genderPickerView];
}

#pragma mark - 返回
- (IBAction)cancleClick:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    
    self.operationLabel.text = @"请选择操作人员";
    self.operationLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    self.shopInfoLabel.text = @"请选择操作人员";
//    self.shopInfoLabel.textColor = [UIColor colorWithHexString:@"999999"];
}

#pragma mark - 重置
- (IBAction)ResetClick:(id)sender {
    self.sv_employee_id = @"";
    self.orderSource = @"";
    self.payName = @"";
    self.type = @"";
   // self.seller = @"";
    self.memberId = @"";
    self.liushui = @"";
    self.product = @"";
       self.memberInfoText.text = self.memberId;
       self.SerialNumberText.text = self.liushui;
       self.commodityInfoText.text = self.product;
       self.operationLabel.text = @"请选择操作人员";
    
    self.shopInfoLabel.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
    self.shopId = [SVUserManager shareInstance].user_id;// 当前店铺;
    [self setUpAllUI];
    [self setUpConsumersView];
    [self setUpSourcesOfConsumptionView];
  
}

- (void)setUpAllUI{
      [self.paymentMethodView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 支付方式
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<self.PaymentMethod.count; i++) {
        NSString *paymentStr = self.PaymentMethod[i];
        CGSize tagTextSize = [paymentStr sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(btnWidth-20, 32)];
        NSLog(@"支付方式------%.2f",tagTextSize.width);
        if (tagBtnX+tagTextSize.width-10 > btnWidth) {

            tagBtnX = 0;
            tagBtnY += 32+15;
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        tagBtn.tag = i;
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 32);
        [tagBtn setTitle:paymentStr forState:UIControlStateNormal];
        [tagBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
        [tagBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
        
        tagBtn.layer.cornerRadius = 16.f;
        tagBtn.layer.masksToBounds = YES;
        
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
      //  tagBtn.layer.borderColor = navigationBackgroundColor.CGColor;
       
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.paymentMethodView addSubview:tagBtn];
        if (i == 0) {
            [self tagBtnClick:tagBtn];
        }
        
        if (!kStringIsEmpty(self.payName)) {
            if ([self.payName isEqualToString:paymentStr]) {
                 [self tagBtnClick:tagBtn];
            }
        }
        
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
        
        self.paymentMethodViewHeight.constant = tagBtnY + 32;
        self.paymentMethodViewBigHeight.constant = tagBtnY + 32 + 38;
        NSLog(@"tagBtnY = %f",tagBtnY);
        NSLog(@"tagBtnX = %f",tagBtnX);
        
    }
}

#pragma mark - 消费对象
- (void)setUpConsumersView{
    [self.ConsumersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.ConsumersArray.count; i++) {
            NSString *paymentStr = self.ConsumersArray[i];
            CGSize tagTextSize = [paymentStr sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(btnWidth-20, 32)];
            NSLog(@"消费对象------%.2f",tagTextSize.width);
            if (tagBtnX+tagTextSize.width-10 > btnWidth) {
                
                tagBtnX = 0;
                tagBtnY += 32+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 32);
            [tagBtn setTitle:paymentStr forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                   [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
                   [tagBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
                   
                   tagBtn.layer.cornerRadius = 16.f;
                   tagBtn.layer.masksToBounds = YES;
                   
                   tagBtn.layer.borderWidth = 1;
                   tagBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
            
            
            [tagBtn addTarget:self action:@selector(tagBtnConsumersClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.ConsumersView addSubview:tagBtn];
            if (i == 0) {
                [self tagBtnConsumersClick:tagBtn];
            }
            
            if (!kStringIsEmpty(self.type)) {
                if ([self.type isEqualToString:paymentStr]) {
                    [self tagBtnConsumersClick:tagBtn];
                }
           }
            
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.ConsumersViewHeight.constant = tagBtnY + 32;
            self.ConsumersViewBigHeight.constant = tagBtnY + 32 + 38;
        }
}
#pragma mark - 消费来源
- (void)setUpSourcesOfConsumptionView{
     [self.SourcesOfConsumptionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.SourcesOfConsumptionArray.count; i++) {
            NSString *paymentStr = self.SourcesOfConsumptionArray[i];
            CGSize tagTextSize = [paymentStr sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(btnWidth-20, 32)];
            NSLog(@"消费来源------%.2f",tagTextSize.width);
            if (tagBtnX+tagTextSize.width-20 > btnWidth) {
                
                tagBtnX = 0;
                tagBtnY += 32+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 32);
            [tagBtn setTitle:paymentStr forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                   [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
                   [tagBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
                   
                   tagBtn.layer.cornerRadius = 16.f;
                   tagBtn.layer.masksToBounds = YES;
                   
                   tagBtn.layer.borderWidth = 1;
                   tagBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
            
            [tagBtn addTarget:self action:@selector(tagBtnSourcesClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.SourcesOfConsumptionView addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            if (i == 0) {
                [self tagBtnSourcesClick:tagBtn];
            }
            
            if (!kStringIsEmpty(self.orderSource)) {
                 if ([self.orderSource isEqualToString:paymentStr]) {
                     [self tagBtnSourcesClick:tagBtn];
                 }
            }
            
            self.soucesViewHeight.constant = tagBtnY + 32;
            self.soucesBigViewHeight.constant = tagBtnY + 32 + 38;
 
        }
}
#pragma mark -
- (void)tagBtnClick:(UIButton *)btn{
    self.PaymentMethodBtn.selected = NO;

    [self.PaymentMethodBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.PaymentMethodBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.PaymentMethodBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
       btn.selected = YES;
     //  btn.layer.borderColor = [[UIColor clearColor] CGColor];
      // btn.backgroundColor = navigationBackgroundColor;
       [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
       btn.layer.borderColor = navigationBackgroundColor.CGColor;
       [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
       self.PaymentMethodBtn = btn;
}

- (void)tagBtnConsumersClick:(UIButton *)btn{
    self.ConsumersBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.ConsumersBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.ConsumersBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.ConsumersBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
   
        self.ConsumersBtn = btn;
}

- (void)tagBtnSourcesClick:(UIButton *)btn{
    self.SourcesBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
//        self.SourcesBtn.backgroundColor = backColor;
    [self.SourcesBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.SourcesBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.SourcesBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
      //  btn.layer.borderColor = [[UIColor clearColor] CGColor];
       // btn.backgroundColor = navigationBackgroundColor;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
        self.SourcesBtn = btn;
}

#pragma mark - 点击店铺确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
       NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    NSDictionary *dic = [self.listArray objectAtIndex:row];
    self.shopInfoLabel.text = dic[@"sv_us_name"];
   // self.operationLabel.text = dic[@"sp_salesclerk_name"];
    self.shopInfoLabel.textColor = [UIColor blackColor];
    self.shopId = dic[@"user_id"];
    [self.vipPickerView removeFromSuperview];
}


//- (NSMutableArray *)PaymentMethod
//{
//    if (!_PaymentMethod) {
//        _PaymentMethod = [NSMutableArray arrayWithObjects:@"全部",@"微信支付",@"支付宝",@"现金",@"微信记账",@"支付宝记账",@"银行卡",@"储值卡",@"赊账",@"美团",@"口碑",@"闪惠", nil];
//
//    }
//
//    return _PaymentMethod;
//}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)ConsumersArray{
    if (!_ConsumersArray) {
        _ConsumersArray = [NSMutableArray arrayWithObjects:@"全部",@"散客消费",@"会员消费", nil];
    }
    
    return _ConsumersArray;
}

- (NSMutableArray *)SourcesOfConsumptionArray{
    if (!_SourcesOfConsumptionArray) {
        _SourcesOfConsumptionArray = [NSMutableArray arrayWithObjects:@"全部",@"线下订单",@"线上订单", nil];
    }
    return _SourcesOfConsumptionArray;
}



/**
 日期遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}


- (void)vipCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.vipPickerView removeFromSuperview];
    [self.genderPickerView removeFromSuperview];
}

#pragma mark - 懒加载
//等级pickerView
-(SVvipPickerView *)vipPickerView{
    if (!_vipPickerView) {
        _vipPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _vipPickerView.frame = CGRectMake(0, 0, 320, 230);
        _vipPickerView.centerX = ScreenW / 2;
        _vipPickerView.centerY = ScreenH / 2;
        _vipPickerView.backgroundColor = [UIColor whiteColor];
        _vipPickerView.layer.cornerRadius = 10;
        _vipPickerView.vipPicker.delegate = self;
        _vipPickerView.vipPicker.dataSource = self;
        [_vipPickerView.vipCancel addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_vipPickerView.vipDetermine addTarget:self action:@selector(vipDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipPickerView;
}


/**
 操作人员
 */
-(SVgenderPickerView *)genderPickerView{
    if (!_genderPickerView) {
        _genderPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVgenderPickerView" owner:nil options:nil].lastObject;
        _genderPickerView.frame = CGRectMake(0, 0, 320, 230);
        _genderPickerView.centerX = ScreenW / 2;
        _genderPickerView.centerY = ScreenH / 2;
        _genderPickerView.backgroundColor = [UIColor whiteColor];
        _genderPickerView.layer.cornerRadius = 10;
        _genderPickerView.genderPicker.delegate = self;
        _genderPickerView.genderPicker.dataSource = self;
        [_genderPickerView.genderCancel addTarget:self action:@selector(genderCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_genderPickerView.genderDetermine addTarget:self action:@selector(genderDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _genderPickerView;
}

- (void)genderCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.genderPickerView removeFromSuperview];
}
#pragma mark - 点击操作员确定按钮
- (void)genderDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
          NSInteger row = [self.genderPickerView.genderPicker selectedRowInComponent:0];
       NSDictionary *dic = [self.letter objectAtIndex:row];
       self.operationLabel.text = dic[@"sp_salesclerk_name"];
       self.operationLabel.textColor = [UIColor blackColor];
       self.sv_employee_id = dic[@"sp_salesclerkid"];
       
       [self.genderPickerView removeFromSuperview];
}

#pragma mark  - UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.vipPickerView.vipPicker) {
        return self.listArray.count;
    }else{
        return self.letter.count;
    }
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.vipPickerView.vipPicker) {
        NSDictionary *dict = self.listArray[row];
        NSString *sv_us_name = dict[@"sv_us_name"];
        return sv_us_name;
    }else{
       // return self.letter[row];
        NSDictionary *dict = self.letter[row];
        NSString *sv_employee_name = dict[@"sp_salesclerk_name"];
        return sv_employee_name;
   }
}

-(NSArray *)letter{
    if (!_letter) {
        _letter = [NSArray array];
    }
    return _letter;
}

@end

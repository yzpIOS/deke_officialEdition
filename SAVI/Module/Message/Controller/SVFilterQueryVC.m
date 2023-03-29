//
//  SVFilterQueryVC.m
//  SAVI
//
//  Created by F on 2020/9/18.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVFilterQueryVC.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVvipPickerView.h"
#import "SVgenderPickerView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)

#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

#define backColor [UIColor colorWithHexString:@"f7f7f7"]
@interface SVFilterQueryVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
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
@property (weak, nonatomic) IBOutlet UILabel *shopInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
//vippickerView
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
@property (nonatomic,strong) SVgenderPickerView *genderPickerView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSArray *letter;
@property (nonatomic,strong) UIView *maskTheView;


@end

@implementation SVFilterQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
//    if (!kStringIsEmpty(self.storeid)) {
//         self.shopInfoLabel.text = self.storeid;
//    }
   
    self.memberInfoText.text = self.seachMemberStr;
    self.SerialNumberText.text = self.liushui;
    self.commodityInfoText.text = self.product;
    if (!kStringIsEmpty(self.seller)) {
        self.operationLabel.text = self.seller;
    }
    
    self.sureBtn.layer.cornerRadius = 20;
    self.sureBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StoreInquiryViewClick)];
    [self.StoreInquiryView addGestureRecognizer:tag];
    
    UITapGestureRecognizer *OperatorViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OperatorViewClick)];
       [self.OperatorView addGestureRecognizer:OperatorViewtag];
    self.navigationItem.title = @"账单搜索";
    // 加载按钮
    [self setUpAllUI];
    [self setUpConsumersView];
    [self setUpSourcesOfConsumptionView];
    [self allStoreData];
    [self loadoperationData];
}

- (void)loadoperationData{
    [SVUserManager loadUserInfo];
      NSString *token = [SVUserManager shareInstance].access_token;
      NSString *dURL=[URLhead stringByAppendingFormat:@"/System/GetEmployeePageList?key=%@",token];
      NSLog(@"总店dURL = %@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"操作员dic = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            self.letter = dic[@"values"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}
#pragma mark - 确定按钮
- (IBAction)determineClick:(id)sender {
    if (self.InquirySalesBlock) {
        self.InquirySalesBlock(self.shopInfoLabel.text, self.memberInfoText.text, self.PaymentMethodBtn.titleLabel.text, self.ConsumersBtn.titleLabel.text, self.SourcesBtn.titleLabel.text, self.SerialNumberText.text, self.commodityInfoText.text,self.sv_employee_id);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)StoreInquiryViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
}

- (void)OperatorViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.genderPickerView];
}

- (void)allStoreData{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/CargoflowData/GetShopList?key=%@",token];
    NSLog(@"总店dURL = %@",dURL);
    
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"总店dic = %@",dic);
        NSArray *list = dic[@"values"][@"list"];
        [self.listArray addObjectsFromArray:list];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 重置
- (IBAction)ResetClick:(id)sender {
    self.sv_employee_id = @"";
    self.orderSource = @"";
    self.payName = @"";
    self.type = @"";
    self.seller = @"";
    self.memberId = @"";
    self.liushui = @"";
    self.product = @"";
       self.memberInfoText.text = self.memberId;
       self.SerialNumberText.text = self.liushui;
       self.commodityInfoText.text = self.product;
       self.operationLabel.text = @"请选择操作人员";
    

  
    [self setUpAllUI];
    [self setUpConsumersView];
    [self setUpSourcesOfConsumptionView];
  
}

- (void)setUpAllUI{
      [self.paymentMethodView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 支付方式
    CGFloat tagBtnX = 10;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<self.PaymentMethod.count; i++) {
        NSString *paymentStr = self.PaymentMethod[i];
        CGSize tagTextSize = [paymentStr sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(self.paymentMethodView.width-32-32, 40)];
        if (tagBtnX+tagTextSize.width+20 > self.paymentMethodView.width-32) {

            tagBtnX = 10;
            tagBtnY += 40+15;
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        tagBtn.tag = i;
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 40);
        [tagBtn setTitle:paymentStr forState:UIControlStateNormal];
        [tagBtn setTitleColor: [UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [tagBtn setBackgroundColor:backColor];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        tagBtn.layer.cornerRadius = 20.f;
        tagBtn.layer.masksToBounds = YES;
        
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
        
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
        
        self.paymentMethodViewHeight.constant = tagBtnY + 40;
        self.paymentMethodViewBigHeight.constant = tagBtnY + 40 + 38;
        NSLog(@"tagBtnY = %f",tagBtnY);
        NSLog(@"tagBtnX = %f",tagBtnX);
        
    }
}

#pragma mark - 消费对象
- (void)setUpConsumersView{
    [self.ConsumersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 10;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.ConsumersArray.count; i++) {
            NSString *paymentStr = self.ConsumersArray[i];
            CGSize tagTextSize = [paymentStr sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(self.ConsumersView.width-32-32, 40)];
            if (tagBtnX+tagTextSize.width+20 > self.ConsumersView.width-32) {
                
                tagBtnX = 10;
                tagBtnY += 40+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 40);
            [tagBtn setTitle:paymentStr forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
                   [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
                   [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                   
                   tagBtn.layer.cornerRadius = 20.f;
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
            
            self.ConsumersViewHeight.constant = tagBtnY + 40;
            self.ConsumersViewBigHeight.constant = tagBtnY + 40 + 38;
        }
}
#pragma mark - 消费来源
- (void)setUpSourcesOfConsumptionView{
     [self.SourcesOfConsumptionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 10;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.SourcesOfConsumptionArray.count; i++) {
            NSString *paymentStr = self.SourcesOfConsumptionArray[i];
            CGSize tagTextSize = [paymentStr sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(self.SourcesOfConsumptionView.width-32-32, 40)];
            if (tagBtnX+tagTextSize.width+20 > self.SourcesOfConsumptionView.width-32) {
                
                tagBtnX = 10;
                tagBtnY += 40+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 40);
            [tagBtn setTitle:paymentStr forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
                   [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
                   [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                   
                   tagBtn.layer.cornerRadius = 20.f;
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
            
            self.soucesViewHeight.constant = tagBtnY + 40;
            self.soucesBigViewHeight.constant = tagBtnY + 40 + 38;
 
        }
}

- (void)tagBtnClick:(UIButton *)btn{
    self.PaymentMethodBtn.selected = NO;
      // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
       self.PaymentMethodBtn.backgroundColor = backColor;
       btn.selected = YES;
     //  btn.layer.borderColor = [[UIColor clearColor] CGColor];
      // btn.backgroundColor = navigationBackgroundColor;
       [btn setBackgroundColor:navigationBackgroundColor];
       self.PaymentMethodBtn = btn;
}

- (void)tagBtnConsumersClick:(UIButton *)btn{
    self.ConsumersBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
        self.ConsumersBtn.backgroundColor = backColor;
        btn.selected = YES;
        [btn setBackgroundColor:navigationBackgroundColor];
    
        self.ConsumersBtn = btn;
}

- (void)tagBtnSourcesClick:(UIButton *)btn{
    self.SourcesBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
        self.SourcesBtn.backgroundColor = backColor;
        btn.selected = YES;
      //  btn.layer.borderColor = [[UIColor clearColor] CGColor];
       // btn.backgroundColor = navigationBackgroundColor;
        [btn setBackgroundColor:navigationBackgroundColor];
    
        self.SourcesBtn = btn;
}


- (NSMutableArray *)PaymentMethod
{
    if (!_PaymentMethod) {
        _PaymentMethod = [NSMutableArray arrayWithObjects:@"全部",@"微信支付",@"支付宝",@"现金",@"微信记账",@"支付宝记账",@"银行卡",@"储值卡",@"赊账",@"美团",@"口碑",@"闪惠", nil];
       
    }
    
    return _PaymentMethod;
}

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
        _SourcesOfConsumptionArray = [NSMutableArray arrayWithObjects:@"全部",@"店内线下订单",@"店内线上订单",@"美团订单",@"饿了么订单",@"百度外卖订单",@"口碑外卖订单", nil];
    }
    return _SourcesOfConsumptionArray;
}

#pragma mark - 懒加载
//等级pickerView
-(SVvipPickerView *)vipPickerView{
    if (!_vipPickerView) {
        _vipPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _vipPickerView.frame = CGRectMake(0, 0, 320, 230);
        _vipPickerView.center = self.view.center;
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

#pragma mark - 点击店铺确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
       NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    NSDictionary *dic = [self.listArray objectAtIndex:row];
    self.shopInfoLabel.text = dic[@"sv_us_name"];
    self.shopId = dic[@"sv_us_name"];
    [self.vipPickerView removeFromSuperview];
}

/**
 操作人员
 */
-(SVgenderPickerView *)genderPickerView{
    if (!_genderPickerView) {
        _genderPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVgenderPickerView" owner:nil options:nil].lastObject;
        _genderPickerView.frame = CGRectMake(0, 0, 320, 230);
        _genderPickerView.center = self.view.center;
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
       self.operationLabel.text = dic[@"sv_employee_name"];
       self.sv_employee_id = dic[@"sv_employee_id"];
       
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
        NSString *sv_employee_name = dict[@"sv_employee_name"];
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

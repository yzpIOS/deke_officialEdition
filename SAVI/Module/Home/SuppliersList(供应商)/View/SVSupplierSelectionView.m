//
//  SVSupplierSelectionView.m
//  SAVI
//
//  Created by houming Wang on 2021/4/15.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSupplierSelectionView.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVvipPickerView.h"
#import "SVDatePickerView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)

#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

#define backColor [UIColor colorWithHexString:@"f7f7f7"]

#define btnWidth  [UIScreen mainScreen].bounds.size.width - 50
@interface SVSupplierSelectionView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneTime;
@property (weak, nonatomic) IBOutlet UIButton *twoTime;


@property (weak, nonatomic) IBOutlet UIView *supplierView;

@property (weak, nonatomic) IBOutlet UIView *AccountsView;
@property (nonatomic,strong) NSMutableArray * AccountsArray;
@property (nonatomic,strong) UIButton * oneAccountsBtn;
@property (nonatomic,strong) UIButton * AccountsBtn;


@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (nonatomic,strong) NSMutableArray * stateArray;
@property (nonatomic,strong) UIButton * oneStateBtn;
@property (nonatomic,strong) UIButton * stateBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chongzhiBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quedingBottom;
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
@property (nonatomic,strong) SVvipPickerView *TwovipPickerView;
@property (nonatomic,strong) UIView *maskTheView;

@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (nonatomic,assign) NSInteger supplier_id;
@property (nonatomic,strong) SVDatePickerView * myDatePicker;
@property (nonatomic,assign) NSInteger selectNumber;
//NSString *startTime,NSString *endTime,NSString *Credit status,NSString *state,NSString *supplier
/**
 NSString *start_date,NSString *end_date,NSString *state1,NSString *sv_enable,NSString *sv_suid
 */
//@property (nonatomic,strong) NSString *start_date;// 开始时间
//@property (nonatomic,strong) NSString *end_date; // 结束时间
//@property (nonatomic,strong) NSString *state1; // 赊账状态
//@property (nonatomic,strong) NSString *sv_enable; // 状态
//@property (nonatomic,strong) NSString *sv_suid; // 供应商
@property (nonatomic,strong) NSString *start_date;// 开始时间
@property (nonatomic,strong) NSString *end_date; // 结束时间
@property (nonatomic,assign) NSInteger state1; // 赊账状态
@property (nonatomic,assign) NSInteger sv_enable; // 状态
@property (nonatomic,assign) NSInteger sv_suid; // 供应商
@property (nonatomic,assign) NSInteger sv_order_type; // 单据类型

@property (weak, nonatomic) IBOutlet UILabel *DocumentTypeLabel;


@end

@implementation SVSupplierSelectionView

- (NSMutableArray *)AccountsArray{
    if (!_AccountsArray) {
        _AccountsArray = [NSMutableArray arrayWithObjects:@"全部",@"有欠款",@"无欠款", nil];
    }
    return _AccountsArray;
}

- (NSMutableArray *)stateArray{
    if (!_stateArray) {
        _stateArray = [NSMutableArray arrayWithObjects:@"全部",@"已启用",@"已暂停", nil];
    }
    return _stateArray;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.start_date = @"";
    self.end_date = @"";
    self.state1 = -1;
    self.sv_enable = -1;
    self.sv_suid = -1;
    self.sv_order_type = 0;
    self.chongzhiBottom.constant = BottomHeight;
    self.quedingBottom.constant = BottomHeight;
    self.determineBtn.backgroundColor = navigationBackgroundColor;
    UITapGestureRecognizer *supplierViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(supplierViewClick)];
    [self.supplierView addGestureRecognizer:supplierViewtag];
    
    UITapGestureRecognizer *DocumentTypeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DocumentTypeViewClick)];
    [self.DocumentTypeView addGestureRecognizer:DocumentTypeViewtag];
    
    [self setUpbrand];
    [self setUpEnbled];
}
#pragma mark - 开始时间
- (IBAction)startClick:(id)sender {
    self.selectNumber = 0;// 开始时间
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
    
}

#pragma mark - 结束时间
- (IBAction)endTimeClick:(id)sender {
    self.selectNumber = 1;// 结束时间
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
}

/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _myDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _myDatePicker.center = self.center;
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        _myDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
//        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
//        _myDatePicker.datePickerView.maximumDate = maxDate;
//        NSDate *minDate = [NSDate date];
//        _myDatePicker.datePickerView.maximumDate = minDate;
        
        [_myDatePicker.dateCancel addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myDatePicker;
}
#pragma mark - 点击确定时间
- (void)dateDetermineResponseEvent{
    if (self.selectNumber == 0) {
        [self.maskTheView removeFromSuperview];
        [self.myDatePicker removeFromSuperview];
        //创建一个日期格式化器
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        //设置时间样式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [self.oneTime setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
        self.start_date = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];
        // NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
        
//        NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
//        NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
    }else{
        [self.maskTheView removeFromSuperview];
        [self.myDatePicker removeFromSuperview];
        //创建一个日期格式化器
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        //设置时间样式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [self.twoTime setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
        self.end_date = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];
    }
}

#pragma mark - 点击供应商
- (void)supplierViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
}

#pragma mark - 点击单据类型
- (void)DocumentTypeViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.TwovipPickerView];
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
//    if (pickerView == self.vipPickerView.vipPicker) {
//        return self.listArray.count;
//    }else if (pickerView == self.genderPickerView.genderPicker){
//        return self.letter.count;
//
//    }else{
//        return self.MembershipSourcesArray.count;
//    }
   
    if (pickerView == self.vipPickerView.vipPicker) {
        return self.dataArray.count;
    }else{
        return self.DocumentTypeArray.count;
    }
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    if (pickerView == self.vipPickerView.vipPicker) {
//        NSDictionary *dict = self.listArray[row];
//        NSString *sv_us_name = dict[@"sv_us_name"];
//        return sv_us_name;
//    }else if (pickerView == self.genderPickerView.genderPicker){
//        // return self.letter[row];
//         NSDictionary *dict = self.letter[row];
//         NSString *sv_employee_name = dict[@"sp_salesclerk_name"];
//         return sv_employee_name;
//       
//    }else{
//        NSString *sv_us_name = self.MembershipSourcesArray[row];
//       
//        return sv_us_name;
//   }
    if (pickerView == self.vipPickerView.vipPicker) {
        NSDictionary *dic = [self.dataArray objectAtIndex:row];
        NSString *sv_suname = dic[@"sv_suname"];
        return sv_suname;
    }else{
        NSDictionary *dic = [self.DocumentTypeArray objectAtIndex:row];
        NSString *vaule = dic[@"vaule"];
        return vaule;
    }
    
}
#pragma mark - 点击供应商确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
       NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    NSDictionary *dic = [self.dataArray objectAtIndex:row];
    self.supplier.text = dic[@"sv_suname"];
   // self.operationLabel.text = dic[@"sp_salesclerk_name"];
    self.supplier.textColor = [UIColor blackColor];
   // self.supplier_id = [dic[@"id"] integerValue];
    self.sv_suid = [dic[@"id"] integerValue];
    [self.vipPickerView removeFromSuperview];
}

#pragma mark - 点击单据
- (void)twovipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
      // NSInteger row = [self.TwovipPickerView.twoVipPicker selectedRowInComponent:0];
//    self.MembershipSourcesLabel.text = [self.MembershipSourcesArray objectAtIndex:row];
//   // self.storeLabel.text = dic[@"sv_us_name"];
//   // self.operationLabel.text = dic[@"sp_salesclerk_name"];
//    self.MembershipSourcesLabel.textColor = [UIColor blackColor];
//   // self.storeId = dic[@"user_id"];
    [self.TwovipPickerView removeFromSuperview];
    NSInteger row = [self.TwovipPickerView.vipPicker selectedRowInComponent:0];
 NSDictionary *dic = [self.DocumentTypeArray objectAtIndex:row];
 self.DocumentTypeLabel.text = dic[@"vaule"];
// self.operationLabel.text = dic[@"sp_salesclerk_name"];
 self.DocumentTypeLabel.textColor = [UIColor blackColor];
// self.supplier_id = [dic[@"id"] integerValue];
 self.sv_order_type = [dic[@"id"] integerValue];
}
#pragma mark - 点击重置
- (IBAction)ResetClick:(id)sender {
//    self.Stock_date_start = @"";
//    self.Stock_date_end = @"";
//    self.Stock_Min = @"";
//    self.Stock_Max = @"";
//    [SVUserManager loadUserInfo];
//    self.user_id = [SVUserManager shareInstance].user_id;
    self.start_date = @"";
    self.end_date = @"";
    self.state1 = -1;
    self.sv_enable = -1;
    self.sv_suid = -1;
    self.sv_order_type = 0;
    [self.oneTime setTitle:@"开始时间" forState:UIControlStateNormal];
    [self.twoTime setTitle:@"结束时间" forState:UIControlStateNormal];
    [self brandBtnClick:self.oneAccountsBtn];
    [self stateBtnClick:self.oneStateBtn];
    self.supplier.text = @"请选择";
    self.DocumentTypeLabel.text = @"请选择";
   // self.supplier.textColor =
//    [self CreationTimeClick:self.oneCreationTimeBtn];
//    [self particularYearClick:self.oneParticularYearBtn];
//    [self brandBtnClick:self.oneBrandBtn];
//    [self componentBtnClick:self.oneComponentBtn];
}

#pragma mark - 点击确定按钮
- (IBAction)determineClick:(id)sender {
    if (self.supplierDetermineBlock) {
        self.supplierDetermineBlock(self.start_date, self.end_date, self.state1, self.sv_enable, self.sv_suid, self.sv_order_type);
    }
}


#pragma mark - 账款状态
- (void)setUpbrand{
   // [self.brandView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 10;
        CGFloat tagBtnY = 24;
        for (int i= 0; i<self.AccountsArray.count; i++) {
            NSString *AccountsName = self.AccountsArray[i];
            CGSize tagTextSize = [AccountsName sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(btnWidth-20, 32)];
            NSLog(@"消费对象------%.2f",tagTextSize.width);
            if (tagBtnX+tagTextSize.width-10 > btnWidth) {
                
                tagBtnX = 0;
                tagBtnY += 32+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 32);
           // tagBtn.centerY = self.AccountsView.centerY;
            [tagBtn setTitle:AccountsName forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                   [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
                   [tagBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
                   
                   tagBtn.layer.cornerRadius = 5.f;
                   tagBtn.layer.masksToBounds = YES;
                   
                   tagBtn.layer.borderWidth = 1;
                   tagBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
            
            
            [tagBtn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.AccountsView addSubview:tagBtn];
            if (i == 0) {
                [self brandBtnClick:tagBtn];
                self.oneAccountsBtn = tagBtn;
            }

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
//            self.brandHeight.constant = tagBtnY + 32;
//            self.brandBigHeight.constant = tagBtnY + 32 + 38;
        }
}
#pragma mark - 赊账状态的点击
- (void)brandBtnClick:(UIButton *)btn{
    self.AccountsBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.AccountsBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.AccountsBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.AccountsBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
  //  NSDictionary *dict = self.brandArray[btn.tag];
    if (btn.tag == 0) {
        self.state1 = -1;
    }else if (btn.tag == 1){
        self.state1 = 1;
    }else{
        self.state1 = 0;
    }
  //  self.sv_brand_ids = [NSString stringWithFormat:@"%@",dict[@"id"]];
    self.AccountsBtn = btn;
}

#pragma mark - 状态
- (void)setUpEnbled{
   // [self.brandView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 10;
        CGFloat tagBtnY = 24;
        for (int i= 0; i<self.stateArray.count; i++) {
            NSString *stateName = self.stateArray[i];
            CGSize tagTextSize = [stateName sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(btnWidth-20, 32)];
            NSLog(@"消费对象------%.2f",tagTextSize.width);
            if (tagBtnX+tagTextSize.width-10 > btnWidth) {
                
                tagBtnX = 0;
                tagBtnY += 32+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 32);
           // tagBtn.centerY = self.AccountsView.centerY;
            [tagBtn setTitle:stateName forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                   [tagBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
                   [tagBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
                   
                   tagBtn.layer.cornerRadius = 5.f;
                   tagBtn.layer.masksToBounds = YES;
                   
                   tagBtn.layer.borderWidth = 1;
                   tagBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
            
            
            [tagBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.stateView addSubview:tagBtn];
            if (i == 0) {
                [self stateBtnClick:tagBtn];
                self.oneStateBtn = tagBtn;
            }

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
//            self.brandHeight.constant = tagBtnY + 32;
//            self.brandBigHeight.constant = tagBtnY + 32 + 38;
        }
}
#pragma mark - 状态的点击
- (void)stateBtnClick:(UIButton *)btn{
    self.stateBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.stateBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.stateBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.stateBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
  //  NSDictionary *dict = self.brandArray[btn.tag];
    if (btn.tag == 0) {
        self.sv_enable = -1;
    }else if (btn.tag == 1){
        self.sv_enable = 1;
    }else{
        self.sv_enable = 0;
    }
  //  self.sv_brand_ids = [NSString stringWithFormat:@"%@",dict[@"id"]];
    self.stateBtn = btn;
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
#pragma mark - 单据的pickerView
-(SVvipPickerView *)TwovipPickerView{
    if (!_TwovipPickerView) {
        _TwovipPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _TwovipPickerView.frame = CGRectMake(0, 0, 320, 230);
        _TwovipPickerView.centerX = ScreenW / 2;
        _TwovipPickerView.centerY = ScreenH / 2;
        _TwovipPickerView.backgroundColor = [UIColor whiteColor];
        _TwovipPickerView.layer.cornerRadius = 10;
        _TwovipPickerView.twoVipPicker.delegate = self;
        _TwovipPickerView.twoVipPicker.dataSource = self;
        [_TwovipPickerView.twovipCancel addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_TwovipPickerView.twovipDetermine addTarget:self action:@selector(twovipDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TwovipPickerView;
}

- (void)vipCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.vipPickerView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    [self.TwovipPickerView removeFromSuperview];
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

@end

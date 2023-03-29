//
//  SVProductScreeningView.m
//  SAVI
//
//  Created by houming Wang on 2020/12/21.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVProductScreeningView.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVvipPickerView.h"
#import "SVgenderPickerView.h"
//选择时间
#import "SVSelectTwoDatesView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)

#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

#define backColor [UIColor colorWithHexString:@"f7f7f7"]

#define btnWidth  [UIScreen mainScreen].bounds.size.width / 6 *5 - 50

@interface SVProductScreeningView()<UIPickerViewDelegate,UIPickerViewDataSource>
// 店铺筛选
@property (weak, nonatomic) IBOutlet UIView *storeView;
// 会员来源
@property (weak, nonatomic) IBOutlet UIView *MembershipSourcesView;
// 员工来源
@property (weak, nonatomic) IBOutlet UIView *SelectEmployeesView;


// 店内商品
@property (weak, nonatomic) IBOutlet UIView *InStoreMerchandiseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InStoreMerchandiseHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InStoreMerchandiseBigHeight;
@property (nonatomic,strong) NSMutableArray * InStoreMerchandiseArray;// 店内商品
@property (nonatomic,strong) UIButton *InStoreMerchandiseBtn;

// 一级分类
@property (weak, nonatomic) IBOutlet UIView *MembershipGroupingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipGroupingHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipGroupingBigHeight;
@property (nonatomic,strong) NSMutableArray * MembershipGroupingArray;
@property (nonatomic,strong) UIButton *MembershipGroupingBtn;

// 二级分类
@property (weak, nonatomic) IBOutlet UIView *MembershipLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipLabelBigHeight;
@property (nonatomic,strong) NSMutableArray * MembershipLabelArray;
@property (nonatomic,strong) UIButton *MembershipLabelBtn;

// 商品库存
@property (weak, nonatomic) IBOutlet UIView *CustomerChurnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CustomerChurnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CustomerChurnBigHeight;
@property (nonatomic,strong) UIButton *CustomerChurnBtn;
@property (nonatomic,strong) NSArray * CustomerChurnArray;
// 入库时间
@property (weak, nonatomic) IBOutlet UIView *MemberArrearsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MemberArrearsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MemberArrearsBigHeight;
@property (nonatomic,strong) UIButton *MemberArrearsBtn;
@property (nonatomic,strong) NSArray * DefaultingMemberArray;

//// 过期时间
//@property (weak, nonatomic) IBOutlet UIView *ExpirationTimeView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ExpirationTimeViewHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ExpirationTimeViewBigHeight;
//@property (nonatomic,strong) UIButton *ExpirationTimeBtn;
//@property (nonatomic,strong) NSArray * ExpirationTimeArray;

@property (weak, nonatomic) IBOutlet UIView *selectTimeView;

//vippickerView
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
@property (nonatomic,strong) SVgenderPickerView *genderPickerView;
@property (nonatomic,strong) SVvipPickerView *TwovipPickerView;

@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSArray *letter;
@property (nonatomic,strong) UIView *maskTheView;

@property (weak, nonatomic) IBOutlet UILabel *storeLabel;// 店铺筛选

@property (weak, nonatomic) IBOutlet UILabel *MembershipSourcesLabel;// 会员来源

@property (weak, nonatomic) IBOutlet UILabel *EmployeeInquiryLabel; // 员工查询

@property (weak, nonatomic) IBOutlet UILabel *zhuceTime;

@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (nonatomic, strong) NSMutableArray *bigNameArr;
@property (nonatomic, strong) NSMutableArray *bigIDArr;
@end
@implementation SVProductScreeningView

- (void)awakeFromNib
{
    [super awakeFromNib];
    //从偏好设置里拿到大分类数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
    [self allStoreData];
    [self setUpMembershipLevel];
    UITapGestureRecognizer *storeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StoreInquiryViewClick)];
    [self.storeView addGestureRecognizer:storeViewtag];
}

// 店铺来源
- (void)StoreInquiryViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
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
        dict[@"user_id"] = @"";
        dict[@"sv_us_name"] = @"全部店铺";
        [self.listArray addObject:dict];
        [self.listArray addObjectsFromArray:list];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self animated:YES];
        [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
}


#pragma mark - 店内商品
- (void)setUpMembershipLevel{
    [self.InStoreMerchandiseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.InStoreMerchandiseArray.count; i++) {
            NSString *paymentStr = self.InStoreMerchandiseArray[i];
          //  NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"sv_ml_name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(MembershipLevelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.InStoreMerchandiseView addSubview:tagBtn];
            if (i == 0) {
                [self MembershipLevelBtnClick:tagBtn];
            }
            
//            if (!kStringIsEmpty(self.type)) {
//                if ([self.type isEqualToString:paymentStr]) {
//                    [self MembershipGroupingBtnClick:tagBtn];
//                }
//           }
            
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.InStoreMerchandiseHeight.constant = tagBtnY + 32;
            self.InStoreMerchandiseBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 会员等级按钮的点击
- (void)MembershipLevelBtnClick:(UIButton *)btn{
    self.InStoreMerchandiseBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.InStoreMerchandiseBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.InStoreMerchandiseBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.InStoreMerchandiseBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSLog(@"会员等级按钮的点击 btn.tag = %ld",btn.tag);
//    NSDictionary *dict = self.MembershipLevelArray[btn.tag];
//    self.dengji = [dict[@"memberlevel_id"] integerValue];
    self.InStoreMerchandiseBtn = btn;
}


#pragma mark - 一级分类
- (void)setUpMembershipGrouping{
    [self.MembershipGroupingView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.MembershipGroupingArray.count; i++) {
            NSDictionary *dict = self.MembershipGroupingArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"sv_mg_name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(MembershipGroupingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.MembershipGroupingView addSubview:tagBtn];
            if (i == 0) {
                [self MembershipGroupingBtnClick:tagBtn];
            }

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.MembershipGroupingHeight.constant = tagBtnY + 32;
            self.MembershipGroupingBigHeight.constant = tagBtnY + 32 + 38;
        }
}
#pragma mark - 一级分类的点击
- (void)MembershipGroupingBtnClick:(UIButton *)btn{
    self.MembershipGroupingBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.MembershipGroupingBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.MembershipGroupingBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.MembershipGroupingBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSDictionary *dict = self.MembershipGroupingArray[btn.tag];
    self.fenzhu = [dict[@"membergroup_id"] integerValue];
    self.MembershipGroupingBtn = btn;
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
   // if (pickerView == self.vipPickerView.vipPicker) {
        return self.listArray.count;
   // }
    
//    else if (pickerView == self.genderPickerView.genderPicker){
//        return self.letter.count;
//
//    }else{
//        return self.MembershipSourcesArray.count;
//    }
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  //  if (pickerView == self.vipPickerView.vipPicker) {
        NSDictionary *dict = self.listArray[row];
        NSString *sv_us_name = dict[@"sv_us_name"];
        return sv_us_name;
//    }
//    else if (pickerView == self.genderPickerView.genderPicker){
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
//    [self.genderPickerView removeFromSuperview];
//    [self.TwovipPickerView removeFromSuperview];
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

#pragma mark - 点击店铺确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
       NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    NSDictionary *dic = [self.listArray objectAtIndex:row];
    self.storeLabel.text = dic[@"sv_us_name"];
   // self.operationLabel.text = dic[@"sp_salesclerk_name"];
    self.storeLabel.textColor = [UIColor blackColor];
    self.storeId = dic[@"user_id"];
    [self.vipPickerView removeFromSuperview];
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)InStoreMerchandiseArray{
    if (!_InStoreMerchandiseArray) {
        _InStoreMerchandiseArray = [NSMutableArray arrayWithObjects:@"全部",@"已上架",@"已下架", nil];
    }
    return _InStoreMerchandiseArray;
}

-(NSMutableArray *)bigNameArr{
    if (!_bigNameArr) {
        _bigNameArr = [NSMutableArray array];
    }
    return _bigNameArr;
}

-(NSMutableArray *)bigIDArr{
    if (!_bigIDArr) {
        _bigIDArr = [NSMutableArray array];
    }
    return _bigIDArr;
}
@end

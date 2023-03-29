//
//  SVNewCommodityScreeningView.m
//  SAVI
//
//  Created by houming Wang on 2021/1/28.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewCommodityScreeningView.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVvipPickerView.h"
#import "SVInventoryRangeView.h"
#import "SVSelectTwoDatesView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)

#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

#define backColor [UIColor colorWithHexString:@"f7f7f7"]

#define btnWidth  [UIScreen mainScreen].bounds.size.width - 50
@interface SVNewCommodityScreeningView()<UIPickerViewDelegate,UIPickerViewDataSource>
// 店铺筛选
@property (weak, nonatomic) IBOutlet UIView *storeView;

// 店内商品
@property (weak, nonatomic) IBOutlet UIView *InStoreMerchandiseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InStoreMerchandiseHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InStoreMerchandiseBigHeight;
@property (nonatomic,strong) NSMutableArray * InStoreMerchandiseArray;
@property (nonatomic,strong) UIButton *InStoreMerchandiseBtn;
@property (nonatomic,strong) UIButton *twoInStoreMerchandiseBtn;

// 商品库存
@property (weak, nonatomic) IBOutlet UIView *MerchandiseInventoryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MerchandiseInventoryHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MerchandiseInventoryBigHeight;
@property (nonatomic,strong) NSMutableArray * MerchandiseInventoryArray;
@property (nonatomic,strong) UIButton *MerchandiseInventoryBtn;
@property (nonatomic,strong) UIButton *oneMerchandiseInventoryBtn;

// 创建时间
@property (weak, nonatomic) IBOutlet UIView *CreationTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CreationTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CreationTimeBigHeight;
@property (nonatomic,strong) NSMutableArray * CreationTimeArray;
@property (nonatomic,strong) UIButton *CreationTimeBtn;
@property (nonatomic,strong) UIButton *oneCreationTimeBtn;

// 年份
@property (weak, nonatomic) IBOutlet UIView *particularYearView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *particularYearHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *particularYearBigHeight;
@property (nonatomic,strong) UIButton *particularYearBtn;
@property (nonatomic,strong) UIButton *oneParticularYearBtn;
@property (nonatomic,strong) NSArray * particularYearArray;
// 品牌
@property (weak, nonatomic) IBOutlet UIView *brandView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandBigHeight;
@property (nonatomic,strong) UIButton *brandBtn;
@property (nonatomic,strong) UIButton *oneBrandBtn;
@property (nonatomic,strong) NSMutableArray * brandArray;

// 成分
@property (weak, nonatomic) IBOutlet UIView *componentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *componentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *componentBigHeight;
@property (nonatomic,strong) UIButton *componentBtn;
@property (nonatomic,strong) UIButton *oneComponentBtn;
@property (nonatomic,strong) NSMutableArray * componentArray;

@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (nonatomic,strong) NSMutableArray * listArray;
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
@property (nonatomic,strong) UIView *maskTheView;

@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
/**
 * 是否点击
 */
@property (nonatomic ,assign) BOOL selected;
@property (nonatomic ,assign) BOOL twoSelected;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (nonatomic,strong) SVInventoryRangeView * inventoryRangeView;
@property (nonatomic,strong) SVSelectTwoDatesView * DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@property (weak, nonatomic) IBOutlet UILabel *choiceTimeLabel;

/***
 NSString *user_id,NSString *Product_state,NSString *Stock_type,NSString *Stock_Min,NSString *Stock_Max,NSString *Stock_date_type,NSString *Stock_date_start,NSString *Stock_date_end,NSString *year,NSString *sv_brand_ids,NSString *fabric_ids
 */
// 门店id -1全部门店
@property (nonatomic,strong) NSString *user_id;
// 商品状态 0上架,-1：下架 1全部
@property (nonatomic,strong) NSString *Product_state;
// 库存类型 1正库存。-1负库存，0零库存，-2全部，-3根据范围查询
@property (nonatomic,strong) NSString *Stock_type;
// 库存最小 Stock_type=-3必须传值
@property (nonatomic,strong) NSString *Stock_Min;
// 库存最大 Stock_type=-3必须传值
@property (nonatomic,strong) NSString *Stock_Max;
// 库存入库时间 1一周，2半个月，3一个月,4根据时间范围查询0全部
@property (nonatomic,strong) NSString *Stock_date_type;
// 库存入库时间开始 Stock_date_type=4必传值
@property (nonatomic,strong) NSString *Stock_date_start;
// 库存入库时间结束 Stock_date_type=4必传值
@property (nonatomic,strong) NSString *Stock_date_end;
// 年份
@property (nonatomic,strong) NSString *year;
// 品牌
@property (nonatomic,strong) NSString * sv_brand_ids;
// 成分
@property (nonatomic,strong) NSString * fabric_ids;

@end
@implementation SVNewCommodityScreeningView


- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self loadData];
//    [self allStoreData];
//    [self loadoperationData];
    
  
   // [self.oneBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
    
    [self.oneBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self.oneBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
    
self.oneBtn.layer.cornerRadius = 16.f;
self.oneBtn.layer.masksToBounds = YES;
    
self.oneBtn.layer.borderWidth = 1;
self.oneBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;


[self.oneBtn addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];

//            [self.twoBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//            [self.oneBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.twoBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self.twoBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
    
self.twoBtn.layer.cornerRadius = 16.f;
self.twoBtn.layer.masksToBounds = YES;
    
self.twoBtn.layer.borderWidth = 1;
self.twoBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;


[self.twoBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
  [self.timeView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
   self.timeView.layer.cornerRadius = 16.f;
   self.timeView.layer.masksToBounds = YES;
    
   self.timeView.layer.borderWidth = 1;
   self.timeView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    
    self.cancleBtn.layer.cornerRadius = 19;
    self.cancleBtn.layer.masksToBounds = YES;
    self.cancleBtn.layer.borderWidth = 1;
    self.cancleBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    
    self.determineBtn.layer.cornerRadius = 20;
    self.determineBtn.layer.masksToBounds = YES;
    
    self.storeView.layer.cornerRadius = 22;
    self.storeView.layer.masksToBounds = YES;
    
//    self.MembershipSourcesView.layer.cornerRadius = 22;
//    self.MembershipSourcesView.layer.masksToBounds = YES;
//    
//    self.SelectEmployeesView.layer.cornerRadius = 22;
//    self.SelectEmployeesView.layer.masksToBounds = YES;
//
//    self.selectTimeView.layer.cornerRadius = 22;
//    self.selectTimeView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *storeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StoreInquiryViewClick)];
    [self.storeView addGestureRecognizer:storeViewtag];
    
    [self setUpInStoreMerchandise];
    [self setUpMerchandiseInventory];
    [self setUpCreationTime];
    [self setUpparticularYear];
    [self loadProductApiConfigGetSv_Brand_Lib];
    [self loadProductApiConfigGetFabricList];
    [self allStoreData];
    
    UITapGestureRecognizer *timeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewClick)];
    [self.timeView addGestureRecognizer:timeViewtag];
  
//    UITapGestureRecognizer *MembershipSourcesViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MembershipSourcesViewClick)];
//    [self.MembershipSourcesView addGestureRecognizer:MembershipSourcesViewtag];
//
//    UITapGestureRecognizer *SelectEmployeesViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectEmployeesViewClick)];
//    [self.SelectEmployeesView addGestureRecognizer:SelectEmployeesViewtag];
//
//    UITapGestureRecognizer *selectTimeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeViewClick)];
//    [self.selectTimeView addGestureRecognizer:selectTimeViewtag];
  
//    self.storeId = @"";
//    self.reg_source = -1;
//    self.sv_employee_id = @"";
//    self.dengji = 0;
//    self.fenzhu = 0;
//    self.liusi = 0;
//   // self.sectkey = @"";
//    self.biaoqian = @"";
//    self.hascredit = -1;
//    self.start_deadline = @"";
//    self.end_deadline = @"";
//    self.reg_start_date = @"";
//    self.reg_end_date = @"";
    
}

#pragma mark - 最小库存
- (void)oneBtnClick:(UIButton *)btn{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.inventoryRangeView];
    __weak typeof(self) weakSelf = self;
//    self.inventoryRangeView.stockBlock = ^(double oneNumber, double twoNumber) {
//
//    };
    self.inventoryRangeView.stockBlock = ^(NSInteger oneNumber, NSInteger twoNumber) {
        [weakSelf.oneBtn setTitle:[NSString stringWithFormat:@"%ld",oneNumber] forState:UIControlStateNormal];
        weakSelf.Stock_Min = [NSString stringWithFormat:@"%ld",oneNumber];
        [weakSelf.twoBtn setTitle:[NSString stringWithFormat:@"%ld",twoNumber] forState:UIControlStateNormal];
        weakSelf.Stock_Max = [NSString stringWithFormat:@"%ld",twoNumber];
        [weakSelf dateCancelResponseEvent];
    };
}

#pragma mark - 最大库存
- (void)twoBtnClick:(UIButton *)btn{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.inventoryRangeView];
    __weak typeof(self) weakSelf = self;
//    self.inventoryRangeView.stockBlock = ^(double oneNumber, double twoNumber) {
//
//    };
    
    self.inventoryRangeView.stockBlock = ^(NSInteger oneNumber, NSInteger twoNumber) {
        [weakSelf.oneBtn setTitle:[NSString stringWithFormat:@"%.ld",oneNumber] forState:UIControlStateNormal];
        weakSelf.Stock_Min = [NSString stringWithFormat:@"%ld",oneNumber];
        [weakSelf.twoBtn setTitle:[NSString stringWithFormat:@"%ld",twoNumber] forState:UIControlStateNormal];
        weakSelf.Stock_Max = [NSString stringWithFormat:@"%ld",twoNumber];
        [weakSelf dateCancelResponseEvent];
    };
}

#pragma mark - 选择时间
- (void)timeViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
    
}

#pragma mark - 选择店铺
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
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"user_id"] = @"";
//        dict[@"sv_us_name"] = @"全部店铺";
//        [self.listArray addObject:dict];
        [self.listArray addObjectsFromArray:list];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self animated:YES];
        [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
}



#pragma mark - 加载品牌数据
- (void)loadProductApiConfigGetSv_Brand_Lib{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetSv_Brand_Lib?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"sv_brand_name"] = @"全部";
            dictM[@"id"] = @"";
            [self.brandArray addObject:dictM];
            [self.brandArray addObjectsFromArray:data[@"list"]];
            [self setUpbrand];

        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

#pragma mark - 加载成分数据
- (void)loadProductApiConfigGetFabricList{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetFabricList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"sv_foundation_name"] = @"全部";
            dictM[@"sv_foundation_id"] = @"";
            [self.componentArray addObject:dictM];
            [self.componentArray addObjectsFromArray:data[@"list"]];
            [self setUpcomponent];

        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

#pragma mark - 店内商品
- (void)setUpInStoreMerchandise{
  //  [self.InStoreMerchandiseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.InStoreMerchandiseArray.count; i++) {
            NSDictionary *dict = self.InStoreMerchandiseArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(InStoreMerchandiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.InStoreMerchandiseView addSubview:tagBtn];
            if (i == 1) {
                [self InStoreMerchandiseBtnClick:tagBtn];
                self.twoInStoreMerchandiseBtn = tagBtn;
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

#pragma mark - 店内商品的点击
- (void)InStoreMerchandiseBtnClick:(UIButton *)btn{
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
   // NSLog(@"会员等级按钮的点击 btn.tag = %ld",btn.tag);
    NSDictionary *dict = self.InStoreMerchandiseArray[btn.tag];
    self.Product_state = dict[@"idStr"];
    self.InStoreMerchandiseBtn = btn;
}

#pragma mark - 商品库存
- (void)setUpMerchandiseInventory{
  //  [self.MerchandiseInventoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.MerchandiseInventoryArray.count; i++) {
            NSDictionary *dict = self.MerchandiseInventoryArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(MerchandiseInventoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.MerchandiseInventoryView addSubview:tagBtn];
            if (i == 0) {
                [self MerchandiseInventoryBtnClick:tagBtn];
                self.oneMerchandiseInventoryBtn = tagBtn;
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.MerchandiseInventoryHeight.constant = tagBtnY + 32;
            self.MerchandiseInventoryBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 点击重置
- (IBAction)ResetClick:(id)sender {
    self.Stock_date_start = @"";
    self.Stock_date_end = @"";
    self.Stock_Min = @"";
    self.Stock_Max = @"";
    [SVUserManager loadUserInfo];
    self.user_id = [SVUserManager shareInstance].user_id;
    [self InStoreMerchandiseBtnClick:self.twoInStoreMerchandiseBtn];
    [self MerchandiseInventoryBtnClick:self.oneMerchandiseInventoryBtn];
    [self CreationTimeClick:self.oneCreationTimeBtn];
    [self particularYearClick:self.oneParticularYearBtn];
    [self brandBtnClick:self.oneBrandBtn];
    [self componentBtnClick:self.oneComponentBtn];
}



#pragma mark - 商品库存的点击
- (void)MerchandiseInventoryBtnClick:(UIButton *)btn{
    self.MerchandiseInventoryBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.MerchandiseInventoryBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.MerchandiseInventoryBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.MerchandiseInventoryBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSDictionary *dict = self.MerchandiseInventoryArray[btn.tag];
    self.Stock_type = dict[@"idStr"];
    self.MerchandiseInventoryBtn = btn;
    if (btn.tag == 4) {

        _selected = !_selected;

        if(_selected) {
            NSLog(@"选中");
            self.oneBtn.hidden = NO;
            self.twoBtn.hidden = NO;
            self.lineView.hidden = NO;
            self.MerchandiseInventoryHeight.constant += 47;
            self.MerchandiseInventoryBigHeight.constant += 47;
          
        }else {
            NSLog(@"取消选中");
            self.oneBtn.hidden = YES;
            self.twoBtn.hidden = YES;
            self.lineView.hidden = YES;
            self.MerchandiseInventoryHeight.constant -= 47;
            self.MerchandiseInventoryBigHeight.constant -= 47;
           
        }
    }else{
        if (_selected == YES) {
            self.oneBtn.hidden = YES;
            self.twoBtn.hidden = YES;
            self.lineView.hidden = YES;
            self.MerchandiseInventoryHeight.constant -= 47;
            self.MerchandiseInventoryBigHeight.constant -= 47;
            _selected = NO;
        }
    }
}


#pragma mark - 创建时间
- (void)setUpCreationTime{
   // [self.CreationTimeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.CreationTimeArray.count; i++) {
            NSDictionary *dict = self.CreationTimeArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(CreationTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.CreationTimeView addSubview:tagBtn];
            if (i == 0) {
                [self CreationTimeClick:tagBtn];
                self.oneCreationTimeBtn = tagBtn;
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.CreationTimeHeight.constant = tagBtnY + 32;
            self.CreationTimeBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 创建时间的点击
- (void)CreationTimeClick:(UIButton *)btn{
    self.CreationTimeBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.CreationTimeBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.CreationTimeBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.CreationTimeBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSDictionary *dict = self.CreationTimeArray[btn.tag];
    self.Stock_date_type = dict[@"idStr"];
        self.CreationTimeBtn = btn;
    
    if (btn.tag == 4) {

        _twoSelected = !_twoSelected;

        if(_twoSelected) {
            NSLog(@"选中");
            self.timeView.hidden = NO;
            self.CreationTimeHeight.constant += 47;
            self.CreationTimeBigHeight.constant += 47;
           // _twoSelected = NO;
        }else {
            NSLog(@"取消选中");
            self.timeView.hidden = YES;
            self.CreationTimeHeight.constant -= 47;
            self.CreationTimeBigHeight.constant -= 47;
        }
    }else{
        if (_twoSelected == YES) {
            self.timeView.hidden = YES;
            self.CreationTimeHeight.constant -= 47;
            self.CreationTimeBigHeight.constant -= 47;
            _twoSelected = NO;
        }
    }
}

#pragma mark - 年份
- (void)setUpparticularYear{
  //  [self.particularYearView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.particularYearArray.count; i++) {
           // NSDictionary *dict = self.MembershipLabelArray[i];
            NSString *paymentStr = self.particularYearArray[i];
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
            
            [tagBtn addTarget:self action:@selector(particularYearClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.particularYearView addSubview:tagBtn];
            if (i == 0) {
                [self particularYearClick:tagBtn];
                self.oneParticularYearBtn = tagBtn;
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.particularYearHeight.constant = tagBtnY + 32;
            self.particularYearBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 年份点击
- (void)particularYearClick:(UIButton *)btn{
    self.particularYearBtn.selected = NO;
    [self.particularYearBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.particularYearBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.particularYearBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
   
  
    if (btn.tag == 0) {
        self.year = @"";
    }else{
        self.year = self.particularYearArray[btn.tag];
    }

  //  NSLog(@"self.liusi = %ld",self.liusi);
    
    self.particularYearBtn = btn;
}


#pragma mark - 品牌
- (void)setUpbrand{
   // [self.brandView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.brandArray.count; i++) {
            NSDictionary *dict = self.brandArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"sv_brand_name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.brandView addSubview:tagBtn];
            if (i == 0) {
                [self brandBtnClick:tagBtn];
                self.oneBrandBtn = tagBtn;
            }

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.brandHeight.constant = tagBtnY + 32;
            self.brandBigHeight.constant = tagBtnY + 32 + 38;
        }
}
#pragma mark - 品牌的点击
- (void)brandBtnClick:(UIButton *)btn{
    self.brandBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.brandBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.brandBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.brandBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSDictionary *dict = self.brandArray[btn.tag];
   // self.fenzhu = [dict[@"membergroup_id"] integerValue];
    self.sv_brand_ids = [NSString stringWithFormat:@"%@",dict[@"id"]];
    self.brandBtn = btn;
}


#pragma mark - 成分
- (void)setUpcomponent{
  //  [self.componentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.componentArray.count; i++) {
            NSDictionary *dict = self.componentArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(componentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.componentView addSubview:tagBtn];
            if (i == 0) {
                [self componentBtnClick:tagBtn];
                self.oneComponentBtn = tagBtn;
            }

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.componentHeight.constant = tagBtnY + 32;
            self.componentBigHeight.constant = tagBtnY + 32 + 38;
        }
}
#pragma mark - 成分的点击
- (void)componentBtnClick:(UIButton *)btn{
    self.componentBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.componentBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.componentBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.componentBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSDictionary *dict = self.componentArray[btn.tag];
   // self.fenzhu = [dict[@"membergroup_id"] integerValue];
    self.fabric_ids = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
    self.componentBtn = btn;
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
//    }else if (pickerView == self.genderPickerView.genderPicker){
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
   // if (pickerView == self.vipPickerView.vipPicker) {
        NSDictionary *dict = self.listArray[row];
        NSString *sv_us_name = dict[@"sv_us_name"];
        return sv_us_name;
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
}

#pragma mark - 懒加载
//等级pickerView
-(SVvipPickerView *)vipPickerView{
    if (!_vipPickerView) {
        _vipPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _vipPickerView.frame = CGRectMake(0, 0, 320, 320);
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

#pragma mark - 设置库存区间的View
- (SVInventoryRangeView *)inventoryRangeView{
    if (!_inventoryRangeView) {
        _inventoryRangeView = [[NSBundle mainBundle]loadNibNamed:@"SVInventoryRangeView" owner:nil options:nil].lastObject;
        _inventoryRangeView.frame = CGRectMake(30, 0, ScreenW -60,490);
       // .center = self.view.center;
        _inventoryRangeView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _inventoryRangeView.layer.cornerRadius = 10;
        _inventoryRangeView.layer.masksToBounds = YES;
        [_inventoryRangeView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _inventoryRangeView;
}

- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.inventoryRangeView removeFromSuperview];
}


//-(SVInventoryRangeView *)inventoryRangeView{
//    if (!_inventoryRangeView) {
//        _inventoryRangeView = [[NSBundle mainBundle] loadNibNamed:@"SVInventoryRangeView" owner:nil options:nil].lastObject;
//        _vipPickerView.frame = CGRectMake(0, 0, 320, 320);
//        _inventoryRangeView.centerX = ScreenW / 2;
//        _inventoryRangeView.centerY = ScreenH / 2;
////        _vipPickerView.backgroundColor = [UIColor whiteColor];
////        _vipPickerView.layer.cornerRadius = 10;
////        _vipPickerView.vipPicker.delegate = self;
////        _vipPickerView.vipPicker.dataSource = self;
////        [_vipPickerView.vipCancel addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
////        [_vipPickerView.vipDetermine addTarget:self action:@selector(vipDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _inventoryRangeView;
//}
#pragma mark - 筛选时间的View
-(SVSelectTwoDatesView *)DateView {
    
    if (!_DateView) {
        _DateView = [[[NSBundle mainBundle] loadNibNamed:@"SVSelectTwoDatesView" owner:nil options:nil] lastObject];
        _DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
        
        [_DateView.cancelButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_DateView.determineButton addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        NSDate *minDate = [NSDate date];
        //设置显示模式
        [_DateView.oneDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        _DateView.oneDatePicker.maximumDate = maxDate;
        _DateView.oneDatePicker.maximumDate = minDate;
        
        //设置显示模式
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        _DateView.twoDatePicker.maximumDate = maxDate;
        _DateView.twoDatePicker.maximumDate = minDate;
        
    }
    
    return _DateView;
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskTheView removeFromSuperview];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
    
}

- (void)twoCancelResponseEvent {
    
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   // dateFormatter.dateStyle = UIDatePickerModeDateAndTime;
    NSString *oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    NSString *twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
    self.Stock_date_start = @"";
    self.Stock_date_end = @"";
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self withSing:@"输入时间有误"];
        
    } else {
        //提示查询
        //        [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
      //  [SVTool IndeterminateButtonAction:self withSing:@"查询中…"];
//        self.oneDate = oneDate;
//        self.twoDate = twoDate;
        self.Stock_date_start = oneDate;
        self.Stock_date_end = twoDate;
        self.choiceTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",oneDate,twoDate];
    }
    
    
}


#pragma mark - 点击店铺确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
       NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    NSDictionary *dic = [self.listArray objectAtIndex:row];
    self.storeLabel.text = dic[@"sv_us_name"];
   // self.operationLabel.text = dic[@"sp_salesclerk_name"];
    self.storeLabel.textColor = [UIColor blackColor];
    self.user_id = dic[@"user_id"];
    
    [self.vipPickerView removeFromSuperview];
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
        [self.inventoryRangeView removeFromSuperview];
      //  [self.genderPickerView removeFromSuperview];
      //  [self.TwovipPickerView removeFromSuperview];
    }





#pragma mark - 取消按钮
- (IBAction)cancleClick:(id)sender {
    if (self.canBlock) {
        self.canBlock();
    }
}

#pragma mark - 确定按钮的点击
- (IBAction)determineClick:(id)sender {
    
    if (self.CommodityScreeningBlock) {
        self.CommodityScreeningBlock(self.user_id, self.Product_state, self.Stock_type, self.Stock_Min, self.Stock_Max, self.Stock_date_type, self.Stock_date_start, self.Stock_date_end, self.year, self.sv_brand_ids, self.fabric_ids);
    };
    
}

- (NSMutableArray *)InStoreMerchandiseArray{
    if (!_InStoreMerchandiseArray) {
        NSArray *nameArray = [NSArray arrayWithObjects:@"全部",@"已上架",@"已下架", nil];
        NSArray *idArray = [NSArray arrayWithObjects:@"1",@"0",@"-1", nil];
        _InStoreMerchandiseArray = [NSMutableArray array];
        for (int i = 0; i < nameArray.count; i++) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = nameArray[i];
            dictM[@"idStr"] = idArray[i];
            [_InStoreMerchandiseArray addObject:dictM];
        }
       
    }
    return _InStoreMerchandiseArray;
}

- (NSMutableArray *)MerchandiseInventoryArray{
    if (!_MerchandiseInventoryArray) {
        NSArray *nameArray = [NSArray arrayWithObjects:@"全部",@"正库存",@"负库存",@"零库存",@"自定义", nil];
        
        NSArray *idArray = [NSArray arrayWithObjects:@"-2",@"1",@"-1",@"0", @"-3",nil];
        _MerchandiseInventoryArray = [NSMutableArray array];
        for (int i = 0; i < nameArray.count; i++) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = nameArray[i];
            dictM[@"idStr"] = idArray[i];
            [_MerchandiseInventoryArray addObject:dictM];
        }
       // _MerchandiseInventoryArray = [NSMutableArray arrayWithObjects:@"全部",@"正库存",@"负库存",@"零库存",@"自定义", nil];
    }
    return _MerchandiseInventoryArray;
}

- (NSMutableArray *)CreationTimeArray{
    if (!_CreationTimeArray) {
        NSArray *nameArray = [NSArray arrayWithObjects:@"全部",@"一星期",@"半个月",@"一个月",@"自定义", nil];
        
        NSArray *idArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3", @"4",nil];
        _CreationTimeArray = [NSMutableArray array];
        for (int i = 0; i < nameArray.count; i++) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = nameArray[i];
            dictM[@"idStr"] = idArray[i];
            [_CreationTimeArray addObject:dictM];
        }
      //  _CreationTimeArray = [NSMutableArray arrayWithObjects:@"全部",@"一星期",@"半个月",@"一个月",@"自定义", nil];
    }
    return _CreationTimeArray;
}

- (NSArray *)particularYearArray{
    if (!_particularYearArray) {

        _particularYearArray = [NSArray arrayWithObjects:@"全部",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017", nil];
    
    }
    return _particularYearArray;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)brandArray{
    if (!_brandArray) {
        _brandArray = [NSMutableArray array];
    }
    return _brandArray;
}

- (NSMutableArray *)componentArray{
    if (!_componentArray) {
        _componentArray = [NSMutableArray array];
    }
    return _componentArray;
}

@end

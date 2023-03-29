//
//  SVmembershipScreeningView.m
//  SAVI
//
//  Created by houming Wang on 2020/12/1.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVmembershipScreeningView.h"
#import "SVMembershipScreeningModel.h"
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
@interface SVmembershipScreeningView()<UIPickerViewDelegate,UIPickerViewDataSource>
// 店铺筛选
@property (weak, nonatomic) IBOutlet UIView *storeView;
// 会员来源
@property (weak, nonatomic) IBOutlet UIView *MembershipSourcesView;
// 员工来源
@property (weak, nonatomic) IBOutlet UIView *SelectEmployeesView;


// 会员等级
@property (weak, nonatomic) IBOutlet UIView *MembershipLevelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipLevelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipLevelBigHeight;
@property (nonatomic,strong) NSMutableArray * MembershipLevelArray;// 等级
@property (nonatomic,strong) UIButton *MembershipLevelBtn;

// 会员分组
@property (weak, nonatomic) IBOutlet UIView *MembershipGroupingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipGroupingHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipGroupingBigHeight;
@property (nonatomic,strong) NSMutableArray * MembershipGroupingArray;
@property (nonatomic,strong) UIButton *MembershipGroupingBtn;

// 会员标签
@property (weak, nonatomic) IBOutlet UIView *MembershipLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MembershipLabelBigHeight;
@property (nonatomic,strong) NSMutableArray * MembershipLabelArray;
@property (nonatomic,strong) UIButton *MembershipLabelBtn;

// 客户流失
@property (weak, nonatomic) IBOutlet UIView *CustomerChurnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CustomerChurnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CustomerChurnBigHeight;
@property (nonatomic,strong) UIButton *CustomerChurnBtn;
@property (nonatomic,strong) NSArray * CustomerChurnArray;
// 欠款会员
@property (weak, nonatomic) IBOutlet UIView *MemberArrearsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MemberArrearsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MemberArrearsBigHeight;
@property (nonatomic,strong) UIButton *MemberArrearsBtn;
@property (nonatomic,strong) NSArray * DefaultingMemberArray;

// 过期时间
@property (weak, nonatomic) IBOutlet UIView *ExpirationTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ExpirationTimeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ExpirationTimeViewBigHeight;
@property (nonatomic,strong) UIButton *ExpirationTimeBtn;
@property (nonatomic,strong) NSArray * ExpirationTimeArray;

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


@property (nonatomic,strong) NSArray * MembershipSourcesArray;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
//遮盖view
@property (nonatomic,strong) UIView *maskView;

//// 请求所需要的参数
//@property (nonatomic,assign) NSInteger dengji;
//@property (nonatomic,assign) NSInteger fenzhu;
//@property (nonatomic,assign) NSInteger biaoqian;
//@property (nonatomic,assign) NSInteger liusi;
//@property (nonatomic,assign) BOOL hascredit;
//@property (nonatomic,strong) NSString * start_deadline;
//@property (nonatomic,strong) NSString * end_deadline;
//
//@property (nonatomic,strong) NSString * reg_start_date;
//@property (nonatomic,strong) NSString * reg_end_date;
//
//@property (nonatomic,assign) NSInteger reg_source;
@property (weak, nonatomic) IBOutlet UILabel *zhuceTime;

@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewTop;

@property (weak, nonatomic) IBOutlet UIImageView *sanjianxing;


@end

@implementation SVmembershipScreeningView



- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadData];
    [self allStoreData];
    [self loadoperationData];
    if (ScreenH == 812) {
       // images = @[@"GuidePages_1_1", @"GuidePages_2_2", @"GuidePages_3_3", @"GuidePages_4_4",@"GuidePages_5_5"];
        self.oneViewTop.constant = 45;

    } else {
      //  images = @[@"GuidePages_1", @"GuidePages_2", @"GuidePages_3", @"GuidePages_4",@"GuidePages_5"];
        self.oneViewTop.constant = 30;
    }
    self.cancleBtn.layer.cornerRadius = 19;
    self.cancleBtn.layer.masksToBounds = YES;
    self.cancleBtn.layer.borderWidth = 1;
    self.cancleBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    
    self.determineBtn.layer.cornerRadius = 20;
    self.determineBtn.layer.masksToBounds = YES;
    
    self.storeView.layer.cornerRadius = 22;
    self.storeView.layer.masksToBounds = YES;
    
    self.MembershipSourcesView.layer.cornerRadius = 22;
    self.MembershipSourcesView.layer.masksToBounds = YES;
    
    self.SelectEmployeesView.layer.cornerRadius = 22;
    self.SelectEmployeesView.layer.masksToBounds = YES;

    self.selectTimeView.layer.cornerRadius = 22;
    self.selectTimeView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *storeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StoreInquiryViewClick)];
    [self.storeView addGestureRecognizer:storeViewtag];
    
    UITapGestureRecognizer *MembershipSourcesViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MembershipSourcesViewClick)];
    [self.MembershipSourcesView addGestureRecognizer:MembershipSourcesViewtag];
    
    UITapGestureRecognizer *SelectEmployeesViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectEmployeesViewClick)];
    [self.SelectEmployeesView addGestureRecognizer:SelectEmployeesViewtag];
    
    UITapGestureRecognizer *selectTimeViewtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeViewClick)];
    [self.selectTimeView addGestureRecognizer:selectTimeViewtag];
  
   // self.storeId = @"";
    self.storeId =[SVUserManager shareInstance].user_id;
    self.storeLabel.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
    self.reg_source = -1;
    self.sv_employee_id = @"";
    self.dengji = 0;
    self.fenzhu = 0;
    self.liusi = 0;
   // self.sectkey = @"";
    self.biaoqian = @"";
    self.hascredit = -1;
    self.start_deadline = @"";
    self.end_deadline = @"";
    self.reg_start_date = @"";
    self.reg_end_date = @"";
    
//    [SVUserManager loadUserInfo];
//     NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
//    if (kDictIsEmpty(sv_versionpowersDict)) {
//
//    }else{
//        NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
//                     NSString *Inventory = [NSString stringWithFormat:@"%@",StockManageDic[@"Inventory"]];
//                   if ([Inventory isEqualToString:@"1"]) {
//                           [_titleArr addObject:@"库存盘点"];
//                           [_titleImg addObject:@"pandian"];
//                      };
//    }
    
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
                    self.storeLabel.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
                    self.storeLabel.textColor = [UIColor colorWithHexString:@"999999"];
                    self.sanjianxing.image = [UIImage imageNamed:@"sanjiaoxing_huise"];
                    self.storeView.userInteractionEnabled = NO;
                    
                }
            }
        }
    }
    
}
#pragma mark - 取消按钮
- (IBAction)cancleClick:(id)sender {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

#pragma mark - 确定按钮的点击
- (IBAction)determineClick:(id)sender {
    if (self.membershipScreeningBlock) {
        self.membershipScreeningBlock(self.storeId, self.reg_source, self.sv_employee_id, self.dengji, self.fenzhu, self.biaoqian, self.liusi, self.hascredit, self.start_deadline, self.end_deadline, self.reg_start_date, self.reg_end_date);
    }
    
}

#pragma mark - 重置按钮的点击
- (IBAction)ResetClick:(id)sender {
  //  self.storeId = @"";
    self.storeId =[SVUserManager shareInstance].user_id;
    self.reg_source = -1;
    self.sv_employee_id = @"";
    self.dengji = 0;
    self.fenzhu = 0;
    self.biaoqian = @"";
    self.liusi = 0;
    self.hascredit = -1;
    self.start_deadline = @"";
    self.end_deadline = @"";
    self.reg_start_date = @"";
    self.reg_end_date = @"";
    
    self.storeLabel.text = [NSString  stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
    self.MembershipSourcesLabel.text = @"请选择来源";
    self.EmployeeInquiryLabel.text = @"请选择操作人员";
    self.zhuceTime.text = @"请选择时间";
    
  //  self.storeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.storeLabel.textColor = [UIColor blackColor];
    self.MembershipSourcesLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.EmployeeInquiryLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.zhuceTime.textColor = [UIColor colorWithHexString:@"999999"];
    
    // 会员等级
    [self setUpMembershipLevel];
    // 会员分组
    [self setUpMembershipGrouping];
    // 会员标签
    [self setUpMembershipLabel];
    
    // 会员流失
    [self setUpCustomerChurn];
    
    // 欠款会员
    [self setUpMemberArrears];
    
    // 过期时间
    [self setUpExpirationTime];
}


// 店铺来源
- (void)StoreInquiryViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
}
// 会员来源
- (void)MembershipSourcesViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.TwovipPickerView];
}
// 员工查询
- (void)SelectEmployeesViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.genderPickerView];
}

// 注册时间
- (void)selectTimeViewClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
}

- (void)loadData{

    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemeberFilters?key=%@",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool]GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        //        NSLog(@"urlStr = %@",urlStr);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic = %@",dic);
        // 会员分组
        NSMutableDictionary *dictMGrouping = [NSMutableDictionary dictionary];
        dictMGrouping[@"sv_mg_name"] = @"全部";
        dictMGrouping[@"membergroup_id"] = @"0";
        [self.MembershipGroupingArray addObject:dictMGrouping];
        NSArray *array = dic[@"values"][@"getMembergroup"];
        [self.MembershipGroupingArray addObjectsFromArray:array];
      //  NSLog(@"self.groupArr = %@",self.groupArr);
        
        // 会员标签
        NSMutableDictionary *dictMLabel = [NSMutableDictionary dictionary];
        dictMLabel[@"sv_mt_name"] = @"全部";
        dictMLabel[@"membertag_id"] = @"";
        [self.MembershipLabelArray addObject:dictMLabel];
        NSArray *array2 = dic[@"values"][@"getSv_membertag"];
        [self.MembershipLabelArray addObjectsFromArray:array2];
        // 会员等级
        NSMutableDictionary *dictMLevel = [NSMutableDictionary dictionary];
        dictMLevel[@"sv_ml_name"] = @"全部";
        dictMLevel[@"memberlevel_id"] = @"0";
        [self.MembershipLevelArray addObject:dictMLevel];
        NSArray *array3 = dic[@"values"][@"getUserLevel"];
        [self.MembershipLevelArray addObjectsFromArray:array3];
        
        // 会员等级
        [self setUpMembershipLevel];
        // 会员分组
        [self setUpMembershipGrouping];
        // 会员标签
        [self setUpMembershipLabel];
        
        // 会员流失
        [self setUpCustomerChurn];
        
        // 欠款会员
        [self setUpMemberArrears];
        
        // 过期时间
        [self setUpExpirationTime];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
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

#pragma mark - 员工查询
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

#pragma mark - 会员等级
- (void)setUpMembershipLevel{
    [self.MembershipLevelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.MembershipLevelArray.count; i++) {
            NSDictionary *dict = self.MembershipLevelArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"sv_ml_name"]];
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
            [self.MembershipLevelView addSubview:tagBtn];
            if (i == 0) {
                [self MembershipLevelBtnClick:tagBtn];
            }
            
//            if (!kStringIsEmpty(self.type)) {
//                if ([self.type isEqualToString:paymentStr]) {
//                    [self MembershipGroupingBtnClick:tagBtn];
//                }
//           }
            
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.MembershipLevelHeight.constant = tagBtnY + 32;
            self.MembershipLevelBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 会员等级按钮的点击
- (void)MembershipLevelBtnClick:(UIButton *)btn{
    self.MembershipLevelBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.MembershipLevelBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.MembershipLevelBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.MembershipLevelBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSLog(@"会员等级按钮的点击 btn.tag = %ld",btn.tag);
    NSDictionary *dict = self.MembershipLevelArray[btn.tag];
    self.dengji = [dict[@"memberlevel_id"] integerValue];
    self.MembershipLevelBtn = btn;
}


#pragma mark - 会员分组
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
#pragma mark - 会员分组的点击
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

#pragma mark - 会员标签
- (void)setUpMembershipLabel{
    [self.MembershipLabelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.MembershipLabelArray.count; i++) {
            NSDictionary *dict = self.MembershipLabelArray[i];
            NSString *paymentStr = [NSString stringWithFormat:@"%@",dict[@"sv_mt_name"]];
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
            
            
            [tagBtn addTarget:self action:@selector(MembershipLabelClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.MembershipLabelView addSubview:tagBtn];
            if (i == 0) {
                [self MembershipLabelClick:tagBtn];
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.MembershipLabelHeight.constant = tagBtnY + 32;
            self.MembershipLabelBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 标签
- (void)MembershipLabelClick:(UIButton *)btn{
    self.MembershipLabelBtn.selected = NO;
       // self.PaymentMethodBtn.layer.borderColor =[UIColor grayColor].CGColor;
     //   self.ConsumersBtn.backgroundColor = backColor;
    [self.MembershipLabelBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.MembershipLabelBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.MembershipLabelBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        btn.selected = YES;
       // [btn setBackgroundColor:navigationBackgroundColor];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    NSDictionary *dict = self.MembershipLabelArray[btn.tag];
    self.biaoqian = [NSString stringWithFormat:@"%@",dict[@"membertag_id"]];
        self.MembershipLabelBtn = btn;
}

#pragma mark - 客户流失
- (void)setUpCustomerChurn{
    [self.CustomerChurnView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.CustomerChurnArray.count; i++) {
           // NSDictionary *dict = self.MembershipLabelArray[i];
            NSString *paymentStr = self.CustomerChurnArray[i];
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
            
            [tagBtn addTarget:self action:@selector(CustomerChurnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.CustomerChurnView addSubview:tagBtn];
            if (i == 0) {
                [self CustomerChurnClick:tagBtn];
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.CustomerChurnHeight.constant = tagBtnY + 32;
            self.CustomerChurnBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 客户流失
- (void)CustomerChurnClick:(UIButton *)btn{
    self.CustomerChurnBtn.selected = NO;
    [self.CustomerChurnBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.CustomerChurnBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.CustomerChurnBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    if (btn.tag == 0) {
        self.liusi = 0;
    }else if (btn.tag == 1){
        self.liusi = -1;
    }else if (btn.tag == 2){
        self.liusi = 30;
    }else if (btn.tag == 3){
        self.liusi = 90;
    }else if (btn.tag == 4){
        self.liusi = 6*30;
    }else if (btn.tag == 5){
        self.liusi = 365;
    }
    
    NSLog(@"self.liusi = %ld",self.liusi);
    
    self.CustomerChurnBtn = btn;
}

#pragma mark - 欠款会员
- (void)setUpMemberArrears{
    [self.MemberArrearsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.DefaultingMemberArray.count; i++) {
           // NSDictionary *dict = self.MembershipLabelArray[i];
            NSString *paymentStr = self.DefaultingMemberArray[i];
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
            
            
            [tagBtn addTarget:self action:@selector(MemberArrearsViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.MemberArrearsView addSubview:tagBtn];
            if (i == 0) {
                [self MemberArrearsViewClick:tagBtn];
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.MemberArrearsHeight.constant = tagBtnY + 32;
            self.MemberArrearsBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 欠款会员
- (void)MemberArrearsViewClick:(UIButton *)btn{
    self.MemberArrearsBtn.selected = NO;
    [self.MemberArrearsBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.MemberArrearsBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.MemberArrearsBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    if (btn.tag == 0) {
        self.hascredit = -1;
    }else if (btn.tag == 1){
        self.hascredit = 0;
    }else if (btn.tag == 2){
        self.hascredit = 1;
    }
    self.MemberArrearsBtn = btn;
}


#pragma mark - 过期时间
- (void)setUpExpirationTime{
    [self.ExpirationTimeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     // 支付方式
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.ExpirationTimeArray.count; i++) {
           // NSDictionary *dict = self.MembershipLabelArray[i];
            NSString *paymentStr = self.ExpirationTimeArray[i];
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
            
            
            [tagBtn addTarget:self action:@selector(ExpirationTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.ExpirationTimeView addSubview:tagBtn];
            if (i == 0) {
                [self ExpirationTimeClick:tagBtn];
            }
            

            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.ExpirationTimeViewHeight.constant = tagBtnY + 32;
            self.ExpirationTimeViewBigHeight.constant = tagBtnY + 32 + 38;
        }
}

#pragma mark - 过期时间
- (void)ExpirationTimeClick:(UIButton *)btn{
    self.ExpirationTimeBtn.selected = NO;
    [self.ExpirationTimeBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.ExpirationTimeBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.ExpirationTimeBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    btn.layer.borderColor = navigationBackgroundColor.CGColor;
    [btn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    if (btn.tag == 0) {
        self.start_deadline = @"";
        self.end_deadline = @"";
    }else{
        //获取当前时间，日期
           NSDate *currentDate = [NSDate date];
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
          //获取前一个月的时间
          NSDate *monthagoData = [self getPriousorLaterDateFromDate:currentDate withMonth:+1];
           NSString *agoString = [dateFormatter stringFromDate:monthagoData];
        NSLog(@"currentDateString = %@,agoString=%@",currentDateString,agoString);
        self.start_deadline = currentDateString;
        self.end_deadline = agoString;
    }
    self.ExpirationTimeBtn = btn;
}

-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

//#pragma mark -得到当前时间date
//- (NSDate *)getCurrentTime{
//
//    //2017-04-24 08:57:29
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
//    NSDate *date = [formatter dateFromString:dateTime];
////    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
////    NSString *dateString = [formatter stringFromDate:date];
////    NSLog(@"datastring  = %@",dateString);
//    return date;
//}

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
    [self.TwovipPickerView removeFromSuperview];
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

#pragma mark - 点击会员来源
- (void)twovipDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
       NSInteger row = [self.TwovipPickerView.twoVipPicker selectedRowInComponent:0];
    self.MembershipSourcesLabel.text = [self.MembershipSourcesArray objectAtIndex:row];
   // self.storeLabel.text = dic[@"sv_us_name"];
   // self.operationLabel.text = dic[@"sp_salesclerk_name"];
    self.MembershipSourcesLabel.textColor = [UIColor blackColor];
   // self.storeId = dic[@"user_id"];
    [self.TwovipPickerView removeFromSuperview];
    if (row == 0) {
        self.reg_source = -1;
    }else if (row == 1){
        self.reg_source = 1;
    }else{
        self.reg_source = 0;
    }
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
       self.EmployeeInquiryLabel.text = dic[@"sp_salesclerk_name"];
       self.EmployeeInquiryLabel.textColor = [UIColor blackColor];
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
    }else if (pickerView == self.genderPickerView.genderPicker){
        return self.letter.count;
       
    }else{
        return self.MembershipSourcesArray.count;
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
    }else if (pickerView == self.genderPickerView.genderPicker){
        // return self.letter[row];
         NSDictionary *dict = self.letter[row];
         NSString *sv_employee_name = dict[@"sp_salesclerk_name"];
         return sv_employee_name;
       
    }else{
        NSString *sv_us_name = self.MembershipSourcesArray[row];
       
        return sv_us_name;
   }
}

#pragma mark - 懒加载

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



//self.rightView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW /4 *3, ScreenH)];

//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskView addGestureRecognizer:tap];
        
        [_maskView addSubview:_DateView];
    }
    return _maskView;
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
    
}

- (void)twoCancelResponseEvent {
    
 
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    NSString *twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.DateView withSing:@"结束时间应在开始时间之后"];
        
    } else {
        [self oneCancelResponseEvent];
        self.reg_start_date = [NSString stringWithFormat:@"%@ 00:00:00",oneDate];
        self.reg_end_date = [NSString stringWithFormat:@"%@ 23:59:59",twoDate];
        self.zhuceTime.text = [NSString stringWithFormat:@"%@ - %@",oneDate,twoDate];
        self.zhuceTime.textColor = [UIColor blackColor];
//        //提示查询
//                [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
//        [SVTool IndeterminateButtonAction:self withSing:@"查询中…"];
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//
//        self.fourPage = 1;
//        [self.dateArr removeAllObjects];
//        [self.dateMoneyArr removeAllObjects];
//        [self.dateModelArr removeAllObjects];
//        //数据请求
//      //  [self getThreeSourcesWithPage:1 top:10 day:self.buttonNum payname:@"" keys:@"" date:self.oneDate date2:self.twoDate keyWords:self.searchSelectName];
//        [self getThreeSourcesWithPage:1 top:10 day:self.buttonNum payname:self.payName date:self.oneDate date2:self.twoDate keyWords:self.searchSelectName type:self.type liushui:self.liushui storeid:self.storeid seller:self.sv_employee_id memberId:self.memberId orderSource:self.orderSource product:self.product seachMemberStr:self.seachMemberStr];
    }
    
    
}




- (NSArray *)CustomerChurnArray{
    if (_CustomerChurnArray == nil) {
        _CustomerChurnArray = @[@"全部",@"已过期会员",@"一个月没购买",@"3个月没购买",@"半年没购买",@"一年没购买"];
    }
    return _CustomerChurnArray;
}

// 欠款会员
- (NSArray *)DefaultingMemberArray{
    if (_DefaultingMemberArray == nil) {
        _DefaultingMemberArray = @[@"全部",@"正常",@"欠款"];
    }
    return _DefaultingMemberArray;
}

// 过期时间
- (NSArray *)ExpirationTimeArray{
    if (_ExpirationTimeArray == nil) {
        _ExpirationTimeArray = @[@"全部",@"近一个月内过期"];
    }
    return _ExpirationTimeArray;
}

-(NSArray *)letter{
    if (!_letter) {
        _letter = [NSArray array];
    }
    return _letter;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSArray *)MembershipSourcesArray{
    if (_MembershipSourcesArray == nil) {
        _MembershipSourcesArray = @[@"全部",@"微信",@"线下"];
    }
    return _MembershipSourcesArray;
}
- (NSMutableArray *)MembershipGroupingArray{
    if (!_MembershipGroupingArray) {
        _MembershipGroupingArray = [NSMutableArray array];
    }
    return _MembershipGroupingArray;
}

- (NSMutableArray *)MembershipLevelArray{
    if (!_MembershipLevelArray) {
        _MembershipLevelArray = [NSMutableArray array];
    }
    return _MembershipLevelArray;
}

- (NSMutableArray *)MembershipLabelArray{
    if (!_MembershipLabelArray) {
        _MembershipLabelArray = [NSMutableArray array];
    }
    return _MembershipLabelArray;
}

@end

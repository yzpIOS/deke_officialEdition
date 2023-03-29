//
//  SVSupplierReconciliationDetailVC.m
//  SAVI
//
//  Created by houming Wang on 2021/4/13.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSupplierReconciliationDetailVC.h"
#import "SVReconciliationModel.h"
#import "SVReconciliationDetailCell.h"
#import "SVRepaymentView.h"
#import "SVDiscountAndNumberView.h"
#import "UITextView+ZWPlaceHolder.h"
static NSString *const ID = @"SVReconciliationDetailCell";
@interface SVSupplierReconciliationDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *BusinessOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *mendian;

@property (weak, nonatomic) IBOutlet UILabel *PurchaseTime;

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_realpay;

@property (weak, nonatomic) IBOutlet UILabel *payable_arrears;

@property (nonatomic,strong) NSArray * product_list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) SVRepaymentView * repaymentView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) SVReconciliationModel *modelTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huankuanHeight;
@property (nonatomic,strong) SVDiscountAndNumberView *discountAndNumberView;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
@property (nonatomic,strong) NSString * money;
@end

@implementation SVSupplierReconciliationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"对账详情";
    
    if (self.model.sv_is_arrears == 1) {
        self.huankuanHeight.constant = 50;
//        self.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",model.sv_pc_total];
//      //
//        self.sv_pc_total.textColor = [UIColor colorWithHexString:@"#999999"];
    }else{
        self.huankuanHeight.constant = 0;
//        self.sv_pc_total.text = @"无欠款";
//        self.sv_pc_total.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVReconciliationDetailCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadData];
}

- (void)loadData{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/StockInOutManage/Getprocurement_supplier?key=%@&uid=%ld&id=%ld&code=%@&type=%ld",token,(long)self.model.user_id,(long)self.model.sv_pc_id,self.model.sv_pc_noid,(long)self.model.sv_type];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            SVReconciliationModel *model = [SVReconciliationModel mj_objectWithKeyValues:data];
            self.modelTwo = model;
            self.BusinessOrderNo.text = model.sv_pc_noid;
            self.mendian.text = model.sv_targetwarehouse_name;
           // self.PurchaseTime.text = model.sv_pc_cdate
            NSString *timeString = model.sv_pc_cdate;
            NSString *time1 = [timeString substringToIndex:10];
            NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
            self.PurchaseTime.text = [NSString stringWithFormat:@"%@ %@",time1,time2];
            self.sv_pc_total.text = [NSString stringWithFormat:@"%.2f",model.sv_pc_total];
            self.sv_pc_realpay.text = [NSString stringWithFormat:@"%.2f",model.sv_pc_realpay];
            self.payable_arrears.text = [NSString stringWithFormat:@"%.2f",model.payable_arrears];
            
            _product_list = data[@"product_list"];
            [self.tableView reloadData];
            
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}
#pragma mark - 点击还款
- (IBAction)repaymentClick:(id)sender {
//    [SVUserManager loadUserInfo];
//    NSString *token = [SVUserManager shareInstance].access_token;
//    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/Supplier_Repayment_Purchase_order?key=%@",token];
//    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
//    parame[@"money"] =
//    parame[@"sv_pc_id"] =
//    parame[@"sv_remark"] =
//    parame[@"sv_repaydate"] =
//    parame[@"sv_repayment_code"] =
//    parame[@"sv_suid"] =
//    parame[@"user_id"] =
    [self.view addSubview:self.maskOneView];
    [self.view addSubview:self.repaymentView];
    self.repaymentView.supplier.text = self.modelTwo.sv_suname;
    self.repaymentView.SettlementNo.text = self.modelTwo.sv_pc_noid;
    self.repaymentView.ArrearsDue.text = [NSString stringWithFormat:@"%.2f",self.modelTwo.payable_arrears];
    
}
#pragma mark - 还款确定按钮的点击
- (void)sureBtnClick{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/Supplier_Repayment_Purchase_order?key=%@",token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"money"] = [NSString stringWithFormat:@"%.2f",self.money.doubleValue]; // 金额
    parame[@"sv_pc_id"] = [NSNumber numberWithInteger:self.modelTwo.sv_pc_id];
    parame[@"sv_remark"] = _repaymentView.beizhuTextView.text; // 备注
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];

    NSString *DateTime = [formatter stringFromDate:date];
    parame[@"sv_repaydate"] = DateTime;
    
    parame[@"sv_repayment_code"] = [NSString stringWithFormat:@"%ld",(long)self.modelTwo.sv_pc_noid];
    parame[@"sv_suid"] = [NSString stringWithFormat:@"%ld",(long)self.modelTwo.sv_suid];
    parame[@"user_id"] = [NSString stringWithFormat:@"%ld",(long)self.modelTwo.user_id];
    [parame setObject:@"301" forKey:@"sv_operation_source"];
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] integerValue] == 1) {
            NSNotification *LoseResponse = [NSNotification notificationWithName:@"SuccessfulRepayment" object:nil];
                       [[NSNotificationCenter defaultCenter] postNotification:LoseResponse];
            [SVTool TextButtonActionWithSing:@"还款成功"];
            [self vipCancelResponseEvent];
        }else{
            [SVTool TextButtonActionWithSing:@"还款失败"];
            [self vipCancelResponseEvent];
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
 //   self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   // [self addSearchBar];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.product_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVReconciliationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVReconciliationDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.dict = self.product_list[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSArray *)product_list{
    if (!_product_list) {
        _product_list = [NSArray array];
    }
    return _product_list;
}

/**
 等级遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

- (void)vipCancelResponseEvent{
    _repaymentView.beizhuTextView.text = nil;
    self.money = @"";
    self.repaymentView.repaymentMoney.text = @"还款金额";
    self.repaymentView.repaymentMoney.textColor = an_gradeColor;
    [self.maskOneView removeFromSuperview];
    [self.repaymentView removeFromSuperview];
  //  [self.discountAndNumberView removeFromSuperview];
}

- (SVRepaymentView *)repaymentView{
    if (_repaymentView == nil) {
        _repaymentView = [[NSBundle mainBundle] loadNibNamed:@"SVRepaymentView" owner:nil options:nil].lastObject;
//        _promptRenewalView.renewLabel.text = @"是否暂停该供应商";
//        [_promptRenewalView.renewBtn setTitle:@"暂停" forState:UIControlStateNormal];
        _repaymentView.frame = CGRectMake(20, 20, ScreenW - 40, 420);
        _repaymentView.layer.cornerRadius = 10;
        _repaymentView.layer.masksToBounds = YES;
       // _repaymentView.center = self.view.center;
      //  [_promptRenewalView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_repaymentView.repaymentView addGestureRecognizer:tap];
        _repaymentView.beizhuTextView.zw_placeHolder = @"备注信息";
        _repaymentView.beizhuTextView.zw_placeHolderColor = an_gradeColor;
        _repaymentView.repaymentMoney.textColor = an_gradeColor;
        _repaymentView.sureBtn.layer.cornerRadius = 20;
        _repaymentView.sureBtn.layer.masksToBounds = YES;
         [_repaymentView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
         [_repaymentView.clearBtn addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
     return _repaymentView;
}

- (SVDiscountAndNumberView *)discountAndNumberView{
    if (!_discountAndNumberView) {
        _discountAndNumberView = [[NSBundle mainBundle]loadNibNamed:@"SVDiscountAndNumberView" owner:nil options:nil].lastObject;
        _discountAndNumberView.nameLabel.text = @"输入还款金额";
        _discountAndNumberView.frame = CGRectMake(30, 0, ScreenW -60,490);
          _discountAndNumberView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _discountAndNumberView.layer.cornerRadius = 10;
        _discountAndNumberView.layer.masksToBounds = YES;
        [_discountAndNumberView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _discountAndNumberView;
}

////点击手势的点击事件
//- (void)dateCancelResponseEvent{
//    [self.maskOneView removeFromSuperview];
//    [self.discountAndNumberView removeFromSuperview];
//}

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

//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.discountAndNumberView removeFromSuperview];
    self.discountAndNumberView.sumLabel.text = @"请输入金额";
    self.discountAndNumberView.sumLabel.textColor = an_gradeColor;
    [self.discountAndNumberView.string setString:@""];
}

//#pragma mark - 还款金额弹框
//- (void)tapClick{
//    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.discountAndNumberView];
//}
#pragma mark - 还款金额弹框
- (void)tapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.discountAndNumberView];
    self.discountAndNumberView.huankuanMoney = self.modelTwo.payable_arrears;
    __weak typeof(self) weakSelf = self;
    self.discountAndNumberView.moneyBlock = ^(NSString * _Nonnull money) {
        weakSelf.money = money;
        [weakSelf dateCancelResponseEvent];
        weakSelf.repaymentView.repaymentMoney.textColor = an_redColor;
        weakSelf.repaymentView.repaymentMoney.text = [NSString stringWithFormat:@"%.2f",money.doubleValue];
    };
}
@end

//
//  SVPaymentHistoryVC.m
//  SAVI
//
//  Created by houming Wang on 2021/4/30.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVPaymentHistoryVC.h"
#import "SVPaymentHistoryCell.h"
#import "SVRepaymentView.h"
#import "SVDiscountAndNumberView.h"
#import "UITextView+ZWPlaceHolder.h"
static NSString *const ID = @"SVPaymentHistoryCell";
@interface SVPaymentHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *gongyingshang;
@property (weak, nonatomic) IBOutlet UILabel *lianxiren;
@property (weak, nonatomic) IBOutlet UILabel *lianxidianhua;
@property (weak, nonatomic) IBOutlet UILabel *chuqiqiankuan;
@property (weak, nonatomic) IBOutlet UILabel *yingfuqiankuan;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString * keyStr;

@property (weak, nonatomic) IBOutlet UIButton *paymentHistoryBtn;

@property (nonatomic,strong) SVRepaymentView * repaymentView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) SVDiscountAndNumberView *discountAndNumberView;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
@property (nonatomic,strong) NSString * sv_repayment_code;
@property (nonatomic,strong) NSDictionary * listDict;
@property (nonatomic,strong) NSString * sv_suid;
@property (nonatomic,strong) NSString * money;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huankuanBtnHeight;

@end

@implementation SVPaymentHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"还款记录";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVPaymentHistoryCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.paymentHistoryBtn.backgroundColor = navigationBackgroundColor;
    [self loadData];
    [self addSetUpRefresh];
}

#pragma mark - 点击还款记录
- (IBAction)paymentHistoryClick:(id)sender {
    [self loadSupplierApiGetRepayment];
//    [self.view addSubview:self.maskOneView];
//    [self.view addSubview:self.repaymentView];
//    self.gongyingshang.text = listDict[@"sv_suname"];
//    self.lianxiren.text = listDict[@"sv_sulinkmnm"];
//    self.lianxidianhua.text = listDict[@"sv_sumoble"];
//    self.chuqiqiankuan.text = [NSString stringWithFormat:@"%.2f",[listDict[@"sv_initial_arrears"] doubleValue]];
//    self.yingfuqiankuan.text = [NSString stringWithFormat:@"%.2f",[listDict[@"arrears"] doubleValue]];
    [self.view addSubview:self.maskOneView];
    [self.maskOneView addSubview:self.repaymentView];
    self.repaymentView.repaymentMoney.text = @"还款金额";
    self.repaymentView.supplier.text = self.listDict[@"sv_suname"];
    self.repaymentView.ArrearsDue.text =  [NSString stringWithFormat:@"%.2f",[self.listDict[@"arrears"] doubleValue]];
   
   
    
}

- (void)loadSupplierApiGetRepayment{
   //
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/GetRepayment?key=%@",token];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            self.sv_repayment_code = dic[@"data"][@"sv_repayment_code"];
            self.repaymentView.SettlementNo.text = self.sv_repayment_code;
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

//[self.maskOneView removeFromSuperview];
//[self.repaymentView removeFromSuperview];
- (void)loadData{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/Getsupplier_arrears?key=%@",token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"id"] = [NSNumber numberWithInt:0];
   // parame[@"keywards"] = keyStr;
    parame[@"page"] = [NSNumber numberWithInt:1];
    parame[@"pagesize"] = [NSNumber numberWithInt:20];
    parame[@"reviewer_by"] = [NSNumber numberWithInt:0];
    parame[@"state"] =[NSNumber numberWithInt:0];
    parame[@"state1"] = [NSNumber numberWithInt:-1];
    parame[@"supp_id"] = self.supp_id;
    parame[@"sv_enable"] =[NSNumber numberWithInt:-1];
    parame[@"sv_order_type"] = [NSNumber numberWithInt:0];
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            NSArray *list = dic[@"data"][@"list"];
            NSDictionary *listDict = list[0];
            self.listDict = listDict;
            self.gongyingshang.text = listDict[@"sv_suname"];
            self.lianxiren.text = listDict[@"sv_sulinkmnm"];
            self.lianxidianhua.text = listDict[@"sv_sumoble"];
            self.chuqiqiankuan.text = [NSString stringWithFormat:@"%.2f",[listDict[@"sv_initial_arrears"] doubleValue]];
            self.yingfuqiankuan.text = [NSString stringWithFormat:@"%.2f",[listDict[@"arrears"] doubleValue]];
            if ([listDict[@"arrears"] doubleValue] > 0) {
                self.huankuanBtnHeight.constant = 50;
            }else{
                self.huankuanBtnHeight.constant = 0;
            }
            
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

- (void)addSetUpRefresh{

    self.page = 1;
    self.keyStr = @"";
   // self.searchBar.text = nil;
    //调用请求
  //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
    [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.keyStr = @"";
       // self.searchBar.text = nil;
        //调用请求
      //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
    }];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    //[header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //[header setImages:pullingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    //[header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    //header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    //header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    //上拉刷新
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //调用请求
        [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
        
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
    // 隐藏刷新状态的文字
    //footer.stateLabel.hidden = YES;
    // 设置刷新图片
    //[footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    
    // 设置正在刷新状态的动画图片
    [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
   // [self addSearchBar];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)GetReconciliation_supplier_list:(NSInteger)page pagesize:(NSInteger)pagesize keyStr:(NSString *)keyStr{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/GetSupplier_repaylsit?key=%@",token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"id"] = [NSNumber numberWithInt:0];
    parame[@"keywards"] = keyStr;
    parame[@"page"] = [NSString stringWithFormat:@"%ld",page];
    parame[@"pagesize"] = [NSString stringWithFormat:@"%ld",pagesize];
    parame[@"reviewer_by"] = [NSNumber numberWithInt:0];
    parame[@"state"] =[NSNumber numberWithInt:0];
    parame[@"state1"] = [NSNumber numberWithInt:-1];
    parame[@"supp_id"] = self.supp_id;
    parame[@"sv_enable"] =[NSNumber numberWithInt:-1];
    parame[@"sv_order_type"] = [NSNumber numberWithInt:0];
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
           
            //有多少位供应高
          //  self.labelB.text = [NSString stringWithFormat:@"%@",listDic[@"total"]];
            
            NSArray *dataList = data[@"list"];
            
            //判断如果为1时，清理模型数组
            if (page == 1) {
                
                [self.modelArr removeAllObjects];
                
            }
            
            if (![SVTool isEmpty:dataList]) {

                for (NSDictionary *dict in dataList) {
                    //字典转模型
//                    SVReconciliationModel *model = [SVReconciliationModel mj_objectWithKeyValues:dict];
//
                   [self.modelArr addObject:dict];
                 
                    
                }
                
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
                
            } else {
                
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                //提示没有供应商
//                if (self.modelArr.count == 0) {
//                  //  self.noLabel.hidden = NO;
//                }
                
            }
        }else{
            
        }
        
        [self.tableView reloadData];
        //是否正在刷新
        if ([self.tableView.mj_header isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }
        
        //是否正在刷新
        if ([self.tableView.mj_footer isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVPaymentHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVPaymentHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.dict = self.modelArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

#pragma mark - 还款确定按钮的点击
- (void)sureBtnClick{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/Getsupplier_Repayment?key=%@",token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"money"] = [NSString stringWithFormat:@"%.2f",self.money.doubleValue]; // 金额
    parame[@"sv_pc_id"] = [NSNumber numberWithInteger:0];
    parame[@"sv_remark"] = _repaymentView.beizhuTextView.text; // 备注
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];

    NSString *DateTime = [formatter stringFromDate:date];
    parame[@"sv_repaydate"] = DateTime;
    
    parame[@"sv_repayment_code"] = self.sv_repayment_code;
    parame[@"sv_suid"] = [NSString stringWithFormat:@"%@",self.listDict[@"sv_suid"]];
    [parame setObject:@"301" forKey:@"sv_operation_source"];
//    parame[@"user_id"] = [NSString stringWithFormat:@"%ld",(long)self.modelTwo.user_id];
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] integerValue] == 1) {
            NSNotification *LoseResponse = [NSNotification notificationWithName:@"SuccessfulRepayment" object:nil];
                       [[NSNotificationCenter defaultCenter] postNotification:LoseResponse];
            [SVTool TextButtonActionWithSing:@"还款成功"];
            [self loadData];
            self.page = 1;
            self.keyStr = @"";
           // self.searchBar.text = nil;
            //调用请求
          //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
            [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
            [self vipCancelResponseEvent];
        }else{
            [SVTool TextButtonActionWithSing:@"还款失败"];
            [self vipCancelResponseEvent];
        }
        
        
        
        _repaymentView.beizhuTextView.text = nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            _repaymentView.beizhuTextView.text = nil;
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
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
        _repaymentView.center = CGPointMake(ScreenW / 2, ScreenH /2-20);
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
       // .center = self.view.center;
          _discountAndNumberView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _discountAndNumberView.layer.cornerRadius = 10;
        _discountAndNumberView.layer.masksToBounds = YES;
        [_discountAndNumberView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _discountAndNumberView;
}

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

#pragma mark - 还款金额弹框
- (void)tapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.discountAndNumberView];
    self.discountAndNumberView.huankuanMoney = [self.listDict[@"arrears"] doubleValue];
    __weak typeof(self) weakSelf = self;
    self.discountAndNumberView.moneyBlock = ^(NSString * _Nonnull money) {
        weakSelf.money = money;
        [weakSelf dateCancelResponseEvent];
        weakSelf.repaymentView.repaymentMoney.textColor = an_redColor;
        weakSelf.repaymentView.repaymentMoney.text = [NSString stringWithFormat:@"%.2f",money.doubleValue];
    };
}

@end

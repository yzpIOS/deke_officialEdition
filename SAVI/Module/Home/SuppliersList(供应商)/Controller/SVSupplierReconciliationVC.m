//
//  SVSupplierReconciliationVC.m
//  SAVI
//
//  Created by houming Wang on 2021/4/13.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSupplierReconciliationVC.h"
#import "SVNewSupplierReconciliationCell.h"
#import "SVReconciliationModel.h"
#import "SVSupplierReconciliationDetailVC.h"
#import "SVSupplierSelectionView.h"

static NSString *const ID = @"SVNewSupplierReconciliationCell";
@interface SVSupplierReconciliationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataList;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString * keyStr;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *AmountPayable;// 应付金额

@property (weak, nonatomic) IBOutlet UILabel *AmountActuallyPaid; // 实付金额

@property (weak, nonatomic) IBOutlet UILabel *TotalAmountOwed; // 应付欠款总汇
@property (nonatomic,strong) SVSupplierSelectionView *supplierSelectionView;
@property (nonatomic,strong) NSArray * dataArray;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) NSArray * DocumentTypeArray;

@property (nonatomic,strong) NSString *start_date;// 开始时间
@property (nonatomic,strong) NSString *end_date; // 结束时间
@property (nonatomic,assign) NSInteger state1; // 赊账状态
@property (nonatomic,assign) NSInteger sv_enable; // 状态
//@property (nonatomic,assign) NSInteger sv_suid; // 供应商
@property (nonatomic,assign) NSInteger sv_order_type; // 单据类型
@end

@implementation SVSupplierReconciliationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.start_date = @"";
    self.end_date = @"";
    self.state1 = -1;
    self.sv_enable = -1;
//    self.sv_suid = -1;
    self.sv_order_type = 0;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    self.searchView.layer.cornerRadius = 19;
    self.searchView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    self.topView.backgroundColor = navigationBackgroundColor;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    self.title = @"对账";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewSupplierReconciliationCell" bundle:nil] forCellReuseIdentifier:ID];
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.page = 1;
    self.keyStr = @"";
    [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid sv_order_type:self.sv_order_type];
    [self SupplierApiGetsupplier_select];
    [self StockInOutManageGetorder_type];
    [self loadData];
}

- (void)StockInOutManageGetorder_type{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/StockInOutManage/Getorder_type?key=%@",token];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            NSArray *dataArray = dic[@"data"];
            self.DocumentTypeArray = dataArray;
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}


- (void)SupplierApiGetsupplier_select{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/Getsupplier_select?key=%@",token];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            NSArray *dataArray = dic[@"data"];
            self.dataArray = dataArray;
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (void)selectbuttonResponseEvent{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.supplierSelectionView];
    self.supplierSelectionView.dataArray = self.dataArray;
    self.supplierSelectionView.DocumentTypeArray = self.DocumentTypeArray;
    __weak typeof(self) weakSelf = self;
    //实现弹出方法
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.supplierSelectionView.frame = CGRectMake(ScreenW /6 *1, TopHeight, ScreenW /6 *5, ScreenH - TopHeight);
    }];
    
    self.supplierSelectionView.supplierDetermineBlock = ^(NSString * _Nonnull start_date, NSString * _Nonnull end_date, NSInteger state1, NSInteger sv_enable, NSInteger sv_suid, NSInteger sv_order_type) {
        [weakSelf handlePan];
        weakSelf.start_date = start_date;
        weakSelf.end_date = end_date;
        weakSelf.state1 = state1;
        weakSelf.sv_enable = sv_enable;
        weakSelf.sv_suid = sv_suid;
        weakSelf.sv_order_type = sv_order_type; // 单据类型
        [weakSelf handlePan];
        weakSelf.page = 1;
        weakSelf.keyStr = @"";
        weakSelf.searchBar.text = nil;
        //调用请求
       // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [weakSelf GetReconciliation_supplier_list:weakSelf.page pagesize:20 keyStr:weakSelf.keyStr start_date:weakSelf.start_date end_date:weakSelf.end_date state1:weakSelf.state1 sv_enable:weakSelf.sv_enable sv_suid:weakSelf.sv_suid sv_order_type:weakSelf.sv_order_type];
    };
}

- (SVSupplierSelectionView *)supplierSelectionView{
    if (!_supplierSelectionView) {
        _supplierSelectionView = [[NSBundle mainBundle]loadNibNamed:@"SVSupplierSelectionView" owner:nil options:nil].lastObject;
        _supplierSelectionView.frame = CGRectMake(ScreenW, TopHeight, ScreenW /6 *5, ScreenH - TopHeight);
        
    }
    return _supplierSelectionView;
}

//移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.3 animations:^{
        self.supplierSelectionView.frame = CGRectMake(ScreenW, TopHeight, ScreenW / 6 *5, ScreenH - TopHeight);
    }];
 
}

/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}

- (void)loadData{
//    /*仓库/店铺id（非仓库调拨列表支持仓库。店铺，仓库调拨列表只支持仓库id）*/
//    private int id;
//    /*自定义模糊查询 跟业务查询*/
//    private String keywards;
//    /*页数*/
//    private int page;
//    /*页码*/
//    private int pagesize;
//    /*供应商*/
//    private String supp_id;
//    /*账款状态  全部 -1，有欠款=1无欠款 0*/
//    private int state1;
//    /*开始时间*/
//    private String start_date;
//    /*结束时间*/
//    private String end_date;
//    /* 状态 是否启用 1启用，0暂停，-1全部*/
//    private int sv_enable;
//    /*单据类型*/
//    private int sv_order_type;
//    /*制单人-1全部*/
//    private int reviewer_by;
//    /*状态 -1全部 -2 非已作废（已删除）*/
//    private int state;
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.keyStr = @"";
        self.searchBar.text = nil;
        //调用请求
      //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid sv_order_type:self.sv_order_type];
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
        [self GetReconciliation_supplier_list:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid sv_order_type:self.sv_order_type];
        
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

- (void)GetReconciliation_supplier_list:(NSInteger)page pagesize:(NSInteger)pagesize keyStr:(NSString *)keyStr start_date:(NSString *)start_date end_date:(NSString *)end_date state1:(NSInteger)state1 sv_enable:(NSInteger)sv_enable sv_suid:(NSInteger)sv_suid sv_order_type:(NSInteger)sv_order_type{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/StockInOutManage/GetReconciliation_supplier_list?key=%@",token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"id"] = [NSNumber numberWithInteger:sv_order_type];
    parame[@"keywards"] = keyStr;
    parame[@"page"] = [NSNumber numberWithInteger:page];
    parame[@"pagesize"] = [NSNumber numberWithInteger:pagesize];
    parame[@"reviewer_by"] = [NSNumber numberWithInt:0];
    parame[@"state"] =[NSNumber numberWithInteger:0];
    parame[@"state1"] = [NSNumber numberWithInteger:state1];
    parame[@"supp_id"] = [NSNumber numberWithInteger:sv_suid];
    parame[@"sv_enable"] =[NSNumber numberWithInteger:sv_enable];
    parame[@"sv_order_type"] = [NSNumber numberWithInteger:sv_order_type];
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            NSDictionary *values = data[@"values"];
            self.AmountPayable.text = [NSString stringWithFormat:@"%.2f",[values[@"payable_Total"] doubleValue]];
            self.AmountActuallyPaid.text = [NSString stringWithFormat:@"%.2f",[values[@"actual_Payment_Total"] doubleValue]];
            double sum=[values[@"payable_Total"] doubleValue]-[values[@"actual_Payment_Total"] doubleValue];
            self.TotalAmountOwed.text = [NSString stringWithFormat:@"%.2f",sum];
            //有多少位供应高
          //  self.labelB.text = [NSString stringWithFormat:@"%@",listDic[@"total"]];
            
            NSArray *dataList = data[@"list"];
            
            //判断如果为1时，清理模型数组
            if (page == 1) {
                
                [self.modelArr removeAllObjects];
                
            }
            
            if (![SVTool isEmpty:dataList]) {
                
              //  self.noLabel.hidden = YES;
                
                for (NSDictionary *dict in dataList) {
                    //字典转模型
                    SVReconciliationModel *model = [SVReconciliationModel mj_objectWithKeyValues:dict];
//
                   [self.modelArr addObject:model];
                 
                    
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
        
        if (kArrayIsEmpty(self.modelArr)) {
            [self.img removeFromSuperview];
                  UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                 self.img = img;
                  [self.tableView addSubview:img];
                  [img mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.center.mas_equalTo(self.tableView);
                      make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                  }];
        }else{
            [self.img removeFromSuperview];
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

//- (void)selectbuttonResponseEvent{
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVNewSupplierReconciliationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVNewSupplierReconciliationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.model = self.modelArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSupplierReconciliationDetailVC *vc = [[SVSupplierReconciliationDetailVC alloc] init];
    vc.model = self.modelArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSArray *)DocumentTypeArray
{
    if (!_DocumentTypeArray) {
        _DocumentTypeArray = [NSArray array];
    }
    return _DocumentTypeArray;
}


- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end

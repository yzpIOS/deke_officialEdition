//
//  SVNewSupplierListVC.m
//  SAVI
//
//  Created by houming Wang on 2021/4/12.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewSupplierListVC.h"
#import "SVExpandBtn.h"
#import "SVNewSupplierListCell.h"
#import "SVAddSupplierVC.h"
#import "SVNewSupplierDetailVC.h"
#import "SVSupplierListModel.h"
#import "SVSupplierSelectionView.h"
static NSString *const ID = @"SVNewSupplierListCell";
@interface SVNewSupplierListVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SVExpandBtn *qrcode;
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView * tableView;
//模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;
//搜索的关键词
@property (nonatomic,strong) NSString *keyStr;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) SVSupplierSelectionView *supplierSelectionView;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) NSArray * dataArray;

@property (nonatomic,strong) NSString *start_date;// 开始时间
@property (nonatomic,strong) NSString *end_date; // 结束时间
@property (nonatomic,assign) NSInteger state1; // 赊账状态
@property (nonatomic,assign) NSInteger sv_enable;; // 状态
@property (nonatomic,assign) NSInteger sv_suid;; // 供应商
@end

@implementation SVNewSupplierListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.start_date = @"";
    self.end_date = @"";
    self.state1 = -1;
    self.sv_enable = -1;
    self.sv_suid = -1;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewSupplierListCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //底部按钮
    UIButton *dayin_button = [[UIButton alloc]init];
    
    [dayin_button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIControlStateNormal];
    [dayin_button addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dayin_button];
    [dayin_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    [self setupRefresh];
    [self SupplierApiGetsupplier_select];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SuccessfulRepaymentNoti:) name:@"SuccessfulRepayment" object:nil];
}
#pragma mark - 通知还款成功
- (void)SuccessfulRepaymentNoti:(NSNotification *)noti{
    self.page = 1;
    self.keyStr = @"";
    self.searchBar.text = nil;
    //调用请求
   // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
    [self GetsupplierListPage:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid];
}

-(void)dealloc{

//移除观察者
[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 添加新的供应商
- (void)addWaresButton{
    SVAddSupplierVC *VC = [[SVAddSupplierVC alloc] init];
    VC.supplierBool = YES;
  //  VC.isOpenSwi = YES;
    __weak typeof(self) weakSelf = self;
    VC.supplierBlock = ^{
        weakSelf.page = 1;
        weakSelf.keyStr = @"";
        weakSelf.searchBar.text = nil;
        //调用请求
       // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [weakSelf GetsupplierListPage:weakSelf.page pagesize:20 keyStr:weakSelf.keyStr start_date:weakSelf.start_date end_date:weakSelf.end_date state1:weakSelf.state1 sv_enable:weakSelf.sv_enable sv_suid:weakSelf.sv_suid];
    };
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
//    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    
//    [self addSearchBar];
//    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self addSearchBar];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    //添加方法二
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, ScreenW - 100, 34)];
    
    titleView.backgroundColor = [UIColor colorWithRed:121/255.0f green:142/255.0f blue:235/255.0f alpha:1];
//    titleView.backgroundColor = [UIColor whiteColor];
//    titleView.alpha = 0.5;
    //UIColor *color =  self.navigationController.navigationBar.tintColor;
    //[titleView setBackgroundColor:color];
    
   // saosao2white
    
    //扫一扫按钮
    self.qrcode = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
 //   self.qrcode.hidden = YES;
    self.qrcode.frame = CGRectMake(titleView.width - 50, 0, 40, 34);
    self.qrcode.centerY = titleView.centerY;
    [self.qrcode setImage:[UIImage imageNamed:@"saosao2white"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(OrderNumberQueryResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.qrcode];
//    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(titleView.mas_right).offset(5);
//        make.centerY.mas_equalTo(titleView.mas_centerY);
//    }];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleView.width - 60, 34)];
//    [SVUserManager loadUserInfo];
//    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
//
//        self.searchBar.placeholder = @"输入商品名称/款号";
//    }else{
        
        self.searchBar.placeholder = @"供应商，联系人，电话";
  //  }
   
    self.searchBar.alpha = 0.8;
  //  self.searchBar.backgroundColor = [UIColor clearColor];
    titleView.layer.cornerRadius = 17;
    titleView.layer.masksToBounds = YES;
   // titleView.backgroundColor = [UIColor clearColor];
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    //设置背景色
    self.searchBar.backgroundColor = [UIColor clearColor];
    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeDefault;
    //self.searchBar.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
    self.searchBar.delegate = self;
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;

    UITextField * searchField;
    if (@available(iOS 13.0, *)) { // iOS 11
        searchField = _searchBar.searchTextField;
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"供应商，联系人，电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
               // 输入文本颜色
               searchField.textColor = [UIColor whiteColor];
               searchField.font = [UIFont systemFontOfSize:12];
               searchField.backgroundColor = [UIColor clearColor];
        }else{
            
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"供应商，联系人，电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
               // 输入文本颜色
               searchField.textColor = [UIColor whiteColor];
               searchField.font = [UIFont systemFontOfSize:12];
               searchField.backgroundColor = [UIColor clearColor];
        }
    }else{
        searchField =  [_searchBar valueForKey:@"_searchField"];
        // 默认文本大小
      
        
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"供应商，联系人，电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
        }else{
            
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"供应商，联系人，电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
        }
        
        if (searchField) {
              [searchField setBackgroundColor:[UIColor clearColor]];
          }
          // 输入文本颜色
          searchField.textColor = [UIColor whiteColor];
          searchField.font = [UIFont systemFontOfSize:12];
    }
    
    searchField.leftView = nil;
    // 输入文本颜色
    searchField.textColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:12];

    //只有编辑时出现出现那个叉叉
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [titleView addSubview:self.searchBar];

    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];

}

#pragma mark - UISearchBarDelegate代理方法
//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //调用请求
    self.page = 1;
    [self GetsupplierListPage:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid];
    
    [searchBar resignFirstResponder];
    
}

//退出键盘响应方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
}

//刷新
-(void)setupRefresh{
    
    self.page = 1;
    self.keyStr = @"";
    self.searchBar.text = nil;
    //调用请求
   // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
    [self GetsupplierListPage:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.keyStr = @"";
        self.searchBar.text = nil;
        //调用请求
       // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [self GetsupplierListPage:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid];
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
        [self GetsupplierListPage:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid];
        
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

- (void)GetsupplierListPage:(NSInteger)page pagesize:(NSInteger)pagesize keyStr:(NSString *)keyStr start_date:(NSString *)start_date end_date:(NSString *)end_date state1:(NSInteger)state1 sv_enable:(NSInteger)sv_enable sv_suid:(NSInteger)sv_suid{
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/GetsupplierList?key=%@&page=%ld&pagesize=%ld&keywards=%@&start_date=%@&end_date=%@&state1=%ld&sv_enable=%ld&sv_suid=%ld",token,(long)page,(long)pagesize,keyStr,start_date,end_date,(long)state1,(long)sv_enable,(long)sv_suid];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            
            //有多少位供应高
          //  self.labelB.text = [NSString stringWithFormat:@"%@",listDic[@"total"]];
            
            NSArray *dataList = data[@"list"];
            
            //判断如果为1时，清理模型数组
            if (self.page == 1) {
                
                [self.modelArr removeAllObjects];
                
            }
            
            if (![SVTool isEmpty:dataList]) {
                
              //  self.noLabel.hidden = YES;
                
                for (NSDictionary *dict in dataList) {
                    //字典转模型
                    SVSupplierListModel *model = [SVSupplierListModel mj_objectWithKeyValues:dict];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVNewSupplierListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVNewSupplierListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.modelArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectNumber == 1) {
        if (self.selectSuplierBlock) {
            self.selectSuplierBlock(self.modelArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        SVNewSupplierDetailVC *vc = [[SVNewSupplierDetailVC alloc] init];
        __weak typeof(self) weakSelf = self;
        vc.EditSupplierBlock = ^{
            weakSelf.page = 1;
            weakSelf.keyStr = @"";
            weakSelf.searchBar.text = nil;
            //调用请求
           // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
            [weakSelf GetsupplierListPage:self.page pagesize:20 keyStr:self.keyStr start_date:self.start_date end_date:self.end_date state1:self.state1 sv_enable:self.sv_enable sv_suid:self.sv_suid];
        };
        SVSupplierListModel*model = self.modelArr[indexPath.row];
        vc.sv_suid = model.sv_suid;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}

- (void)selectbuttonResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.supplierSelectionView];
    self.supplierSelectionView.dataArray = self.dataArray;
    __weak typeof(self) weakSelf = self;
    //实现弹出方法
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.supplierSelectionView.frame = CGRectMake(ScreenW /6 *1, TopHeight, ScreenW /6 *5, ScreenH - TopHeight);
    }];
    
    
    self.supplierSelectionView.supplierDetermineBlock = ^(NSString * _Nonnull start_date, NSString * _Nonnull end_date, NSInteger state1, NSInteger sv_enable, NSInteger sv_suid, NSInteger sv_order_type) {
        weakSelf.start_date = start_date;
        weakSelf.end_date = end_date;
        weakSelf.state1 = state1;
        weakSelf.sv_enable = sv_enable;
        weakSelf.sv_suid = sv_suid;
//        weakSelf.start_date = start_date;
        
        [weakSelf handlePan];
        weakSelf.page = 1;
        weakSelf.keyStr = @"";
        weakSelf.searchBar.text = nil;
        //调用请求
       // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [weakSelf GetsupplierListPage:weakSelf.page pagesize:20 keyStr:weakSelf.keyStr start_date:weakSelf.start_date end_date:weakSelf.end_date state1:weakSelf.state1 sv_enable:weakSelf.sv_enable sv_suid:weakSelf.sv_suid];
    };
}

- (void)OrderNumberQueryResponseEvent{
    
}

//移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.3 animations:^{
        self.supplierSelectionView.frame = CGRectMake(ScreenW, TopHeight, ScreenW / 6 *5, ScreenH - TopHeight);
    }];
 
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

//- (SVSupplierSelectionView *)

- (SVSupplierSelectionView *)supplierSelectionView{
    if (!_supplierSelectionView) {
        _supplierSelectionView = [[NSBundle mainBundle]loadNibNamed:@"SVSupplierSelectionView" owner:nil options:nil].lastObject;
        _supplierSelectionView.frame = CGRectMake(ScreenW, TopHeight, ScreenW /6 *5, ScreenH - TopHeight);
        _supplierSelectionView.DocumentTypeView.hidden = YES;
        
    }
    return _supplierSelectionView;
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
@end

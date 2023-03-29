//
//  SVInventoryCompletedVC.m
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventoryCompletedVC.h"
#import "SVCompletedCell.h"
#import "SVdraftListModel.h"
#import "SVPandianDetailModel.h"
#import "SVInventoryDetailsVC.h"
#import "SVAddSupplierVC.h"
#import "SVSupplierCell.h"
#import "SVSupplierListModel.h"
static NSString *const completedCellID = @"SVCompletedCell";
static NSString *const supplierCellID = @"SVSupplierCell";
@interface SVInventoryCompletedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *supplierArr;
@property (nonatomic,strong) NSMutableArray *supplierIDArr;
@end

@implementation SVInventoryCompletedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    if (self.selectNumber == 1) {
        self.navigationItem.title = @"选择供应商";
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH -TopHeight-BottomHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        self.view.backgroundColor = BackgroundColor;
        self.tableView.backgroundColor = BackgroundColor;
        [self.tableView registerNib:[UINib nibWithNibName:@"SVSupplierCell" bundle:nil] forCellReuseIdentifier:supplierCellID];
        [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self setupRefresh];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"新增供应商" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
        // self.navigationItem.rightBarButtonItem = [UIBarButtonItem]
        
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 60 - TopHeight-BottomHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        self.view.backgroundColor = BackgroundColor;
        self.tableView.backgroundColor = BackgroundColor;
        [self.tableView registerNib:[UINib nibWithNibName:@"SVCompletedCell" bundle:nil] forCellReuseIdentifier:completedCellID];
        [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self setupRefresh];
        //注册通知(接收,监听,一个通知)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1) name:@"notifyName1" object:nil];
    }
    
    
}

- (void)selectbuttonResponseEvent{
    SVAddSupplierVC *VC = [[SVAddSupplierVC alloc] init];
    VC.supplierBool = YES;
    __weak typeof(self) weakSelf = self;
    VC.supplierBlock = ^(){
        weakSelf.page = 1;
        // [weakSelf requestDataIndex:1 pageSize:20 suid:0 name:weakSelf.keyStr];
        [self setupRefresh];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notifyName1" object:nil];
}

//实现方法
-(void)notification1{
    [self setupRefresh];
}

//刷新
-(void)setupRefresh{
    
    if (self.selectNumber == 1) {
        self.page = 1;
        [SVTool IndeterminateButtonAction:self.view withSing:nil];
        [self requestDataIndex:self.page pageSize:10 suid:0 name:@""];
        
        /**
         下拉刷新
         */
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            self.page = 1;
            //调用请求
            //  [self getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
            // [self loadDataCheckstatus:2 Page:self.page pageSize:10];
            [self requestDataIndex:self.page pageSize:10 suid:0 name:@""];
        }];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 设置文字
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
        [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        header.stateLabel.textColor = [UIColor grayColor];
        // 设置正在刷新状态的动画图片
        [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
        self.tableView.mj_header = header;
        
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            self.page ++;
            //调用请求
            //        [self getDataPage:[NSString stringWithFormat:@"%ld",(long)self.page] top:@"20" seachStr:@"" couponState:@"-1"];
            //        [self loadDataPage:self.page pageSize:10];
            //  [self loadDataCheckstatus:2 Page:self.page pageSize:10];
            [self requestDataIndex:self.page pageSize:10 suid:0 name:@""];
        }];
        // 设置文字
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor grayColor];
        // 设置正在刷新状态的动画图片
        [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
        
        self.tableView.mj_footer.hidden = YES;
        
        self.tableView.mj_footer = footer;
    }else{
        self.page = 1;
        [SVTool IndeterminateButtonAction:self.view withSing:nil];
        //  [self loadDataCheckstatus:2 Page:self.page pageSize:10];
        [self loadDataCheckstatus:1 day:3 Page:self.page pageSize:10];
        /**
         下拉刷新
         */
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            self.page = 1;
            //调用请求
            //  [self getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
            // [self loadDataCheckstatus:2 Page:self.page pageSize:10];
            [self loadDataCheckstatus:1 day:3 Page:self.page pageSize:10];
        }];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 设置文字
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
        [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        header.stateLabel.textColor = [UIColor grayColor];
        // 设置正在刷新状态的动画图片
        [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
        self.tableView.mj_header = header;
        
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            self.page ++;
            //调用请求
            //        [self getDataPage:[NSString stringWithFormat:@"%ld",(long)self.page] top:@"20" seachStr:@"" couponState:@"-1"];
            //        [self loadDataPage:self.page pageSize:10];
            //  [self loadDataCheckstatus:2 Page:self.page pageSize:10];
            [self loadDataCheckstatus:1 day:3 Page:self.page pageSize:10];
        }];
        // 设置文字
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor grayColor];
        // 设置正在刷新状态的动画图片
        [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
        
        self.tableView.mj_footer.hidden = YES;
        
        self.tableView.mj_footer = footer;
    }
    
}


# pragma mark - 请求数据
/**
 请求供应商
 @param pageIndex 页码
 @param pageSize 分页大小
 @param suid 0表示查询供应商列表，传入具体的供应商Id可查询单个供应商信息
 @param name 搜索关键字
 */
-(void)requestDataIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize suid:(NSInteger)suid name:(NSString *)name{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/GetSupplierPageList?key=%@&keywards=%@&suid=%ld&page=%ld&pagesize=%ld",token,name,(long)suid,(long)pageIndex,(long)pageSize];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *listDic = dic[@"values"];
        
        NSArray *dataList = listDic[@"dataList"];
        
        if (self.page == 1) {
            [self.supplierArr removeAllObjects];
        }
        
        if (![SVTool isEmpty:dataList]) {
            
            for (NSDictionary *dict in dataList) {
                //字典转模型
                SVSupplierListModel *model = [SVSupplierListModel mj_objectWithKeyValues:dict];
                
                [self.supplierArr addObject:model];
                
                //  [self.supplierIDArr addObject:dict[@"sv_suid"]];
                
            }
            
            //            [self.oneButton setTitle:self.supplierArr[0] forState:UIControlStateNormal];
            //            self.supplierID = [NSString stringWithFormat:@"%@",self.supplierIDArr[0]];
            
        } else {
            
            // [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
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



- (void)loadDataCheckstatus:(NSInteger)checkstatus day:(NSInteger)day Page:(NSInteger)page pageSize:(NSInteger)pageSize{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/GetAllStoreStockCheckRecordInfo?key=%@&checkstatus=%li&day=%li&page=%li&pageSize=%li&getdetail=true&getcheckdetailstate=true",[SVUserManager shareInstance].access_token,checkstatus,day,page,pageSize];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic已完成 = %@",dic);
        NSLog(@"urlStr = %@",urlStr);
        if (self.page == 1) {
            [self.modelArr removeAllObjects];
        }
        if ([dic[@"succeed"] intValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = dic[@"values"];
            if (!kDictIsEmpty(dict)) {
                //                for (NSDictionary *dict in dic[@"values"]) {
                //                    SVCouponListModel *model = [SVCouponListModel mj_objectWithKeyValues:dict];
                //                    [self.modelArr addObject:model];
                //                }
                NSArray *array=dic[@"values"][@"dataList"];
                if (!kArrayIsEmpty(array)) {
                    //self.modelArr = [SVdraftListModel mj_objectArrayWithKeyValuesArray:array];
                    NSArray *arr = [SVdraftListModel mj_objectArrayWithKeyValuesArray:array];
                    [self.modelArr addObjectsFromArray:arr];
                    
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }else {
                    
                    /** 所有数据加载完毕，没有更多的数据了 */
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    //                //提示没有供应商
                    //                if (self.modelArr.count == 0) {
                    //                    self.noLabel.hidden = NO;
                    //                }
                    
                }
                
                //                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                //                    /** 普通闲置状态 */
                //                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                //                }
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
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


////头部的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//    return 0;
//
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectNumber == 1) {
        return self.supplierArr.count;
    }else{
        return self.modelArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.selectNumber == 1) {
        SVSupplierCell *cell = [tableView dequeueReusableCellWithIdentifier:supplierCellID];
        if (!cell) {
            cell = [[SVSupplierCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:supplierCellID];
        }
        
        cell.model = self.supplierArr[indexPath.row];
        
        return cell;
    }else{
        SVCompletedCell *cell = [tableView dequeueReusableCellWithIdentifier:completedCellID];
        if (!cell) {
            cell = [[SVCompletedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completedCellID];
        }
        
        cell.model = self.modelArr[indexPath.row];
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.selectNumber == 1) {
        if (self.selectSuplierBlock) {
            self.selectSuplierBlock(self.supplierArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        SVInventoryDetailsVC *inventoryDetailVc = [[SVInventoryDetailsVC alloc] init];
        inventoryDetailVc.selectNum = 1;
        inventoryDetailVc.model = self.modelArr[indexPath.row];
        [self.navigationController pushViewController:inventoryDetailVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)supplierArr {
    if (!_supplierArr) {
        _supplierArr = [NSMutableArray array];
    }
    return _supplierArr;
}

-(NSMutableArray *)supplierIDArr {
    if (!_supplierIDArr) {
        _supplierIDArr = [NSMutableArray array];
    }
    return _supplierIDArr;
}
@end

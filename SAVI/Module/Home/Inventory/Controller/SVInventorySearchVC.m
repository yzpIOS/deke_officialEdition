//
//  SVInventorySearchVC.m
//  SAVI
//
//  Created by houming Wang on 2019/6/5.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventorySearchVC.h"
#import "SVnewDraftCell.h"
#import "SVdraftListModel.h"
#import "SVInventoryDetailsVC.h"
static NSString *const newDraftCellID = @"SVnewDraftCell";
@interface SVInventorySearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *modelArr;
@end

@implementation SVInventorySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenW /4 *3, 50)];
//    UIView *view = [[UIView alloc] init];
//    [view addSubview:text];
//    self.navigationItem.titleView = view;
    

}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;

    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//     self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-BottomHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVnewDraftCell" bundle:nil] forCellReuseIdentifier:newDraftCellID];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [self setupRefresh];
}

//刷新
-(void)setupRefresh{
    
    
    self.page = 1;
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    //  [self loadDataCheckstatus:2 Page:self.page pageSize:10];
   // [self loadDataCheckstatus:2 day:3 Page:self.page pageSize:10];
    [self loadDataDay:4 Page:self.page pageSize:10 keywards:self.searchText];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.page = 1;
        //调用请求
        //  [self getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
        // [self loadDataCheckstatus:2 Page:self.page pageSize:10];
        [self loadDataDay:4 Page:self.page pageSize:10 keywards:self.searchText];
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
        [self loadDataDay:3 Page:self.page pageSize:10 keywards:self.searchText];
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


- (void)loadDataDay:(NSInteger)day Page:(NSInteger)page pageSize:(NSInteger)pageSize keywards:(NSString *)keywards{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/GetAllStoreStockCheckRecordInfo?key=%@&day=%li&page=%li&pageSize=%li&keywards=%@&getdetail=true",[SVUserManager shareInstance].access_token,day,page,pageSize,keywards];
    NSString *utf = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic草稿 = %@",dic);
        NSLog(@"urlStr = %@",utf);
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
                    NSArray *arr= [SVdraftListModel mj_objectArrayWithKeyValuesArray:array];
                    [self.modelArr addObjectsFromArray:arr];
                }
                
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
            } else {
                
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                //                //提示没有供应商
                //                if (self.modelArr.count == 0) {
                //                    self.noLabel.hidden = NO;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVnewDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:newDraftCellID];
    if (!cell) {
        cell = [[SVnewDraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newDraftCellID];
    }
    cell.model = self.modelArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVInventoryDetailsVC *inventoryDetailVc = [[SVInventoryDetailsVC alloc] init];
    inventoryDetailVc.selectNum = 5;
    inventoryDetailVc.model = self.modelArr[indexPath.row];
    __weak __typeof(self) weakSelf = self;
    inventoryDetailVc.successBlock = ^{
        [weakSelf setupRefresh];
    };
    
    [self.navigationController pushViewController:inventoryDetailVc animated:YES];
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


@end

//
//  SVWarehouseListVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/22.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWarehouseListVC.h"
//添加仓库
#import "SVaddWarehouseVC.h"
//仓库详情
#import "SVWarehouseDetailsVC.h"
//model
#import "SVWarehouseModel.h"



static NSString *WarehouseCellID = @"WarehouseCell";
@interface SVWarehouseListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
//搜索的关键词
@property (nonatomic,strong) NSString *keyStr;

@property (nonatomic,strong) NSMutableArray *modelArr;

//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableDictionary *dicCell;

@end

@implementation SVWarehouseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"仓库管理";
    
    //添加搜索栏
    [self addSearchBar];
    
//    //正确创建方式，这样显示的图片就没有问题了
//    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addWarehouseResponseEvent)];
//    self.navigationItem.rightBarButtonItem = rightButon;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH-64-50)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //取消tableView的选中
    //tableView.allowsSelection = NO;
    //滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
    //普通cell的注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:WarehouseCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    self.page = 1;
    [self requestDatapageIndex:1 pageSize:20 searchCriteria:@""];
    
    [self setupRefresh];
    
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addWarehouseResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
}

//添加响应方法
-(void)addWarehouseResponseEvent {
    
    SVaddWarehouseVC *VC = [[SVaddWarehouseVC alloc]init];
    VC.sv_warehouse_id = @"0";
    __weak typeof(self) weakSelf = self;
    VC.addWarehouseBlock = ^{
        weakSelf.page = 1;
        [weakSelf requestDatapageIndex:1 pageSize:20 searchCriteria:@""];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.searchBar.placeholder = @"请输入仓库名称,编码";
    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    self.searchBar.delegate = self;
    
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;
    //为UISearchBar添加背景图片
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    //一下代码为修改placeholder字体的颜色和大小

   // UITextField *searchField = [_searchBar valueForKey:@"_searchField"];  UITextField * UITextField *searchField = _searchBar.searchTextField;
      // 输入文本颜色
//    UITextField *searchField = self.searchBar.searchTextField;
//      searchField.textColor = GlobalFontColor;
//      searchField.font = [UIFont systemFontOfSize:15];
//      // 默认文本大小
//  //    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//      searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入仓库名称,编码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//     // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//      //只有编辑时出现出现那个叉叉
//      searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
//      //添加到view中
//      searchField.backgroundColor = [UIColor whiteColor];
    
    UITextField * searchField;
       if (@available(iOS 13.0, *)) {
           searchField = _searchBar.searchTextField;
             // 输入文本颜色
               searchField.textColor = GlobalFontColor;
           //    searchField.font = [UIFont systemFontOfSize:15];
               
               // 默认文本大小
              // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
               
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入仓库名称,编码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
       }else{
         
         searchField = [_searchBar valueForKey:@"_searchField"];
            // 输入文本颜色
            searchField.textColor = GlobalFontColor;
           // searchField.font = [UIFont systemFontOfSize:15];
            // 默认文本大小
            [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
          // searchField.placeholder = @"请输入仓库名称,编码";
            //只有编辑时出现那个叉叉
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
       }
     
       
      // searchField.attributedPlaceholder =
       
       //只有编辑时出现那个叉叉
       searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
       searchField.backgroundColor = [UIColor whiteColor];
       searchField.font = [UIFont systemFontOfSize:13];

    //添加到view中
    [self.view addSubview:self.searchBar];
    
    
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
    [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr];
    
    [searchBar resignFirstResponder];
    
}

//退出键盘响应方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
}

//刷新
-(void)setupRefresh{
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.keyStr = @"";
        self.searchBar.text = nil;
        //调用请求
        [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr];
        
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
        [self requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr];
        
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

#pragma mark - 请求数据
/**
 请求仓库数据
 @param pageIndex 页数
 @param pageSize 每页几个
 @param searchCriteria 搜索关键词
 */
-(void)requestDatapageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchCriteria:(NSString *)searchCriteria {
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/GetWarehouselist?key=%@&pageIndex=%ld&pageSize=%ld&SearchCriteria=%@",token,pageIndex,pageSize,searchCriteria];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if (self.page == 1) {
            [self.modelArr removeAllObjects];
        }
        
        if ([dic[@"succeed"] integerValue] == 1) {
            NSArray *warehouseList = dic[@"values"];
            
            if (![SVTool isEmpty:warehouseList])
            {
                
                for (NSDictionary *dict in warehouseList) {
                    //字典转模型
                    SVWarehouseModel *model = [SVWarehouseModel mj_objectWithKeyValues:dict];
                    
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"仓库数据请求失败"];
        }
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //普通cell的创建
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WarehouseCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WarehouseCellID];
    }
    
    SVWarehouseModel *model = self.modelArr[indexPath.row];
    
    cell.textLabel.text = model.sv_warehouse_name;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = GlobalFontColor;
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SVWarehouseDetailsVC *VC = [[SVWarehouseDetailsVC alloc]init];
    VC.model  = self.modelArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    VC.warehouseDetailsBlock = ^{
        weakSelf.page = 1;
        [weakSelf requestDatapageIndex:1 pageSize:20 searchCriteria:@""];
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end

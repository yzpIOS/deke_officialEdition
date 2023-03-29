//
//  SVSuppliersListVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/25.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSuppliersListVC.h"
//UICollectionViewCell
#import "SVHomeViewCell.h"
//UITableViewCell
#import "SVSuppliersListCell.h"
//model
#import "SVSupplierListModel.h"
//新增供应商
#import "SVAddSupplierVC.h"
//供应商详情
#import "SVSupplierDetailsVC.h"
//采购列表
#import "SVProcurementListVC.h"
//退货
#import "SVRefundGoodsVC.h"
//仓库调拨
#import "SVTransfersListVC.h"
//仓库管理
#import "SVWarehouseListVC.h"

static NSString *SuppliersCellID = @"SupplierCell";
static NSString *collectionVID = @"collectionVCell";
@interface SVSuppliersListVC () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
//搜索的关键词
@property (nonatomic,strong) NSString *keyStr;

//title数组
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *titleImg;

@property (nonatomic,strong) UITableView *tableView;
//模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;
//此时段没有供应商记录
@property (nonatomic,strong) UILabel *noLabel;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UILabel *labelB;


@end

@implementation SVSuppliersListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"供应商";
    
    //显示tabBar
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = BlueBackgroundColor;
    

    //    self.titleArr = @[@"采购进货",@"采购退货",@"库存调拨",@"仓库管理",];
    //    self.titleImg = @[@"ic_oneButton",@"ic_twoButton",@"ic_threeButton",@"ic_fourbutton",];
    self.titleArr = @[@"进货管理",@"采购退货",@"仓库管理"];
    self.titleImg = @[@"ic_oneButton",@"ic_twoButton",@"ic_fourbutton"];

//    self.titleArr = @[@"采购进货",@"采购退货",@"库存调拨",@"仓库管理",];
//    self.titleImg = @[@"ic_oneButton",@"ic_twoButton",@"ic_threeButton",@"ic_fourbutton",];
//    self.titleArr = @[@"进货管理",@"采购退货",@"仓库管理"];
//    self.titleImg = @[@"ic_oneButton",@"ic_twoButton",@"ic_fourbutton"];

    
    //正确创建方式，这样显示的图片就没有问题了
    //    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addSuppliersResponseEvent)];
    //    self.navigationItem.rightBarButtonItem = rightButon;
    
    [self addSearchBar];
   // [self addCollectionView];
    [self addTabelView];
    
    self.noLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.noLabel.hidden = YES;
    self.noLabel.text = @"没有供应商记录";
    self.noLabel.textColor = [UIColor grayColor];
    self.noLabel.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/3);
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.noLabel];
    
    self.page = 1;
    self.keyStr = @"";
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [self requestDataIndex:1 pageSize:20 suid:0 name:@""];
    
    //底部按钮
    //    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/5*4, ScreenH/5*4, 45, 45)];
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addSuppliersResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1) name:@"notifyAddShop" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notifyAddShop" object:nil];
}

- (void)notification1{
    self.page = 1;
    //  weakSelf.page = 1;
    [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
}

//添加响应方法
-(void)addSuppliersResponseEvent {
    
    SVAddSupplierVC *VC = [[SVAddSupplierVC alloc]init];
    VC.supplierBool = YES;
    __weak typeof(self) weakSelf = self;
    VC.supplierBlock = ^(){
        weakSelf.page = 1;
        [weakSelf requestDataIndex:1 pageSize:20 suid:0 name:weakSelf.keyStr];
    };
    //跳转界面有导航栏的
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.searchBar.placeholder = @"请输入供应商、联系人、电话";
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

  //  UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    UITextField * searchField;
       if (@available(iOS 13.0, *)) {
           searchField = _searchBar.searchTextField;
             // 输入文本颜色
               searchField.textColor = GlobalFontColor;
           //    searchField.font = [UIFont systemFontOfSize:15];
               
               // 默认文本大小
              // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
               
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入供应商、联系人、电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
       }else{
        // [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
         searchField = [_searchBar valueForKey:@"_searchField"];
            // 输入文本颜色
            searchField.textColor = GlobalFontColor;
           // searchField.font = [UIFont systemFontOfSize:15];
            // 默认文本大小
            [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
          // searchField.placeholder = @"请输入供应商、联系人、电话";
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
    [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
    
    [searchBar resignFirstResponder];
    
}

//退出键盘响应方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
}

//
-(void)addCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置垂直间距
    layout.minimumLineSpacing = 0;
    //设置水平间距
    layout.minimumInteritemSpacing = 0;
    //初始化collectionview,并作设置
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 70) collectionViewLayout:layout];
    collectionV.showsVerticalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor whiteColor];
    //指定collectionview代理
    collectionV.delegate = self;
    collectionV.dataSource = self;
    //注册collectionView的cell
    [collectionV registerNib:[UINib nibWithNibName:@"SVHomeViewCell" bundle:nil] forCellWithReuseIdentifier:collectionVID];
    
    [self.view addSubview:collectionV];
    
}

-(void)addTabelView {
    UIView *labelV = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, 30)];
    labelV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelV];
    UILabel *labelA = [[UILabel alloc]init];
    labelA.text = @"共有";
    labelA.textColor = GreyFontColor;
    labelA.font = [UIFont systemFontOfSize:13];
    [labelV addSubview:labelA];
    [labelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labelV.mas_centerY);
        make.left.mas_equalTo(labelV).offset(20);
    }];
    self.labelB = [[UILabel alloc]init];
    self.labelB.textColor = RedFontColor;
    self.labelB.font = [UIFont systemFontOfSize:15];
    [labelV addSubview:self.labelB];
    [self.labelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labelV.mas_centerY);
        make.left.mas_equalTo(labelA.mas_right);
    }];
    UILabel *labelC = [[UILabel alloc]init];
    labelC.text = @"家供应商";
    labelC.textColor = GreyFontColor;
    labelC.font = [UIFont systemFontOfSize:13];
    [labelV addSubview:labelC];
    [labelC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labelV.mas_centerY);
        make.left.mas_equalTo(self.labelB.mas_right);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 81, ScreenW, ScreenH-64-81)];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSuppliersListCell" bundle:nil] forCellReuseIdentifier:SuppliersCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
    
}

//刷新
-(void)setupRefresh{
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.keyStr = @"";
        self.searchBar.text = nil;
        //调用请求
        [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        
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
        [self requestDataIndex:self.page pageSize:20 suid:0 name:self.keyStr];
        
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

# pragma mark - 请求数据
/**
 请求数据
 
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
        
        //有多少位供应高
        self.labelB.text = [NSString stringWithFormat:@"%@",listDic[@"total"]];
        
        NSArray *dataList = listDic[@"dataList"];
        
        //判断如果为1时，清理模型数组
        if (self.page == 1) {
            
            [self.modelArr removeAllObjects];
            
        }
        
        if (![SVTool isEmpty:dataList]) {
            
            self.noLabel.hidden = YES;
            
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
            if (self.modelArr.count == 0) {
                self.noLabel.hidden = NO;
            }
            
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
//
//#pragma mark - UICollectionViewDataSource
////定义展示的UICollectionViewCell的个数
//-( NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
//    return self.titleArr.count;
//}
//
////定义展示的Section的个数
//-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
//    return 1 ;
//}
//
////每个UICollectionView展示的内容
//-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
//    SVHomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionVID forIndexPath:indexPath];
//    cell.titleLabel.text = self.titleArr[indexPath.item];
//    //cell.img.image = self.titleImg[indexPath.item];
//    cell.img.image = [UIImage imageNamed:self.titleImg[indexPath.item]];
//
//    //cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
//
//    return cell;
//
//}
//
//#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
//- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
//    //    return CGSizeMake (80,80);
//    return CGSizeMake(ScreenW/3, 70);
//}
//
////定义每个UICollectionView 的边距
//-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
//    return UIEdgeInsetsMake (0,0,0,0);
//}
//
//
//#pragma mark - 点击跳转方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    //设置(Highlight)高亮下的颜色
//    if (cell.isSelected) {
//        cell.backgroundColor = clickButtonBackgroundColor;
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            cell.backgroundColor = [UIColor whiteColor];
//        });
//    }
//
//    if (indexPath.row == 0) {
//        SVProcurementListVC *VC = [[SVProcurementListVC alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }
//    if (indexPath.row == 1) {
//        SVRefundGoodsVC *VC = [[SVRefundGoodsVC alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }
//    //if (indexPath.row == 2) {
//    //    SVTransfersListVC *VC = [[SVTransfersListVC alloc]init];
//    //    [self.navigationController pushViewController:VC animated:YES];
//    //}
//    if (indexPath.row == 2) {
//        SVWarehouseListVC *VC = [[SVWarehouseListVC alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }
//
//}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib的cell的创建
    SVSuppliersListCell *cell = [tableView dequeueReusableCellWithIdentifier:SuppliersCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVSuppliersListCell" owner:nil options:nil].lastObject;
    }
    cell.model = self.modelArr[indexPath.row];
    
    
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
    
    SVSupplierListModel *model = self.modelArr[indexPath.row];
    
    SVSupplierDetailsVC *VC = [[SVSupplierDetailsVC alloc]init];
    VC.sv_suname = model.sv_suname;
    VC.sv_sulinkmnm = model.sv_sulinkmnm;
    VC.sv_sumoble = model.sv_sumoble;
    VC.sv_suaddtime = model.sv_suaddtime;
    VC.sv_subeizhu = model.sv_subeizhu;
    VC.sv_suid = model.sv_suid;
    VC.sv_suqq = model.sv_suqq;
    VC.sv_suadress = model.sv_suadress;
    VC.arrear = model.arrears;
    
    __weak typeof(self) weakSelf = self;
    VC.supplierDetailsBlock = ^{
        weakSelf.page = 1;
        [weakSelf requestDataIndex:1 pageSize:20 suid:0 name:weakSelf.keyStr];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TRUE;
    
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVSupplierListModel *model = self.modelArr[indexPath.row];
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row<[self.modelArr count]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:model.sv_suid forKey:@"sv_suid"];
                [parameters setObject:@"true" forKey:@"sv_is_deleted"];
                
                [SVUserManager loadUserInfo];
                NSString *token = [SVUserManager shareInstance].access_token;
                //url
                NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/AUDSupplier?key=%@",token];
                [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    if ([dic[@"succeed"] integerValue] == 1) {
                        //移除数据源的数据
                        [self.modelArr removeObjectAtIndex:indexPath.row];
                        //移除tableView中的数据
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        [self.tableView reloadData];
                    } else {
                        NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                        [SVTool TextButtonAction:self.view withSing:errmsg];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                }];
            }];
            [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
            [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
            
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定要删除吗？"];
            //设置文本颜色
            [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 7)];
            //设置文本字体大小
            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
            [alert setValue:hogan forKey:@"attributedTitle"];
            
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}


@end

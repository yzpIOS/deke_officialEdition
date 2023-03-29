//
//  SVWarehouseWaresVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/23.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWarehouseWaresVC.h"
//商品详情
#import "SVWaresDetailsVC.h"
//筛选商品
#import "SVWaresScreeningVC.h"
//自定义cell
#import "SVWaresListVCell.h"
//模型
#import "SVWaresListModel.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"


static NSString *WaresListVCellID = @"WaresListVCell";

@interface SVWarehouseWaresVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *qrcode;

/**
 模型数组
 */
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,assign)  NSInteger productsubcategory_id;

//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL sao;


@property (nonatomic,strong) UIImageView *img;


@end

@implementation SVWarehouseWaresVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航标题
    self.navigationItem.title = @"仓库商品";

    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;

    self.productsubcategory_id = 0;
    //界面布局
    [self setupController];
    //刷新
    [self setupRefresh];

    self.hidesBottomBarWhenPushed = YES;
    
    
    
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear: animated];
//
//    if ([SVTool isEmpty:[NSString stringWithFormat:@"%ld",(long)self.productsubcategory_id]]) {
//
//        [self getDataPageIndex:1 pageSize:10 category:self.productsubcategory_id name:@""];
//    }
//}


/**
 布局界面
 */
-(void)setupController{

    //添加搜索栏
    [self addSearchBar];

    //去掉滚动条
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH-114)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];

    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVWaresListVCell" bundle:nil] forCellReuseIdentifier:WaresListVCellID];

    //添加右侧按钮
    UIButton *pulishButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [pulishButton setImage:[UIImage imageNamed:@"screening_icon"] forState:UIControlStateNormal];
    [pulishButton addTarget:self action:@selector(buttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];

    UIButton *saveButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [saveButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];

    pulishButton.frame = CGRectMake(0, 0, 20, 20);
    saveButton.frame=CGRectMake(0, 0, 20, 20);

    UIBarButtonItem *pulish = [[UIBarButtonItem alloc] initWithCustomView:pulishButton];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:saveButton];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: pulish, save,nil]];

    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    //调用请求方法
    [self getDataPageIndex:self.page pageSize:20 category:0 name:@""];

}

-(void)releaseInfo{

    SVNewWaresVC *VC = [[SVNewWaresVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}

//右侧按钮响应事件
-(void)buttonResponseEvent{
    //跳转会员详情界面
    //self.hidesBottomBarWhenPushed = YES;
    SVWaresScreeningVC *VC = [[SVWaresScreeningVC alloc]init];

    //对象有一个Block属性，然而这个Block属性中又引用了对象的其他成员变量，那么就会对这个变量本身产生强引用，那么变量本身和他自己的Block属性就形成了循环引用。因此我们需要对其进行处理进行弱引用。
    __weak typeof(self) weakSelf = self;

    [VC setProductsubcategory_idBlock:^(NSInteger productsubcategory_id){
        weakSelf.productsubcategory_id = productsubcategory_id;

        weakSelf.searchBar.text = nil;
        //调用请求数据接口
        weakSelf.page = 1;
        weakSelf.sao = NO;

        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:productsubcategory_id name:@""];
        //进入刷新状态
        //[self.tableView.mj_footer beginRefreshing];

    }];


    [self.navigationController pushViewController:VC animated:YES];
    //self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.searchBar.placeholder = @"请输入商品名称,款号";
    }else{
        
        self.searchBar.placeholder = @"请输入商品名称,条码";
    }
    
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
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    // 输入文本颜色
    searchField.textColor = GlobalFontColor;
    searchField.font = [UIFont systemFontOfSize:15];
    // 默认文本大小
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    //只有编辑时出现出现那个叉叉
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //添加到view中
    [self.view addSubview:self.searchBar];

    //扫一扫按钮
    self.qrcode=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.qrcode setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:self.qrcode];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(self.searchBar.mas_right).offset(-10);
    }];

}

#pragma mark - UISearchBarDelegate代理方法
//点击搜索栏中的textFiled触发
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.qrcode.hidden = YES;
}

//当用停止编辑时，会调这个方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    self.qrcode.hidden = NO;

}

//输入内容就会触发
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//}

//当输入框内容发生变化时，就会触发，能够及时获取到输入框最新的内容
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""]) {
        self.qrcode.hidden = YES;
    }

    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.qrcode.hidden = NO;
    }
    return YES;
}

//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    self.sao = YES;

    //设置为显示
    self.qrcode.hidden = NO;

    NSString *Str = searchBar.text;

    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    //调用请求
    self.page = 1;
    [self getDataPageIndex:1 pageSize:20 category:0 name:keyStr];

    [searchBar resignFirstResponder];

}

/**
 退出键盘响应方法
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //移除第一响应者
    [self.searchBar resignFirstResponder];

    //退出设置为显示
    self.qrcode.hidden = NO;

}

#pragma mark - 跳转到扫一扫
-(void)scanButtonResponseEvent{

//    self.hidesBottomBarWhenPushed = YES;
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        self.sao = YES;
//
//        weakSelf.page = 1;
//
//        //        weakSelf.oneCell.barcode.text = name;
//        weakSelf.searchBar.text = name;
//
//        //调用请求
//        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:name];
//
//    };

  

    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        
        self.sao = YES;

        weakSelf.page = 1;

        //        weakSelf.oneCell.barcode.text = name;
        weakSelf.searchBar.text = resultStr;

        //调用请求
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:resultStr];

    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 刷新
 */
-(void)setupRefresh{
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{

        self.page = 1;
        self.searchBar.text = nil;
        self.productsubcategory_id = 0;
        //调用请求
        [self getDataPageIndex:1 pageSize:20 category:self.productsubcategory_id name:self.searchBar.text];

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
    header.stateLabel.textColor = [UIColor redColor];
    //header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];

    self.tableView.mj_header = header;

    /**
     上拉刷新
     */
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{

        self.page ++;
        self.sao = NO;
        //调用请求
        [self getDataPageIndex:self.page pageSize:20 category:self.productsubcategory_id name:self.searchBar.text];

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

    self.tableView.mj_footer = footer;
}

#pragma mark - tableVeiw
//展示几组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 定义唯一标识
//    static NSString *CellIdentifier = @"Cell";

    SVWaresListVCell *cell = [tableView dequeueReusableCellWithIdentifier:WaresListVCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVWaresListVCell" owner:nil options:nil].lastObject;
    }
    //转好的模型数组赋值给cell
    cell.model = self.modelArr[indexPath.row];

//    if (![self.imageArr[indexPath.row] isKindOfClass:[NSNull class]]) {
//        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imageArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//    }
//    cell.waresName.text = self.waresNameArr[indexPath.row];
//    cell.money.text = [NSString stringWithFormat:@"%@",self.moneyArr[indexPath.row]];
//    cell.inventory.text = [NSString stringWithFormat:@"%@",self.inventoryArr[indexPath.row]];

    return cell;

}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //跳转会员详情界面
    SVWaresListModel *model = self.modelArr[indexPath.row];
    //self.hidesBottomBarWhenPushed = YES;
    SVWaresDetailsVC *VC = [[SVWaresDetailsVC alloc]init];
    VC.productID = model.product_id;

    __weak typeof(self) weakSelf = self;
    VC.WaresDetailsBlock = ^(){
        weakSelf.page = 1;
        //调用请求方法
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:@""];
    };
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = YES;

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


    SVWaresListModel *model = self.modelArr[indexPath.row];
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (indexPath.row<[self.modelArr count]) {

            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            NSString *userID = [defaults objectForKey:@"user_id"];
            //            NSString *token = [defaults objectForKey:@"access_token"];

            [SVUserManager loadUserInfo];
//            NSString *userID = [SVUserManager shareInstance].user_id;
            NSString *token = [SVUserManager shareInstance].access_token;
//            NSString *sv_mr_modifier = @"0";

            //url
            NSString *strURL = [URLhead stringByAppendingFormat:@"/product?key=%@&ids=%@",token,model.product_id];

            [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

        }

    }

}

#pragma mark - 获取产品列表

- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category name:(NSString *)name {
    //URL
    //    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],pageIndex,pageSize,category,name];

    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,name];

    //请求数据
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        NSDictionary *valuesDic = dic[@"values"];

        NSArray *listArr = valuesDic[@"list"];

        //默认隐藏
        self.img.hidden = YES;

        //判断如果为1时，清理模型数组
        if (self.page == 1) {

            [self.modelArr removeAllObjects];

        }

        //判断数组是否请求完了
        if (![SVTool isEmpty:listArr]) {

            for (NSDictionary *dict in listArr) {

                //字典转模型
                SVWaresListModel *model = [SVWaresListModel mj_objectWithKeyValues:dict];

                [self.modelArr addObject:model];
            }

            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                /** 普通闲置状态 */
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }

        } else {
            /** 所有数据加载完毕，没有更多的数据了 */
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;

            //提示分类没有商品
            if (self.modelArr.count == 0 && self.sao == NO) {
                self.img.hidden = NO;
            }

            //扫一扫提示返回空结果
            if (self.modelArr.count == 0 && self.sao == YES) {
                self.sao = NO;
                [SVTool TextButtonAction:self.view withSing:@"抱歉!没有此商品"];
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
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 懒加载

//模型数组
- (NSMutableArray *)modelArr {

    if (!_modelArr) {

        _modelArr = [NSMutableArray array];

    }
    return _modelArr;
}

-(UIImageView *)img{
    if (!_img) {

        CGFloat imgWidth = 122.5;

        CGFloat imgHeight = 132.5;

        CGFloat imgX = (self.tableView.frame.size.width - imgWidth) / 2;

        CGFloat imgY = (self.tableView.frame.size.height - imgHeight) / 2;

        _img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWidth, imgHeight)];

        _img.image = [UIImage imageNamed:@"noWares"];

        _img.hidden = NO;

        [self.tableView addSubview:_img];
    }
    return _img;
}

@end

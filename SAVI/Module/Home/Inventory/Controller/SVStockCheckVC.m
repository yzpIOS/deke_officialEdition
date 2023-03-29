//
//  SVStockCheckVC.m
//  SAVI
//
//  Created by Sorgle on 2017/10/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVStockCheckVC.h"
//cell
#import "SVStockCheckCell.h"
//footerButton
#import "SVCheckFooterButton.h"
//模型
#import "SVCheckGoodsModel.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"

static NSString *StockCheckOneID = @"StockCheckOneCell";
static NSString *StockCheckTwoID = @"StockCheckTwoCell";

@interface SVStockCheckVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *qrcode;

//footerButton
@property (nonatomic,strong) SVCheckFooterButton *checkFooterButton;
//提示此分类没有商品
@property (nonatomic,strong) UIImageView *img;
//提示搜索没有此商品
@property (nonatomic,strong) UILabel *noWares;
@property (strong,nonatomic) UIButton *addButton;
@property (nonatomic,assign) BOOL sao;

//tableView
@property (nonatomic,strong) UITableView *oneTableView;
@property (nonatomic,strong) UITableView *twoTableView;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;

//第一个tableViewcell的数组
@property (nonatomic,strong) NSMutableArray *bigNameArr;
@property (nonatomic,strong) NSMutableArray *bigIDArr;
//商品模型数组
@property (nonatomic,strong) NSMutableArray *goodsModelArr;
//商品ID
@property (nonatomic,strong) NSNumber *productcategory_id;
//记录模型数组的索引
@property (nonatomic, assign) NSInteger tableviewIndex;
//选择好的挂单数组
//@property (nonatomic, strong) NSArray *guaDanArr;

@property (nonatomic,strong) NSMutableArray *goodsArr;



@end

@implementation SVStockCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"库存盘点";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
    //搜索栏
    [self addSearchBar];
    
    //从偏好设置里拿到大分类数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
    
#pragma mark - 添加tableView
    //tabeleView
    self.oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW/6*2, ScreenH-TopHeight-50-50)];
    //设置样式
    self.oneTableView.tableFooterView = [[UIView alloc]init];
    self.oneTableView.showsVerticalScrollIndicator = NO;
    self.oneTableView.backgroundColor = BackgroundColor;
    //改变cell分割线的颜色
    [self.oneTableView setSeparatorColor:[UIColor whiteColor]];
    // 设置距离左右各10的距离
    [self.oneTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //指定代理
    self.oneTableView.delegate = self;
    self.oneTableView.dataSource = self;
    
    self.twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/6*2, 50, ScreenW/6*4, ScreenH-TopHeight-50-50)];
    //设置样式
    self.twoTableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.twoTableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右各10的距离
    [self.twoTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    //指定代理
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    
    [self.view addSubview:self.oneTableView];
    [self.view addSubview:self.twoTableView];
    
    //注册cell
    [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:StockCheckOneID];
    [self.twoTableView registerNib:[UINib nibWithNibName:@"SVStockCheckCell" bundle:nil] forCellReuseIdentifier:StockCheckTwoID];
    
    //添加刷新
    [self setupRefresh];
    
    //footerButton
    self.checkFooterButton = [[NSBundle mainBundle] loadNibNamed:@"SVCheckFooterButton" owner:nil options:nil].lastObject;
    [self.checkFooterButton.inventoryButton addTarget:self action:@selector(inventoryButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkFooterButton];
    //frame
    [self.checkFooterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
#pragma mark - 请求数据
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    //在没有点击的情况下，设置数组索引为0
    self.tableviewIndex = 0;
    //调用数据
    [self getDataPageIndex:1 pageSize:20 category:0 name:@""];
    
    //默认选中第一行
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
#pragma mark - 添加提示
    //默认为YES,则提示此分类没有商品
    self.sao = YES;
    
    //提示没有此商品信息
    self.noWares = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.noWares.hidden = YES;
    self.noWares.text = @"没有此商品信息";
    self.noWares.textColor = [UIColor grayColor];
    self.noWares.center = CGPointMake(self.twoTableView.frame.size.width/2, self.twoTableView.frame.size.height/5 * 2);
    self.noWares.textAlignment = NSTextAlignmentCenter;
    [self.twoTableView addSubview:self.noWares];
    
    //提示该分类下没有商品
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake((self.twoTableView.frame.size.width - 122.5) / 2, (self.twoTableView.frame.size.height - 132.5) / 3, 122.5, 132.5)];
    self.img.image = [UIImage imageNamed:@"noWares"];
    self.img.hidden = YES;
    [self.twoTableView addSubview:self.img];
    
    //添加按钮
    self.addButton = [[UIButton alloc] init];
    self.addButton.hidden = YES;
    self.addButton.layer.cornerRadius = 6;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.addButton setTitle:@"+ 新增商品" forState:UIControlStateNormal];
    //self.addButton.backgroundColor = navigationBackgroundColor;
    [self.addButton setBackgroundColor:navigationBackgroundColor];
    [self.addButton addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.twoTableView addSubview:self.addButton];
    //addButtonFrame
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.centerX.mas_equalTo(self.img.mas_centerX);
        make.top.mas_equalTo(self.img.mas_bottom).offset(20);
    }];
    
}

//MARK:点击返回按钮（你也可以自定义一个返回按钮）
-(BOOL)navigationShouldPopOnBackButton {
    
    if (self.goodsArr.count == 0) {
        //返回上一控制器
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要离开吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //返回上一控制器
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
        
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"未盘点完,确定退出吗?"];
        //设置文本颜色
        [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 11)];
        //设置文本字体大小
        [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 11)];
        [alert setValue:hogan forKey:@"attributedTitle"];
        
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return YES;
}

//添加商品跳转
-(void)addWaresButton{
    
    //设置按钮点击时的背影色
    [self.addButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.addButton setBackgroundColor:navigationBackgroundColor];
        
        SVNewWaresVC *VC = [[SVNewWaresVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    });
}

/**
 刷新
 */
-(void)setupRefresh{
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.sao = YES;
        self.searchBar.text = nil;
        //调用请求
        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        
    }];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.twoTableView.mj_header = header;
    
    
    //上拉刷新
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page = 0;
        
        NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        if (ary_1.count < 20) {
            
            self.page = 2;
            
        } else {
            
            if (ary_1.count % 20 == 0) {
                self.page = (ary_1.count+20) / 20;
            } else {
                self.page = (ary_1.count+20) / 20 + 1;
            }
            
        }
        
        //调用请求
        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        
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
    
    self.twoTableView.mj_footer = footer;
    
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    //设置提示文字
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.searchBar.placeholder = @"请输入商品名称或款号";
    }else{
        
        self.searchBar.placeholder = @"请输入商品名称或条码";
    }
   
    //风格
    self.searchBar.barStyle = UIBarStyleDefault;
    //键盘
    self.searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    //代理
    self.searchBar.delegate = self;
    //为UISearchBar添加背景图片
    //self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    
    //一下代码为修改placeholder字体的颜色和大小
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
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
    self.qrcode = [UIButton buttonWithType:UIButtonTypeCustom];
    //qrcode.frame=CGRectMake(ScreenW-45, 2, 44, 44);
    [self.qrcode setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:self.qrcode];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(self.searchBar.mas_right).offset(-20);
    }];
    
    
}

//跳转扫一扫方法
- (void)scanButtonResponseEvent{
    
    self.page = 1;
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        //设置为NO则，当没有数据时，则提示没有找到此商品
//        weakSelf.sao = NO;
//
//        //提示查询
//        [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"正在查询中…"];
//        //设置数组索引为0
//        self.tableviewIndex = 0;
//        //默认选中第一行
//        self.productcategory_id = 0;
//        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//
//        weakSelf.searchBar.text = name;
//
//        //调用请求
//        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:name];
//
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        
        //设置为NO则，当没有数据时，则提示没有找到此商品
        weakSelf.sao = NO;
        
        //提示查询
        [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"正在查询中…"];
        //设置数组索引为0
        self.tableviewIndex = 0;
        //默认选中第一行
        self.productcategory_id = 0;
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        weakSelf.searchBar.text = resultStr;
        
        //调用请求
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:resultStr];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    //设置为NO则，当没有数据时，则提示没有找到此商品
    self.sao = NO;
    
    //设置为显示
    self.qrcode.hidden = NO;
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //提示查询
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在查询中…"];
    //设置数组索引为0
    self.tableviewIndex = 0;
    //默认选中第一行
    self.productcategory_id = 0;
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    //调用请求
    self.page = 1;
    //调用请求
    [self getDataPageIndex:self.page pageSize:20 category:0 name:keyStr];
    
    //移除第一响应者
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

#pragma mark - 请求数据
/**
 获取产品列表
 
 @param pageIndex 第几页
 @param pageSize 每页有几个
 @param category 只限大分类
 @param name 搜索关键字
 */
- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category name:(NSString *)name {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,name];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *valuesDic = dic[@"values"];
        
        NSArray *listArr = valuesDic[@"list"];
        
        //1判断页数，第一次加载先移除数组元素 在将请求返回的数据添加进去，刷新页数改变直接添加数据到数组中
        if (pageIndex == 1) {
            //删除对应索引下的数据
            [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:@[]];
            
        }
        
        NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
        
        if (![SVTool isEmpty:listArr]) {
            
            //NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
            for (NSDictionary *goodsDic in listArr) {
                //赋值给模型
                SVCheckGoodsModel *goodsModel = [SVCheckGoodsModel mj_objectWithKeyValues:goodsDic];
                goodsModel.product_num = [goodsModel.sv_p_storage integerValue];
                //模型给数组
                [ary_1 addObject:goodsModel];
            }
            //数组给模型数组
            [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
            
            if (ary_1.count >= 20) {
                if (self.twoTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.twoTableView.mj_footer.state = MJRefreshStateIdle;
                }
            }
            
            self.img.hidden = YES;
            self.noWares.hidden = YES;
            self.addButton.hidden = YES;
            
        }else {
            /** 所有数据加载完毕，没有更多的数据了 */
            self.twoTableView.mj_footer.state = MJRefreshStateNoMoreData;
            
            //NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
            if ([SVTool isEmpty:ary_1]) {
                //用判断来显示不同的提示
                if (self.sao == NO) {
                    self.noWares.hidden = NO;
                    self.addButton.hidden = NO;
                    self.img.hidden = YES;
                } else {
                    self.img.hidden = NO;
                    self.addButton.hidden = NO;
                    self.noWares.hidden = YES;
                }
            }
        }
        
        [self.twoTableView reloadData];
        
        //是否正在刷新
        if ([self.twoTableView.mj_header isRefreshing]) {
            //结束刷新状态
            [self.twoTableView.mj_header endRefreshing];
        }
        
        //是否正在刷新
        if ([self.twoTableView.mj_footer isRefreshing]) {
            //结束刷新状态
            [self.twoTableView.mj_footer endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}




#pragma mark - tablevewiDegelate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.oneTableView) {
        
        return 55;
    }else{
        return 80;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.oneTableView) {
        return self.bigNameArr.count;
    }else{
        
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        return ary_1.count;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.oneTableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StockCheckOneID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StockCheckOneID];
        }
        //赋值
        cell.textLabel.text = self.bigNameArr[indexPath.row];
        //设置字体大小
        cell.textLabel.font = [UIFont systemFontOfSize: 13];
        //设置label的行数
        cell.textLabel.numberOfLines = 0;
        //字体中2
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //字体颜色
        cell.textLabel.textColor = GlobalFontColor;
        //背景色
        cell.backgroundColor = BackgroundColor;
        //选中后显示的效果
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil highlightedImage:[UIImage imageNamed:@"leftbackgroup_red"]];
        //选中后字体颜色
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        
        return cell;
        
    } else {
        
        SVStockCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:StockCheckTwoID forIndexPath:indexPath];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"SVStockCheckCell" owner:nil options:nil].lastObject;
        }
        
        //取消高亮
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        if (ary_1.count > indexPath.row) {
            SVCheckGoodsModel *model = [ary_1 objectAtIndex:indexPath.row];
            model.indexPath = indexPath;
            if (self.goodsArr.count == 0) {
                cell.goodsModel = model;
                cell.indexPatch = indexPath;
                cell.checkCellBool = YES;
            } else {
                
                for (NSDictionary *dict in self.goodsArr) {
                    SVCheckGoodsModel *equalModel = [SVCheckGoodsModel mj_objectWithKeyValues:dict];
                    
                    if ([equalModel.product_id isEqualToString:model.product_id]) {
                        
                        cell.goodsModel = equalModel;
                        cell.indexPatch = indexPath;
                        cell.checkCellBool = NO;
                        return cell;
                        
                    } else {
                        
                        cell.goodsModel = model;
                        cell.indexPatch = indexPath;
                        cell.checkCellBool = YES;
                        
                    }
                    
                }
            }
        }
        
        
        //这里？更改的地方
        __weak typeof(self) weakSelf = self;
        //[cell setCountChangeBlock:^(SVSelectedGoodsModel *model,NSIndexPath *indexPatch){
        [cell setInventoryChangeBlock:^(SVCheckGoodsModel *model, NSIndexPath *indexPatch) {
            
            //根据tableviewIndex找到对应的模型数组里的数组
//            NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[weakSelf.goodsModelArr objectAtIndex:weakSelf.tableviewIndex]];
//            [ary_1 replaceObjectAtIndex:indexPatch.row withObject:model];//这里有一报错 / 2017.12.21、2018.1.16
//            [weakSelf.goodsModelArr replaceObjectAtIndex:weakSelf.tableviewIndex withObject:ary_1];
//
//            NSMutableArray *ary_2 = [[NSMutableArray alloc]init];
//            for (NSArray *ary_3 in weakSelf.goodsModelArr) {
//
//                [ary_2 addObjectsFromArray:ary_3];
//            }
//            // 这个有点类似sql语句
//            //@"product_num CONTAINS %@"
//            //@"product_number=%d",1  此句为设定的搜索条件
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_number=%d",1]; // name\pinYin\pinYinHead不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
//            NSArray *dataAry = [ary_2 filteredArrayUsingPredicate:predicate];
//
//
//            weakSelf.guaDanArr = dataAry;
//            weakSelf.checkFooterButton.sumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.guaDanArr.count];
//            NSArray *ary_2 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            //头像
            if (![SVTool isBlankString:model.sv_p_images2]) {
                [dic setObject:model.sv_p_images2 forKey:@"sv_p_images2"];
            }
            //商品名
            [dic setObject:model.sv_p_name forKey:@"sv_p_name"];
            //单价
            [dic setObject:model.sv_p_unitprice forKey:@"sv_p_unitprice"];
            //库存
            [dic setObject:model.sv_p_storage forKey:@"sv_p_storage"];
            //单位
            [dic setObject:model.sv_p_unit forKey:@"sv_p_unit"];
            //商品ID
            [dic setObject:model.product_id forKey:@"product_id"];
            //记录点击后的件数
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
            
            if (weakSelf.goodsArr.count == 0) {
                
                [weakSelf.goodsArr addObject:dic];
                
            } else {
                
                for (NSDictionary *dict in weakSelf.goodsArr) {
                    SVCheckGoodsModel *modell = [SVCheckGoodsModel mj_objectWithKeyValues:dict];
                    if (modell.product_id == model.product_id) {
                        [weakSelf.goodsArr removeObject:dict];
                        break;
                    }
                }
                
                [weakSelf.goodsArr addObject:dic];
                
            }
            
            weakSelf.checkFooterButton.sumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.goodsArr.count];
            
            
        }];
        
        return cell;
    }
    
}

/**
 二级分类请求 / tabelView点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //先判断点击的是不是大分类
    if (tableView == self.oneTableView) {
        
        self.sao = YES;
        
        self.tableviewIndex = indexPath.row;
        //取出对应二级分类的id
        self.productcategory_id = [self.bigIDArr objectAtIndex:indexPath.row];
        //根据id去请求二级分类的内容
        NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
        if (ary_1.count != 0) {
            //当ary_1数组大于等于20个时，重新设置一下状态
            if (ary_1.count >= 20) {
                if (self.twoTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.twoTableView.mj_footer.state = MJRefreshStateIdle;
                }
            }
            [self.twoTableView reloadData];
            self.img.hidden = YES;
            self.noWares.hidden = YES;
            self.addButton.hidden = YES;
            return;
        }
        
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        
    }
}

#pragma mark - 盘点按钮响应方法
-(void)inventoryButtonResponseEvent {
    
    if (self.goodsArr.count == 0) {
        [SVTool TextButtonAction:self.view withSing:@"请选择盘点内容!"];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定将盘点结果调整为商品库存吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定将盘点结果调整为商品库存吗？"];
    //设置文本颜色
    [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 16)];
    //设置文本字体大小
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 16)];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self inventoryRequest];
    }];
    [derAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
    
    [alertController addAction:derAction];
    
    [alertController addAction:cancelAction];
    //添加到当前view上
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//盘点请求
-(void)inventoryRequest {
    
    //提示在支付中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    
    NSMutableArray *guaDanArr = [NSMutableArray array];
    
    for (NSDictionary *dict in self.goodsArr) {
        
        NSMutableDictionary *guaDanDic = [NSMutableDictionary dictionary];
        
        //商品ID
        [guaDanDic setObject:dict[@"product_id"] forKey:@"product_id"];
        //商品名字
        [guaDanDic setObject:dict[@"sv_p_name"] forKey:@"product_name"];
        //直接给0
        [guaDanDic setObject:@"0" forKey:@"product_num"];
        //新库存
        [guaDanDic setObject:dict[@"product_num"] forKey:@"sv_p_new_storage"];
        //旧库存
        [guaDanDic setObject:dict[@"sv_p_storage"] forKey:@"sv_p_storage"];
        //直接给0
        [guaDanDic setObject:@"0" forKey:@"sv_pricing_method"];
        //类型
        [guaDanDic setObject:@"false" forKey:@"type"];
        
        [guaDanArr addObject:guaDanDic];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:guaDanArr forKey:@"stockingprlist"];
    [parameters setObject:@"0" forKey:@"sv_without_list_id"];
    
    
    [SVUserManager loadUserInfo];
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier?key=%@",[SVUserManager shareInstance].access_token];

    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];


        if ([dic[@"succeed"] integerValue] == 1) {


            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"盘点成功";
            hud.label.textColor = [UIColor whiteColor];//字体颜色

            //默认选中第一行
            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                self.checkFooterButton.sumLabel.text = @"0";
                //设置数组索引为0
                self.tableviewIndex = 0;
                //默认选中第一行
                self.productcategory_id = 0;
                //清除数组
                [self.goodsModelArr removeAllObjects];
                NSInteger ins = self.bigNameArr.count;
                for (NSInteger inx = 0; inx <ins; inx++) {
                    
                    [_goodsModelArr addObject:@[]];
                    
                }
                self.goodsArr = nil;
                
                [self getDataPageIndex:1 pageSize:20 category:0 name:@""];

            });
        }



    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];

    }];
    
    
}


#pragma mark - 懒加载
-(NSMutableArray *)bigNameArr{
    if (!_bigNameArr) {
        _bigNameArr = [NSMutableArray array];
    }
    return _bigNameArr;
}

-(NSMutableArray *)bigIDArr{
    if (!_bigIDArr) {
        _bigIDArr = [NSMutableArray array];
    }
    return _bigIDArr;
}

-(NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

- (NSMutableArray *)goodsModelArr {
    
    if (!_goodsModelArr) {
        
        _goodsModelArr = [NSMutableArray array];
        NSInteger ins = self.bigNameArr.count;
        for (NSInteger inx = 0; inx <ins; inx++) {
            
            [_goodsModelArr addObject:@[]];
            
        }
    }
    return _goodsModelArr;
}

@end

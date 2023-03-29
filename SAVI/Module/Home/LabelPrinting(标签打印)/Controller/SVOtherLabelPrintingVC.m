//
//  SVWaresListVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVOtherLabelPrintingVC.h"
//自定义cell
#import "SVWaresListVCell.h"
//商品详情
#import "SVWaresDetailsVC.h"
//筛选商品
//#import "SVWaresScreeningVC.h"
//分类管理
#import "SVWaresOneClassVC.h"
//模型
#import "SVduoguigeModel.h"

#import "SVSelectPrintVC.h"

#import "SVCtrlViewVC.h"

#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
// 定义唯一标识
static NSString *oneWaresListVCellID = @"oneWaresListVCell";
static NSString *const WaresListVCellID = @"WaresListVCell";

@interface SVOtherLabelPrintingVC () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

//@property (nonatomic,strong) UITableView *tableView;
//
////搜索栏
//@property (strong, nonatomic) UISearchBar *searchBar;
//@property (strong, nonatomic) UIButton *qrcode;
//
///**
// 模型数组
// */
//@property (nonatomic,strong) NSMutableArray *modelArr;
//
//@property (nonatomic,assign)  NSInteger productsubcategory_id;
//
////记录刷新次数
//@property (nonatomic,assign) NSInteger page;
//
//@property (nonatomic,assign) BOOL sao;
//
//
//@property (nonatomic,strong) UIImageView *img;

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *qrcode;

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
@property (nonatomic, strong) NSMutableArray *bigNameArr;
@property (nonatomic, strong) NSMutableArray *bigIDArr;
//商品模型数组
@property (nonatomic, strong) NSMutableArray *goodsModelArr;
@property (nonatomic,strong) NSNumber *productcategory_id;
//标记 从属于第几个一级分类
@property (nonatomic, assign) NSInteger tableviewIndex;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *rightMenuBtn;
//@property (nonatomic,strong) NSMutableArray *purchaseArr;
@property (nonatomic,strong) UIButton *SingleElection;
@property (nonatomic,assign) ConnectState state;
// 记录
@end

@implementation SVOtherLabelPrintingVC
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    //设置导航标题
    //    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    //    title.text = @"商品管理";
    //    title.textAlignment = NSTextAlignmentCenter;
    //    title.textColor = [UIColor whiteColor];
    //    self.navigationItem.titleView = title;
    //
    //    //适配ios11偏移问题
    //    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backltem;
    //
    //    self.productsubcategory_id = 0;
    //    //界面布局
    //    [self setupController];
    //    //刷新
    //    [self setupRefresh];
    //
    //    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.title = @"选择打印商品";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
    //添加搜索栏
    [self addSearchBar];
    
    //从偏好设置里拿到大分类数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
    
    self.tableviewIndex = 0;
#pragma mark - 添加tableView
    //tabeleView
    self.oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW/6*2, ScreenH-114)];
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
    
    self.twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/6*2, 50, ScreenW/6*4, ScreenH-114)];
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
    [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:oneWaresListVCellID];
    [self.twoTableView registerNib:[UINib nibWithNibName:@"SVWaresListVCell" bundle:nil] forCellReuseIdentifier:WaresListVCellID];
    
    //调用刷新
    [self setupRefresh];
    
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
    [self.addButton setBackgroundColor:navigationBackgroundColor];
    [self.addButton addTarget:self action:@selector(addWaresButtonTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.twoTableView addSubview:self.addButton];
    //addButtonFrame
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.centerX.mas_equalTo(self.img.mas_centerX);
        make.top.mas_equalTo(self.img.mas_bottom).offset(20);
    }];
    
    
#pragma mark - 添加右侧按钮
    if (self.controllerNum == 1) {
        
        //        UIButton *rightMenuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        //        self.rightMenuBtn = rightMenuBtn;
        //        [rightMenuBtn setTitle:@"单选" forState:UIControlStateNormal];
        //        [rightMenuBtn setTitle:@"多选" forState:UIControlStateSelected];
        //        rightMenuBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        //        rightMenuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [rightMenuBtn addTarget:self action:@selector(rightBnt:) forControlEvents:UIControlEventTouchUpInside];
        //        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightMenuBtn];
        
    } else {
        
        //        UIButton *pulishButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
        //        [pulishButton setImage:[UIImage imageNamed:@"classManagement_icon"] forState:UIControlStateNormal];
        //        [pulishButton addTarget:self action:@selector(buttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        //
        //        UIButton *saveButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
        //        [saveButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
        //        [saveButton addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
        //
        //        pulishButton.frame = CGRectMake(0, 0, 20, 20);
        //        saveButton.frame=CGRectMake(0, 0, 20, 20);
        //
        //        UIBarButtonItem *pulish = [[UIBarButtonItem alloc] initWithCustomView:pulishButton];
        //        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        //
        //        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: pulish, save,nil]];
        
        //正确创建方式，这样显示的图片就没有问题了
        UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"classManagement_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonResponseEvent)];
        self.navigationItem.rightBarButtonItem = rightButon;
        
        
        
    }
    
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 30;
    // [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button setTitle:@"打印" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:navigationBackgroundColor];
    [button addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    
    //右上角按钮
    //    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    //    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)rightBnt:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        NSLog(@"--%@",btn.titleLabel.text);
    }else{
        NSLog(@"--+++%@",btn.titleLabel.text);
    }
    
    
}

//刷新
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
- (void)addSearchBar{
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    //是否在搜索框右侧显示一个图书的按钮，默认为NO
    //searchbar.showsBookmarkButton = NO;
    //是否显示搜索结果按钮，默认为NO
    //searchbar.showsSearchResultsButton = NO;
    //是否显示取消按钮，默认为NO
    //searchbar.showsCancelButton=NO;
    //是否显示搜索结果按钮，默认为NO
    //searchbar.showsSearchResultsButton=NO;
    
    //和其他文本输入控件的placeholder相同，在输入文字时就会消失
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.searchBar.placeholder = @"请输入商品名称或款号";
    }else{
        self.searchBar.placeholder = @"请输入商品名称或条码";
    }
    
    //默认风格
    self.searchBar.barStyle=UIBarStyleDefault;
    //设置键盘类型
    self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    //指定代理
    self.searchBar.delegate = self;
    //为UISearchBar添加背景图片
    //searchbar.backgroundColor = [UIColor whiteColor];
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
    [self.qrcode setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:self.qrcode];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(self.searchBar.mas_right).offset(-20);
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

#pragma mark - 完成选择按钮
- (void)selectbuttonResponseEvent {
    //当为空时，提示选择一下
    if ([SVTool isEmpty:self.purchaseArr]) {
        [SVTool TextButtonActionWithSing:@"请选择商品"];
        return;
    }
    
    if (self.addWarehouseWares) {
        //        self.addWarehouseWares(model.sv_p_images2, model.sv_p_name, model.sv_p_unitprice, model.sv_p_storage, model.product_id,model.sv_pricing_method);
        self.addWarehouseWares(self.purchaseArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 跳转扫一扫响应方法
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
//        weakSelf.tableviewIndex = 0;
//        //默认选中第一行
//        weakSelf.productcategory_id = 0;
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
        weakSelf.tableviewIndex = 0;
        //默认选中第一行
        weakSelf.productcategory_id = 0;
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        weakSelf.searchBar.text = resultStr;
        
        //调用请求
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:resultStr];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addWaresButtonTwo{
    //设置按钮点击时的背影色
    SVNewWaresVC *VC = [[SVNewWaresVC alloc]init];
    __weak typeof(self) weakSelf = self;
    VC.addWaresBlock = ^{
        //提示加载中
        [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"加载中…"];
        //调用请求方法
        [weakSelf getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",weakSelf.productcategory_id] integerValue] name:@""];
    };
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 新增商品跳转响应方法
-(void)addWaresButton{
    
    if (self.purchaseArr.count <= 0) {
        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
    }else{
        
        //设置按钮点击时的背影色
        SVSelectPrintVC *selectPrintVC = [[SVSelectPrintVC alloc]init];
        selectPrintVC.interface = 2;
        
        //        selectPrintVC.state = ^(ConnectState state) {
        //            NSLog(@"state = %ld",state);
        //            self.state = state;
        //            [self updateConnectState:state];
        //        };
        
        [SVUserManager shareInstance].indexpath = self.state;
        
        if ([SVUserManager shareInstance].indexpath == 3) {
            
            selectPrintVC.labelPrintArray = self.purchaseArr;
            [self.navigationController pushViewController:selectPrintVC animated:YES];
            
            
        }else {
            
            selectPrintVC.labelPrintArray = self.purchaseArr;
            
            [self.navigationController pushViewController:selectPrintVC animated:YES];
        }
        
        
    }
    
    
    //用延迟来作提示
    
    //    SVCtrlViewVC *vc = [[SVCtrlViewVC alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//     [Manager close];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    [Manager close];
//}

-(void)updateConnectState:(ConnectState)state {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case CONNECT_STATE_CONNECTING:
                //
                //  self.ConnState.text = @"连接状态：连接中....";
                break;
            case CONNECT_STATE_CONNECTED:
                //                [Manager close];
                //                [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                // self.ConnState.text = @"连接状态：已连接";
                
                break;
            case CONNECT_STATE_FAILT:
                //[SVProgressHUD showErrorWithStatus:@"连接失败"];
                //  self.ConnState.text = @"连接状态：连接失败";
                break;
            case CONNECT_STATE_DISCONNECT:
                // [SVProgressHUD showInfoWithStatus:@"断开连接"];
                // self.ConnState.text = @"连接状态：断开连接";
                break;
            default:
                // self.ConnState.text = @"连接状态：连接超时";
                break;
        }
        
    });
    
}


#pragma mark - 分类管理
-(void)buttonResponseEvent{
    //跳转会员详情界面
    //self.hidesBottomBarWhenPushed = YES;
    SVWaresOneClassVC *VC = [[SVWaresOneClassVC alloc]init];
    
    //对象有一个Block属性，然而这个Block属性中又引用了对象的其他成员变量，那么就会对这个变量本身产生强引用，那么变量本身和他自己的Block属性就形成了循环引用。因此我们需要对其进行处理进行弱引用。
    __weak typeof(self) weakSelf = self;
    
    VC.waresOneClassBlock = ^{
        
        //从偏好设置里拿到大分类数组
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        weakSelf.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
        weakSelf.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
        [weakSelf.oneTableView reloadData];
        
        [weakSelf.goodsModelArr removeAllObjects];
        for (NSInteger inx = 0; inx < weakSelf.bigNameArr.count; inx++) {
            [weakSelf.goodsModelArr addObject:@[]];
        }
        
        //设置数组索引为0
        weakSelf.tableviewIndex = 0;
        //默认选中第一行
        weakSelf.productcategory_id = 0;
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        //调用请求数据接口
        weakSelf.page = 1;
        weakSelf.sao = NO;
        weakSelf.searchBar.text = nil;
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:@""];
        
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    //self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - 数据请求
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
    // NSLog(@"fff---%@",urlStr);
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic---%@",dic);
        
        
        NSDictionary *valuesDic = dic[@"values"];
        
        NSArray *listArr = valuesDic[@"list"];
        
        
        //1判断页数，第一次加载先移除数组元素 在将请求返回的数据添加进去，刷新页数改变直接添加数据到数组中
        if (pageIndex == 1) {
            //[self.goodsModelArr removeAllObjects];
            //删除对应索引下的数据
            [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:@[]];
        }
        
        NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
        
        if (![SVTool isEmpty:listArr]) {
            //NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
            for (NSDictionary *goodsDic in listArr) {
                //赋值给模型
                SVduoguigeModel *goodsModel = [SVduoguigeModel mj_objectWithKeyValues:goodsDic];
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

#pragma mark - cell的展示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.oneTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneWaresListVCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneWaresListVCellID];
        }
        //赋值
        cell.textLabel.text = self.bigNameArr[indexPath.row];
        //设置字体大小
        cell.textLabel.font = [UIFont systemFontOfSize: 13];
        //设置label的行数
        cell.textLabel.numberOfLines = 0;
        //字体中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //字体颜色
        cell.textLabel.textColor = GlobalFontColor;
        //背景色
        cell.backgroundColor = BackgroundColor;
        //选中后显示的效果
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil highlightedImage:[UIImage imageNamed:@"leftbackgroup_red"]];
        //选中后字体颜色
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        
        //默认显示第一个子分类商品
        //if (indexPath.row == 0) {
        //self.productcategory_id = [self.bigIDArr objectAtIndex:indexPath.row];
        //[self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        //}
        
        return cell;
    } else {
        
        SVWaresListVCell *cell = [tableView dequeueReusableCellWithIdentifier:WaresListVCellID forIndexPath:indexPath];
        //如果没有就重新建一个
        if (!cell) {
            
            // cell = [[NSBundle mainBundle] loadNibNamed:@"SVWaresListVCell" owner:nil options:nil].lastObject;
            cell = [[SVWaresListVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WaresListVCellID];
            
        }
        //取消高亮
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        if (ary_1.count > indexPath.row) {
            SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];
            //            model.indexPath = indexPath;
            //            cell.model = model;
            //            cell.indexPatch = indexPath;
            
            if (self.purchaseArr.count == 0) {
                model.indexPath = indexPath;
                cell.model = model;
            } else {
                
                for (NSDictionary *dict in self.purchaseArr) {
                    SVduoguigeModel *equalModel = [SVduoguigeModel mj_objectWithKeyValues:dict];
                    
                    if ([equalModel.product_id isEqualToString:model.product_id]) {
                        model.indexPath = indexPath;
                        cell.model = equalModel;
                        return cell;
                    }
                    
                    model.indexPath = indexPath;
                    cell.model = model;
                    
                }
            }
        }
        
        //
        if (self.controllerNum == 1) {
            cell.cellButton.hidden = NO;
        } else {
            cell.cellButton.hidden = YES;
        }
        
        __weak typeof(self) weakSelf = self;
        cell.waresListVCelllock = ^(SVduoguigeModel *model, NSIndexPath *index) {
            if (weakSelf.purchaseArr.count == 0) {
                
                //第一个选中时添加
                [weakSelf.purchaseArr addObject:model];
                //  NSLog(@"weakSelf.purchaseArr.count = %ld",weakSelf.purchaseArr.count);
            } else {
                //判断相同时，先删掉，再添加到数组中
                for (NSDictionary *dict in weakSelf.purchaseArr) {
                    SVduoguigeModel *modell = [SVduoguigeModel mj_objectWithKeyValues:dict];
                    if (modell.product_id == model.product_id) {
                        [weakSelf.purchaseArr removeObject:dict];
                        break;
                    }
                }
                
                //当为选中1状态时，添加
                if ([model.isSelect isEqualToString:@"1"]) {
                    [weakSelf.purchaseArr addObject:model];
                }
                
            }
            
        };
        
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
    if (tableView == self.twoTableView) {
        //一句实现点击效果
        [self.twoTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];//这里有一个报错
        
        //        if (self.controllerNum == 1) {
        //            //将选中的商品返回新增采购
        //            //判断商品是否被选择
        //            for (NSDictionary *dic in self.purchaseArr) {
        //                SVduoguigeModel *modelA = [SVduoguigeModel mj_objectWithKeyValues:dic];
        //                if ([model.product_id isEqualToString:modelA.product_id]) {
        //                    [SVTool TextButtonAction:self.view withSing:@"商品已选择"];
        //                    return;
        //                }
        //            }
        //
        //            if (self.addWarehouseWares) {
        //                self.addWarehouseWares(model.sv_p_images2, model.sv_p_name, model.sv_p_unitprice, model.sv_p_storage, model.product_id,model.sv_pricing_method);
        //            }
        //            [self.navigationController popViewControllerAnimated:YES];
        //        } else {
        //跳转会员详情界面
        SVWaresDetailsVC *VC = [[SVWaresDetailsVC alloc]init];
        VC.productID = model.product_id;
        
        __weak typeof(self) weakSelf = self;
        VC.WaresDetailsBlock = ^(){
            weakSelf.page = 1;
            //提示加载中
            [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
            //调用请求方法
            [self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        };
        [self.navigationController pushViewController:VC animated:YES];
        //        }
    }
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

- (NSMutableArray *)goodsModelArr {
    
    if (!_goodsModelArr) {
        
        _goodsModelArr = [NSMutableArray array];
        NSInteger ins = self.bigNameArr.count;
        //if (self.bigNameArr.count == 0) {
        //ins = 20;
        //ins = 200;
        //}
        for (NSInteger inx = 0; inx <ins; inx++) {
            [_goodsModelArr addObject:@[]];
        }
    }
    return _goodsModelArr;
}

-(NSMutableArray *)purchaseArr {
    if (!_purchaseArr) {
        _purchaseArr = [NSMutableArray array];
    }
    return _purchaseArr;
}


@end

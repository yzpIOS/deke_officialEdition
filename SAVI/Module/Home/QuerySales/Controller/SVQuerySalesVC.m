//
//  SVMessageVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVQuerySalesVC.h"
//选择时间
#import "SVSelectTwoDatesView.h"
//cell
#import "SVQuerySalesCell.h"
#import "SVQuerySalesModel.h"
////组头
//#import "SVPayManagementView.h"
//详情
#import "SVSellOrderVC.h"
#import "SVExpandBtn.h"

static NSString *MessageCellID = @"MessageCell";
@interface SVQuerySalesVC () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,copy) NSString *keyStr;

@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic, strong) SVPayManagementView *headerview;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *selectDateView;
//记录点击是1还是0
@property (nonatomic,assign) NSInteger isSelect;
//记录点击的按钮
@property (nonatomic,assign) NSInteger buttonNum;
//记录支付方式
@property (nonatomic,copy) NSString *payName;

@property (nonatomic,copy) NSString *searchSelectName;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;

//今天的数据
@property (nonatomic,copy) NSString *toDay;//日期
//@property (nonatomic,copy) NSString *toDayMoney;
@property (nonatomic,copy) NSString *toDayOne;//总金额
@property (nonatomic,copy) NSString *toDayTwo;//笔数
@property (nonatomic,copy) NSString *toDayThree;//数量
@property(nonatomic, strong) NSMutableArray *toDayModelArr;
//昨天的数据
@property (nonatomic,copy) NSString *yesterDay;
//@property (nonatomic,copy) NSString *yesterDayMoney;
@property (nonatomic,copy) NSString *yesterDayOne;
@property (nonatomic,copy) NSString *yesterDayTwo;
@property (nonatomic,copy) NSString *yesterDayThree;
@property(nonatomic, strong) NSMutableArray *yesterDayModelArr;
//本周的数据
@property (nonatomic,copy) NSString *weekDayOne;
@property (nonatomic,copy) NSString *weekDayTwo;
@property (nonatomic,copy) NSString *weekDayThree;
@property (nonatomic,strong) NSMutableArray *weekDateArr;
@property (nonatomic,strong) NSMutableArray *weekMoneyArr;
@property (nonatomic,strong) NSMutableArray *weekModelArr;
//其它的数据
@property (nonatomic,copy) NSString *dateDayOne;
@property (nonatomic,copy) NSString *dateDayTwo;
@property (nonatomic,copy) NSString *dateDayThree;
@property (nonatomic,strong) NSMutableArray *dateArr;
@property (nonatomic,strong) NSMutableArray *dateMoneyArr;
@property(nonatomic, strong) NSMutableArray *dateModelArr;

//记录刷新次数
@property (nonatomic,assign) NSInteger onePage;
@property (nonatomic,assign) NSInteger twoPage;
@property (nonatomic,assign) NSInteger threePage;
@property (nonatomic,assign) NSInteger fourPage;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
//遮盖view
@property (nonatomic,strong) UIView *maskView;
@property (strong, nonatomic) SVExpandBtn *sanjiao;
@end

@implementation SVQuerySalesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏TabBar
    self.hidesBottomBarWhenPushed=YES;
    
    //默认选中今天按钮
    if (self.indexNum == 1) {
        self.buttonNum = self.indexNum;
        [self.button setTitle:@"今天" forState:UIControlStateNormal];
        [self.oneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.oneButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
        
        //数据请求
        self.payName = @"";
        [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        
    }else if (self.indexNum == -1){
        self.buttonNum = self.indexNum;
        [self.button setTitle:@"昨天" forState:UIControlStateNormal];
        [self.twoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.twoButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
        
        //数据请求
        self.payName = @"";
        [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        
    }else if (self.indexNum == 2){
        self.buttonNum = self.indexNum;
        [self.button setTitle:@"本周" forState:UIControlStateNormal];
        [self.threeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.threeButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
        
        //数据请求
        self.payName = @"";
        [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    }else if(self.indexNum == 3){
        self.buttonNum = self.indexNum;
        // self.payName = @"";
        [self.button setTitle:@"其他" forState:UIControlStateNormal];
        [self.fourButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.fourButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
        
        //        NSInteger temp = [SVDateTool cTimestampFromString:self.oneDateStr format:@"yyyy-MM-dd"];
        //        NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDateStr format:@"yyyy-MM-dd"];
        self.oneDate = self.oneDateStr;
        self.twoDate = self.twoDateStr;
        [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        
        //         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onToggleMasterVisible:) name:@"InfoInquirySale" object:nil];
        
    }
    
    
    //默认是YES 高亮效果
    [self.button setAdjustsImageWhenHighlighted:NO];
    
    //添加搜索栏
    [self addSearchBar];
    
    //正确创建方式，这样显示的图片就没有问题了
    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"screening_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfoButtonResponseEvent)];
    self.navigationItem.rightBarButtonItem = rightButon;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, ScreenW, ScreenH-64-105)];
    //self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, ScreenW, ScreenH-64-105) style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = RGBA(246, 246, 246, 1);
    //取消tableView的选中
    //tableView.allowsSelection = NO;
    //滚动条
    //self.tableView.showsVerticalScrollIndicator = NO;
    // 这样就不会显示自带的分割线
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右各10的距离
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
    //普通cell的注册
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QuerySalesCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVQuerySalesCell" bundle:nil] forCellReuseIdentifier:MessageCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    //实现弹出方法
    [UIView animateWithDuration:.1 animations:^{
        self.selectDateView.frame = CGRectMake(0, 15, ScreenW, 45);
        self.tableView.frame = CGRectMake(0, 60, ScreenW, ScreenH-64-60);
    }];
    
    //提示查询
    [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    //数据请求
    //   self.payName = @"";
    //    [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    
    self.onePage = 1;
    self.twoPage = 1;
    self.threePage = 1;
    self.fourPage = 1;
    
    self.toDayOne = @"0.00";
    self.toDayTwo = @"0";
    self.toDayThree = @"0";
    
    self.yesterDayOne = @"0.00";
    self.yesterDayTwo = @"0";
    self.yesterDayThree = @"0";
    
    self.weekDayOne = @"0.00";
    self.weekDayTwo = @"0";
    self.weekDayThree = @"0";
    
    self.dateDayOne = @"0.00";
    self.dateDayTwo = @"0";
    self.dateDayThree = @"0";
    
#pragma mark -  下拉刷新请求
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.payName = @"";
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        if (self.buttonNum == 1) {
            self.onePage = 1;
            [self.toDayModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            
        }
        if (self.buttonNum == -1) {
            self.twoPage = 1;
            [self.yesterDayModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == 2) {
            self.threePage = 1;
            [self.weekDateArr removeAllObjects];
            [self.weekMoneyArr removeAllObjects];
            [self.weekModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == 3) {
            self.fourPage = 1;
            [self.dateArr removeAllObjects];
            [self.dateMoneyArr removeAllObjects];
            [self.dateModelArr removeAllObjects];
            
            self.searchBar.text = nil;
            self.keyStr = @"";
            [self dateRequestResponseEvent];
        }
        
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
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    //    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    
    self.tableView.mj_header = header;
    
#pragma mark -  上拉刷新请求
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        if (self.buttonNum == 1) {
            self.onePage ++;
            //数据请求
            if ([SVTool isBlankString:self.payName]) {
                [self getThreeSourcesWithPage:self.onePage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            } else {
                [self getThreeSourcesWithPage:self.onePage top:20 day:self.buttonNum payname:self.payName keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            }
        }
        if (self.buttonNum == -1) {
            self.twoPage ++;
            //数据请求
            if ([SVTool isBlankString:self.payName]) {
                [self getThreeSourcesWithPage:self.twoPage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            } else {
                [self getThreeSourcesWithPage:self.twoPage top:20 day:self.buttonNum payname:self.payName keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            }
        }
        if (self.buttonNum == 2) {
            self.threePage ++;
            //数据请求
            if ([SVTool isBlankString:self.payName]) {
                [self getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            } else {
                [self getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:self.payName keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
            }
        }
        if (self.buttonNum == 3) {
            self.fourPage ++;
            [self dateRequestResponseEvent];
            
        }
        
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
    
    self.tableView.mj_footer = footer;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}


#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    //添加方法二
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    
    titleView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.1];
    //UIColor *color =  self.navigationController.navigationBar.tintColor;
    //[titleView setBackgroundColor:color];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 0, ScreenW-60-40, 30)];
    
    self.searchBar.placeholder = @"请输入商品信息或会员信息查找";
    titleView.layer.cornerRadius = 15;
    titleView.layer.masksToBounds = YES;
    // titleView.backgroundColor = [UIColor clearColor];
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    //设置背景色
    //  self.searchBar.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.1];
    self.searchBar.backgroundColor = [UIColor clearColor];
    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeDefault;
    //self.searchBar.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
    self.searchBar.delegate = self;
    //   UITextField *searchTextField  = [self.searchBar valueForKey:@"_searchField"];
    // searchTextField.leftView = nil;
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;
    //5. 设置搜索Icon
    //    [self.searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    
    
    // [self.searchBar]
    
    /*这段代码有个特别的地方就是通过KVC获得到UISearchBar的私有变量
     searchField（类型为UITextField），设置SearchBar的边框颜色和圆角实际上也就变成了设置searchField的边框颜色和圆角，你可以试试直接设置SearchBar.layer.borderColor和cornerRadius，会发现这样做是有问题的。*/
    //一下代码为修改placeholder字体的颜色和大小

   // UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
   // UITextField *searchField = self.searchBar.searchTextField;
    
          UITextField * searchField;
                if (@available(iOS 13.0, *)) { // iOS 11
                    searchField = _searchBar.searchTextField;
                    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品信息或会员信息查找" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
                       // 输入文本颜色
                       searchField.textColor = [UIColor whiteColor];
                       searchField.font = [UIFont systemFontOfSize:13];
                }else{
                    searchField =  [_searchBar valueForKey:@"_searchField"];
                    // 默认文本大小
                    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                    if (searchField) {
                          [searchField setBackgroundColor:[UIColor clearColor]];
                      }
                      // 输入文本颜色
                      searchField.textColor = [UIColor whiteColor];
                      searchField.font = [UIFont systemFontOfSize:15];
                }
                
                searchField.leftView = nil;
                // 输入文本颜色
                searchField.textColor = [UIColor whiteColor];
                searchField.font = [UIFont systemFontOfSize:15];
                // 默认文本大小
              //  [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                //2. 设置圆角和边框颜色
            //    if (searchField) {
            //        [searchField setBackgroundColor:[UIColor clearColor]];
            //        //searchField.layer.borderColor = [UIColor colorWithRed:49/255.0f green:193/255.0f blue:123/255.0f alpha:1].CGColor;
            //        //searchField.layer.borderWidth = 1;
            //        //searchField.layer.cornerRadius = 23.0f;
            //        //searchField.layer.masksToBounds = YES;
            //        //根据@"_placeholderLabel.textColor" 找到placeholder的字体颜色
            //      //  [searchField setValue:[UIColor colorWithRed:10/255.0f green:150/255.0f blue:90/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            //
            ////        NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:searchField.placeholder attributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:10/255.0f green:150/255.0f blue:90/255.0f alpha:1],NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
            ////        searchField.attributedPlaceholder = arrStr;
            //    }

               // NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.textFieldOne.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldOne.placeholder.color}];
                
                
               // searchField.
              //  searchField.attributedPlaceholder =
                // 默认文本大小
              //  [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
              //  searchField.font = [UIFont boldSystemFontOfSize:13];
                //只有编辑时出现出现那个叉叉
                searchField.clearButtonMode = UITextFieldViewModeWhileEditing;

    
    [titleView addSubview:self.searchBar];
    
    //    //扫一扫按钮
    self.sanjiao = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
    self.sanjiao.backgroundColor = [UIColor clearColor];
    self.sanjiao.frame = CGRectMake(00, 0, 40, 30);
    [self.sanjiao setImage:[UIImage imageNamed:@"xiaosanjiao"] forState:UIControlStateNormal];
    [self.sanjiao setTitle:@"商品" forState:UIControlStateNormal];
    [self.sanjiao.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.sanjiao addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.sanjiao];
    
    [self.sanjiao setTitleEdgeInsets:UIEdgeInsetsMake(0, -
                                                      self.sanjiao.imageView.frame.size.width, 0, self.sanjiao.imageView.frame.size.width-10)];
    [self.sanjiao setImageEdgeInsets:UIEdgeInsetsMake(0, self.sanjiao.titleLabel.bounds.size.width, 0, - self.sanjiao.titleLabel.bounds.size.width-20)];
    
    //Set to titleView
    self.navigationItem.titleView = titleView;
    
}
#pragma mark - 左边按钮的使用
- (void)scanButtonResponseEvent{
    
    [UIView animateWithDuration:.3 animations:^{
        //旋转
        self.sanjiao.imageView.transform = CGAffineTransformRotate(self.sanjiao.imageView.transform, M_PI);
    }];
    
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
    //    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"    现金" image:[UIImage imageNamed:@"YCXM_cash"] target:self action:@selector(logout)];
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"会员查询" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor = GlobalFontColor;
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"销售单查询" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = GlobalFontColor;
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    NSArray *items = [NSArray array];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"商品名款号查询" image:nil target:self action:@selector(logout)];
        logoutItem.foreColor = GlobalFontColor;
        logoutItem.alignment = NSTextAlignmentLeft;
        logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
        
        items = @[logoutItem,menuTitle,cashTitle];
        
        [YCXMenu setCornerRadius:3.0f];
        [YCXMenu setSeparatorColor:GreyFontColor];
        [YCXMenu setSelectedColor:clickButtonBackgroundColor];
        [YCXMenu setTintColor:[UIColor whiteColor]];
    }else{
        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"商品名条码查询" image:nil target:self action:@selector(logout)];
        logoutItem.foreColor = GlobalFontColor;
        logoutItem.alignment = NSTextAlignmentLeft;
        logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
        
        items = @[logoutItem,menuTitle,cashTitle];
        
        [YCXMenu setCornerRadius:3.0f];
        [YCXMenu setSeparatorColor:GreyFontColor];
        [YCXMenu setSelectedColor:clickButtonBackgroundColor];
        [YCXMenu setTintColor:[UIColor whiteColor]];
    }
   
    
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(70, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    self.searchSelectName = @"商品名款号";
                }else{
                    self.searchSelectName = @"商品名条码";
                }
              
                [self.sanjiao setTitle:@"商品" forState:UIControlStateNormal];
                //  [self selectYCXMenuPayName];
                
            }
                break;
            case 1:
            {
                self.searchSelectName = @"销售单";
                [self.sanjiao setTitle:@"销售" forState:UIControlStateNormal];
                //  [self selectYCXMenuPayName];
            }
                break;
            case 2:
            {
                self.searchSelectName = @"会员";
                [self.sanjiao setTitle:@"会员" forState:UIControlStateNormal];
                // [self selectYCXMenuPayName];
            }
                
                break;
            default:
                break;
        }
    }];
    
    
}

#pragma mark - 输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //提示查询
    //    [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
    [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    //默认选中本周按钮
    // self.buttonNum = 2;
    self.fourPage = 1;
    //    //高亮
    //    [self setSelectedButton:self.fourButton];
    //    //默认
    //    [self setDefaultButton:self.oneButton];
    //    [self setDefaultButton:self.twoButton];
    //    [self setDefaultButton:self.threeButton];
    //设置button的text
    //  [self.button setTitle:@"其它" forState:UIControlStateNormal];
    
    //解码方法，返回的是一致的字符串
    //    self.keyStr = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.dateArr removeAllObjects];
    [self.dateMoneyArr removeAllObjects];
    [self.dateModelArr removeAllObjects];
    if ([self.searchSelectName isEqualToString:@"会员"]) {
        if (self.buttonNum == 1) {
            self.onePage = 1;
            [self.toDayModelArr removeAllObjects];
            
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == -1) {
            self.twoPage = 1;
            [self.yesterDayModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
            
        }
        if (self.buttonNum == 2) {
            self.threePage = 1;
            [self.weekDateArr removeAllObjects];
            [self.weekMoneyArr removeAllObjects];
            [self.weekModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == 3) {
            self.fourPage = 1;
            [self.dateArr removeAllObjects];
            [self.dateMoneyArr removeAllObjects];
            [self.dateModelArr removeAllObjects];
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        
    }else if ([self.searchSelectName isEqualToString:@"销售单"]){
        
        if (self.buttonNum == 1) {
            self.onePage = 1;
            [self.toDayModelArr removeAllObjects];
            
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == -1) {
            self.twoPage = 1;
            [self.yesterDayModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
            
        }
        if (self.buttonNum == 2) {
            self.threePage = 1;
            [self.weekDateArr removeAllObjects];
            [self.weekMoneyArr removeAllObjects];
            [self.weekModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == 3) {
            self.fourPage = 1;
            [self.dateArr removeAllObjects];
            [self.dateMoneyArr removeAllObjects];
            [self.dateModelArr removeAllObjects];
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        
        //        [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
    }else{
        // 商品名款号
        
        if (self.buttonNum == 1) {
            self.onePage = 1;
            [self.toDayModelArr removeAllObjects];
            
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == -1) {
            self.twoPage = 1;
            [self.yesterDayModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
            
        }
        if (self.buttonNum == 2) {
            self.threePage = 1;
            [self.weekDateArr removeAllObjects];
            [self.weekMoneyArr removeAllObjects];
            [self.weekModelArr removeAllObjects];
            //数据请求
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        if (self.buttonNum == 3) {
            self.fourPage = 1;
            [self.dateArr removeAllObjects];
            [self.dateMoneyArr removeAllObjects];
            [self.dateModelArr removeAllObjects];
            [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
        }
        
        //         [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:searchBar.text date:@"" date2:@"" keyWords:self.searchSelectName];
    }
    
    
    //移除第一响应者
    [searchBar resignFirstResponder];
    
}

- (IBAction)selectDateButtonResponseEvent {
    
    if (self.isSelect == 0) {
        //点第一次
        self.isSelect = 1;
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.selectDateView.frame = CGRectMake(0, 60, ScreenW, 45);
            self.tableView.frame = CGRectMake(0, 105, ScreenW, ScreenH-64-105);
        }];
    } else {
        //点第二次
        self.isSelect = 0;
        //        [self.maskOneView removeFromSuperview];
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.selectDateView.frame = CGRectMake(0, 15, ScreenW, 45);
            self.tableView.frame = CGRectMake(0, 60, ScreenW, ScreenH-64-60);
        }];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        //旋转
        self.button.imageView.transform = CGAffineTransformRotate(self.button.imageView.transform, M_PI);
    }];
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - 四个按钮的响应方法
- (IBAction)oneButtonResponseEvent {
    
    self.buttonNum = 1;
    //高亮
    [self setSelectedButton:self.oneButton];
    //默认
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.threeButton];
    [self setDefaultButton:self.fourButton];
    //设置button的text
    [self.button setTitle:@"今天" forState:UIControlStateNormal];
    self.oneLabel.text = self.toDayOne;
    self.twoLabel.text = self.toDayTwo;
    self.threeLabel.text = self.toDayThree;
    
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    if ([SVTool isEmpty:self.toDayModelArr]) {
        //提示查询
        //        [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
        [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        self.onePage = 1;
        [self getThreeSourcesWithPage:self.onePage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    
}

- (IBAction)twoButtonResponseEvent {
    
    self.buttonNum = -1;
    //高亮
    [self setSelectedButton:self.twoButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.threeButton];
    [self setDefaultButton:self.fourButton];
    //设置button的text
    [self.button setTitle:@"昨天" forState:UIControlStateNormal];
    self.oneLabel.text = self.yesterDayOne;
    self.twoLabel.text = self.yesterDayTwo;
    self.threeLabel.text = self.yesterDayThree;
    
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    if ([SVTool isEmpty:self.yesterDayModelArr]) {
        //提示查询
        //        [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
        [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        self.twoPage = 1;
        [self getThreeSourcesWithPage:self.twoPage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
}

- (IBAction)threeButtonResponseEvent {
    
    self.buttonNum = 2;
    //高亮
    [self setSelectedButton:self.threeButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.fourButton];
    //设置button的text
    [self.button setTitle:@"本周" forState:UIControlStateNormal];
    self.oneLabel.text = self.weekDayOne;
    self.twoLabel.text = self.weekDayTwo;
    self.threeLabel.text = self.weekDayThree;
    
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    if ([SVTool isEmpty:self.weekModelArr]) {
        //提示查询
        //        [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
        [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        self.threePage = 1;
        [self getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
}

- (IBAction)fourButtonResponseEvent {
    
    self.buttonNum = 3;
    //高亮
    [self setSelectedButton:self.fourButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.threeButton];
    //设置button的text
    [self.button setTitle:@"其它" forState:UIControlStateNormal];
    self.oneLabel.text = self.dateDayOne;
    self.twoLabel.text = self.dateDayTwo;
    self.threeLabel.text = self.dateDayThree;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
    
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

//选中状态
-(void)setSelectedButton:(UIButton *)btn {
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
    
}

//改变按钮字体颜色
-(void)setDefaultButton:(UIButton *)btn {
    //默认
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateNormal];
    
}

#pragma mark -  筛选请求
#pragma mark - 右上角反应方法
-(void)releaseInfoButtonResponseEvent {
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"    现金" image:[UIImage imageNamed:@"YCXM_cash"] target:self action:@selector(logout)];
    cashTitle.foreColor = GlobalFontColor;
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"    微信" image:[UIImage imageNamed:@"YCXM_wechat"] target:self action:@selector(logout)];
    menuTitle.foreColor = GlobalFontColor;
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"    支付宝" image:[UIImage imageNamed:@"YCXM_treasure"] target:self action:@selector(logout)];
    logoutItem.foreColor = GlobalFontColor;
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"    银行卡" image:[UIImage imageNamed:@"YCXM_unionpay"] target:self action:@selector(logout)];
    bankItem.foreColor = GlobalFontColor;
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *storedItem = [YCXMenuItem menuItem:@"    储值卡" image:[UIImage imageNamed:@"YCXM_stored"] target:self action:@selector(logout)];
    storedItem.foreColor = GlobalFontColor;
    storedItem.alignment = NSTextAlignmentLeft;
    storedItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem,storedItem];
    //    NSArray *items = @[[YCXMenuItem menuItem:@"现金" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"微信" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"支付宝" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"银行卡" image:nil tag:4 userInfo:@{@"title":@"Menu"}],
    //                       ];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:GreyFontColor];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
                self.payName = @"现金";
                [self selectYCXMenuPayName];
                
            }
                break;
            case 1:
            {
                self.payName = @"微信支付";
                [self selectYCXMenuPayName];
            }
                break;
            case 2:
            {
                self.payName = @"支付宝";
                [self selectYCXMenuPayName];
            }
                break;
            case 3:
            {
                self.payName = @"银行卡";
                [self selectYCXMenuPayName];
            }
                break;
            case 4:
            {
                self.payName = @"储值卡";
                [self selectYCXMenuPayName];;
            }
                break;
            default:
                break;
        }
    }];
    
}

- (void)logout {
    
}

- (void)selectYCXMenuPayName {
    
    //提示查询
    //    [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
    [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    if (self.buttonNum == 1) {
        self.onePage = 1;
        [self.toDayModelArr removeAllObjects];
        //数据请求
        [self getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:self.payName keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    }
    if (self.buttonNum == -1) {
        self.twoPage = 1;
        [self.yesterDayModelArr removeAllObjects];
        //数据请求
        [self getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:self.payName keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        
    }
    if (self.buttonNum == 2) {
        self.threePage = 1;
        [self.weekDateArr removeAllObjects];
        [self.weekMoneyArr removeAllObjects];
        [self.weekModelArr removeAllObjects];
        //数据请求
        [self getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:self.payName keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
    }
    if (self.buttonNum == 3) {
        self.fourPage = 1;
        [self.dateArr removeAllObjects];
        [self.dateMoneyArr removeAllObjects];
        [self.dateModelArr removeAllObjects];
        [self dateRequestResponseEvent];
    }
}

- (void)dateRequestResponseEvent {
    
    if (![SVTool isBlankString:self.keyStr]) {
        //数据请求
        [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:self.payName keys:self.keyStr date:@"" date2:@"" keyWords:self.searchSelectName];
    } else {
        
        //创建一个日期格式化器
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        //设置时间样式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
        self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
        
        NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
        NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
        
        if (temp > tempi) {
            
            [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
            
        } else {
            //数据请求
            if ([SVTool isBlankString:self.payName]) {
                [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:@"" date:self.oneDate date2:self.twoDate keyWords:self.searchSelectName];
            } else {
                [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:self.payName keys:@"" date:self.oneDate date2:self.twoDate keyWords:self.searchSelectName];
            }
            
        }
    }
    
    
}

#pragma mark - 数据请求

/**
 @param page 第几页
 @param top 显示多少条
 @param day 日期
 @param payname 支付方式
 @param keys 按用户信息模糊搜索
 @param date 选择时间
 @param date2 选择时间
 */

-(void)getThreeSourcesWithPage:(NSInteger)page top:(NSInteger)top day:(NSInteger)day payname:(NSString *)payname keys:(NSString *)keys date:(NSString *)date date2:(NSString *)date2 keyWords:(NSString *)keyWords{
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *sURL;
    if ([keyWords isEqualToString:@"会员"]) {
        sURL = [URLhead stringByAppendingFormat:@"/intelligent/GetsalesList_new?key=%@&page=%li&top=%li&day=%li&payname=%@&date=%@&date2=%@&keys=%@",token,(long)page,(long)top,(long)day,payname,date,date2,keys];
    }else if ([keyWords isEqualToString:@"销售单"]){
        sURL = [URLhead stringByAppendingFormat:@"/intelligent/GetsalesList_new?key=%@&page=%li&top=%li&day=%li&payname=%@&date=%@&date2=%@&liushui=%@",token,(long)page,(long)top,(long)day,payname,date,date2,keys];
    }else{
        sURL = [URLhead stringByAppendingFormat:@"/intelligent/GetsalesList_new?key=%@&page=%li&top=%li&day=%li&payname=%@&date=%@&date2=%@&pkeyword=%@",token,(long)page,(long)top,(long)day,payname,date,date2,keys];
    }
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL = %@",strURL);
    
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic886755 = %@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
            //            [self.yesterDayModelArr removeAllObjects];
            //            [self.toDayModelArr removeAllObjects];
            //            [self.weekModelArr removeAllObjects];
            //            [self.dateModelArr removeAllObjects];
            
            NSArray *countArr = dic[@"count"];
            
            NSArray *dataListArr = dic[@"resutlist"];
            
            if (![SVTool isEmpty:dataListArr]) {
                
                for (NSDictionary *dict in dataListArr) {
                    if (self.buttonNum == 1) {
                        self.toDay = [dict objectForKey:@"order_datetime"];
                        self.toDayOne = [NSString stringWithFormat:@"%.2f",[countArr[2] floatValue]];
                        self.toDayTwo = [NSString stringWithFormat:@"%.f",[countArr[0] floatValue]];
                        self.toDayThree = [NSString stringWithFormat:@"%.f",[countArr[3] floatValue]];
                        self.oneLabel.text = self.toDayOne;
                        self.twoLabel.text = self.toDayTwo;
                        self.threeLabel.text = self.toDayThree;
                        
                        [self.toDayModelArr addObject:[dict objectForKey:@"orderlist"]];
                    }
                    if (self.buttonNum == -1) {
                        self.yesterDay = [dict objectForKey:@"order_datetime"];
                        self.yesterDayOne = [NSString stringWithFormat:@"%.2f",[countArr[2] floatValue]];
                        self.yesterDayTwo = [NSString stringWithFormat:@"%.f",[countArr[0] floatValue]];
                        self.yesterDayThree = [NSString stringWithFormat:@"%.f",[countArr[3] floatValue]];
                        self.oneLabel.text = self.yesterDayOne;
                        self.twoLabel.text = self.yesterDayTwo;
                        self.threeLabel.text = self.yesterDayThree;
                        
                        [self.yesterDayModelArr addObject:[dict objectForKey:@"orderlist"]];
                    }
                    if (self.buttonNum == 2) {
                        self.weekDayOne = [NSString stringWithFormat:@"%.2f",[countArr[2] floatValue]];
                        self.weekDayTwo = [NSString stringWithFormat:@"%.f",[countArr[0] floatValue]];
                        self.weekDayThree = [NSString stringWithFormat:@"%.f",[countArr[3] floatValue]];
                        self.oneLabel.text = self.weekDayOne;
                        self.twoLabel.text = self.weekDayTwo;
                        self.threeLabel.text = self.weekDayThree;
                        
                        [self.weekDateArr addObject:[dict objectForKey:@"order_datetime"]];
                        [self.weekMoneyArr addObject:[dict objectForKey:@"datemoney"]];
                        [self.weekModelArr addObject:[dict objectForKey:@"orderlist"]];
                    }
                    if (self.buttonNum == 3) {
                        self.dateDayOne = [NSString stringWithFormat:@"%.2f",[countArr[2] floatValue]];
                        self.dateDayTwo = [NSString stringWithFormat:@"%.f",[countArr[0] floatValue]];
                        self.dateDayThree = [NSString stringWithFormat:@"%.f",[countArr[3] floatValue]];
                        self.oneLabel.text = self.dateDayOne;
                        self.twoLabel.text = self.dateDayTwo;
                        self.threeLabel.text = self.dateDayThree;
                        
                        [self.dateArr addObject:[dict objectForKey:@"order_datetime"]];
                        [self.dateMoneyArr addObject:[dict objectForKey:@"datemoney"]];
                        [self.dateModelArr addObject:[dict objectForKey:@"orderlist"]];
                    }
                }
                
                //    [self.tableView reloadData];
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            } else {
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
                if ([SVTool isEmpty:self.toDayModelArr] && [SVTool isEmpty:self.yesterDayModelArr] && [SVTool isEmpty:self.weekModelArr] && [SVTool isEmpty:self.dateModelArr]) {
                    self.oneLabel.text = @"0.00";
                    self.twoLabel.text = @"0";
                    self.threeLabel.text = @"0";
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
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
            
        }
        
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}


//#pragma mark - tableVeiw
////让section头部不停留在顶部
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//
//    //移除第一响应者
//    [self.searchBar resignFirstResponder];
//}

//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.buttonNum == 1) {
        return self.toDayModelArr.count;
    }
    if (self.buttonNum == -1) {
        return self.yesterDayModelArr.count;
    }
    if (self.buttonNum == 2) {
        return self.weekModelArr.count;
    }
    if (self.buttonNum == 3) {
        return self.dateModelArr.count;
    }
    
    return 0;
}

////头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
//
////section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    //创建组头view
//    self.headerview = [[NSBundle mainBundle]loadNibNamed:@"SVPayManagementView" owner:self options:nil].firstObject;
//    self.headerview.backgroundColor = RGBA(246, 246, 246, 1);
//
//    if (self.buttonNum == 1) {
//        if (![SVTool isEmpty:self.toDayModelArr]) {
//            self.headerview.dateLabel.text = [self.toDay substringWithRange:NSMakeRange(0, 10)];
//            self.headerview.moneyLabel.text = self.toDayOne;
//        }
//    }
//    if (self.buttonNum == -1) {
//        if (![SVTool isEmpty:self.yesterDayModelArr]) {
//            self.headerview.dateLabel.text = [self.yesterDay substringWithRange:NSMakeRange(0, 10)];
//            self.headerview.moneyLabel.text = self.yesterDayOne;
//        }
//    }
//    if (self.buttonNum == 2) {
//        if (![SVTool isEmpty:self.weekModelArr]) {
//            //求日期
//            self.headerview.dateLabel.text = [self.weekDateArr[section] substringWithRange:NSMakeRange(0, 10)];
//            //金额
//            self.headerview.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.weekMoneyArr[section] floatValue]];
//        }
//    }
//    if (self.buttonNum == 3) {
//        if (![SVTool isEmpty:self.dateModelArr]) {
//            self.headerview.dateLabel.text = [self.dateArr[section] substringWithRange:NSMakeRange(0, 10)];
//            self.headerview.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.dateMoneyArr[section] floatValue]];
//        }
//    }
//
//    //求星期几
//    self.headerview.weekLabel.text = [SVTool weekdayStringFromDate:self.headerview.dateLabel.text];
//
//    return self.headerview;
//
//}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.buttonNum == 1) {
        NSArray *listArr = self.toDayModelArr[section];
        return listArr.count;
    }
    if (self.buttonNum == -1) {
        NSArray *listArr = self.yesterDayModelArr[section];
        return listArr.count;
    }
    if (self.buttonNum == 2) {
        NSArray *listArr = self.weekModelArr[section];
        return listArr.count;
    }
    NSArray *listArr = self.dateModelArr[section];
    return listArr.count;
    
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVQuerySalesCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVQuerySalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellID];
    }
    
    NSDictionary *dic;
    if (self.buttonNum == 1) {
        if (![SVTool isEmpty:self.toDayModelArr]) {
            dic = self.toDayModelArr[indexPath.section][indexPath.row];
        }
    }
    if (self.buttonNum == -1) {
        if (![SVTool isEmpty:self.yesterDayModelArr]) {
            dic = self.yesterDayModelArr[indexPath.section][indexPath.row];
        }
    }
    if (self.buttonNum == 2) {
        if (![SVTool isEmpty:self.weekModelArr]) {
            dic = self.weekModelArr[indexPath.section][indexPath.row];
        }
    }
    if (self.buttonNum == 3) {
        if (![SVTool isEmpty:self.dateModelArr]) {
            dic = self.dateModelArr[indexPath.section][indexPath.row];
        }
    }
    
    SVQuerySalesModel *model = [SVQuerySalesModel mj_objectWithKeyValues:dic];
    
    cell.model = model;
    
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
    
    __weak typeof(self) weakSelf = self;
    if (self.buttonNum == 1) {
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=YES;
        SVSellOrderVC *VC = [[SVSellOrderVC alloc]init];
        VC.dict  = self.toDayModelArr[indexPath.section][indexPath.row];
        VC.sellOrderBlock = ^{
            weakSelf.onePage = 1;
            [weakSelf.toDayModelArr removeAllObjects];
            //提示查询
            [SVTool IndeterminateButtonAction:self.view withSing:@"更新中…"];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [weakSelf getThreeSourcesWithPage:self.onePage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        };
        [self.navigationController pushViewController:VC animated:YES];
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=NO;
    }
    
    if (self.buttonNum == -1) {
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=YES;
        SVSellOrderVC *VC = [[SVSellOrderVC alloc]init];
        VC.dict  = self.yesterDayModelArr[indexPath.section][indexPath.row];
        VC.sellOrderBlock = ^{
            weakSelf.twoPage = 1;
            [weakSelf.yesterDayModelArr removeAllObjects];
            //提示查询
            [SVTool IndeterminateButtonAction:self.view withSing:@"更新中…"];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [weakSelf getThreeSourcesWithPage:self.twoPage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        };
        [self.navigationController pushViewController:VC animated:YES];
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=NO;
    }
    
    if (self.buttonNum == 2) {
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=YES;
        SVSellOrderVC *VC = [[SVSellOrderVC alloc]init];
        VC.dict  = self.weekModelArr[indexPath.section][indexPath.row];
        VC.sellOrderBlock = ^{
            weakSelf.threePage = 1;
            [weakSelf.weekDateArr removeAllObjects];
            [weakSelf.weekMoneyArr removeAllObjects];
            [weakSelf.weekModelArr removeAllObjects];
            //提示查询
            [SVTool IndeterminateButtonAction:self.view withSing:@"更新中…"];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [weakSelf getThreeSourcesWithPage:self.threePage top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@"" keyWords:self.searchSelectName];
        };
        [self.navigationController pushViewController:VC animated:YES];
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=NO;
    }
    
    if (self.buttonNum == 3) {
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=YES;
        SVSellOrderVC *VC = [[SVSellOrderVC alloc]init];
        VC.dict  = self.dateModelArr[indexPath.section][indexPath.row];
        VC.sellOrderBlock = ^{
            weakSelf.fourPage = 1;
            [weakSelf.dateArr removeAllObjects];
            [weakSelf.dateMoneyArr removeAllObjects];
            [weakSelf.dateModelArr removeAllObjects];
            
            //提示查询
            [SVTool IndeterminateButtonAction:self.view withSing:@"更新中…"];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [weakSelf dateRequestResponseEvent];
            
            //            //创建一个日期格式化器
            //            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            //            //设置时间样式
            //            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //            self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
            //            self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
            //
            //            NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
            //            NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
            //
            //            if (temp > tempi) {
            //
            //                [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
            //
            //            } else {
            //                //数据请求
            //                [self getThreeSourcesWithPage:self.fourPage top:20 day:self.buttonNum payname:@"" keys:@"" date:self.oneDate date2:self.twoDate];
            //
            //            }
        };
        [self.navigationController pushViewController:VC animated:YES];
        //隐藏TabBar
        self.hidesBottomBarWhenPushed=NO;
    }
    
    
    
}

#pragma mark - 懒加载

-(SVSelectTwoDatesView *)DateView {
    
    if (!_DateView) {
        _DateView = [[[NSBundle mainBundle] loadNibNamed:@"SVSelectTwoDatesView" owner:nil options:nil] lastObject];
        _DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
        
        [_DateView.cancelButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_DateView.determineButton addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        NSDate *minDate = [NSDate date];
        //设置显示模式
        [_DateView.oneDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        _DateView.oneDatePicker.maximumDate = maxDate;
        _DateView.oneDatePicker.maximumDate = minDate;
        
        //设置显示模式
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        _DateView.twoDatePicker.maximumDate = maxDate;
        _DateView.twoDatePicker.maximumDate = minDate;
        
    }
    
    return _DateView;
}

//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskView addGestureRecognizer:tap];
        
        [_maskView addSubview:_DateView];
    }
    return _maskView;
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
    
}

- (void)twoCancelResponseEvent {
    
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        //提示查询
        //        [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
        [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        self.fourPage = 1;
        [self.dateArr removeAllObjects];
        [self.dateMoneyArr removeAllObjects];
        [self.dateModelArr removeAllObjects];
        //数据请求
        [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:self.oneDate date2:self.twoDate keyWords:self.searchSelectName];
        
    }
    
    
}

-(NSMutableArray *)toDayModelArr {
    if (!_toDayModelArr) {
        _toDayModelArr = [NSMutableArray array];
    }
    return _toDayModelArr;
}

-(NSMutableArray *)yesterDayModelArr {
    if (!_yesterDayModelArr) {
        _yesterDayModelArr = [NSMutableArray array];
    }
    return _yesterDayModelArr;
}

-(NSMutableArray *)weekDateArr{
    if (!_weekDateArr) {
        _weekDateArr = [NSMutableArray array];
    }
    return _weekDateArr;
}

-(NSMutableArray *)weekMoneyArr{
    if (!_weekMoneyArr) {
        _weekMoneyArr = [NSMutableArray array];
    }
    return _weekMoneyArr;
}

-(NSMutableArray *)weekModelArr{
    if (!_weekModelArr) {
        _weekModelArr = [NSMutableArray array];
    }
    return _weekModelArr;
}

-(NSMutableArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

-(NSMutableArray *)dateMoneyArr {
    if (!_dateMoneyArr) {
        _dateMoneyArr = [NSMutableArray array];
    }
    return _dateMoneyArr;
}

-(NSMutableArray *)dateModelArr {
    if (!_dateModelArr) {
        _dateModelArr = [NSMutableArray array];
    }
    return _dateModelArr;
}



@end

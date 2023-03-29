//
//  SVRefundGoodsVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/25.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVRefundGoodsVC.h"
////增加
//#import "SVaddRefundGoodsVC.h"
//cell
#import "SVProcurementListCell.h"
//详情
#import "SVRefundDetailsVC.h"
#import "SVReturnGoodsListVC.h"
#import "SVaddPurchaseVC.h"
//选择时间
#import "SVSelectTwoDatesView.h"

static NSString *RefundGoodsCellID = @"RefundGoodsCell";
@interface SVRefundGoodsVC () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
//搜索的关键词
@property (nonatomic,strong) NSString *keyStr;

@property (nonatomic,strong) NSMutableArray *modelArr;

//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableDictionary *dicCell;

//件数总数
@property (nonatomic,assign) float sumnumber;
@property (nonatomic,assign) float sumoney;

//遮盖view
@property (nonatomic,strong) UIView *maskView;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@property (nonatomic,assign) NSInteger day;

@end

@implementation SVRefundGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示tabBar
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"退货列表";
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SVProcurementListCell" bundle:nil] forCellReuseIdentifier:RefundGoodsCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    self.page = 1;
    self.keyStr = @"";
//<<<<<<< HEAD
//    [self requestDatapageIndex:1 pageSize:20 searchCriteria:@""];
//    
//=======
    self.day = 1;
    self.oneDate = @"";
    self.twoDate = @"";
    //                self.page = 1;
    //                self.type = 1;
    //                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" sdate2:@""];
    [self requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
//    [self requestDatapageIndex:1 pageSize:20 searchCriteria:@""];

//>>>>>>> 1714960... oem退货修改，毛利，收银微信记账
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
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
}
#pragma mark - 时间筛选
- (void)selectbuttonResponseEvent{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"   今天" image:nil target:self action:@selector(logout)];
     // YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"   已入库" image:nil target:self action:@selector(logout)];
    
    cashTitle.foreColor = GlobalFontColor;
   // cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"   昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = GlobalFontColor;
   // menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"   本周" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = GlobalFontColor;
  //  logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"   其他" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = GlobalFontColor;
  //  bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    

    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:GreyFontColor];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待审核，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
//                self.payName = @"现金";
//                [self selectYCXMenuPayName];
                self.navigationItem.rightBarButtonItem.title = @"今天";
                self.day = 1;
                self.oneDate = @"";
                self.twoDate = @"";
//                self.page = 1;
//                self.type = 1;
//                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" sdate2:@""];
                [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
                
            }
                break;
            case 1:
            {

                self.navigationItem.rightBarButtonItem.title = @"昨天";
                self.day = 2;
                [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
//                self.page = 1;
//                 self.type = -1;
//                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
            }
                break;
            case 2:
            {
//                self.payName = @"支付宝";
//                [self selectYCXMenuPayName];
                self.navigationItem.rightBarButtonItem.title = @"本周";
                self.day = 3;
                [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
//                self.page = 1;
//                self.type = 2;
//                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
            }
                break;
            case 3:
            {
                 self.navigationItem.rightBarButtonItem.title = @"其他";
                self.day = 4;
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
                     [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
                     
                     [UIView animateWithDuration:.3 animations:^{
                         self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
                     }];
                
             //   self.page = 1;
                
//                self.type = 3;
//
//                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
            }
                break;

            default:
                break;
        }
    }];
}

- (void)logout {
    
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
        self.page = 1;
        [self requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
        
    }
    
    
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


//添加响应方法
-(void)addWarehouseResponseEvent {
    
//    SVaddRefundGoodsVC *VC = [[SVaddRefundGoodsVC alloc]init];
//    __weak typeof(self) weakSelf = self;
//    VC.addRefundGoodsBlock = ^{
//        weakSelf.page = 1;
//        weakSelf.keyStr = @"";
//        [weakSelf requestDatapageIndex:1 pageSize:20 searchCriteria:@""];
//    };
//    [self.navigationController pushViewController:VC animated:YES];
//    SVReturnGoodsListVC *vc = [[SVReturnGoodsListVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    SVaddPurchaseVC *vc = [[SVaddPurchaseVC alloc] init];
    vc.selectNumber = 2;// 显示退货vc
    __weak typeof(self) weakSelf = self;
    vc.addPurchaseBlock = ^{
        self.page = 1;
         [weakSelf requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.searchBar.placeholder = @"请输入单据号";
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
//    UITextField * searchField = _searchBar.searchTextField;
//    // 输入文本颜色
//    searchField.textColor = GlobalFontColor;
//    searchField.font = [UIFont systemFontOfSize:15];
//    // 默认文本大小
////    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入单据号或商品名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//   // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//    //只有编辑时出现出现那个叉叉
//    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    //添加到view中
//    searchField.backgroundColor = [UIColor whiteColor];
    
    UITextField * searchField;
       if (@available(iOS 13.0, *)) {
           searchField = _searchBar.searchTextField;
             // 输入文本颜色
               searchField.textColor = GlobalFontColor;
           //    searchField.font = [UIFont systemFontOfSize:15];
               
               // 默认文本大小
              // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
               
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入单据号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
       }else{
        // [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
         searchField = [_searchBar valueForKey:@"_searchField"];
            // 输入文本颜色
            searchField.textColor = GlobalFontColor;
           // searchField.font = [UIFont systemFontOfSize:15];
            // 默认文本大小
            [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
          // searchField.placeholder = @"请输入单据号或商品名称";
            //只有编辑时出现那个叉叉
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
       }
     
       
      // searchField.attributedPlaceholder =
       
       //只有编辑时出现那个叉叉
       searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
       searchField.backgroundColor = [UIColor whiteColor];
       searchField.font = [UIFont systemFontOfSize:13];

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
   // [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr];
    [self requestDatapageIndex:self.page pageSize:10 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
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
      //  [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr];
        [self requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
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
//        [self requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr];
      [self requestDatapageIndex:self.page pageSize:20 searchCriteria:self.keyStr day:self.day start_date:self.oneDate end_date:self.twoDate];
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


/**
 请求仓库数据
 @param pageIndex 页数
 @param pageSize 每页几个
 @param searchCriteria 搜索关键词
 */
-(void)requestDatapageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchCriteria:(NSString *)searchCriteria day:(NSInteger)day start_date:(NSString *)start_date end_date:(NSString *)end_date{
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中..."];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/get_returnprocurement_new?key=%@&page=%ld&top=%ld&keywards=%@&pc_noid=%@&suname=%@&type=%@&start_date=%@&end_date=%@&day=%ld",token,pageIndex,pageSize,@"",self.keyStr,@"",@"",start_date,end_date,day];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic = %@",dic);
        if (self.page == 1) {
            
            [self.modelArr removeAllObjects];
        }
        
        if ([dic[@"succeed"] integerValue] == 1)
        {
            NSArray *warehouseList = dic[@"values"][@"list"];
            
            if (![SVTool isEmpty:warehouseList])
            {
                
                for (NSDictionary *diction in warehouseList)
                {
                    
                    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                    [dataDict setObject:diction[@"sv_suname"] forKey:@"sv_suname"];//供应商
                    [dataDict setObject:diction[@"sv_pc_id"] forKey:@"sv_pc_id"];//供应商
                    [dataDict setObject:diction[@"sv_pc_date"] forKey:@"sv_pc_date"];//时期
                    [dataDict setObject:diction[@"sv_pc_noid"] forKey:@"sv_pc_noid"];//退货单号
                    [dataDict setObject:diction[@"sv_pc_total"] forKey:@"sv_pc_total"];//进货单的总额
                    [dataDict setObject:diction[@"sv_pc_statestr"] forKey:@"sv_pc_statestr"];//入库状态
                    [dataDict setObject:diction[@"sv_productname"] forKey:@"sv_productname"];//产品名称
                    [dataDict setObject:diction[@"prlist"] forKey:@"Prlist"];//
                    [dataDict setObject:diction[@"sv_orgwarehouse_id"] forKey:@"sv_orgwarehouse_id"];// 操作人
                    [dataDict setObject:diction[@"sv_pc_operation"] forKey:@"sv_pc_operation"];// 操作人
                    [dataDict setObject:diction[@"sv_suid"] forKey:@"sv_suid"];//供应商
                    [dataDict setObject:diction[@"sv_pc_note"] forKey:@"sv_pc_note"];
                    [dataDict setObject:diction[@"sv_pc_combined"] forKey:@"sv_pc_combined"];//结合
                    [dataDict setObject:diction[@"sv_pc_costs"] forKey:@"sv_pc_costs"];// 其它费用
                    [dataDict setObject:diction[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];// 结算方式
                    [dataDict setObject:diction[@"sv_pc_state"] forKey:@"sv_pc_state"];//判断是否入库
                    [dataDict setObject:diction[@"sv_pc_realpay"] forKey:@"sv_pc_realpay"];// 实付费用
                    [dataDict setObject:diction[@"sv_associated_code"] forKey:@"sv_associated_code"];// 关联入库单号
                    
                    //取总价、总件数
                    self.sumoney = 0;
                    self.sumnumber = 0;
                    for (NSDictionary *dic in diction[@"prlist"]) {
                        self.sumoney = [dic[@"sv_pc_pnumber"] floatValue] * [dic[@"sv_pc_price"] floatValue] + self.sumoney;
                        self.sumnumber = [dic[@"sv_pc_pnumber"] floatValue] + self.sumnumber;
                    }
                    
                    [dataDict setObject:[NSString stringWithFormat:@"%.2f",self.sumoney] forKey:@"sv_pc_price"];// 总价
                    [dataDict setObject:[NSString stringWithFormat:@"%.f",self.sumnumber] forKey:@"sv_pc_pnumber"];// 总件数
                    
                    [self.modelArr addObject:dataDict];
                    
                }
                
            } else {
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
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
    
    SVProcurementListCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundGoodsCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVProcurementListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RefundGoodsCellID];
    }
    
    self.dicCell = self.modelArr[indexPath.row];
    
    cell.sv_pc_noid.text = self.dicCell[@"sv_pc_noid"];
    if ([self.dicCell[@"sv_pc_statestr"] containsString:@"待审核"]) {
       // cell.sv_pc_statestr.hidden = NO;
        cell.caogaoLabel.hidden = NO;
         cell.sv_pc_statestr.text = @"待审核";
    }else{
        cell.caogaoLabel.hidden = YES;
        cell.sv_pc_statestr.text = @"已入库";
    }
    
    cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"]doubleValue]];
    [SVUserManager loadUserInfo];
      NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
       if (kDictIsEmpty(sv_versionpowersDict)) {
           cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"]doubleValue]];
       }else{
           NSDictionary *StockManage = sv_versionpowersDict[@"StockManage"];
           if (kDictIsEmpty(StockManage)) {
               cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"]doubleValue]];
           }else{
        
               // 底部是否添加会员
               NSString *StorEquery_Jurisdiction = [NSString stringWithFormat:@"%@",StockManage[@"ReturnGoods_Price_Total"]];
               if (kStringIsEmpty(StorEquery_Jurisdiction)) {
                   cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"]doubleValue]];
               }else{
                   if ([StorEquery_Jurisdiction isEqualToString:@"1"]) {
                       cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dicCell[@"sv_pc_total"]doubleValue]];
                   }else{
                       cell.sv_pc_total.text = @"***";
                   }
               }
              
           }
                                     
       }
   
    cell.sv_suname.text = self.dicCell[@"sv_suname"];

    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

//点击响应方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SVRefundDetailsVC *VC = [[SVRefundDetailsVC alloc]init];
    __weak typeof(self) weakSelf = self;
    VC.addRefundGoodsBlock = ^{
        weakSelf.page = 1;
             weakSelf.keyStr = @"";
             weakSelf.searchBar.text = nil;
             //调用请求
           //  [self requestDatapageIndex:1 pageSize:20 searchCriteria:self.keyStr];
             [weakSelf requestDatapageIndex:weakSelf.page pageSize:20 searchCriteria:weakSelf.keyStr day:weakSelf.day start_date:weakSelf.oneDate end_date:weakSelf.twoDate];
    };
    VC.dic = self.modelArr[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableDictionary *)dicCell{
    if (!_dicCell) {
        _dicCell = [NSMutableDictionary dictionary];
    }
    return _dicCell;
}



@end

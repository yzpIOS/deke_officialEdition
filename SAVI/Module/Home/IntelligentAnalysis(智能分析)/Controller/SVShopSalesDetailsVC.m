//
//  SVShopSalesDetailsVC.m
//  SAVI
//
//  Created by houming Wang on 2020/12/22.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVShopSalesDetailsVC.h"
#import "SVShopSalesDetailsCell.h"
#import "SVSelectTwoDatesView.h"
#import "SVDetailsHistoryModel.h"

static NSString *const ID = @"SVShopSalesDetailsCell";
@interface SVShopSalesDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

//遮盖view
@property (nonatomic,strong) UIView *maskView;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *saleNumber; // 销售数量
@property (weak, nonatomic) IBOutlet UILabel *saleMoney; // 销售金额
@property (weak, nonatomic) IBOutlet UILabel *saleCount; // 销售笔数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;


@end

@implementation SVShopSalesDetailsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品销售明细";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
    self.bottom.constant = BottomHeight;
  
    [self.tableView registerNib:[UINib nibWithNibName:@"SVShopSalesDetailsCell" bundle:Nil] forCellReuseIdentifier:ID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    self.tableView.allowsSelection=NO;
    self.oneDate = @"";
    self.twoDate = @"";
    self.type = 1;
    [self setUpDataProduct_id:self.product_id];
    
}

- (void)setUpDataProduct_id:(NSString *)product_id{
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    // self.type = @"1"; // 默认是今天
    self.page = 1;
    //
    [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:product_id];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:product_id];
        
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
    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.scrollView.mj_header = header;
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //  self.isSelect = YES;
        //调用请求
        //        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@""];
     [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:product_id];
        
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
    
    self.scrollView.mj_footer.hidden = YES;
    
    self.scrollView.mj_footer = footer;
}

- (void)loadGetProductAnalysisDetailsType:(NSInteger)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2 product_id:(NSString *)product_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL;
    if (self.type == 4) {
      dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductAnalysisDetails?key=%@&type=%li&page=%ld&top=%ld&date=%@&date2=%@&product_id=%@",token,(long)type,(long)page,(long)top,date,[NSString stringWithFormat:@"%@ 23:59:59",date2],product_id];
        NSLog(@"dURL = %@",dURL);
    }else{
       dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductAnalysisDetails?key=%@&type=%li&page=%ld&top=%ld&product_id=%@",token,(long)type,(long)page,(long)top,product_id];
        NSLog(@"dURL = %@",dURL);
    }
   
     NSString *utf = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic9999 = %@",dic);

        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.saleMoney.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"order_receivable"]doubleValue]];
                self.saleNumber.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"count"]];
                self.saleCount.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"orderciunt"]];
            }
            NSArray *list = dic[@"values"][@"list"];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.saleMoney.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"order_receivable"]];
                self.saleNumber.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"count"]];
                self.saleCount.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"orderciunt"]];
            }
            if (!kArrayIsEmpty(list)) {
                NSMutableArray *listM = [SVDetailsHistoryModel mj_objectArrayWithKeyValuesArray:list];
                 
                 [self.dataArray addObjectsFromArray:listM];
            }
           
        }else{
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        self.twoViewHeight.constant =37+ self.dataArray.count * 80;
        [self.tableView reloadData];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    
}

#pragma mark - 会员分析
- (void)selectMemberButtonResponseEvent{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor = [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = [UIColor colorWithHexString:@"666666"];
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"本周" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = [UIColor colorWithHexString:@"666666"];
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"其他" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = [UIColor colorWithHexString:@"666666"];
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];

    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
                self.oneDate = @"";
                self.twoDate = @"";
                self.page = 1;
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
                self.type = 1;
                [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:self.product_id];
                
            }
                break;
            case 1:
            {
                self.oneDate = @"";
                self.twoDate = @"";
                self.page = 1;
                 self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
                self.type = 2;
                [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:self.product_id];

            }
                break;
            case 2:
            {
                self.oneDate = @"";
                self.twoDate = @"";
                self.page = 1;
                 self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
                self.type = 3;
                [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:self.product_id];

            }
                break;
            case 3:
            {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectMemberButtonResponseEvent)];
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
                
                [UIView animateWithDuration:.3 animations:^{
                    self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
                }];

            }
                break;
            default:
                break;
        }
    }];
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
    
        self.type = 4;
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self loadGetProductAnalysisDetailsType:self.type Page:self.page top:20 date:self.oneDate date2:self.twoDate product_id:self.product_id];
        
//        if ([self.titleNumber isEqualToString:@"1"]) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            dic[@"type"] = @"4";// 昨天
//            dic[@"oneDate"] = self.oneDate;
//            dic[@"twoDate"] = self.twoDate;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName1" object:nil userInfo:dic];
//        }else if ([self.titleNumber isEqualToString:@"2"]){
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            dic[@"type"] = @"3";// 其他
//            dic[@"oneDate"] = self.oneDate;
//            dic[@"twoDate"] = self.twoDate;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName2" object:nil userInfo:dic];
//        }else{// 商品分析
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            dic[@"type"] = @"4";// 其他
//            dic[@"oneDate"] = self.oneDate;
//            dic[@"twoDate"] = self.twoDate;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyName3" object:nil userInfo:dic];
//        }
//
        
    }
    
    
}

- (void)oneCancelResponseEvent{
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVShopSalesDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[SVShopSalesDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SVDetailsHistoryModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}


- (void)logout{
    
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
@end

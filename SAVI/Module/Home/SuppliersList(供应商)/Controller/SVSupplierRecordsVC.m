//
//  SVSupplierRecordsVC.m
//  SAVI
//
//  Created by houming Wang on 2021/4/30.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSupplierRecordsVC.h"
#import "UIView+Ext.h"
#import "SVSupplierRecordsCell.h"
#import "SVReconciliationModel.h"
#import "SVSelectTwoDatesView.h"
static NSString *const ID = @"SVSupplierRecordsCell";
@interface SVSupplierRecordsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString * keyStr;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,strong) SVSelectTwoDatesView * DateView;
@property (nonatomic,strong) UIView *maskTheView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@property (nonatomic,strong) UIImageView *img;
//搜索的关键词
//@property (nonatomic,strong) NSString *keyStr;
@property (nonatomic,strong) UITextField * textField;
@end

@implementation SVSupplierRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供应记录";
    
    [self setUI];
}

- (void)setUI{
    self.oneDate = @"";
    self.twoDate = @"";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    view.backgroundColor = navigationBackgroundColor;
    [self.view addSubview:view];
    self.view.backgroundColor = BackgroundColor;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(20, 6, ScreenW - 40, 38)];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor colorWithRed:121/255.0f green:142/255.0f blue:235/255.0f alpha:1];
    searchView.layer.cornerRadius = 19;
    searchView.layer.masksToBounds = YES;
    UIImageView *icon = [[UIImageView alloc] init];
//    icon.contentMode = UIViewContentModeScaleAspectFit;
    [searchView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchView.mas_left).offset(10);
        make.centerY.mas_equalTo(searchView.mas_centerY);
    }];
//   // [icon sizeToFit];
//    icon.centerY = searchView.centerY;
////    icon.X = 10;
    icon.image = [UIImage imageNamed:@"sousuo"];
    
    UITextField *searchField = [[UITextField alloc] init];
    
  //  searchText.placeholder = @"输入进货单号";
    [searchView addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(10);
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.height.mas_equalTo(38);
    }];
    
  //  UITextField * searchField;
//    if (@available(iOS 13.0, *)) { // iOS 11
      //  searchField = _searchBar.searchTextField;
        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入进货单号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
           // 输入文本颜色
           searchField.textColor = [UIColor whiteColor];
           searchField.font = [UIFont systemFontOfSize:12];
           searchField.backgroundColor = [UIColor clearColor];
//    }else{
//     //   searchField =  [_searchBar valueForKey:@"_searchField"];
//        // 默认文本大小
//        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入进货单号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
//
//        if (searchField) {
//              [searchField setBackgroundColor:[UIColor clearColor]];
//          }
//          // 输入文本颜色
//          searchField.textColor = [UIColor whiteColor];
//          searchField.font = [UIFont systemFontOfSize:12];
//    }
    
  //  self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(view.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
   // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSupplierRecordsCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
    [self addSetUpRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
   // [self addSearchBar];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)selectbuttonResponseEvent{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
}

- (void)addSetUpRefresh{
//    /*仓库/店铺id（非仓库调拨列表支持仓库。店铺，仓库调拨列表只支持仓库id）*/
//    private int id;
//    /*自定义模糊查询 跟业务查询*/
//    private String keywards;
//    /*页数*/
//    private int page;
//    /*页码*/
//    private int pagesize;
//    /*供应商*/
//    private String supp_id;
//    /*账款状态  全部 -1，有欠款=1无欠款 0*/
//    private int state1;
//    /*开始时间*/
//    private String start_date;
//    /*结束时间*/
//    private String end_date;
//    /* 状态 是否启用 1启用，0暂停，-1全部*/
//    private int sv_enable;
//    /*单据类型*/
//    private int sv_order_type;
//    /*制单人-1全部*/
//    private int reviewer_by;
//    /*状态 -1全部 -2 非已作废（已删除）*/
//    private int state;
    self.page = 1;
    self.keyStr = @"";
   // self.searchBar.text = nil;
    //调用请求
  //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
    [self Getprocurement_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.keyStr = @"";
       // self.searchBar.text = nil;
        //调用请求
      //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [self Getprocurement_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
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
        [self Getprocurement_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
        
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *Str = textField.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //调用请求
    self.page = 1;
    [self Getprocurement_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
    
    [textField resignFirstResponder];
}

//退出键盘响应方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //移除第一响应者
    [self.textField resignFirstResponder];

}
/**
 {
     "id": 0,
     "state": 0,
     "start_date": "2019-05-07 00:00",
     "pagesize": "20",
     "end_date": "2021-05-07 23:59",
     "reviewer_by": 0,
     "state1": -1,
     "sv_order_type": 0,
     "supp_id": "45198",
     "keywards": "",
     "sv_enable": -1,
     "page": "1"
 }
 */

- (void)Getprocurement_supplier_list:(NSInteger)page pagesize:(NSInteger)pagesize keyStr:(NSString *)keyStr{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/StockInOutManage/Getprocurement_supplier_list?key=%@",token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"id"] = [NSNumber numberWithInt:-1];
    parame[@"keywards"] = keyStr;
    parame[@"page"] = [NSString stringWithFormat:@"%ld",page];
    parame[@"pagesize"] = [NSString stringWithFormat:@"%ld",pagesize];
    parame[@"reviewer_by"] = [NSNumber numberWithInt:-1];
    parame[@"state"] =[NSNumber numberWithInt:-2];
    parame[@"state1"] = [NSNumber numberWithInt:0];
    parame[@"supp_id"] = self.supp_id;
    parame[@"sv_enable"] =[NSNumber numberWithInt:0];
    parame[@"sv_order_type"] = [NSNumber numberWithInt:0];
    if (!kStringIsEmpty(self.oneDate)) {
        parame[@"start_date"] = [NSString stringWithFormat:@"%@ 00:00",self.oneDate];
    }
    
    if (!kStringIsEmpty(self.twoDate)) {
        parame[@"end_date"] = [NSString stringWithFormat:@"%@ 23:59",self.twoDate];
    }

    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
           
            //有多少位供应高
          //  self.labelB.text = [NSString stringWithFormat:@"%@",listDic[@"total"]];
            
            NSArray *dataList = data[@"list"];
            
            //判断如果为1时，清理模型数组
            if (page == 1) {
                
                [self.modelArr removeAllObjects];
                
            }
            
            if (![SVTool isEmpty:dataList]) {
                
              //  self.noLabel.hidden = YES;
                
                self.modelArr = [SVReconciliationModel mj_objectArrayWithKeyValuesArray:dataList];
                
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
                
            } else {
                
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                //提示没有供应商
//                if (self.modelArr.count == 0) {
//                  //  self.noLabel.hidden = NO;
//                }
                
            }
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        if (kArrayIsEmpty(self.modelArr)) {
            [self.img removeFromSuperview];
                  UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                 self.img = img;
                  [self.tableView addSubview:img];
                  [img mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.center.mas_equalTo(self.tableView);
                      make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                  }];
            self.tableView.backgroundColor = [UIColor whiteColor];
        }else{
            [self.img removeFromSuperview];
            self.tableView.backgroundColor = BackgroundColor;
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
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSupplierRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVSupplierRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.modelArr[indexPath.row];
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159;
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

/**
 日期遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}
- (void)vipCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
  //  [self.genderPickerView removeFromSuperview];
  //  [self.TwovipPickerView removeFromSuperview];
}
//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskTheView removeFromSuperview];
    
    [UIView animateWithDuration:.3 animations:^{
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
        //数据请求

      //  [self getThreeSourcesWithPage:self.fourPage top:10 day:self.buttonNum payname:self.payName date:self.oneDate date2:self.twoDate keyWords:self.searchSelectName type:self.type liushui:self.liushui storeid:self.storeid seller:self.sv_employee_id memberId:self.memberId orderSource:self.orderSource product:self.product seachMemberStr:self.seachMemberStr];
        
        self.page = 1;
        self.keyStr = @"";
       // self.searchBar.text = nil;
        //调用请求
      //  [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
        [self Getprocurement_supplier_list:self.page pagesize:20 keyStr:self.keyStr];
        
    }
    
//    //创建一个日期格式化器
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//    //设置时间样式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//   // dateFormatter.dateStyle = UIDatePickerModeDateAndTime;
//    NSString *oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
//    NSString *twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
//
//    NSInteger temp = [SVDateTool cTimestampFromString:oneDate format:@"yyyy-MM-dd"];
//    NSInteger tempi = [SVDateTool cTimestampFromString:twoDate format:@"yyyy-MM-dd"];
////    self.Stock_date_start = @"";
////    self.Stock_date_end = @"";
//    if (temp > tempi) {
//
//        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
//
//    } else {
//        //提示查询
//        //        [SVTool IndeterminateButtonActionWithSing:@"查询中…"];
//        [SVTool IndeterminateButtonAction:self.view withSing:@"查询中…"];
//        self.oneDate = oneDate;
//        self.twoDate = twoDate;
//        self.Stock_date_start = oneDate;
//        self.Stock_date_end = twoDate;
//        self.choiceTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",oneDate,twoDate];
//    }
    
    
}

@end

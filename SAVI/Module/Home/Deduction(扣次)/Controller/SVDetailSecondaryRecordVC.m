//
//  SVDetailSecondaryRecordVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVDetailSecondaryRecordVC.h"
#import "SVSecondaryRecordCell.h"
#import "SVCardRechargeInfoModel.h"
#import "SVSecondaryRecordModel.h"
#import "SVSelectTwoDatesView.h"

static NSString * const ID = @"SVSecondaryRecordCell";
@interface SVDetailSecondaryRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *dt1;
@property (nonatomic,strong) NSString *dt2;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;

//遮盖view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;


@end

@implementation SVDetailSecondaryRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSecondaryRecordCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 设置tableView的估算高度
    self.tableView.estimatedRowHeight = 60;
    
    self.day = @"1";
    self.dt1 = @"";
    self.dt2 = @"";
    
    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    
    
    //调用请求
    //    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@""];
    [self getDataPage:self.page top:10];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        // [self.goodsArr removeAllObjects];
        //调用请求
        [self getDataPage:self.page top:10];
        
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
    
    self.tableView.mj_header = header;
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        
        //调用请求
        [self getDataPage:self.page top:10];
        
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
    
    //    NSArray *idleImages = [NSArray arrayWithObject:[UIImage imageNamed:@"MJRefresh_arrowDown"]];
    //    NSArray *pullingImages = [NSArray arrayWithObject:[UIImage imageNamed:@"MJRefresh_arrow"]];
    //    //1.设置普通状态的动画图片
    //    [footer setImages:pullingImages forState:MJRefreshStateIdle];
    //    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    [footer setImages:idleImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.mj_footer = footer;
    
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"notifyName2" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notifyName2" object:nil];
}

//实现方法
-(void)notification2:(NSNotification *)noti{
    
    //使用object处理消息
    NSMutableDictionary *dict = [noti object];
    self.day = dict[@"day"];
    self.dt1 = dict[@"dt1"];
    self.dt2 = dict[@"dt2"];
    self.page = 1;
    
    // [self.goodsArr removeAllObjects];
    //调用请求
    [self getDataPage:self.page top:10];
//    NSLog(@"接收 object传递的消息：%@",info);
    
    
}

- (void)getDataPage:(NSInteger)page top:(NSInteger)top
{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/GetSetmealChargeDetailList?key=%@&page=%li&pagesize=%li&sv_charge_type=1&member_id=%@&product_id=%@&sv_serialnumber=%@&dt1=%@&dt2=%@&day=%@",[SVUserManager shareInstance].access_token,(long)page,(long)top,self.member_id,self.model.product_id,self.model.sv_serialnumber,self.dt1,self.dt2,self.day];
    NSLog(@"urlStr====---%@",urlStr);
     NSString *utf = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic555 333====---%@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArray = dic[@"values"][@"dataList"];
            if (!kArrayIsEmpty(dataArray)) {
                self.dataArray = [SVSecondaryRecordModel mj_objectArrayWithKeyValuesArray:dataArray];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSecondaryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVSecondaryRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
        //        //UIDatePicker时间范围限制
        //        _DateView.oneDatePicker.maximumDate = maxDate;
        //        _DateView.oneDatePicker.maximumDate = minDate;
        
        //设置显示模式
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
        //        //UIDatePicker时间范围限制
        //        _DateView.twoDatePicker.maximumDate = maxDate;
        //        _DateView.twoDatePicker.maximumDate = minDate;
        
    }
    
    return _DateView;
}


- (void)twoCancelResponseEvent{
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
//    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSString *oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    NSString *twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        self.oneDate = oneDate;
        self.twoDate = twoDate;
//        self.time.text = [NSString stringWithFormat:@"%@ 至 %@",self.oneDate,self.twoDate];
//        self.time.textColor = GlobalFontColor;
        
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

- (void)oneCancelResponseEvent{
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
}
@end

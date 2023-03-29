//
//  SVWaresRecordVC.m
//  SAVI
//
//  Created by Sorgle on 2017/10/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVWaresRecordVC.h"
//Cell
#import "SVWaresRecordCell.h"
//模型
#import "SVWaresRecordModel.h"
#import "SVWaresListCell_two.h"
#import "SVSelectTwoDatesView.h"

static NSString *WaresRecordID = @"WaresRecordCell";
static NSString *SVWaresListCell_twoID = @"SVWaresListCell_two";
@interface SVWaresRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *number;

// 模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UILabel *unit;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
//遮盖view
@property (nonatomic,strong) UIView *maskView;
/**
 记录刷新次数
 */
@property (nonatomic,assign) NSInteger page;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@property (nonatomic,assign) NSInteger onePage;
@end

@implementation SVWaresRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"销售记录";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"销售记录";
    if (self.sv_is_newspec == 1) {
        self.twoView.hidden = NO;
    }else{
        self.twoView.hidden = YES;
    }
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 81, ScreenW, ScreenH - 81 - 64)];
    //去掉多余的分割线,显示cell还有线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.oneDate = @"";
    self.twoDate = @"";
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVWaresRecordCell" bundle:nil] forCellReuseIdentifier:WaresRecordID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVWaresListCell_two" bundle:nil] forCellReuseIdentifier:SVWaresListCell_twoID];
    
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.onePage = 1;
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    //调用请求
    if (self.sv_is_newspec == 0) {
        [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@""];
    }else{
        [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@"true"];
    }
    
    //  self.page = 1;
    //  [self getDataPageIndex:self.page pageSize:20];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"日期选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    //刷新
    [self setupRefresh];
    
  //  self.unit.text = self.unitName;
    
}




-(void)setupRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.onePage = 1;
        [SVUserManager loadUserInfo];
        NSString *token = [SVUserManager shareInstance].access_token;
        
        //数据请求
        if (self.sv_is_newspec == 0) {
            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@""];
        }else{
            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@"true"];
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
        
        
        self.onePage ++;
        //数据请求
        //  [self getThreeSourcesWithPage:self.onePage top:20 productId:@"" keys:@"" date:@"" date2:@"" is_spec:@"true"];
        [SVUserManager loadUserInfo];
        NSString *token = [SVUserManager shareInstance].access_token;
        if (self.sv_is_newspec == 0) {
            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@""];
        }else{
            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@"true"];
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

//getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:@"" date2:@"" is_spec:@""
- (void)getThreeSourcesWithPage:(NSInteger)page top:(NSInteger)top productId:(NSString *)productId keys:(NSString *)key date:(NSString *)date date2:(NSString *)date2 is_spec:(NSString *)is_spec{
    
    NSString *strURL = [URLhead stringByAppendingFormat:@"/intelligent/GetProductOrderList?key=%@&productId=%@&pageIndex=%ld&pageSize=%ld&start=%@&end=%@&is_spec=%@",key,productId,(long)page,(long)top,date,[NSString stringWithFormat:@"%@ 23:59:59",date2],is_spec];
  //  [NSString stringWithFormat:@"%@ 23:59:59",dt2]
    NSString *utf = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //请求
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *valuesDic = dic[@"values"];
        
        NSArray *listArr = valuesDic[@"list"];
        
        self.number.text = [NSString stringWithFormat:@"%@",valuesDic[@"total"]];
        
        NSLog(@"listArr = %@",listArr);
        //判断如果为1时，清理模型数组
        if (self.onePage == 1) {
            [self.modelArr removeAllObjects];
        }
        
        //判断数组是否请求完了
        if (![SVTool isEmpty:listArr]) {
            
            for (NSDictionary *dict in listArr) {
                
                //字典转模型
                SVWaresRecordModel *model = [SVWaresRecordModel mj_objectWithKeyValues:dict];
                
                [self.modelArr addObject:model];
            }
            
           
            
            self.tableView.mj_footer.state = MJRefreshStateIdle;
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            // [SVTool TextButtonAction:self.view withSing:@"本周内暂无数据"];
            /** 所有数据加载完毕，没有更多的数据了 */
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
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
        
         [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - tableVeiw

//展示几组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib的cell的创建
    
    if (self.sv_is_newspec == 1) {
        SVWaresListCell_two *cell = [tableView dequeueReusableCellWithIdentifier:SVWaresListCell_twoID forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SVWaresListCell_two" owner:nil options:nil].lastObject;
        }
        //取消高亮
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.modelArr[indexPath.row];
        
        
        return cell;
    }else{
        SVWaresRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:WaresRecordID forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SVWaresRecordCell" owner:nil options:nil].lastObject;
        }
        //取消高亮
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.modelArr[indexPath.row];
        
        
        return cell;
    }
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}


- (void)selectbuttonResponseEvent{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
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

- (void)twoCancelResponseEvent{
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
        //  [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        //                self.fourPage = 1;
        //                [self.dateArr removeAllObjects];
        //                [self.dateMoneyArr removeAllObjects];
        //                [self.dateModelArr removeAllObjects];
        //数据请求
        //                [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:self.oneDate date2:self.twoDate];
        [SVUserManager loadUserInfo];
        NSString *token = [SVUserManager shareInstance].access_token;
        if (self.sv_is_newspec == 0) {
            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@""];
        }else{
            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@"true"];
        }
        
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

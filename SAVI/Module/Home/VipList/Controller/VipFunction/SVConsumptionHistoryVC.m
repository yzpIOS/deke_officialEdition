//
//  SVConsumptionHistoryVC.m
//  SAVI
//
//  Created by Sorgle on 2017/7/2.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVConsumptionHistoryVC.h"
//#import "SVHistoryCell.h"
#import "SVHistoryListCell.h"
//模型
//#import "SVHistoryModel.h"
#import "SVHistoryDateilsModel.h"
//销售详情
//#import "SVSellOrderVC.h"
#import "SVHistoryDetailsVC.h"
#import "SVSelectTwoDatesView.h"

@interface SVConsumptionHistoryVC () <UITableViewDelegate,UITableViewDataSource>

//tableView
@property (nonatomic,strong) UITableView *tableView;

/**
 模型数组
 */
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,strong) NSMutableArray *prlistArr;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
//遮盖view
@property (nonatomic,strong) UIView *maskView;

//件数总数
@property (nonatomic,assign) float sum;
@property (nonatomic,assign) NSInteger day;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@end

@implementation SVConsumptionHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消费记录";
    self.oneDate = @"";
    self.twoDate = @"";
    self.day = 0;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight-BottomHeight)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVHistoryListCell" bundle:nil] forCellReuseIdentifier:@"HistoryCell"];
    
    //提示加载中
    [SVTool IndeterminateButtonAction:self.tableView withSing:@"加载中…"];
    self.page = 1;
    [self getOrderListWithPage:self.page top:20 keys:self.memberID day:self.day date:self.oneDate date2:self.twoDate];
   
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEventNav)];
    
    [self setupRefresh];
}

#pragma mark - 日常分析
- (void)selectbuttonResponseEventNav{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
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
               // self.payName = @"现金";
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEventNav)];
                self.day = 0;
               // self.selectNum = 0;
                [self selectYCXMenuPayName];
                
            }
                break;
            case 1:
            {
              //  self.payName = @"微信支付";
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEventNav)];
               //  self.selectNum = 1;
                self.day = -1;
                [self selectYCXMenuPayName];
            }
                break;
            case 2:
            {
               // self.payName = @"支付宝";
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEventNav)];
                // self.selectNum = 2;
                self.day = 2;
               [self selectYCXMenuPayName];
            }
                break;
            case 3:
            {
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEventNav)];
              //  self.selectNum = 3;
                //self.payName = @"银行卡";
                self.day = 3;
             // [self selectYCXMenuPayName];
                [self selectbuttonResponseEvent];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)selectYCXMenuPayName{
    self.page = 1;
    [self getOrderListWithPage:self.page top:20 keys:self.memberID day:self.day date:self.oneDate date2:self.twoDate];
}


-(void)setupRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        //        [SVUserManager loadUserInfo];
        //        NSString *token = [SVUserManager shareInstance].access_token;
        
        //数据请求
        [self getOrderListWithPage:self.page top:20 keys:self.memberID day:self.day date:self.oneDate date2:self.twoDate];
        
        
        
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
        
        self.page ++;
        //数据请求
        //  [self getThreeSourcesWithPage:self.onePage top:20 productId:@"" keys:@"" date:@"" date2:@"" is_spec:@"true"];
        [SVUserManager loadUserInfo];
        [self getOrderListWithPage:self.page top:20 keys:self.memberID day:self.day date:self.oneDate date2:self.twoDate];
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


-(void)getOrderListWithPage:(NSInteger)page top:(NSInteger)top keys:(NSString*)keys day:(NSInteger)day date:(NSString *)date date2:(NSString *)date2{
    
    [SVUserManager loadUserInfo];
    NSString *sURL=[URLhead stringByAppendingFormat:@"/intelligent/GetIntelligentSalesLists?isAntiSettlement=false&isexport=0&key=%@&page=%li&pagesize=%li&memberId=%@&day=%li&date=%@&date2=%@&type=-1&orderSource=-1&storeid=-1",[SVUserManager shareInstance].access_token,(long)page,(long)top,keys,(long)day,date,[NSString stringWithFormat:@"%@ 23:59:59",date2]];
    NSString *utf = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dic === %@",dic);
        
        //判断如果为1时，清理模型数组
        if (self.page == 1) {
            [self.modelArr removeAllObjects];
        }
        
        if ([dic[@"succeed"] intValue] == 1) {
            
            if (![SVTool isEmpty:[dic objectForKey:@"values"]]) {
                NSArray *orderList = dic[@"values"][@"orderList"];
                for (NSDictionary *dict in orderList) {
                    
                    //用字典来重新整理处理数据
                    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                    
                    //取到商品名
                    self.prlistArr = [dict objectForKey:@"prlist"];//取到字典里的数组
                    
                   // NSDictionary *nameDic = [self.prlistArr firstObject];//取到数组里的字典
                    
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"sv_mr_name"]] forKey:@"product_name"];//这里有一个报错3.22
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"order_datetime"]] forKey:@"time"];
                    
                    //支付方式
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"order_payment"]] forKey:@"order_payment"];
                    //退货
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"order_state"]] forKey:@"order_state"];
                    //金额
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"order_money"]] forKey:@"order_money"];
                    // 规格
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"sv_p_specs"]] forKey:@"sv_p_specs"];
                    // 消费店铺
                    [dataDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"consumeusername"]] forKey:@"consumeusername"];
                    //件数
                    self.sum = 0;
                    for (NSDictionary *diction in self.prlistArr) {
                        self.sum = [diction[@"product_num"] floatValue] + self.sum;
                    }
                    [dataDict setObject:[NSString stringWithFormat:@"%.f",self.sum] forKey:@"product_num"];
                    
                    //商品详情数组
                    [dataDict setObject:[dict objectForKey:@"prlist"] forKey:@"prlistArr"];
             
                    
                    //添加到模型数组中
                    [self.modelArr addObject:dataDict];
                    
                }
                self.tableView.mj_footer.state = MJRefreshStateIdle;
                //隐藏提示框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            } else {
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            
            //一定要记得刷新tableView的数据
            [self.tableView reloadData];
            
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
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        //       [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
    
    
}

#pragma mark - tableVeiw

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
    //    return 2;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVHistoryListCell" owner:nil options:nil].lastObject;
    }
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = self.modelArr[indexPath.row];
    
    //赋值
    cell.name.text = [dict objectForKey:@"product_name"];
    //价钱
    cell.unitprice.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"order_money"] floatValue]];
    cell.ConsumerShop.text = [dict objectForKey:@"consumeusername"];
    //支付方式
    //显示时间
    NSString *timeString = [dict objectForKey:@"time"];
    cell.pay.text = [NSString stringWithFormat:@"%@ %@",[timeString substringToIndex:10],[timeString substringWithRange:NSMakeRange(11, 8)]];
    //数量
    cell.number.text = [dict objectForKey:@"product_num"];
    //退货
    NSString *state = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_state"]];
    float stateNum = [state floatValue];
    if (stateNum == 0) {
        cell.returnWares.hidden = YES;
    } else if (stateNum == 1){
        cell.returnWares.text = @"部分退货";
        cell.returnWares.hidden = NO;
    }else if (stateNum == 2){
        cell.returnWares.text = @"整单退货";
        cell.returnWares.hidden = NO;
    }
    
    if ([[dict objectForKey:@"order_payment"] isEqualToString:@"现金"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_cash"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"储值卡"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_stored"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"支付宝"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_treasure"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"银行卡"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_unionpay"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"微信支付"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_wechat"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"优惠券"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_coupons"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"美团"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_regiment"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"口碑"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_publicpraise"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"闪惠"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_shanhui"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"赊账"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_owe"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"饿了么"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_hungry"];
    } else if ([[dict objectForKey:@"order_payment"] isEqualToString:@"百度"]) {
        cell.icon.image = [UIImage imageNamed:@"sales_baidu"];
    }
    
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVHistoryDetailsVC *VC = [[SVHistoryDetailsVC alloc]init];
    VC.dic = self.modelArr[indexPath.row];
    //跳转界面有导航栏的
    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - 懒加载

-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)prlistArr{
    if (!_prlistArr) {
        _prlistArr = [NSMutableArray array];
    }
    return _prlistArr;
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
        //        [SVUserManager loadUserInfo];
        //        NSString *token = [SVUserManager shareInstance].access_token;
        //        if (self.sv_is_newspec == 0) {
        self.page = 1;
        self.day = 3;
        //调用请求
        [self getOrderListWithPage:self.page top:20 keys:self.memberID day:self.day date:self.oneDate date2:self.twoDate];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"日期选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEventNav)];
        //        }else{
        //            [self getThreeSourcesWithPage:self.onePage top:20 productId:self.productID keys:token date:self.oneDate date2:self.twoDate is_spec:@"true"];
        //        }
        
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

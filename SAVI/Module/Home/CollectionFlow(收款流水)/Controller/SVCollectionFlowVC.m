//
//  SVCollectionFlowVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/5/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCollectionFlowVC.h"
#import "SVCollectionFlowCell.h"
#import "SVCollectionFlowDetailVC.h"
#import "SVSelectTwoDatesView.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#import "SVCollectionRefundVC.h"

static NSString *const ID = @"SVCollectionFlowCell";
@interface SVCollectionFlowVC ()<UITableViewDelegate,UITableViewDataSource,CollectionRefundDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UILabel *selectTimeLabel;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
//遮盖view
@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) NSMutableArray *datasArray;

@property (nonatomic,strong) NSString *PaymentType;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UIImageView *img;


@end

@implementation SVCollectionFlowVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVCollectionFlowCell" bundle:nil] forCellReuseIdentifier:ID];
    self.title = @"收款流水";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //正确创建方式，这样显示的图片就没有问题了
    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saosao"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonResponseEvent)];
    self.navigationItem.rightBarButtonItem = rightButon;

    //适配ios11偏移问题
       UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
       self.navigationItem.backBarButtonItem = backltem;

    self.allBtn.layer.cornerRadius = 15;
    self.allBtn.layer.masksToBounds = YES;

    self.allBtn.layer.borderWidth = 1;
    self.allBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectbuttonResponseEvent)];
    [self.timeView addGestureRecognizer:tap];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

       // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

       [formatter setDateFormat:@"yyyy-MM-dd"];

       //现在时间,你可以输出来看下是什么格式

       NSDate *datenow = [NSDate date];

       //----------将nsdate按formatter格式转成nsstring

       NSString *currentTimeString = [formatter stringFromDate:datenow];

//    self.selectTimeLabel.text = [NSString stringWithFormat:@"%@ -- %@",self.oneDate,self.twoDate];
    self.selectTimeLabel.text = [NSString stringWithFormat:@"%@ -- %@",currentTimeString,currentTimeString];
    self.oneDate = currentTimeString;
    self.twoDate = currentTimeString;
    self.PaymentType = @"";
    self.page = 1;
    [self loadDataOrderStatus:1 startTime:currentTimeString endTime:currentTimeString paymentType:self.PaymentType queryId:@""];

}

- (void)loadDataOrderStatus:(NSInteger)OrderStatus startTime:(NSString *)startTime endTime:(NSString *)endTime paymentType:(NSString *)paymentType queryId:(NSString *)queryId{

    [self loadCollectionReportOrderStatus:OrderStatus StartTime:startTime EndTime:endTime PaymentType:paymentType QueryId:queryId PageIndex:self.page PageSize:10];

    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{

//        self.page = 1;
//        self.listView.searchWares.text = nil;
//        //
//        self.isSelect = NO;
//        self.isAllSelect = NO;
//        self.listView.allSelectButton.selected = NO;
//        [self.goodsArr removeAllObjects];
        //调用请求
       [self loadCollectionReportOrderStatus:OrderStatus StartTime:startTime EndTime:endTime PaymentType:paymentType QueryId:@"" PageIndex:self.page PageSize:10];

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
    //    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];

    //    NSArray *imageArr = [NSArray arrayWithObjects:
    //                           [UIImage imageNamed:@"MJRefresh_arrowDown"],
    //                           [UIImage imageNamed:@"MJRefresh_arrow"],nil];
    //    //1.设置普通状态的动画图片
    ////    [header setImages:idleImages forState:MJRefreshStateIdle];
    //    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    [header setImages:imageArr forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];

    self.tableView.mj_header = header;


    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{

        self.page ++;
       // self.isSelect = YES;
        //调用请求
      [self loadCollectionReportOrderStatus:OrderStatus StartTime:startTime EndTime:endTime PaymentType:paymentType QueryId:@"" PageIndex:self.page PageSize:10];

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
}

- (IBAction)allBtnClick:(id)sender {
    [self releaseInfoButtonResponseEvent];
}

-(void)releaseInfoButtonResponseEvent {

    //移除第一响应者
   // [self.searchBar resignFirstResponder];
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@" 全部 " image:nil target:self action:@selector(logout)];
    cashTitle.foreColor = GlobalFontColor;
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];

    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"扫码支付" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = GlobalFontColor;
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];

    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"微信支付" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = GlobalFontColor;
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];

    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"支付宝" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = GlobalFontColor;
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];

    YCXMenuItem *storedItem = [YCXMenuItem menuItem:@"龙支付" image:nil target:self action:@selector(logout)];
    storedItem.foreColor = GlobalFontColor;
    storedItem.alignment = NSTextAlignmentLeft;
    storedItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];

    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem,storedItem];

    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:GreyFontColor];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(self.allBtn.centerX, TopHeight + 50, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {

        switch (index) {
            case 0:
            {
               // self.payName = @"全部";
                 [self.allBtn setTitle:@"全部" forState:UIControlStateNormal];
                self.PaymentType = @"";
                [self selectYCXMenuPayNamePaymentType:@""];

            }
                break;
            case 1:
            {

                [self.allBtn setTitle:@"扫码支付" forState:UIControlStateNormal];
                self.PaymentType = @"1";
                [self selectYCXMenuPayNamePaymentType:@"1"];
            }
                break;
            case 2:
            {
               // self.payName = @"支付宝";
                [self.allBtn setTitle:@"微信支付" forState:UIControlStateNormal];
                self.PaymentType = @"2";
                [self selectYCXMenuPayNamePaymentType:@"2"];
            }
                break;
            case 3:
            {
                 [self.allBtn setTitle:@"支付宝" forState:UIControlStateNormal];
                self.PaymentType = @"3";
                [self selectYCXMenuPayNamePaymentType:@"3"];
            }
                break;
            case 4:
            {
                [self.allBtn setTitle:@"龙支付" forState:UIControlStateNormal];
                self.PaymentType = @"4";
                [self selectYCXMenuPayNamePaymentType:@"4"];
            }
                break;
            default:
                break;
        }
    }];

}

- (void)logout {

}

- (void)selectYCXMenuPayNamePaymentType:(NSString *)PaymentType{
//    [self loadCollectionReportStartTime:self.oneDate EndTime:self.twoDate PaymentType:PaymentType QueryId:@"" PageIndex:1 PageSize:10];

    self.page = 1;
    [self loadDataOrderStatus:1 startTime:self.oneDate endTime:self.twoDate paymentType:PaymentType queryId:@""];
}


- (void)buttonResponseEvent{
    //添加一些扫码或相册结果处理
    self.hidesBottomBarWhenPushed=YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
  //  vc.stockCheckVC = self;
    vc.style = [StyleDIY weixinStyle];
    vc.isStockPurchase = 2;
    __weak typeof(self) weakSelf = self;
    vc.scanBlock = ^(NSString *resultStr) {
        weakSelf.page = 1;
        [weakSelf loadDataOrderStatus:1 startTime:@"" endTime:@"" paymentType:@"" queryId:resultStr];
    };
//    vc.selectNumber = 1;
//    vc.isStockPurchase = 0;// 0是盘点
//    vc.stockCheckVC = self;
//    vc.style = [StyleDIY weixinStyle];
//    self.LBXScanViewVc = vc;
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVCollectionFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVCollectionFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.dict = self.datasArray[indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
        self.hidesBottomBarWhenPushed=YES;
        SVCollectionFlowDetailVC *vc = [[SVCollectionFlowDetailVC alloc] init];
        vc.collectionFlowVC = self;
        vc.dictData = self.datasArray[indexPath.row];
       // NSDictionary *dict = self.datasArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
      //  self.hidesBottomBarWhenPushed=NO;
    }else{
        self.hidesBottomBarWhenPushed=YES;
        SVCollectionFlowDetailVC *vc = [[SVCollectionFlowDetailVC alloc] init];
        vc.collectionFlowVC = self;
        vc.dict = self.datasArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
         //  self.hidesBottomBarWhenPushed=NO;
    }
    

}

- (void)CollectionRefundCellClick{
    self.page = 1;
    [self loadDataOrderStatus:1 startTime:self.oneDate endTime:self.twoDate paymentType:self.PaymentType queryId:@""];
}


- (void)selectbuttonResponseEvent{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];

    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
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
  
        self.selectTimeLabel.text = [NSString stringWithFormat:@"%@ -- %@",self.oneDate,self.twoDate];

        self.page = 1;
        [self loadDataOrderStatus:1 startTime:self.oneDate endTime:self.twoDate paymentType:self.PaymentType queryId:@""];
    }
}

- (void)loadCollectionReportOrderStatus:(NSInteger)OrderStatus StartTime:(NSString *)StartTime EndTime:(NSString *)EndTime PaymentType:(NSString *)PaymentType QueryId:(NSString *)QueryId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize{
     [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
    /**
     OrderStatus
     订单状态
     1:Success,执行成功;
     2:InLine,排队中;
     3:Executing,执行中;
     -1:Faild,执行失败;
     */
       NSString *token = [SVUserManager shareInstance].access_token;
    NSString *ShopId = [SVUserManager shareInstance].user_id;
    NSString *dURL = [[NSString alloc] init];
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
        dURL=[URLhead stringByAppendingFormat:@"/api/Report/V2?OrderStatus=%ld&key=%@&StartTime=%@&EndTime=%@&ShopId=%@&PaymentType=%@&QueryId=%@&PageIndex=%ld&PageSize=%ld",(long)OrderStatus,token,StartTime,[NSString stringWithFormat:@"%@ 23:59:59",EndTime],ShopId,PaymentType,QueryId,PageIndex,PageSize];
    }else{
        dURL=[URLhead stringByAppendingFormat:@"/api/Report?key=%@&StartTime=%@&EndTime=%@&ShopId=%@&PaymentType=%@&QueryId=%@&PageIndex=%ld&PageSize=%ld",token,StartTime,[NSString stringWithFormat:@"%@ 23:59:59",EndTime],ShopId,PaymentType,QueryId,PageIndex,PageSize];
    }
    
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic5555 == %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSArray *dataArray = dic[@"data"][@"datas"];

            if (self.page == 1) {
                  [self.datasArray removeAllObjects];
            }

            if (!kArrayIsEmpty(dataArray)) {
                [self.datasArray addObjectsFromArray:dataArray];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            self.totalCount.text = [NSString stringWithFormat:@"共收款%ld笔，合计",(long)[dic[@"data"][@"total"] integerValue]];
            NSString *totalMoney = [NSString stringWithFormat:@"%@",dic[@"data"][@"infos"][@"totalMoney"]];
            double totalMoneyF = [totalMoney doubleValue];
            self.totalMoney.text = [NSString stringWithFormat:@"%.2f",totalMoneyF];

        }else{
           NSString *msg = dic[@"msg"];
            [SVTool TextButtonActionWithSing:msg?:@"获取失败"];
        }

         [self.tableView reloadData];

        if (kArrayIsEmpty(self.datasArray)) {
            [self.img removeFromSuperview];
                  UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                 self.img = img;
                  [self.tableView addSubview:img];
                  [img mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.center.mas_equalTo(self.tableView);
                      make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                  }];
        }else{
            [self.img removeFromSuperview];
        }
        if ([self.tableView.mj_header isRefreshing]) {

                  [self.tableView.mj_header endRefreshing];
              }

              if ([self.tableView.mj_footer isRefreshing]) {

                  [self.tableView.mj_footer endRefreshing];
              }



              //隐藏提示框
              [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           //隐藏提示框
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
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

- (void)oneCancelResponseEvent{
    [self.maskView removeFromSuperview];

    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
}


@end

//
//  SVPurchasingRecordsView.m
//  SAVI
//
//  Created by houming Wang on 2021/2/3.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVPurchasingRecordsView.h"
#import "SVSVPurchasingRecordsCell.h"
#import "SVSelectTwoDatesView.h"

static NSString *const ID = @"SVSVPurchasingRecordsCell";
@interface SVPurchasingRecordsView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,strong) UIButton * leftBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,assign) NSInteger page;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
//遮盖view
@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (weak, nonatomic) IBOutlet UILabel *purchase_Total;
@property (weak, nonatomic) IBOutlet UILabel *total_num;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (nonatomic,strong) NSString * keyWords;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContant;
@property (weak, nonatomic) IBOutlet UILabel *caigouText;


@end
@implementation SVPurchasingRecordsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (ScreenH == 812) {
        self.bottomContant.constant = -20;
    } else {
        self.bottomContant.constant = 0;
    }
    
    self.keyWords = @"";
    self.searchView.layer.cornerRadius = 16;
    self.searchView.layer.masksToBounds = YES;
    //默认风格
    self.searchText.borderStyle = UIBarStyleDefault;
    self.searchText.delegate = self;
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSVPurchasingRecordsCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.scrollEnabled = NO;
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"今天" forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"arrow_whiteColor"] forState:UIControlStateNormal];
    self.leftBtn = leftBtn;
      //  rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [self.oneView addSubview:leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oneView.mas_left).offset(10);
       // make.width.mas_equalTo(80);
      //  make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.twoView.mas_top).offset(-10);
    }];
    leftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [leftBtn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
 
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
     //   UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftBtn.imageView.frame.size.width - leftBtn.frame.size.width + leftBtn.titleLabel.frame.size.width, 0, 0);
      
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -leftBtn.titleLabel.frame.size.width - leftBtn.frame.size.width + leftBtn.imageView.frame.size.width);
    
    self.page = 1;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    self.oneDate = currentTimeString;
    self.twoDate = currentTimeString;
    [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{

        self.page = 1;

        [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];

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
        [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];

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

- (void)setUpStartDate:(NSString *)startDate endDate:(NSString *)endDate page:(NSInteger)page user_id:(NSString *)user_id keywards:(NSString *)keywards{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductPurchasedetailed?key=%@&pageSize=20&pageIndex=%ld&keywards=%@&startDate=%@&endDate=%@&id=%@&user_id=%@",[SVUserManager shareInstance].access_token,(long)page,keywards,startDate,[NSString stringWithFormat:@"%@ 23:59:59",endDate],[SVUserManager shareInstance].product_id,user_id];
    NSLog(@"url---%@",url);
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic888777---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *listArray = data[@"list"];
            if (!kArrayIsEmpty(listArray)) {
                [self.dataArray addObjectsFromArray:listArray];

                if (self.scrollView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.scrollView.mj_footer.state = MJRefreshStateIdle;
                }
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            NSDictionary *values = data[@"values"];
            self.purchase_Total.text = [NSString stringWithFormat:@"%.2f",[values[@"purchase_Total"]doubleValue]];
            self.total_num.text = [NSString stringWithFormat:@"%.2f",[values[@"total_num"] doubleValue]];
          //  CommodityTotalCostQuery
            [SVUserManager loadUserInfo];
            NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
            NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
            if (kDictIsEmpty(CommodityManageDic)) {
                self.purchase_Total.hidden = NO;
                self.caigouText.hidden = NO;
            }else{
                NSString *CommodityTotalCostQuery = [NSString stringWithFormat:@"%@",CommodityManageDic[@"CommodityTotalCostQuery"]];
                if (kStringIsEmpty(CommodityTotalCostQuery)) {
                    self.purchase_Total.hidden = NO;
                    self.caigouText.hidden = NO;
                }else{
                    if ([CommodityTotalCostQuery isEqualToString:@"1"]) {
                  
                        self.purchase_Total.hidden = NO;
                        self.caigouText.hidden = NO;
                }else{
                    self.purchase_Total.text = @"***";
                   // self.caigouText.text = @"***";
                }
                }
            }
            
           

            
            
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {

            [self.scrollView.mj_header endRefreshing];
        }

        if ([self.scrollView.mj_footer isRefreshing]) {

            [self.scrollView.mj_footer endRefreshing];
        }
        self.tableViewHeight.constant = self.dataArray.count * 200;
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];

}

#pragma mark - UISearchBarDelegate代理方法
//点击搜索栏中的textFiled触发
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.listView.scanButton.hidden = YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  //  self.scanButton.hidden = YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{

    //设置为显示
   // self.scanButton.hidden = NO;
    

    self.keyWords = textField.text;

    //调用请求
    self.page = 1;
   // [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:Str biaoqian:@""];
//    [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id];
    [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
   
   // [searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((self.searchText.returnKeyType = UIReturnKeySearch)) {
        //设置为显示
      //  self.scanButton.hidden = NO;
        

        self.keyWords = textField.text;

        //调用请求
        self.page = 1;
//        [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:Str biaoqian:@""];
        [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
        [self.searchText endEditing:YES];
    }
    
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    //[text isEqualToString:@""] 表示输入的是退格键
////    if (![string isEqualToString:@""]) {
////        self.scanButton.hidden = YES;
////    }
//
//    //range.location == 0 && range.length == 1 表示输入的是第一个字符
//    if ([string isEqualToString:@""] && range.location == 0 && range.length == 1) {
//        self.scanButton.hidden = NO;
//    }
//    return YES;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSVPurchasingRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVSVPurchasingRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.dict = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
        
        [SVTool TextButtonAction:self withSing:@"输入时间有误"];
        
    } else {
        self.page = 1;
        [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
        
        [self.leftBtn setTitle:[NSString stringWithFormat:@"%@ - %@",self.oneDate,self.twoDate] forState:UIControlStateNormal];
        [self btnSize];
        
    }
    
    
}
- (void)btnSize{
    self.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.leftBtn.imageView.frame.size.width - self.leftBtn.frame.size.width + self.leftBtn.titleLabel.frame.size.width, 0, 0);
      
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.leftBtn.titleLabel.frame.size.width - self.leftBtn.frame.size.width + self.leftBtn.imageView.frame.size.width);
}

/**
 当前周的日期范围
 
 @return 结果字符串
 */
- (NSString *)currentScopeWeek {
    // 默认周一为第一天，1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    return [self currentScopeWeek:2 dateFormat:@"YYYY.MM.dd"];
}

- (NSString *)currentScopeWeek:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    // 1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    calendar.firstWeekday = firstWeekday;
    
    // 日历单元
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    unsigned unitNewFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowComponents = [calendar components:unitFlag fromDate:nowDate];
    // 获取今天是周几，需要用来计算
    NSInteger weekDay = [nowComponents weekday];
    // 获取今天是几号，需要用来计算
    NSInteger day = [nowComponents day];
    // 计算今天与本周第一天的间隔天数
    NSInteger countDays = 0;
    // 特殊情况，本周第一天firstWeekday比当前星期weekDay小的，要回退7天
    if (calendar.firstWeekday > weekDay) {
        countDays = 7 + (weekDay - calendar.firstWeekday);
    } else {
        countDays = weekDay - calendar.firstWeekday;
    }
    // 获取这周的第一天日期
    NSDateComponents *firstComponents = [calendar components:unitNewFlag fromDate:nowDate];
    [firstComponents setDay:day - countDays];
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    
    // 获取这周的最后一天日期
    NSDateComponents *lastComponents = firstComponents;
    [lastComponents setDay:firstComponents.day + 6];
    NSDate *lastDate = [calendar dateFromComponents:lastComponents];
    
    // 输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *firstDay = [formatter stringFromDate:firstDate];
    NSString *lastDay = [formatter stringFromDate:lastDate];
    
    return [NSString stringWithFormat:@"%@ - %@",firstDay,lastDay];
}

- (void)timeClick:(UIButton *)btn{
   
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
        
        YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"自定义" image:nil target:self action:@selector(logout)];
        bankItem.foreColor = [UIColor colorWithHexString:@"666666"];
        bankItem.alignment = NSTextAlignmentLeft;
        bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
        
        NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];
        //    NSArray *items = @[[YCXMenuItem menuItem:@"现金" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
        //                       [YCXMenuItem menuItem:@"微信" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
        //                       [YCXMenuItem menuItem:@"支付宝" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
        //                       [YCXMenuItem menuItem:@"银行卡" image:nil tag:4 userInfo:@{@"title":@"Menu"}],
        //                       ];
        
        [YCXMenu setCornerRadius:3.0f];
        [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
        [YCXMenu setSelectedColor:clickButtonBackgroundColor];
        [YCXMenu setTintColor:[UIColor whiteColor]];
        //name="state">0：查询全部，1：待入库，2：已入库
        [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(27, TopHeight + CGRectGetMaxY(self.leftBtn.frame), 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
            
            switch (index) {
                case 0:
                {
                   // self.payName = @"现金";
                    [self.leftBtn setTitle:@"今天" forState:UIControlStateNormal];
                    self.page = 1;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                    
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    
                    //现在时间,你可以输出来看下是什么格式
                    
                    NSDate *datenow = [NSDate date];
                    
                    //----------将nsdate按formatter格式转成nsstring
                    
                    NSString *currentTimeString = [formatter stringFromDate:datenow];
                    self.oneDate = currentTimeString;
                    self.twoDate = currentTimeString;
                    [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
                    [self btnSize];
                    
                }
                    break;
                case 1:
                {
                  //  self.payName = @"微信支付";
                    self.page = 1;
                    [self.leftBtn setTitle:@"昨天" forState:UIControlStateNormal];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                    
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    
                    //现在时间,你可以输出来看下是什么格式
                    
                    // NSDate *datenow = [NSDate date];
                    
                    NSDate *date = [NSDate date];//当前时间
                    
                    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
                    
                    NSString *currentTimeString = [formatter stringFromDate:lastDay];
                    self.oneDate = currentTimeString;
                    self.twoDate = currentTimeString;
                    [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
                    [self btnSize];
                }
                    break;
                case 2:
                {
                   // self.payName = @"支付宝";
                    [self.leftBtn setTitle:@"本周" forState:UIControlStateNormal];
                    NSString *str = [self currentScopeWeek];
                    NSLog(@"本周str = %@",str);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                    
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    
                    //现在时间,你可以输出来看下是什么格式
                    
                    NSDate *datenow = [NSDate date];
                    
                    //----------将nsdate按formatter格式转成nsstring
                    
                    NSString *currentTimeString = [formatter stringFromDate:datenow];
                   // NSString *str = [self currentScopeWeek];
                    //  NSString *string =@"sdfsfsfsAdfsdf";
                    NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
                    NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                    NSString *str1 = array[0];
                    NSLog(@"本周str = %@",str1);
                    self.oneDate = str1;
                    self.twoDate = currentTimeString;
                    [self setUpStartDate:self.oneDate endDate:self.twoDate page:self.page user_id:[SVUserManager shareInstance].user_id keywards:self.keyWords];
                    [self btnSize];
                  //  [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];
                }
                    break;
                case 3:
                {
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


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

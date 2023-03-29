//
//  SVSubCardReportVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/16.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVSubCardReportVC.h"
#import "SVCardFlowChartCell.h"
#import "SVStoreLineView.h"
#import "SVAddCustomView.h"

static NSString *const CardFlowChartCellID = @"SVCardFlowChartCell";
@interface SVSubCardReportVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subCardHeight;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cikahuizongHeight;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray *valuesArray;
@property (weak, nonatomic) IBOutlet UILabel *consumptionMemberNum;
@property (weak, nonatomic) IBOutlet UILabel *consumptionNum;
@property (weak, nonatomic) IBOutlet UILabel *consumptionCount;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;

@property (nonatomic,strong) SVAddCustomView *addCustomView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation SVSubCardReportVC
- (NSMutableArray *)valuesArray
{
    if (!_valuesArray) {
        _valuesArray = [NSMutableArray array];
    }
    return _valuesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVCardFlowChartCell" bundle:nil] forCellReuseIdentifier:CardFlowChartCellID];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    

    
    if (kDictIsEmpty(self.dic)) {
        
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        // self.page = 1;
        self.type = 1; // 默认是今天
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];

    }else{
        NSString *type = [self.dic objectForKey:@"type"];
        if ([type isEqualToString:@"2"]) {// 本周
            self.type = type.integerValue;
            
            NSString *str = [self currentScopeWeek];
          //  NSString *string =@"sdfsfsfsAdfsdf";
            NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
            NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
            NSString *str1 = array[0];
            NSLog(@"本周str = %@",str1);
            
            [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];

        }else if ([type isEqualToString:@"1"]){// 是今天
            self.type = type.integerValue;
             [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
  
        }else if ([type isEqualToString:@"-1"]){// 昨天
            self.type = type.integerValue;
       
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            //现在时间,你可以输出来看下是什么格式
            
            // NSDate *datenow = [NSDate date];
            
            NSDate *date = [NSDate date];//当前时间
            
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
            
            NSString *currentTimeString = [formatter stringFromDate:lastDay];
            
             [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
            
            
            
        }else{
            self.type = type.integerValue;
            
            
            NSString *oneDate = [self.dic objectForKey:@"oneDate"];
            NSString *twoDate = [self.dic objectForKey:@"twoDate"];
            
             [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];

        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"nitifyName2" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyMemberNameAllStore:) name:@"nitifyMemberNameAllStore" object:nil];
   
    
    //  [self setUpData];
            //增加监听，当键盘出现或改变时收出消息
               [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(keyboardWillShow:)
                                                            name:UIKeyboardWillShowNotification
                                                          object:nil];
               
               //增加监听，当键退出时收出消息
               [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(keyboardWillHide:)
                                                            name:UIKeyboardWillHideNotification
                                                          object:nil];
}

        - (void)keyboardWillShow:(NSNotification *)aNotification
        {
            //获取键盘的高度
            
            NSDictionary *userInfo = [aNotification userInfo];
            NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardRect = [aValue CGRectValue];
            int height = keyboardRect.size.height;
            int width = keyboardRect.size.width;
            self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
            NSLog(@"键盘高度是  %d",height);
            NSLog(@"键盘宽度是  %d",width);
            
            
        }

        //当键退出时调用
        - (void)keyboardWillHide:(NSNotification *)aNotification
        {
             [self.addCustomView.textView becomeFirstResponder];// 2
        }


- (void)nitifyMemberNameAllStore:(NSNotification *)noti{
    NSDictionary  *dic = [noti userInfo];
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
    //    self.dic = dic;
    
    self.user_id = dic[@"user_id"];
    
   // NSDictionary  *dic = [noti userInfo];
   // NSString *type = [dic objectForKey:@"type"];
   // self.type = type.integerValue;
    NSString *type = [NSString stringWithFormat:@"%ld",self.type];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    if ([type isEqualToString:@"2"]) {// 本周
        NSString *str = [self currentScopeWeek];
        NSLog(@"本周str = %@",str);
        
        // NSString *str = [self currentScopeWeek];
        //  NSString *string =@"sdfsfsfsAdfsdf";
        NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
        NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
        NSString *str1 = array[0];
        NSLog(@"本周str = %@",str1);
        
        [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"1"]){
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"-1"]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else{
        if (kDictIsEmpty(self.dic)) {
            NSString *oneDate = @"";
            NSString *twoDate = @"";
            
            [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
        }else{
            NSString *oneDate = [self.dic objectForKey:@"oneDate"];
            NSString *twoDate = [self.dic objectForKey:@"twoDate"];
            
            [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
        }
        
    }
}

#pragma mark - 时间晒选
-(void)notification2:(NSNotification *)noti{
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    NSString *type = [dic objectForKey:@"type"];
    self.type = type.integerValue;
    self.dic = dic;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    if ([type isEqualToString:@"2"]) {// 本周
        NSString *str = [self currentScopeWeek];
        NSLog(@"本周str = %@",str);
        
       // NSString *str = [self currentScopeWeek];
        //  NSString *string =@"sdfsfsfsAdfsdf";
        NSArray *array = [str componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
        NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
        NSString *str1 = array[0];
        NSLog(@"本周str = %@",str1);
        
        [self setUpDataStart:str1 end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"1"]){
          [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else if ([type isEqualToString:@"-1"]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else{
        NSString *oneDate = [dic objectForKey:@"oneDate"];
        NSString *twoDate = [dic objectForKey:@"twoDate"];
        
        [self setUpDataStart:oneDate end:twoDate user_id:self.user_id];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName2" object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyMemberNameAllStore" object:nil];
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


- (void)setUpDataStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
   
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.page = 1;
   // self.type = 1; // 默认是今天
//    [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
   [self GetSetmealConsumeSerialSalesTopStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
    // 次卡流水表
     [self GetSetmealConsumeSerialInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
       [self GetSetmealConsumeSerialSalesTopStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
        // 次卡流水表
        [self GetSetmealConsumeSerialInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
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
      [self GetSetmealConsumeSerialSalesTopStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
        // 次卡流水表
   [self GetSetmealConsumeSerialInfoStart:start end:end page:self.page pageSize:10 day:@"4" user_id:user_id];
        
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



#pragma mark - 次卡消费汇总
- (void)GetSetmealConsumeSerialSalesTopStart:(NSString *)start end:(NSString *)end page:(NSInteger)page pageSize:(NSInteger)pageSize day:(NSString *)day user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetSetmealConsumeSerialSalesTop?key=%@&start=%@&end=%@&page=%ld&pagesize=%ld&day=%@&storeid=%@",token,start,[NSString stringWithFormat:@"%@ 23:59:59",end],page,pageSize,day,user_id];
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic次卡消费汇总 = %@",dic);
      
        if ([dic[@"succeed"] intValue] == 1) {
           
            if (self.page == 1) {
                [self.valuesArray removeAllObjects];
            }
            
            NSArray *valuesArray = dic[@"values"];
            if (!kArrayIsEmpty(valuesArray)) {
                [self.valuesArray addObjectsFromArray:valuesArray];
            if (!kArrayIsEmpty(self.valuesArray)) {
                  [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                float order_receivable= 0.0;
                for (NSDictionary *dict in self.valuesArray) {
                    order_receivable += [dict[@"product_num"] floatValue];
                }
                
                CGFloat maxY = 0;
                
                CGFloat maxHeight = 0;
                
                for (int i = 0; i < self.valuesArray.count ; i++) {
                    
                    NSDictionary *dictLeval = self.valuesArray[i];
                    
                    if ([dictLeval[@"product_num"] floatValue] == 0) {//数据为0时
                        
                    }else{
                        
                        SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(0, maxY, self.fatherView.width, 48)];
                        maxHeight += 48;
                        rankingsV.namelabel.text = dictLeval[@"sv_p_name"];
                        rankingsV.moneylabel.text = [NSString stringWithFormat:@"￥%.2f",[dictLeval[@"product_num"]floatValue]];
                        if (order_receivable != 0) {
                            float twoWide = 210 * [dictLeval[@"product_num"]floatValue] / order_receivable;
                            
                            [UIView animateWithDuration:1 animations:^{
                                rankingsV.colorView.width = twoWide;
                            }];
                            rankingsV.colorView.height = 15;
                            rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                            rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                            //  maxY = maxY;
                            maxY = CGRectGetMaxY(rankingsV.frame);
                            [self.fatherView addSubview:rankingsV];
                        }
                         }
                    }
                self.cikahuizongHeight.constant = maxY + 63;
            }else{
                 [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.cikahuizongHeight.constant = 230;
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                [self.fatherView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.fatherView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
            }
            
                
            }else{
                if (kArrayIsEmpty(self.valuesArray)) {
                     [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    self.cikahuizongHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.fatherView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.fatherView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }
                /** 所有数据加载完毕，没有更多的数据了 */
              //  self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
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
       
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 次卡报表
- (void)GetSetmealConsumeSerialInfoStart:(NSString *)start end:(NSString *)end  page:(NSInteger)page pageSize:(NSInteger)pageSize day:(NSString *)day user_id:(NSString *)user_id{
 //   GetSetmealConsumeSerialInfo
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetSetmealConsumeSerialInfo?key=%@&start=%@&end=%@&page=%ld&pagesize=%ld&day=%@&storeid=%@",token,start,[NSString stringWithFormat:@"%@ 23:59:59",end],page,pageSize,day,user_id];
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic次卡报表 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataList removeAllObjects];
            }
            self.consumptionMemberNum.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"membercount"]floatValue]];
            self.consumptionNum.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"total"]floatValue]];
           self.consumptionCount.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"totalsumcount"]floatValue]];
            NSArray *array = dic[@"values"][@"dataList"];
            if (!kArrayIsEmpty(array)) {
                 [self.dataList addObjectsFromArray:array];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
             //   self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
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
        
         self.subCardHeight.constant = self.dataList.count *50 + 80 + 20;
        [self.tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVCardFlowChartCell *cell = [tableView dequeueReusableCellWithIdentifier:CardFlowChartCellID];
    if (!cell) {
        cell = [[SVCardFlowChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CardFlowChartCellID];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.dict = self.dataList[indexPath.row];
    cell.cancleBtn.tag = indexPath.row;
    cell.cancleBtn.sd_indexPath = indexPath;
    [cell.cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)cancleClick:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定撤销吗?"];
    //设置文本颜色
    [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 6)];
    //设置文本字体大小
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,6)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [SVUserManager loadUserInfo];
          NSDictionary *dict = self.dataList[btn.tag];
        //  NSString *token = [SVUserManager shareInstance].access_token;
          NSString *dURL = [URLhead stringByAppendingFormat:@"/intelligent/returensales_new?key=%@",[SVUserManager shareInstance].access_token];
        [SVTool IndeterminateButtonAction:self.view withSing:@"撤销中..."];
          NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
          
          [parameters setObject:@"" forKey:@"return_cause"];
          [parameters setObject:[NSString stringWithFormat:@"%@",dict[@"sv_order_list_id"]] forKey:@"order_id"];
          [parameters setObject:@"" forKey:@"return_remark"];
          [parameters setObject:[NSString stringWithFormat:@"%@",dict[@"product_num"]] forKey:@"return_num"];
          [parameters setObject:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:@"order_product_id"];
          //    [parameters setObject:self.order_id forKey:@"order_product_id"];
          [parameters setObject:@"1" forKey:@"return_type"];
          [parameters setObject:[NSString stringWithFormat:@"%@",dict[@"product_id"]] forKey:@"return_pordcot"];
          
          [[SVSaviTool sharedSaviTool] POST:dURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
              
              NSLog(@"dic = %@",dic);
              
              if ([dic[@"succeed"] intValue] == 1) {
                  [self.dataList removeObjectAtIndex:btn.sd_indexPath.row];
                   self.subCardHeight.constant = self.dataList.count *50 + 80 + 20;
                  [self.tableView reloadData];
                  [SVTool TextButtonAction:self.view withSing:@"撤销成功，已移除"];
              }else{
                  //隐藏提示框
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  [SVTool TextButtonAction:self.view withSing:@"撤销失败"];
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              //隐藏提示框
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
          }];
    }];
    [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}
- (void)cancleBtnClick{
  //  [self sureBtnClick];
    [self vipCancelResponseEvent];
}

//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
   // [self.vipPickerView removeFromSuperview];
    [self.addCustomView removeFromSuperview];
  //  [self.setUserdItemView removeFromSuperview];
    
    //[self.tableView reloadData];
    
}

/**
 等级遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

@end

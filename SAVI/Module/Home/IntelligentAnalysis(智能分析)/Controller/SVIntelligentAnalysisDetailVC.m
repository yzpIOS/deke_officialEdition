//
//  SVIntelligentAnalysisDetailVC.m
//  SAVI
//
//  Created by houming Wang on 2019/9/18.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVIntelligentAnalysisDetailVC.h"
#import "SVIntelligentDetailView.h"
#import "SVIntelligentDetailCell.h"
#import "SVRankingsView.h"
#import "SVShopOverviewModel.h"
#import "SVFourLabelView.h"
#import "SVSelectTwoDatesView.h"
static NSString*const ID = @"SVIntelligentDetailCell";
@interface SVIntelligentAnalysisDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
////分段控件
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic,strong) SVIntelligentDetailView *intelligentDetailView;
@property (nonatomic,strong) NSArray *valuesArr;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) SVFourLabelView *fourLabelView;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@end

@implementation SVIntelligentAnalysisDetailVC
- (SVFourLabelView *)fourLabelView
{
    if (!_fourLabelView) {
        _fourLabelView = [[NSBundle mainBundle] loadNibNamed:@"SVFourLabelView" owner:nil options:nil].lastObject;
    }
    return _fourLabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sectionHeaderHeight = 390;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH -TopHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVIntelligentDetailCell" bundle:nil] forCellReuseIdentifier:ID];
   // [self setUpShopRankingType:1];
    self.title = @"店铺概况";
      self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
    self.page = 1;
    self.type = 1; // 默认是今天
    [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
         [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
        
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
      //  self.isSelect = YES;
        //调用请求
//        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@""];
        [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
        
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
    
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.mj_footer = footer;

}



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
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
//                self.payName = @"现金";
//                [self selectYCXMenuPayName];
                self.navigationItem.rightBarButtonItem.title = @"今天";
                self.page = 1;
                self.type = 1;
                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
                
            }
                break;
            case 1:
            {

                self.navigationItem.rightBarButtonItem.title = @"昨天";
                self.page = 1;
                 self.type = -1;
                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
            }
                break;
            case 2:
            {
//                self.payName = @"支付宝";
//                [self selectYCXMenuPayName];
                self.navigationItem.rightBarButtonItem.title = @"本周";
                self.page = 1;
                self.type = 2;
                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
            }
                break;
            case 3:
            {
                 self.navigationItem.rightBarButtonItem.title = @"其他";
                self.page = 1;
                
                self.type = 3;
                
                [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
            }
                break;

            default:
                break;
        }
    }];
}

- (void)logout {
    
}

// 店铺概况
- (void)setShopOverviewType:(NSInteger)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
     NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductAnalysisByShop?key=%@&id=0&type=%li&storeid=-1&page=%ld&top=%ld&date=%@&date2=%@&queryLike=%@",token,type,page,top,date,date2,@""];
    
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic444 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            
            if (self.page == 1) {
                [self.dataList removeAllObjects];
            }
            
           NSMutableArray *array = dic[@"values"][@"dataList"];
            self.dataList = [SVShopOverviewModel mj_objectArrayWithKeyValuesArray:array];
           // [self.dataList addObjectsFromArray:array];
            float order_receivable = 0.0;
            float order_pdgfee = 0.0;
            NSInteger count = 0;
            for (SVShopOverviewModel *model in self.dataList) {
                order_receivable += [model.order_receivable floatValue];
                order_pdgfee += [model.order_pdgfee floatValue];
                count += [model.count integerValue];
            }
            self.intelligentDetailView = [[NSBundle mainBundle] loadNibNamed:@"SVIntelligentDetailView" owner:nil options:nil].lastObject;
            
            self.intelligentDetailView.totleMoney.text = [NSString stringWithFormat:@"%.2f",order_receivable];
            self.intelligentDetailView.discountVolume.text = [NSString stringWithFormat:@"%.2f",order_pdgfee];
            self.intelligentDetailView.strokeNumber.text = [NSString stringWithFormat:@"%ld",(long)count];
            
           // NSMutableArray *dataArray = array[0][@"proList"];
            if (kArrayIsEmpty(self.dataList)) {
                
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noWareRanking"]];
                [self.intelligentDetailView.topView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.intelligentDetailView.topView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
                
                
                self.sectionHeaderHeight = 390;
                
                
                 UIView *headerView = _tableView.tableHeaderView;
                headerView =self.intelligentDetailView;
                headerView.height = self.sectionHeaderHeight;
                 [self.tableView reloadData];
              //  [_tableView beginUpdates];
                [_tableView setTableHeaderView:headerView];// 关键是这句话
//                [_tableView endUpdates];
//                [_tableView beginUpdates];
//                [_tableView endUpdates];
               
                
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
//                if (48 * dataArray.count + 35 <= 390) {
//                    self.sectionHeaderHeight = 390;
//                }else{
                    self.sectionHeaderHeight = 48 * self.dataList.count + 35 + 190;
                //}
                
                UIView *headerView = _tableView.tableHeaderView;

                headerView =self.intelligentDetailView;
                headerView.height = self.sectionHeaderHeight;
                [self.tableView reloadData];
             //   [_tableView beginUpdates];
                [_tableView setTableHeaderView:headerView];// 关键是这句话
//                [_tableView endUpdates];
//                [_tableView beginUpdates];
//                [_tableView endUpdates];
                
                
                for (int i = 0; i<self.dataList.count; i++) {
                    
                    SVRankingsView *rankingsV = [[SVRankingsView alloc]init];
                    rankingsV.tag = i+1;
                    SVShopOverviewModel *model = self.dataList[i];
                    rankingsV.taglabel.text = [NSString stringWithFormat:@"%d",i+1];
                    rankingsV.namelabel.text = [NSString stringWithFormat:@"%@",model.sv_us_name];
                  //  rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",];
                    rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",model.order_receivable.floatValue];
                    [self.intelligentDetailView.topView addSubview:rankingsV];
                    
                    if (i == 0) {
                        [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
                            make.left.mas_equalTo(self.intelligentDetailView.topView);
                            make.top.mas_equalTo(self.intelligentDetailView.topView).offset(35);
                        }];
                        
                        float twoWide;
                        //                            if ([rankingsOneV.moneylabel.text floatValue] <= 0.0) {
                        //                                twoWide = 0.0;
                        //                            }else{
                        twoWide = 180 * [model.order_receivable floatValue] / [self.intelligentDetailView.totleMoney.text floatValue];
                        //}
                        
                        //改变frame
                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(twoWide, 22));
                        }];
                      
                    } else {
                        
                        
                        SVRankingsView *rankingsT = (SVRankingsView *)[self.intelligentDetailView.topView viewWithTag:i];
                        [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
                            make.left.mas_equalTo(self.intelligentDetailView.topView);
                            make.top.mas_equalTo(rankingsT.mas_bottom).offset(10);
                        }];
                        
                        //计算长度
                        if ([model.order_receivable floatValue] == 0) {//数据为0时
                            //改变frame
                            rankingsV.colorView.backgroundColor = [UIColor whiteColor];
                            [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.size.with.mas_equalTo(0.5);
                            }];
                        } else {
               
                            SVRankingsView *rankingsOneV = (SVRankingsView *)[self.intelligentDetailView.topView viewWithTag:1];
                            float twoWide;
//                            if ([rankingsOneV.moneylabel.text floatValue] <= 0.0) {
//                                twoWide = 0.0;
//                            }else{
                            twoWide = 180 * [model.order_receivable floatValue] / [self.intelligentDetailView.totleMoney.text floatValue];
                            //}
                           
                            //改变frame
                            [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.size.mas_equalTo(CGSizeMake(twoWide, 22));
                            }];
                            
                        }
                        
                    }
                    
                }
                
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
                
            }
            
            
        }else{
             [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
            
       
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
         [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}

// 商品销售排行
//- (void)setUpShopRankingType:(NSInteger)type{
//    [SVUserManager loadUserInfo];
//    NSString *token = [SVUserManager shareInstance].access_token;
//    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/getprCoutlist?key=%@&type=%li",token,(long)type];
//    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//        NSArray *valuesArr = dic[@"values"];
//        self.valuesArr = valuesArr;
//
//        if ([valuesArr isEqual:@""]) {
//
//            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noWareRanking"]];
//            [self.intelligentDetailView.topView addSubview:img];
//            [img mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(self.intelligentDetailView.topView);
//                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
//            }];
//
//            self.sectionHeaderHeight = 390;
//
//        } else {
//
//            if (48 * valuesArr.count + 35 <= 390) {
//                self.sectionHeaderHeight = 390;
//            }else{
//                self.sectionHeaderHeight = 48 * valuesArr.count + 35 + 190;
//            }
//
//            UIView *headerView = _tableView.tableHeaderView;
//            self.intelligentDetailView = [[NSBundle mainBundle] loadNibNamed:@"SVIntelligentDetailView" owner:nil options:nil].lastObject;
//            headerView =self.intelligentDetailView;
//            headerView.height = self.sectionHeaderHeight;
//            [_tableView beginUpdates];
//            [_tableView setTableHeaderView:headerView];// 关键是这句话
//            [_tableView endUpdates];
//            [_tableView beginUpdates];
//            [_tableView endUpdates];
//
//            for (int i = 0; i<valuesArr.count; i++) {
//
//                SVRankingsView *rankingsV = [[SVRankingsView alloc]init];
//                rankingsV.tag = i+1;
//                NSDictionary *dic1 = valuesArr[i];
//                rankingsV.taglabel.text = [NSString stringWithFormat:@"%d",i+1];
//                rankingsV.namelabel.text = [NSString stringWithFormat:@"%@",dic1[@"sv_mr_name"]];
//                rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[dic1[@"order_receivable"] floatValue]];
//
//                [self.intelligentDetailView.topView addSubview:rankingsV];
//
//                if (i == 0) {
//                    [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
//                        make.left.mas_equalTo(self.intelligentDetailView.topView);
//                        make.top.mas_equalTo(self.intelligentDetailView.topView).offset(35);
//                    }];
//                //    rankingsV.frame = CGRectMake(0, 35, ScreenW, 38);
//                } else {
//
//
//                    SVRankingsView *rankingsT = (SVRankingsView *)[self.intelligentDetailView.topView viewWithTag:i];
//                    [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
//                        make.left.mas_equalTo(self.intelligentDetailView.topView);
//                        make.top.mas_equalTo(rankingsT.mas_bottom).offset(10);
//                    }];
//
//                    //计算长度
//                    if ([dic1[@"order_receivable"] floatValue] == 0) {//数据为0时
//                        //改变frame
//                        rankingsV.colorView.backgroundColor = [UIColor whiteColor];
//                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.size.with.mas_equalTo(0.5);
//                        }];
//                    } else {
//
//                        SVRankingsView *rankingsOneV = (SVRankingsView *)[self.intelligentDetailView.topView viewWithTag:1];
//                        float twoWide = 180 * [dic1[@"order_receivable"] floatValue] / [rankingsOneV.moneylabel.text floatValue];
//                        //改变frame
//                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.size.mas_equalTo(CGSizeMake(twoWide, 22));
//                        }];
//
//                    }
//
//                }
//
//            }
//
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//    }];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.fourLabelView.frame = CGRectMake(0, 0, ScreenW, 50);
    return self.fourLabelView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVIntelligentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVIntelligentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
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

@end

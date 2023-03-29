//
//  SVRechargeReportVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVRechargeReportVC.h"
#import "SVOneStoreCell.h"
#import "SVShopOverviewModel.h"
#import "SVTwoDoBusinessCell.h"
#import "SVStoreLineView.h"
#import "SVIntelligentDetailCell.h"
#import "SVStoreTopView.h"
#import "SVShopReportModel.h"
#import "SVRechargeReportCell.h"
static NSString *const ID = @"UITableViewCell";
static NSString *const OneStoreCellID = @"SVOneStoreCell";
static NSString *const TwoDoBusinessCellID = @"SVTwoDoBusinessCell";
static NSString *const RechargeReportCellID = @"SVRechargeReportCell";

@interface SVRechargeReportVC ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *valuesArr;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) NSString *type;


@property (nonatomic,strong) NSMutableArray *dataList;
//@property (nonatomic,strong) SVFourLabelView *fourLabelView;
@property (nonatomic,strong) SVStoreTopView *storeTopView;
@property (nonatomic,strong) NSMutableArray *GreaterThanArray;
@property (nonatomic,assign) float order_receivable;
@property (nonatomic,strong) NSDictionary *topDict;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeHeight;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoHeight;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UILabel *storemoney;
@property (weak, nonatomic) IBOutlet UILabel *allMember;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *threeView;

@end

@implementation SVRechargeReportVC

- (SVStoreTopView *)storeTopView
{
    if (!_storeTopView) {
        _storeTopView = [[NSBundle mainBundle]loadNibNamed:@"SVStoreTopView" owner:nil options:nil].lastObject;
        _storeTopView.frame = CGRectMake(0, 0, ScreenW, 50);
        _storeTopView.chongzhiView.hidden = NO;
    }
    
    return _storeTopView;
}

- (NSMutableArray *)GreaterThanArray
{
    if (!_GreaterThanArray) {
        _GreaterThanArray = [NSMutableArray array];
    }
    return _GreaterThanArray;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - kTabbarHeight - 50 - BottomHeight-TopHeight)];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - kTabbarHeight - 50 - BottomHeight-TopHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.estimatedSectionFooterHeight = 1.5;
//    self.tableView.estimatedSectionHeaderHeight = 1.5;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置tableView的估算高度
//    self.tableView.estimatedRowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  [self.view addSubview:self.tableView];
//    self.view.backgroundColor = BackgroundColor;
//    [self.tableView registerNib:[UINib nibWithNibName:@"SVOneStoreCell" bundle:nil] forCellReuseIdentifier:OneStoreCellID];
//    [self.tableView registerNib:[UINib nibWithNibName:@"SVTwoDoBusinessCell" bundle:nil] forCellReuseIdentifier:TwoDoBusinessCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVRechargeReportCell" bundle:nil] forCellReuseIdentifier:RechargeReportCellID];
    
    
    if (kDictIsEmpty(self.dic)) {

        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
       // self.page = 1;
        self.type = @"1"; // 默认是今天
        self.oneDate = @"";
        self.twoDate = @"";
       // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
//        [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
    }else{
        NSString *type = [self.dic objectForKey:@"type"];
        if ([type isEqualToString:@"2"]) {// 本周
            self.type = type;

            self.oneDate = @"";
            self.twoDate = @"";
            
          //  [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
//           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
    
        }else if ([type isEqualToString:@"1"]){// 是今天
            self.type = type;
            self.oneDate = @"";
            self.twoDate = @"";
          //  self.page = 1;
            
           // [self setUpDataType:1];
           [self setUpDataUser_id:self.user_id];
//            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
     
        }else if ([type isEqualToString:@"-1"]){// 昨天
            self.type = type;
           // self.timeLabel.text = @"昨天";
            self.oneDate = @"";
            self.twoDate = @"";
            // self.page = 1;
          //  self.page = 1;
            
          //  [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
//            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];

            
        }else{
            self.type = type;
            self.oneDate = [self.dic objectForKey:@"oneDate"];
            self.twoDate = [self.dic objectForKey:@"twoDate"];
           // self.page = 1;
            
          //  [self setUpDataType:1];
           [self setUpDataUser_id:self.user_id];
//            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];

        }
    }
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"nitifyName2" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyMemberNameAllStore:) name:@"nitifyMemberNameAllStore" object:nil];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName2" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyMemberNameAllStore" object:nil];
}

- (void)nitifyMemberNameAllStore:(NSNotification *)noti{
    
    NSDictionary  *dic = [noti userInfo];
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
    //    self.dic = dic;
    
    self.user_id = dic[@"user_id"];
    
  //  NSString *type = [dic objectForKey:@"type"];
    if ([self.type isEqualToString:@"2"]) {// 本周
       // self.type = type;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        
        // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([self.type isEqualToString:@"1"]){// 是今天
        //self.type = type;
        
        self.page = 1;
        
        // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([self.type isEqualToString:@"-1"]){// 昨天
       // self.type = type;
        self.page = 1;
        // self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        //  self.page = 1;
        
        //  [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
        
    }else{
        //self.type = type;
        if (kDictIsEmpty(self.dic)) {
            self.page = 1;
            self.oneDate = @"";
            self.twoDate = @"";
            // self.page = 1;
            
            // [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
        }else{
            self.page = 1;
            self.oneDate = [self.dic objectForKey:@"oneDate"];
            self.twoDate = [self.dic objectForKey:@"twoDate"];
            // self.page = 1;
            
            // [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
        }
  
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }
}

#pragma mark - 时间晒选
-(void)notification2:(NSNotification *)noti{
    
//    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
     NSDictionary  *dic = [noti userInfo];
//    // NSString *type = [dic objectForKey:@"type"];
//    // self.type = type;
    self.dic = dic;
    
    NSString *type = [dic objectForKey:@"type"];
    if ([type isEqualToString:@"2"]) {// 本周
        self.type = type;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        
       // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.type = type;
        
          self.page = 1;
        
       // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"-1"]){// 昨天
        self.type = type;
        self.page = 1;
        // self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        //  self.page = 1;
        
      //  [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
        
    }else{
        self.type = type;
        self.page = 1;
        self.oneDate = [dic objectForKey:@"oneDate"];
        self.twoDate = [dic objectForKey:@"twoDate"];
        // self.page = 1;
        
       // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }
    
}

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName2" object:nil];
//}


- (void)setUpDataUser_id:(NSString *)user_id{
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.page = 1;
   // self.type = @"1"; // 默认是今天
    [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
    
    [self setUpDataType:self.type date:self.oneDate date2:self.twoDate user_id:user_id];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
        [self setUpDataType:self.type date:self.oneDate date2:self.twoDate user_id:user_id];
        
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
      [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
        
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

- (void)setUpDataType:(NSString *)type date:(NSString *)date date2:(NSString *)date2 user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/getSumtop_up_new?key=%@&day=%@&date=%@&date2=%@&user_id=%@",token,type,date,date2,user_id];
    NSLog(@"dURL = %@",dURL);
    
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic111 = %@",dic);
       self.topDict = dic[@"values"];
        self.storemoney.text = [NSString stringWithFormat:@"%.2f",[self.topDict[@"all_sv_mw_availableamount"] doubleValue]];
        self.allMember.text = [NSString stringWithFormat:@"%.2f",[self.topDict[@"sumup"] doubleValue]];
        self.number.text = [NSString stringWithFormat:@"%.2f",[self.topDict[@"sumcancel"] doubleValue]];
        [self.GreaterThanArray removeAllObjects];
        NSMutableArray *listArr = dic[@"values"][@"list"];
        if (kArrayIsEmpty(listArr)) {
           // if (kArrayIsEmpty(self.GreaterThanArray)) {
                [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.twoHeight.constant = 230;
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                [self.fatherView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.fatherView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
           // }
        }else{
            for (NSDictionary *values in listArr) {
                SVShopReportModel *model = [SVShopReportModel mj_objectWithKeyValues:values];
                if ([model.sv_mrr_money floatValue] != 0) {
                    
                    [self.GreaterThanArray addObject:model];
                    
                    
                }
            }
            
            float order_receivable = 0.0;
            for (SVShopReportModel *model in self.GreaterThanArray) {
                order_receivable += [model.sv_mrr_money floatValue];
            }
            
            self.order_receivable = order_receivable;
            
            CGFloat maxY = 0;

            [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (int i = 0; i < self.GreaterThanArray.count ; i++) {
                
                SVShopReportModel *model = self.GreaterThanArray[i];
                
                if ([model.sv_mrr_money floatValue] == 0) {//数据为0时
                    
                }else{
                    
                    SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
                    // rankingsV.tag = i+1;
                    
                    rankingsV.namelabel.text = model.sv_mr_name;
                    rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",model.sv_mrr_money.floatValue];
                    
                    
                    if (self.order_receivable != 0) {
                        float twoWide = 210 * [model.sv_mrr_money floatValue] / self.order_receivable;
                        
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
            
            
            if (kArrayIsEmpty(self.fatherView.subviews)) {
                self.twoHeight.constant = 230;
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                [self.fatherView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.fatherView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
                
            }else{
                self.twoHeight.constant = maxY + 63;
                
            }
            
        }
       
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 充值报表
- (void)setShopOverviewType:(NSString *)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2 user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetSavingsList_new?key=%@&day=%@&page=%ld&pagesize=%ld&date=%@&date2=%@&state=0&user_id=%@",token,type,(long)page,(long)top,date,date2,user_id];
    NSLog(@"dURL = %@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic65656 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            
            
            
            if (self.page == 1) {
                [self.dataList removeAllObjects];
               // [self.GreaterThanArray removeAllObjects];
            }
            
            NSMutableArray *listArr = dic[@"values"][@"dataList"];
            NSLog(@"listArr = %@",listArr);
            
            if (![SVTool isEmpty:listArr]) {
                
                
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVShopReportModel *model = [SVShopReportModel mj_objectWithKeyValues:values];
                    //   model.JurisdictionNum = self.JurisdictionNum;
                    //                    [self.modelArr addObject:model];
                   
                     if ((model.sv_mrr_state.integerValue == 0 &&model.sv_mrr_type.integerValue != -1 && model.sv_mrr_type.integerValue != -2) ||[model.sv_mrr_desc isEqualToString:@"充值退款"]) {
                         
                        [self.dataList addObject:model];
                         
                     }
            
                }
            
               
                
            }else{
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
        
        self.threeHeight.constant = 37+ self.dataList.count * 50;
        [self.tableView reloadData];
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //   // if (!kArrayIsEmpty(self.dataList)) {
    //         return self.dataList.count + 2;
    ////    }else{
    ////        return self.dataList.count;
    ////    }
    
  
        return self.dataList.count;
   
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section == 0) {
//        SVOneStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:OneStoreCellID];
//        if (!cell) {
//            cell = [[SVOneStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneStoreCellID];
//        }
//        cell.dict = self.topDict;
//      //  cell.dataList = self.dataList;
//         cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        return cell;
//    }else if (indexPath.section == 1){
//        SVTwoDoBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:TwoDoBusinessCellID];
//        if (!cell) {
//            cell = [[SVTwoDoBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TwoDoBusinessCellID];
//        }
//        cell.order_receivable = self.order_receivable;
//        cell.chongzhiList = self.GreaterThanArray;
//         cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        return cell;
//
//    }else{
        SVRechargeReportCell *cell = [tableView dequeueReusableCellWithIdentifier:RechargeReportCellID];
        if (!cell) {
            cell = [[SVRechargeReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RechargeReportCellID];
        }
        
        cell.model = self.dataList[indexPath.row];
         cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.RevokeBlock = ^{
           // [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
        };
        return cell;
   // }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    return 50;
  
    
}



@end

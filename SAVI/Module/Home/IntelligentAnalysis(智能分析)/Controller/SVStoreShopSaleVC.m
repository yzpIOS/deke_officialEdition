//
//  SVStoreShopSaleVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVStoreShopSaleVC.h"
#import "SVOneStoreCell.h"
#import "SVShopOverviewModel.h"
#import "SVTwoDoBusinessCell.h"
#import "SVStoreLineView.h"
#import "SVIntelligentDetailCell.h"
#import "SVStoreTopView.h"
#import "SVTShopSaleAnalysisCell.h"
#import "SVShopSalesDetailsVC.h"

//static NSString *const ID = @"UITableViewCell";
//static NSString *const OneStoreCellID = @"SVOneStoreCell";
//static NSString *const TwoDoBusinessCellID = @"SVTwoDoBusinessCell";
static NSString *const IntelligentDetailCellID = @"SVTShopSaleAnalysisCell";

@interface SVStoreShopSaleVC ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *valuesArr;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,strong) NSMutableArray *dataList;
//@property (nonatomic,strong) SVFourLabelView *fourLabelView;
@property (nonatomic,strong) SVStoreTopView *storeTopView;
@property (nonatomic,strong) NSMutableArray *GreaterThanArray;
@property (nonatomic,strong) NSDictionary *topDict;
@property (nonatomic,assign) float order_receivable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeHeight;
@property (weak, nonatomic) IBOutlet UILabel *saleAllMoney;
@property (weak, nonatomic) IBOutlet UILabel *saleNumber;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoHeight;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;

@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;

@property (nonatomic,strong) NSString *user_id;

@property (nonatomic,strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *maoliLabel;


@end

@implementation SVStoreShopSaleVC

- (SVStoreTopView *)storeTopView
{
    if (!_storeTopView) {
        _storeTopView = [[NSBundle mainBundle]loadNibNamed:@"SVStoreTopView" owner:nil options:nil].lastObject;
        _storeTopView.frame = CGRectMake(0, 0, ScreenW, 50);
        _storeTopView.memberName.text = @"商品名称";
        _storeTopView.number.text = @"消费笔数";
        _storeTopView.money.text = @"营业总额";
        _storeTopView.chongzhiView.hidden = YES;
        _storeTopView.fatherView.hidden = NO;
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
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.user_id = @"";
    
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVTShopSaleAnalysisCell" bundle:nil] forCellReuseIdentifier:IntelligentDetailCellID];
    
    [self setUpDataUser_id:self.user_id];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification3:) name:@"nitifyName3" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyShopNameAllStore:) name:@"nitifyShopNameAllStore" object:nil];
}

#pragma mark - 时间晒选
-(void)notification3:(NSNotification *)noti{
    
    //    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    self.dic = dic;
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
    //    self.dic = dic;
    
    NSString *type = [dic objectForKey:@"type"];
    if ([type isEqualToString:@"3"]) {// 本月
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.type = type.integerValue;
        
        self.page = 1;
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"2"]){// 昨天
        self.type = type.integerValue;
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
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = [dic objectForKey:@"oneDate"];
        self.twoDate = [dic objectForKey:@"twoDate"];
        // self.page = 1;
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }
    
}

- (void)nitifyShopNameAllStore:(NSNotification *)noti{
    
    //    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
    //    self.dic = dic;
     self.user_id = dic[@"user_id"];
    NSString *type = [NSString stringWithFormat:@"%ld",self.type];
   // NSString *type = [dic objectForKey:@"type"];
    if ([type isEqualToString:@"3"]) {// 本月
       // self.type = type.integerValue;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
       // self.type = type.integerValue;
        
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"2"]){// 昨天
       // self.type = type.integerValue;
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
       // self.type = type.integerValue;
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName3" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyShopNameAllStore" object:nil];
}

- (void)setUpDataUser_id:(NSString *)user_id{
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    // self.type = @"1"; // 默认是今天
    self.page = 1;
    //
    [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
        
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



// 商品销售
- (void)setShopOverviewType:(NSInteger)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2 user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductAnalysis?key=%@&id=0&type=%li&page=%ld&top=%ld&date=%@&date2=%@&user_id=%@",token,(long)type,(long)page,(long)top,date,[NSString stringWithFormat:@"%@ 23:59:59",date2],user_id];
    NSLog(@"dURL = %@",dURL);
     NSString *utf = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic444 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            
            if (self.page == 1) {
                [self.dataList removeAllObjects];
                [self.GreaterThanArray removeAllObjects];
            }
            
           
            NSMutableArray *listArr = dic[@"values"][@"proList"];
             self.topDict = dic[@"values"];
            self.saleAllMoney.text = [NSString stringWithFormat:@"%.2f",[self.topDict[@"order_receivable"]doubleValue]];
            //self.Discount.text = [NSString stringWithFormat:@"%.2f",order_pdgfee];
            self.saleNumber.text = [NSString stringWithFormat:@"%.2f",[self.topDict[@"count"]doubleValue]];
            self.maoliLabel.text = [NSString stringWithFormat:@"%.2f",[self.topDict[@"sv_p_originalprice"]doubleValue]];
            NSLog(@"listArr = %@",listArr);
            if (![SVTool isEmpty:listArr]) {
                  [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                for (NSInteger i = 0;i < listArr.count; i ++) {
                    //字典转模型
                    NSDictionary *values = listArr[i];
                    SVShopOverviewModel *model = [SVShopOverviewModel mj_objectWithKeyValues:values];
                    model.selectVC = 2;// 会员分析
                   
                    [self.dataList addObject:model];
                    
                    
                    if ([model.count floatValue] > 0) {
                        
                        [self.GreaterThanArray addObject:model];
                        
                      
                    }
                }

                float order_receivable = 0.0;
                for (SVShopOverviewModel *model in self.GreaterThanArray) {
                    
                    order_receivable += [model.count doubleValue];
                    NSLog(@"order_receivable = %f",order_receivable);
                    
                }
                
                self.order_receivable = order_receivable;
                
                CGFloat maxY = 0;
                
                [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i = 0; i < self.GreaterThanArray.count ; i++) {
                    
                    SVShopOverviewModel *model = self.GreaterThanArray[i];
 
                    if ([model.count floatValue] <= 0) {//数据为0时
                        
                    }else{
                        SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
                        rankingsV.state = 1;
                        rankingsV.namelabel.text = model.sv_mr_name;
                        rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[model.count doubleValue]];
                        rankingsV.contentLabel.text = [NSString stringWithFormat:@"销售笔数：%@笔  销售毛利：%.2f  毛利率：%.2f%@",model.orderciunt,model.maolili3,model.maolili,@"%"];
                        
                        float twoWide = 210 * [model.count doubleValue] / self.order_receivable;
                        
                        [UIView animateWithDuration:1 animations:^{
                            rankingsV.colorView.width = twoWide;
                        }];
                        rankingsV.colorView.height = 15;
                        rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                        rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                        //  maxY = maxY;
                        maxY = CGRectGetMaxY(rankingsV.frame) + 20;
                        
                        //  maxY = maxY;
                        [self.fatherView addSubview:rankingsV];
                    }
                    
                    
                    
                }
                
                
                if (kArrayIsEmpty(self.fatherView.subviews)) {
                    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
                
                
               
                
            }else{
                if (kArrayIsEmpty(self.GreaterThanArray)) {
                    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    self.twoHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.fatherView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.fatherView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }
                
                /** 所有数据加载完毕，没有更多的数据了 */
               // self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
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
         self.threeHeight.constant = 37+ self.dataList.count * 70;
        [self.tableView reloadData];
        
            for (NSInteger i = 0;i < self.dataList.count; i ++) {
                //字典转模型
               // NSDictionary *values = listArr[i];
                SVShopOverviewModel *model = self.dataList[i];
                NSInteger a = i + 1;
                model.number = [NSString stringWithFormat:@"%ld",a];
               
            }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return self.dataList.count;
  
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        SVTShopSaleAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligentDetailCellID];
        if (!cell) {
            cell = [[SVTShopSaleAnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligentDetailCellID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.memberModel = self.dataList[indexPath.row];
        
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVShopSalesDetailsVC *vc = [[SVShopSalesDetailsVC alloc] init];
    SVShopOverviewModel *model = self.dataList[indexPath.row];
    vc.product_id = model.product_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"来了%ld次",indexPath.row);
//    if (indexPath.section == 0) {
//        return 100;
//    }else if (indexPath.section == 1){
//        return self.GreaterThanArray.count *48 + 35;
//    }else{
        return 70;
  //  }
    
}



@end

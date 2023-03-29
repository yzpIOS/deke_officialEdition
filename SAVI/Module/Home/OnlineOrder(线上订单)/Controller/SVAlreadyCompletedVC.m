//
//  SVAlreadyCompletedVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/3/17.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVAlreadyCompletedVC.h"
#import "SVOnlineOrderCell.h"
#import "SVOnlineTobeDelivered.h"
#import "SVOnlineOrderDetailVC.h"
static NSString*const ID = @"SVOnlineOrderCell";

@interface SVAlreadyCompletedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation SVAlreadyCompletedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight - 60-BottomHeight)];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVOnlineOrderCell" bundle:nil] forCellReuseIdentifier:ID];
   // self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
     [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = BackgroundColor;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnlineOrderPost:) name:@"OnlineOrderPost" object:nil];
     self.page = 1;
    [self setUpRefreshBeginDate:@"" endDate:@"" goodsState:1 numberDay:-1];
    
}

- (void)OnlineOrderPost:(NSNotification *)noti{
    NSDictionary  *dic = [noti userInfo];
    NSString *type = dic[@"type"];
    NSString *oneDate = dic[@"oneDate"];
    NSString *twoDate = dic[@"twoDate"];
    if ([type isEqualToString:@"-1"]) {
         [self setUpDataPageIndex:self.page pageSize:10 beginDate:@"" endDate:@"" goodsState:1 numberDay:-1];
    }else if ([type isEqualToString:@"0"]) {
        [self setUpDataPageIndex:self.page pageSize:10 beginDate:@"" endDate:@"" goodsState:1 numberDay:0];
    }else if ([type isEqualToString:@"1"]){
         [self setUpDataPageIndex:self.page pageSize:10 beginDate:@"" endDate:@"" goodsState:1 numberDay:1];
    }else if ([type isEqualToString:@"2"]){
         [self setUpDataPageIndex:self.page pageSize:10 beginDate:@"" endDate:@"" goodsState:1 numberDay:2];
    }else if ([type isEqualToString:@"3"]){
         [self setUpDataPageIndex:self.page pageSize:10 beginDate:oneDate endDate:twoDate goodsState:1 numberDay:3];
    }else if ([type isEqualToString:@"4"]){
         [self setUpDataPageIndex:self.page pageSize:10 beginDate:oneDate endDate:twoDate goodsState:1 numberDay:4];
    }
}

- (void)setUpRefreshBeginDate:(NSString *)beginDate endDate:(NSString *)endDate goodsState:(NSInteger)goodsState numberDay:(NSInteger)numberDay{
   
    [self setUpDataPageIndex:self.page pageSize:10 beginDate:beginDate endDate:endDate goodsState:goodsState numberDay:numberDay];
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
       // self.page = 1;

        [self setUpDataPageIndex:self.page pageSize:10 beginDate:beginDate endDate:endDate goodsState:goodsState numberDay:numberDay];
    }];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    
    //上拉刷新
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
  //   [self setUpDataPageIndex:self.page pageSize:10];
        [self setUpDataPageIndex:self.page pageSize:10 beginDate:beginDate endDate:endDate goodsState:goodsState numberDay:numberDay];
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



- (void)setUpDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize beginDate:(NSString *)beginDate endDate:(NSString *)endDate goodsState:(NSInteger)goodsState numberDay:(NSInteger)numberDay{
   [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *user_id = [SVUserManager shareInstance].user_id;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/OnlineOrder/GetCateringOnlineOrderPageListByUserId?key=%@",token];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"distributionStatus"] = @(2); // 0是等待配送中 1是配送中
    parames[@"distributionType"] = @(-1);//配送方式
    parames[@"onlinePayType"] = @(-1);
    parames[@"onlinePaymentStatus"] = @(-1);
    parames[@"QueryType"] = @(-1);
    parames[@"userId"] = user_id;
    parames[@"pageIndex"] = @(pageIndex);
    parames[@"pageSize"] = @"10";
    parames[@"queryDayType"] = @(numberDay);
    if (kStringIsEmpty(beginDate)) {
         parames[@"beginDate"] = nil;
    }else{
         parames[@"beginDate"] = beginDate;
    }
   
    if (kStringIsEmpty(endDate)) {
        parames[@"endDate"] = nil;
    }else{
        parames[@"endDate"] = endDate;
    }
    
    parames[@"isQueryPageList"] = @"true";
    parames[@"sv_order_source"] = @(1);
    NSLog(@"parames = %@",parames);
    NSLog(@"durl = %@",dURL);
    [[SVSaviTool sharedSaviTool] POST:dURL parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
         }
        NSLog(@"dic线上订单 = %@",dic);
        NSString *succeed = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
        if ([succeed isEqualToString:@"1"]) {
            NSArray *dataList=[SVOnlineTobeDelivered mj_objectArrayWithKeyValuesArray:dic[@"values"]];
            if (!kArrayIsEmpty(dataList)) {
                [self.dataArray addObjectsFromArray:dataList];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }else{
             [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        [self.tableView reloadData];
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
        
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
    SVOnlineOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVOnlineOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.detailClick.tag = indexPath.row;
    cell.sureBtn.tag = indexPath.row;
    [cell.detailClick addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
     [cell.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)detailClick:(UIButton *)btn{
    SVOnlineOrderDetailVC *detailVC = [[SVOnlineOrderDetailVC alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
   SVOnlineTobeDelivered *model = self.dataArray[btn.tag];
    detailVC.orderId = model.sv_move_order_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 确认发货
- (void)sureBtnClick:(UIButton *)btn{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                     message:@"你确定要确认发货吗？"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                  
                                                               }];
    
      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                //响应事件
           [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
             [SVUserManager loadUserInfo];
           NSString *token = [SVUserManager shareInstance].access_token;
          SVOnlineTobeDelivered *model = self.dataArray[btn.tag];
          NSString *sv_move_order_id = model.sv_move_order_id;
           NSString *dURL=[URLhead stringByAppendingFormat:@"/api/OnlineOrder/ProcessOrder?key=%@&orderId=%@&type=0",token,sv_move_order_id];
          [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
              if ([dic[@"succeed"] intValue] == 1) {
                  self.page = 1;
                  [self setUpRefreshBeginDate:@"" endDate:@"" goodsState:1 numberDay:1];
                 
              }else{
                   [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
              }
              
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              //隐藏提示框
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
          }];
          
                                                            }];
        
    [alert addAction:cancelAction];
    
      [alert addAction:defaultAction];
      
      [self presentViewController:alert animated:YES completion:nil];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

//
//  SVMembershipLevelMianList.m
//  SAVI
//
//  Created by 杨忠平 on 2022/7/23.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVMembershipLevelMianList.h"
#import "SVmembershipLevelListCell.h"
//#import "SVmembershipLevelListCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SVMembershipLevelCell.h"
#import "SVMembershipLevelEditVC.h"
#import "SVMemberLevelPromotionVC.h"
static NSString *const ID = @"SVMembershipLevelCell";
@interface SVMembershipLevelMianList ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) NSMutableArray *dataList;



@end

@implementation SVMembershipLevelMianList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
     self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"升级规则" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
   
    
//    _img.image = [UIImage imageNamed:@"membershipLevel_bg_one"];
//}else if (data.indexNum == 1){
//    _img.image = [UIImage imageNamed:@"membershipLevel_bg_two"];
//}else if (data.indexNum == 2){
//    _img.image = [UIImage imageNamed:@"membershipLevel_bg_three"];
//}else if (data.indexNum == 3){
//    _img.image = [UIImage imageNamed:@"membershipLevel_bg_four"];
    
    self.title = @"会员等级";
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVMembershipLevelCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.pageIndex = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadDataListPageIndex:self.pageIndex];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
//        self.page = 1;
//        self.listView.searchWares.text = nil;
//        //
//        self.isSelect = NO;
//        self.isAllSelect = NO;
//        self.listView.allSelectButton.selected = NO;
//        [self.goodsArr removeAllObjects];
        //调用请求
        [self loadDataListPageIndex:self.pageIndex];
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

        self.pageIndex ++;
       // self.isSelect = YES;
        //调用请求
        [self loadDataListPageIndex:self.pageIndex];

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
    
    [self setUpBottomBtn];
}
#pragma mark - 点击升级规则
- (void)selectbuttonResponseEvent{
    SVMemberLevelPromotionVC *VC = [[SVMemberLevelPromotionVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    VC.hidesBottomBarWhenPushed = YES;
}

- (void)setUpBottomBtn{
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addVipbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30 - BottomHeight);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
}

#pragma mark - 点击添加
- (void)addVipbuttonResponseEvent{
    SVMembershipLevelEditVC *vc = [[SVMembershipLevelEditVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.suessBlock = ^{
        self.pageIndex = 1;
        [self loadDataListPageIndex:self.pageIndex];
    };
}

- (void)loadDataListPageIndex:(NSInteger)pageIndex{
    [SVUserManager loadUserInfo];
    NSString *userID = [SVUserManager shareInstance].user_id;
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/UserV2/GetMemberLevelList?key=%@&pageIndex=%ld&UserId=%@&pageSize=20",[SVUserManager shareInstance].access_token,(long)pageIndex,userID];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (self.pageIndex == 1) {
            [self.dataList removeAllObjects];
        }
        NSLog(@"dic ====---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *listArr = [dataDic objectForKey:@"datas"];
         
            for (int i = 0; i < listArr.count; i++) {
                NSDictionary *dict = listArr[i];
                SVMembershipLevelList *model = [SVMembershipLevelList mj_objectWithKeyValues:dict];
             
                [self.dataList addObject:model];
            }
            
            for (int i = 0; i < self.dataList.count; i++) {
                SVMembershipLevelList *model = self.dataList[i];
                if (i >= 4) {
                    model.indexNum = i%4;
                }else{
                    model.indexNum = i;
                }
            }
           
            
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                /** 普通闲置状态 */
                self.tableView.mj_footer.state = MJRefreshStateIdle;
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
        }else{
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // SVmembershipLevelListCell *cell = []
    
//    static NSString* const cellid =@"SVmembershipLevelListCell";
//    SVmembershipLevelListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid ];
//    if (!cell)
//    {
//        cell = [[SVmembershipLevelListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//    }
//    SVMembershipLevelList*data = self.dataList[indexPath.row];
//    cell.data = data;
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;
//    return cell;
    
    SVMembershipLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVMembershipLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.data = self.dataList[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SVMembershipLevelEditVC *vc = [[SVMembershipLevelEditVC alloc] init];
    vc.model = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.suessBlock = ^{
        self.pageIndex = 1;
        [self loadDataListPageIndex:self.pageIndex];
    };
    

}

#pragma mark -- UITableViewDelegate 方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    titleLabel.textColor = [UIColor whiteColor];;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text=self.title;
    
    self.navigationItem.titleView = titleLabel;
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = navigationBackgroundColor;

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = [UIColor whiteColor];

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
}


@end

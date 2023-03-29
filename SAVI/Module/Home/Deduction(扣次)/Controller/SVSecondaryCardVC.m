//
//  SVSecondaryCardVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/10/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSecondaryCardVC.h"
#import "SVSecondaryCardCell.h"
#import "SVAddSecondaryCardVC.h"
#import "SVCardRechargeInfoModel.h"
#import "SVSubCardRechargeVC.h"
#import "SVSubCardDetailVC.h"
#import "SVComputationTimesVC.h"
static NSString *const SVSecondaryCardCellID = @"SVSecondaryCardCell";

@interface SVSecondaryCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation SVSecondaryCardVC
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    if (self.selectCount == 1) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH  - TopHeight) style:UITableViewStylePlain];
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
       // self.tableView.backgroundColor = GreyFontColor;
        [self.view addSubview:tableView];
        
        [tableView registerNib:[UINib nibWithNibName:@"SVSecondaryCardCell" bundle:nil] forCellReuseIdentifier:SVSecondaryCardCellID];
        self.navigationItem.title = @"选择次卡";
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 取消
        // 编辑
        // [self.tableView setEditing:NO animated:NO];
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.page = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];

        //调用请求
        //    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@""];
        [self getDataPage:self.page top:10];
        /**
         下拉刷新
         */
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            self.page = 1;
            
            // [self.goodsArr removeAllObjects];
            //调用请求
            [self getDataPage:self.page top:10];
            
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
            
            //调用请求
            [self getDataPage:self.page top:10];
            
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
        
    }else if (self.selectCount == 2){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH  - TopHeight) style:UITableViewStylePlain];
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        // self.tableView.backgroundColor = GreyFontColor;
        [self.view addSubview:tableView];
        
          [tableView registerNib:[UINib nibWithNibName:@"SVSecondaryCardCell" bundle:nil] forCellReuseIdentifier:SVSecondaryCardCellID];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 取消
        // 编辑
        // [self.tableView setEditing:NO animated:NO];
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.page = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        
        
        
        //调用请求
        //    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@""];
       // [self cigetDataPage:self.page top:20];
        [self jicikaGetDataPage:self.page top:10];
        /**
         下拉刷新
         */
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            self.page = 1;
            
            // [self.goodsArr removeAllObjects];
            //调用请求
            [self jicikaGetDataPage:self.page top:10];
            
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
            
            //调用请求
             [self jicikaGetDataPage:self.page top:10];
            
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
        
    }else{
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH  - TopHeight) style:UITableViewStylePlain];
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:tableView];
      //  self.tableView.backgroundColor = GreyFontColor;
        [tableView registerNib:[UINib nibWithNibName:@"SVSecondaryCardCell" bundle:nil] forCellReuseIdentifier:SVSecondaryCardCellID];
        
    
        
       // MembershipSetMealCard_Add
        [SVUserManager loadUserInfo];
         NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        NSDictionary *MemberDic = sv_versionpowersDict[@"Member"];
        if (kDictIsEmpty(sv_versionpowersDict)) {
            [self setUpAddBtn];
           
        }else{
            NSString *MembershipSetMealCard_Add = [NSString stringWithFormat:@"%@",MemberDic[@"MembershipSetMealCard_Add"]];
            if (kStringIsEmpty(MembershipSetMealCard_Add)) {
                [self setUpAddBtn];
            }else{
                if ([MembershipSetMealCard_Add isEqualToString:@"1"]) {
                    [self setUpAddBtn];
                }else{
                    UIButton *button = [[UIButton alloc]init];
                    button.alpha = 0.4;
                    button.layer.cornerRadius = 30;
                    button.userInteractionEnabled = YES;
                    [button setImage:[UIImage imageNamed:@"bigcircle"] forState:UIWindowLevelNormal];
                    [button addTarget:self action:@selector(addSuppliersResponseEvent2) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:button];
                 
                        [button mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(60, 60));
                            make.bottom.mas_equalTo(self.view).offset(-30);
                            make.right.mas_equalTo(self.view).offset(-20);
                        }];
                   
                }
            }
        }
        
       
     
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 取消
        // 编辑
        // [self.tableView setEditing:NO animated:NO];
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.page = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        
        
        
        //调用请求
        //    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@""];
        [self getDataPage:self.page top:10];
        /**
         下拉刷新
         */
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            self.page = 1;
            
            // [self.goodsArr removeAllObjects];
            //调用请求
            [self getDataPage:self.page top:10];
            
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
            
            //调用请求
            [self getDataPage:self.page top:10];
            
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

    
}

- (void)addSuppliersResponseEvent2{
    
}

- (void)setUpAddBtn{
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 30;
    [button setImage:[UIImage imageNamed:@"bigcircle"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addSuppliersResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
 
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.bottom.mas_equalTo(self.view).offset(-30);
            make.right.mas_equalTo(self.view).offset(-20);
        }];
}

- (void)jicikaGetDataPage:(NSInteger)page top:(NSInteger)top
{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/GetCardSetmealProductInfo?key=%@&page=%li&pagesize=%li&is_validity=0&member_id=%@",[SVUserManager shareInstance].access_token,(long)page,(long)top,self.member_id];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic 333====---%@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArray = dic[@"values"];
            if (!kArrayIsEmpty(dataArray)) {
                NSMutableArray *array = [SVCardRechargeInfoModel mj_objectArrayWithKeyValuesArray:dataArray];
                [self.dataArray addObjectsFromArray:array];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


- (void)getDataPage:(NSInteger)page top:(NSInteger)top
{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/GetMemberCardSetmealRechargeInfo?key=%@&page=%li&pagesize=%li&is_shelves=0",[SVUserManager shareInstance].access_token,(long)page,(long)top];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic 333====---%@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArray = dic[@"values"][@"dataList"];
            if (!kArrayIsEmpty(dataArray)) {
                NSMutableArray *array = [SVCardRechargeInfoModel mj_objectArrayWithKeyValuesArray:dataArray];
                [self.dataArray addObjectsFromArray:array];
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)addSuppliersResponseEvent{
    SVAddSecondaryCardVC *vc = [[SVAddSecondaryCardVC alloc] init];
    vc.addBlock = ^{
        [self getDataPage:1 top:20];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSecondaryCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SVSecondaryCardCellID];
    if (!cell) {
        cell = [[SVSecondaryCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVSecondaryCardCellID];
    }
    __weak typeof(self) weakSelf = self;
    cell.model_block = ^(SVCardRechargeInfoModel * _Nonnull model) {
        SVSubCardRechargeVC *vc = [[SVSubCardRechargeVC alloc] init];
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
   cell.selectionStyle = UITableViewCellSelectionStyleNone;//也能达到效果。
    cell.selectVC = self.selectCount;
    cell.model = self.dataArray[indexPath.row];
    
    return  cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectCount == 1) {
        SVCardRechargeInfoModel *model =self.dataArray[indexPath.row];
        if (self.model_block) {
            self.model_block(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.selectCount == 2){
        SVComputationTimesVC *vc = [[SVComputationTimesVC alloc] init];
        SVCardRechargeInfoModel *model =self.dataArray[indexPath.row];
        vc.member_id = self.member_id;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SVCardRechargeInfoModel *model =self.dataArray[indexPath.row];
        SVSubCardDetailVC *detailVC = [[SVSubCardDetailVC alloc] init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectCount == 2) {
         return NO;
    }else{
         return YES;
    }
   
    
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}



// 返回一个菜单数组
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray  *actionArray = [NSMutableArray array];
//    // 添加删除操作
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//
//        // 进行删除操作
//    }];
    
    // 添加编辑操作
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"下架" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        SVCardRechargeInfoModel *model =self.dataArray[indexPath.row];
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/UpdateSelectMemberCardSetmealInfo?key=%@&productid=%@&updatestate=0",[SVUserManager shareInstance].access_token,model.product_id];
        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic4353 ====---%@",dic);
            if ([dic[@"succeed"] intValue] == 1) {
                [self getDataPage:1 top:20];
            }
            
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
        
    }];
    // 自定义这个菜单的背景色
    editRowAction.backgroundColor = navigationBackgroundColor;
   // [actionArray addObject:deleteRowAction];
    [actionArray addObject:editRowAction];
    
    return actionArray;
}


@end

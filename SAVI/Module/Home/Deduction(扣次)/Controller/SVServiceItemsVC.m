//
//  SVServiceItemsVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVServiceItemsVC.h"
#import "SVsubCardDetailCell.h"
#import "SVCardRechargeInfoModel.h"
#import "SVServiceItemCell.h"
#import "SVExtendTimeView.h"


static NSString *const ID = @"SVServiceItemCell";
@interface SVServiceItemsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArray;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) SVExtendTimeView *extendTimeView;


@end

@implementation SVServiceItemsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVServiceItemCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 设置tableView的估算高度
    self.tableView.estimatedRowHeight = 60;
    
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

- (void)getDataPage:(NSInteger)page top:(NSInteger)top
{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/GetSetmealacharge?key=%@&page=%li&pagesize=%li&sv_charge_type=1&member_id=%@&product_id=%@&sv_serialnumber=%@",[SVUserManager shareInstance].access_token,(long)page,(long)top,self.member_id,self.model.product_id,self.model.sv_serialnumber];
    NSLog(@"urlStr====---%@",urlStr);
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic 333====---%@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArray = dic[@"values"][@"dataList"];
            if (!kArrayIsEmpty(dataArray)) {
                self.dataArray = [SVCardRechargeInfoModel mj_objectArrayWithKeyValuesArray:dataArray];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVServiceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVServiceItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
   
    __weak typeof(self) weakSelf = self;
    cell.model = self.dataArray[indexPath.row];
    cell.DelayBlock = ^(SVCardRechargeInfoModel * _Nonnull model) {
         [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.maskOneView];
        NSString *time = [model.validity_date substringToIndex:10];
        [SVUserManager shareInstance].timeStr = time;
        [SVUserManager saveUserInfo];
         weakSelf.extendTimeView = [[SVExtendTimeView alloc] init];
      //  weakSelf.extendTimeView.timeStr = model.validity_date;
        weakSelf.extendTimeView.cleanBlock = ^{
            [weakSelf vipCancelResponseEvent];
        };
        
         [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.extendTimeView];
        weakSelf.extendTimeView.sureBlock = ^(NSString * _Nonnull validity_date) {
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/UpdateTimedelayDate?key=%@",[SVUserManager shareInstance].access_token];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"member_id"] = self.member_id;
            parame[@"product_id"] = model.product_id;
            parame[@"userecord_id"] = model.userecord_id;
            parame[@"validity_date"] = validity_date;
            
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"succeed"] intValue] == 1) {
                    self.page = 1;
                    
                    // [self.goodsArr removeAllObjects];
                    //调用请求
                    [self getDataPage:self.page top:10];
                }else{
                   NSString *errmsg= [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                    [SVTool TextButtonActionWithSing:errmsg];
                }
                
                [weakSelf vipCancelResponseEvent];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //隐藏提示框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
        };
        
    };
    
    
    return cell;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.extendTimeView removeFromSuperview];
//    [self.addCustomView removeFromSuperview];
//    [self.setUserdItemView removeFromSuperview];
    
    //[self.tableView reloadData];
    
}

@end

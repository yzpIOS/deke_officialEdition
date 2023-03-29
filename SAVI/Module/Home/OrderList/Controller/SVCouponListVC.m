//
//  SVCouponListVC.m
//  SAVI
//
//  Created by houming Wang on 2019/8/23.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVCouponListVC.h"
#import "SVCouponListCell.h"
#import "SVCouponListModel.h"
#import "SVExpandBtn.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"

static NSString *CouponListCellID = @"CouponListCell";
@interface SVCouponListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger selectIndex;
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SVExpandBtn *qrcode;

@end

@implementation SVCouponListVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"优惠券";
    self.hidesBottomBarWhenPushed = YES;
    
    self.view.backgroundColor = BlueBackgroundColor;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH -50 - TopHeight)];
    self.tableView.backgroundColor = BlueBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //完全没有线   这样就不会显示自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVCouponListCell" bundle:nil] forCellReuseIdentifier:CouponListCellID];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    /**
//     下拉刷新
//     */
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//
//    }];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//
//    // 设置文字
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
//    [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
//
//    // 设置字体
//    header.stateLabel.font = [UIFont systemFontOfSize:12];
//    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
//
//    // 设置颜色
//    header.stateLabel.textColor = [UIColor grayColor];
//    //    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
//
//    //    NSArray *imageArr = [NSArray arrayWithObjects:
//    //                           [UIImage imageNamed:@"MJRefresh_arrowDown"],
//    //                           [UIImage imageNamed:@"MJRefresh_arrow"],nil];
//    //    //1.设置普通状态的动画图片
//    ////    [header setImages:idleImages forState:MJRefreshStateIdle];
//    //    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    //    [header setImages:imageArr forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
//
//    self.tableView.mj_header = header;
    
    [self loadCouponDataCouponCode:@"" queryType:@"0"];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{

        [self loadCouponDataCouponCode:@"" queryType:@"0"];
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
    
    
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
//
////        self.page ++;
////        self.isSelect = YES;
////        //调用请求
////        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@""];
//         [self loadCouponDataCouponCode:@"" queryType:@"0"];
//    }];
//    // 设置文字
//    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
//    [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
//
//    // 设置字体
//    footer.stateLabel.font = [UIFont systemFontOfSize:12];
//
//    // 设置颜色
//    footer.stateLabel.textColor = [UIColor grayColor];
//
//    //    NSArray *idleImages = [NSArray arrayWithObject:[UIImage imageNamed:@"MJRefresh_arrowDown"]];
//    //    NSArray *pullingImages = [NSArray arrayWithObject:[UIImage imageNamed:@"MJRefresh_arrow"]];
//    //    //1.设置普通状态的动画图片
//    //    [footer setImages:pullingImages forState:MJRefreshStateIdle];
//    //    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    //    [footer setImages:idleImages forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
//
//    self.tableView.mj_footer.hidden = YES;
//
//    self.tableView.mj_footer = footer;
    
    
    
    [self addSearchBar];
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.isSelect = NO;// 一进来是没选
   
}

  - (void)rightbuttonResponseEvent{
      if (self.isSelect == YES) {
          SVCouponListModel *model = self.modelArr[self.selIndex.row];
          if (self.couponBlock) {
              self.couponBlock(model, self.selIndex);
          }
          
          [self.navigationController popViewControllerAnimated:YES];
      }else{
          [SVTool TextButtonActionWithSing:@"没有选择优惠券"];
      }
  }


#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
      self.searchBar.placeholder = @"请输入优惠券号码";
      //默认风格
      self.searchBar.barStyle=UIBarStyleDefault;
      //设置键盘类型
      self.searchBar.keyboardType= UIKeyboardTypeDefault;
      //指定代理
      self.searchBar.delegate = self;
      //为UISearchBar添加背景图片
      //searchbar.backgroundColor = [UIColor whiteColor];
      self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
      
       UITextField * searchField;
      if (@available(iOS 13.0, *)) {
          searchField = _searchBar.searchTextField;
            // 输入文本颜色
              searchField.textColor = GlobalFontColor;
          //    searchField.font = [UIFont systemFontOfSize:15];
              
              // 默认文本大小
             // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
              
              searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入优惠券号码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
      }else{
       // [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        searchField = [_searchBar valueForKey:@"_searchField"];
           // 输入文本颜色
           searchField.textColor = GlobalFontColor;
          // searchField.font = [UIFont systemFontOfSize:15];
           // 默认文本大小
           [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
           
           //只有编辑时出现那个叉叉
           searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
      }
    
      
     // searchField.attributedPlaceholder =
      
      //只有编辑时出现那个叉叉
      searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
      searchField.backgroundColor = [UIColor whiteColor];
      searchField.font = [UIFont systemFontOfSize:13];

    //添加到view中
    [self.view addSubview:self.searchBar];
    
    //扫一扫按钮
    self.qrcode = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
    [self.qrcode setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:self.qrcode];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(self.searchBar.mas_right).offset(-20);
    }];
    
}

#pragma mark - UISearchBarDelegate代理方法
//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.qrcode.hidden = NO;
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //调用请求
   // self.page = 1;
   // [self requestDataIndex:1 pageSize:20 suid:0 name:self.keyStr];
    [self loadCouponDataCouponCode:keyStr queryType:@"1"];
    [searchBar resignFirstResponder];
    
}

//退出键盘响应方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //退出设置为显示
    self.qrcode.hidden = NO;
    //移除第一响应者
    [self.searchBar resignFirstResponder];
   //  [self loadCouponDataCouponCode:@"" queryType:@"0"];
}


#pragma mark - UISearchBarDelegate代理方法
//点击搜索栏中的textFiled触发
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.qrcode.hidden = YES;
}

//当用停止编辑时，会调这个方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    self.qrcode.hidden = NO;
    
}

//输入内容就会触发
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//}

//当输入框内容发生变化时，就会触发，能够及时获取到输入框最新的内容
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""]) {
        self.qrcode.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.qrcode.hidden = NO;
    }
    return YES;
}


- (void)scanButtonResponseEvent{
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//         NSString *keyStr = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        self.searchBar.text = name;
//        [weakSelf loadCouponDataCouponCode:keyStr queryType:@"1"];
//
//
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        NSString *keyStr = [resultStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
       self.searchBar.text = resultStr;
       [weakSelf loadCouponDataCouponCode:keyStr queryType:@"1"];
   };
    
    [self.navigationController pushViewController:vc animated:YES];
}
////输入完毕后，会调用这个方法
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//
//    //设置为NO则，当没有数据时，则提示没有找到此商品
//    self.sao = NO;
//
//    //设置为显示
//    self.qrcode.hidden = NO;
//
//    NSString *Str = searchBar.text;
//
//    //解码方法，返回的是一致的字符串
//    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    //提示查询
//    [SVTool IndeterminateButtonAction:self.view withSing:@"正在查询中…"];
//    //设置数组索引为0
//    self.tableviewIndex = 0;
//    //默认选中第一行
//    self.productcategory_id = 0;
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//
//    //调用请求
//    self.page = 1;
//    //调用请求
//    [self getDataPageIndex:self.page pageSize:20 category:0 name:keyStr isn:keyStr read_morespec:@"true"];
//
//    //移除第一响应者
//    [searchBar resignFirstResponder];
//
//}
//
///**
// 退出键盘响应方法
// */
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    //移除第一响应者
//    [self.searchBar resignFirstResponder];
//
//    //退出设置为显示
//    self.qrcode.hidden = NO;
//
//}


- (void)loadCouponDataCouponCode:(NSString *)couponCode queryType:(NSString *)queryType{
   // [SVSaviTool ]
    [SVUserManager loadUserInfo];
    NSString *urlStr;
    if (kStringIsEmpty(self.member_id)) {
        urlStr = [URLhead stringByAppendingFormat:@"/Order/GetCouponListByMemberIdOrCouponCode?key=%@&memberId=%@&couponCode=%@&queryType=%@",[SVUserManager shareInstance].access_token,@"",couponCode,queryType];
    }else{
        urlStr = [URLhead stringByAppendingFormat:@"/Order/GetCouponListByMemberIdOrCouponCode?key=%@&memberId=%@&couponCode=%@&queryType=%@",[SVUserManager shareInstance].access_token,self.member_id,couponCode,queryType];
    }
    NSLog(@"url = %@",urlStr);
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic9999 = %@",dic);
        
       // if (self.page == 1) {
            [self.modelArr removeAllObjects];
       // }
        if ([dic[@"succeed"] intValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![SVTool isEmpty:dic[@"values"]]) {
//                for (NSDictionary *dict in dic[@"values"]) {
//
//                  SVCouponListModel *model = [SVCouponListModel mj_objectWithKeyValues:dict];
//
//                    [self.modelArr addObject:model];
//                }
               self.modelArr = [SVCouponListModel mj_objectArrayWithKeyValuesArray:dic[@"values"]];
//                if (self.modelArr.count == 0) {
//                    self.navigationItem.rightBarButtonItem.
//                }
                
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
            } else {
                
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                //                //提示没有供应商
                //                if (self.modelArr.count == 0) {
                //                    self.noLabel.hidden = NO;
                //                }
                
            }
            
            
            [self.tableView reloadData];
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
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - tableVeiw
//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponListCellID];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVCouponListCell" owner:nil options:nil].lastObject;
        
    }
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.userInteractionEnabled = NO;
//   SVCouponListModel *model =self.modelArr[indexPath.row];
     
    cell.model = self.modelArr[indexPath.row];
    
    if (_selIndex == indexPath) {
        cell.selectIcon.image = [UIImage imageNamed:@"ic_yixuan.png"];
    }else{
        cell.selectIcon.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    SVCouponListModel *model = self.modelArr[indexPath.row];

    //  NSString *sv_coupon_state = [NSString stringWithFormat:@"%ld",model.sv_coupon_state];
    
    if (model.time != 1 && model.time2 != -1) {
         if (model.sv_coupon_use_conditions.floatValue > self.totle_money.floatValue) {
               [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"没满%@元",model.sv_coupon_use_conditions]];
           }else{
               
               self.selectIndex = indexPath.row;
               self.isSelect = YES;
               
               //取消之前的选择
               SVCouponListCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
               // celled.accessoryType = UITableViewCellAccessoryNone;
               celled.selectIcon.image = [UIImage imageNamed:@"ic_mo-ren"];
               //记录当前的选择的位置
               _selIndex = indexPath;
               
               //当前选择的打钩
               SVCouponListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
               //  cell.accessoryType = UITableViewCellAccessoryCheckmark;
               cell.selectIcon.image = [UIImage imageNamed:@"ic_yixuan.png"];
               // [self.tableView reloadData];
           }

    }
   
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end

//
//  SVVipSelectVC.m
//  SAVI
//
//  Created by Sorgle on 2017/5/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVipSelectVC.h"
//tableviewCell
#import "SVVipSelectCell.h"
#import "SVVipSelectModdl.h"
#import "SVExpandBtn.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
static NSString *VipSelectCellID = @"VipSelectCell";
@interface SVVipSelectVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

//tableView
@property (nonatomic,strong) UITableView *tableView;
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SVExpandBtn *qrcode;

/**
 模型数组
 */
@property (nonatomic,strong) NSMutableArray *modelArr;

//会员名
@property (nonatomic,strong) NSMutableArray *nameArr;
//会员电话
@property (nonatomic,strong) NSMutableArray *phoneArr;
//会员等级
@property (nonatomic,strong) NSMutableArray *levelArr;
//会员折扣sv_ml_commondiscount
@property (nonatomic,strong) NSMutableArray *discountArr;
//会员卡号
@property (nonatomic,strong) NSMutableArray *cardnoArr;
//会员ID
@property (nonatomic,strong) NSMutableArray *member_idArr;
//储值
@property (nonatomic,strong) NSMutableArray *sv_mw_availableamountArr;

@property (nonatomic,assign) NSInteger JurisdictionNum;

@property (nonatomic, assign) NSInteger page;

//判断条件
@property (nonatomic, assign) BOOL sao;
// 跨店会员开关是否开启
@property (nonatomic,strong) NSString *sv_branchrelation;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,assign) NSInteger allstore;
@end

@implementation SVVipSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"选择会员";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;

    self.navigationItem.title = @"选择会员";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
        [SVUserManager loadUserInfo];
          NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
           if (kDictIsEmpty(sv_versionpowersDict)) {
               self.allstore = 1;
             //  [self setUpBottomBtn];
           }else{
               NSDictionary *StockManage = sv_versionpowersDict[@"StockManage"];
               if (kDictIsEmpty(StockManage)) {
                   self.allstore = 1;
                  // [self setUpBottomBtn];
               }else{
            
                   // 底部是否添加会员
                   NSString *StorEquery_Jurisdiction = [NSString stringWithFormat:@"%@",StockManage[@"StorEquery_Jurisdiction"]];
                   if (kStringIsEmpty(StorEquery_Jurisdiction)) {
                       self.allstore = 1;
                   }else{
                       if ([StorEquery_Jurisdiction isEqualToString:@"1"]) {
                           self.allstore = 1;
                       }else{
                           self.allstore = 0;
                       }
                   }
                  
               }
                                         
               
           }
        
        NSLog(@" self.allstore  = %ld", self.allstore);
    //添加搜索栏
    [self addSearchBar];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH-64-50)];
    /** 去除tableview 右侧滚动条 */
    //_tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVVipSelectCell" bundle:nil] forCellReuseIdentifier:VipSelectCellID];
    
    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    //调用请求
    [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" allstore:self.allstore];
    
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.searchBar.text = nil;
        //调用请求
        [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.searchBar.text biaoqian:@"" allstore:self.allstore];
        
    }];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    //header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    //header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //调用请求
        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" allstore:self.allstore];
        
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
    
    //初始化数组
    self.phoneArr = [NSMutableArray array];
    self.levelArr = [NSMutableArray array];
    self.discountArr = [NSMutableArray array];
    self.cardnoArr = [NSMutableArray array];


       if (kDictIsEmpty(sv_versionpowersDict)) {
       
           [self setUpBottomBtn];
       }else{
           NSDictionary *Member = sv_versionpowersDict[@"Member"];
           if (kDictIsEmpty(Member)) {
      
               [self setUpBottomBtn];
           }else{
        
               // 底部是否添加会员
               NSString *AddMember = [NSString stringWithFormat:@"%@",Member[@"AddMember"]];
               if (kStringIsEmpty(AddMember)) {
                   [self setUpBottomBtn];
               }else{
                   if ([AddMember isEqualToString:@"1"]) {
                       [self setUpBottomBtn];
                   }else{
                      
                   }
               }
              
           }
                                     
           
       }
    
    self.sv_branchrelation = [SVUserManager shareInstance].sv_branchrelation;
    self.user_id = [SVUserManager shareInstance].user_id;

    
}

- (void)setUpBottomBtn{
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];

}

- (void)addWaresButton{

    SVNewVipVC *VC = [[SVNewVipVC alloc]init];
    
    VC.addVipBlock = ^(){
        //调用请求
        [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" allstore:self.allstore];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar{
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
            self.searchBar.placeholder = @"请输入会员名称、卡号、款号、车牌号码";
        }else{
            self.searchBar.placeholder = @"请输入会员名称、卡号、款号";
        }
    }else{
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
            self.searchBar.placeholder = @"请输入会员名称、卡号、条码、车牌号码";
        }else{
            self.searchBar.placeholder = @"请输入会员名称、卡号、条码";
        }
    }

    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    //设置键盘类型
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.barStyle=UIBarStyleDefault;

    self.searchBar.delegate = self;
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;
    //为UISearchBar添加背景图片
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    //一下代码为修改placeholder字体的颜色和大小
    
   // UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    
     UITextField * searchField;
       if (@available(iOS 13.0, *)) {
           searchField = _searchBar.searchTextField;
             // 输入文本颜色
               searchField.textColor = GlobalFontColor;
           //    searchField.font = [UIFont systemFontOfSize:15];
               
               // 默认文本大小
              // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
           [SVUserManager loadUserInfo];
           if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入会员名称、卡号、电话、车牌号码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}];
           }else{
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入会员名称、卡号、电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}];
           }
             //  searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入会员名称,款号,车牌号码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
       }else{
        // [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
         searchField = [_searchBar valueForKey:@"_searchField"];
            // 输入文本颜色
            searchField.textColor = GlobalFontColor;
           // searchField.font = [UIFont systemFontOfSize:15];
            // 默认文本大小
            [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
          // searchField.placeholder = @"请输入供应商、联系人、电话";
            //只有编辑时出现那个叉叉
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
       }
    
    searchField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    
    self.qrcode=[SVExpandBtn buttonWithType:UIButtonTypeCustom];
    [self.qrcode setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:self.qrcode];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(self.searchBar.mas_right).offset(-10);
    }];
    
    //    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
    //        NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+14,1)];
    //
    //        if ([num isEqualToString:@"0"]) {
    //            self.JurisdictionNum = 0;
    //        }else{
    //            self.JurisdictionNum = 1;
    //        }
    //    }else{
    //        self.JurisdictionNum = 1;
    //    }
    
//    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
//        NSString *number = [SVUserManager shareInstance].sv_app_config;
//        if (number.length < 16) {
//            self.JurisdictionNum = 1;// 不用显示*号
//        }else{
//            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(15,1)];
//
//            if ([num isEqualToString:@"0"]) {
//                self.JurisdictionNum = 0;// 显示*号
//            }else{
//                self.JurisdictionNum = 1;// 不用显示*号
//            }
//        }
//
//    }else{
//        self.JurisdictionNum = 1;
//    }
    
    [SVUserManager loadUserInfo];
             NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
      if (kDictIsEmpty(sv_versionpowersDict)) {
          self.JurisdictionNum = 1;// 不用显示*号
      }else{
       NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Member"][@"MobilePhoneShow"]];
          if ([MobilePhoneShow isEqualToString:@"1"]) {
              self.JurisdictionNum = 1;// 不用显示*号
          }else{
              self.JurisdictionNum = 0;// 显示*号
          }
      }
    
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

//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.sao = YES;
    
    //设置为显示
    self.qrcode.hidden = NO;
    
    NSString *Str = searchBar.text;
    
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //调用请求
    
    self.page = 1;
    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:keyStr biaoqian:@"" allstore:1];
    
    [searchBar resignFirstResponder];
}


/**
 退出键盘响应方法
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self.oneView.search resignFirstResponder];
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
    //退出设置为显示
    self.qrcode.hidden = NO;
    
}

#pragma mark - 跳转到扫一扫
-(void)scanButtonResponseEvent{
    
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        self.sao = YES;
//        weakSelf.page = 1;
//        weakSelf.searchBar.text = name;
//
//        //调用请求
//        [weakSelf getDataPage:weakSelf.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:name biaoqian:@"" allstore:1];
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
        self.sao = YES;
        weakSelf.page = 1;
        weakSelf.searchBar.text = resultStr;
        
        //调用请求
        [weakSelf getDataPage:weakSelf.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:resultStr biaoqian:@"" allstore:1];
    };
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
       [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //xib的cell的创建
    SVVipSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:VipSelectCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVVipSelectCell" owner:nil options:nil].lastObject;
    }
    //赋值
    cell.vipModel = self.modelArr[indexPath.row];
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVVipSelectModdl *model = self.modelArr[indexPath.row];
    if (kStringIsEmpty(model.sv_ml_name) && model.sv_mr_status == 0) { // 正常) {
        return 65;
    }else{
        return 95;
    }
   // return 65;
}

//点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    SVVipSelectModdl *model = self.modelArr[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         //下面以 '2017-04-24 08:57:29'为例代表服务器返回的时间字符串
        NSString *sv_mr_deadline;
        if (kStringIsEmpty(model.sv_mr_deadline)) {
            sv_mr_deadline = @"9999-12-31T23:59:59.999999+08:00";
        }else{
            sv_mr_deadline = model.sv_mr_deadline;
        }
        NSDate *date = [dateFormatter dateFromString:[sv_mr_deadline substringToIndex:10]];

         NSDate *currentdate = [self getCurrentTime];
        int time = [self compareOneDay:currentdate withAnotherDay:date];
    
    if (self.sv_branchrelation.intValue == 2 || self.sv_branchrelation.intValue == 3) {// 允许跨店消费
    
        if (model.sv_mr_status == 0) {
            
             if (time == -1) {// 没过期
                 if (self.vipBlock) {
                     NSString *grade;
                     if (kStringIsEmpty(model.sv_grade_price)) {
                         grade = nil;
                     }else{
                         NSData *data = [model.sv_grade_price dataUsingEncoding:NSUTF8StringEncoding];
                                    NSDictionary *sv_grade_price = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                                    NSLog(@"sv_grade_price = %@",sv_grade_price);
                                   grade = [NSString stringWithFormat:@"%@",sv_grade_price[@"v"]];
                                   NSLog(@"grade = %@",grade);
                         if (grade.doubleValue == 0) { // 等于0的话就是没有选择任何会员价
                             grade = nil;
                         }
                     }
                     
                     self.vipBlock(model.sv_mr_name,model.sv_mr_mobile,model.sv_ml_name,model.sv_ml_commondiscount,model.member_id,model.sv_mw_availableamount,model.sv_mr_headimg,model.sv_mr_cardno,model.sv_mw_availablepoint,model.sv_mw_sumamount,model.sv_mr_birthday,model.sv_mr_pwd,grade,nil,model.memberlevel_id,model.user_id);
                     
                 }
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }else{
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
                 hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
                 //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
                 hud.bezelView.color = [UIColor blackColor];//背景颜色
                 hud.yOffset = -50.0f;
                 
                 hud.mode = MBProgressHUDModeText;
                 hud.label.text = @"已过期";
                 hud.label.textColor = [UIColor whiteColor];//字体颜色
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     //隐藏提示
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     
                 });
             }
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
            hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
            //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
            hud.bezelView.color = [UIColor blackColor];//背景颜色
            hud.yOffset = -50.0f;
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"已挂失";
            hud.label.textColor = [UIColor whiteColor];//字体颜色
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        }
    }else{
        // 不允许跨店消费
        if (model.sv_mr_status == 0) {
           if (time == -1) {// 没过期
                if (self.vipBlock) {
                    NSString *grade;
                    if (kStringIsEmpty(model.sv_grade_price)) {
                        grade = nil;
                    }else{
                        NSData *data = [model.sv_grade_price dataUsingEncoding:NSUTF8StringEncoding];
                                   NSDictionary *sv_grade_price = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                                   NSLog(@"sv_grade_price = %@",sv_grade_price);
                                  grade = [NSString stringWithFormat:@"%@",sv_grade_price[@"v"]];
                                  NSLog(@"grade = %@",grade);
                        if (grade.doubleValue == 0) { // 等于0的话就是没有选择任何会员价
                            grade = nil;
                        }
                    }
                    
                    self.vipBlock(model.sv_mr_name,model.sv_mr_mobile,model.sv_ml_name,model.sv_ml_commondiscount,model.member_id,model.sv_mw_availableamount,model.sv_mr_headimg,model.sv_mr_cardno,model.sv_mw_availablepoint,model.sv_mw_sumamount,model.sv_mr_birthday,model.sv_mr_pwd,grade,nil,model.memberlevel_id,model.user_id);
                    
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
                hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
                //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
                hud.bezelView.color = [UIColor blackColor];//背景颜色
                hud.yOffset = -50.0f;
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"已过期";
                hud.label.textColor = [UIColor whiteColor];//字体颜色
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                });
            }
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
            hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
            //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
            hud.bezelView.color = [UIColor blackColor];//背景颜色
            hud.yOffset = -50.0f;
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"已挂失";
            hud.label.textColor = [UIColor whiteColor];//字体颜色
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        }
    }
    
    
    
}

#pragma mark -得到当前时间date
- (NSDate *)getCurrentTime{
    
    //2017-04-24 08:57:29
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *dateString = [formatter stringFromDate:date];
//    NSLog(@"datastring  = %@",dateString);
    return date;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}

#pragma mark - 请求会员列表数据
- (void)getDataPage:(NSInteger)page top:(NSInteger)top dengji:(NSInteger)dengji fenzhu:(NSInteger)fenzhu liusi:(NSInteger)liusi sectkey:(NSString *)sectkey biaoqian:(NSString *)biaoqian allstore:(NSInteger)allstore {
    
    //    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user?key=%@&page=%li&top=%li&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],page,top,dengji,fenzhu,liusi,sectkey,biaoqian];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@&reg_source=-1&allstore=%ld",[SVUserManager shareInstance].access_token,(long)page,(long)top,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian,allstore];
 //   NSString *strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"memberdic = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
        NSDictionary *valuesDic = [dic objectForKey:@"values"];
        
        NSArray *valuesArr = [valuesDic objectForKey:@"list"];
        
        if (self.page == 1) {
            [self.modelArr removeAllObjects];
        }
        
        if (![SVTool isEmpty:valuesArr]) {
            
            for (NSDictionary *values in valuesArr) {
                //字典转模型
                SVVipSelectModdl *model = [SVVipSelectModdl mj_objectWithKeyValues:values];
                model.JurisdictionNum = self.JurisdictionNum;
                
                [self.modelArr addObject:model];
                
            }
            
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                /** 普通闲置状态 */
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
            
        }
        else {
            /** 所有数据加载完毕，没有更多的数据了 */
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            
            if ([SVTool isEmpty:valuesArr] && self.sao == YES) {
                self.sao = NO;
                [SVTool TextButtonAction:self.view withSing:@"抱歉!没有此会员"];
            }
        }
        
        [self.tableView reloadData];
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
            
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - 懒加载

- (NSMutableArray *)modelArr {
    
    if (!_modelArr) {
        
        _modelArr = [NSMutableArray array];
        
    }
    return _modelArr;
}

-(NSMutableArray *)nameArr{
    if (!_nameArr) {
        
        _nameArr = [NSMutableArray array];
        
    }
    return _nameArr;
}

-(NSMutableArray *)member_idArr{
    if (!_member_idArr) {
        _member_idArr = [NSMutableArray array];
    }
    return _member_idArr;
}

-(NSMutableArray *)sv_mw_availableamountArr{
    if (!_sv_mw_availableamountArr) {
        _sv_mw_availableamountArr = [NSMutableArray array];
    }
    return _sv_mw_availableamountArr;
}




@end

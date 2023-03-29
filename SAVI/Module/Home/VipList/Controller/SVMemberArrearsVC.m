//
//  SVMemberArrearsVC.m
//  SAVI
//
//  Created by houming Wang on 2020/11/23.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVMemberArrearsVC.h"
#import "SVVipListModel.h"
#import "SVVipListTableCell.h"
#import "SVMemberArrearsCell.h"
#import "SVMemberCreditVC.h"
#import "YCMenuView.h"
#import "SVNavShopView.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
static NSString *SVMemberArrearsCellID = @"SVMemberArrearsCell";
@interface SVMemberArrearsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *creditcount;
@property (weak, nonatomic) IBOutlet UILabel *creditamount;
@property (weak, nonatomic) IBOutlet UILabel *membercount;

@property (weak, nonatomic) IBOutlet UILabel *memberamount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,assign) NSInteger dengji;
@property (nonatomic,strong) NSString * sectkey;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 模型数组
 */
@property (nonatomic, strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) NSMutableArray * actionArray;
@property (nonatomic,strong) SVNavShopView *navShopView;
@end

@implementation SVMemberArrearsVC

- (SVNavShopView *)navShopView
{
    if (!_navShopView) {
        _navShopView = [[NSBundle mainBundle]loadNibNamed:@"SVNavShopView" owner:nil options:nil].lastObject;
      //  _navShopView.width = _navShopView.image.width + _navShopView.nameText.width;
       // NSString *sv_ul_name = [SVUserManager shareInstance].sv_us_name;
        _navShopView.nameText.text = @"全部等级";
        
    }
    
    return _navShopView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;

    //默认风格
    self.searchText.borderStyle = UIBarStyleDefault;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopClick)];
    
    // MyTitleView *titleView = [[MyTitleView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,44)];
    
    self.navShopView.intrinsicContentSize = CGSizeMake(_navShopView.image.width + _navShopView.nameText.width,44);
    
    self.navigationItem.titleView = self.navShopView;
    
    self.navShopView.userInteractionEnabled = YES;
    self.navigationItem.titleView = self.navShopView;
    [self.navShopView addGestureRecognizer:tap];
    
    
    self.searchView.layer.cornerRadius = 19;
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    self.searchView.layer.borderWidth = 1;
    
    self.secondView.layer.cornerRadius = 10;
    self.secondView.layer.masksToBounds = YES;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右各10的距离
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVMemberArrearsCell" bundle:nil] forCellReuseIdentifier:SVMemberArrearsCellID];
    self.dengji = 0;
    self.sectkey = @"";
    [self addRefreshData];
    [self loadGetMemberCreditListInfo];
    
}

- (void)tapShopClick{
    [self.actionArray removeAllObjects];
    NSArray *getUserLevel=[SVUserManager shareInstance].getUserLevel;
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"sv_ml_name"] = @"全部等级";
    dictM[@"memberlevel_id"] = @"";
    [dataArray addObject:dictM];
    [dataArray addObjectsFromArray:getUserLevel];
       for (NSDictionary *dic in dataArray) {
           YCMenuAction *action = [YCMenuAction actionWithTitle:dic[@"sv_ml_name"] image:nil handler:^(YCMenuAction *action) {
//                     self.user_id = dict[@"user_id"];
//                     self.navigationItem.rightBarButtonItem.title = dict[@"sv_us_name"];
//                      self.navTitleView.nameText.text = dic[@"sv_us_name"];
//                     [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyNameAllStore" object:nil userInfo:dic];
//                     调用请求
//                     [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                    //[self.rightBtn setTitle:dic[@"sv_ml_name"] forState:UIControlStateNormal];
               self.navShopView.nameText.text = dic[@"sv_ml_name"];
               self.page = 1;
               //提示加载中
               [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
               self.dengji = [dic[@"memberlevel_id"] integerValue];
               //调用请求
              // [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" dengji:];
               [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:self.sectkey biaoqian:@""];
                     
                 }];
                 [self.actionArray addObject:action];
       }
    
    YCMenuView *view = [YCMenuView menuWithActions:self.actionArray width:150 atPoint:CGPointMake(ScreenW*0.5,TopHeight)];
         [view show];
}

- (void)addRefreshData{
    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    //调用请求
   // [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" dengji:];
    [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:self.sectkey biaoqian:@""];
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
//        self.listView.searchWares.text = nil;
//        //
//        self.isSelect = NO;
//        self.isAllSelect = NO;
//        self.listView.allSelectButton.selected = NO;
//        [self.goodsArr removeAllObjects];
        //调用请求
        [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:self.sectkey biaoqian:@""];
        
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
       // self.isSelect = YES;
        //调用请求
      //  [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@"" user_id:self.user_id];
        [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:self.sectkey biaoqian:@""];
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

- (IBAction)scanClick:(id)sender {
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//    self.hidesBottomBarWhenPushed = YES;
//
//
//    VC.saosao_Block = ^(NSString *name){
//
//       // self.sao = YES;
//
//       // weakSelf.searchText.text = name;
//
//        //调用请求
//        [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:name biaoqian:@""];
//
//    };
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        [weakSelf getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:resultStr biaoqian:@""];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 请求会员列表数据
- (void)getDataPage:(NSInteger)page top:(NSInteger)top dengji:(NSInteger)dengji fenzhu:(NSInteger)fenzhu liusi:(NSInteger)liusi sectkey:(NSString *)sectkey biaoqian:(NSString *)biaoqian{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@&allstore=0&hascredit=true",[SVUserManager shareInstance].access_token,(long)page,(long)top,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian];
    //NSLog(@"222---%@",urlStr);
    //NSLog(@"key----%@",[SVUserManager shareInstance].access_token);
    //当URL拼接里有中文时，需要进行编码一下
    NSString *strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic ====---%@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            
            NSDictionary *valuesDic = [dic objectForKey:@"values"];
            
            NSArray *listArr = [valuesDic objectForKey:@"list"];
            
            if (self.page == 1) {
                [self.modelArr removeAllObjects];
            }
            
         //   self.listView.sumVip.text = [NSString stringWithFormat:@"%@",valuesDic[@"rowCount"]];
            
            
            if (![SVTool isEmpty:listArr]) {
                
                
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVVipListModel *model = [SVVipListModel mj_objectWithKeyValues:values];
                  //  model.JurisdictionNum = self.JurisdictionNum;
                    //                    [self.modelArr addObject:model];
                    
//                    if (self.isAllSelect) {
//                        model.isSelect = @"1";
//                        //判断是否是上拉状态状态,上拉状态为no,并不添加
//                        if (self.isSelect) {
//                            for (SVVipListModel *modell in self.goodsArr) {
//                                if ([modell.member_id isEqualToString:model.member_id]) {
//                                    self.num = 0;
//                                    //                                    [self.goodsArr removeObject:modell];
//                                    break;
//                                } else {
//                                    self.num = 1;
//                                }
//                            }
//                            if (self.num == 1) {
//                                [self.goodsArr addObject:model];
//                            }
//                        }
//                    }
                    [self.modelArr addObject:model];
                  
                }
               // self.listView.vipLabel.text = [NSString stringWithFormat:@"%lu",(long)self.goodsArr.count];
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
                
                
            } else {
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
//                if (self.modelArr.count == 0 && self.sao == YES) {
//                    self.sao = NO;
//                    [SVTool TextButtonAction:self.view withSing:@"抱歉!没有此会员"];
//
//                }
            }
            self.number.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.modelArr.count];
            [self.tableView reloadData];
            
            if ([self.tableView.mj_header isRefreshing]) {
                
                [self.tableView.mj_header endRefreshing];
            }
            
            if ([self.tableView.mj_footer isRefreshing]) {
                
                [self.tableView.mj_footer endRefreshing];
            }
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - UISearchBarDelegate代理方法
//点击搜索栏中的textFiled触发
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.listView.scanButton.hidden = YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.scanButton.hidden = YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{

    //设置为显示
    self.scanButton.hidden = NO;
    

    NSString *Str = textField.text;

    //调用请求
    self.page = 1;
    [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:Str biaoqian:@""];
    
   // [searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((self.searchText.returnKeyType = UIReturnKeySearch)) {
        //设置为显示
        self.scanButton.hidden = NO;
        

        NSString *Str = textField.text;

        //调用请求
        self.page = 1;
        [self getDataPage:self.page top:20 dengji:self.dengji fenzhu:0 liusi:0 sectkey:Str biaoqian:@""];
        
        [self.searchText endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![string isEqualToString:@""]) {
        self.scanButton.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([string isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.scanButton.hidden = NO;
    }
    return YES;
}


- (void)loadGetMemberCreditListInfo{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/Member/GetMemberCreditListInfo?key=%@",token];
    NSLog(@"总店dURL = %@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"总店dic = %@",dic);
     //   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *code = dic[@"code"];
        NSDictionary *data = dic[@"data"];
        NSString *msg = dic[@"msg"];
        if ([code isEqual:@1]) {
            if (!kDictIsEmpty(data)) {
                self.creditcount.text = [NSString stringWithFormat:@"%@",data[@"creditcount"]];
                self.creditamount.text = [NSString stringWithFormat:@"%.2f",[data[@"creditamount"]doubleValue]];
                self.membercount.text = [NSString stringWithFormat:@"%@",data[@"membercount"]];
                self.memberamount.text = [NSString stringWithFormat:@"%.2f",[data[@"memberamount"]doubleValue]];
                
            }
         
        }else{
            [SVTool TextButtonAction:self.view withSing:msg?:@"请求数据失败"];
        }
       
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVMemberArrearsCell *cell = [tableView dequeueReusableCellWithIdentifier:SVMemberArrearsCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVMemberArrearsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVMemberArrearsCellID];
    }
    cell.model = self.modelArr[indexPath.row];
//    //转好的模型数组赋值给cell
//    if (self.goodsArr.count == 0) {
//        cell.model = self.modelArr[indexPath.row];
//        cell.index = indexPath;
//    } else {
//        SVVipListModel *model = self.modelArr[indexPath.row];
//
//
//        }
//    cell.model = self.modelArr[indexPath.row];
//    cell.index = indexPath;
    
    
    
    return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //当手指离开某行时，就让某行的选中状态消失
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SVMemberCreditVC *vc = [[SVMemberCreditVC alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.successBlock = ^{
        weakSelf.page = 1;
        //提示加载中
        [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"加载中…"];
        
        //调用请求
       // [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" dengji:];
        [weakSelf getDataPage:weakSelf.page top:20 dengji:weakSelf.dengji fenzhu:0 liusi:0 sectkey:weakSelf.sectkey biaoqian:@""];
        
        [weakSelf loadGetMemberCreditListInfo];
        
    };
    SVVipListModel *model=self.modelArr[indexPath.row];
    vc.member_id = model.member_id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSMutableArray *)modelArr {
    
    if (!_modelArr) {
        
        _modelArr = [NSMutableArray array];
        
    }
    return _modelArr;
}

- (NSMutableArray *)actionArray
{
    if (!_actionArray) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

@end

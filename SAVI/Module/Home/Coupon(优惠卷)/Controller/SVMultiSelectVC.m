//
//  SVMultiSelectVC.m
//  SAVI
//
//  Created by houming Wang on 2018/7/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVMultiSelectVC.h"
#import "SVMultiSelectCell.h"
#import "SVVipListModel.h"

#import "SVCouponVC.h"

static NSString *MultiSelectCellID = @"MultiSelectCell";
@interface SVMultiSelectVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
//搜索的关键词
@property (nonatomic,strong) NSString *keyStr;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UILabel *vipNumber;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *goodsArr;
@property (nonatomic,strong) NSArray *dataAry;

@property (nonatomic,assign) int num;

@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *allSelectLabel;
@property (weak, nonatomic) IBOutlet UIButton *Hair;

@end

@implementation SVMultiSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择会员";
    self.view.backgroundColor = RGBA(233, 239, 239, 1);
    
    [self addSearchBar];
    
    [self.allSelectButton setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
    self.vipNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, ScreenW, 15)];
    self.vipNumber.textColor = GreyFontColor;
    self.vipNumber.textAlignment = NSTextAlignmentCenter;
    self.vipNumber.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.vipNumber];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, ScreenW, ScreenH-TopHeight-50-70)];
//    self.tableView.backgroundColor = BlueBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVMultiSelectCell" bundle:nil] forCellReuseIdentifier:MultiSelectCellID];
    
    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    //调用请求
    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@""];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.searchBar.text = nil;
        self.isSelect = NO;
        self.allSelectButton.selected = NO;
        [self.goodsArr removeAllObjects];
        //调用请求
        [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@""];
        
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
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        self.page ++;
        self.isSelect = YES;
        //调用请求
        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.searchBar.text biaoqian:@""];
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

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.searchBar.placeholder = @"请输入会员名称/卡号/电话";
    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeDefault;
    self.searchBar.delegate = self;
    
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;
    //为UISearchBar添加背景图片
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    //一下代码为修改placeholder字体的颜色和大小

       UITextField * searchField;
       if (@available(iOS 13.0, *)) {
           searchField = _searchBar.searchTextField;
             // 输入文本颜色
               searchField.textColor = GlobalFontColor;
           //    searchField.font = [UIFont systemFontOfSize:15];
               
               // 默认文本大小
              // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
               
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入会员名称/卡号/电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
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

    [self.view addSubview:self.searchBar];
    
}

#pragma mark - UISearchBarDelegate代理方法
//让 UISearchBar 支持空搜索，当没有输入的时候，search 按钮一样可以点击
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}
//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //调用请求
    self.page = 1;
    [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.keyStr biaoqian:@""];
    
    [searchBar resignFirstResponder];
    
}

//退出键盘响应方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
}

- (IBAction)HairButton {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect CONTAINS %@",@"1"]; // name\pinYin\pinYinHead不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
    NSArray *dataAry = [self.modelArr filteredArrayUsingPredicate:predicate];
    
    if (dataAry.count > [self.sv_coupon_surplus_num integerValue]) {
        [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"优惠券只剩%@张未发放!",self.sv_coupon_surplus_num]];
        return;
    }
    
    if (dataAry.count == 0) {
        
        [SVTool TextButtonAction:self.view withSing:@"请选择会员"];
        
    } else {
        [SVTool IndeterminateButtonAction:self.view withSing:nil];
        [self.Hair setEnabled:NO];
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/PostCouponRecode?key=%@",[SVUserManager shareInstance].access_token];
        
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        NSMutableArray *arr = [NSMutableArray array];
        for (SVVipListModel *model in dataAry) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:model.member_id forKey:@"UseIds"];
            [dict setObject:model.sv_mr_mobile forKey:@"sv_mr_mobile"];
            [dict setObject:model.sv_mr_name forKey:@"sv_mr_name"];
            [arr addObject:dict];
        }
        [par setObject:self.sv_coupon_id forKey:@"sv_coupon_id"];
        [SVUserManager loadUserInfo];
        NSString *sv_us_name = [SVUserManager shareInstance].sv_us_name;
        if (!kStringIsEmpty(sv_us_name)) {
            [par setObject:sv_us_name forKey:@"ShopName"];
        }
       
        [par setObject:arr forKey:@"GenerateUseIds"];
        
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dic[@"succeed"] intValue] == 1) {
                [SVTool TextButtonAction:self.view withSing:@"发放成功"];
                //用延迟来移除提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[SVCouponVC class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                });
            } else {
                [self.Hair setEnabled:YES];
                [SVTool TextButtonAction:self.view withSing:@"数据出错,发放失败"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
}

#pragma mark - 请求会员列表数据
- (void)getDataPage:(NSInteger)page top:(NSInteger)top dengji:(NSInteger)dengji fenzhu:(NSInteger)fenzhu liusi:(NSInteger)liusi sectkey:(NSString *)sectkey biaoqian:(NSString *)biaoqian {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@",[SVUserManager shareInstance].access_token,(long)page,(long)top,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            
            NSDictionary *valuesDic = [dic objectForKey:@"values"];
            
            NSArray *listArr = [valuesDic objectForKey:@"list"];
            
            if (self.page == 1) {
                [self.modelArr removeAllObjects];
            }
            
            self.vipNumber.text = [NSString stringWithFormat:@"共%@位会员",valuesDic[@"rowCount"]];
            
            
            if (![SVTool isEmpty:listArr]) {
                
                
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVVipListModel *model = [SVVipListModel mj_objectWithKeyValues:values];
                    
                    if (self.allSelectButton.selected) {
                        model.isSelect = @"1";
                        //判断是否是上拉状态状态,上拉状态为no,并不添加
                        if (self.isSelect) {
                            for (SVVipListModel *modell in self.goodsArr) {
                                if ([modell.member_id isEqualToString:model.member_id]) {
                                    self.num = 0;
                                    break;
                                } else {
                                    self.num = 1;
                                }
                            }
                            if (self.num == 1) {
                                [self.goodsArr addObject:model];
                            }
                        }
                    }
                    [self.modelArr addObject:model];
                    
                }
                self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(long)self.goodsArr.count];
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
                
            } else {
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            [self.tableView reloadData];
            
            if ([self.tableView.mj_header isRefreshing]) {
                
                [self.tableView.mj_header endRefreshing];
            }
            
            if ([self.tableView.mj_footer isRefreshing]) {
                
                [self.tableView.mj_footer endRefreshing];
                //判断是否选择状态
//                if (self.allSelectButton.selected == YES) {
//
//                    self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(long)self.modelArr.count];
//                }
                
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

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:MultiSelectCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVMultiSelectCell" owner:nil options:nil].lastObject;
        
    }
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.model = self.modelArr[indexPath.row];
    
    if (self.goodsArr.count == 0) {
        cell.model = self.modelArr[indexPath.row];
    } else {
        SVVipListModel *model = self.modelArr[indexPath.row];
        
        for (SVVipListModel *modell in self.goodsArr) {
            if ([modell.member_id isEqualToString:model.member_id]) {
                cell.model = modell;
                return cell;
            }
            cell.model = self.modelArr[indexPath.row];
        }
    }
    self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(long)self.goodsArr.count];
    
    // 这个有点类似sql语句
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect CONTAINS %@",@"1"]; // name\pinYin\pinYinHead不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
//    self.dataAry = [self.modelArr filteredArrayUsingPredicate:predicate];
//    if (self.dataAry.count == 0) {
//        self.allSelectLabel.text = @"0";
//    }else{
//        self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(long)self.dataAry.count];
//    }
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SVVipListModel *model = self.modelArr[indexPath.row];
    if ([model.isSelect isEqualToString:@"1"]) {
        model.isSelect = @"0";
        for (SVVipListModel *modell in self.goodsArr) {
            if ([modell.member_id isEqualToString:model.member_id]) {
                [self.goodsArr removeObject:modell];
                break;
            }
        }
    } else {
        model.isSelect = @"1";
        [self.goodsArr addObject:model];
    }
    
    [self.tableView reloadData];
    self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(long)self.goodsArr.count];
    
}

- (IBAction)allSelectButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.isSelect = sender.selected;
    
    [self.goodsArr removeAllObjects];
    if (sender.selected) {
        
        for (SVVipListModel *model in self.modelArr) {
            model.isSelect = @"1";
            [self.goodsArr addObject:model];
            self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.goodsArr.count];
        }
    } else {
        for (SVVipListModel *model in self.modelArr) {
            model.isSelect = @"0";
            self.allSelectLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.goodsArr.count];
        }
    }
    //这句是刷新
    [self.tableView reloadData];
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}


@end

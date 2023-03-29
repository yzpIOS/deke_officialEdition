//
//  SVVipListVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVipListVC.h"
#import "SVVipListView.h"
#import "SVVipListTableCell.h"
#import "SVNewVipVC.h"
#import "SVVipListModel.h"
#import "SVVipDetailsVC.h"
#import "SVTexting.h"
//添加会员
#import "SVNewVipVC.h"

#import "YCMenuView.h"

//#import "SVRenLei.h"
#import "SVmembershipScreeningView.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"

static NSString *VipListTableCellID = @"VipListTableCell";


@interface SVVipListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//tableView
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic,strong) SVVipListView *listView;


@property (strong, nonatomic)NSMutableArray *datas;

/**
 模型数组
 */
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *goodsArr;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic,assign) int num;
@property (nonatomic,assign) int numbel;
@property (nonatomic,assign) NSInteger JurisdictionNum;
/**
 是否删除会员
 */
@property (nonatomic,assign) NSInteger cleanMemberNum;

//底部按键
@property (nonatomic,strong) UIButton *button;


@property (nonatomic,strong) NSString *user_id;


//添加判断条件
@property (nonatomic,assign) BOOL sao;
@property(nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong) SVmembershipScreeningView * membershipScreeningView;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;

@property (nonatomic,strong) NSString * sectkey;

// 请求所需要的参数
@property (nonatomic,assign) NSInteger dengji;
@property (nonatomic,assign) NSInteger fenzhu;
@property (nonatomic,strong) NSString * biaoqian;
@property (nonatomic,assign) NSInteger liusi;
@property (nonatomic,assign) NSInteger hascredit;
@property (nonatomic,strong) NSString * start_deadline;
@property (nonatomic,strong) NSString * end_deadline;
@property (nonatomic,strong) NSString * storeId;
@property (nonatomic,strong) NSString * reg_start_date;
@property (nonatomic,strong) NSString * reg_end_date;
@property (nonatomic,strong) NSString *sv_employee_id;// 操作人员的ID
@property (nonatomic,assign) NSInteger reg_source;
@end

@implementation SVVipListVC

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectkey = @"";
    self.hidesBottomBarWhenPushed = YES;
    

//    SVRenLei *lei = [[SVRenLei alloc] init];
//    lei.name = @"张三";
  //  NSLog(@"张三：%@",);
    
     [self setUpController];

    
}

#pragma mark - 点击导航栏右边的按钮
- (void)rightbuttonResponseEvent:(UIBarButtonItem *)sender{
//    YCMenuView *view = [YCMenuView menuWithActions:self.listArray width:140 atPoint:CGPointMake(SCREEN_WIDTH - 70,70)];
//      [view show];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.membershipScreeningView];
    
    __weak typeof(self) weakSelf = self;
    self.membershipScreeningView.cancleBlock = ^{
        [weakSelf handlePan];
    };
    
    self.membershipScreeningView.membershipScreeningBlock = ^(NSString * _Nonnull storeId, NSInteger reg_source, NSString * _Nonnull sv_employee_id, NSInteger dengji, NSInteger fenzhu, NSString * _Nonnull biaoqian, NSInteger liusi, NSInteger hascredit, NSString * _Nonnull start_deadline, NSString * _Nonnull end_deadline, NSString * _Nonnull reg_start_date, NSString * _Nonnull reg_end_date) {
        weakSelf.storeId = storeId;
        weakSelf.reg_source = reg_source;
        weakSelf.sv_employee_id = sv_employee_id;
        weakSelf.dengji = dengji;
        weakSelf.fenzhu = fenzhu;
        weakSelf.liusi = liusi;
       // self.sectkey = ;
        weakSelf.biaoqian = biaoqian;
        weakSelf.hascredit = hascredit;
        weakSelf.start_deadline = start_deadline;
        weakSelf.end_deadline = end_deadline;
        weakSelf.reg_start_date = reg_start_date;
        weakSelf.reg_end_date = reg_end_date;
        weakSelf.page = 1;
        [weakSelf getDataPage:weakSelf.page top:20 storeId:storeId reg_source:reg_source sv_employee_id:sv_employee_id dengji:dengji fenzhu:fenzhu liusi:liusi sectkey:weakSelf.sectkey biaoqian:biaoqian hascredit:hascredit start_deadline:start_deadline end_deadline:end_deadline reg_start_date:reg_start_date reg_end_date:reg_end_date];

        [weakSelf handlePan];
    };
    //实现弹出方法
    [UIView animateWithDuration:.3 animations:^{
        self.membershipScreeningView.frame = CGRectMake(ScreenW /6 *1, 0, ScreenW /6 *5, ScreenH);
    }];
    
    
    

}

//移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.3 animations:^{
        self.membershipScreeningView.frame = CGRectMake(ScreenW, 0, ScreenW / 6 *5, ScreenH);
    }];
 
}

/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}



- (void)setUpController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"会员管理";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //创建搜索Xib
    self.listView = [[NSBundle mainBundle]loadNibNamed:@"SVVipListView" owner:nil options:nil].lastObject;
    //self.listView.frame = CGRectMake(0, 0, ScreenW, 81);
    self.listView.searchWares.delegate = self;


    self.listView.searchWares.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    
       UITextField * searchField;
      if (@available(iOS 13.0, *)) {
          searchField = self.listView.searchWares.searchTextField;
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
             ///新的实现
      }else{
       // [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
          [SVUserManager loadUserInfo];
          if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
              self.listView.searchWares.placeholder = @"请输入会员名称、卡号、电话、车牌号码";
          }else{
              self.listView.searchWares.placeholder = @"请输入会员名称、卡号、电话";
          }
        searchField = [self.listView.searchWares valueForKey:@"_searchField"];
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
    
    
    [self.listView.scanButton addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.listView.allSelectButton addTarget:self action:@selector(allSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 81));
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    
    //创建tableView
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 81, ScreenW, ScreenH-TopHeight-81-50-BottomHeight)];
    //_myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.myTableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右各10的距离
    [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"SVVipListTableCell" bundle:nil] forCellReuseIdentifier:VipListTableCellID];
    [self.view addSubview:self.myTableView];

    [self.view addSubview:self.button];
    [SVUserManager loadUserInfo];
    // 一进来就是展示当前店的数据
    self.storeId =[SVUserManager shareInstance].user_id;
    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    //调用请求
   // [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
  //  self.storeId = @"";
    self.reg_source = -1;
    self.sv_employee_id = @"";
    self.dengji = 0;
    self.fenzhu = 0;
    self.liusi = 0;
    self.sectkey = @"";
    self.biaoqian = @"";
    self.hascredit = -1;
    self.start_deadline = @"";
    self.end_deadline = @"";
    self.reg_start_date = @"";
    self.reg_end_date = @"";
    
    [self getDataPage:self.page top:20 storeId:self.storeId reg_source:self.reg_source sv_employee_id:self.sv_employee_id dengji:self.dengji fenzhu:self.fenzhu liusi:self.liusi sectkey:self.sectkey biaoqian:self.biaoqian hascredit:self.hascredit start_deadline:self.start_deadline end_deadline:self.end_deadline reg_start_date:self.reg_start_date reg_end_date:self.reg_end_date];

    /**
     下拉刷新
     */
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        self.listView.searchWares.text = nil;
        //
        self.isSelect = NO;
        self.isAllSelect = NO;
        self.listView.allSelectButton.selected = NO;
        [self.goodsArr removeAllObjects];
        //调用请求
        [self getDataPage:self.page top:20 storeId:self.storeId reg_source:self.reg_source sv_employee_id:self.sv_employee_id dengji:self.dengji fenzhu:self.fenzhu liusi:self.liusi sectkey:self.sectkey biaoqian:self.biaoqian hascredit:self.hascredit start_deadline:self.start_deadline end_deadline:self.end_deadline reg_start_date:self.reg_start_date reg_end_date:self.reg_end_date];
        
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
    
    self.myTableView.mj_header = header;
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        self.isSelect = YES;
        //调用请求
       // [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@"" user_id:self.user_id];
        [self getDataPage:self.page top:20 storeId:self.storeId reg_source:self.reg_source sv_employee_id:self.sv_employee_id dengji:self.dengji fenzhu:self.fenzhu liusi:self.liusi sectkey:self.sectkey biaoqian:self.biaoqian hascredit:self.hascredit start_deadline:self.start_deadline end_deadline:self.end_deadline reg_start_date:self.reg_start_date reg_end_date:self.reg_end_date];
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
    
    self.myTableView.mj_footer.hidden = YES;
    
    self.myTableView.mj_footer = footer;
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    if (kDictIsEmpty(sv_versionpowersDict)) {
        self.JurisdictionNum = 1;// 不用显示*号
        self.cleanMemberNum = 1; //不删除会员
        [self setUpBottomBtn];
    }else{
        NSDictionary *Member = sv_versionpowersDict[@"Member"];
        if (kDictIsEmpty(Member)) {
            self.JurisdictionNum = 1;// 不用显示*号
            self.cleanMemberNum = 1; //不删除会员
            [self setUpBottomBtn];
        }else{
            // 是否显示完整手机号
           NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",Member[@"MobilePhoneShow"]];
            if (kStringIsEmpty(MobilePhoneShow)) {
                 self.JurisdictionNum = 1;// 不用显示*号
            }else{
                if ([MobilePhoneShow isEqualToString:@"1"]) {
                    self.JurisdictionNum = 1;// 不用显示*号
                }else{
                    self.JurisdictionNum = 0;// 显示*号
                }
            }
            
            // 是否删除会员
            NSString *DeleteMember = [NSString stringWithFormat:@"%@",Member[@"DeleteMember"]];
            if (kStringIsEmpty(DeleteMember)) {
                 self.cleanMemberNum = 1;// 不用显示*号
            }else{
                if ([DeleteMember isEqualToString:@"1"]) {
                    self.cleanMemberNum = 1;// 不用显示*号
                }else{
                    self.cleanMemberNum = 0;// 显示*号
                }
            }
            
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
    
       self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo_black"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent:)];

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
        make.bottom.mas_equalTo(self.view).offset(-70 -BottomHeight);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
}

-(void)allSelectButton:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    self.isAllSelect = sender.selected;
    self.isSelect = sender.selected;
    
    [self.goodsArr removeAllObjects];
    if (sender.selected) {
        
        for (SVVipListModel *model in self.modelArr) {
            model.isSelect = @"1";
            //            for (SVVipListModel *modell in self.goodsArr) {
            //                NSLog(@"modell--%@--model---%@",modell.member_id,model.member_id);
            //                if (modell.member_id == model.member_id) {
            //                    [self.goodsArr removeObject:modell];
            //                    break;
            //                }
            //            }
            [self.goodsArr addObject:model];
            self.listView.vipLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.goodsArr.count];
        }
        //一个section刷新
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        //        [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        //一个cell刷新
        //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        //        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } else {
        
        for (SVVipListModel *model in self.modelArr) {
            model.isSelect = @"0";
            //            for (SVVipListModel *modell in self.goodsArr) {
            //                if (modell.member_id == model.member_id) {
            //                    [self.goodsArr removeObject:modell];
            //                    break;
            //                }
            //            }
            //            self.listView.vipLabel.text = @"0";
            self.listView.vipLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.goodsArr.count];
        }
    }
    //这句是刷新
    [self.myTableView reloadData];
}

#pragma mark - 跳转到扫一扫
-(void)scanButtonResponseEvent{
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        weakSelf.sao = YES;
//
//        weakSelf.listView.searchWares.text = name;
//        weakSelf.sectkey = name;
//        weakSelf.page = 1;
//
//        [weakSelf getDataPage:weakSelf.page top:20 storeId:weakSelf.storeId reg_source:weakSelf.reg_source sv_employee_id:weakSelf.sv_employee_id dengji:weakSelf.dengji fenzhu:weakSelf.fenzhu liusi:weakSelf.liusi sectkey:weakSelf.sectkey biaoqian:weakSelf.biaoqian hascredit:weakSelf.hascredit start_deadline:weakSelf.start_deadline end_deadline:weakSelf.end_deadline reg_start_date:weakSelf.reg_start_date reg_end_date:weakSelf.reg_end_date];
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
        
                weakSelf.sao = YES;
        
                weakSelf.listView.searchWares.text = resultStr;
                weakSelf.sectkey = resultStr;
                weakSelf.page = 1;
        
                [weakSelf getDataPage:weakSelf.page top:20 storeId:weakSelf.storeId reg_source:weakSelf.reg_source sv_employee_id:weakSelf.sv_employee_id dengji:weakSelf.dengji fenzhu:weakSelf.fenzhu liusi:weakSelf.liusi sectkey:weakSelf.sectkey biaoqian:weakSelf.biaoqian hascredit:weakSelf.hascredit start_deadline:weakSelf.start_deadline end_deadline:weakSelf.end_deadline reg_start_date:weakSelf.reg_start_date reg_end_date:weakSelf.reg_end_date];
        };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate代理方法
//点击搜索栏中的textFiled触发
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.listView.scanButton.hidden = YES;
}

//当用停止编辑时，会调这个方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    self.listView.scanButton.hidden = NO;
    
}

//当输入框内容发生变化时，就会触发，能够及时获取到输入框最新的内容
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""]) {
        self.listView.scanButton.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.listView.scanButton.hidden = NO;
    }
    return YES;
}

//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.sao = YES;
    
    //设置为显示
    self.listView.scanButton.hidden = NO;
    
    //不是全选
    if (self.isAllSelect) {
        self.listView.allSelectButton.selected = YES;
    }
    //    self.isAllSelect = NO;
    //    self.isSelect = NO;
    
    NSString *Str = searchBar.text;
    self.sectkey = Str;
    
    //调用请求
    self.page = 1;
//#warning 这里要改
   // [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:Str biaoqian:@"" user_id:self.user_id];
    [self getDataPage:self.page top:20 storeId:self.storeId reg_source:self.reg_source sv_employee_id:self.sv_employee_id dengji:self.dengji fenzhu:self.fenzhu liusi:self.liusi sectkey:self.sectkey biaoqian:self.biaoqian hascredit:self.hascredit start_deadline:self.start_deadline end_deadline:self.end_deadline reg_start_date:self.reg_start_date reg_end_date:self.reg_end_date];
    
    [searchBar resignFirstResponder];
    
}


/**
 退出键盘响应方法
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self.oneView.search resignFirstResponder];
    
    //移除第一响应者
    [self.listView.searchWares resignFirstResponder];
    
    //退出设置为显示
    self.listView.scanButton.hidden = NO;
    
}

#pragma mark - 群发送短信按钮
-(void)textingButtonResponseEvent{
    
    if (self.goodsArr.count == 0) {
        
        [SVTool TextButtonAction:self.view withSing:@"请选择会员"];
        
    } else {
        
        
        SVTexting *VC = [[SVTexting alloc]init];
        
        NSMutableArray *idAry = [[NSMutableArray alloc]init];
        for (SVVipListModel *model in self.goodsArr) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:model.sv_mr_mobile forKey:@"Mobile"];
            [dict setObject:model.member_id forKey:@"Memberid"];
            [idAry addObject:dict];
        }
        
        VC.phoneIDArr = idAry;
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
}

//右上角侧---筛选会员
-(void)buttonResponseEvent{
    
}

/**
 添加会员响应的方法
 */
-(void)addVipbuttonResponseEvent{
    SVNewVipVC *VC = [[SVNewVipVC alloc]init];
    
    __weak typeof(self) weakSelf = self;
    VC.addVipBlock = ^(){
        //调用请求
//#warning 这里要改
      //  [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
        weakSelf.page = 1;
        
        [weakSelf getDataPage:weakSelf.page top:20 storeId:weakSelf.storeId reg_source:weakSelf.reg_source sv_employee_id:weakSelf.sv_employee_id dengji:weakSelf.dengji fenzhu:weakSelf.fenzhu liusi:weakSelf.liusi sectkey:weakSelf.sectkey biaoqian:weakSelf.biaoqian hascredit:weakSelf.hascredit start_deadline:weakSelf.start_deadline end_deadline:weakSelf.end_deadline reg_start_date:weakSelf.reg_start_date reg_end_date:weakSelf.reg_end_date];
        
    };
    
    [self.navigationController pushViewController:VC animated:YES];
}
//self.membershipScreeningView.membershipScreeningBlock = ^(NSString * _Nonnull storeId, NSInteger reg_source, NSString * _Nonnull sv_employee_id, NSInteger dengji, NSInteger fenzhu, NSInteger biaoqian, NSInteger liusi, BOOL hascredit, NSString * _Nonnull start_deadline, NSString * _Nonnull end_deadline, NSString * _Nonnull reg_start_date, NSString * _Nonnull reg_end_date) {
#pragma mark - 请求会员列表数据
- (void)getDataPage:(NSInteger)page top:(NSInteger)top storeId:(NSString *)storeId reg_source:(NSInteger)reg_source sv_employee_id:(NSString *)sv_employee_id dengji:(NSInteger)dengji fenzhu:(NSInteger)fenzhu liusi:(NSInteger)liusi sectkey:(NSString *)sectkey biaoqian:(NSString *)biaoqian hascredit:(NSInteger)hascredit start_deadline:(NSString *)start_deadline end_deadline:(NSString *)end_deadline reg_start_date:(NSString *)reg_start_date reg_end_date:(NSString *)reg_end_date{
    
    NSString *urlStr;
    [SVUserManager loadUserInfo];
    if (hascredit == -1) {
        urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&user_id=%@&reg_source=%ld&creator=%@&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@&start_deadline=%@&end_deadline=%@&reg_start_date=%@&reg_end_date=%@&allstore=1&birthday=0",[SVUserManager shareInstance].access_token,(long)page,(long)top,storeId,reg_source,sv_employee_id,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian,start_deadline,end_deadline,reg_start_date,reg_end_date];
    }else if (hascredit == 0){ //正常
        urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&user_id=%@&reg_source=%ld&creator=%@&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@&hascredit=%@&start_deadline=%@&end_deadline=%@&reg_start_date=%@&reg_end_date=%@&allstore=1&birthday=0",[SVUserManager shareInstance].access_token,(long)page,(long)top,storeId,reg_source,sv_employee_id,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian,@"false",start_deadline,end_deadline,reg_start_date,reg_end_date];
    }else{ // 欠款
        urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&user_id=%@&reg_source=%ld&creator=%@&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@&hascredit=%@&start_deadline=%@&end_deadline=%@&reg_start_date=%@&reg_end_date=%@&allstore=1&birthday=0",[SVUserManager shareInstance].access_token,(long)page,(long)top,storeId,reg_source,sv_employee_id,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian,@"true",start_deadline,end_deadline,reg_start_date,reg_end_date];
    }
    
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
            
            self.listView.sumVip.text = [NSString stringWithFormat:@"%@",valuesDic[@"rowCount"]];
            
            
            if (![SVTool isEmpty:listArr]) {
                
                
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVVipListModel *model = [SVVipListModel mj_objectWithKeyValues:values];
                    model.JurisdictionNum = self.JurisdictionNum;
                    //                    [self.modelArr addObject:model];
                    
                    if (self.isAllSelect) {
                        model.isSelect = @"1";
                        //判断是否是上拉状态状态,上拉状态为no,并不添加
                        if (self.isSelect) {
                            for (SVVipListModel *modell in self.goodsArr) {
                                if ([modell.member_id isEqualToString:model.member_id]) {
                                    self.num = 0;
                                    //                                    [self.goodsArr removeObject:modell];
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
                self.listView.vipLabel.text = [NSString stringWithFormat:@"%lu",(long)self.goodsArr.count];
                if (self.myTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.myTableView.mj_footer.state = MJRefreshStateIdle;
                }
                
                
            } else {
                /** 所有数据加载完毕，没有更多的数据了 */
                self.myTableView.mj_footer.state = MJRefreshStateNoMoreData;
                
                if (self.modelArr.count == 0 && self.sao == YES) {
                    self.sao = NO;
                    [SVTool TextButtonAction:self.view withSing:@"抱歉!没有此会员"];
                    
                }
            }
            
            [self.myTableView reloadData];
            
            if ([self.myTableView.mj_header isRefreshing]) {
                
                [self.myTableView.mj_header endRefreshing];
            }
            
            if ([self.myTableView.mj_footer isRefreshing]) {
                
                [self.myTableView.mj_footer endRefreshing];
                //判断是否选择状态
                //            if (self.listView.allSelectButton.selected == YES) {
                //
                //                self.listView.vipLabel.text = [NSString stringWithFormat:@"%lu",(long)self.goodsArr.count];
                //            }
                
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


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVVipListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:VipListTableCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVVipListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VipListTableCellID];
    }
    
    //转好的模型数组赋值给cell
    if (self.goodsArr.count == 0) {
        cell.model = self.modelArr[indexPath.row];
        cell.index = indexPath;
    } else {
        SVVipListModel *model = self.modelArr[indexPath.row];
        
        for (SVVipListModel *modell in self.goodsArr) {
            if ([modell.member_id isEqualToString:model.member_id]) {
                cell.model = modell;
                cell.index = indexPath;
                return cell;
            }
            cell.model = self.modelArr[indexPath.row];
            cell.index = indexPath;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    cell.model_block = ^(SVVipListModel *model,NSIndexPath *index){
        
        [weakSelf.modelArr replaceObjectAtIndex:index.row withObject:model];//替换数据源，好了可以去刷新了
        // 这个有点类似sql语句
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect CONTAINS %@",@"1"]; // name\pinYin\pinYinHead不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
        NSArray *dataAry = [weakSelf.modelArr filteredArrayUsingPredicate:predicate];
        if (dataAry.count == weakSelf.modelArr.count) {
            //全选
            weakSelf.listView.allSelectButton.selected = YES;
        }else{
            //不是全选
            weakSelf.listView.allSelectButton.selected = NO;
            //            weakSelf.isAllSelect = NO;
            //            weakSelf.isSelect = NO;
        }
        
        
        if (weakSelf.goodsArr.count == 0) {
            //第一个选中时添加
            [weakSelf.goodsArr addObject:model];
            
        } else {
            //判断相同时
            for (SVVipListModel *modell in weakSelf.goodsArr) {
                if (modell.member_id == model.member_id) {
                    [weakSelf.goodsArr removeObject:modell];
                    break;
                }
            }
            //为0时，不添加
            if ([model.isSelect isEqualToString:@"1"]) {
                [weakSelf.goodsArr addObject:model];
            }
            
        }
        weakSelf.listView.vipLabel.text = [NSString stringWithFormat:@"%lu",(long)weakSelf.goodsArr.count];
    };
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVVipListModel *model = self.modelArr[indexPath.row];
    if (kStringIsEmpty(model.sv_ml_name) && model.sv_mr_status == 0) { // 正常) {
        return 65;
    }else{
        return 90;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVVipListModel *model = self.modelArr[indexPath.row];
    if (model.sv_mr_status == 0) { // 正常状态
        
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
        //     NSDate *date2 = [dateFormatter dateFromString:[model.sv_coupon_bendate substringToIndex:10]];
             NSDate *currentdate = [self getCurrentTime];
            int time = [self compareOneDay:currentdate withAnotherDay:date];
        
            if (time == -1) {// 没过期
             SVVipDetailsVC *VC = [[SVVipDetailsVC alloc]init];
                VC.memberID = model.member_id;
                VC.memberlevel_id = model.memberlevel_id;
                VC.sv_mr_platenumber = model.sv_mr_platenumber;
                
                __weak typeof(self) weakSelf = self;
                VC.VipDetailsBlock = ^(){
                    weakSelf.page = 1;
                    
                    [weakSelf getDataPage:weakSelf.page top:20 storeId:weakSelf.storeId reg_source:weakSelf.reg_source sv_employee_id:weakSelf.sv_employee_id dengji:weakSelf.dengji fenzhu:weakSelf.fenzhu liusi:weakSelf.liusi sectkey:weakSelf.sectkey biaoqian:weakSelf.biaoqian hascredit:weakSelf.hascredit start_deadline:weakSelf.start_deadline end_deadline:weakSelf.end_deadline reg_start_date:weakSelf.reg_start_date reg_end_date:weakSelf.reg_end_date];
                    //调用请求
//#warning 这里要改
                  //  [weakSelf getDataPage:weakSelf.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                };
                
                [self.navigationController pushViewController:VC animated:YES];
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

#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cleanMemberNum == 1) {
         return TRUE;
    }else{
        return FALSE;
    }
   
    
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //这个方法里有一个出错 2018.1.09
    
    SVVipListModel *model = self.modelArr[indexPath.row];
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row<[self.modelArr count]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SVVipListModel *model = self.modelArr[indexPath.row];
                if (model.sv_mw_credit > 0) {
                    [SVTool TextButtonAction:self.view withSing:@"会员还有积分，不能删除"];
                    // return ;
                }else if (model.sv_mw_availableamount.integerValue > 0){
                    [SVTool TextButtonAction:self.view withSing:@"会员还有余额，不能删除"];
                }else if (model.sv_mw_credit > 0){
                    [SVTool TextButtonAction:self.view withSing:@"会员还有欠款，不能删除"];
                }else{
                    [SVUserManager loadUserInfo];
                    NSString *userID = [SVUserManager shareInstance].user_id;
                    NSString *token = [SVUserManager shareInstance].access_token;
                    NSString *sv_mr_modifier = @"0";
                    
                    //url
                    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/User/DeleteMember?userId=%@&key=%@&memberId=%@&sv_mr_modifier=%@",userID,token,model.member_id,sv_mr_modifier];
                    [[SVSaviTool sharedSaviTool] POST:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        
                        
                        if ([dic[@"succeed"] integerValue] == 1) {
                            
                            //移除数据源的数据
                            [self.modelArr removeObjectAtIndex:indexPath.row];
                            
                            //移除tableView中的数据
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            
                            [self.myTableView reloadData];
                            
                            
                        } else {
                            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"values"]];
                            [SVTool TextButtonAction:self.view withSing:errmsg];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    }];
                    
//                    [[SVSaviTool sharedSaviTool] POST:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                        
//                        
//                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                        
//                        
//                        if ([dic[@"succeed"] integerValue] == 1) {
//                            
//                            //移除数据源的数据
//                            [self.modelArr removeObjectAtIndex:indexPath.row];
//                            
//                            //移除tableView中的数据
//                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//                            
//                            [self.myTableView reloadData];
//                            
//                            
//                        } else {
//                            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"values"]];
//                            [SVTool TextButtonAction:self.view withSing:errmsg];
//                        }
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//                    }];
                }
                
            }];
            [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
            [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
            
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定要删除吗？"];
            //设置文本颜色
            [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 7)];
            //设置文本字体大小
            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
            [alert setValue:hogan forKey:@"attributedTitle"];
            
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}

#pragma mark - 懒加载
-(SVVipListView *)listView{
    if (!_listView) {
        _listView = [[SVVipListView alloc]init];
    }
    return _listView;
}

-(UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - TopHeight - 50-BottomHeight, ScreenW, 50)];
        [_button setTitle:@"发短信" forState:UIControlStateNormal];
        [_button setBackgroundColor:navigationBackgroundColor];
        [_button addTarget:self action:@selector(textingButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (NSMutableArray *)modelArr {
    
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

//并收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (SVmembershipScreeningView *)membershipScreeningView{
    if (!_membershipScreeningView) {
        _membershipScreeningView = [[NSBundle mainBundle]loadNibNamed:@"SVmembershipScreeningView" owner:nil options:nil].lastObject;
        _membershipScreeningView.frame = CGRectMake(ScreenW, 0, ScreenW /6 *5, ScreenH);
        
    }
    return _membershipScreeningView;
}

@end

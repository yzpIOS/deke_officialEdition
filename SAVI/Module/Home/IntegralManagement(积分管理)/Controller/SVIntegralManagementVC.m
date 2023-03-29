//
//  SVIntegralManagementVC.m
//  SAVI
//
//  Created by F on 2020/8/1.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVIntegralManagementVC.h"
#import "SVExpandBtn.h"
#import "SVVipSelectVC.h"
#import "SVVipSelectModdl.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
@interface SVIntegralManagementVC ()<UISearchBarDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) SVExpandBtn *qrcode;

@property (weak, nonatomic) IBOutlet UIView *careView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *name_leval;
@property (weak, nonatomic) IBOutlet UILabel *care;
@property (weak, nonatomic) IBOutlet UILabel *storeValues;
@property (weak, nonatomic) IBOutlet UILabel *availablepoint;
@property (weak, nonatomic) IBOutlet UILabel *sumpoint;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (nonatomic,strong) UIButton *tagBtn;

@property (weak, nonatomic) IBOutlet UIButton *integralAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *integralReduceBtn;

@property (weak, nonatomic) IBOutlet UIButton *integralClearingBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *member_id;
@property (weak, nonatomic) IBOutlet UITextField *noteText;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) NSString * user_id;
@end

@implementation SVIntegralManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
     self.hidesBottomBarWhenPushed = YES;
    self.title = @"积分管理";
    [self.integralAddBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
//    [self.integralAddBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateSelected];
    self.integralClearingBtn.layer.cornerRadius = 22.5;
    self.integralClearingBtn.layer.masksToBounds = YES;
    self.header.hidden = YES;
    self.sureBtn.layer.cornerRadius = 22.5;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.header.layer.cornerRadius = 25;
    self.header.layer.masksToBounds = YES;
    
    [self.integralAddBtn addTarget:self action:@selector(integralAddAndReduceClick:) forControlEvents:UIControlEventTouchUpInside];
    self.integralAddBtn.tag = 0;
    [self integralAddAndReduceClick:self.integralAddBtn];
    [self.integralReduceBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    self.scrollView.delegate = self;
//    [self.integralReduceBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateSelected];
    [self.integralReduceBtn addTarget:self action:@selector(integralAddAndReduceClick:) forControlEvents:UIControlEventTouchUpInside];
    self.integralReduceBtn.tag = 1;
    
    self.careView.layer.cornerRadius = 10;
    self.careView.layer.masksToBounds = YES;
    
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    self.integralClearingBtn.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    self.sureBtn.userInteractionEnabled = NO;
    self.integralClearingBtn.userInteractionEnabled = NO;
    [self setUpUI];
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
    
  //  self.sao = YES;
    
    //设置为显示
    self.qrcode.hidden = NO;
    
    //不是全选
//    if (self.isAllSelect) {
//        self.listView.allSelectButton.selected = YES;
//    }
    //    self.isAllSelect = NO;
    //    self.isSelect = NO;
    
    NSString *Str = searchBar.text;
    
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //调用请求
    //self.page = 1;
    [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:keyStr biaoqian:@""];
    
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

- (void)setUpUI{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"选择会员" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
     //和其他文本输入控件的placeholder相同，在输入文字时就会消失
       self.searchBar.placeholder = @"请输入完整手机号或会员名称";
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
               
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入完整手机号或会员名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}]; ///新的实现
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

- (void)scanButtonResponseEvent{
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//        VC.saosao_Block = ^(NSString *name){
//           // self.textLabel.hidden = YES;
//            [weakSelf getDataPage:1 top:1 dengji:0 fenzhu:0 liusi:0 sectkey:name biaoqian:@""];
//
//        };
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
        // self.textLabel.hidden = YES;
         [weakSelf getDataPage:1 top:1 dengji:0 fenzhu:0 liusi:0 sectkey:resultStr biaoqian:@""];
         
     };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 请求会员列表数据
- (void)getDataPage:(NSInteger)page top:(NSInteger)top dengji:(NSInteger)dengji fenzhu:(NSInteger)fenzhu liusi:(NSInteger)liusi sectkey:(NSString *)sectkey biaoqian:(NSString *)biaoqian {
    self.sureBtn.userInteractionEnabled = NO;
    [SVUserManager loadUserInfo];
    // 换成了精确搜索
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/GetMemberList?key=%@&page=%li&top=%li&dengji=%li&fenzhu=%li&liusi=%li&cardno=%@&biaoqian=%@",[SVUserManager shareInstance].access_token,(long)page,(long)top,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian];
    //NSLog(@"222---%@",urlStr);
    //NSLog(@"key----%@",[SVUserManager shareInstance].access_token);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic ====---%@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            
            NSDictionary *valuesDic = [dic objectForKey:@"values"];
            
            NSArray *listArr = [valuesDic objectForKey:@"list"];
            if (kArrayIsEmpty(listArr)) {
                [SVTool TextButtonActionWithSing:@"没有这个会员"];
            }else{

                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVVipSelectModdl *model = [SVVipSelectModdl mj_objectWithKeyValues:values];
   
                    
                     
                     self.name_leval.text = [NSString stringWithFormat:@"%@.%@",model.sv_mr_name,model.sv_ml_name];
                     self.care.text = model.sv_mr_cardno;
                     self.storeValues.text = model.sv_mw_availableamount;
                     self.availablepoint.text = model.sv_mw_availablepoint;
                     self.sumpoint.text = model.sv_mw_sumamount;
                    // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
                     self.birthday.text = [model.sv_mr_birthday substringWithRange:NSMakeRange(5,5)];//str2 = "is"
                    // NSString *oneText = [self.sv_mr_birthday substringToIndex:10];//（length为7）];
                    self.member_id = model.member_id;
                    self.user_id = model.user_id;
                    if (!kStringIsEmpty(model.member_id)) {
                        self.sureBtn.backgroundColor = navigationBackgroundColor;
                        self.integralClearingBtn.backgroundColor = navigationBackgroundColor;
                        self.sureBtn.userInteractionEnabled = YES;
                        self.integralClearingBtn.userInteractionEnabled = YES;
                     
                    }
                     
                     if (![SVTool isBlankString:model.sv_mr_headimg]) {
                         [self.header sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_mr_headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                     } else {
                         
                         self.header.image = [UIImage imageNamed:@"iconView"];
                     }
                    
                }
                
              // [self loadUserMemberId:self.member_id];
                
            }
           
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
         self.sureBtn.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         self.sureBtn.userInteractionEnabled = YES;
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 点击积分增加和积分扣除的按钮
- (void)integralAddAndReduceClick:(UIButton *)btn{
    self.tagBtn.selected = NO;
          // self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
        [self.tagBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
           btn.selected = YES;
          // btn.layer.borderColor = [[UIColor clearColor] CGColor];
    //       btn.backgroundColor =
        [btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
           self.tagBtn = btn;
    if (btn.tag == 0) {// 是积分增加
        self.type = @"1";
    }else{// 积分扣除
        self.type = @"0";
    }
}


- (void)selectbuttonResponseEvent{
    SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
    
    __weak typeof(self) weakSelf = self;

    VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
//        self.textLabel.hidden = YES;
//        weakSelf.telNum.text = phone;
//        weakSelf.member_id = member_id;
//        weakSelf.name = name;
//        weakSelf.level = level;
//        weakSelf.sv_mr_cardno = sv_mr_cardno;
//        weakSelf.storedValue = storedValue;
//        weakSelf.sv_mw_sumpoint = sv_mw_sumpoint;
//        weakSelf.sv_mw_availablepoint = sv_mw_availablepoint;
//        weakSelf.discount = discount;
//        weakSelf.sv_mr_birthday = sv_mr_birthday;
//        weakSelf.headimg = headimg;
        
        if (!kStringIsEmpty(member_id)) {
            self.sureBtn.backgroundColor = navigationBackgroundColor;
            self.integralClearingBtn.backgroundColor = navigationBackgroundColor;
            self.sureBtn.userInteractionEnabled = YES;
            self.integralClearingBtn.userInteractionEnabled = YES;
            self.header.hidden = NO;
        }
        weakSelf.header.layer.cornerRadius = 25;
         weakSelf.header.layer.masksToBounds = YES;
        weakSelf.member_id = member_id;
         weakSelf.name_leval.text = [NSString stringWithFormat:@"%@.%@",name,level];
         weakSelf.care.text = sv_mr_cardno;
         weakSelf.storeValues.text = storedValue;
         weakSelf.availablepoint.text = sv_mw_availablepoint;
         weakSelf.sumpoint.text = sv_mw_sumpoint;
        self.user_id = user_id;
        // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
         weakSelf.birthday.text = [sv_mr_birthday substringWithRange:NSMakeRange(5,5)];//str2 = "is"
        // NSString *oneText = [self.sv_mr_birthday substringToIndex:10];//（length为7）];
         
         
//         if (![SVTool isBlankString:headimg]) {
//             [weakSelf.header sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
//         } else {
//
//             weakSelf.header.image = [UIImage imageNamed:@"iconView"];
//         }
        
        if (![SVTool isBlankString:headimg]) {
            [self.header sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
            self.nameLabel.hidden = YES;
        } else {
            if (![SVTool isBlankString:name]) {
                self.nameLabel.hidden = NO;
                self.nameLabel.text = [name substringToIndex:1];
                self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                self.header.image = [UIImage imageNamed:@"icon_black"];
                self.nameLabel.hidden = NO;
            }
            
        }
        
      //  [weakSelf loadUserMemberId:member_id];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 积分清零
- (IBAction)integralClearingClick:(id)sender {
    self.sureBtn.userInteractionEnabled = NO;
      // self.integralClearingBtn.userInteractionEnabled = YES;
       NSMutableDictionary *parame = [NSMutableDictionary dictionary];
       [SVUserManager loadUserInfo];
     //  NSString *user_id = [SVUserManager shareInstance].user_id;
       parame[@"type"] = @"2";
    // 晋级开关的判断
    if ([SVUserManager shareInstance].rankPromotion_sv_detail_is_enable.doubleValue == 1) { // 开关开了
        // 分类折扣
        parame[@"availableIntegralSwitch"] = @"true";
        parame[@"isPromote"] = @"true";
        parame[@"rankDemotion"] = @"true";
    }else{
        // 分类折扣
        parame[@"availableIntegralSwitch"] = @"false";
        parame[@"isPromote"] = @"false";
        parame[@"rankDemotion"] = @"false";
    }
       parame[@"user_id"] = self.user_id;
       parame[@"sv_mpr_reason"] = self.noteText.text;
       parame[@"member_id"] = self.member_id;
       parame[@"integral"] = self.availablepoint.text;
       NSLog(@"parame = %@",parame);
       
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Member/UpdateIntegral?key=%@",[SVUserManager shareInstance].access_token];
       [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
           NSLog(@"dic999 ==%@",dic);
           if ([dic[@"code"] intValue] == 1) {
               [SVTool TextButtonActionWithSing:@"操作成功"];
               self.noteText.text = nil;
               self.moneyText.text = nil;
               [self loadMemberData];
           }else{
               NSString *msg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
               [SVTool TextButtonAction:self.view withSing:msg];
           }
           self.sureBtn.userInteractionEnabled = YES;
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           self.sureBtn.userInteractionEnabled = YES;
           [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
       }];
}



#pragma mark - 确定按钮的点击
- (IBAction)sureClick:(id)sender {
    if (self.moneyText.text.length == 0) {
        return [SVTool TextButtonAction:self.view withSing:@"请输入变动金额"];
    }
    self.sureBtn.userInteractionEnabled = NO;
   // self.integralClearingBtn.userInteractionEnabled = YES;
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [SVUserManager loadUserInfo];
   // NSString *user_id = [SVUserManager shareInstance].user_id;
    parame[@"type"] = self.type;
    
    // 晋级开关的判断
    if ([SVUserManager shareInstance].rankPromotion_sv_detail_is_enable.doubleValue == 1) { // 开关开了
        // 分类折扣
        parame[@"availableIntegralSwitch"] = @"true";
        parame[@"isPromote"] = @"true";
        parame[@"rankDemotion"] = @"true";
    }else{
        // 分类折扣
        parame[@"availableIntegralSwitch"] = @"false";
        parame[@"isPromote"] = @"false";
        parame[@"rankDemotion"] = @"false";
    }
//    parame[@"availableIntegralSwitch"] = @"true";
//    parame[@"isPromote"] = @"true";
   
    parame[@"user_id"] = self.user_id;
    parame[@"sv_mpr_reason"] = self.noteText.text;
    parame[@"member_id"] = self.member_id;
    parame[@"integral"] = self.moneyText.text;
    NSLog(@"parame = %@",parame);
    
     NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Member/UpdateIntegral?key=%@",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic999 ==%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            [SVTool TextButtonActionWithSing:@"操作成功"];
            self.noteText.text = nil;
            self.moneyText.text = nil;
            [self loadMemberData];
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
            [SVTool TextButtonAction:self.view withSing:msg];
        }
        self.sureBtn.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.sureBtn.userInteractionEnabled = YES;
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)loadMemberData{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/%@?key=%@",self.member_id,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic666 ==%@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
                   
                   NSDictionary *valuesDic = [dic objectForKey:@"values"];
            if (!kDictIsEmpty(valuesDic)) {
                 //字典转模型
                SVVipSelectModdl *model = [SVVipSelectModdl mj_objectWithKeyValues:valuesDic];
                
                self.header.layer.cornerRadius = 10;
                self.header.layer.masksToBounds = YES;
                
                self.name_leval.text = [NSString stringWithFormat:@"%@.%@",model.sv_mr_name,model.sv_ml_name];
                self.care.text = model.sv_mr_cardno;
                self.storeValues.text = model.sv_mw_availableamount;
                self.availablepoint.text = model.sv_mw_availablepoint;
                self.sumpoint.text = model.sv_mw_sumamount;
                // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
                self.birthday.text = [model.sv_mr_birthday substringWithRange:NSMakeRange(5,5)];//str2 = "is"
                // NSString *oneText = [self.sv_mr_birthday substringToIndex:10];//（length为7）];
                if (!kStringIsEmpty(model.member_id)) {
                    self.sureBtn.backgroundColor = navigationBackgroundColor;
                    self.integralClearingBtn.backgroundColor = navigationBackgroundColor;
                    self.sureBtn.userInteractionEnabled = YES;
                    self.integralClearingBtn.userInteractionEnabled = YES;
                    
                }
                
                if (![SVTool isBlankString:model.sv_mr_headimg]) {
                    [self.header sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_mr_headimg]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
                } else {
                    
                    self.header.image = [UIImage imageNamed:@"foodimg"];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}



@end

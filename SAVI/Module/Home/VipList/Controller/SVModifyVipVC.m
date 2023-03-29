//
//  SVModifyVipVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/7.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVModifyVipVC.h"
#import "SVNewVipOneCell.h"
#import "SVNewVipTwoCell.h"
#import "SVNewVipThreeCell.h"
//pickerView
#import "SVvipPickerView.h"
#import "SVgenderPickerView.h"
#import "SVDatePickerView.h"
#import "SVAddFourCell.h"
#import "SVlicensePlateNumber.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
static NSString *NewViponeCellID = @"NewVipOneCell";
static NSString *NewViptwoCellID = @"NewVipTwoCell";
static NSString *NewVipthreeCellID = @"NewVipThreeCell";
static NSString *SVAddFourCellID = @"SVAddFourCell";
static NSString *SVlicensePlateNumberID = @"SVlicensePlateNumber";

@interface SVModifyVipVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>//tableView,修改头像，pickerView

/**
 tableView
 */
@property (nonatomic,strong) UITableView *tableView;
/**
 全局第一个cell
 */
@property (nonatomic,strong) SVNewVipOneCell *oneCell;
/**
 全局第二个cell
 */
@property (nonatomic,strong) SVNewVipTwoCell *twoCell;
@property (nonatomic,strong) SVNewVipThreeCell *threeCell;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//vippickerView
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
//等级数组
@property (nonatomic,strong) NSMutableArray *pickViewArr;
@property (nonatomic,strong) NSMutableArray *memberlevel_id;

//@property (nonatomic,retain) NSInteger num;

//遮盖view
@property (nonatomic,strong) UIView *maskTwoView;
//性别选择
@property (nonatomic,strong) SVgenderPickerView * genderPickerView;//自定义pickerview
//性别数组
@property (nonatomic,strong) NSArray * letter;//保存要展示的字母

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSMutableArray *textFileArray;
@property (nonatomic,assign) BOOL isIphoneSelect;
@property (nonatomic,strong) SVlicensePlateNumber *licensePlateNumberCell;
@end

@implementation SVModifyVipVC

#pragma mark -  请求会员等级
- (void)loadData {
    //url
    //NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/getUserconfig?key=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/getUserconfig?key=%@",[SVUserManager shareInstance].access_token];
    
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //判断是否请求成功，成功为1
        if ([dict[@"succeed"]integerValue]==1) {
            NSArray *aar = [dict[@"values"] objectForKey:@"getUserLevel"];
            [self.pickViewArr removeAllObjects];
            for (NSDictionary *dic in aar) {
                [self.pickViewArr addObject:dic[@"sv_ml_name"]];
                [self.memberlevel_id addObject:dic[@"memberlevel_id"]];
            }
            //刷新tableView数据
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (NSMutableArray *)textFileArray
{
    if (_textFileArray == nil) {
        _textFileArray = [NSMutableArray array];
    }
    
    return _textFileArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTabelView];
}

-(void)setupTabelView{
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    title.text = @"修改会员";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"修改会员";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) style:UITableViewStyleGrouped];
    //RGBA(241, 241, 241, 1)
    self.tableView.backgroundColor = BackgroundColor;
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN - 20)];
    //适配ios11
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //取消选中
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipOneCell" bundle:nil] forCellReuseIdentifier:NewViponeCellID];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {//汽车美容
        [self.tableView registerNib:[UINib nibWithNibName:@"SVlicensePlateNumber" bundle:nil] forCellReuseIdentifier:SVlicensePlateNumberID];
    }else{
        [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipTwoCell" bundle:nil] forCellReuseIdentifier:NewViptwoCellID];
    }
  //  [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipTwoCell" bundle:nil] forCellReuseIdentifier:NewViptwoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipThreeCell" bundle:nil] forCellReuseIdentifier:NewVipthreeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVAddFourCell" bundle:nil] forCellReuseIdentifier:SVAddFourCellID];
    
    //navigation右边按钮
    //字样
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    //请求会员等级
    [self loadData];
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    
    
    //        if (!kArrayIsEmpty(self.textArray) && [SVUserManager shareInstance].cellIndexPath != nil) {
    // [SVUserManager shareInstance].cellIndexPath
    SVAddFourCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    for (int i = 0; i < self.customArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i *55 +i, ScreenW, 55)];
        // [view removeFromSuperview];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        label.textColor = [UIColor colorWithHexString:@"686868"];
        label.font = [UIFont systemFontOfSize:14];
        NSDictionary *dict = self.customArray[i];
        label.text = [NSString stringWithFormat:@"%@",dict[@"sv_field_name"]];
        label.centerY = 55/2;
        [view addSubview:label];
        UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 10, ScreenW - label.width - 30, 50)];
        textF.placeholder = @"请输入";
        if ((!kStringIsEmpty(dict[@"sv_field_value"]) && ![dict[@"sv_field_value"] isEqualToString:@"<null>"])) {
            textF.text = [NSString stringWithFormat:@"%@",dict[@"sv_field_value"]];
        }
        
        textF.font = [UIFont systemFontOfSize:14];
        textF.textAlignment = NSTextAlignmentRight;
        textF.centerY = 55/2;
        [view addSubview:textF];
        [self.textFileArray addObject:textF];
        //  }
    }
  
    
   
}

#pragma mark - 响应修改会员方法
-(void)rightbuttonResponseEvent{
    
    
    //控制添加会员只能点一次
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    //当前view退出编辑模式
    [self.tableView endEditing:YES];
    
//    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/%@",[SVUserManager shareInstance].access_token];
    
     
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //会员卡号
    if ([SVTool isBlankString:self.cardNumber]) {
        [SVTool TextButtonActionWithSing:@"卡号不能为空"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }else{
        [parameters setObject:self.cardNumber forKey:@"sv_mr_cardno"];
    }
    
    //姓名
    if ([SVTool isBlankString:self.name]) {
        [SVTool TextButtonActionWithSing:@"姓名不能为空"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }else{
        [parameters setObject:self.name forKey:@"sv_mr_name"];
    }
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *MemberDic = sv_versionpowersDict[@"Member"];

   
    
    //零售价
    if (kDictIsEmpty(MemberDic)) {
        //手机
        if ([SVTool isBlankString:self.phone]) {
            [SVTool TextButtonActionWithSing:@"电话不能为空"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }
        [parameters setObject:self.phone forKey:@"sv_mr_mobile"];
      
    }else{
        NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",MemberDic[@"MobilePhoneShow"]];
        if (kStringIsEmpty(MobilePhoneShow)) {
            //手机
            if ([SVTool isBlankString:self.phone]) {
                [SVTool TextButtonActionWithSing:@"电话不能为空"];
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                return;
            }
            [parameters setObject:self.phone forKey:@"sv_mr_mobile"];
          
        }else{
            if ([MobilePhoneShow isEqualToString:@"1"]) {
                //手机
                if ([SVTool isBlankString:self.phone]) {
                    [SVTool TextButtonActionWithSing:@"电话不能为空"];
                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                    return;
                }
                [parameters setObject:self.phone forKey:@"sv_mr_mobile"];
              
        }else{
          //  self.RetailAndWholesalePrices.text = @"***";
//            self.licensePlateNumberCell.phoneNumber.userInteractionEnabled = NO;
            //手机
            if ([SVTool isBlankString:self.telNumber]) {
                [SVTool TextButtonActionWithSing:@"电话不能为空"];
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                return;
            }
            [parameters setObject:self.telNumber forKey:@"sv_mr_mobile"];
        }
        }
    }
    
  
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {//汽车美容
        [parameters setObject:self.licensePlateNumberCell.genderLabel.text forKey:@"sv_mr_nick"];
                //    }
                    
                    //生日
                //    if (![self.twoCell.genderLabel.text isEqualToString:@"日期选择"]) {
                        
        if ([self.licensePlateNumberCell.dateLabel.text containsString:@"日期选择"]) {
             [parameters setObject:@"" forKey:@"sv_mr_birthday"];
        }else{
            [parameters setObject:self.licensePlateNumberCell.dateLabel.text forKey:@"sv_mr_birthday"];
        }
        
        //等级
        if ([self.licensePlateNumberCell.levelLabel.text isEqualToString:@"等级选择"]) {
            [SVTool TextButtonActionWithSing:@"请选择会员等级"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }else{
            [parameters setObject:[NSNumber numberWithInteger:self.number] forKey:@"memberlevel_id"];
        }
    }else{
        [parameters setObject:self.twoCell.genderLabel.text forKey:@"sv_mr_nick"];
                //    }
                    
                    //生日
                //    if (![self.twoCell.genderLabel.text isEqualToString:@"日期选择"]) {
                        
        if ([self.twoCell.dateLabel.text containsString:@"日期选择"]) {
             [parameters setObject:@"" forKey:@"sv_mr_birthday"];
        }else{
            [parameters setObject:self.twoCell.dateLabel.text forKey:@"sv_mr_birthday"];
        }
        
        //等级
        if ([self.twoCell.levelLabel.text isEqualToString:@"等级选择"]) {
            [SVTool TextButtonActionWithSing:@"请选择会员等级"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }else{
            [parameters setObject:[NSNumber numberWithInteger:self.number] forKey:@"memberlevel_id"];
        }
    }

  
                   
            //    }
                
                //地址
            //    if (![SVTool isBlankString:self.address]) {
                    [parameters setObject:self.address forKey:@"sv_mr_address"];
            //    }
                
                //QQ
            //    if (![SVTool isBlankString:self.qq]) {
                    [parameters setObject:self.qq forKey:@"sv_mr_qq"];
            //    }
                
                //微信
            //    if (![SVTool isBlankString:self.weChat]) {
                    [parameters setObject:self.weChat forKey:@"sv_mr_wechat"];
            //    }
                
                //邮箱
            //    if (![SVTool isBlankString:self.email]) {
                    [parameters setObject:self.email forKey:@"sv_mr_email"];
            //    }
                
                //备注
            //    if (![SVTool isBlankString:self.note]) {
                    [parameters setObject:self.note forKey:@"sv_mr_remark"];
            //    }
                
                //头像
                if (![SVTool isBlankString:self.imgURL]) {
                    [parameters setObject:self.imgURL forKey:@"sv_mr_headimg"];
                }
    
    if (![SVTool isBlankString:self.licensePlateNumberCell.sv_mr_platenumberText.text]) {
        [parameters setObject:self.licensePlateNumberCell.sv_mr_platenumberText.text forKey:@"sv_mr_platenumber"];
    }
                
                //会员ID
                [parameters setObject:self.memberID forKey:@"member_id"];
                
                if (!kArrayIsEmpty(self.customArray)) {
                    NSMutableArray *CustomFieldList = [NSMutableArray array];
                    for (int i = 0; i < self.customArray.count; i++) {
                        NSMutableDictionary *dic = self.customArray[i];
                        UITextField *textF = self.textFileArray[i];
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[@"sv_field_id"] = dic[@"sv_field_id"];
                        if (kStringIsEmpty(textF.text)) {
                            dict[@"sv_field_value"] = @"";
                        }else{
                            dict[@"sv_field_value"] = textF.text;
                        }
                        
                        dict[@"sv_relation_id"] = dic[@"sv_relation_id"];
                        
                        [CustomFieldList addObject:dict];
                    }
                    [parameters setObject:CustomFieldList forKey:@"CustomFieldList"];
                }
                
                
                [[SVSaviTool sharedSaviTool] PUT:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //解析
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

                    if ([dic[@"succeed"] integerValue] == 1) {
                        
                        if (self.ModifyVipBlock) {
                            self.ModifyVipBlock();
                        }
                        
                        [SVTool TextButtonActionWithSing:@"修改成功"];
                        //用延迟来移除提示框
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    } else {
                        [SVTool TextButtonActionWithSing:@"修改失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVTool TextButtonActionWithSing:@"网络开小差了"];
                }];
                
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
      //  }
        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [SVTool TextButtonActionWithSing:@"网络开小差了"];
//    }];
    
    
    
}

#pragma mark - UITableView
//几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kArrayIsEmpty(self.customArray)) {
        return 3;
    }else{
        return 4;
    }
    
}

//每组有几个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.customArray)) {
        if (indexPath.section == 0) {
            
            //创建cell
            self.oneCell = [tableView dequeueReusableCellWithIdentifier:NewViponeCellID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!self.oneCell) {
                self.oneCell = [[SVNewVipOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewViponeCellID];
            }
            
            //进来赋值
            self.oneCell.cardNumber.text = self.cardNumber;
            self.oneCell.name.text = self.name;
            
            //指定代理
            self.oneCell.cardNumber.delegate = self;
            self.oneCell.name.delegate = self;
            
            //赋值图片
            if (![SVTool isBlankString:self.imgURL]) {
                UIImageView *img = [[UIImageView alloc]init];
                [img sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imgURL]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                [self.oneCell.iconButton setBackgroundImage:img.image forState:UIControlStateNormal];
            }
            /**
             头像件事
             */
            [self.oneCell.iconButton addTarget:self action:@selector(iconButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
            //设置为圆
            self.oneCell.iconButton.layer.cornerRadius = 27.5;
            self.oneCell.iconButton.layer.masksToBounds = YES;
            
            //扫一扫
            [self.oneCell.scanButton addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
            
            return self.oneCell;
            
        }else if (indexPath.section == 1){
            
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {//汽车美容
               // self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewVipTwoCellSecondID forIndexPath:indexPath];
               // self.twoCell = [SVNewVipTwoCell tempTableViewCellWith:tableView index:1];
                                self.licensePlateNumberCell = [tableView dequeueReusableCellWithIdentifier:SVlicensePlateNumberID forIndexPath:indexPath];
                                if (!self.licensePlateNumberCell) {
                                    self.licensePlateNumberCell = [[SVlicensePlateNumber alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVlicensePlateNumberID];
                                }
                
                //进来赋值
                self.licensePlateNumberCell.levelLabel.text = self.vipLevel;
               // self.licensePlateNumberCell.genderLabel.text = self.gender;
                self.licensePlateNumberCell.phoneNumber.text = self.phone;
                
//                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
//
//                   // self.licensePlateNumberCell.genderLabel.text = self.gender;
//
//                }
                
                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.genderLabel.text = self.gender;
                    
                }
                /**
                 车牌号
                 */
                if (!kStringIsEmpty(self.sv_mr_platenumber) && ![self.sv_mr_platenumber isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.sv_mr_platenumberText.text = self.sv_mr_platenumber;
                    
                }
                
                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.genderLabel.text = self.gender;
                    
                }
                
                
                if (!kStringIsEmpty(self.birthday) && ![self.birthday isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.dateLabel.text = [self.birthday substringToIndex:10];
                }
                
                if (!kStringIsEmpty(self.address) && ![self.address isEqualToString:@"<null>"]) {
                    self.licensePlateNumberCell.address.text = self.address;
                }
                
                
                //指定代理
                self.licensePlateNumberCell.phoneNumber.delegate = self;
                self.licensePlateNumberCell.address.delegate = self;
                
                /**
                 等级选择添加件事
                 */
                self.licensePlateNumberCell.levelLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelResponseEvent)];
                [self.licensePlateNumberCell.levelView addGestureRecognizer:singleTap1];
                

                /**
                 性别选择添加件事
                 */
                //允许用户交互
                //        self.twoCell.genderLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.licensePlateNumberCell.genderView addGestureRecognizer:singleTap2];
                
                /**
                 选择日期添加件事
                 */
                //允许用户交互
                //        self.twoCell.dateLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateLabelResponseEvent)];
                //给dateLabel添加手势
                [self.licensePlateNumberCell.dateView addGestureRecognizer:singleTap3];
                
                
                return self.licensePlateNumberCell;
            }else{
                self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewViptwoCellID forIndexPath:indexPath];
                if (!self.twoCell) {
                    _twoCell = [[SVNewVipTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewViptwoCellID];
                }
                //进来赋值
                self.twoCell.levelLabel.text = self.vipLevel;
                
                self.twoCell.phoneNumber.text = self.phone;
                
                
                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
                    
                    self.twoCell.genderLabel.text = self.gender;
                    
                }
                
                
                if (!kStringIsEmpty(self.birthday) && ![self.birthday isEqualToString:@"<null>"]) {
                    
                    self.twoCell.dateLabel.text = [self.birthday substringToIndex:10];
                }
                
                if (!kStringIsEmpty(self.address) && ![self.address isEqualToString:@"<null>"]) {
                    self.twoCell.address.text = self.address;
                }
                
                
                //指定代理
                self.twoCell.phoneNumber.delegate = self;
                self.twoCell.address.delegate = self;
                
          
                
                /**
                 等级选择添加件事
                 */
                self.twoCell.levelLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelResponseEvent)];
                [self.twoCell.levelView addGestureRecognizer:singleTap1];
                
                /**
                 性别选择添加件事
                 */
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.twoCell.genderView addGestureRecognizer:singleTap2];
                
                /**
                 选择日期添加件事
                 */
                //初始化一个手势
                UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateLabelResponseEvent)];
                //给dateLabel添加手势
                [self.twoCell.dateView addGestureRecognizer:singleTap3];
                
                return self.twoCell;
            }
            
        }else if (indexPath.section ==2){
            self.threeCell = [tableView dequeueReusableCellWithIdentifier:NewVipthreeCellID forIndexPath:indexPath];
            if (!self.threeCell) {
                self.threeCell = [[SVNewVipThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewVipthreeCellID];
            }
            
            //进来赋值
            if (!kStringIsEmpty(self.qq) && ![self.qq isEqualToString:@"<null>"]) {
                self.threeCell.qq.text = self.qq;
            }
            
            if (!kStringIsEmpty(self.weChat) && ![self.weChat isEqualToString:@"<null>"]) {
                self.threeCell.WeChat.text = self.weChat;
            }
            
            if (!kStringIsEmpty(self.email) && ![self.email isEqualToString:@"<null>"]) {
                self.threeCell.email.text = self.email;
            }
            
            if (!kStringIsEmpty(self.note) && ![self.note isEqualToString:@"<null>"]) {
                self.threeCell.note.text = self.note;
            }
            
            
            //指定代理
            self.threeCell.qq.delegate = self;
            self.threeCell.WeChat.delegate = self;
            self.threeCell.email.delegate = self;
            self.threeCell.note.delegate = self;
            return self.threeCell;
        }
        return nil;
    }else{
        if (indexPath.section == 0) {
            
            //创建cell
            self.oneCell = [tableView dequeueReusableCellWithIdentifier:NewViponeCellID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!self.oneCell) {
                self.oneCell = [[SVNewVipOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewViponeCellID];
            }
            
            //进来赋值
            self.oneCell.cardNumber.text = self.cardNumber;
            self.oneCell.name.text = self.name;
            
            //指定代理
            self.oneCell.cardNumber.delegate = self;
            self.oneCell.name.delegate = self;
            
            //赋值图片
            if (![SVTool isBlankString:self.imgURL]) {
                UIImageView *img = [[UIImageView alloc]init];
                [img sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imgURL]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                [self.oneCell.iconButton setBackgroundImage:img.image forState:UIControlStateNormal];
            }
            /**
             头像件事
             */
            [self.oneCell.iconButton addTarget:self action:@selector(iconButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
            //设置为圆
            self.oneCell.iconButton.layer.cornerRadius = 27.5;
            self.oneCell.iconButton.layer.masksToBounds = YES;
            
            //扫一扫
            [self.oneCell.scanButton addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
            
            return self.oneCell;
            
        }else if (indexPath.section == 1){
            
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {//汽车美容
               // self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewVipTwoCellSecondID forIndexPath:indexPath];
               // self.twoCell = [SVNewVipTwoCell tempTableViewCellWith:tableView index:1];
                                self.licensePlateNumberCell = [tableView dequeueReusableCellWithIdentifier:SVlicensePlateNumberID forIndexPath:indexPath];
                                if (!self.licensePlateNumberCell) {
                                    self.licensePlateNumberCell = [[SVlicensePlateNumber alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVlicensePlateNumberID];
                                }
                
                //进来赋值
                self.licensePlateNumberCell.levelLabel.text = self.vipLevel;
                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.genderLabel.text = self.gender;
                    
                }
                
                self.licensePlateNumberCell.phoneNumber.text = self.phone;
                
                /**
                 车牌号
                 */
                if (!kStringIsEmpty(self.sv_mr_platenumber) && ![self.sv_mr_platenumber isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.sv_mr_platenumberText.text = self.sv_mr_platenumber;
                    
                }
                
                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.genderLabel.text = self.gender;
                    
                }
                
                
                if (!kStringIsEmpty(self.birthday) && ![self.birthday isEqualToString:@"<null>"]) {
                    
                    self.licensePlateNumberCell.dateLabel.text = [self.birthday substringToIndex:10];
                }
                
                if (!kStringIsEmpty(self.address) && ![self.address isEqualToString:@"<null>"]) {
                    self.licensePlateNumberCell.address.text = self.address;
                }
                
                //指定代理
                self.licensePlateNumberCell.phoneNumber.delegate = self;
                self.licensePlateNumberCell.address.delegate = self;
                
                /**
                 等级选择添加件事
                 */
                self.licensePlateNumberCell.levelLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelResponseEvent)];
                [self.licensePlateNumberCell.levelView addGestureRecognizer:singleTap1];
                

                /**
                 性别选择添加件事
                 */
                //允许用户交互
                //        self.twoCell.genderLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.licensePlateNumberCell.genderView addGestureRecognizer:singleTap2];
                
                /**
                 选择日期添加件事
                 */
                //允许用户交互
                //        self.twoCell.dateLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateLabelResponseEvent)];
                //给dateLabel添加手势
                [self.licensePlateNumberCell.dateView addGestureRecognizer:singleTap3];
                
                return self.licensePlateNumberCell;
            }else{
                self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewViptwoCellID forIndexPath:indexPath];
                if (!self.twoCell) {
                    _twoCell = [[SVNewVipTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewViptwoCellID];
                }
                //进来赋值
                self.twoCell.levelLabel.text = self.vipLevel;
                
                self.twoCell.phoneNumber.text = self.phone;
                
                
                if (!kStringIsEmpty(self.gender) && ![self.gender isEqualToString:@"<null>"]) {
                    
                    self.twoCell.genderLabel.text = self.gender;
                    
                }
                
                
                if (!kStringIsEmpty(self.birthday) && ![self.birthday isEqualToString:@"<null>"]) {
                    
                    self.twoCell.dateLabel.text = [self.birthday substringToIndex:10];
                }
                
                if (!kStringIsEmpty(self.address) && ![self.address isEqualToString:@"<null>"]) {
                    self.twoCell.address.text = self.address;
                }
                
                
                //指定代理
                self.twoCell.phoneNumber.delegate = self;
                self.twoCell.address.delegate = self;
                
                /**
                 等级选择添加件事
                 */
                self.twoCell.levelLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelResponseEvent)];
                [self.twoCell.levelView addGestureRecognizer:singleTap1];
                
                /**
                 性别选择添加件事
                 */
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.twoCell.genderView addGestureRecognizer:singleTap2];
                
                /**
                 选择日期添加件事
                 */
                //初始化一个手势
                UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateLabelResponseEvent)];
                //给dateLabel添加手势
                [self.twoCell.dateView addGestureRecognizer:singleTap3];
                
                return self.twoCell;
            }
          
        }else if (indexPath.section ==2){
            SVAddFourCell *cell = [tableView dequeueReusableCellWithIdentifier:SVAddFourCellID];
            if (!cell) {
                cell = [[SVAddFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVAddFourCellID];
            }
            
            self.indexPath = indexPath;
            
            return cell;
        }else if (indexPath.section ==3){
            self.threeCell = [tableView dequeueReusableCellWithIdentifier:NewVipthreeCellID forIndexPath:indexPath];
            if (!self.threeCell) {
                self.threeCell = [[SVNewVipThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewVipthreeCellID];
            }
            
            //进来赋值
            if (!kStringIsEmpty(self.qq) && ![self.qq isEqualToString:@"<null>"]) {
                self.threeCell.qq.text = self.qq;
            }
            
            if (!kStringIsEmpty(self.weChat) && ![self.weChat isEqualToString:@"<null>"]) {
                self.threeCell.WeChat.text = self.weChat;
            }
            
            if (!kStringIsEmpty(self.email) && ![self.email isEqualToString:@"<null>"]) {
                self.threeCell.email.text = self.email;
            }
            
            if (!kStringIsEmpty(self.note) && ![self.note isEqualToString:@"<null>"]) {
                self.threeCell.note.text = self.note;
            }
            
            
            //指定代理
            self.threeCell.qq.delegate = self;
            self.threeCell.WeChat.delegate = self;
            self.threeCell.email.delegate = self;
            self.threeCell.note.delegate = self;
            return self.threeCell;
        }
        return nil;
    }
   
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.customArray)) {
        if (indexPath.section == 0) {
            return 111;
        }else if (indexPath.section == 1) {
           // return 280;
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                return 280 + 55.5;
            }else{
                return 280;
           }
        }else if (indexPath.section == 2){
            return 224;
        }
        return 0;
    }else{
        if (indexPath.section == 0) {
            return 111;
        }else if (indexPath.section == 1) {
           // return 280;
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                return 280 + 55.5;
            }else{
                return 280;
           }
        }else if (indexPath.section == 2){
            return self.customArray.count *55 + self.customArray.count-1;
        }else if (indexPath.section == 3){
            return 224;
        }
        return 0;
        
    }
  
}

//设置组与组的距离
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - 按钮响应事件
-(void)levelLabelResponseEvent{
    //指定代理
    self.vipPickerView.vipPicker.delegate = self;
    self.vipPickerView.vipPicker.dataSource = self;
    //添加pickerView
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
    
    //退出键盘用
    [self.tableView endEditing:YES];
}

//-(void)genderLabelResponseEvent{
//    //指定代理
//    self.genderPickerView.genderPicker.delegate = self;
//    self.genderPickerView.genderPicker.dataSource = self;
//    //添加pickerView
//    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.genderPickerView];
//
//    //退出键盘
//    [self.tableView endEditing:YES];
//}


-(void)genderLabelResponseEvent{
    
    //退出编辑
    [self.tableView endEditing:YES];
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/getUserconfig?key=%@",[SVUserManager shareInstance].access_token];
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //判断是否请求成功，成功为1
        if ([dict[@"succeed"] integerValue] == 1) {
            self.letter = [dict[@"values"] objectForKey:@"sv_uc_callnameList"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //指定代理
            self.genderPickerView.genderPicker.delegate = self;
            self.genderPickerView.genderPicker.dataSource = self;
            //添加pickerView
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.genderPickerView];
            
        } else {
            [SVTool TextButtonAction:self.view withSing:@"等级数据请求失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    //    //指定代理
    //    self.genderPickerView.genderPicker.delegate = self;
    //    self.genderPickerView.genderPicker.dataSource = self;
    //    //添加pickerView
    ////    [self.view addSubview:self.maskTwoView];
    ////    [self.view addSubview:self.genderPickerView];
    //
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.genderPickerView];
    //
    //    //退出编辑
    //    [self.tableView endEditing:YES];
    
}

/**
 日期选择
 */
-(void)dateLabelResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
    
    //退出键盘
    [self.tableView endEditing:YES];
    
}

#pragma mark  - UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.vipPickerView.vipPicker) {
        return self.pickViewArr.count;
    }else{
        return self.letter.count;
    }
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.vipPickerView.vipPicker) {
        return self.pickViewArr[row];
    }else{
        return self.letter[row];
    }
}

#pragma mark - UITextFieldDelegate
//编辑完成时调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            self.cardNumber = textField.text;
            break;
        case 1:
            self.name = textField.text;
            break;
        case 2:
            self.phone = textField.text;
            self.telNumber = textField.text;
            break;
        case 3:
            self.address = textField.text;
            break;
        case 4:
            self.qq = textField.text;
            break;
        case 5:
            self.weChat = textField.text;
            break;
        case 6:
            self.email = textField.text;
            break;
        case 7:
            self.note = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark - textField
//限制字数输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    if ([textField isEqual:self.oneCell.cardNumber] || [textField isEqual:self.threeCell.qq] || [textField isEqual:self.threeCell.WeChat]) {
        //超过20位 就不能在输入了
        if (pointLength > 20) {
            return NO;
        }else{
            return YES;
        }
    }
    if ([textField isEqual:self.oneCell.name] || [textField isEqual:self.twoCell.phoneNumber]) {
        //超过20位 就不能在输入了
        if (pointLength > 11) {
            return NO;
        }else{
            return YES;
        }
    }
    if ([textField isEqual:self.threeCell.note]) {
        //超过20位 就不能在输入了
        if (pointLength > 50) {
            return NO;
        }else{
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - 跳转到扫一扫
-(void)scanButtonResponseEvent{
    
//    self.hidesBottomBarWhenPushed = YES;
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        weakSelf.oneCell.cardNumber.text = name;
//
//        weakSelf.cardNumber = name;
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
        
        weakSelf.oneCell.cardNumber.text = resultStr;
        
        weakSelf.cardNumber = resultStr;
        };
    

    
    //设置点击时的背影色
    [self.oneCell.scanButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.oneCell.scanButton setBackgroundColor:[UIColor clearColor]];
        
        //跳转方法
        //QRCode QRCodeClickBy:self];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}

#pragma mark - 修改头像
-(void)iconButtonResponseEvent{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.oneCell.iconButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    //给服务器上传图片
//    UIImage *newImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(200.0f, 200.0f)];
    
    [self performSelector:@selector(saveImage:)  withObject:newPhoto afterDelay:0.5];
}

#pragma mark - 上传图片的方法
- (void)saveImage:(UIImage *)image {
    
    [SVUserManager loadUserInfo];
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在压缩图片"];
    NSString *loadImage_path = @"/system/UploadImg";
    
    NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
    
  //  NSData *newIMGData = [self resetSizeOfImageData:image maxSize:30];
   // NSData *newIMGData = [image bb_compressWithMaxLength:50 sizeMultiple:0];
    NSData *newIMGData = [image bb_compressWithMaxLength:50 size:CGSizeMake(750, 1334)];
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //                NSData *data = [NSUtil dataWithOriginalImage:newImage];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:newIMGData
         
                                    name:@"icon"
         
                                fileName:@"icon.jpg"
         
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //                    [SVTool ];
            if ([self changeImagePath:dic[@"values"]].length <= 0) {
                [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
            }else{
                self.imgURL = [self changeImagePath:dic[@"values"]];
                NSLog(@"self.imgURL = %@",self.imgURL);
            }
            
        } else {
            
            [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}
//截掉图片拼接路径
-(NSString*)changeImagePath:(NSString*)path{
    return  [path stringByReplacingOccurrencesOfString:URLHeadPortrait withString:@""];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}



//#pragma mark - 判断手机号码格式是否正确
//- (BOOL)valiMobile:(NSString *)mobile
//{
//    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (mobile.length != 11)
//    {
//        return NO;
//    }else{
//        /**
//         * 移动号段正则表达式
//         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
//        
//        if (isMatch1 || isMatch2 || isMatch3) {
//            
//            return YES;
//            
//        }else{
//            
//            return NO;
//        }
//    }
//}

#pragma mark - 懒加载
//-(UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW,ScreenH)];
//        //适配ios11
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//    }
//    return _tableView;
//}

//等级pickerView
-(SVvipPickerView *)vipPickerView{
    if (!_vipPickerView) {
        _vipPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _vipPickerView.frame = CGRectMake(0, 0, 320, 230);
        _vipPickerView.center = self.view.center;
        _vipPickerView.backgroundColor = [UIColor whiteColor];
        _vipPickerView.layer.cornerRadius = 10;
        
        [_vipPickerView.vipCancel addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_vipPickerView.vipDetermine addTarget:self action:@selector(vipDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipPickerView;
}

//等级数组
- (NSMutableArray *)pickViewArr {
    
    if (!_pickViewArr) {
        
        _pickViewArr = [NSMutableArray array];
    }
    return _pickViewArr;
    
}

-(NSMutableArray *)memberlevel_id{
    if (!_memberlevel_id) {
        _memberlevel_id = [NSMutableArray array];
    }
    return _memberlevel_id;
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

//点击手势的点击事件
//- (void)maskOneClickGesture{
//    [self.maskOneView removeFromSuperview];
//    [self.vipPickerView removeFromSuperview];
//}
//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.vipPickerView removeFromSuperview];
}
//确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    
    NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    
    self.number =[self.memberlevel_id[row] integerValue];
    
   // self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:row];
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
        self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:row];
    }else{
        self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:row];
    }
    
    [self.vipPickerView removeFromSuperview];
}

/**
 性别选择
 */
-(SVgenderPickerView *)genderPickerView{
    if (!_genderPickerView) {
        _genderPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVgenderPickerView" owner:nil options:nil].lastObject;
        _genderPickerView.frame = CGRectMake(0, 0, 320, 230);
        _genderPickerView.center = self.view.center;
        _genderPickerView.backgroundColor = [UIColor whiteColor];
        _genderPickerView.layer.cornerRadius = 10;
        
        [_genderPickerView.genderCancel addTarget:self action:@selector(genderCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_genderPickerView.genderDetermine addTarget:self action:@selector(genderDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _genderPickerView;
}

//-(NSArray *)letter{
//    if (!_letter) {
//        _letter = @[@"男",@"女"];
//    }
//    return _letter;
//}

-(NSArray *)letter{
    if (!_letter) {
        _letter = [NSArray array];
    }
    return _letter;
}

/**
 性别遮盖View
 */
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderCancelResponseEvent)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}

//点击手势的点击事件
- (void)genderDetermineResponseEvent{
    [self.maskTwoView removeFromSuperview];
    NSInteger row = [self.genderPickerView.genderPicker selectedRowInComponent:0];
   // self.twoCell.genderLabel.text = [self.letter objectAtIndex:row];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
       // self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:row];
        self.licensePlateNumberCell.genderLabel.text = [self.letter objectAtIndex:row];
    }else{
        self.twoCell.genderLabel.text = [self.letter objectAtIndex:row];
    }
    [self.genderPickerView removeFromSuperview];
}

- (void)genderCancelResponseEvent{
    [self.maskTwoView removeFromSuperview];
    [self.genderPickerView removeFromSuperview];
}

/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _myDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _myDatePicker.center = self.view.center;
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        _myDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        
        [_myDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myDatePicker;
}

/**
 日期遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

//点击手势的点击事件
- (void)dateDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   // self.twoCell.dateLabel.text = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
        //self..levelLabel.text = [self.pickViewArr objectAtIndex:row];
        self.licensePlateNumberCell.dateLabel.text = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];

    }else{
        self.twoCell.dateLabel.text = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];

    }
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
}




@end

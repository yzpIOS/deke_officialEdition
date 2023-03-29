//
//  SVNewVipVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVNewVipVC.h"
#import "SVNewVipOneCell.h"
#import "SVNewVipTwoCell.h"
#import "SVNewVipThreeCell.h"
//pickerView
#import "SVvipPickerView.h"
#import "SVgenderPickerView.h"
#import "SVDatePickerView.h"
#import "SVLastCustomCell.h"
#import "SVAddCustomView.h"
#import "SVAddFourCell.h"
#import "SVSetUserdItemsView.h"
#import "SVlicensePlateNumber.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
static NSString *NewViponeCellID = @"NewVipOneCell";
static NSString *NewVipTwoCellID = @"NewVipTwoCell";
static NSString *SVlicensePlateNumberID = @"SVlicensePlateNumber";
static NSString *NewVipthreeCellID = @"NewVipThreeCell";
static NSString *SVLastCustomCellID = @"SVLastCustomCell";
static NSString *SVAddFourCellID = @"SVAddFourCell";

@interface SVNewVipVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>//tableView,修改头像，pickerView

/**
 tableView
 */
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SVNewVipOneCell *oneCell;
@property (nonatomic,strong) SVNewVipTwoCell *twoCell;
@property (nonatomic,strong) SVNewVipThreeCell *threeCell;
@property (nonatomic,strong) SVlicensePlateNumber *licensePlateNumberCell;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//vippickerView
@property (nonatomic,strong) SVvipPickerView *vipPickerView;
//等级数组
@property (nonatomic,strong) NSMutableArray *pickViewArr;
@property (nonatomic,strong) NSMutableArray *memberlevel_id;
@property (nonatomic,assign) NSUInteger number;
//@property (nonatomic,retain) NSInteger num;

//遮盖view
@property (nonatomic,strong) UIView *maskTwoView;
//性别选择
@property (nonatomic,strong) SVgenderPickerView *genderPickerView;//自定义pickerview
//性别数组
@property (nonatomic,strong) NSArray * letter;//保存要展示的字母

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;

//全局属性接收
//图片路径
@property (nonatomic,copy) NSString *imgURL;
@property (nonatomic,copy) NSString *cardNumber;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *qq;
@property (nonatomic,copy) NSString *weChat;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,strong) SVAddCustomView *addCustomView;
@property (nonatomic,strong) SVSetUserdItemsView *setUserdItemView;

@property (nonatomic,strong) NSMutableArray *textArray;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSMutableArray *textFileArray;





@end



@implementation SVNewVipVC

- (NSMutableArray *)textFileArray
{
    if (_textFileArray == nil) {
        _textFileArray = [NSMutableArray array];
    }
    
    return _textFileArray;
}

- (void)setUserdItemSureBtnClick{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabelView];
    
//    [SVTool IndeterminateButtonAction:self.view withSing:nil];
//    [self loadData];
}

//#pragma mark - 设置状态栏颜色
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//
//{
//
//    [super viewWillDisappear:animated];
//
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//
//}

-(void)setupTabelView{
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    title.text = @"新增会员";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新增会员";
   
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) style:UITableViewStyleGrouped];
    //RGBA(241, 241, 241, 1)
    self.tableView.backgroundColor = RGBA(247, 247, 247, 1);
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN - 20)];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //取消选中
    self.tableView.allowsSelection = NO;
    //适配ios11
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipOneCell" bundle:nil] forCellReuseIdentifier:NewViponeCellID];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {//汽车美容
        [self.tableView registerNib:[UINib nibWithNibName:@"SVlicensePlateNumber" bundle:nil] forCellReuseIdentifier:SVlicensePlateNumberID];
    }else{
        [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipTwoCell" bundle:nil] forCellReuseIdentifier:NewVipTwoCellID];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewVipThreeCell" bundle:nil] forCellReuseIdentifier:NewVipthreeCellID];
     [self.tableView registerNib:[UINib nibWithNibName:@"SVLastCustomCell" bundle:nil] forCellReuseIdentifier:SVLastCustomCellID];
     [self.tableView registerNib:[UINib nibWithNibName:@"SVAddFourCell" bundle:nil] forCellReuseIdentifier:SVAddFourCellID];
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self loadmemberNumber];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   // #pragma mark - 加载常用项数据
    [self loadGetMemberCustomList];
    
    [self loadlevelLabelResponseData];
    [self genderLabelResponseData];
   // [self AddMemberCustomField];
}


- (void)loadGetMemberCustomList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/GetMemberCustomInfo?key=%@",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict = %@",dict);
        NSMutableArray *array = dict[@"values"];
//        [self.textArray addObjectsFromArray:array];
//        
//        [self.tableView reloadData];
//        [self.tableView layoutIfNeeded];
//        
//        
////        if (!kArrayIsEmpty(self.textArray) && [SVUserManager shareInstance].cellIndexPath != nil) {
//           // [SVUserManager shareInstance].cellIndexPath
//            SVAddFourCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
//            for (int i = 0; i < self.textArray.count; i++) {
//                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i *55 +i, ScreenW, 55)];
//                // [view removeFromSuperview];
//                view.backgroundColor = [UIColor whiteColor];
//                [cell addSubview:view];
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
//                label.textColor = [UIColor colorWithHexString:@"686868"];
//                label.font = [UIFont systemFontOfSize:14];
//                NSDictionary *dict = self.textArray[i];
//                label.text = [NSString stringWithFormat:@"%@",dict[@"sv_field_name"]];
//                label.centerY = 55/2;
//                [view addSubview:label];
//                UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 10, ScreenW - label.width - 30, 50)];
//                textF.placeholder = @"请输入";
//                textF.font = [UIFont systemFontOfSize:14];
//                textF.textAlignment = NSTextAlignmentRight;
//                textF.centerY = 55/2;
//                [view addSubview:textF];
//                [self.textFileArray addObject:textF];
//          //  }
//        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];// 1
    [self.addCustomView.textView becomeFirstResponder];// 2
   
}
- (void)dealloc{
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
}

- (void)loadmemberNumber{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/GetAutomaticallyGenerateMemberCode?key=%@&plusone=true",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic999 = %@",dic);
        if ([dic[@"succeed"] integerValue] == 1) {
             self.oneCell.cardNumber.text = dic[@"values"];
             self.cardNumber = dic[@"values"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 响应添加会员方法
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
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {//汽车美容
        //等级
        if ([self.licensePlateNumberCell.levelLabel.text isEqualToString:@"等级选择"]) {
            [SVTool TextButtonActionWithSing:@"请选择会员等级"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }else{
            [parameters setObject:[NSNumber numberWithInteger:self.number] forKey:@"memberlevel_id"];
        }
        
        //称谓
        if ([self.licensePlateNumberCell.genderLabel.text isEqualToString:@"称谓选择"]) {
            [SVTool TextButtonActionWithSing:@"请选择称谓"];
             [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }
        
        if (![self.licensePlateNumberCell.genderLabel.text isEqualToString:@"性别选择"] && ![SVTool isBlankString:self.licensePlateNumberCell.genderLabel.text]) {
            [parameters setObject:self.licensePlateNumberCell.genderLabel.text forKey:@"sv_mr_nick"];
        }
       
    }else{
        if ([self.twoCell.levelLabel.text isEqualToString:@"等级选择"]) {
            [SVTool TextButtonActionWithSing:@"请选择会员等级"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }else{
            [parameters setObject:[NSNumber numberWithInteger:self.number] forKey:@"memberlevel_id"];
        }
        
        //称谓
        if ([self.twoCell.genderLabel.text isEqualToString:@"称谓选择"]) {
            [SVTool TextButtonActionWithSing:@"请选择称谓"];
             [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }
        
        if (![self.twoCell.genderLabel.text isEqualToString:@"性别选择"] && ![SVTool isBlankString:self.twoCell.genderLabel.text]) {
            [parameters setObject:self.twoCell.genderLabel.text forKey:@"sv_mr_nick"];
        }
    }
   
    
    //手机
    if ([SVTool isBlankString:self.phone]) {
        [SVTool TextButtonActionWithSing:@"电话不能为空"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }else{
       // if ([SVTool valiMobile:self.phone]) {
            [parameters setObject:self.phone forKey:@"sv_mr_mobile"];
//        } else{
//            [SVTool TextButtonActionWithSing:@"请输入正确的电话"];
//            [self.navigationItem.rightBarButtonItem setEnabled:YES];
//            return;
//        }
    }
    
   
    
    //生日
    if (![self.twoCell.dateLabel.text isEqualToString:@"日期选择"] && ![SVTool isBlankString:self.twoCell.dateLabel.text]) {
        [parameters setObject:self.twoCell.dateLabel.text forKey:@"sv_mr_birthday"];
    }
    
    //地址
    if (![SVTool isBlankString:self.address]) {
        [parameters setObject:self.address forKey:@"sv_mr_address"];
    }
    
    //QQ
    if (![SVTool isBlankString:self.qq]) {
        [parameters setObject:self.qq forKey:@"sv_mr_qq"];
    }
    
    //微信
    if (![SVTool isBlankString:self.weChat]) {
        [parameters setObject:self.weChat forKey:@"sv_mr_wechat"];
    }
    // 车牌号 sv_mr_platenumber
    if (![SVTool isBlankString:self.licensePlateNumberCell.sv_mr_platenumberText.text]) {
        [parameters setObject:self.licensePlateNumberCell.sv_mr_platenumberText.text forKey:@"sv_mr_platenumber"];
    }
    
    //邮箱
    if (![SVTool isBlankString:self.email]) {
        
        if ([SVTool isValidateEmail:self.email] == NO) {
            
            [SVTool TextButtonActionWithSing:@"邮箱格式错误"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
            
        } else {
            [parameters setObject:self.email forKey:@"sv_mr_email"];//这句有一报错10月20号
        }
        
    }
    
    //备注
    if (![SVTool isBlankString:self.note]) {
        [parameters setObject:self.note forKey:@"sv_mr_remark"];
    }
    
    //头像
    if (self.imgURL) {
        [parameters setObject:self.imgURL forKey:@"sv_mr_headimg"];
    }
    
    if (!kArrayIsEmpty(self.textArray)) {
        NSMutableArray *CustomFieldList = [NSMutableArray array];
            for (int i = 0; i < self.textArray.count; i++) {
                NSMutableDictionary *dic = self.textArray[i];
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
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            [SVTool TextButtonActionWithSing:@"添加会员成功"];
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //触发回调的block
                if (self.addVipBlock) {
                    self.addVipBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSString *errmsg = dic[@"values"];
            [SVTool TextButtonActionWithSing:errmsg];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //控制添加会员只能点一次
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        [SVTool requestFailed];
        [SVTool TextButtonActionWithSing:@"网络开小差了"];
    }];
    
    //控制添加会员只能点一次
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
}


#pragma mark - UITableView
//几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kArrayIsEmpty(self.textArray)) {
         return 4;
    }else{
        return 5;
    }
   
}

//每组有几个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.textArray)) {
        if (indexPath.section == 0) {
            
            //创建cell
            self.oneCell = [tableView dequeueReusableCellWithIdentifier:NewViponeCellID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!self.oneCell) {
                self.oneCell = [[SVNewVipOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewViponeCellID];
            }
            
            //指定代理
            self.oneCell.cardNumber.delegate = self;
            self.oneCell.name.delegate = self;
            
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
                
                //指定代理
                self.licensePlateNumberCell.phoneNumber.delegate = self;
                self.licensePlateNumberCell.address.delegate = self;
                
                /**
                 等级选择添加件事
                 */
                self.licensePlateNumberCell.levelLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelResponseEvent)];
                [self.licensePlateNumberCell.levelView addGestureRecognizer:singleTap1];
                
                if ([self.licensePlateNumberCell.levelLabel.text isEqualToString:@"等级选择"]) {
                    if(self.memberlevel_id.count != 0){
                        self.number =[self.memberlevel_id[0] integerValue];
                        [SVUserManager loadUserInfo];
                        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                            if (self.pickViewArr.count != 0) {
                                self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                            }
                            
                        }else{
                            if (self.pickViewArr.count != 0) {
                                self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                            }
                            
                        }
                    }
                   
                }
                
                
             
                

                /**
                 性别选择添加件事
                 */
                //允许用户交互
                //        self.twoCell.genderLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.licensePlateNumberCell.genderView addGestureRecognizer:singleTap2];
                
//                [SVUserManager loadUserInfo];
//                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
//                   // self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:row];
//                    self.licensePlateNumberCell.genderLabel.text = [self.letter objectAtIndex:0];
//                }else{
//                    self.twoCell.genderLabel.text = [self.letter objectAtIndex:0];
//                }
                
                if ([self.licensePlateNumberCell.genderLabel.text isEqualToString:@"称谓选择"] && self.letter.count > 0) {
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                        self.licensePlateNumberCell.genderLabel.text = [self.letter objectAtIndex:0];
                    }else{
                        self.twoCell.genderLabel.text = [self.letter objectAtIndex:0];
                    }
                }
                
                
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
               // self.twoCell = [SVNewVipTwoCell tempTableViewCellWith:tableView index:0];
                self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewVipTwoCellID forIndexPath:indexPath];
                if (!self.twoCell) {
                    _twoCell = [[SVNewVipTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewVipTwoCellID];
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
                
                if ([self.twoCell.levelLabel.text isEqualToString:@"等级选择"] && self.memberlevel_id.count > 0 && self.pickViewArr.count > 0) {
                    self.number =[self.memberlevel_id[0] integerValue];
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                        self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                    }else{
                        self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                    }
                }
                
                
                if ([self.twoCell.genderLabel.text isEqualToString:@"称谓选择"] && self.letter.count > 0) {
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                        self.licensePlateNumberCell.genderLabel.text = [self.letter objectAtIndex:0];
                    }else{
                        self.twoCell.genderLabel.text = [self.letter objectAtIndex:0];
                    }
                }
                
    //            [SVUserManager loadUserInfo];
    //            if (![[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
    //               // self.twoCell.dateView.birthdayTopHeight = 0;
    //                self.twoCell.LicensePlateHeight = 0;
    //                self.twoCell.chengweiHeight = 0;
    //               // self.twoCell.LicensePlateBottomHeight = 0;
    //                self.twoCell.LicensePlateView.hidden = YES;
    //              //  self.twoCell.LicensePlateBottomView.hidden = YES;
    //            }
                
                /**
                 性别选择添加件事
                 */
                //允许用户交互
                //        self.twoCell.genderLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.twoCell.genderView addGestureRecognizer:singleTap2];
                
                /**
                 选择日期添加件事
                 */
                //允许用户交互
                //        self.twoCell.dateLabel.userInteractionEnabled = YES;
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
            //指定代理
            self.threeCell.qq.delegate = self;
            self.threeCell.WeChat.delegate = self;
            self.threeCell.email.delegate = self;
            self.threeCell.note.delegate = self;
            return self.threeCell;
        }else if (indexPath.section == 3){
            SVLastCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:SVLastCustomCellID];
            if (!cell) {
                cell = [[SVLastCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVLastCustomCellID];
            }
            UITapGestureRecognizer *customTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTagClick)];
            
            [cell.customView addGestureRecognizer:customTag];
            
            UITapGestureRecognizer *frequentlyTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frequentlyTagClick)];
            [cell.frequentlyView addGestureRecognizer:frequentlyTag];
            
            
            return cell;
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
            
            //指定代理
            self.oneCell.cardNumber.delegate = self;
            self.oneCell.name.delegate = self;
            
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
                
                //指定代理
                self.licensePlateNumberCell.phoneNumber.delegate = self;
                self.licensePlateNumberCell.address.delegate = self;
                
                /**
                 等级选择添加件事
                 */
                self.licensePlateNumberCell.levelLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelLabelResponseEvent)];
                [self.licensePlateNumberCell.levelView addGestureRecognizer:singleTap1];
                
                if ([self.licensePlateNumberCell.levelLabel.text isEqualToString:@"等级选择"]) {
                    self.number =[self.memberlevel_id[0] integerValue];
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                        self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                    }else{
                        self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                    }
                }
                
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
               // self.twoCell = [SVNewVipTwoCell tempTableViewCellWith:tableView index:0];
                self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewVipTwoCellID forIndexPath:indexPath];
                if (!self.twoCell) {
                    _twoCell = [[SVNewVipTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewVipTwoCellID];
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
                
    //            [SVUserManager loadUserInfo];
    //            if (![[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
    //               // self.twoCell.dateView.birthdayTopHeight = 0;
    //                self.twoCell.LicensePlateHeight = 0;
    //                self.twoCell.chengweiHeight = 0;
    //               // self.twoCell.LicensePlateBottomHeight = 0;
    //                self.twoCell.LicensePlateView.hidden = YES;
    //              //  self.twoCell.LicensePlateBottomView.hidden = YES;
    //            }
                
                /**
                 性别选择添加件事
                 */
                //允许用户交互
                //        self.twoCell.genderLabel.userInteractionEnabled = YES;
                //初始化一个手势
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderLabelResponseEvent)];
                //给dateLabel添加手势
                [self.twoCell.genderView addGestureRecognizer:singleTap2];
                
                /**
                 选择日期添加件事
                 */
                //允许用户交互
                //        self.twoCell.dateLabel.userInteractionEnabled = YES;
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
            
            

        }else if (indexPath.section == 3){
            self.threeCell = [tableView dequeueReusableCellWithIdentifier:NewVipthreeCellID forIndexPath:indexPath];
            if (!self.threeCell) {
                self.threeCell = [[SVNewVipThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewVipthreeCellID];
            }
            //指定代理
            self.threeCell.qq.delegate = self;
            self.threeCell.WeChat.delegate = self;
            self.threeCell.email.delegate = self;
            self.threeCell.note.delegate = self;
            return self.threeCell;
            
            
        }else if (indexPath.section == 4){
            SVLastCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:SVLastCustomCellID];
            if (!cell) {
                cell = [[SVLastCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVLastCustomCellID];
            }
            UITapGestureRecognizer *customTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTagClick)];
            
            [cell.customView addGestureRecognizer:customTag];
            
            UITapGestureRecognizer *frequentlyTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frequentlyTagClick)];
            [cell.frequentlyView addGestureRecognizer:frequentlyTag];
            
            
            return cell;
        }
        return nil;
    }
    
}

- (void)customTagClick{
    [self.addCustomView.textView becomeFirstResponder];// 2
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
}

- (void)frequentlyTagClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
   // self.setUserdItemView.dataArray = self.textArray;
   self.setUserdItemView = [[SVSetUserdItemsView alloc] init];
    [self.setUserdItemView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.setUserdItemView.dataArray = self.textArray;
    __weak typeof(self) weakSelf = self;
    self.setUserdItemView.sureBlock = ^{
        [weakSelf cancleBtnClick];
       // [weakSelf sureBtnClick];
    };
    self.setUserdItemView.removeDataArrayBlock = ^{
        
        NSLog(@"self.textArray = %@",weakSelf.textArray);
        [weakSelf.tableView reloadData];
        [weakSelf.tableView layoutIfNeeded];
        
        if (!kArrayIsEmpty(weakSelf.textArray)) {
            SVAddFourCell *cell = [weakSelf.tableView cellForRowAtIndexPath:weakSelf.indexPath];
            
            for (UIView *view3 in cell.subviews) {
                [view3 removeFromSuperview];
            }
        
            
            for (int i = 0; i < weakSelf.textArray.count; i++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i *55 +i -1, ScreenW, 55)];
                // [view removeFromSuperview];
                view.backgroundColor = [UIColor whiteColor];
                [cell addSubview:view];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
                label.textColor = [UIColor colorWithHexString:@"686868"];
                label.font = [UIFont systemFontOfSize:14];
                NSDictionary *dict = weakSelf.textArray[i];
                label.text = [NSString stringWithFormat:@"%@",dict[@"sv_field_name"]];
                label.centerY = 55/2;
                [view addSubview:label];
                UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 10, ScreenW - label.width - 30, 50)];
                textF.placeholder = @"请输入";
                textF.font = [UIFont systemFontOfSize:14];
                textF.textAlignment = NSTextAlignmentRight;
                textF.centerY = 55/2;
                [view addSubview:textF];
            }
            
        }
       // }
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.setUserdItemView];
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.textArray)) {
        if (indexPath.section == 0) {
            return 111;
        }else if (indexPath.section == 1) {
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                return 280 + 55.5;
            }else{
                return 280;
           }
           
        }else if (indexPath.section == 2){
            return 224;
        }else if (indexPath.section == 3){
            return 111;
        }
        return 0;
    }else{
        if (indexPath.section == 0) {
            return 111;
        }else if (indexPath.section == 1) {
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                return 280 + 55.5;
            }else{
                return 280;
            }
//            return 280;
        }else if (indexPath.section == 2){
            return self.textArray.count *55 + self.textArray.count-1;
            
        }else if (indexPath.section == 3){
            return 224;
        }else if (indexPath.section == 4){
            return 111;
        }
        return 0;
    }
}

//设置组与的距离
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - 跳转到扫一扫
-(void)scanButtonResponseEvent{
    
    self.hidesBottomBarWhenPushed = YES;
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
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
       [self.navigationController pushViewController:vc animated:YES];
//              //显示tabBar
//       self.hidesBottomBarWhenPushed=YES;
    
    //设置点击时的背影色
    [self.oneCell.scanButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.oneCell.scanButton setBackgroundColor:[UIColor clearColor]];
        
        //跳转方法
        //QRCode QRCodeClickBy:self];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}

#pragma mark -  请求等级会员的数据
- (void)loadlevelLabelResponseData{
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
            [self.pickViewArr removeAllObjects];
            [self.memberlevel_id removeAllObjects];
            NSArray *aar = [dict[@"values"] objectForKey:@"getUserLevel"];
          //  self.letter = [dict[@"values"] objectForKey:@"sv_uc_callnameList"];
            if ([SVTool isEmpty:aar]) {
                [SVTool TextButtonAction:self.view withSing:@"请到德客PC端后台设置会员等级"];
            } else {
                for (NSDictionary *dic in aar) {
                    [self.pickViewArr addObject:dic[@"sv_ml_name"]];
                    [self.memberlevel_id addObject:dic[@"memberlevel_id"]];
                   
                }
                
                [self.tableView reloadData];
                
//                if ([self.licensePlateNumberCell.levelLabel.text isEqualToString:@"等级选择"]) {
//                    self.number =[self.memberlevel_id[0] integerValue];
//                    [SVUserManager loadUserInfo];
//                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
//                        self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
//                    }else{
//                        self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
//                    }
//                }
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
        
            }
        } else {
            [SVTool TextButtonAction:self.view withSing:@"等级数据请求失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 按钮响应事件 等级会员选择
-(void)levelLabelResponseEvent{
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
            [self.pickViewArr removeAllObjects];
            [self.memberlevel_id removeAllObjects];
            NSArray *aar = [dict[@"values"] objectForKey:@"getUserLevel"];
          //  self.letter = [dict[@"values"] objectForKey:@"sv_uc_callnameList"];
            if ([SVTool isEmpty:aar]) {
                [SVTool TextButtonAction:self.view withSing:@"请到德客PC端后台设置会员等级"];
            } else {
                for (NSDictionary *dic in aar) {
                    [self.pickViewArr addObject:dic[@"sv_ml_name"]];
                    [self.memberlevel_id addObject:dic[@"memberlevel_id"]];
                   
                }
                
                if ([self.licensePlateNumberCell.levelLabel.text isEqualToString:@"等级选择"]) {
                    self.number =[self.memberlevel_id[0] integerValue];
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_auto_beauty"]) {// 汽车美容行业
                        self.licensePlateNumberCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                    }else{
                        self.twoCell.levelLabel.text = [self.pickViewArr objectAtIndex:0];
                    }
                }
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //指定代理
                self.vipPickerView.vipPicker.delegate = self;
                self.vipPickerView.vipPicker.dataSource = self;
                //添加pickerView
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
            }
        } else {
            [SVTool TextButtonAction:self.view withSing:@"等级数据请求失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

#pragma mark - 性别数据
- (void)genderLabelResponseData{
    
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
            NSArray *array = [dict[@"values"] objectForKey:@"sv_uc_callnameList"];
            if (kArrayIsEmpty(array)) {
                self.letter = @[@"先生",@"女士"];
            }else{
                self.letter = array;
            }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
         
        
        } else {
            [SVTool TextButtonAction:self.view withSing:@"等级数据请求失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}

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
            NSArray *array = [dict[@"values"] objectForKey:@"sv_uc_callnameList"];
            if (kArrayIsEmpty(array)) {
                self.letter = @[@"先生",@"女士"];
            }else{
                self.letter = array;
            }
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
    
    
}


/**
 日期选择
 */
-(void)dateLabelResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
    
    //退出编辑
    [self.tableView endEditing:YES];
    
}


/**
 退出键盘响应方法
 */

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

#pragma mark - 懒加载
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

-(NSArray *)letter{
    if (!_letter) {
        _letter = [NSArray array];
    }
    return _letter;
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
    [self.addCustomView removeFromSuperview];
    [self.setUserdItemView removeFromSuperview];
    
    //[self.tableView reloadData];
    
}
//确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    
    NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    
    self.number =[self.memberlevel_id[row] integerValue];
    
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
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _myDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _myDatePicker.datePickerView.maximumDate = minDate;
        
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

- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}

- (void)cancleBtnClick{
  //  [self sureBtnClick];
    [self vipCancelResponseEvent];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if (!kStringIsEmpty(textView.text)) {
//         [self.textArray addObject:textView.text];
//    }
    
   

}

#pragma mark - 自定义弹框的确定按钮
- (void)sureBtnClick{
   
    if (!kStringIsEmpty(self.addCustomView.textView.text)) {
      //  [self.textArray addObject:self.addCustomView.textView.text];
        
        //sv_enabled 是否启用，sv_field_id :自定义主键id （新增时默认0） ，sv_field_name 自定义名称， sv_is_active是否删除，sv_is_remind_tim是否为时间自定义 ，sv_relation_id关联id （新增时默认0）  sv_sort  排序id
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/AddMemberCustomField?key=%@",[SVUserManager shareInstance].access_token];
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
        NSMutableArray *parame = [NSMutableArray array];
        // for (NSString *nameStr in self.selectArray) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        // [md setObject:dateString forKey:@"order_datetime"];
        dictM[@"sv_creation_date"] = dateString;
        dictM[@"sv_enabled"] = @"false";
        dictM[@"sv_field_id"] = @"0";
        dictM[@"sv_field_name"] = self.addCustomView.textView.text;
        dictM[@"sv_is_active"] = @"false";
        dictM[@"sv_is_remind_tim"] = @"false";
        dictM[@"sv_relation_id"] = @"0";
        dictM[@"sv_sort"] = @"0";
        [parame addObject:dictM];
        // }
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict = %@",dict);
            if ([[NSString stringWithFormat:@"%@",dict[@"succeed"]] isEqualToString:@"1"]) {
                NSMutableArray *array = dict[@"values"];
              //  NSMutableDictionary *dicTwo = array[0];
               // for (NSMutableDictionary *dictMTwo in array) {
                [self.textArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView layoutIfNeeded];
                
            
                SVAddFourCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (self.textArray.count -1) *55 +self.textArray.count -1, ScreenW, 55)];
                // [view removeFromSuperview];
                view.backgroundColor = [UIColor whiteColor];
                [cell addSubview:view];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
                label.textColor = [UIColor colorWithHexString:@"686868"];
                label.font = [UIFont systemFontOfSize:14];
                label.text = [NSString stringWithFormat:@"%@",self.addCustomView.textView.text];
                label.centerY = 55/2;
                [view addSubview:label];
                UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 10, ScreenW - label.width - 30, 50)];
                textF.placeholder = @"请输入";
                textF.font = [UIFont systemFontOfSize:14];
                textF.textAlignment = NSTextAlignmentRight;
                textF.centerY = 55/2;
              //  dicTwo[@"sv_field_value_new"] = [NSString stringWithFormat:@"%@",textF.text];
                [self.textFileArray addObject:textF];
                [view addSubview:textF];
                
              
                
            }else{
                [SVTool TextButtonAction:self.view withSing:dict[@"errmsg"]];
            }
            
            [self.addCustomView.textView endEditing:YES];
            [self vipCancelResponseEvent];
            
            self.addCustomView.textView.text = nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
  
}


- (NSMutableArray *)textArray
{
    if (!_textArray) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}

@end

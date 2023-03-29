//
//  SVNewWaresVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVNewWaresVC.h"
#import "SVNewWaresCell.h"
#import "SVNewWarestwoCell.h"
#import "SVUploadCell.h"
#import "SVNewWaresThreeCell.h"
#import "SVWaresClassVC.h"
//#import "NSUtil.h"
//unitpickerView
#import "SVUnitPickerView.h"
#import "YQImageCompressTool.h"
#import "SVMoreMemberPriceCell.h"
#import "SVTradePriceCell.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"

static NSString *NewWaresCellID = @"NewWaresCell";
static NSString *NewWarestwoCellID = @"NewWarestwoCell";
static NSString *NewWaresthreeCellID = @"NewWaresThreeCell";
static NSString *UploadCellID = @"UploadCell";
static NSString *MoreMemberPriceCellID = @"SVMoreMemberPriceCell";
static NSString *TradePriceCellID = @"SVTradePriceCell";

@interface SVNewWaresVC ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,/*修改头像*/UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
//上传图片cell
@property (nonatomic,strong) SVUploadCell *imgCell;

@property (nonatomic,strong) SVNewWaresCell *oneCell;
@property (nonatomic,strong) SVNewWarestwoCell *twoCell;
//全局单位的cell
@property (nonatomic,strong) SVNewWaresThreeCell *unitCell;

@property (nonatomic,strong) SVMoreMemberPriceCell * moreMemberPriceCell;

@property (nonatomic,strong) SVTradePriceCell * tradePriceCell;

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
//自定义pickerView
@property(nonatomic,strong) SVUnitPickerView *pickerView;
//单位
@property (nonatomic, strong) NSMutableArray *pickViewArr;

//全局属性
//图片路径
@property (nonatomic,copy) NSString *imgURL;
//款号
@property (nonatomic,copy) NSString *barcode;
//商品名称
@property (nonatomic,copy) NSString *waresName;
//分类
//@property (nonatomic,retain) NSString *classification;

//售价
@property (nonatomic,copy) NSString *price;
//进价
@property (nonatomic,copy) NSString *purchaseprice;

//库存
@property (nonatomic,copy) NSString *inventory;
//规格
@property (nonatomic,copy) NSString *specifications;

//单位
@property (nonatomic,copy) NSString *unit;

@property (nonatomic,assign) NSInteger switch_isOn;

/**
 回调回来的二级分类名
 */
@property (nonatomic, copy) NSString *className;

/**
 @“选择分类”
 */
@property (nonatomic, copy) NSString *localName;
@property (nonatomic, assign) NSInteger productcategory_id;
@property (nonatomic, assign) NSInteger productsubcategory_id;
@property (nonatomic, assign) NSInteger producttype_id;

@property (nonatomic,strong) NSString *value;

@property (nonatomic,strong) NSString * sv_p_mindiscount;
@property (nonatomic,strong) NSString * sv_p_minunitprice;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice;

@property (nonatomic,strong) NSString * sv_p_memberprice1;
@property (nonatomic,strong) NSString * sv_p_memberprice2;
@property (nonatomic,strong) NSString * sv_p_memberprice3;
@property (nonatomic,strong) NSString * sv_p_memberprice4;
@property (nonatomic,strong) NSString * sv_p_memberprice5;

@property (nonatomic,strong) NSString * sv_p_tradeprice1;
@property (nonatomic,strong) NSString * sv_p_tradeprice2;
@property (nonatomic,strong) NSString * sv_p_tradeprice3;
@property (nonatomic,strong) NSString * sv_p_tradeprice4;
@property (nonatomic,strong) NSString * sv_p_tradeprice5;

@property (nonatomic,strong) NSString * sv_mnemonic_code;
@property (nonatomic,strong) NSString * sv_p_artno;
@property (nonatomic,strong) NSString * sv_guaranteeperiod;
@end

@implementation SVNewWaresVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"新增商品";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"新增商品";
    self.switch_isOn = 0;// 一进来是计件的
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    /**
     布局界面
     */
    [self setupTabelView];
    /**
     请求单位的数据
     */
    [self loadData];
    // 请求款号数据
    [self addLoadData];
    
    
}

- (void)addLoadData{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetAutomaticallyGenerateMemberId?key=%@&plusone=true",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // NSLog(@"dict款号 = %@",dict);
        
        if ([dict[@"succeed"] integerValue] == 1) {
            self.oneCell.barcode.text = dict[@"values"];
            self.barcode = self.oneCell.barcode.text;
            self.twoCell.sv_p_artno.text = dict[@"values"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


/**
 添加tableView
 */
-(void)setupTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) style:UITableViewStyleGrouped];
    //RGBA(241, 241, 241, 1)
    self.tableView.backgroundColor = BackgroundColor;
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewWaresCell" bundle:nil] forCellReuseIdentifier:NewWaresCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewWarestwoCell" bundle:nil] forCellReuseIdentifier:NewWarestwoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewWaresThreeCell" bundle:nil] forCellReuseIdentifier:NewWaresthreeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVUploadCell" bundle:nil] forCellReuseIdentifier:UploadCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVMoreMemberPriceCell" bundle:nil] forCellReuseIdentifier:MoreMemberPriceCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVTradePriceCell" bundle:nil] forCellReuseIdentifier:TradePriceCellID];
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
}


#pragma mark -  请求单位的数据
- (void)loadData {
    
    //    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/getUserconfig?key=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];

//    [SVUserManager loadUserInfo];
//    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/getUserconfig?key=%@",[SVUserManager shareInstance].access_token];
//
//    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //隐藏提示框
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSString *a,*b,*c,*d;
//        if ([dict[@"succeed"]integerValue]==1) {
//            a=[[dict objectForKey:@"values"]objectForKey:@"sv_uc_unit"];
//            b=[a stringByReplacingOccurrencesOfString:@"[" withString:@""];
//            c=[b stringByReplacingOccurrencesOfString:@"]" withString:@""];
//            d=[c stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//
//            NSArray *strArr=[d componentsSeparatedByString:@","];
//            [self.pickViewArr addObjectsFromArray:strArr];
//            //            [self.supplierPcikerView reloadAllComponents];
//
//        }
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //隐藏提示框
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //        [SVTool requestFailed];
//        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//    }];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetunitModelList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.pickViewArr = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    
}

#pragma mark - 右按钮响应方法（请求保存商品）
-(void)rightbuttonResponseEvent{
    
    //控制添加会员只能点一次
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    //当前view退出编辑模式
    [self.tableView endEditing:YES];
    //取到token
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *token = [defaults stringForKey:@"access_token"];
    //    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/?key=%@",token];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/?key=%@&p_source=300",[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);
    
    //创建字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //款号
    if ([SVTool isBlankString:self.barcode]) {
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            [SVTool TextButtonActionWithSing:@"款号不能为空"];
        }else{
            [SVTool TextButtonActionWithSing:@"条码不能为空"];
        }
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    } else {
        [parameters setObject:self.barcode forKey:@"sv_p_barcode"];
    }
    
    //名称
    if ([SVTool isBlankString:self.waresName]) {
        [SVTool TextButtonActionWithSing:@"名称不能为空"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }else{
        [parameters setObject:self.waresName forKey:@"sv_p_name"];
    }
    
    //分类
    if ([self.localName isEqualToString:@"选择分类"]) {
        [SVTool TextButtonActionWithSing:@"选择分类"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    } else {
        [parameters setObject:[NSNumber numberWithInteger:self.productcategory_id] forKey:@"productcategory_id"];
        [parameters setObject:[NSNumber numberWithInteger:self.productsubcategory_id] forKey:@"productsubcategory_id"];
        [parameters setObject:[NSNumber numberWithInteger:self.producttype_id] forKey:@"producttype_id"];
    }
    
    //售价
    if ([SVTool isBlankString:self.price]) {
        [SVTool TextButtonActionWithSing:@"售价不能为空"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }else{
        [parameters setObject:[NSNumber numberWithFloat:[self.price floatValue]] forKey:@"sv_p_unitprice"];
    }
    
    //进价
    [parameters setObject:[NSNumber numberWithFloat:[self.purchaseprice floatValue]] forKey:@"sv_purchaseprice"];
    [parameters setObject:[NSNumber numberWithFloat:[self.purchaseprice floatValue]] forKey:@"sv_p_originalprice"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",self.switch_isOn] forKey:@"sv_pricing_method"];

    // self.switch_isOn
    //会员售价
    [parameters setObject:[NSNumber numberWithFloat:[self.sv_p_memberprice floatValue]] forKey:@"sv_p_memberprice"];

    //库存
    [parameters setObject:[NSNumber numberWithInteger:[self.inventory integerValue]] forKey:@"sv_p_storage"];
    
    //规格
    if (![SVTool isBlankString:self.specifications]) {
        [parameters setObject:self.specifications forKey:@"sv_p_specs"];
    }
    
    //单位
    if (![self.unit isEqualToString:@"单位选择"] && ![SVTool isBlankString:self.unit]) {
        [parameters setObject:self.unit forKey:@"sv_p_unit"];
    }
    
    //图片
    if (![SVTool isBlankString:self.imgURL]) {
        [parameters setObject:self.imgURL forKey:@"sv_p_images"];
    }
    
   
    if (!kStringIsEmpty(self.sv_p_mindiscount)) {
        [parameters setObject:self.sv_p_mindiscount forKey:@"sv_p_mindiscount"];

    }else{
        [parameters setObject:@"0.00" forKey:@"sv_p_mindiscount"];
    }
    
    if (!kStringIsEmpty(self.sv_p_minunitprice)) {
        [parameters setObject:self.sv_p_minunitprice forKey:@"sv_p_minunitprice"];

    }else{
        [parameters setObject:@"0.00" forKey:@"sv_p_minunitprice"];
    }
    
    //会员售价
    if (!kStringIsEmpty(self.sv_p_memberprice)) {
        [parameters setObject:self.sv_p_memberprice forKey:@"sv_p_memberprice"];
    }else{
        [parameters setObject:@"0.00" forKey:@"sv_p_memberprice"];
    }
    
   // 处理新增的数据
    if (kStringIsEmpty(self.sv_p_memberprice1)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_memberprice1"];

    }else{
        [parameters setObject:self.sv_p_memberprice1 forKey:@"sv_p_memberprice1"];

    }
    
    if (kStringIsEmpty(self.sv_p_memberprice2)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_memberprice2"];

    }else{
        [parameters setObject:self.sv_p_memberprice2 forKey:@"sv_p_memberprice2"];

    }
    
    if (kStringIsEmpty(self.sv_p_memberprice3)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_memberprice3"];

    }else{
        [parameters setObject:self.sv_p_memberprice3 forKey:@"sv_p_memberprice3"];

    }
    
    if (kStringIsEmpty(self.sv_p_memberprice4)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_memberprice4"];

    }else{
        [parameters setObject:self.sv_p_memberprice4 forKey:@"sv_p_memberprice4"];

    }
    
    if (kStringIsEmpty(self.sv_p_memberprice5)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_memberprice5"];

    }else{
        [parameters setObject:self.sv_p_memberprice5 forKey:@"sv_p_memberprice5"];

    }
    
    
    // 批发价
    if (kStringIsEmpty(self.sv_p_tradeprice1)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_tradeprice1"];
    }else{
        [parameters setObject:self.sv_p_tradeprice1 forKey:@"sv_p_tradeprice1"];
    }
    
    if (kStringIsEmpty(self.sv_p_tradeprice2)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_tradeprice2"];

    }else{
        [parameters setObject:self.sv_p_tradeprice2 forKey:@"sv_p_tradeprice2"];
 
    }
    
    if (kStringIsEmpty(self.sv_p_tradeprice3)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_tradeprice3"];

    }else{
        [parameters setObject:self.sv_p_tradeprice3 forKey:@"sv_p_tradeprice3"];

    }
    
    if (kStringIsEmpty(self.sv_p_tradeprice4)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_tradeprice4"];

    }else{
        [parameters setObject:self.sv_p_tradeprice4 forKey:@"sv_p_tradeprice4"];

    }
    
    if (kStringIsEmpty(self.sv_p_tradeprice5)) {
        [parameters setObject:@"0.0" forKey:@"sv_p_tradeprice5"];
   
    }else{
        [parameters setObject:self.sv_p_tradeprice5 forKey:@"sv_p_tradeprice5"];

    }

    // 助词码
    if (!kStringIsEmpty(self.sv_mnemonic_code)) {
        [parameters setObject:self.sv_mnemonic_code forKey:@"sv_mnemonic_code"];
      //  self.sv_mnemonic_code = self.twoCell.sv_mnemonic_code.text;
    }
   
    // 条码
    if (!kStringIsEmpty(self.sv_p_artno)) {
        [parameters setObject:self.sv_p_artno forKey:@"sv_p_artno"];
      //  self.sv_p_artno = self.twoCell.sv_p_artno.text;
    }
    
    // 质保天数
    if (!kStringIsEmpty(self.sv_guaranteeperiod)) {
        [parameters setObject:self.sv_guaranteeperiod forKey:@"sv_guaranteeperiod"];
    }
    
   
    
//    [parameters setObject:[NSNumber numberWithFloat:[self.sv_p_memberprice floatValue]] forKey:@"sv_p_memberprice"];
    
    
    //是否只限积分兑换（后期有用）
    [parameters setObject:[NSNumber numberWithDouble:NO] forKey:@"sv_p_isonlypoint"];
    
    //这个是什么呀？？
    //    [parameters setObject:@"" forKey:@"sv_mr_headimg"];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"新增urlStr = %@",urlStr);
        NSLog(@"新增parameters = %@",parameters);
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //添加成功时，回调给商品列表刷新
            if (self.addWaresBlock) {
                self.addWaresBlock();
            }
            
            [SVTool TextButtonActionWithSing:@"添加商品成功"];
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            //提示添加失败的原因
            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
            [SVTool TextButtonActionWithSing:errmsg];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[SVTool requestFailed];
        [SVTool TextButtonActionWithSing:@"网络开小差了"];
    }];
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!kStringIsEmpty(self.sv_p_mindiscount) || !kStringIsEmpty(self.sv_p_minunitprice)) {
        return 5;
    }else{
        return 6;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 168;
    }else if (indexPath.section == 1){
        return 168 + 55;
    }else if (indexPath.section == 2){
        return 223 + 55;
    }else if (indexPath.section == 3){
        
        if (!kStringIsEmpty(self.sv_p_mindiscount) || !kStringIsEmpty(self.sv_p_minunitprice)) {
            return 166;
            
        }else{
            return 443.5;
        }
    }else if (indexPath.section == 4){
        if (!kStringIsEmpty(self.sv_p_mindiscount) || !kStringIsEmpty(self.sv_p_minunitprice)) {
            return 100;
        }else{
            return 277;
        }
        
    }else{
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //创建cell
        self.oneCell = [tableView dequeueReusableCellWithIdentifier:NewWaresCellID forIndexPath:indexPath];
        //如果没有就重新建一个
        if (!self.oneCell) {
            self.oneCell = [[SVNewWaresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewWaresCellID];
        }
        //指定代理
        self.oneCell.barcode.delegate = self;
        self.oneCell.waresName.delegate = self;
        
        //先判断block回调有没有值，有就赋值
        if (self.className) {
            self.oneCell.waresClassLabel.text = self.className;
        }
        
        //self.classification = cell.classification.text;
        //扫一扫事件
        [self.oneCell.scanButton addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         分类跳转事件
         */
        //允许用户交互
        //cell.waresClassLabel.userInteractionEnabled = YES;
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(waresClassLabelResponseEvent)];
        //给dateLabel添加手势
        [self.oneCell.waresClassView addGestureRecognizer:singleTap];
        
        self.localName = self.oneCell.waresClassLabel.text;
        return self.oneCell;
    }else if (indexPath.section == 1){
        self.twoCell = [tableView dequeueReusableCellWithIdentifier:NewWarestwoCellID forIndexPath:indexPath];
        if (!self.twoCell) {
            self.twoCell = [[SVNewWarestwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewWarestwoCellID];
            
        }
        //指定代理
        self.twoCell.price.delegate = self;
        self.twoCell.sv_p_originalprice.delegate = self;
      //  self.twoCell.sv_p_memberprice.delegate = self;
        
        self.twoCell.sv_p_artno.delegate = self;
        self.twoCell.sv_mnemonic_code.delegate = self;
        
        return self.twoCell;
    }else if (indexPath.section == 2){
        
        self.unitCell = [tableView dequeueReusableCellWithIdentifier:NewWaresthreeCellID forIndexPath:indexPath];
        if (!self.unitCell) {
            self.unitCell = [[SVNewWaresThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewWaresthreeCellID];
        }
        //self.unit = cell.unit.text;
        
        self.unitCell.inventory.delegate = self;
        self.unitCell.specifications.delegate = self;
        self.unitCell.sv_guaranteeperiod.delegate = self;
        //允许用户交互
        self.unitCell.unit.userInteractionEnabled = YES;
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unitResponseEvent)];
        //添加手势
        [self.unitCell.unitView addGestureRecognizer:singleTap];
        
        [self.unitCell.switch_isOn addTarget:self action:@selector(switch_isOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return self.unitCell;

    }else if (indexPath.section == 3){
        self.moreMemberPriceCell = [tableView dequeueReusableCellWithIdentifier:MoreMemberPriceCellID forIndexPath:indexPath];
        if (!self.moreMemberPriceCell) {
            self.moreMemberPriceCell = [[SVMoreMemberPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreMemberPriceCellID];
        }
        
        self.moreMemberPriceCell.MinimumDiscount.delegate = self;
        self.moreMemberPriceCell.MinimumPrice.delegate = self;
        self.moreMemberPriceCell.MemberPrice.delegate = self;
        self.moreMemberPriceCell.MemberPrice1.delegate = self;
        self.moreMemberPriceCell.MemberPrice2.delegate = self;
        self.moreMemberPriceCell.MemberPrice3.delegate = self;
        self.moreMemberPriceCell.MemberPrice4.delegate = self;
        self.moreMemberPriceCell.MemberPrice5.delegate = self;
        
        return self.moreMemberPriceCell;
       
    }else if (indexPath.section == 4){
//        self.tradePriceCell = [tableView dequeueReusableCellWithIdentifier:TradePriceCellID forIndexPath:indexPath];
//        if (!self.tradePriceCell) {
//            self.tradePriceCell = [[NSBundle mainBundle]loadNibNamed:@"SVTradePriceCell" owner:nil options:nil].lastObject;
//        }
//
//        return self.tradePriceCell;
        
        if (!kStringIsEmpty(self.sv_p_mindiscount) || !kStringIsEmpty(self.sv_p_minunitprice)) {
          
            self.imgCell = [tableView dequeueReusableCellWithIdentifier:UploadCellID forIndexPath:indexPath];
            if (!self.imgCell) {
              //  self.imgCell = [[NSBundle mainBundle]loadNibNamed:@"SVUploadCell" owner:nil options:nil].lastObject;
                self.imgCell = [[SVUploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UploadCellID];
            }
            //进来赋值
            if (![SVTool isBlankString:self.imgURL]) {

                NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imgURL]]];

                UIImage* resultImage = [UIImage imageWithData: imageData];
                CGImageRef cgref = [resultImage CGImage];
                   CIImage *cim = [resultImage CIImage];
                
                if (cim == nil && cgref == NULL)
                 {
                    // NSLog(@"no image");
                     [self.imgCell.imgButton setImage:[UIImage imageNamed:@"addImage_icon"] forState:UIControlStateNormal];
                 } else {
                    [self.imgCell.imgButton setImage:resultImage forState:UIControlStateNormal];
                 }
                
                //[ setBackgroundImage:resultImage forState:UIControlStateNormal]; addImage_icon
    //            if (Kstr) {
    //                <#statements#>
    //            }
                
            }
            
            //添加响应事件
            [self.imgCell.imgButton addTarget:self action:@selector(imgButtonResponseEvent:) forControlEvents:UIControlEventTouchUpInside];
            return self.imgCell;
        }else{
            self.tradePriceCell = [tableView dequeueReusableCellWithIdentifier:TradePriceCellID forIndexPath:indexPath];
            if (!self.tradePriceCell) {
//                self.tradePriceCell = [[NSBundle mainBundle]loadNibNamed:@"SVTradePriceCell" owner:nil options:nil].lastObject;
                self.tradePriceCell = [[SVTradePriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TradePriceCellID];
            }
            
            self.tradePriceCell.sv_p_tradeprice1.delegate = self;
            self.tradePriceCell.sv_p_tradeprice2.delegate = self;
            self.tradePriceCell.sv_p_tradeprice3.delegate = self;
            self.tradePriceCell.sv_p_tradeprice4.delegate = self;
            self.tradePriceCell.sv_p_tradeprice5.delegate = self;
//            if (!kStringIsEmpty(self.sv_p_tradeprice1)) {
//                self.tradePriceCell.sv_p_tradeprice1.text = self.sv_p_tradeprice1;
//            }
//
//            if (!kStringIsEmpty(self.sv_p_tradeprice2)) {
//                self.tradePriceCell.sv_p_tradeprice2.text = self.sv_p_tradeprice2;
//            }
//
//            if (!kStringIsEmpty(self.sv_p_tradeprice3)) {
//                self.tradePriceCell.sv_p_tradeprice3.text = self.sv_p_tradeprice3;
//            }
//
//            if (!kStringIsEmpty(self.sv_p_tradeprice4)) {
//                self.tradePriceCell.sv_p_tradeprice4.text = self.sv_p_tradeprice4;
//            }
//            if (!kStringIsEmpty(self.sv_p_tradeprice5)) {
//                self.tradePriceCell.sv_p_tradeprice5.text = self.sv_p_tradeprice5;
//            }
            
            
            return self.tradePriceCell;
        }
    }else{
        self.imgCell = [tableView dequeueReusableCellWithIdentifier:UploadCellID forIndexPath:indexPath];
        if (!self.imgCell) {
            self.imgCell = [[SVUploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UploadCellID];
        }
        [self.imgCell.imgButton addTarget:self action:@selector(imgButtonResponseEvent:) forControlEvents:UIControlEventTouchUpInside];
        return self.imgCell;
    }
    return nil;
}

- (void)switch_isOnClick:(UISwitch *)swi{
    if (swi.isOn) {
        self.switch_isOn = 1;// 开了就是计重的
    }else{
        self.switch_isOn = 0;// 没开就是计件的
    }
}



//设置组与的距离
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


#pragma mark - UITextFieldDelegate
//编辑完成时调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {

        case 0:
       

            self.barcode = textField.text;
           
            break;

        case 1:
        {

            self.waresName = textField.text;
            NSString *s = textField.text;
                
                NSMutableArray *characters = [NSMutableArray array];
                NSMutableString *mutStr = [NSMutableString string];
                
                
                // 分离出字符串中的所有字符，并存储到数组characters中
                for (int i = 0; i < s.length; i ++) {
                    NSString *subString = [s substringToIndex:i + 1];
                    
                    subString = [subString substringFromIndex:i];
                    
                    [characters addObject:subString];
                }
                
                // 利用正则表达式，匹配数组中的每个元素，判断是否是数字，将数字拼接在可变字符串mutStr中
                for (NSString *b in characters) {
                    NSString *regex = @"^[0-9]*$";
                    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];// 谓词
                    BOOL isShu = [pre evaluateWithObject:b];// 对b进行谓词运算
                    
                    if (isShu) {
                        [mutStr appendString:b];
                    }else{
                        
                    }
                }
                NSLog(@"数字符串: %@", mutStr);

         NSString *str = [self firstCharactor:textField.text];
            
            self.twoCell.sv_mnemonic_code.text = [NSString stringWithFormat:@"%@%@",str,mutStr];
        }
           
            break;
            case 2:
            self.price = textField.text;
            break;
            case 3:
            self.purchaseprice = textField.text;
            break;
            case 4:
            self.sv_p_memberprice = textField.text;
            break;
            case 5:
            self.inventory = textField.text;
            break;
            case 6:
            self.specifications = textField.text;
            break;
            
        case 7: // 最低折
        {
           // self.specifications = textField.text;
           // self.moreMemberPriceCell.MinimumDiscount.delegate = self;
          
            if (kStringIsEmpty(textField.text)) {
                NSString *text = [NSString stringWithFormat:@"%@",textField.text];
                self.sv_p_mindiscount = text;
                [self.tableView reloadData];
                self.moreMemberPriceCell.MinimumDiscount.userInteractionEnabled = YES;
                self.moreMemberPriceCell.MinimumPrice.userInteractionEnabled = YES;
                self.moreMemberPriceCell.MemberPrice.userInteractionEnabled = YES;
                
                self.moreMemberPriceCell.view1.hidden = NO;
                self.moreMemberPriceCell.viewBottom1.hidden = NO;
                self.moreMemberPriceCell.view2.hidden = NO;
                self.moreMemberPriceCell.view2Bottom.hidden = NO;
                self.moreMemberPriceCell.view3.hidden = NO;
                self.moreMemberPriceCell.view3Bottom.hidden = NO;
                self.moreMemberPriceCell.view4.hidden = NO;
                self.moreMemberPriceCell.view4Bottom.hidden = NO;
                self.moreMemberPriceCell.view5.hidden = NO;
            }else{
                
                if (textField.text.doubleValue > 10) {
                    textField.text = @"10";
//                    NSString *text = [NSString stringWithFormat:@"%@",textField.text];
//                    self.sv_p_mindiscount = text;
                  //  [self.tableView reloadData];
                }else if (textField.text.doubleValue <= 0){
                    textField.text = @"1";
//                    NSString *text = [NSString stringWithFormat:@"%@",textField.text];
//                    self.sv_p_mindiscount = text;
                  //  [self.tableView reloadData];
                }
                NSString *text = [NSString stringWithFormat:@"%@",textField.text];
                self.sv_p_mindiscount = text;
                [self.tableView reloadData];
                
                self.moreMemberPriceCell.MinimumPrice.userInteractionEnabled = NO;
                self.moreMemberPriceCell.MemberPrice.userInteractionEnabled = NO;
                
                self.moreMemberPriceCell.view1.hidden = YES;
                self.moreMemberPriceCell.viewBottom1.hidden = YES;
                self.moreMemberPriceCell.view2.hidden = YES;
                self.moreMemberPriceCell.view2Bottom.hidden = YES;
                self.moreMemberPriceCell.view3.hidden = YES;
                self.moreMemberPriceCell.view3Bottom.hidden = YES;
                self.moreMemberPriceCell.view4.hidden = YES;
                self.moreMemberPriceCell.view4Bottom.hidden = YES;
                self.moreMemberPriceCell.view5.hidden = YES;
                
                self.sv_p_memberprice1 = @"";
                self.sv_p_memberprice2= @"";
                self.sv_p_memberprice3= @"";
                self.sv_p_memberprice4= @"";
                self.sv_p_memberprice5= @"";

                self.sv_p_tradeprice1= @"";
                self.sv_p_tradeprice2= @"";
                self.sv_p_tradeprice3= @"";
                self.sv_p_tradeprice4= @"";
                self.sv_p_tradeprice5= @"";
            }
           // [self.tableView reloadData];
        }
            
            break;
            
        case 8: // 最低价
        {
           // self.specifications = textField.text;
            NSString *text = [NSString stringWithFormat:@"%@",textField.text];
            NSLog(@"最低价text = %@",text);
            self.sv_p_minunitprice = text;
            [self.tableView reloadData];
            if (kStringIsEmpty(textField.text)) {
                self.moreMemberPriceCell.MinimumDiscount.userInteractionEnabled = YES;
                self.moreMemberPriceCell.MinimumPrice.userInteractionEnabled = YES;
                self.moreMemberPriceCell.MemberPrice.userInteractionEnabled = YES;
                
                self.moreMemberPriceCell.view1.hidden = NO;
                self.moreMemberPriceCell.viewBottom1.hidden = NO;
                self.moreMemberPriceCell.view2.hidden = NO;
                self.moreMemberPriceCell.view2Bottom.hidden = NO;
                self.moreMemberPriceCell.view3.hidden = NO;
                self.moreMemberPriceCell.view3Bottom.hidden = NO;
                self.moreMemberPriceCell.view4.hidden = NO;
                self.moreMemberPriceCell.view4Bottom.hidden = NO;
                self.moreMemberPriceCell.view5.hidden = NO;
            }else{
             self.moreMemberPriceCell.MinimumDiscount.userInteractionEnabled = NO;
           //  self.moreMemberPriceCell.MinimumPrice.userInteractionEnabled = NO;
             self.moreMemberPriceCell.MemberPrice.userInteractionEnabled = NO;
                
                self.moreMemberPriceCell.view1.hidden = YES;
                self.moreMemberPriceCell.viewBottom1.hidden = YES;
                self.moreMemberPriceCell.view2.hidden = YES;
                self.moreMemberPriceCell.view2Bottom.hidden = YES;
                self.moreMemberPriceCell.view3.hidden = YES;
                self.moreMemberPriceCell.view3Bottom.hidden = YES;
                self.moreMemberPriceCell.view4.hidden = YES;
                self.moreMemberPriceCell.view4Bottom.hidden = YES;
                self.moreMemberPriceCell.view5.hidden = YES;
                
                self.sv_p_memberprice1 = @"";
                self.sv_p_memberprice2= @"";
                self.sv_p_memberprice3= @"";
                self.sv_p_memberprice4= @"";
                self.sv_p_memberprice5= @"";

                self.sv_p_tradeprice1= @"";
                self.sv_p_tradeprice2= @"";
                self.sv_p_tradeprice3= @"";
                self.sv_p_tradeprice4= @"";
                self.sv_p_tradeprice5= @"";
            }
            
          //  [self.tableView reloadData];
        }
            break;
            
        case 9: // 会员价
        {
          //  self.specifications = textField.text;
            NSString *text = [NSString stringWithFormat:@"%@",textField.text];
            NSLog(@"最低价text = %@",text);
            self.sv_p_memberprice = text;
            [self.tableView reloadData];
            if (kStringIsEmpty(textField.text)) {
                self.moreMemberPriceCell.MinimumDiscount.userInteractionEnabled = YES;
                self.moreMemberPriceCell.MinimumPrice.userInteractionEnabled = YES;
                self.moreMemberPriceCell.MemberPrice.userInteractionEnabled = YES;
            }else{
                self.moreMemberPriceCell.MinimumDiscount.userInteractionEnabled = NO;
                self.moreMemberPriceCell.MinimumPrice.userInteractionEnabled = NO;
               // self.moreMemberPriceCell.MemberPrice.userInteractionEnabled = NO;
            }
            self.sv_p_memberprice1 = self.moreMemberPriceCell.MemberPrice1.text;
            self.sv_p_memberprice2 = self.moreMemberPriceCell.MemberPrice2.text;
            self.sv_p_memberprice3 = self.moreMemberPriceCell.MemberPrice3.text;
            self.sv_p_memberprice4 = self.moreMemberPriceCell.MemberPrice4.text;
            self.sv_p_memberprice5 = self.moreMemberPriceCell.MemberPrice5.text;

            self.sv_p_tradeprice1= self.tradePriceCell.sv_p_tradeprice1.text;
            self.sv_p_tradeprice2= self.tradePriceCell.sv_p_tradeprice2.text;
            self.sv_p_tradeprice3= self.tradePriceCell.sv_p_tradeprice3.text;
            self.sv_p_tradeprice4= self.tradePriceCell.sv_p_tradeprice4.text;
            self.sv_p_tradeprice5= self.tradePriceCell.sv_p_tradeprice5.text;
        }
            
            break;
            
        case 10: // 条码
            self.sv_p_artno = textField.text;
            break;
            
        case 11: // 助词码
            self.sv_mnemonic_code = textField.text;
            break;
        case 12: // 质保天数
            self.sv_guaranteeperiod = textField.text;
            break;
//        case 13: // 最低折
//            self.sv_p_mindiscount = textField.text;
//            break;
//        case 14: // 最低价
//            self.sv_p_minunitprice = textField.text;
//            break;
//        case 15: // 会员价
//            self.sv_p_memberprice = textField.text;
//            break;
        case 16: // 会员价1
            self.sv_p_memberprice1 = textField.text;
            break;
        case 17:// 会员价2
            self.sv_p_memberprice2 = textField.text;
            
            break;
        case 18:// 会员价3
            self.sv_p_memberprice3 = textField.text;
            
            break;
        case 19:// 会员价4
            self.sv_p_memberprice4 = textField.text;
            
            break;
        case 20:// 会员价5
            self.sv_p_memberprice5 = textField.text;
            
            break;
        case 21: // 批发价1
            self.sv_p_tradeprice1 = textField.text;
            break;
        case 22:// 批发价2
            self.sv_p_tradeprice2 = textField.text;
            
            break;
        case 23:// 批发价3
            self.sv_p_tradeprice3 = textField.text;
            
            break;
        case 24:// 批发价4
            self.sv_p_tradeprice4 = textField.text;
            
            break;
        case 25:// 批发价5
            self.sv_p_tradeprice5 = textField.text;
            
            break;
            
        default:
            break;
    }
}




//获取汉字的首字母
- (NSString *)firstCharactor:(NSString *)aString
{
   NSMutableString *str = [NSMutableString stringWithString:aString];
CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
   
   NSString *pinYin = [str capitalizedString];
   
   NSString *firatCharactors = [NSMutableString string];
   for (int i = 0; i < pinYin.length; i++) {
       if ([pinYin characterAtIndex:i] >= 'A' && [pinYin characterAtIndex:i] <= 'Z') {
           firatCharactors = [firatCharactors stringByAppendingString:[NSString stringWithFormat:@"%C",[pinYin characterAtIndex:i]]];
       }else{
         //  firatCharactors = [firatCharactors stringByAppendingString:[NSString stringWithFormat:@"%C",[pinYin characterAtIndex:i]]];
           NSCharacterSet * set =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];

           CGFloat second=[[firatCharactors stringByTrimmingCharactersInSet:set] floatValue];

           NSLog(@"最终输出数字部分=%f",second);

       }
   }
   return firatCharactors;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 7: // 最低折
        {
           // self.specifications = textField.text;
            textField.tintColor = [UIColor grayColor];
        }
            
            break;
            
        case 8: // 最低价
        {
           // self.specifications = textField.text;
            textField.tintColor = [UIColor grayColor];
        }
            break;
            
        case 9: // 会员价
        {
            textField.tintColor = [UIColor grayColor];
           // self.specifications = textField.text;
        }
            
            break;
    }
}

#pragma mark - 不能输入空格
//- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
//
//{
//
//
//
//}

//限制字数输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString*tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    //  NSString*tem = [[string componentsSeparatedByCharactersInSet:]]
    if(![string isEqualToString:tem]) {
        [SVTool TextButtonActionWithSing:@"不支持输入空格"];
        return NO;
        
    }
    
    //  return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    if ([textField isEqual:self.oneCell.waresName] || [textField isEqual:self.unitCell.inventory]) {
        //超过20位 就不能在输入了
        if (pointLength > 15) {
            return NO;
        }else{
            return YES;
        }
    }
    
    if ([textField isEqual:self.oneCell.barcode] || [textField isEqual:self.unitCell.specifications]) {
        if (pointLength > 30) {
            return NO;
        }else{
            return YES;
        }
    }
    
    NSCharacterSet *cs;
    if ([textField isEqual:self.twoCell.price] || [textField isEqual:self.twoCell.sv_p_originalprice] || [textField isEqual:self.twoCell.sv_p_memberprice]) {
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        if (dotLocation == NSNotFound && range.location != 0) {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
            if (range.location >= 9) {
                
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                
                return NO;
            }
        }else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            return NO;
        }
        if (textField.text.length > 11) {
            return NO;
        }
    }
    
  
    
    return YES;
}

#pragma mark - 跳转到分类界面
//分类跳转
-(void)waresClassLabelResponseEvent{
    
    //退出编辑
    [self.tableView endEditing:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    SVWaresClassVC *VC = [[SVWaresClassVC alloc]init];
    
    //对象有一个Block属性，然而这个Block属性中又引用了对象的其他成员变量，那么就会对这个变量本身产生强引用，那么变量本身和他自己的Block属性就形成了循环引用。因此我们需要对其进行处理进行弱引用。
    __weak typeof(self) weakSelf = self;
    VC.nameBlock = ^(NSString *name,NSString *productcategory_id,NSString *productsubcategory_id,NSString *producttype_id) {
        //把回调回来的二级分类名用全局属性保存
        weakSelf.className = name;
        
        weakSelf.productcategory_id = [productcategory_id integerValue];
        
        weakSelf.productsubcategory_id = [productsubcategory_id integerValue];
        
        weakSelf.producttype_id = [producttype_id integerValue];
        
        [weakSelf.tableView reloadData];
        
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 单位
-(void)unitResponseEvent{
    
    //退出编辑状态
    [self.tableView endEditing:YES];
    
    //pickerView指定代理
    self.pickerView.unitPicker.delegate = self;
    self.pickerView.unitPicker.dataSource = self;
    
    //为空是提示
    if ([SVTool isEmpty:self.pickViewArr]) {
        [SVTool TextButtonAction:self.view withSing:@"单位数据为空，可到电脑端添加单位"];
        return;
    }
    
    //    [self.view addSubview:self.maskTheView];
    //    [self.view addSubview:self.pickerView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    
}

#pragma mark UIPickerView DataSource Method 数据源方法
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickViewArr.count;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = self.pickViewArr[row];
    
    self.unit = [NSString stringWithFormat:@"%@",dict[@"sv_unit_name"]];
    return self.unit;
}


#pragma mark - 跳转到扫一扫
-(void)scanButtonResponseEvent{
    
    __weak typeof(self) weakSelf = self;
    
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *VC = [QQLBXScanViewController new];
    VC.libraryType = [Global sharedManager].libraryType;
    VC.scanCodeType = [Global sharedManager].scanCodeType;
    VC.selectNumber = 1;
    VC.isStockPurchase = 5;// 0是新增商品跳转过来的
   // vc.stockCheckVC = self;
    VC.style = [StyleDIY weixinStyle];
  //  [self.navigationController pushViewController:VC animated:YES];
      self.hidesBottomBarWhenPushed = NO;
    
    VC.addShopScanBlock = ^(NSString *name) {
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetGoodsInfoByBarcode?key=%@&barcode=%@",[SVUserManager shareInstance].access_token,name];
        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"444dic = %@",dic);
            NSDictionary *dic55 = dic[@"values"];
            if (kDictIsEmpty(dic55)) {
                weakSelf.oneCell.barcode.text = name;
                weakSelf.barcode = name;
            }else{
                weakSelf.oneCell.waresName.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_goods_name"]];
                if (![SVTool isBlankString:weakSelf.oneCell.waresName.text]) {
                    weakSelf.waresName = weakSelf.oneCell.waresName.text;
                }
                weakSelf.twoCell.price.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_price"]];
                if (![SVTool isBlankString:weakSelf.twoCell.price.text]) {
                    weakSelf.price = weakSelf.twoCell.price.text;
                }

                weakSelf.oneCell.barcode.text = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_barcode"]];
                if (![SVTool isBlankString:weakSelf.oneCell.barcode.text]) {
                    weakSelf.barcode = weakSelf.oneCell.barcode.text;
                }

                NSLog(@"dic = %@",dic);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    };
    

    
    //设置点击时的背影色
    [self.oneCell.scanButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.oneCell.scanButton setBackgroundColor:[UIColor clearColor]];
        
        [self.navigationController pushViewController:VC animated:YES];
    });
    
}

- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category name:(NSString *)name {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@&read_morespec=true",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,name];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic---%@",dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 修改头像的响应方法
//  方法：alterHeadPortrait
-(void)imgButtonResponseEvent:(UITapGestureRecognizer *)gesture{
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
    //赋值图片
//    [self.imgCell.imgButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
    [self.imgCell.imgButton setImage:newPhoto forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(saveImage:) withObject:newPhoto afterDelay:0.5];
    
}

#pragma mark - 上传图片的方法
- (void)saveImage:(UIImage *)image {
    
    [SVUserManager loadUserInfo];
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在压缩图片"];
    NSString *loadImage_path = @"/system/UploadImg";
    
    NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
    //    NSLog(@"urlStr = %@",urlStr);
    
    // UIImage *newImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(200.0f, 200.0f)];
    //   UIImage *newImage= [NSUtil imageWithOriginalImage:image quality:1];
    
   // NSData *newIMGData = [self resetSizeOfImageData:image maxSize:50];

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

            //                    [SVTool ];
            if ([self changeImagePath:dic[@"values"]].length <= 0) {
                [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
            }else{
                self.imgURL = [self changeImagePath:dic[@"values"]];
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
//单位数组
- (NSMutableArray *)pickViewArr {
    
    if (!_pickViewArr) {
        
        _pickViewArr = [NSMutableArray array];
    }
    return _pickViewArr;
    
}

/**
 单位选择
 */
-(SVUnitPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[NSBundle mainBundle] loadNibNamed:@"SVUnitPickerView" owner:nil options:nil].lastObject;
        _pickerView.frame = CGRectMake(0, 0, 320, 230);
        _pickerView.center = self.view.center;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.layer.cornerRadius = 10;
        
        [_pickerView.unitCancel addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.unitDetermine addTarget:self action:@selector(unitDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerView;
}

/**
 遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unitCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

//点击手势的点击事件
- (void)unitDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    //获取pickerView中第0列的选中值
    NSInteger row=[self.pickerView.unitPicker selectedRowInComponent:0];
    NSDictionary *dict = [self.pickViewArr objectAtIndex:row];
    self.unit = dict[@"sv_unit_name"];
    self.unitCell.unit.text = dict[@"sv_unit_name"];
}

- (void)unitCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
}


@end

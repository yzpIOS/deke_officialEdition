//
//  SVQuickDeductionVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/10/21.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVQuickDeductionVC.h"
#import "SVDeductionDetailVC.h"
#import "SVVipSelectVC.h"
#import "SVSettlementTimesCountModel.h"
#import "SVVipSelectModdl.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
@interface SVQuickDeductionVC ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
@property (weak, nonatomic) IBOutlet UIButton *nightBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeroTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *spotBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *telNum;

@property(retain,nonatomic) NSMutableString *string;
//NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property(retain,nonatomic) NSMutableString *stringNumber;

@property(retain,nonatomic) NSString *member_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *storedValue;
@property (nonatomic,strong) NSString *sv_mw_sumpoint;
@property (nonatomic,strong) NSString *sv_mr_birthday;
@property (nonatomic,strong) NSString *sv_mr_cardno;
@property (nonatomic,strong) NSString *sv_mw_availablepoint;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *numberText;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;






@end

@implementation SVQuickDeductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.title = @"快速扣次";
//     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    
//    //更改navigation的标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
      self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"选择会员" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
    self.topView.layer.cornerRadius = 30;
    self.topView.layer.masksToBounds = YES;
    
    self.oneBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.oneBtn.layer.masksToBounds = YES;
    
    self.twoBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.twoBtn.layer.masksToBounds = YES;
    
    self.threeBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.threeBtn.layer.masksToBounds = YES;
    
    self.fourBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.fourBtn.layer.masksToBounds = YES;
    
    self.fiveBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.fiveBtn.layer.masksToBounds = YES;
    
    self.sixBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.sixBtn.layer.masksToBounds = YES;
    
    self.sevenBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.sevenBtn.layer.masksToBounds = YES;
    
    self.eightBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.eightBtn.layer.masksToBounds = YES;
    
    self.nightBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.nightBtn.layer.masksToBounds = YES;
    
    self.zeroTwoBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.zeroTwoBtn.layer.masksToBounds = YES;
    
    self.zeroBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.zeroBtn.layer.masksToBounds = YES;
    
    self.spotBtn.layer.cornerRadius = (ScreenW -160) / 3 /2;
    self.spotBtn.layer.masksToBounds = YES;
    
    self.sureBtn.layer.cornerRadius = 30;
    self.sureBtn.layer.masksToBounds = YES;
    
    
    self.numberText = @"";
    self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber = [[NSMutableString alloc]init];
}

//- (void)viewWillAppear:(BOOL)animated{
//
//[super viewWillAppear:animated];
//
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//
//    titleLabel.font = [UIFont systemFontOfSize:17];
//
//     titleLabel.textColor = [UIColor blackColor];;
//
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//
//    titleLabel.text=self.title;
//
//    self.navigationItem.titleView = titleLabel;
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
//
//self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//}



- (void)selectbuttonResponseEvent{
    

    SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
    
    __weak typeof(self) weakSelf = self;

    VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
        self.textLabel.hidden = YES;
        weakSelf.telNum.text = phone;
        weakSelf.member_id = member_id;
        weakSelf.name = name;
        weakSelf.level = level;
        weakSelf.sv_mr_cardno = sv_mr_cardno;
        weakSelf.storedValue = storedValue;
        weakSelf.sv_mw_sumpoint = sv_mw_sumpoint;
        weakSelf.sv_mw_availablepoint = sv_mw_availablepoint;
        weakSelf.discount = discount;
        weakSelf.sv_mr_birthday = sv_mr_birthday;
        weakSelf.headimg = headimg;
        
        [weakSelf loadUserMemberId:member_id];
    };
    [self.navigationController pushViewController:VC animated:YES];
   
}

- (IBAction)allNumberClick:(UIButton *)btn {
   // btn.selected = !btn.selected;
//    [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"F1F2F6"]] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateHighlighted];
    self.textLabel.hidden = YES;
     NSString *text = self.telNum.text;
    [self.telNum setText:[text stringByAppendingString:[btn currentTitle]]];
    
    
}



- (IBAction)saomaClick:(id)sender {
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//        VC.saosao_Block = ^(NSString *name){
//            self.textLabel.hidden = YES;
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
        self.textLabel.hidden = YES;
        [weakSelf getDataPage:1 top:1 dengji:0 fenzhu:0 liusi:0 sectkey:resultStr biaoqian:@""];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cleanBtn:(id)sender {
    
    self.textLabel.hidden = NO;
   [self.telNum setText:@""];
    
}

- (IBAction)reduceBtn:(id)sender {
 //  NSString *str = [self removeLastOneChar:self.telNum.text];
  //  self.stringNumber = [NSMutableString stringWithFormat:@"%@", self.telNum.text];
         self.textLabel.hidden = YES;
       // [self.telNum setText:@""];
        NSString *text = self.telNum.text;
        if (text.length > 0) {
            text = [text substringToIndex:text.length -1];
            [self.telNum setText:text];
        }else{
            self.textLabel.hidden = NO;
        }
  
  
    
}



#pragma mark - 加载计次卡
- (void)loadUserMemberId:(NSString *)memberId{
     self.sureBtn.userInteractionEnabled = NO;
  //  [self.timesCountArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/ACharge?key=%@&id=%@",[SVUserManager shareInstance].access_token,memberId];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *timesCountArr = [SVSettlementTimesCountModel mj_objectArrayWithKeyValuesArray:dic[@"values"]];
        NSMutableArray *leftcountArrM = [NSMutableArray array];

        NSDate *currentDate = [NSDate date];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
        NSString *str = [formatter stringFromDate:date];
//        NSInteger aa;
//        NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
//        [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *dta = [[NSDate alloc] init];
//        NSDate *dtb = [[NSDate alloc] init];
//
//        dta = [dateformater dateFromString:aDate];
//        dtb = [dateformater dateFromString:bDate];
//        NSComparisonResult result = [dta compare:dtb];
        

        for (SVSettlementTimesCountModel *model in timesCountArr) {
           // NSInteger aa;
            NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
            [dateformater setDateFormat:@"yyyy-MM-dd"];
            NSDate *dta = [[NSDate alloc] init];
            NSDate *dtb = [[NSDate alloc] init];
            
            dta = [dateformater dateFromString:str];
             NSString *string = [model.validity_date substringToIndex:10];//（length为7）
            dtb = [dateformater dateFromString:string];
            NSComparisonResult result = [dta compare:dtb];
            if (model.sv_mcc_leftcount > 0&& (result!=NSOrderedDescending)) {
                [leftcountArrM addObject:model];
            }
        }
        
        if (kArrayIsEmpty(leftcountArrM)) {
            [SVTool TextButtonActionWithSing:@"无计次卡"];
        }else{
            
            SVDeductionDetailVC *VC = [[SVDeductionDetailVC alloc] init];
            VC.timesCountArr = leftcountArrM;
            VC.name = weakSelf.name;
            VC.level = weakSelf.level;
            VC.sv_mr_cardno = weakSelf.sv_mr_cardno;
            VC.storedValue = weakSelf.storedValue;
            VC.headimg = weakSelf.headimg;
            VC.sv_mw_sumpoint = weakSelf.sv_mw_sumpoint;
            VC.sv_mw_availablepoint = weakSelf.sv_mw_availablepoint;
            VC.sv_mr_birthday = weakSelf.sv_mr_birthday;
            VC.member_id = weakSelf.member_id;
            VC.discount = weakSelf.discount;
            VC.tel = weakSelf.telNum.text;
           [weakSelf.navigationController pushViewController:VC animated:YES];
            
            weakSelf.member_id = nil;
        }
        
     //   NSLog(@"dic6666 = %@",dic);
        
//<<<<<<< HEAD
//        self.sureBtn.userInteractionEnabled = YES;
//=======
         self.sureBtn.userInteractionEnabled = YES;
//>>>>>>> 8b769db... 启动页，销售备注换行，扣次，新增商品不能连续点击
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  self.sureBtn.userInteractionEnabled = YES;
        //隐藏提示框
        self.sureBtn.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}


- (IBAction)sureClick:(id)sender {
    if (kStringIsEmpty(self.telNum.text) || ![self.telNum.text containsString:@"请输入会员号/手机号"]) {
        if (kStringIsEmpty(self.member_id)) {
            self.sureBtn.userInteractionEnabled = NO;
            [self getDataPage:1 top:1 dengji:0 fenzhu:0 liusi:0 sectkey:self.telNum.text biaoqian:@""];
        }else{
            self.sureBtn.userInteractionEnabled = NO;
            [self loadUserMemberId:self.member_id];
        }
    }
   
   
    
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
                  //  NSDictionary *dict = listArr[0];
                    self.member_id = model.member_id;
                    self.telNum.text = model.sv_mr_mobile;
                    // self.member_id = member_id;
                    self.name = model.sv_mr_name;
                    self.level = model.sv_ml_name;
                    self.sv_mr_cardno = model.sv_mr_cardno;
                    self.storedValue = model.sv_mw_availableamount;
                    self.sv_mw_sumpoint = model.sv_mw_sumamount;
                    self.sv_mw_availablepoint = model.sv_mw_availablepoint;
                    self.discount = model.sv_ml_commondiscount;
                    self.sv_mr_birthday = model.sv_mr_birthday;
                    self.headimg = model.sv_mr_headimg;
                  
                    
                }
                
               [self loadUserMemberId:self.member_id];
                
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

@end

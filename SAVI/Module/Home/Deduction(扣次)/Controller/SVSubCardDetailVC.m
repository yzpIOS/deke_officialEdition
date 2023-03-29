//
//  SVSubCardDetailVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSubCardDetailVC.h"
#import "SVCardRechargeInfoModel.h"
#import "SVsubCardObjectDetailVC.h"
#import "SVModifySunCardVC.h"
@interface SVSubCardDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *serviceObject;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *Remarks;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (nonatomic,strong) NSMutableArray *arr;


@end

@implementation SVSubCardDetailVC
- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //正确创建方式，这样显示的图片就没有问题了
    [SVUserManager loadUserInfo];
     NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *MemberDic = sv_versionpowersDict[@"Member"];
    if (kDictIsEmpty(sv_versionpowersDict)) {
        [self setUpNavRightBtn];
       
    }else{
        NSString *MembershipSetMealCard_Update = [NSString stringWithFormat:@"%@",MemberDic[@"MembershipSetMealCard_Update"]];
        if (kStringIsEmpty(MembershipSetMealCard_Update)) {
            [self setUpNavRightBtn];
        }else{
            if ([MembershipSetMealCard_Update isEqualToString:@"1"]) {
                [self setUpNavRightBtn];
            }else{
               
            }
        }
    }
    
    
    self.navigationItem.title = @"次卡详情";
    [self loadData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.serviceView addGestureRecognizer:tap];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
}
- (void)setUpNavRightBtn{
    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ModifyOne"] style:UIBarButtonItemStylePlain target:self action:@selector(addVipbuttonResponseEvent)];
    self.navigationItem.rightBarButtonItem = rightButon;
}

- (void)tapClick{
    SVsubCardObjectDetailVC *vc = [[SVsubCardObjectDetailVC alloc] init];
    vc.dataArray = self.arr;
    vc.name = self.name.text;
    vc.price = self.price.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData{
    [SVUserManager loadUserInfo];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/GetSelectMemberCardSetmealInfo?key=%@&productid=%@",[SVUserManager shareInstance].access_token,self.model.product_id];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic666---%@",dic);
        NSDictionary *dict = dic[@"values"][0];
        NSString *result=dict[@"combination_new"];
        NSMutableArray *arr = [NSMutableArray array];
        if (!kStringIsEmpty(result)) {
            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"arr = %@",arr);
           // self.infoDataArray = arr;
        }
        self.arr = arr;
        NSString *sv_p_images = dict[@"sv_p_images2"];

        if (![SVTool isBlankString:sv_p_images]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images]]];
        } else {

           // self.icon.image = [UIImage imageNamed:@"foodimg"];
        }
        
       // self.iconImage.image = [UIImage imageNamed:@"%@",];
        NSString *nameStr;

        for (int i = 0 ; i < arr.count; i++) {
            if (i == 0) {
                NSDictionary *arrDic = arr[i];
                nameStr = [NSString stringWithFormat:@"%@,",arrDic[@"sv_p_name"]];
            }else{
                NSDictionary *arrDic = arr[i];
                nameStr = [nameStr stringByAppendingFormat:@"%@,",arrDic[@"sv_p_name"]];
            }
        }
        
        NSString *str3 = [nameStr substringToIndex:nameStr.length-1];//str3 = "this"
        self.serviceObject.text = str3;
        self.name.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_name"]];
        self.price.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]];
        NSString *startTime = [dict[@"sv_dis_startdate"] substringToIndex:10];
        NSString *endTime = [dict[@"sv_dis_enddate"] substringToIndex:10];
        self.time.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
        self.Remarks.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_remark"]];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)addVipbuttonResponseEvent{
    SVModifySunCardVC *vc = [[SVModifySunCardVC alloc] init];
    vc.arr = self.arr;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

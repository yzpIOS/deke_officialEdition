//
//  SVCardManagementVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/10/26.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVCardManagementVC.h"
#import "SVSecondaryCardVC.h"
#import "SVObtainedSecondaryCardVC.h"

static NSString *const ID = @"cell";
@interface SVCardManagementVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *titleData;


@property (strong, nonatomic) UIScrollView *topTitleView;

@property (strong, nonatomic) NSMutableArray *buttons;

@property (weak, nonatomic) UIButton *selectButons;

@property (weak, nonatomic)UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isInitial;

@property (weak, nonatomic)UIView *underLine;
@property (nonatomic,strong) SVSecondaryCardVC *secondaryCardVC;
@property (nonatomic,strong) SVObtainedSecondaryCardVC *obtainedSecondaryCardVC;



@end

@implementation SVCardManagementVC
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}
- (void)viewDidLoad {
   
  
//    self.selectIndex = 0;
//    self.menuViewStyle = WMMenuViewStyleLine;
//    //  self.menuItemWidth = ScreenW / 3 *2 / 6;
//    self.progressHeight = 1;
//    self.titleColorNormal = GlobalFontColor;
//    self.titleColorSelected = navigationBackgroundColor;
//   // self.automaticallyCalculatesItemWidths = YES;
//    self.menuItemWidth = 80;
//    //    self.titleSizeSelected = 17;
//    //    self.titleSizeNormal = 15;
//
//    //    self.iskaiguan = NO;
//    self.titleFontName = @"PingFangSC-Medium";
     [super viewDidLoad];
   // self.title = @"次卡管理";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    NSArray *arr = [NSArray array];
    if (self.selectCount == 2) { // 等于2的话是从会员详情的次卡跳转过来的
       arr = [[NSArray alloc]initWithObjects:@"次卡",@"过期次卡", nil];
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
       arr = [[NSArray alloc]initWithObjects:@"次卡",@"下架次卡", nil];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //初始化UISegmentedControl
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    segment.selectedSegmentIndex = 0;
    [self segmentClick:segment];
    
    //设置frame
    segment.frame = CGRectMake(0, 0, 150, 30);
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    // 创建两个控制器
    self.secondaryCardVC = [[SVSecondaryCardVC alloc] init];
  //  self.listVC.controllerNum = 1;
    self.secondaryCardVC.selectCount = self.selectCount;
    self.secondaryCardVC.member_id = self.member_id;
    [self addChildViewController:self.secondaryCardVC];
    
    self.secondaryCardVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH-TopHeight);
    [self.view addSubview:self.secondaryCardVC.view];
    
    self.obtainedSecondaryCardVC = [[SVObtainedSecondaryCardVC alloc] init];
    self.obtainedSecondaryCardVC.selectCount = self.selectCount;
    self.obtainedSecondaryCardVC.member_id = self.member_id;
    [self addChildViewController:self.obtainedSecondaryCardVC];
    
    
}

- (void)segmentClick:(UISegmentedControl *)segment{
    // 切换视图
    if (segment.selectedSegmentIndex == 0) {
        //  [self.lbxScanVC removeFromParentViewController];
        self.secondaryCardVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight -TopHeight);
        [self.view addSubview:self.secondaryCardVC.view];
        
        
    } else if (segment.selectedSegmentIndex == 1) {
        self.obtainedSecondaryCardVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight-TopHeight);
       // [self.lbxScanVC reStartDevice];
        [self.view addSubview:self.obtainedSecondaryCardVC.view];
        
    }
}

@end

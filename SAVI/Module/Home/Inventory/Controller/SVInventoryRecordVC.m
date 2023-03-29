//
//  SVInventoryRecordVC.m
//  SAVI
//
//  Created by houming Wang on 2019/6/3.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventoryRecordVC.h"
#import "SVdraftVC.h"
#import "SVInventoryCompletedVC.h"
#import "SVInventorySearchVC.h"
#import "CADetailNavigationController.h"
#import "XMNavigationController.h"
#import "SVInvemtoryRecordTimeVC.h"
@interface SVInventoryRecordVC ()
@property (nonatomic,strong) NSArray *titleData;
@end

@implementation SVInventoryRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectIndex = 1;
    self.menuViewStyle = WMMenuViewStyleLine;
    //  self.menuItemWidth = ScreenW / 3 *2 / 6;
    self.progressHeight = 1;
    self.titleColorNormal = GlobalFontColor;
    self.titleColorSelected = navigationBackgroundColor;
    
    //    self.titleSizeSelected = 17;
    //    self.titleSizeNormal = 15;
    
    //    self.iskaiguan = NO;
    self.titleFontName = @"PingFangSC-Medium";
    
    self.title = @"盘点记录";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
  //  self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"盘点记录" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
    //    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [informationCardBtn addTarget:self action:@selector(sousuoRightBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    
    [informationCardBtn setImage:[UIImage imageNamed:@"sousuo_black"] forState:UIControlStateNormal];
    
    [informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];

    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 15;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(shaixuanRightBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"screening_icon_black"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];

    self.navigationItem.rightBarButtonItems  = @[informationCardItem,fixedSpaceBarButtonItem,settingBtnItem];
    
    
    //   [self setUpbottomView_two];
    
    [super viewDidLoad];
}

- (void)shaixuanRightBtnCLick{
    
    SVInventorySearchVC *searchVc = [SVInventorySearchVC searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索盘点单号"];
    searchVc.hotSearchStyle = PYHotSearchStyleRankTag;
    searchVc.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    __weak typeof(SVInventorySearchVC *) wkSearch = searchVc;
    [searchVc setDidSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        wkSearch.searchText = searchText;
    }];
    searchVc.showKeyboardWhenReturnSearchResult = NO;
    
    XMNavigationController *nav = [[XMNavigationController alloc] initWithRootViewController:searchVc];
    // [nav.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self presentViewController:nav animated:NO completion:nil];
   
}

- (void)sousuoRightBtnCLick{
    SVInvemtoryRecordTimeVC *VC = [[SVInvemtoryRecordTimeVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
            case 0:{
                
                SVInventoryCompletedVC *vc = [SVInventoryCompletedVC new];
                
                return vc;
                
            }
            
            break;
        default:{
            
            SVdraftVC *vc = [SVdraftVC new];
            
            return vc;
            
        }
            break;
            
            
    }
    
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    
    return CGRectMake(0, 0, ScreenW, 60);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    //    if (self.iskaiguan == NO) {
    //        return CGRectMake(0, 64, HomePageScreen / 3 *2, ScreenH - 64);
    //    }
    //    else{
    //        return CGRectMake(0, 64, ScreenW /3 *2, ScreenH -64);
    //    }
    return CGRectMake(0, 60, ScreenW, ScreenH -TopHeight- 60-BottomHeight);
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}


#pragma mark - 暂存草稿
- (void)temporaryDraftClick{
    
}

#pragma mark - 完成盘点
- (void)physicalCountClick{
    
}

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"已完成", @"草稿"];
    }
    return _titleData;
}


@end

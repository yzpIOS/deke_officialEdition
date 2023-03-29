//
//  SVSpendingDetailVC.m
//  SAVI
//
//  Created by Sorgle on 2017/9/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSpendingDetailVC.h"
//子view控制器
#import "SVTodyPayVC.h"
#import "SVYesterdayPayVc.h"
#import "SVWeekPayVc.h"
#import "SVDatePayVC.h"

@interface SVSpendingDetailVC ()<UIScrollViewDelegate>

/**
 显示scrollView
 */
@property (nonatomic, strong) UIScrollView *contentScrollView;

/**
 按钮数组
 */
@property (nonatomic, strong) NSMutableArray *buttonArr;

/**
 选中按钮
 */
@property (nonatomic, strong) UIButton *selectedBtn;


@end

@implementation SVSpendingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"支出明细";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"支出明细";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.contentScrollView];
    
    //添加所有子控制器
    [self setUpChildViewController];
    
    [self addBtn];
    
    //设置scrollview
    [self setUpScrollView];
    
    self.hidesBottomBarWhenPushed = YES;
    
}
- (void)addBtn {
    
    NSArray *nameButton = @[@"今天",@"昨天",@"本周",@"其它"];
    
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width / 4;
    
    for (int i = 0; i < 4; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, 40);
        
        btn.tag = i;
        
        [btn setTitle:nameButton[i] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        //默认
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [btn setBackgroundColor:BackgroundColor];
        //高亮
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateSelected];
        
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加到titleArr数组
        [self.buttonArr addObject:btn];
        
        //默认选中第一个
        if (i == 0) {
            
            [self btnClick:btn];
        }
        
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn != self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        self.selectedBtn = btn;
    }
    self.selectedBtn.selected = YES;
    
    [self setSelectedBtn:self.selectedBtn];
    //滚动到对应的位置
    NSInteger index = btn.tag;
    //计算滚动的位置
    CGFloat offsetX = index * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    //给对应位置添加对应子控制器
    [self showViewController:index];
    
}
- (void)setUpChildViewController {
    
    SVTodyPayVC *firstVC = [[SVTodyPayVC alloc] init];
    
    //    firstVC.hidesBottomBarWhenPushed = YES;
    
    //    firstVC.view.backgroundColor = [UIColor blueColor];
    
    [self addChildViewController:firstVC];
    
    SVYesterdayPayVc *secondVC = [[SVYesterdayPayVc alloc] init];
    
    //    secondVC.view.backgroundColor = [UIColor orangeColor];
    
    [self addChildViewController:secondVC];
    
    SVWeekPayVc *thirdVC = [[SVWeekPayVc alloc] init];
    
    //    thirdVC.view.backgroundColor = [UIColor purpleColor];
    
    [self addChildViewController:thirdVC];
    
    SVDatePayVC *fourthVC = [[SVDatePayVC alloc] init];
    
    //    fourthVC.view.backgroundColor = [UIColor brownColor];
    
    [self addChildViewController:fourthVC];
    
}

- (void)setUpScrollView {
    
    NSUInteger count = self.childViewControllers.count;
    //设置内容scrollView
    self.contentScrollView.contentSize = CGSizeMake(count * [UIScreen mainScreen].bounds.size.width, 0);
    //开启分页
    self.contentScrollView.pagingEnabled = YES;
    //关掉弹簧效果
    self.contentScrollView.bounces = NO;
    //隐藏水平滚动条
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.delegate = self;
}

/**
 显示控制器的view
 
 @param index 第几个控制器
 */
- (void)showViewController:(NSInteger)index {
    
    CGFloat offsetX = index * [UIScreen mainScreen].bounds.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    //    if (vc.isViewLoaded) return;
    [self.contentScrollView addSubview:vc.view];
    
    vc.view.frame = CGRectMake(offsetX, 40, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64 );
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    //添加子控制器的view
    [self showViewController:index];
    //把对应的标题选中
    UIButton *selectedBtn = self.buttonArr[index];
    
    [self selectedBtn:selectedBtn];
}

- (void)selectedBtn:(UIButton *)btn {
    
    self.selectedBtn.selected = NO;
    //颜色恢复
    //    [self.selectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    btn.selected = YES;
    
    self.selectedBtn = btn;
}


#pragma mark - 懒加载
- (UIScrollView *)contentScrollView {
    
    if (!_contentScrollView) {
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    }
    return _contentScrollView;
}

- (NSMutableArray *)buttonArr {
    
    if (!_buttonArr) {
        
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}



@end

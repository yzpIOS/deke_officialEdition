//
//  SVselectShopListVC.m
//  SAVI
//
//  Created by houming Wang on 2019/7/31.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVselectShopListVC.h"
#import "SVSelectShopListCell.h"
#import "SVAddShopFlowLayout.h"
#import "SVDetaildraftFirmOfferCell.h"

static NSString *const collectionViewCellID = @"SVDetaildraftFirmOfferCell";
static NSString *const ID = @"SVSelectShopListCell";
@interface SVselectShopListVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UICollectionView *PrintingCollectionView;
//@property (nonatomic,strong) NSArray *sizeImageArray;
//@property (nonatomic,strong) NSArray *sizeArray;
@property (nonatomic,strong) UIImageView *icon_imageView;
@property (nonatomic,strong) UIButton *icon_button;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end

@implementation SVselectShopListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        
        self.titleNameLabel.text = @"品名/款号";
    }else{
        
        self.titleNameLabel.text = @"品名/条码";
    }
    
    self.title = @"商品列表";
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSelectShopListCell" bundle:nil] forCellReuseIdentifier:ID];
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
    self.PrintingCollectionView.delegate = self;
    self.PrintingCollectionView.dataSource = self;
  //  [self setUpUI];
}

//- (void)setUpUI{
//    UIView *topView = [[UIView alloc] init];
//    [self.view addSubview:topView];
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
//
//    self.tableView.frame = CGRectMake(0, 60, ScreenW, ScreenH - 60);
//    [self.view addSubview:self.tableView];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSelectShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVSelectShopListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.model = self.selectArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
    [self.PrintingCollectionView reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return self.selectArray.count;
 
    
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.selectNum == 3) {
        SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
        cell.model = self.selectArray[indexPath.row];
        cell.sureBtn.tag = indexPath.row;
        __weak typeof(self) weakSelf = self;
        cell.sureBtnClickBlock = ^(NSInteger selctCount, SVduoguigeModel * _Nonnull model_two) {
            if (selctCount+ 1 == weakSelf.selectArray.count) {
                [weakSelf.selectArray replaceObjectAtIndex:selctCount withObject:model_two];
               
                [weakSelf handlePan];
               
            }else{
                [weakSelf.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        };
        
        return cell;
//    }
//
//    else{
//        SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
//        cell.model_two = self.modelArr[indexPath.row];
//        cell.sureBtn.tag = indexPath.row;
//        __weak typeof(self) weakSelf = self;
//        cell.sureBtnClickBlock_two = ^(NSInteger selctCount, SVPandianDetailModel * _Nonnull model_two) {
//            if (selctCount+ 1 == self.modelArr.count) {
//                [weakSelf.modelArr replaceObjectAtIndex:selctCount withObject:model_two];
//
//                [weakSelf handlePan];
//
//            }else{
//                [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//
//            }
//
//        };
//
//        return cell;
//    }
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

//移除
- (void)handlePan{
    
    [self.tableView reloadData];
    [self.maskTheView removeFromSuperview];
    [self.PrintingCollectionView removeFromSuperview];
    [self.icon_button removeFromSuperview];
    
}



- (UICollectionView *)PrintingCollectionView
{
    if (_PrintingCollectionView == nil) {
        SVAddShopFlowLayout *layout = [[SVAddShopFlowLayout alloc] init];
        
        _PrintingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight,ScreenW, 540) collectionViewLayout:layout];
        // _PrintingCollectionView.automaticallyAdjustsScrollViewInsets = false;
        _PrintingCollectionView.backgroundColor = [UIColor clearColor];
        // _PrintingCollectionView.showsVerticalScrollIndicator = NO;
        _PrintingCollectionView.showsHorizontalScrollIndicator = NO;
        
    }
    
    
    
    return _PrintingCollectionView;
}

- (UIImageView *)icon_imageView
{
    if (_icon_imageView == nil) {
        _icon_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_PrintingCollectionView.frame) - 20, 40, 40)];
        _icon_imageView.image = [UIImage imageNamed:@"close"];
    }
    
    return _icon_imageView;
}

- (UIButton *)icon_button
{
    if (_icon_button == nil) {
        _icon_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon_button.frame = CGRectMake(ScreenW /2 - 20, CGRectGetMaxY(_PrintingCollectionView.frame) - 10, 40, 40);
        [_icon_button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_icon_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _icon_button;
}

- (void)btnClick{
    [self handlePan];
}

@end

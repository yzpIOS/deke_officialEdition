//
//  SVEjectPriceView.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/23.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVEjectPriceView.h"
#import "SVEjectViewCell.h"




@interface SVEjectPriceView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSDictionary *dict;
@end

static NSString *const ID = @"SVEjectViewCell";
@implementation SVEjectPriceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SVEjectViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置垂直间距
    layout.minimumLineSpacing = 0;
    //设置水平间距
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    if (!kArrayIsEmpty(self.dataArray)) {
        [self.collectionView reloadData];
        self.dict = self.dataArray[0];
    }
    
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.collectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {

    return CGSizeMake(ScreenW / 3, 100);

}

#pragma mark - 每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    
    SVEjectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[SVEjectViewCell alloc] init];
//    }
    cell.selectedBackgroundView.backgroundColor = navigationBackgroundColor;
    cell.dict = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isSelected) {
        cell.backgroundColor = clickButtonBackgroundColor;
    }
    self.dict = self.dataArray[indexPath.row];
}

//当你取消某项的选择的时候来触发
- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{


    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

}

- (IBAction)sureClick:(id)sender {
    
    if (self.dictBlock) {
        self.dictBlock(self.dict);
    }
}


@end

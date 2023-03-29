//
//  SVSettlementCollectionView.h
//  SAVI
//
//  Created by houming Wang on 2021/5/18.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSettlementCollectionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *tuichu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *PortfolioPaymentBtn;
@property (weak, nonatomic) IBOutlet UIView *PortfolioPaymentView;

@end

NS_ASSUME_NONNULL_END

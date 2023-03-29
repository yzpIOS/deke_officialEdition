//
//  SVTwoDoBusinessCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVTwoDoBusinessCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *FatherDataList;

@property (nonatomic,strong) NSMutableArray *chongzhiList;

@property (nonatomic,strong) NSMutableArray *shopArray;

@property (nonatomic,strong) NSMutableArray *catageryArray;


@property (nonatomic,assign) float order_receivable;
@property (nonatomic,assign) float memberOrder_receivable;
@property (nonatomic,strong) NSMutableArray *memberCountArray;

@property (nonatomic,strong) NSMutableArray *memberAnalysisArray;



@end

NS_ASSUME_NONNULL_END

//
//  SVOneStoreCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVOneStoreCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *FatherDataList;

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) NSDictionary *shopDict;

@property (nonatomic,strong) NSMutableArray *catageryArray;

@property (nonatomic,strong) NSDictionary *memberAnalysis;


@end

NS_ASSUME_NONNULL_END

//
//  SVCollectionFlowDetailVC.h
//  SAVI
//
//  Created by 杨忠平 on 2020/5/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SVCollectionFlowVC;
@interface SVCollectionFlowDetailVC : UIViewController
@property (nonatomic,strong) NSDictionary *dictData;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,weak) SVCollectionFlowVC *collectionFlowVC;
@end

NS_ASSUME_NONNULL_END

//
//  SVCollectionRefundVC.h
//  SAVI
//
//  Created by 杨忠平 on 2020/5/21.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CollectionRefundDelegate<NSObject>
- (void)CollectionRefundCellClick;
@end

@interface SVCollectionRefundVC : UIViewController
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic, copy)void(^dataBlock)();
@property (nonatomic, weak) id<CollectionRefundDelegate> delegate;
@property (nonatomic,strong)  NSString *payment;
@end

NS_ASSUME_NONNULL_END

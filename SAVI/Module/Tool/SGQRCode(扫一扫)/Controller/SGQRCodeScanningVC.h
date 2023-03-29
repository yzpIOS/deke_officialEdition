//
//  SGQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by apple on 17/3/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneViewControllerDelegate<NSObject>
- (void)OneViewControllerCellClick:(NSString *)name;
@end
@interface SGQRCodeScanningVC : UIViewController

//自己在第三方里添加的回调
@property (nonatomic,copy) void(^saosao_Block)(NSString *number);

@property (nonatomic, weak) id<OneViewControllerDelegate> delegate;

@property (nonatomic,assign) NSInteger selectNum; // 等于1就是盘点的
@end

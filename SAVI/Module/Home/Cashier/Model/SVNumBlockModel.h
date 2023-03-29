//
//  SVNumBlockModel.h
//  SAVI
//
//  Created by houming Wang on 2018/12/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVNumBlockModel : NSObject
//NSString *size,NSString *color,NSString *money,NSString *tf_count
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *money;// 售价
@property (nonatomic,strong) NSString *tf_count;
@property (nonatomic,strong) NSString *titleName;// 名称
@property (nonatomic,strong) NSString *memberPrice;// 会员售价
@property (nonatomic,strong) NSString *sv_p_images2;// 图片
@property (nonatomic,strong) NSString *product_id;
// 记录用户购买商品的个数 text的
@property (nonatomic,assign) NSInteger count;
//@property (nonatomic,assign) int secCount;
@end

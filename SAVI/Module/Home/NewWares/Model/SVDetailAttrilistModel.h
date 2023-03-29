//
//  SVDetailAttrilistModel.h
//  SAVI
//
//  Created by houming Wang on 2019/3/22.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVDetailAttrilistModel : NSObject
@property (nonatomic,strong) NSString *attri_group;
@property (nonatomic,strong) NSString *attri_name;
//@property (nonatomic,strong) NSString *spec_id;
@property (nonatomic,assign) NSInteger spec_id;
@property (nonatomic,assign) NSInteger attri_id;
@property (nonatomic,assign) NSInteger attri_user_id;
@property (nonatomic,assign) NSInteger is_custom;
@property (nonatomic,assign) NSInteger effective;
@property (nonatomic,strong) NSString *sv_remark;
@property (nonatomic,strong) NSString *images_info;
//@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,strong) NSString *attri_code;

@property (nonatomic,assign) NSInteger indexTag;

/**
 条码
 */
@property (nonatomic,strong) NSString *sv_p_artno;
@end

NS_ASSUME_NONNULL_END

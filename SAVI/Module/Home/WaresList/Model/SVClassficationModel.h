//
//  SVClassficationModel.h
//  SAVI
//
//  Created by houming Wang on 2021/1/22.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVClassficationModel : NSObject
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * sv_pc_name;
// 记录按钮是否被选中
@property (nonatomic, copy) NSString *isSelect;
@property (nonatomic,strong) NSString * productsubcategory_id;
@property (nonatomic,strong) NSString * sv_psc_name;
@end

NS_ASSUME_NONNULL_END

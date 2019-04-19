//
//  MetroPrimaryLine.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroPrimaryLine : NSObject
@property (nonatomic, copy)   NSString * color;
@property (nonatomic, copy)   NSString * alpha;
@property (nonatomic, assign) long       weight;
@property (nonatomic, strong) NSMutableArray * sections; //存放section对象

- (id)initColor:(NSString *)color andAlpha:(NSString *)alpha andWeight:(long)weight;
@end

NS_ASSUME_NONNULL_END

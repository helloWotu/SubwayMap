//
//  MetroPathNode.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroPathNode : NSObject
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (id)initType:(NSString *)type andX:(CGFloat)x andY:(CGFloat)y;
@end

NS_ASSUME_NONNULL_END

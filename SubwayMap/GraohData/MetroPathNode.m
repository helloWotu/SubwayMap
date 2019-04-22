//
//  MetroPathNode.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroPathNode.h"

@implementation MetroPathNode
- (id)initType:(NSString *)type andX:(CGFloat)x andY:(CGFloat)y {
    if (self = [super init]) {
        self.type = type;
        self.x = x;
        self.y = y;
    }
    return self;
}
@end

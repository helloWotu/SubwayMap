//
//  MetroDownLine.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroDownLine.h"

@implementation MetroDownLine
- (id)initColor:(NSString *)color andAlpha:(NSString *)alpha andWeight:(long)weight {
    if (self = [super init]) {
        self.color = color;
        self.alpha = alpha;
        self.weight = weight;
        self.sections = [NSMutableArray array];
    }
    return self;
}
@end

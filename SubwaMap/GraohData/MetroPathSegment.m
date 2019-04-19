//
//  MetroPathSegment.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroPathSegment.h"

@implementation MetroPathSegment
-(id) init
{
    if (self = [super init]) {
        _sDataArr = [NSMutableArray array];
        _sNodeArr = [NSMutableArray array];
    }
    return self;
}
@end

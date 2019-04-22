//
//  MetroLine.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroLine.h"

@interface MetroLine()<NSCopying, NSMutableCopying>


@end

@implementation MetroLine
- (id)initName:(NSString *)lineName andCode:(NSString *)lineCode andPrimaryLine:(MetroPrimaryLine *)primaryLine andUpLine:(MetroUpLine *)upLine andDownLine:(MetroDownLine *)downLine {
    if (self = [super init]) {
        self.lineName = lineName;
        self.lineCode = lineCode;
        self.primaryLine = primaryLine;
        self.upLine = upLine;
        self.downLine = downLine;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MetroLine * line = [[[self class] alloc] init];
    line.lineName = self.lineName;
    line.lineCode  = self.lineCode;
    return line;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    MetroLine * line = [[[self class] alloc] init];
    line.lineName = self.lineName;
    line.lineCode  = self.lineCode;
    return line;
}

@end

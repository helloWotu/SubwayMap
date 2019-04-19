//
//  MetroSection.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroSection.h"

@implementation MetroSection
- (id)initName:(NSString *)name andBeginCode:(NSString *)beginCode andEndCode:(NSString *)endCode andStartNode:(CGPoint)startNode andEndNode:(CGPoint)endNode andStartNodeType:(NSString *)startNodeType andEndNodeType:(NSString *)endNodeType {
    if (self = [super init]) {
        self.name = name;
        self.beginCode = beginCode;
        self.endCode = endCode;
        self.startNode = startNode;
        self.endNode = endNode;
        self.startNodeType = startNodeType;
        self.endNodeType = endNodeType;
        self.pathNodes = [NSMutableArray array];
    }
    return self;
}


- (id)initName:(NSString *)name andBeginCode:(NSString *)beginCode andEndCode:(NSString *)endCode sectionColor:(NSString *)sectionColor {
    if (self = [super init]) {
        self.name = name;
        self.beginCode = beginCode;
        self.endCode = endCode;
        self.pathNodes = [NSMutableArray array];
        self.sectionColor = sectionColor;
    }
    return self;
}
@end

//
//  MetroIcon.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroIcon.h"

@implementation MetroIcon
- (id)initWithType:(NSString *)type andLabel:(NSString *)label andColor:(NSString *)color andAlpha:(NSString *)alpha andFontSize:(NSString *)fontSize andWeight:(NSString *)weight andImageUrl:(NSString *)imageUrl andRotate:(CGFloat)rotate andIconX:(CGFloat)iconX andIconY:(CGFloat)iconY {
    if (self = [super init]) {
        self.type = type;
        self.label = label;
        self.color = color;
        self.alpha = alpha;
        self.fontSize = fontSize;
        self.weight = weight;
        self.imageUrl = imageUrl;
        self.rotate = rotate;
        self.iconX = iconX;
        self.iconY = iconY;
        self.pathNodes = [NSMutableArray array];
    }
    return self;
}
@end

//
//  MetroLabel.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroLabel.h"

@implementation MetroLabel
- (id)initWithText:(NSString *)text andColor:(NSString *)color andFontSize:(NSString *)fontSize andRotate:(CGFloat)rotate andTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right {
    if (self = [super init]) {
        self.text = text;
        self.color = color;
        self.fontSize = fontSize;
        self.rotate = rotate;
        self.top = top;
        self.bottom = bottom;
        self.left = left;
        self.right = right;
    }
    return self;
}
@end

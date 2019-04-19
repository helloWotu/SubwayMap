//
//  MetroMarkIcon.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroMarkIcon.h"

@implementation MetroMarkIcon
-(id) initWithIconColor:(UIColor *)iconColor
           andiconLabel:(NSString *)iconLabel
            andIconType:(NSString *)iconType
                   andX:(CGFloat)x
                   andY:(CGFloat)y
{
    if (self = [super init]) {
        self.iconColor = iconColor;
        self.iconLabel = iconLabel;
        self.iconType = iconType;
        self.iconx = x;
        self.icony = y;
    }
    return self;
}
@end

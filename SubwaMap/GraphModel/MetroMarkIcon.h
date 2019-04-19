//
//  MetroMarkIcon.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroMarkIcon : NSObject
@property (nonatomic, copy) UIColor  * iconColor;
@property (nonatomic, copy) NSString * iconLabel;
@property (nonatomic, copy) NSString * iconType;
@property CGFloat iconx;
@property CGFloat icony;


-(id) initWithIconColor:(UIColor *)iconColor
           andiconLabel:(NSString *)iconLabel
            andIconType:(NSString *)iconType
                   andX:(CGFloat)x
                   andY:(CGFloat)y;
@end

NS_ASSUME_NONNULL_END

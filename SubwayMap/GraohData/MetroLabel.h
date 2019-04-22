//
//  MetroLabel.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroLabel : NSObject
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * color;
@property (nonatomic, copy) NSString * fontSize;
@property (nonatomic, assign) CGFloat  rotate;
@property (nonatomic, assign) CGFloat  top;
@property (nonatomic, assign) CGFloat  bottom;
@property (nonatomic, assign) CGFloat  left;
@property (nonatomic, assign) CGFloat  right;


- (id)initWithText:(NSString *)text andColor:(NSString *)color andFontSize:(NSString *)fontSize andRotate:(CGFloat)rotate andTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;
@end

NS_ASSUME_NONNULL_END

//
//  MetroIcon.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroIcon : NSObject
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * color;
@property (nonatomic, copy) NSString * alpha;
@property (nonatomic, copy) NSString * fontSize;
@property (nonatomic, copy) NSString * weight;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) CGFloat  rotate;
@property (nonatomic, assign) CGFloat  iconX;
@property (nonatomic, assign) CGFloat  iconY;

@property (nonatomic, strong) NSMutableArray * pathNodes;

- (id)initWithType:(NSString *)type andLabel:(NSString *)label andColor:(NSString *)color andAlpha:(NSString *)alpha andFontSize:(NSString *)fontSize andWeight:(NSString *)weight andImageUrl:(NSString *)imageUrl andRotate:(CGFloat)rotate andIconX:(CGFloat)iconX andIconY:(CGFloat)iconY;
@end

NS_ASSUME_NONNULL_END

//
//  MetroSection.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MetroSection : NSObject

@property (nonatomic, copy) NSString * beginCode;
@property (nonatomic, copy) NSString * endCode;
@property (nonatomic, copy) NSString * name;

@property (nonatomic, assign) CGPoint startNode;
@property (nonatomic, assign) CGPoint endNode;

@property (nonatomic, copy) NSString * startNodeType;
@property (nonatomic, copy) NSString * endNodeType;

@property (nonatomic, strong) NSMutableArray * pathNodes;//放pathNode对象

@property (nonatomic, copy) NSString * sectionColor;//拥挤度

- (id)initName:(NSString *)name andBeginCode:(NSString *)beginCode andEndCode:(NSString *)endCode andStartNode:(CGPoint)startNode andEndNode:(CGPoint)endNode andStartNodeType:(NSString *)startNodeType andEndNodeType:(NSString *)endNodeType;
- (id)initName:(NSString *)name andBeginCode:(NSString *)beginCode andEndCode:(NSString *)endCode sectionColor:(NSString *)sectionColor;

@end

NS_ASSUME_NONNULL_END

//
//  MetroView.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetroDrawer.h"
#import "MetroGraph.h"
@class MetroStation;
@class MetroPath;

NS_ASSUME_NONNULL_BEGIN



//1 创建协议
@protocol MetroViewDelegate <NSObject>
//2 定义协议方法
- (void)selectStation:(MetroStation *)station withType:(NSInteger)type;

@end


@interface MetroView : UIView

//3 声明委托变量
@property (strong,nonatomic)id <MetroViewDelegate> viewDelegate;
@property (strong,nonatomic) MetroGraph   * graph;
@property (strong,nonatomic) MetroDrawer  * drawer;
@property (assign,nonatomic) int  scrollViewZoomScale;
@property (strong,nonatomic) MetroStation * startNode;
@property (strong,nonatomic) MetroStation * endNode;
@property (strong,nonatomic) NSArray      * curPaths;

//绘制地铁线路图
- (void)paintGraph:(CGContextRef)ctx;
//绘制起点和终点
- (void)paintStartAndEndNodes:(CGContextRef) ctx;
//渲染指定换乘路径
- (void)paintTransferPath:(NSArray *)paths;

@end

NS_ASSUME_NONNULL_END

//
//  MetroView.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroView.h"
#import "MetroDataContainer.h"
#import "MetroMarkIcon.h"
#import "MetroStation.h"
#import "MetroLine.h"
#import "MetroPath.h"
#import "GraphicUtil.h"
//#import "ViaStation.h"

@implementation MetroView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _graph = [[MetroGraph alloc] init];
        _graph.icons = [MetroDataContainer shareInstance].icons;
        _graph.lines = [MetroDataContainer shareInstance].lines;
        _graph.stations = [MetroDataContainer shareInstance].stations;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Only override drawRect:调用UIView类中的setNeedsDisplay方法，则程序会自动调用drawRect方法进行重绘
//重写drawRect方法后，内存暴增原因
//TODO:这里会导致内存暴涨，后续得想办法优化
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextClearRect(ctx, self.bounds);
    //绘制地铁线路图
    [self paintGraph:ctx];
    
    //绘制起点和终点
    [self paintStartAndEndNodes:ctx];
    
    if (_curPaths) {
        [self paintCurrentPaths:ctx withCurrentPaths:_curPaths];
        [self paintStartAndEndNodes:ctx];
    }
    
}



#pragma mark - 绘制地铁线路图
- (void)paintGraph:(CGContextRef)ctx {
    
#pragma mark - 画站点间连线
    for (MetroLine * line in _graph.lines) {
        
        NSMutableArray * parimaryLineArr = [NSMutableArray array];
        NSArray * primarySections = line.primaryLine.sections;
        for (int i = 0; i < primarySections.count; i++) {
            MetroSection * section = primarySections[i];
            NSArray * pathNodes = section.pathNodes;
            for (int a = 0; a < pathNodes.count - 1; a++) {
                MetroPathNode * node = pathNodes[a];
                if(node != nil){
                    [parimaryLineArr addObject:node];
                }
                MetroPathNode * anchorNode = pathNodes[a];
                MetroPathNode * endNode = pathNodes[a+1];
                if ([anchorNode.type isEqualToString:@"anchor"] && [endNode.type isEqualToString:@"anchor"]) {
                    [_drawer paintLink:ctx fromStartNode:CGPointMake(anchorNode.x, anchorNode.y) toEndNode:CGPointMake(endNode.x, endNode.y) inLine:line.primaryLine];
                }else if([anchorNode.type isEqualToString:@"control"]){
                    MetroPathNode * startNode = pathNodes[a-1];
                    [_drawer paintArcLinkFromStartNode:startNode toEndNode:endNode andControlNode:anchorNode inLine:line.primaryLine];
                }
                
            }
        }
        
    }
    
    
    
#pragma mark - 画站点
    for (MetroStation * station in _graph.stations) {
        [_drawer paintStation:ctx andStation:station isPath:NO];
        [_drawer paintTransferArrow:ctx andStation:station];
    }
    
    
#pragma mark - 画站点名称
    for (MetroStation * station in _graph.stations) {
        [_drawer paintStationLabel:ctx andStation:station inView:self isPath:NO];
    }
    
    
#pragma mark - 画换乘站圆角矩形和图片
    for (UIImageView * imageView in self.subviews) {
        [imageView removeFromSuperview];
    }
    
    for (MetroIcon * icon in _graph.icons) {
        [_drawer paintIcons:ctx andIcon:icon inView:self];
    }
    
}

#pragma mark - 渲染指定换乘路径
- (void) paintTransferPath:(NSArray *)paths {
    _curPaths = [NSArray array];
    _curPaths = paths;
    [self setNeedsDisplay];
}

#pragma mark - 绘制起点和终点
- (void)paintStartAndEndNodes:(CGContextRef)ctx {
    CGFloat roate = (CANVAS_WIDTH * MIM_ZOOM_SCALE / scale_zoom) / self.frame.size.width;
    if (_startNode != nil) {
        UIImage * image = [UIImage imageNamed:@"起点"];
        float sx = _startNode.stationX - image.size.width / 16 * roate;
        float sy = _startNode.stationY;
        [GraphicUtil drawImage:ctx theImage:image boundsHeight:self.bounds.size.height forLeftTop:CGPointMake(sx, sy) forScale:1.0 forRotate:0 roateWidth:self.frame.size.width];
    }
    
    if (_endNode != nil) {
        UIImage * image = [UIImage imageNamed:@"终点"];
        float sx = _endNode.stationX - image.size.width / 16 * roate;
        float sy = _endNode.stationY;
        [GraphicUtil drawImage:ctx theImage:image boundsHeight:self.bounds.size.height forLeftTop:CGPointMake(sx, sy) forScale:1.0 forRotate:0 roateWidth:self.frame.size.width];
    }
}

#pragma mark - 点击站点，回传点击的站点
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    MetroStation * station = [_graph getNodeAt:point];
    if (station != nil && !station.disabled) {
        NSString *toast = [NSString stringWithFormat:@"点击了：%@",station.name];
        [[UIApplication sharedApplication].keyWindow makeToast:toast];
        [self.viewDelegate selectStation:station withType:1];
    }else if (station.disabled){
        [[UIApplication sharedApplication].keyWindow makeToast:@"站点未开通"];
        [self.viewDelegate selectStation:station withType:0];
    }else {
        [[UIApplication sharedApplication].keyWindow makeToast:@"没有点中站点"];
        MetroStation * unStation = [MetroStation new];
        unStation.stationX = point.x;
        unStation.stationY = point.y;
        [self.viewDelegate selectStation:unStation withType:2];
    }
}


#pragma mark - 绘制乘车路径
- (void)paintCurrentPaths:(CGContextRef)ctx withCurrentPaths:(NSArray *)paths{
    //绘制白色遮罩层
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor);
    CGContextFillRect(ctx, self.bounds);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    for (MetroLine * line in paths[0]) {
        NSMutableArray * parimaryLineArr = [NSMutableArray array];
        NSArray * primarySections = line.primaryLine.sections;
        for (int i = 0; i < primarySections.count; i++) {
            MetroSection * section = primarySections[i];
            NSArray * pathNodes = section.pathNodes;
            
            for (int a = 0; a < pathNodes.count - 1; a++) {
                MetroPathNode * node = pathNodes[a];
                [parimaryLineArr addObject:node];
                
                MetroPathNode * anchorNode = pathNodes[a];
                MetroPathNode * endNode = pathNodes[a+1];
                if ([anchorNode.type isEqualToString:@"anchor"] && [endNode.type isEqualToString:@"anchor"]) {
                    [_drawer paintLink:ctx fromStartNode:CGPointMake(anchorNode.x, anchorNode.y) toEndNode:CGPointMake(endNode.x, endNode.y) inLine:line.primaryLine];
                }else if([anchorNode.type isEqualToString:@"control"]){
                    MetroPathNode * startNode = pathNodes[a-1];
                    [_drawer paintArcLinkFromStartNode:startNode toEndNode:endNode andControlNode:anchorNode inLine:line.primaryLine];
                }
            }
        }
    }
    
    for (MetroStation * station in paths[1]) {
        [_drawer paintStation:ctx andStation:station isPath:YES];
        [_drawer paintTransferArrow:ctx andStation:station];
        [_drawer paintStationLabel:ctx andStation:station inView:self isPath:YES];
    }
    
}

@end

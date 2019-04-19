//
//  ViewController.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/14.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "ViewController.h"
#import "MetroView.h"

#define MiddleViewHeight 140
#define BottomViewHeight 131

@interface ViewController ()<UIScrollViewDelegate,MetroViewDelegate>

@property (nonatomic ,strong) UIScrollView * scrollView;
@property (nonatomic, strong) MetroView * metroView;
@property (nonatomic,assign)  BOOL  isEableDrawPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMetroView) name:@"LoadDataOK" object:nil];
//    self.isEableDrawPath = YES;
}




//路网图
- (void)initMetroView {
    
    //_scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.bounces = NO;
    _scrollView.minimumZoomScale = MIM_ZOOM_SCALE/scale_zoom;
    _scrollView.maximumZoomScale = MAX_ZOOM_SCALE * scale_zoom;
    _scrollView.contentSize = CGSizeMake(CANVAS_WIDTH * scale_zoom, CANVAS_HEIGHT * scale_zoom);
    [self.view addSubview:_scrollView];
    
    //_metroView
    _metroView = [[MetroView alloc] initWithFrame:CGRectMake(0, 0, CANVAS_WIDTH * scale_zoom, CANVAS_HEIGHT * scale_zoom)];
    _metroView.viewDelegate = self;
    _metroView.drawer = [[MetroDrawer alloc] init];
    [_scrollView addSubview:_metroView];
    
}

#pragma mark - MetroViewDelegate
#pragma mark - 点击某个站点触发
- (void)selectStation:(MetroStation *)station withType:(NSInteger)type {
    if (self.isEableDrawPath) {
        if (type == 1) {

            //路线图点击点滚动到中心位置
            [UIView animateWithDuration:0.2f animations:^{
                self.scrollView.zoomScale = 0.6/scale_zoom;
                float scale = self.scrollView.zoomScale;
                float x = station.stationX * scale - self.scrollView.bounds.size.width / 2;
                float y = station.stationY * scale - (self.scrollView.bounds.size.height - BottomViewHeight - 0) / 2;
                [self.scrollView setContentOffset:CGPointMake(x, y)];
            } completion:^(BOOL finished) {
                
            }];
            
        }else if(type == 0){
           
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"站点未开通" message:@"该站点未开通，请重新选择" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击确认");
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else if (type == 2){
            NSLog(@"%f",self.scrollView.zoomScale);
            [self.view makeToast:@"未点击到站点,请选择车站"];
            //路线图点击点滚动到中心位置
            [UIView animateWithDuration:0.2f animations:^{
                self.scrollView.zoomScale = 0.6/scale_zoom;
                float scale = self.scrollView.zoomScale;
                float x = station.stationX * scale - self.scrollView.bounds.size.width / 2;
                float y = station.stationY * scale - (self.scrollView.bounds.size.height - BottomViewHeight - 0) / 2;
                [self.scrollView setContentOffset:CGPointMake(x, y)];
            } completion:^(BOOL finished) {
                
            }];
          
        }
        
    }
}

@end

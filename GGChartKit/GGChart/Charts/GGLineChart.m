//
//  GGLineChart.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLineChart.h"
#import "LineCanvas.h"
#import "GridBackCanvas.h"
#import "QueryCanvas.h"

@interface GGLineChart ()

/**
 * 折线渲染层
 */
@property (nonatomic, strong) LineCanvas * lineCanvas;

/**
 * 折线背景层
 */
@property (nonatomic, strong) GridBackCanvas * gridCanvas;

/**
 * 查价图层
 */
@property (nonatomic, strong) QueryCanvas * queryCanvas;

@end

@implementation GGLineChart

/**
 * 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _gridCanvas = [[GridBackCanvas alloc] init];
        _gridCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_gridCanvas];
        
        _lineCanvas = [[LineCanvas alloc] init];
        _lineCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_lineCanvas];
        
        _queryCanvas = [[QueryCanvas alloc] init];
        _queryCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_queryCanvas];
    }
    
    return self;
}

/**
 * 设置图层接口
 */
- (void)setLineDataSet:(LineDataSet *)lineDataSet
{
    _lineDataSet = lineDataSet;
    
    _lineCanvas.lineDrawConfig = (id <LineCanvasAbstract>)lineDataSet;
    _gridCanvas.gridDrawConfig = (id <GridAbstract>)lineDataSet.gridConfig;
    _queryCanvas.queryDrawConfig = (id <QueryAbstract>)lineDataSet.queryConfig;
}

/**
 * 设置各个视图的大小
 */
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _lineCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    _gridCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    _queryCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

/**
 * 渲染折线图
 */
- (void)drawLineChart
{
    [_lineDataSet updateChartConfigs:CGRectMake(0, 0, self.gg_width, self.gg_height)];
    
    [_lineCanvas drawChart];
    [_gridCanvas drawChart];
}

/**
 * 启动动画
 */
- (void)startAnimation:(NSTimeInterval)duration
{
    [_lineCanvas startAnimation:duration];
}

#pragma mark - 手势相应

/**
 * 即将响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateBegan:(CGPoint)point
{
    [_queryCanvas updateWithPoint:point];
    _queryCanvas.hidden = NO;
}

/**
 * 即将结束响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateEnded:(CGPoint)point
{
    _queryCanvas.hidden = YES;
    [_queryCanvas updateWithPoint:point];
}

/**
 * 响应长按手势点变换
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateChanged:(CGPoint)point
{
    [_queryCanvas updateWithPoint:point];
}

@end

//
//  MBXLineGraphDataSource.m
//  Pods
//
//  Created by Tamara Bernad on 31/03/15.
//
//

#import "MBXLineGraphDataSource.h"
#import "MBXGraphDataUtils.h"
#import "MBXNumberUtils.h"
#import "MBXAxisVM.h"
#import "MBXChartVM.h"

@interface MBXLineGraphDataSource()
@property (nonatomic, weak) NSArray *xValues;
@property (nonatomic, weak) NSArray *yValues;
@property (nonatomic, strong) NSArray *lineGraphVMs;
@property (nonatomic, strong) MBXGraphDataUtils *dataUtils;
@property (nonatomic, strong) MBXChartVM *chartVM;
@property (nonatomic) MBXValueRange yTotalRange;
@property (nonatomic) MBXValueRange xTotalRange;
@property (nonatomic, strong) NSArray *graphsValues;
@end
@implementation MBXLineGraphDataSource
- (MBXChartVM *)chartVM{
    if(!_chartVM){
        _chartVM = [MBXChartVM new];
    }
    return _chartVM;
}
- (MBXGraphDataUtils *)dataUtils{
    if(!_dataUtils){
        _dataUtils = [MBXGraphDataUtils new];
    }
    return _dataUtils;
}
- (void)graphView:(MBXLineGraphView *)graphView configureGraphVM:(MBXLineGraphVM *)graphVM{
    
}
- (NSInteger)graphViewNumberOfGraphs:(MBXLineGraphView *)graphView{
    return self.graphsValues.count;
}
- (void)reload{
    NSInteger index = 0;
    NSMutableArray *graphs = [NSMutableArray new];
    for (NSArray *values in self.graphsValues) {
        NSArray *xValues = [values valueForKeyPath:@"self.CGPointValue.x"];
        NSArray *yValues = [values valueForKeyPath:@"self.CGPointValue.y"];
        NSArray *yProportionValues = [self.dataUtils calculateProportionValues:yValues WithRange:self.yTotalRange];
        NSArray *xProportionValues = [self.dataUtils calculateProportionValues:xValues WithRange:self.xTotalRange];
        MBXLineGraphVM *lineGraphVM =[MBXLineGraphVM new];
        lineGraphVM.uid = [NSString stringWithFormat:@"%lu",index];
        lineGraphVM.proportionPoints = [self.dataUtils createProportionPointsWithXProportionValues:xProportionValues AndYProportionValues:yProportionValues];
        
        [graphs addObject:lineGraphVM];
    }
    self.chartVM.graphs = [NSArray arrayWithArray:graphs];
    
    self.chartVM.yAxisVM = [self yAxisVM];
    self.chartVM.xAxisVM = [self xAxisVM];
}
- (void)setMultipleGraphValues:(NSArray *)values{
    self.graphsValues = values;
    NSArray *completeXValues = [values valueForKeyPath:@"@unionOfArrays.self"];
    completeXValues = [completeXValues valueForKeyPath:@"self.CGPointValue.x"];
    self.xTotalRange = [self.dataUtils rangeWithTicksForValues:completeXValues];
    
    NSArray *completeYValues = [values valueForKeyPath:@"@unionOfArrays.self"];
    completeYValues = [completeYValues valueForKeyPath:@"self.CGPointValue.y"];
    self.yTotalRange = [self.dataUtils rangeWithTicksForValues:completeYValues];
}

- (void)setXValues:(NSArray *)values{
    _xValues = values;
    [self reload];
}
- (void)setYValues:(NSArray *)values{
    _yValues = values;
    [self reload];
}

- (MBXAxisVM *)yAxisVM{
    MBXValueRange yRange = [self.dataUtils rangeWithTicksForValues:self.yValues];

    NSArray *yAxisIntervals =[self.dataUtils calculateIntervalsInRange:yRange];
    MBXAxisVM *yAxisVM = [MBXAxisVM new];
    yAxisVM.proportionValues = [self.dataUtils calculateProportionValues:yAxisIntervals WithRange:yRange];
    //TODO: appearance need to happen in a delegate
    yAxisVM.labelValues = [self.dataUtils formatIntervalStringsWithIntervals:yAxisIntervals];
//    self.graphVisualModel.yAxisVM = yAxisVM;
    return yAxisVM;
}
- (MBXAxisVM *)xAxisVM{
    MBXAxisVM *xAxisVM = [MBXAxisVM new];
    MBXValueRange xRange = [self.dataUtils rangeWithTicksForValues:self.xValues];
    NSArray *xAxisIntervals =[self.dataUtils calculateIntervalsInRange:xRange];
    xAxisVM.proportionValues = [self.dataUtils calculateProportionValues:xAxisIntervals WithRange:xRange];
    //TODO: appearance need to happen in a delegate
    xAxisVM.labelValues = [self.dataUtils formatIntervalStringsWithIntervals:xAxisIntervals];
    return xAxisVM;
//    self.graphVisualModel.xAxisVM = xAxisVM;
}
@end

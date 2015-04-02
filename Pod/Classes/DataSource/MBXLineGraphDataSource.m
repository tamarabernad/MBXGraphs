/*
 
 Copyright (c) 2015 tamarabernad <tamara.bernad@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "MBXLineGraphDataSource.h"
#import "MBXGraphDataUtils.h"
#import "MBXNumberUtils.h"
#import "MBXAxisVM.h"
#import "MBXChartVM.h"

@interface MBXLineGraphDataSource()
//@property (nonatomic, weak) NSArray *xValues;
//@property (nonatomic, weak) NSArray *yValues;
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
- (NSInteger)graphViewNumberOfGraphs:(MBXLineGraphView *)graphView{
    return self.graphsValues.count;
}
- (NSArray *)graphVMs{
    return self.chartVM.graphs;
}
- (MBXAxisVM *)yAxisVM{
    return self.chartVM.yAxisVM;
}
- (MBXAxisVM *)xAxisVM{
    return self.chartVM.xAxisVM;
}
- (void)reload{
    NSInteger index = 0;
    NSMutableArray *graphs = [NSMutableArray new];
    for (NSArray *values in self.graphsValues) {
        NSArray *xValues = [self valuesForGraphValues:values inKey:@"x"];
        NSArray *yValues = [self valuesForGraphValues:values inKey:@"y"];
        NSArray *yProportionValues = [self.dataUtils calculateProportionValues:yValues WithRange:self.yTotalRange];
        NSArray *xProportionValues = [self.dataUtils calculateProportionValues:xValues WithRange:self.xTotalRange];
        MBXLineGraphVM *lineGraphVM =[MBXLineGraphVM new];
        lineGraphVM.uid = [NSString stringWithFormat:@"%lu",index];
        lineGraphVM.proportionPoints = [self.dataUtils createProportionPointsWithXProportionValues:xProportionValues AndYProportionValues:yProportionValues];
        
        [graphs addObject:lineGraphVM];
    }
    self.chartVM.graphs = [NSArray arrayWithArray:graphs];
    
    self.chartVM.yAxisVM = [self createYAxisVM];
    self.chartVM.xAxisVM = [self createXAxisVM];
}
- (void)setMultipleGraphValues:(NSArray *)values{
    self.graphsValues = values;
    [self calculateRanges];
    [self reload];
}
- (void)setGraphValues:(NSArray *)values{
    self.graphsValues = [NSArray arrayWithObject:values];
   [self calculateRanges];
   [self reload];
}
- (void)calculateRanges{
    //TODO: only y values are right now spreaded out nicely, x values are used as they come (thinking they would be something like years: 2005, 2006, etc) should they in some cases be as the y values, nicely speraded out with nice whole values?
    self.xTotalRange = [self.dataUtils rangeForValues:[self allXValues]];
    self.yTotalRange = [self.dataUtils rangeWithTicksForValues:[self allYValues]];
}
- (MBXAxisVM *)createYAxisVM{
    MBXValueRange yRange = [self.dataUtils rangeWithTicksForValues:[self allYValues]];

    NSArray *yAxisIntervals =[self.dataUtils calculateIntervalsInRange:yRange];
    MBXAxisVM *yAxisVM = [MBXAxisVM new];
    yAxisVM.proportionValues = [self.dataUtils calculateProportionValues:yAxisIntervals WithRange:yRange];
    //TODO: appearance need to happen in a delegate
    yAxisVM.labelValues = [self.dataUtils formatIntervalStringsWithIntervals:yAxisIntervals];
    return yAxisVM;
}
- (MBXAxisVM *)createXAxisVM{
    MBXAxisVM *xAxisVM = [MBXAxisVM new];
    MBXValueRange xRange = [self.dataUtils rangeWithTicksForValues:[self allXValues]];
    NSArray *xAxisIntervals =[self.dataUtils calculateIntervalsInRange:xRange];
    xAxisVM.proportionValues = [self.dataUtils calculateProportionValues:xAxisIntervals WithRange:xRange];
    //TODO: appearance need to happen in a delegate
    xAxisVM.labelValues = [self.dataUtils formatIntervalStringsWithIntervals:xAxisIntervals];
    return xAxisVM;
}
- (NSArray *)allXValues
{
    return [self allValuesForKey:@"x"];
}
- (NSArray *)allYValues{
    return [self allValuesForKey:@"y"];
}
- (NSArray *)allValuesForKey:(NSString *)key{
    //TODO convert to KVO, was getting null values...
    NSMutableArray *valuesForKey = [NSMutableArray new];
    for (NSArray *graphValues in self.graphsValues) {
        [valuesForKey addObjectsFromArray:[self valuesForGraphValues:graphValues inKey:key]];
    }
    return [NSArray arrayWithArray:valuesForKey];

//    NSArray *completeXValues = [self.graphsValues valueForKeyPath:@"@unionOfArrays.self"];
//    completeXValues = [completeXValues valueForKeyPath:key];
//    return completeXValues;
}
- (NSArray *)valuesForGraphValues:(NSArray *)graphValues inKey:(NSString *)key{
    NSMutableArray *valuesForKey = [NSMutableArray new];
    for (NSDictionary *value in graphValues){
        [valuesForKey addObject:[value objectForKey:key]];
    }
    return [NSArray arrayWithArray:valuesForKey];
}
@end

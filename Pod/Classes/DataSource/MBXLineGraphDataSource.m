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

@interface MBXLineGraphDataSource()
@property (nonatomic, strong) NSArray *lineGraphVMs;
@property (nonatomic, strong) MBXGraphDataUtils *dataUtils;
@property (nonatomic, strong) MBXChartVM *chartVM;
@property (nonatomic) MBXValueRange yTotalRange;
@property (nonatomic) MBXValueRange xTotalRange;
@property (nonatomic, strong) NSArray *graphsValues;
@end
@implementation MBXLineGraphDataSource

////////////////////////////////////
#pragma mark - Public
////////////////////////////////////
- (instancetype)init{
    if(self = [super init]){
        _xAxisCalc = MBXLineGraphDataSourceAxisCalcValueTickmark | MBXLineGraphDataSourceAxisCalcEquallyDistribute;
        _yAxisCalc = MBXLineGraphDataSourceAxisCalcAutoTickmark | MBXLineGraphDataSourceAxisCalcValueDistribute;
    }
    return self;
}
- (void)setXAxisCalc:(MBXLineGraphDataSourceAxisCalc)xAxisCalc{
    _xAxisCalc = xAxisCalc;
}
- (void)setYAxisCalc:(MBXLineGraphDataSourceAxisCalc)yAxisCalc{
    _yAxisCalc = yAxisCalc;
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
    
    NSArray *allXValuesNoDuplicates = [self allXValuesNoDuplicates];
    NSArray *allYValuesNoDuplicates = [self allYValuesNoDuplicates];
    
    for (NSArray *values in self.graphsValues) {
        NSArray *xValues = [self valuesForGraphValues:values inKey:@"x"];
        NSArray *yValues = [self valuesForGraphValues:values inKey:@"y"];
        NSArray *yProportionValues = [self hasEqualDistribution:self.yAxisCalc] ?
        [self.dataUtils calculateProportionValuesEquallyDistributed:yValues WithAllValues:allYValuesNoDuplicates] :
        [self.dataUtils calculateProportionValues:yValues WithRange:self.yTotalRange];
        
        NSArray *xProportionValues = [self hasEqualDistribution:self.xAxisCalc] ?
        [self.dataUtils calculateProportionValuesEquallyDistributed:xValues WithAllValues:allXValuesNoDuplicates] :
        [self.dataUtils calculateProportionValues:xValues WithRange:self.xTotalRange];
        
        MBXGraphVM *lineGraphVM =[MBXGraphVM new];
        lineGraphVM.uid = [NSString stringWithFormat:@"%lu",(long)index];
        lineGraphVM.proportionPoints = [self.dataUtils createProportionPointsWithXProportionValues:xProportionValues AndYProportionValues:yProportionValues];
        
        [graphs addObject:lineGraphVM];
        index++;
    }
    self.chartVM.graphs = [NSArray arrayWithArray:graphs];
    
    NSArray *xAxisValues = allXValuesNoDuplicates;
    NSArray *yAxisValues = allYValuesNoDuplicates;
    
    self.chartVM.yAxisVM = [self hasAutoTickmark:self.yAxisCalc] ?
    [self createAxisVMAutoTicksWithValues:yAxisValues WithCalc:self.yAxisCalc] :
    [self createAxisVMValueTicksWithValues:yAxisValues WithCalc:self.yAxisCalc];
    
    self.chartVM.xAxisVM = [self hasAutoTickmark:self.xAxisCalc] ?
    [self createAxisVMAutoTicksWithValues:xAxisValues WithCalc:self.xAxisCalc] :
    [self createAxisVMValueTicksWithValues:xAxisValues WithCalc:self.xAxisCalc];
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

////////////////////////////////////
#pragma mark - Lazy getters
////////////////////////////////////
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

////////////////////////////////////
#pragma mark - Helpers
////////////////////////////////////
- (void)calculateRanges{
    self.xTotalRange = [self hasAutoTickmark:self.xAxisCalc] ? [self.dataUtils rangeWithTicksForValues:[self allXValues]]: [self.dataUtils rangeForValues:[self allXValues]];
    self.yTotalRange = [self hasAutoTickmark:self.yAxisCalc] ? [self.dataUtils rangeWithTicksForValues:[self allYValues]] : [self.dataUtils rangeForValues:[self allYValues]];
}
- (MBXAxisVM *)createAxisVMAutoTicksWithValues:(NSArray *)values WithCalc:(MBXLineGraphDataSourceAxisCalc)calc{
    MBXAxisVM *axisVM = [MBXAxisVM new];
    MBXValueRange xRange = [self.dataUtils rangeWithTicksForValues:values];
    NSArray *xAxisIntervals = [self.dataUtils calculateIntervalsInRange:xRange];
    axisVM.proportionValues = [self hasEqualDistribution:calc] ? [self.dataUtils calculateProportionValuesEquallyDistributed:values] : [self.dataUtils calculateProportionValues:xAxisIntervals WithRange:xRange];
    axisVM.values = xAxisIntervals;
    return axisVM;
}
- (MBXAxisVM *)createAxisVMValueTicksWithValues:(NSArray *)values WithCalc:(MBXLineGraphDataSourceAxisCalc)calc{
    MBXAxisVM *axisVM = [MBXAxisVM new];
    MBXValueRange xRange = [self.dataUtils rangeForValues:values];
    axisVM.proportionValues = [self hasEqualDistribution:calc] ?  [self.dataUtils calculateProportionValuesEquallyDistributed:values] : [self.dataUtils calculateProportionValues:values WithRange:xRange];
    axisVM.values = values;
    return axisVM;
}
- (NSArray *)allXValuesNoDuplicates{
    NSArray *allValues = [self allValuesNoDuplicatesForKey:@"x"];
    return allValues;
}
- (NSArray *)allYValuesNoDuplicates{
    NSArray *allValues = [self allValuesNoDuplicatesForKey:@"y"];
    return allValues;
}
- (NSArray *)allXValues
{
    return [self allValuesForKey:@"x"];
}
- (NSArray *)allYValues{
    return [self allValuesForKey:@"y"];
}
- (NSArray *)allValuesNoDuplicatesForKey:(NSString *)key{
    NSArray *allValues = [self allValuesForKey:key];
    allValues = [allValues valueForKeyPath:@"@distinctUnionOfObjects.self"];
    allValues = [allValues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    return allValues;
}
- (NSArray *)allValuesForKey:(NSString *)key{
    //TODO convert to KVO, was getting null values...
    NSMutableArray *valuesForKey = [NSMutableArray new];
    for (NSArray *graphValues in self.graphsValues) {
        [valuesForKey addObjectsFromArray:[self valuesForGraphValues:graphValues inKey:key]];
    }
    return [NSArray arrayWithArray:valuesForKey];
}
- (NSArray *)valuesForGraphValues:(NSArray *)graphValues inKey:(NSString *)key{
    NSMutableArray *valuesForKey = [NSMutableArray new];
    for (NSDictionary *value in graphValues){
        [valuesForKey addObject:[value objectForKey:key]];
    }
    return [NSArray arrayWithArray:valuesForKey];
}
- (BOOL)hasAutoTickmark:(MBXLineGraphDataSourceAxisCalc)calc{
    return (calc & MBXLineGraphDataSourceAxisCalcAutoTickmark) == MBXLineGraphDataSourceAxisCalcAutoTickmark;
}
- (BOOL)hasEqualDistribution:(MBXLineGraphDataSourceAxisCalc)calc{
    return (calc & MBXLineGraphDataSourceAxisCalcEquallyDistribute) == MBXLineGraphDataSourceAxisCalcEquallyDistribute;
}
@end

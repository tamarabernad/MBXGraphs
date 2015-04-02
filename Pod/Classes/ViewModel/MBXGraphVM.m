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

#import "MBXGraphVM.h"
#import "MBXNumberUtils.h"

@implementation MBXGraphVM
- (NSArray *)graphs{
    if(!_graphs){
        _graphs = [NSArray new];
    }
    return _graphs;
}
- (MBXLineGraphVM *)getGraphByUid:(NSString *)uid{
    NSUInteger index = [[self.graphs valueForKey:@"uid"] indexOfObject:uid];
    return index != NSNotFound ? [self.graphs objectAtIndex:index] : nil;
}

- (NSArray *)calculateProportionValues:(NSArray *)values WithRange:(MBXValueRange )range{
    NSMutableArray *pointsArray=[[NSMutableArray alloc] init];
    for (NSNumber *p in values) {
        double val= [self getProportionpointWithValue:p AndRange:range];
        [pointsArray addObject:@(val)];
    }
    
    return pointsArray;
}
- (double)getProportionpointWithValue:(NSNumber *)value AndRange:(MBXValueRange)range{
    double val=[value doubleValue];
    double min=range.min,max=range.max;
    
    val=((val-min)/(max-min));
    val = (max - min == 0) ? 1 : val;
    val = (max == 0 && min == 0) ? 0 : val;
    return val;
}

- (NSArray*)calculateRangeAndIntervalSizeWithMinValue:(double)minValue AndMaxValue:(double)maxValue
{
    double min_ = 0, max_ = 0, min = minValue, max = maxValue, power = 0, factor = 0, tickWidth = 0, minAxisValue = 0, maxAxisValue = 0;
    NSArray *factorArray = [NSArray arrayWithObjects:@"0.0f",@"1.2f",@"2.5f",@"5.0f",@"10.0f",nil];
    NSArray *scalarArray = [NSArray arrayWithObjects:@"0.2f",@"0.2f",@"0.5f",@"1.0f",@"2.0f",nil];
    
    // calculate x-axis nice scale and ticks
    // 1. min_
    if (min == 0) {
        min_ = 0;
    }
    else if (min > 0) {
        min_ = MAX(0, min-(max-min)/100);
    }
    else {
        min_ = min-(max-min)/100;
    }
    
    // 2. max_
    if (max == 0) {
        if (min == 0) {
            max_ = 1;
        }
        else {
            max_ = 0;
        }
    }
    else if (max < 0) {
        max_ = MIN(0, max+(max-min)/100);
    }
    else {
        max_ = max+(max-min)/100;
    }
    
    if(compareDoubles(max_, min_) == NSOrderedSame){
        return @[[NSNumber numberWithDouble:min_],[NSNumber numberWithDouble:max_],[NSNumber numberWithDouble:1]];
    }
    
    // 3. power
    power = log(max_ - min_) / log(10);
    
    // 4. factor
    factor = pow(10, power - floor(power));
    
    // 5. nice ticks
    for (NSInteger i = 0; factor > [[factorArray objectAtIndex:i]doubleValue] ; i++) {
        tickWidth = [[scalarArray objectAtIndex:i]doubleValue] * pow(10, floor(power));
    }
    
    // 6. min-axisValues
    minAxisValue = tickWidth * floor(min_/tickWidth);
    
    // 7. min-axisValues
    maxAxisValue = tickWidth * floor((max_/tickWidth)+1);
    
    // 8. create NSArray to return
    NSArray *niceAxisValues = [NSArray arrayWithObjects:[NSNumber numberWithDouble:minAxisValue], [NSNumber numberWithDouble:maxAxisValue],[NSNumber numberWithDouble:tickWidth], nil];
    
    return niceAxisValues;
}
@end

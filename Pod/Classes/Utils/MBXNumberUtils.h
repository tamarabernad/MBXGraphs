//
//  CDANumberUtils.h
//  kpi-dashboard
//
//  Created by Tamara Bernad on 31/10/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
struct MBXValueRange {
    double min;
    double max;
    double ticks;
};
typedef struct MBXValueRange MBXValueRange;

CG_INLINE MBXValueRange
MBXValueRangeMake(double min, double max)
{
    MBXValueRange range; range.min = min; range.max = max; return range;
}
CG_INLINE MBXValueRange
MBXValueRangeTicksMake(double min, double max, double ticks)
{
    MBXValueRange range; range.min = min; range.max = max; range.ticks = ticks; return range;
}

BOOL doubleAlmostEqual(double x, double y);
NSInteger compareDoubles(double x, double y);
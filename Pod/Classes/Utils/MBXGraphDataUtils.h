//
//  MBXGraphDataUtils.h
//  Pods
//
//  Created by Tamara Bernad on 31/03/15.
//
//

#import <Foundation/Foundation.h>
#import "MBXNumberUtils.h"
@interface MBXGraphDataUtils : NSObject
- (MBXValueRange)rangeWithTicksForValues:(NSArray *)values;
- (MBXValueRange)rangeForValues:(NSArray *)values;
- (NSArray *)calculateProportionValues:(NSArray *)values WithRange:(MBXValueRange )range;
- (NSArray *)createProportionPointsWithXProportionValues:(NSArray *)xProportionValues AndYProportionValues:(NSArray *)yProportionValues;
- (NSArray *)calculateIntervalsInRange:(MBXValueRange)range;
- (NSArray *)formatIntervalStringsWithIntervals:(NSArray *)intervals;
@end

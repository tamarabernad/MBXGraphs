//
//  CDANumberUtils.m
//  kpi-dashboard
//
//  Created by Tamara Bernad on 31/10/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import "MBXNumberUtils.h"

BOOL doubleAlmostEqual(double x, double y)
{
    return fabs(x - y) <= 0.0000001;
}
NSInteger compareDoubles(double x, double y){
    if(doubleAlmostEqual(x, y)){
        return NSOrderedSame;
    }
    if(doubleAlmostEqual(fmin(x, y),x)){
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}

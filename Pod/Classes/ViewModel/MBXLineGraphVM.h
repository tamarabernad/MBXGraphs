//
//  MBXLineGraphVM.h
//  kpi-dashboard
//
//  Created by Tamara Bernad on 02/02/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
 MBXLineGraphDawingTypeNone = 1 << 0,
 MBXLineGraphDawingTypeMarker = 1 << 1,
 MBXLineGraphDawingTypeLine = 1 << 2,
 MBXLineGraphDawingTypeFill = 1 << 3,
 MBXLineGraphDawingHidden = 1 << 4
    
}MBXLineGraphDawingType;

typedef enum
{
    MBXLineStyleDefault,
    MBXLineStyleDashed,
    MBXLineStyleDotDash
}MBXLineStyle;

typedef enum{
    MBXMarkerStyleDefault = 1 << 0,
    MBXMarkerStyleFilled = 1 << 1,
    MBXMarkerStyleImage = 1 << 2,
    MBXMarkerStyleBig = 1 << 3,
    MBXMarkerStyleMedium = 1 << 4,
    MBXMarkerStyleSmall = 1 << 5,
    MBXMarkerStyleMaxToParentWidth = 1 << 6,
    MBXMarkerStyleHidden = 1 << 7
    
}MBXMarkerStyle;

@interface MBXLineGraphVM : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSArray *proportionPoints;
@property (nonatomic, strong) NSArray *pointsInView;
@property (nonatomic, strong) NSArray *yValues;
@property (nonatomic, strong) NSArray *xValues;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic) NSInteger priority;
@property (nonatomic, strong) UIImage *markerImage;

@property (nonatomic) CGFloat opacity;
@property (nonatomic) CGFloat fillOpacity;
@property (nonatomic) MBXLineGraphDawingType drawingType;
@property (nonatomic) MBXLineStyle lineStyle;
@property (nonatomic) MBXMarkerStyle markerStyle;
@end

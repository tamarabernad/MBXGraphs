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

@interface MBXGraphVM : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic) NSInteger priority;
@property (nonatomic, strong) NSArray *proportionPoints;
@property (nonatomic, strong) NSArray *pointsInView;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIImage *markerImage;

@property (nonatomic) CGFloat opacity;
@property (nonatomic) CGFloat fillOpacity;
@property (nonatomic) MBXLineGraphDawingType drawingType;
@property (nonatomic) MBXLineStyle lineStyle;
@property (nonatomic) MBXMarkerStyle markerStyle;
@end

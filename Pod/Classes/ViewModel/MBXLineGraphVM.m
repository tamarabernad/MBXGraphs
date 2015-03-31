//
//  MBXLineGraphVM.m
//  kpi-dashboard
//
//  Created by Tamara Bernad on 02/02/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "MBXLineGraphVM.h"

@implementation MBXLineGraphVM

- (CGFloat)opacity{
    if(!_opacity){
        _opacity = 1.0;
    }
    return _opacity;
}
- (CGFloat)fillOpacity{
    if(!_fillOpacity){
        _fillOpacity = 1.0;
    }
    return _fillOpacity;
}


@end

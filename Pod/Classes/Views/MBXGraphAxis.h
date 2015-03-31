//
//  MBXGraphAxis.h
//  kpi-dashboard
//
//  Created by Tamara Bernad on 11/09/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBXAxisVM.h"
typedef enum
{
    kDirectionVertical,
    kDirectionHorizontal
    
}MBXGRaphAxisDirection;
@interface MBXGraphAxis : UIView
@property (nonatomic) MBXGRaphAxisDirection direction;
- (void)setIsForReport:(BOOL)forReport;
- (void)setAxisProportionValues:(NSArray *)proportionValues AndTitles:(NSArray *)titles;
- (void)setAxisVM:(MBXAxisVM *)axisVM;
@end

//
//  MBXGraphAxis.h
//  kpi-dashboard
//
//  Created by Tamara Bernad on 11/09/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBXAxisVM.h"
#import "MBXGraphDataSource.h"
typedef enum
{
    kDirectionVertical,
    kDirectionHorizontal
    
}MBXGRaphAxisDirection;

@interface MBXGraphAxis : UIView

@property (nonatomic) MBXGRaphAxisDirection direction;
@property (nonatomic, assign)   id <MBXGraphDataSource> dataSource;

- (void)reload;
- (void)setAxisProportionValues:(NSArray *)proportionValues AndTitles:(NSArray *)titles;
@end

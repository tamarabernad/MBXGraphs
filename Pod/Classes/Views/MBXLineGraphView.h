//
//  MBXLineGraphView.h
//  kpi-dashboard
//
//  Created by Tamara Bernad on 09/09/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBXLineGraphVM.h"
#import "MBXGraphVM.h"
#import "MBXGraphDataSource.h"
#import "MBXGraphAppearanceDelegate.h"

@interface MBXLineGraphView : UIView
@property (nonatomic, assign)   id <MBXGraphDataSource> dataSource;
@property (nonatomic, assign)   id <MBXGraphAppearanceDelegate> appearanceDelegate;

@end

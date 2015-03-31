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
@interface MBXLineGraphView : UIView
- (void)setGraphVMs:(NSArray *)graphs;
@end

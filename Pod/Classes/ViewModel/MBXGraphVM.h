//
//  MBXGraphVM.h
//  kpi-dashboard
//
//  Created by Tamara Bernad on 05/01/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBXAxisVM.h"
#import "MBXLineGraphVM.h"

@interface MBXGraphVM : NSObject
@property (nonatomic, strong) MBXAxisVM *yAxisVM;
@property (nonatomic, strong) MBXAxisVM *xAxisVM;
@property (nonatomic, strong) NSArray *graphs;
- (MBXLineGraphVM *)getGraphByUid:(NSString *)uid;
@end

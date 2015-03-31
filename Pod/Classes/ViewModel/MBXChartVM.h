//
//  MBXChartVM.h
//  Pods
//
//  Created by Tamara Bernad on 31/03/15.
//
//

#import <Foundation/Foundation.h>

#import "MBXAxisVM.h"
#import "MBXLineGraphVM.h"

@interface MBXChartVM : NSObject
@property (nonatomic, strong) MBXAxisVM *yAxisVM;
@property (nonatomic, strong) MBXAxisVM *xAxisVM;
@property (nonatomic, strong) NSArray *graphs;
- (MBXLineGraphVM *)getGraphByUid:(NSString *)uid;
@end

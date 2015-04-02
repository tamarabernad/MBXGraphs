//
//  MBXLineGraphDataSource.h
//  Pods
//
//  Created by Tamara Bernad on 31/03/15.
//
//

#import <Foundation/Foundation.h>
#import "MBXGraphDataSource.h"
@interface MBXLineGraphDataSource : NSObject<MBXGraphDataSource>
- (void)setMultipleGraphValues:(NSArray *)values;
- (void)setGraphValues:(NSArray *)values;
@end

//
//  MBXGraphDataSource.h
//  Pods
//
//  Created by Tamara Bernad on 31/03/15.
//
//

#import <Foundation/Foundation.h>
#import "MBXLineGraphView.h"
#import "MBXLineGraphVM.h"

@protocol MBXGraphDataSource <NSObject>
- (NSInteger)graphViewNumberOfGraphs:(MBXLineGraphView *)graphView;
- (void) graphView:(MBXLineGraphView *)graphView configureGraphVM:(MBXLineGraphVM *)graphVM;
@end

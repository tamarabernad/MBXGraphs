//
//  MBXGraphAppearanceDelegate.h
//  Pods
//
//  Created by Tamara Bernad on 01/04/15.
//
//

#import <Foundation/Foundation.h>
@class MBXLineGraphView;

@protocol MBXGraphAppearanceDelegate <NSObject>
- (void) graphView:(MBXLineGraphView *)graphView configureAppearanceGraphVM:(MBXLineGraphVM *)graphVM;
@end

//
//  MBXViewController.m
//  MBXGraphs
//
//  Created by tamarabernad on 02/11/2015.
//  Copyright (c) 2014 tamarabernad. All rights reserved.
//

#import "MBXViewController.h"
#import "MBXLineGraphView.h"
#import "MBXGraphAxis.h"
#import "MBXLineGraphDataSource.h"

@interface MBXViewController ()<MBXGraphDelegate, MBXGraphAxisDelegate>
@property (weak, nonatomic) IBOutlet MBXLineGraphView *viewGraph;
@property (weak, nonatomic) IBOutlet MBXGraphAxis *viewYAxis;
@property (weak, nonatomic) IBOutlet MBXGraphAxis *viewXAxis;

@property (nonatomic, strong) MBXLineGraphDataSource *dataSource;

@end

@implementation MBXViewController
- (IBAction)onBtClick:(id)sender {
    [self reload];
}
- (MBXLineGraphDataSource *)dataSource{
    if(!_dataSource){
        _dataSource = [MBXLineGraphDataSource new];
    }
    return _dataSource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *graphValues = @[
                             @[@{@"y":@3.0, @"x": @2005},
                             @{@"y":@3.5, @"x": @2006},
                             @{@"y":@4.0, @"x": @2007},
                             @{@"y":@1.2, @"x": @2008},
                             @{@"y":@7.0, @"x": @2009},
                             @{@"y":@7.0, @"x": @2010},
                             @{@"y":@2.0, @"x": @2011}],
                             
                             @[@{@"y":@0.5, @"x": @2008},
                               @{@"y":@1.5, @"x": @2009},
                               @{@"y":@9.0, @"x": @2010},
                               @{@"y":@3.2, @"x": @2011},
                               @{@"y":@5.0, @"x": @2012},
                               @{@"y":@8.0, @"x": @2013},
                               @{@"y":@2.0, @"x": @2014}]
                             ];
    
    
    self.viewGraph.dataSource = self.dataSource;
    self.viewYAxis.dataSource = self.dataSource;
    self.viewXAxis.dataSource = self.dataSource;
    self.viewXAxis.direction = kDirectionHorizontal;
    self.viewYAxis.direction = kDirectionVertical;
    self.viewGraph.appearanceDelegate = self;
    
    self.viewXAxis.delegate = self;
    self.viewYAxis.delegate = self;
    [self.dataSource setMultipleGraphValues:graphValues];
}
- (void)viewDidAppear:(BOOL)animated{
    [self reload];

}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self reload];
}

- (void)reload{
    [self.viewGraph reload];
    [self.viewYAxis reload];
    [self.viewXAxis reload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)MBXLineGraphView:(MBXLineGraphView *)graphView configureAppearanceGraphVM:(MBXLineGraphVM *)graphVM{

    graphVM.color = [UIColor greenColor];
    graphVM.drawingType = MBXLineGraphDawingTypeMarker | MBXLineGraphDawingTypeLine | MBXLineGraphDawingTypeFill;
    graphVM.fillColor = [UIColor redColor];
    graphVM.fillOpacity = 0.4;
    graphVM.markerStyle = MBXMarkerStyleFilled;
    graphVM.priority = 1000;

}

- (UIView *)MBXGraphAxis:(MBXGraphAxis *)graphAxis ViewForValue:(NSNumber *)value{
    UILabel *label = [UILabel new];
    label.text = [value stringValue];
    [label sizeToFit];
    return label;
}
- (NSInteger)MBXGraphAxisTicksHeight:(MBXGraphAxis *)graphAxis{
    return 1;
}
- (NSInteger)MBXGraphAxisTicksWidth:(MBXGraphAxis *)graphAxis{
    return 4;
}
- (UIColor *)MBXGraphAxisColor:(MBXGraphAxis *)graphAxis{
    return [UIColor purpleColor];
}
@end


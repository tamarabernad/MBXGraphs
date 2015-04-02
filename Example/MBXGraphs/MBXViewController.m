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

@interface MBXViewController ()
@property (weak, nonatomic) IBOutlet MBXLineGraphView *viewGraph;
@property (weak, nonatomic) IBOutlet MBXGraphAxis *viewYAxis;
@property (weak, nonatomic) IBOutlet MBXGraphAxis *viewXAxis;

@property (nonatomic, strong) MBXLineGraphDataSource *dataSource;

@end

@implementation MBXViewController
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
                             @{@"x":@3.0, @"y": @2005},
                             @{@"x":@3.5, @"y": @2006},
                             @{@"x":@4.0, @"y": @2007},
                             @{@"x":@1.2, @"y": @2008},
                             @{@"x":@7.0, @"y": @2009},
                             @{@"x":@7.0, @"y": @2010},
                             @{@"x":@2.0, @"y": @2011}
                             ];
    
    
    self.viewGraph.dataSource = self.dataSource;
    self.viewYAxis.dataSource = self.dataSource;
    self.viewXAxis.dataSource = self.dataSource;
    self.viewXAxis.direction = kDirectionHorizontal;
    self.viewYAxis.direction = kDirectionVertical;
    
    [self.dataSource setGraphValues:graphValues];
}
- (void)viewDidAppear:(BOOL)animated{

    [self.viewGraph reload];
    [self.viewYAxis reload];
    [self.viewXAxis reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

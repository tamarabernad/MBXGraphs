//
//  MBXGraphAxis.m
//  kpi-dashboard
//
//  Created by Tamara Bernad on 11/09/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import "MBXGraphAxis.h"

//#define N_LINES 11
#define LINE_SIZE 4


@interface MBXGraphAxis()
@property (nonatomic, strong) UIView *indicatorsContainer;
@property (nonatomic, strong) UIView *labelsContainer;
@property (nonatomic, strong) UIView *axisView;

@property (nonatomic, strong) NSArray *pointsInView;
@property (nonatomic) BOOL forReport;
@end

@implementation MBXGraphAxis

- (void)setIsForReport:(BOOL)forReport{
    self.forReport = forReport;
    [self setNeedsLayout];

}
- (void)setDirection:(MBXGRaphAxisDirection)direction{
    _direction = direction;
    [self setNeedsLayout];
}
- (void)setAxisVM:(MBXAxisVM *)axisVM{
    NSArray *proportionValues = axisVM.proportionValues;
    NSArray *titles = axisVM.labelValues;
    
    NSMutableArray *pivs = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0, n= [proportionValues count]; i<n;i++){
        [pivs addObject:[self viewPointWithProportionPoint:[proportionValues objectAtIndex:i]]];
    }
    self.pointsInView = [NSArray arrayWithArray:pivs];
    
    
    if ([self.pointsInView count] != [[self.indicatorsContainer subviews] count]) {
        [self setNumberIndicators:[self.pointsInView count]];
    }
    for(NSUInteger i = 0, n = [[self.labelsContainer subviews] count]; i<n;i++){
        UILabel *lb = [[self.labelsContainer subviews] objectAtIndex:i];
        NSString *val = [titles objectAtIndex:i];
        [lb setText:val];
        [lb sizeToFit];
    }
    [self setNeedsLayout];
}
- (void)setAxisProportionValues:(NSArray *)proportionValues AndTitles:(NSArray *)titles{
    
    NSMutableArray *pivs = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0, n= [proportionValues count]; i<n;i++){
        [pivs addObject:[self viewPointWithProportionPoint:[proportionValues objectAtIndex:i]]];
    }
    self.pointsInView = [NSArray arrayWithArray:pivs];
    
    
    if ([self.pointsInView count] != [[self.indicatorsContainer subviews] count]) {
        [self setNumberIndicators:[self.pointsInView count]];
    }
    for(NSUInteger i = 0, n = [[self.labelsContainer subviews] count]; i<n;i++){
        UILabel *lb = [[self.labelsContainer subviews] objectAtIndex:i];
        NSString *val = [titles objectAtIndex:i];
        [lb setText:val];
        [lb sizeToFit];
    }
    [self setNeedsLayout];
    
    
}
- (void)setAxisValues:(NSArray *)axisValues{
    NSInteger maxLines = 10;
    NSUInteger steps;
    NSMutableArray *finalAxisValues = [[NSMutableArray alloc] initWithArray:axisValues];
    if (([axisValues count]-1) > maxLines) {
        finalAxisValues = [[NSMutableArray alloc] init];
        steps =  ([axisValues count]-1)/maxLines;
        for (NSUInteger i=0; i<=steps; i++) {
            NSUInteger index = i * maxLines;
            [finalAxisValues addObject:[axisValues objectAtIndex:index]];
        }
    }
    
    if ([finalAxisValues count] != [[self.indicatorsContainer subviews] count]) {
        [self setNumberIndicators:[finalAxisValues count]];
    }
    for(NSUInteger i = 0, n = [[self.labelsContainer subviews] count]; i<n;i++){
        UILabel *lb = [[self.labelsContainer subviews] objectAtIndex:i];
        NSString *val = [finalAxisValues objectAtIndex:i];
        [lb setText:val];
        [lb sizeToFit];
    }
    [self setNeedsLayout];
}

- (void)setNumberIndicators:(NSInteger)numberIndicators{
    
    NSArray *indicators = [[self.indicatorsContainer subviews] copy];
    for(UIView *indicator in indicators){
        [indicator removeFromSuperview];
    }
    
    NSArray *labels = [[self.labelsContainer subviews] copy];
    for(UILabel *label in labels){
        [label removeFromSuperview];
    }
    
    UIView *line;
    UILabel *label;
    for (int i=0; i<numberIndicators; i++) {
        line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor grayColor]];
        [self.indicatorsContainer addSubview:line];
        
        label = [[UILabel alloc] init];
        [self.labelsContainer addSubview:label];
    }

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.forReport = NO;
        
        self.labelsContainer = [[UIView alloc] init];
        [self addSubview:self.labelsContainer];
        
        self.indicatorsContainer = [[UIView alloc] init];
        [self addSubview:self.indicatorsContainer];
        
        self.axisView = [[UIView alloc] init];
        [self.axisView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:self.axisView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    int lineSize = self.forReport ? 10 : LINE_SIZE;
    int lineWidth = self.forReport ? 2 : 1;
    
    // Axis View
    CGRect fr = self.bounds;
    fr = self.direction == kDirectionHorizontal ? CGRectMake(-lineWidth, 0, fr.size.width + lineWidth, lineWidth) : CGRectMake(fr.size.width - lineWidth, 0, lineWidth, fr.size.height);
    [self.axisView setFrame:fr];
    
    // Indicator Container
    fr = self.bounds;
    fr.origin.x = self.direction == kDirectionHorizontal ? 0 : fr.size.width - lineSize - self.axisView.frame.size.width;
    fr.size = self.direction == kDirectionHorizontal ? CGSizeMake(fr.size.width, lineSize) : CGSizeMake(lineSize, fr.size.height);
    [self.indicatorsContainer setFrame:fr];
    
    // Labels Container
    fr = self.indicatorsContainer.frame;
    fr.origin.y = self.direction == kDirectionHorizontal ? fr.size.height : 0;
    fr.origin.x = self.direction == kDirectionHorizontal ? - lineWidth : 0;
    fr.size = self.direction == kDirectionHorizontal ? CGSizeMake(fr.size.width, self.bounds.size.height - fr.size.height) : CGSizeMake(self.bounds.size.width - fr.size.width- lineWidth, fr.size.height);

    [self.labelsContainer setFrame:fr];
    
    // Indicator Lines
    
    UIView *line;
    UILabel *label;
    
    for (int i=0; i<[self.pointsInView count]; i++) {
        line = [[self.indicatorsContainer subviews] objectAtIndex:i];
        CGPoint point = [[self.pointsInView objectAtIndex:i] CGPointValue];
        fr = CGRectMake(point.x, point.y, lineWidth, lineWidth);
        fr.size = self.direction == kDirectionHorizontal ? CGSizeMake(lineWidth, lineSize): CGSizeMake(lineSize, lineWidth);
        [line setFrame:fr];
        
        label = [[self.labelsContainer subviews] objectAtIndex:i];
        [label sizeToFit];
        label.center = self.direction == kDirectionHorizontal ? CGPointMake(fr.origin.x, (int)label.frame.size.height) : CGPointMake(fr.origin.x, fr.origin.y);
        
        fr = label.frame;
        fr.origin.x = self.direction == kDirectionHorizontal ? (int)fr.origin.x : (int)(self.indicatorsContainer.frame.origin.x - fr.size.width - 3);
        fr.origin.y = self.direction == kDirectionHorizontal ? self.indicatorsContainer.frame.origin.y : (int)(fr.origin.y - 1);
        label.frame = fr;
        
    }
    
}
- (NSValue *)viewPointWithProportionPoint:(NSNumber *)proportionPoint{
    
    CGFloat height = self.frame.size.height;
    CGFloat width  = self.frame.size.width;
    NSValue *point;
    if (self.direction == kDirectionHorizontal) {
        point = [NSValue valueWithCGPoint:CGPointMake(width*[proportionPoint doubleValue],0)];
    }else{
        point = [NSValue valueWithCGPoint:CGPointMake(0,height-(height*[proportionPoint doubleValue]))];
    }
    return point;
}
@end

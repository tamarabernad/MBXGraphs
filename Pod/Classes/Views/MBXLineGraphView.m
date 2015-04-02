    //
//  MBXLineGraphView.m
//  kpi-dashboard
//
//  Created by Tamara Bernad on 09/09/14.
//  Copyright (c) 2014 Code d'Azur. All rights reserved.
//

#import "MBXLineGraphView.h"
#import "MBXLineGraphVM.h"


@interface MBXLineGraphView()
@property (nonatomic, strong) CAShapeLayer *graphLayer;

@end

@implementation MBXLineGraphView

+ (Class)layerClass{
    return [CAShapeLayer class];
}


////////////////////////////////
#pragma mark - Life cycle
////////////////////////////////
- (id)initWithCoder:(NSCoder *)aDecoder{
    //TODO change this to the designed initializer, this would only work for nib created graphViews
    if(self = [super initWithCoder:aDecoder]){

        self.graphLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.graphLayer];
        self.graphLayer.actions = @{@"sublayers":[NSNull null]};

    }
    return self;
}
////////////////////////////////
#pragma mark - Private methods
////////////////////////////////
////////////////////////////////
#pragma mark Drawing
////////////////////////////////
- (void)reload{
    self.graphLayer.frame = self.bounds;
    [self clearGraph];
    
    for (MBXLineGraphVM *graphVM in [self.dataSource graphVMs]) {
        [self generatePointsInViewForGraphModel:graphVM];
        [self.appearanceDelegate graphView:self configureAppearanceGraphVM:graphVM];
        [self drawGraphWithGraphModel:graphVM];
    }
}
- (void)clearGraph{
    ((CAShapeLayer *)self.graphLayer).path = nil;
    
    [self.graphLayer.sublayers makeObjectsPerformSelector: @selector(removeFromSuperlayer)];
}
- (void)drawGraphWithGraphModel:(MBXLineGraphVM *)graphVM{
    CAShapeLayer *layer;
    CAShapeLayer *fillLayer;
    CALayer *marker;
    BOOL hasLine = (graphVM.drawingType & MBXLineGraphDawingTypeLine) == MBXLineGraphDawingTypeLine;
    BOOL hasMarker = (graphVM.drawingType & MBXLineGraphDawingTypeMarker) == MBXLineGraphDawingTypeMarker;
    BOOL hasFill = (graphVM.drawingType & MBXLineGraphDawingTypeFill) == MBXLineGraphDawingTypeFill;
    
    CAShapeLayer *graphLayer =[CAShapeLayer layer];
    [self.graphLayer addSublayer:graphLayer];
    graphLayer.zPosition = graphVM.priority;
    [graphLayer setHidden:(graphVM.drawingType & MBXLineGraphDawingHidden) == MBXLineGraphDawingHidden];
    
    if(hasFill){
        fillLayer =[CAShapeLayer layer];
        [fillLayer setMasksToBounds:YES];
        fillLayer.frame = self.graphLayer.bounds;
        
        fillLayer.fillColor = graphVM.fillColor.CGColor;
        fillLayer.opacity = graphVM.fillOpacity;
        UIBezierPath *path =[self getPathWithPoints:graphVM.pointsInView];
        UIBezierPath *fullPath = [self getFillPathFromPath:path AndPoints:graphVM.pointsInView];
        fillLayer.path = fullPath.CGPath;
        [graphLayer addSublayer:fillLayer];
    }
    if (hasLine) {
        layer = [CAShapeLayer layer];
        [layer setMasksToBounds:YES];
        layer.frame = self.graphLayer.bounds;
        
        layer.fillColor=[UIColor clearColor].CGColor;
        layer.lineWidth= 1;
        layer.opacity = graphVM.opacity;
        
        if (graphVM.lineStyle == MBXLineStyleDashed) {
            [layer setLineDashPattern:
             [NSArray arrayWithObjects:
              [NSNumber numberWithInt:5],
              [NSNumber numberWithInt:2],
              nil]];
        }else if (graphVM.lineStyle == MBXLineStyleDotDash) {
            [layer setLineDashPattern:
             [NSArray arrayWithObjects:
              [NSNumber numberWithInt:1],
              [NSNumber numberWithInt:3],
              [NSNumber numberWithInt:5],
              [NSNumber numberWithInt:4],
              nil]];
        }
        [graphLayer addSublayer:layer];
        
        UIBezierPath *path =[self getPathWithPoints:graphVM.pointsInView];
        layer.strokeColor = graphVM.color.CGColor;
        layer.path = path.CGPath;
    }
    if (hasMarker) {
        marker= [CALayer layer];
        [marker setMasksToBounds:YES];

        if((graphVM.markerStyle & MBXMarkerStyleFilled) == MBXMarkerStyleFilled){
            [marker setBackgroundColor:graphVM.color.CGColor];
        }else if((graphVM.markerStyle & MBXMarkerStyleImage) == MBXMarkerStyleImage){
            marker.contents =(id) graphVM.markerImage.CGImage;
        }else{
            [marker setBorderWidth:1.0];
            [marker setBackgroundColor:[UIColor whiteColor].CGColor];
            [marker setBorderColor:graphVM.color.CGColor];
        }
        
        [graphLayer addSublayer:marker];
        NSInteger markerDim;
        if((graphVM.markerStyle & MBXMarkerStyleBig) == MBXMarkerStyleBig){
            markerDim = 32;
        }else if((graphVM.markerStyle & MBXMarkerStyleMedium) == MBXMarkerStyleMedium){
            markerDim = 14;
        }else{
            markerDim = 8;
        }
        
        CGPoint endPoint = [[graphVM.pointsInView lastObject] CGPointValue];
        if (graphVM.markerStyle & MBXMarkerStyleMaxToParentWidth) {
            endPoint.x = endPoint.x > self.graphLayer.frame.size.width ? self.graphLayer.frame.size.width : endPoint.x;
        }
        
        [marker setCornerRadius:markerDim/2];
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        marker.frame = CGRectMake(endPoint.x- markerDim/2, endPoint.y - markerDim/2, markerDim, markerDim);
        [CATransaction commit];
    }

}
////////////////////////////////
#pragma mark Points Conversion
////////////////////////////////
- (void)generatePointsInViewForGraphModels:(NSArray *)graphModels{
    for (MBXLineGraphVM *graphVM in graphModels) {
        [self generatePointsInViewForGraphModel:graphVM];
    }
}
- (void)generatePointsInViewForGraphModel:(MBXLineGraphVM *)graphVM{
    NSMutableArray *pivs = [[NSMutableArray alloc] init];
    for(NSInteger i = 0, n = [graphVM.proportionPoints count]; i<n;i++){
        [pivs addObject:[self viewPointWithProportionPoint:[graphVM.proportionPoints objectAtIndex:i]]];
    }
    graphVM.pointsInView = [NSArray arrayWithArray:pivs];
}

- (NSValue *)viewPointWithProportionPoint:(NSValue *)proportionPoint{
    
    CGPoint p = [proportionPoint CGPointValue];
    
    CGFloat height = self.frame.size.height;
    CGFloat width  = self.frame.size.width;
    NSValue *point = [NSValue valueWithCGPoint:CGPointMake(width*p.x,height-(height*p.y))];
    return point;
}
////////////////////////////////
#pragma mark paths
////////////////////////////////
- (UIBezierPath *)getFillPathFromPath:(UIBezierPath *)path AndPoints:(NSArray *)points{
    UIBezierPath *fullPath = [path copy];
    if ([points count] > 0){
        CGPoint last= [[points objectAtIndex:[points count]-1] CGPointValue];
        CGPoint first=[[points objectAtIndex:0] CGPointValue];
        [fullPath addLineToPoint:CGPointMake(last.x,self.frame.size.height)];
        [fullPath addLineToPoint:CGPointMake(first.x,self.frame.size.height)];
        [fullPath addLineToPoint:first];
    }
    return fullPath;
    
}
- (UIBezierPath *)getPathWithPoints:(NSArray *)points{
    UIBezierPath *path=[UIBezierPath bezierPath];
    for (NSInteger i=0;i<points.count;i++) {
       
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        
        if(i==0)
            [path moveToPoint:point];
        [path addLineToPoint:point];
    }
    return path;
}
@end

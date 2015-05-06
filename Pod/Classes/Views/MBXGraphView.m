/*
 
 Copyright (c) 2015 tamarabernad <tamara.bernad@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "MBXGraphView.h"
#import "MBXGraphVM.h"


@interface MBXGraphView()
@property (nonatomic, strong) CAShapeLayer *graphLayer;
@property (nonatomic, strong) NSArray *graphVMs;

@end

@implementation MBXGraphView

+ (Class)layerClass{
    return [CAShapeLayer class];
}


////////////////////////////////
#pragma mark - Life cycle
////////////////////////////////
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initContainers];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContainers];
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
    
    for (MBXGraphVM *graphVM in [self.dataSource graphVMs]) {
        [self generatePointsInViewForGraphModel:graphVM];
        [self.delegate MBXLineGraphView:self configureAppearanceGraphVM:graphVM];
        [self drawGraphWithGraphModel:graphVM];
    }
    self.graphVMs = [self.dataSource graphVMs];
}
- (void)clearGraph{
    ((CAShapeLayer *)self.graphLayer).path = nil;
    
    [self.graphLayer.sublayers makeObjectsPerformSelector: @selector(removeFromSuperlayer)];
}

- (void)drawGraphWithGraphModel:(MBXGraphVM *)graphVM{
    
    CAShapeLayer *graphLayer =[CAShapeLayer layer];
    [self.graphLayer addSublayer:graphLayer];
    graphLayer.zPosition = graphVM.priority;
    [graphLayer setHidden:(graphVM.drawingType & MBXLineGraphDawingHidden) == MBXLineGraphDawingHidden];
    
    [self drawFillGraphOnLayer:self.graphLayer withGraphVM:graphVM];
    [self drawLineGraphOnLayer:self.graphLayer withGraphVM:graphVM];
    [self drawMarkerGraphOnLayer:self.graphLayer withGraphVM:graphVM];

}
////////////////////////////////
#pragma mark Points Conversion
////////////////////////////////
- (void)generatePointsInViewForGraphModels:(NSArray *)graphModels{
    for (MBXGraphVM *graphVM in graphModels) {
        [self generatePointsInViewForGraphModel:graphVM];
    }
}
- (void)generatePointsInViewForGraphModel:(MBXGraphVM *)graphVM{
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

////////////////////////////////
#pragma - Helpers
////////////////////////////////
- (void)drawMarkerGraphOnLayer:(CALayer *)graphLayer withGraphVM:(MBXGraphVM *)graphVM{
    MBXGraphVM *previousGraphVM = [self graphVMByUid:graphVM.uid];
    BOOL animated = (graphVM.drawingType & MBXLineGraphDawingAnimated) == MBXLineGraphDawingAnimated;
    CALayer *marker;
    CGPoint point;
    CGRect toFrame;
    CGSize markerSize;
    for (NSInteger i=0; i<graphVM.pointsInView.count; i++) {
        point = [[graphVM.pointsInView objectAtIndex:i] CGPointValue];
        markerSize = [self.delegate MBXLineGraphView:self markerSizeAtIndex:i];
        toFrame = CGRectMake(point.x- markerSize.width/2, point.y - markerSize.height/2, markerSize.width, markerSize.height);

        if(![self.delegate MBXLineGraphView:self hasMarkerAtIndex:i])continue;
        
        marker= [self.delegate MBXLineGraphView:self markerViewForGraphVM:graphVM ForPointAtIndex:i];
        [graphLayer addSublayer:marker];
        
        if (graphVM.markerStyle & MBXMarkerStyleMaxToParentWidth) {
            point.x = point.x > graphLayer.frame.size.width ? graphLayer.frame.size.width : point.x;
        }
        
        if(previousGraphVM && animated && i<previousGraphVM.pointsInView.count){
            CGPoint fromEndpoint =[[previousGraphVM.pointsInView objectAtIndex:i] CGPointValue];
            if (previousGraphVM.markerStyle & MBXMarkerStyleMaxToParentWidth) {
                fromEndpoint.x = fromEndpoint.x > graphLayer.frame.size.width ? graphLayer.frame.size.width : fromEndpoint.x;
            }
            marker.frame = toFrame;
            CABasicAnimation* a = [CABasicAnimation animationWithKeyPath:@"position"];
            [a setDuration:graphVM.animationDuration];
            a.fromValue = [NSValue valueWithCGPoint:fromEndpoint];
            a.toValue = [NSValue valueWithCGPoint:point];
            [marker addAnimation:a forKey:@"position"];
        }else{
            marker.frame = toFrame;
        }

    }
    
}
- (void)drawFillGraphOnLayer:(CALayer *)graphLayer withGraphVM:(MBXGraphVM *)graphVM{
    BOOL hasFill = (graphVM.drawingType & MBXLineGraphDawingTypeFill) == MBXLineGraphDawingTypeFill;
    if(!hasFill)return;
    BOOL animated = (graphVM.drawingType & MBXLineGraphDawingAnimated) == MBXLineGraphDawingAnimated;
    MBXGraphVM *previousGraphVM = [self graphVMByUid:graphVM.uid];
    CAShapeLayer *fillLayer;
    fillLayer =[CAShapeLayer layer];
    [fillLayer setMasksToBounds:YES];
    fillLayer.frame = graphLayer.bounds;
    
    fillLayer.fillColor = graphVM.fillColor.CGColor;
    fillLayer.opacity = graphVM.fillOpacity;
    UIBezierPath *path =[self getPathWithPoints:graphVM.pointsInView];
    path = [self getFillPathFromPath:path AndPoints:graphVM.pointsInView];
    [graphLayer addSublayer:fillLayer];
    
    if(previousGraphVM && animated){
        UIBezierPath *oldPath =[self getPathWithPoints:previousGraphVM.pointsInView];
        
        CABasicAnimation* a = [CABasicAnimation animationWithKeyPath:@"path"];
        [a setDuration:graphVM.animationDuration];
        [a setFromValue:(id)oldPath.CGPath];
        [a setToValue:(id)path.CGPath];
        
        fillLayer.path = path.CGPath;
        [fillLayer addAnimation:a forKey:@"path"];
    }else{
        fillLayer.path = path.CGPath;
    }

}
- (void)drawLineGraphOnLayer:(CALayer *)graphLayer withGraphVM:(MBXGraphVM *)graphVM{
    BOOL hasLine = (graphVM.drawingType & MBXLineGraphDawingTypeLine) == MBXLineGraphDawingTypeLine;
    if(!hasLine)return;
    BOOL animated = (graphVM.drawingType & MBXLineGraphDawingAnimated) == MBXLineGraphDawingAnimated;
    MBXGraphVM *previousGraphVM = [self graphVMByUid:graphVM.uid];
    CAShapeLayer *layer;
    layer = [CAShapeLayer layer];
    [layer setMasksToBounds:YES];
    layer.frame = graphLayer.bounds;
    
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
    
    if(previousGraphVM && animated){
        UIBezierPath *oldPath =[self getPathWithPoints:previousGraphVM.pointsInView];
        
        CABasicAnimation* a = [CABasicAnimation animationWithKeyPath:@"path"];
        [a setDuration:graphVM.animationDuration];
        [a setFromValue:(id)oldPath.CGPath];
        [a setToValue:(id)path.CGPath];
        
        layer.path = path.CGPath;
        [layer addAnimation:a forKey:@"path"];
    }else{
        layer.path = path.CGPath;
    }
}
- (void)initContainers{
    self.graphLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.graphLayer];
    self.graphLayer.actions = @{@"sublayers":[NSNull null]};
}
- (MBXGraphVM *)graphVMByUid:(NSString *)uid{
    NSArray *uids = [self.graphVMs valueForKey:@"uid"];
    MBXGraphVM *ret = nil;
    if([uids indexOfObject:uid] != NSNotFound){
        ret = [self.graphVMs objectAtIndex:[uids indexOfObject:uid]];
    }
    return ret;
}
@end

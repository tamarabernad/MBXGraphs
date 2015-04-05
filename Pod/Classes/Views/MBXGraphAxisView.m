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

#import "MBXGraphAxisView.h"

@interface MBXGraphAxisView()
@property (nonatomic, strong) UIView *ticksContainer;
@property (nonatomic, strong) UIView *valuesContainer;
@property (nonatomic, strong) UIView *axisLineView;

@property (nonatomic, strong) NSArray *pointsInView;
@end

@implementation MBXGraphAxisView

////////////////////////////////////
#pragma mark - Public
////////////////////////////////////

- (void)reload{
    [self setAxisVM:self.direction == kDirectionHorizontal ? [self.dataSource xAxisVM] : [self.dataSource yAxisVM]];
}
- (void)setDirection:(MBXGRaphAxisDirection)direction{
    _direction = direction;
    [self setNeedsLayout];
}
- (void)setAxisVM:(MBXAxisVM *)axisVM{
    [self calculatePointsInViewWithProportionValues:axisVM.proportionValues];
    [self createViewsWithValues:axisVM.values];
    [self setNeedsLayout];
}

////////////////////////////////////
#pragma mark - Life cycle
////////////////////////////////////
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
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger lineSize = [self.delegate respondsToSelector:@selector(MBXGraphAxisTicksWidth:)] ? [self.delegate MBXGraphAxisTicksWidth:self] : 4;
    NSInteger lineWidth = [self.delegate respondsToSelector:@selector(MBXGraphAxisTicksHeight:)] ? [self.delegate MBXGraphAxisTicksHeight:self]: 1;
    
    // Axis Line
    CGRect fr = self.bounds;
    fr = self.direction == kDirectionHorizontal ? CGRectMake(-lineWidth, 0, fr.size.width + lineWidth, lineWidth) : CGRectMake(fr.size.width - lineWidth, 0, lineWidth, fr.size.height);
    [self.axisLineView setFrame:fr];
    
    // Ticks Container
    fr = self.bounds;
    fr.origin.x = self.direction == kDirectionHorizontal ? 0 : fr.size.width - lineSize - self.axisLineView.frame.size.width;
    fr.size = self.direction == kDirectionHorizontal ? CGSizeMake(fr.size.width, lineSize) : CGSizeMake(lineSize, fr.size.height);
    [self.ticksContainer setFrame:fr];
    
    // Values Container
    fr = self.ticksContainer.frame;
    fr.origin.y = self.direction == kDirectionHorizontal ? fr.size.height : 0;
    fr.origin.x = self.direction == kDirectionHorizontal ? - lineWidth : 0;
    fr.size = self.direction == kDirectionHorizontal ? CGSizeMake(fr.size.width, self.bounds.size.height - fr.size.height) : CGSizeMake(self.bounds.size.width - fr.size.width- lineWidth, fr.size.height);

    [self.valuesContainer setFrame:fr];
    
    // Ticks Lines
    UIView *line;
    UIView *valueView;
    
    for (int i=0; i<[self.pointsInView count]; i++) {
        line = [[self.ticksContainer subviews] objectAtIndex:i];
        CGPoint point = [[self.pointsInView objectAtIndex:i] CGPointValue];
        fr = CGRectMake(point.x, point.y, lineWidth, lineWidth);
        fr.size = self.direction == kDirectionHorizontal ? CGSizeMake(lineWidth, lineSize): CGSizeMake(lineSize, lineWidth);
        [line setFrame:fr];
        
        valueView = [[self.valuesContainer subviews] objectAtIndex:i];
        valueView.center = self.direction == kDirectionHorizontal ? CGPointMake(fr.origin.x, (int)valueView.frame.size.height) : CGPointMake(fr.origin.x, fr.origin.y);
        
        fr = valueView.frame;
        fr.origin.x = self.direction == kDirectionHorizontal ? (int)fr.origin.x : (int)(self.ticksContainer.frame.origin.x - fr.size.width - 3);
        fr.origin.y = self.direction == kDirectionHorizontal ? self.ticksContainer.frame.origin.y : (int)(fr.origin.y - 1);
        valueView.frame = fr;
        
    }
    
}

////////////////////////////////////
#pragma mark - Helpers
////////////////////////////////////
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
- (void)createViewsWithValues:(NSArray *)values{
    UIColor *axisColor = [self.delegate respondsToSelector:@selector(MBXGraphAxisColor:)] ? [self.delegate MBXGraphAxisColor:self] : [UIColor grayColor];
    NSArray *indicatorsSubviews = self.ticksContainer.subviews;
    [indicatorsSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *valueViews = self.valuesContainer.subviews;
    [valueViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    UIView *valueView;
    UIView *tickerView;
    for (NSNumber *value in values) {
        valueView = [self.delegate MBXGraphAxis:self ViewForValue:value];
        [self.valuesContainer addSubview:valueView];
        
        tickerView = [[UIView alloc] init];
        [tickerView setBackgroundColor:axisColor];
        [self.ticksContainer addSubview:tickerView];
    }
    
    [self.axisLineView setBackgroundColor:axisColor];
}
- (void)calculatePointsInViewWithProportionValues:(NSArray *)proportionValues{
    NSMutableArray *pivs = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0, n= [proportionValues count]; i<n;i++){
        [pivs addObject:[self viewPointWithProportionPoint:[proportionValues objectAtIndex:i]]];
    }
    self.pointsInView = [NSArray arrayWithArray:pivs];
}
- (void)initContainers{
    self.valuesContainer = [[UIView alloc] init];
    [self addSubview:self.valuesContainer];
    
    self.ticksContainer = [[UIView alloc] init];
    [self addSubview:self.ticksContainer];
    
    self.axisLineView = [[UIView alloc] init];
    [self addSubview:self.axisLineView];
}
@end

//
//  UIView+AutoLayout.m
//
//  Created by Richard Turton on 18/10/2012.

#import "UIView+AutoLayout.h"

#import <Availability.h>

@interface UIView (AutoLayoutPrivate)

/**
 *  Searches the view hierarchy to find the common superview between the receiver and the `peerView`.
 *
 *  @param peerView The other view in the view hierarchy where the superview should be located.
 *
 *  @return The common superview between the receiver and the `peerView` or nil if the views are not contained in the same view hierarchy.
 */
- (UIView*)commonSuperviewWithView:(UIView*)peerView;

@end

@implementation UIView (AutoLayout)

#pragma mark - Initializing a View Object

+(instancetype)autoLayoutView
{
    UIView *viewToReturn = [self new];
    viewToReturn.translatesAutoresizingMaskIntoConstraints = NO;
    return viewToReturn;
}

#pragma mark - Pinning to the Superview

-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset
{
    return [self pinToSuperviewEdges:edges inset:inset usingLayoutGuidesFrom:nil];
}

- (NSArray *)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset usingLayoutGuidesFrom:(UIViewController *)viewController
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't pin to a superview if no superview exists");

    id topItem = nil;
    id bottomItem = nil;

#ifdef __IPHONE_7_0
    if (viewController && [viewController respondsToSelector:@selector(topLayoutGuide)])
    {
        topItem = viewController.topLayoutGuide;
        bottomItem = viewController.bottomLayoutGuide;
    }
#endif

    NSMutableArray *constraints = [NSMutableArray new];

    if (edges & JRTViewPinTopEdge)
    {
        id item = topItem ? topItem : superview;
        NSLayoutAttribute attribute = topItem ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item attribute:attribute multiplier:1.0 constant:inset]];
    }
    if (edges & JRTViewPinLeftEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:inset]];
    }
    if (edges & JRTViewPinRightEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-inset]];
    }
    if (edges & JRTViewPinBottomEdge)
    {
        id item = bottomItem ? bottomItem : superview;
        NSLayoutAttribute attribute = bottomItem ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item attribute:attribute multiplier:1.0 constant:-inset]];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}


-(NSArray*)pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets
{
    NSMutableArray *constraints = [NSMutableArray new];

    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinTopEdge inset:insets.top]];
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinLeftEdge inset:insets.left]];
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinBottomEdge inset:insets.bottom]];
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinRightEdge inset:insets.right]];

    return [constraints copy];
}

#pragma mark - Centering Views

-(NSArray *)centerInView:(UIView*)view
{
    NSMutableArray *constraints = [NSMutableArray new];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    UIView *superview = [self commonSuperviewWithView:view];

    [superview addConstraints:constraints];

    return [constraints copy];
}

-(NSLayoutConstraint *)centerInContainerOnAxis:(NSLayoutAttribute)axis
{
    NSParameterAssert(axis == NSLayoutAttributeCenterX || axis == NSLayoutAttributeCenterY);

    UIView *superview = self.superview;
    NSParameterAssert(superview);
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:axis relatedBy:NSLayoutRelationEqual toItem:superview attribute:axis multiplier:1.0 constant:0.0];
    [superview addConstraint:constraint];
    return constraint;
}

#pragma mark - Constraining to a fixed size

-(NSArray *)constrainToSize:(CGSize)size
{
    NSMutableArray *constraints = [NSMutableArray new];

    if (size.width)
        [constraints addObject:[self constrainToWidth:size.width]];
    if (size.height)
        [constraints addObject:[self constrainToHeight:size.height]];

    return [constraints copy];
}

-(NSLayoutConstraint *)constrainToWidth:(CGFloat)width
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:width];
    [self addConstraint:constraint];
    return constraint;
}

-(NSLayoutConstraint *)constrainToHeight:(CGFloat)height
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:height];
    [self addConstraint:constraint];
    return constraint;
}

-(NSArray *)constrainToMinimumSize:(CGSize)minimum maximumSize:(CGSize)maximum
{
    NSAssert(minimum.width <= maximum.width, @"maximum width should be strictly wider than or equal to minimum width");
    NSAssert(minimum.height <= maximum.height, @"maximum height should be strictly higher than or equal to minimum height");
    NSArray *minimumConstraints = [self constrainToMinimumSize:minimum];
    NSArray *maximumConstraints = [self constrainToMaximumSize:maximum];
    return [minimumConstraints arrayByAddingObjectsFromArray:maximumConstraints];
}

-(NSArray *)constrainToMinimumSize:(CGSize)minimum
{
    NSMutableArray *constraints = [NSMutableArray array];
    if (minimum.width)
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:0 constant:minimum.width]];
    if (minimum.height)
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:0 constant:minimum.height]];
    [self addConstraints:constraints];
    return [constraints copy];
}

-(NSArray *)constrainToMaximumSize:(CGSize)maximum
{
    NSMutableArray *constraints = [NSMutableArray array];
    if (maximum.width)
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0 multiplier:0 constant:maximum.width]];
    if (maximum.height)
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0 multiplier:0 constant:maximum.height]];
    [self addConstraints:constraints];
    return [constraints copy];
}

#pragma mark - Pinning to other items

- (NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem withConstant:(CGFloat)constant
{
    return [self pinAttribute:attribute toAttribute:toAttribute ofItem:peerItem withConstant:constant relation:NSLayoutRelationEqual];
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem
{
    return [self pinAttribute:attribute toAttribute:toAttribute ofItem:peerItem withConstant:0];
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem withConstant:(CGFloat)constant relation:(NSLayoutRelation)relation
{
    NSParameterAssert(peerItem);
    UIView *superview;
    if ([peerItem isKindOfClass:[UIView class]])
    {
        superview = [self commonSuperviewWithView:peerItem];
        NSAssert(superview,@"Can't create constraints without a common superview");
    }
    else
    {
        superview = self.superview;
    }
    NSAssert(superview,@"Can't create constraints without a common superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:relation toItem:peerItem attribute:toAttribute multiplier:1.0 constant:constant];
    [superview addConstraint:constraint];
    return constraint;
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfItem:(id)peerItem
{
    return [self pinAttribute:attribute toAttribute:attribute ofItem:peerItem withConstant:0];
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfItem:(id)peerItem withConstant:(CGFloat)constant {
    return [self pinAttribute:attribute toAttribute:attribute ofItem:peerItem withConstant:constant];
}

-(NSArray *)pinEdges:(JRTViewPinEdges)edges toSameEdgesOfView:(UIView *)peerView
{
    return [self pinEdges:edges toSameEdgesOfView:peerView inset:0];
}

-(NSArray *)pinEdges:(JRTViewPinEdges)edges toSameEdgesOfView:(UIView *)peerView inset:(CGFloat)inset
{
    UIView *superview = [self commonSuperviewWithView:peerView];
    NSAssert(superview,@"Can't create constraints without a common superview");
    
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:4];
    
    if (edges & JRTViewPinTopEdge)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:peerView withConstant:inset]];
    }
    if (edges & JRTViewPinLeftEdge)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeLeft ofItem:peerView withConstant:inset]];
    }
    if (edges & JRTViewPinRightEdge)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeRight ofItem:peerView withConstant:-inset]];
    }
    if (edges & JRTViewPinBottomEdge)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeBottom ofItem:peerView withConstant:-inset]];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}

#pragma mark - Pinning to a fixed point

-(NSArray*)pinPointAtX:(NSLayoutAttribute)x Y:(NSLayoutAttribute)y toPoint:(CGPoint)point
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't create constraints without a superview");
    
    // Valid X positions are Left, Center, Right and Not An Attribute
    __unused BOOL xValid = (x == NSLayoutAttributeLeft || x == NSLayoutAttributeCenterX || x == NSLayoutAttributeRight || x == NSLayoutAttributeNotAnAttribute);
    // Valid Y positions are Top, Center, Baseline, Bottom and Not An Attribute
    __unused BOOL yValid = (y == NSLayoutAttributeTop || y == NSLayoutAttributeCenterY || y == NSLayoutAttributeBaseline || y == NSLayoutAttributeBottom || y == NSLayoutAttributeNotAnAttribute);
    
    NSAssert (xValid && yValid,@"Invalid positions for creating constraints");
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    if (x != NSLayoutAttributeNotAnAttribute)
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:x relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:point.x];
        [constraints addObject:constraint];
    }
    
    if (y != NSLayoutAttributeNotAnAttribute)
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:y relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:point.y];
        [constraints addObject:constraint];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}

#pragma mark - Spacing Views

-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options
{
    return [self spaceViews:views onAxis:axis withSpacing:spacing alignmentOptions:options flexibleFirstItem:NO];
}

-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options flexibleFirstItem:(BOOL)flexibleFirstItem
{
    NSAssert([views count] > 1,@"Can only distribute 2 or more views");
    NSString *direction = nil;
    NSLayoutAttribute attribute;
    switch (axis) {
        case UILayoutConstraintAxisHorizontal:
            direction = @"H:";
            attribute = NSLayoutAttributeWidth;
            break;
        case UILayoutConstraintAxisVertical:
            direction = @"V:";
            attribute = NSLayoutAttributeHeight;
            break;
        default:
            return @[];
    }
    
    UIView *previousView = nil;
    UIView *firstView = views[0];
    NSDictionary *metrics = @{@"spacing":@(spacing)};
    NSString *vfl = nil;
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in views)
    {
        vfl = nil;
        NSDictionary *views = nil;
        if (previousView)
        {
            if (previousView == firstView && flexibleFirstItem)
            {
                vfl = [NSString stringWithFormat:@"%@[previousView(>=view)]-spacing-[view]",direction];
            }
            else
            {
                vfl = [NSString stringWithFormat:@"%@[previousView(==view)]-spacing-[view]",direction];
            }
            views = NSDictionaryOfVariableBindings(previousView,view);
        }
        else
        {
            vfl = [NSString stringWithFormat:@"%@|-spacing-[view]",direction];
            views = NSDictionaryOfVariableBindings(view);
        }
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:metrics views:views]];
        if (previousView == firstView && flexibleFirstItem)
        {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:firstView attribute:attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:view attribute:attribute multiplier:1.0 constant:2.0]];
        }
        previousView = view;
    }
    
    vfl = [NSString stringWithFormat:@"%@[previousView]-spacing-|",direction];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:metrics views:NSDictionaryOfVariableBindings(previousView)]];
    
    [self addConstraints:constraints];
    return [constraints copy];
}

-(NSArray*)spaceViews:(NSArray *)views onAxis:(UILayoutConstraintAxis)axis
{
    NSAssert([views count] > 1,@"Can only distribute 2 or more views");

    NSLayoutAttribute attributeForView;
    NSLayoutAttribute attributeToPin;

    switch (axis) {
        case UILayoutConstraintAxisHorizontal:
            attributeForView = NSLayoutAttributeCenterX;
            attributeToPin = NSLayoutAttributeRight;
            break;
        case UILayoutConstraintAxisVertical:
            attributeForView = NSLayoutAttributeCenterY;
            attributeToPin = NSLayoutAttributeBottom;
            break;
        default:
            return @[];
    }

    CGFloat fractionPerView = 1.0 / (CGFloat)([views count] + 1);
    
    NSMutableArray *constraints = [NSMutableArray array];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop)
    {
        CGFloat multiplier = fractionPerView * (idx + 1.0);
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:attributeForView relatedBy:NSLayoutRelationEqual toItem:self attribute:attributeToPin multiplier:multiplier constant:0.0]];
    }];
    
    [self addConstraints:constraints];
    return [constraints copy];
}

#pragma mark - Private

-(UIView*)commonSuperviewWithView:(UIView*)peerView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([peerView isDescendantOfView:startView])
        {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    
    return commonSuperview;
}

#pragma mark - Deprecated

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfView:(UIView *)peerView
{
    return [self pinAttribute:attribute toSameAttributeOfItem:peerView];
}

-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView
{
    return [self pinEdge:edge toEdge:toEdge ofItem:peerView inset:0.0];
}

-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)peerView inset:(CGFloat)inset
{
    return [self pinEdge:edge toEdge:toEdge ofItem:peerView inset:inset];
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem
{
    return [self pinEdge:edge toEdge:toEdge ofItem:peerItem inset:0.0];
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem inset:(CGFloat)inset
{
    return [self pinEdge:edge toEdge:toEdge ofItem:peerItem inset:inset relation:NSLayoutRelationEqual];
}

-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem inset:(CGFloat)inset relation:(NSLayoutRelation)relation
{
    return [self pinAttribute:edge toAttribute:toEdge ofItem:peerItem withConstant:inset relation:relation];
}

@end

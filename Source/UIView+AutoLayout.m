//
//  UIView+AutoLayout.m
//  CollectionTableGrid
//
//  Created by Richard Turton on 18/10/2012.
//  Copyright (c) 2012 Richard Turton. All rights reserved.
//

#import "UIView+AutoLayout.h"
#import <objc/runtime.h>

static char UIViewConstraintKey;

@implementation UIView (AutoLayout)

+(id)autoLayoutView
{
    UIView *viewToReturn = [self new];
    viewToReturn.translatesAutoresizingMaskIntoConstraints = NO;
    return viewToReturn;
}

-(NSArray *)centerInView:(UIView*)superview
{
    NSMutableArray *constraints = [NSMutableArray new];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

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


-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfView:(UIView *)peerView;
{
    NSParameterAssert(peerView);
    UIView *superview = [self commonSuperviewWithView:peerView];
    NSAssert(superview,@"Can't create constraints without a common superview");

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:peerView attribute:attribute multiplier:1.0 constant:0.0];
    [superview addConstraint:constraint];
    return constraint;
}

-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't pin to a superview if no superview exists");
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    if (edges & JRTViewPinTopEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:inset]];
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
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-inset]];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}

-(NSArray*)pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't pin to a superview if no superview exists");
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinTopEdge inset:insets.top]];
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinLeftEdge inset:insets.left]];
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinBottomEdge inset:insets.bottom]];
    [constraints addObjectsFromArray:[self pinToSuperviewEdges:JRTViewPinRightEdge inset:insets.right]];
    
    return [constraints copy];
}

-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView
{
    return [self pinEdge:edge toEdge:toEdge ofView:peerView inset:0.0];
}

-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)peerView inset:(CGFloat)inset
{
    UIView *superview = [self commonSuperviewWithView:peerView];
    NSAssert(superview,@"Can't create constraints without a common superview");
    NSAssert (edge >= NSLayoutAttributeLeft && edge <= NSLayoutAttributeBottom,@"Edge parameter is not an edge");
    NSAssert (toEdge >= NSLayoutAttributeLeft && toEdge <= NSLayoutAttributeBottom,@"Edge parameter is not an edge");
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:edge relatedBy:NSLayoutRelationEqual toItem:peerView attribute:toEdge multiplier:1.0 constant:inset];
    [superview addConstraint:constraint];
    return constraint;
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
        [constraints addObject:[self pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeTop ofView:peerView inset:inset]];
    }
    if (edges & JRTViewPinLeftEdge)
    {
        [constraints addObject:[self pinEdge:NSLayoutAttributeLeft toEdge:NSLayoutAttributeLeft ofView:peerView inset:inset]];
    }
    if (edges & JRTViewPinRightEdge)
    {
        [constraints addObject:[self pinEdge:NSLayoutAttributeRight toEdge:NSLayoutAttributeRight ofView:peerView inset:-inset]];
    }
    if (edges & JRTViewPinBottomEdge)
    {
        [constraints addObject:[self pinEdge:NSLayoutAttributeBottom toEdge:NSLayoutAttributeBottom ofView:peerView inset:-inset]];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}

-(NSArray *)constrainToSize:(CGSize)size
{
    NSMutableArray *constraints = [NSMutableArray new];

    if (size.width)
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:size.width]];
    if (size.height)
         [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:size.height]];

    [self addConstraints:constraints];
    return [constraints copy];
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

-(NSArray*)pinPointAtX:(NSLayoutAttribute)x Y:(NSLayoutAttribute)y toPoint:(CGPoint)point
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't create constraints without a superview");
    
    // Valid X positions are Left, Center, Right and Not An Attribute
    BOOL xValid = (x == NSLayoutAttributeLeft || x == NSLayoutAttributeCenterX || x == NSLayoutAttributeRight || x == NSLayoutAttributeNotAnAttribute);
    // Valid Y positions are Top, Center, Baseline, Bottom and Not An Attribute
    BOOL yValid = (y == NSLayoutAttributeTop || y == NSLayoutAttributeCenterY || y == NSLayoutAttributeBaseline || y == NSLayoutAttributeBottom || y == NSLayoutAttributeNotAnAttribute);
    
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

-(void)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options;
{
    NSAssert([views count] > 1,@"Can only distribute 2 or more views");
    NSString *direction = nil;
    switch (axis) {
        case UILayoutConstraintAxisHorizontal:
            direction = @"H:";
            break;
        case UILayoutConstraintAxisVertical:
            direction = @"V:";
            break;
        default:
            return;
    }
    
    UIView *previousView = nil;
    NSDictionary *metrics = @{@"spacing":@(spacing)};
    NSString *vfl = nil;
    for (UIView *view in views)
    {
        vfl = nil;
        NSDictionary *views = nil;
        if (previousView)
        {
            vfl = [NSString stringWithFormat:@"%@[previousView(==view)]-spacing-[view]",direction];
            views = NSDictionaryOfVariableBindings(previousView,view);
        }
        else
        {
            vfl = [NSString stringWithFormat:@"%@|-spacing-[view]",direction];
            views = NSDictionaryOfVariableBindings(view);
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:metrics views:views]];
        previousView = view;
    }
    
    vfl = [NSString stringWithFormat:@"%@[previousView]-spacing-|",direction];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:metrics views:NSDictionaryOfVariableBindings(previousView)]];
}

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

-(void)storeConstraint:(NSLayoutConstraint *)constraint forKey:(id)key
{
    NSMutableDictionary *constraints = objc_getAssociatedObject(self, &UIViewConstraintKey) ?: [NSMutableDictionary dictionary];
    constraints[key] = constraint;
    objc_setAssociatedObject(self, &UIViewConstraintKey, constraints, OBJC_ASSOCIATION_RETAIN);
}

-(NSLayoutConstraint *)storedConstraintForKey:(id)key
{
    NSDictionary *constraints = objc_getAssociatedObject(self, &UIViewConstraintKey);
    return constraints[key];
}

@end

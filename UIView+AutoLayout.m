//
//  UIView+AutoLayout.m
//  CollectionTableGrid
//
//  Created by Richard Turton on 18/10/2012.
//  Copyright (c) 2012 Richard Turton. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

+(id)autoLayoutView
{
    UIView *viewToReturn = [self new];
    viewToReturn.translatesAutoresizingMaskIntoConstraints = NO;
    return viewToReturn;
}

-(void)centerInView:(UIView*)superview
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

-(void)centerInContainerOnAxis:(NSLayoutAttribute)axis
{
    NSParameterAssert(axis == NSLayoutAttributeCenterX || axis == NSLayoutAttributeCenterY);

    UIView *superview = self.superview;
    NSParameterAssert(superview);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:axis relatedBy:NSLayoutRelationEqual toItem:superview attribute:axis multiplier:1.0 constant:0.0]];
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

-(void)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView
{
    [self pinEdge:edge toEdge:toEdge ofView:peerView inset:0.0];
}

-(void)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView inset:(CGFloat)inset
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't create constraints without a superview");
    NSAssert(superview == peerView.superview,@"Can't create constraints between views that don't share a superview");
    NSAssert (edge >= NSLayoutAttributeLeft && edge <= NSLayoutAttributeBottom,@"Edge parameter is not an edge");
    NSAssert (toEdge >= NSLayoutAttributeLeft && toEdge <= NSLayoutAttributeBottom,@"Edge parameter is not an edge");
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:edge relatedBy:NSLayoutRelationEqual toItem:peerView attribute:toEdge multiplier:1.0 constant:inset]];
}

-(void)constrainToSize:(CGSize)size
{
    if (size.width)
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:size.width]];
    if (size.height)
         [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:size.height]];
}

-(void)pinPointAtX:(NSLayoutAttribute)x Y:(NSLayoutAttribute)y toPoint:(CGPoint)point
{
    UIView *superview = self.superview;
    NSAssert(superview,@"Can't create constraints without a superview");
    
    // Valid X positions are Left, Center, Right and Not An Attribute
    BOOL xValid = (x == NSLayoutAttributeLeft || x == NSLayoutAttributeCenterX || x == NSLayoutAttributeRight || x == NSLayoutAttributeNotAnAttribute);
    // Valid Y positions are Top, Center, Baseline, Bottom and Not An Attribute
    BOOL yValid = (y == NSLayoutAttributeTop || y == NSLayoutAttributeCenterY || y == NSLayoutAttributeBaseline || y == NSLayoutAttributeBottom || y == NSLayoutAttributeNotAnAttribute);
    
    NSAssert (xValid && yValid,@"Invalid positions for creating constraints");
    
    if (x != NSLayoutAttributeNotAnAttribute)
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:x relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:point.x]];
    
    if (y != NSLayoutAttributeNotAnAttribute)
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:y relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:point.y]];
    
}

@end

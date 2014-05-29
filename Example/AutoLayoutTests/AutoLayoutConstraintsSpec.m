//
//  AutoLayoutTests.m
//  AutoLayoutTests
//
//  Created by James Frost on 20/05/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

#import <Specta/Specta.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "EXPMatchers+haveConstraint.h"
#import "EXPMatchers+haveFrame.h"

#import "UIView+AutoLayout.h"


#define JRTCenterConstraintWithAxis(axis) [NSLayoutConstraint constraintWithItem:subview attribute:axis relatedBy:NSLayoutRelationEqual toItem:superview attribute:axis multiplier:1.0f constant:0]

#define JRTSizeConstraintWithAttributeAndSize(axis, size) [NSLayoutConstraint constraintWithItem:subview attribute:axis relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size]

#define JRTSizeConstraintWithAttributeSizeAndRelation(axis, size, relation) [NSLayoutConstraint constraintWithItem:subview attribute:axis relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size]

#define JRTEdgeConstraintWithEdgeAndEqualInset(edge, inset) [NSLayoutConstraint constraintWithItem:subview attribute:edge relatedBy:NSLayoutRelationEqual toItem:superview attribute:edge multiplier:1.0 constant:inset]


SpecBegin(AutoLayoutConstraints)

describe(@"AutoLayout constraints", ^{
    
    __block UIView *superview = nil;
    __block UIView *subview = nil;
    
    context(@"when initializing views", ^{
        it(@"returns a view without translated autoresizing masks", ^{
            UIView *view = [UIView autoLayoutView];
            expect(view.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
        });
    });
    
    context(@"when centering views", ^{
        
        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subview = [UIView autoLayoutView];
            
            [superview addSubview:subview];
            
            [subview constrainToSize:CGSizeMake(100, 100)];
        });
        
        it(@"centers a view horizontally", ^{
            
            [subview centerInContainerOnAxis:NSLayoutAttributeCenterX];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterX));
            
            expect(CGRectGetMinX(subview.frame)).to.equal(100);
        });
        
        it(@"centers a view vertically", ^{
            
            [subview centerInContainerOnAxis:NSLayoutAttributeCenterY];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterY));
            
            expect(CGRectGetMinY(subview.frame)).to.equal(100);
        });
        
        it(@"centers a view within another view", ^{
            
            [subview centerInView:superview];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterX));
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterY));
            
            expect(subview.center).to.equal(CGPointMake(150, 150));
        });
        
    });
    
    context(@"when constraining size", ^{
        
        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subview = [UIView autoLayoutView];
            
            [superview addSubview:subview];
        });
        
        it(@"constrains just the width", ^{
            [subview constrainToSize:CGSizeMake(100, 0)];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeWidth, 100));
            expect(subview.constraints).to.haveCountOf(1);
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(100);
            expect(CGRectGetHeight(subview.bounds)).will.equal(0);
        });
        
        it(@"constrains just the height", ^{
            [subview constrainToSize:CGSizeMake(0, 100)];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeHeight, 100));
            expect(subview.constraints).to.haveCountOf(1);
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(0);
            expect(CGRectGetHeight(subview.bounds)).will.equal(100);
        });
        
        it(@"constrains both width and height", ^{
            [subview constrainToSize:CGSizeMake(100, 100)];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeWidth, 100));
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeHeight, 100));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(100);
            expect(CGRectGetHeight(subview.bounds)).will.equal(100);
        });
        
        it(@"constrains to a minimum size", ^{
            [subview constrainToMinimumSize:CGSizeMake(100, 150)];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeWidth, 100, NSLayoutRelationGreaterThanOrEqual));
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeHeight, 150, NSLayoutRelationGreaterThanOrEqual));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(100);
            expect(CGRectGetHeight(subview.bounds)).will.equal(150);
        });
        
        it(@"constrains to a maximum size", ^{
            [subview constrainToMaximumSize:CGSizeMake(100, 150)];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeWidth, 100, NSLayoutRelationLessThanOrEqual));
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeHeight, 150, NSLayoutRelationLessThanOrEqual));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(0);
            expect(CGRectGetHeight(subview.bounds)).will.equal(0);
        });
        
        it(@"constrains to both a maximum and minimum size", ^{
            [subview constrainToMinimumSize:CGSizeMake(100, 150) maximumSize:CGSizeMake(200, 300)];
            [superview layoutIfNeeded];
            
            // minimum sizes
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeWidth, 100, NSLayoutRelationGreaterThanOrEqual));
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeHeight, 150, NSLayoutRelationGreaterThanOrEqual));
            
            // maximum sizes
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeWidth, 200, NSLayoutRelationLessThanOrEqual));
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeSizeAndRelation(NSLayoutAttributeHeight, 300, NSLayoutRelationLessThanOrEqual));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(100);
            expect(CGRectGetHeight(subview.bounds)).will.equal(150);
        });

    });
    
    context(@"when constraining width and height", ^{
        
        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subview = [UIView autoLayoutView];
            
            [superview addSubview:subview];
        });
        
        it(@"constrains the width", ^{
            [subview constrainToWidth:100];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeWidth, 100));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(100);
            expect(CGRectGetHeight(subview.bounds)).will.equal(0);
        });
        
        it(@"constrains the height", ^{
            [subview constrainToHeight:100];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeHeight, 100));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(0);
            expect(CGRectGetHeight(subview.bounds)).will.equal(100);
        });
        
        it(@"constrains both width and height", ^{
            [subview constrainToWidth:100];
            [subview constrainToHeight:100];
            [superview layoutIfNeeded];
            
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeWidth, 100));
            expect(subview).to.haveConstraint(JRTSizeConstraintWithAttributeAndSize(NSLayoutAttributeHeight, 100));
            
            expect(CGRectGetWidth(subview.bounds)).will.equal(100);
            expect(CGRectGetHeight(subview.bounds)).will.equal(100);
        });
        
    });
    
    fcontext(@"when pinning to a superview's edges", ^{
        
        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subview = [UIView autoLayoutView];
            
            [superview addSubview:subview];
        });
        
        it(@"pins to just the top edge", ^{
            [subview pinToSuperviewEdges:JRTViewPinTopEdge inset:0];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeTop, 0));
            expect(superview.constraints).to.haveCountOf(1);
            
            expect(CGRectGetMinY(subview.frame)).to.equal(CGRectGetMinY(superview.frame));
        });
        
        it(@"pins to just the right edge", ^{
            [subview pinToSuperviewEdges:JRTViewPinRightEdge inset:0];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeRight, 0));
            expect(superview.constraints).to.haveCountOf(1);
            
            expect(CGRectGetMaxX(subview.frame)).to.equal(CGRectGetMaxX(superview.frame));
        });
        
        it(@"pins to just the bottom edge", ^{
            [subview pinToSuperviewEdges:JRTViewPinBottomEdge inset:0];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeBottom, 0));
            expect(superview.constraints).to.haveCountOf(1);
            
            expect(CGRectGetMaxY(subview.frame)).to.equal(CGRectGetMaxY(superview.frame));
        });
        
        it(@"pins to just the left edge", ^{
            [subview pinToSuperviewEdges:JRTViewPinLeftEdge inset:0];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeLeft, 0));
            expect(superview.constraints).to.haveCountOf(1);
            
            expect(CGRectGetMinX(subview.frame)).to.equal(CGRectGetMinX(superview.frame));
        });
        
        it(@"pins to a bitmask of edges", ^{
            [subview pinToSuperviewEdges:JRTViewPinTopEdge|JRTViewPinLeftEdge|JRTViewPinBottomEdge|JRTViewPinRightEdge inset:0];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeTop, 0));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeLeft, 0));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeBottom, 0));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeRight, 0));
            expect(superview.constraints).to.haveCountOf(4);
            
            expect(CGRectGetMinY(subview.frame)).to.equal(CGRectGetMinY(superview.frame));
            expect(CGRectGetMinX(subview.frame)).to.equal(CGRectGetMinX(superview.frame));
            expect(CGRectGetMaxY(subview.frame)).to.equal(CGRectGetMaxY(superview.frame));
            expect(CGRectGetMaxX(subview.frame)).to.equal(CGRectGetMaxX(superview.frame));
        });
        
        it(@"pins to all edges", ^{
            [subview pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeTop, 0));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeLeft, 0));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeBottom, 0));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeRight, 0));
            expect(superview.constraints).to.haveCountOf(4);
            
            expect(CGRectGetMinY(subview.frame)).to.equal(0);
            expect(CGRectGetMinX(subview.frame)).to.equal(CGRectGetMinX(superview.frame));
            expect(CGRectGetMaxY(subview.frame)).to.equal(CGRectGetMaxY(superview.frame));
            expect(CGRectGetMaxX(subview.frame)).to.equal(CGRectGetMaxX(superview.frame));
        });
        
        it(@"works with positive insets", ^{
            CGFloat inset = 10;
            
            [subview pinToSuperviewEdges:JRTViewPinTopEdge|JRTViewPinBottomEdge inset:inset];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeTop, inset));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeBottom, -inset));
            expect(superview.constraints).to.haveCountOf(2);
            
            CGRect expected = (CGRect) {
                .origin.x = CGRectGetMinY(superview.frame),
                .origin.y = inset,
                .size.width = 0,
                .size.height = CGRectGetHeight(superview.frame) - (inset * 2)
            };
            expect(subview).to.haveFrame(expected);
        });
        
        it(@"works with negative insets", ^{
            CGFloat inset = -10;
            
            [subview pinToSuperviewEdges:JRTViewPinTopEdge|JRTViewPinBottomEdge inset:inset];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeTop, inset));
            expect(superview).to.haveConstraint(JRTEdgeConstraintWithEdgeAndEqualInset(NSLayoutAttributeBottom, -inset));
            expect(superview.constraints).to.haveCountOf(2);
            
            CGRect expected = (CGRect) {
                .origin.x = CGRectGetMinY(superview.frame),
                .origin.y = inset,
                .size.width = 0,
                .size.height = CGRectGetHeight(superview.frame) - (inset * 2)
            };
            expect(subview).to.haveFrame(expected);
        });
    });
    
});

SpecEnd
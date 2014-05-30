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
        
        it(@"centers a view on both axes", ^{
            
            [subview centerInContainer];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterX));
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterY));
            
            expect(CGRectGetMinY(subview.frame)).to.equal(100);
        });
        
        it(@"centers a view within another view horizontally", ^{
            
            [subview centerInView:superview onAxis:NSLayoutAttributeCenterX];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterX));
            expect(superview).toNot.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterY));

            expect(subview.center.x).to.equal(150);
        });
        
        it(@"centers a view within another view vertically", ^{
            
            [subview centerInView:superview onAxis:NSLayoutAttributeCenterY];
            [superview layoutIfNeeded];
            
            expect(superview).to.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterY));
            expect(superview).toNot.haveConstraint(JRTCenterConstraintWithAxis(NSLayoutAttributeCenterX));

            expect(subview.center.y).to.equal(150);
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
    
    context(@"when pinning to a superview's edges", ^{
        
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
        
        it(@"uses a UIEdgeInsets value", ^{
            UIEdgeInsets insets = (UIEdgeInsets){.top = 10.0,.right = 20.0,.bottom = 30.0,.left = 40.0};
            [subview pinToSuperviewEdgesWithInset:insets];
            [superview layoutIfNeeded];
            expect(superview.constraints).to.haveCountOf(4);
            
            CGRect expected = UIEdgeInsetsInsetRect(superview.bounds, insets);
            expect(subview).to.haveFrame(expected);
        });
    });
    
    context(@"When pinning to layout guides", ^{
        it(@"uses the layout guides from the view controller",^{
            UIViewController *vc = [UIViewController new];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            
            UIView *view = [UIView autoLayoutView];
            [vc.view addSubview:view];
            [view pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinBottomEdge inset:0.0 usingLayoutGuidesFrom:vc];
            [navController.view layoutIfNeeded];
            XCTAssertNotNil(vc.topLayoutGuide);
            XCTAssertNotNil(vc.bottomLayoutGuide);
            expect(vc.view).to.haveConstraint([NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:vc.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]);
            expect(vc.view).to.haveConstraint([NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:vc.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]);
        });
    });

    context(@"when pinning attributes",^{

        __block UIView *view1 = nil;
        __block UIView *view2 = nil;

        beforeEach(^{
            superview = [UIView autoLayoutView];
            view1 = [UIView autoLayoutView];
            view2 = [UIView autoLayoutView];
            [superview addSubview:view1];
            [superview addSubview:view2];
        });

        it(@"pins one attribute to another",^{
            [view1 pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:view2];
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]);
        });

        it(@"pins one attribute to another using a constant",^{
            [view1 pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:view2 withConstant:10.0];
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]);
        });

        it(@"pins one attribute to another using a constant and relation",^{
            [view1 pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:view2 withConstant:10.0 relation:NSLayoutRelationGreaterThanOrEqual];
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]);
        });

        it(@"pins the same attributes",^{
            [view1 pinAttribute:NSLayoutAttributeTop toSameAttributeOfItem:view2];
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]);
        });

        it(@"pins the same attributes with a constant",^{
            [view1 pinAttribute:NSLayoutAttributeTop toSameAttributeOfItem:view2 withConstant:10.0];
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]);
        });
    });


    context(@"when pinning edges of peer views",^{

        __block UIView *view1 = nil;
        __block UIView *view2 = nil;

        beforeEach(^{
            superview = [UIView autoLayoutView];
            view1 = [UIView autoLayoutView];
            view2 = [UIView autoLayoutView];
            [superview addSubview:view1];
            [superview addSubview:view2];
            [superview constrainToSize:CGSizeMake(300.0,300.0)];
            [view1 constrainToSize:CGSizeMake(100.0, 100.0)];
            [view1 centerInView:superview];
        });

        it (@"pins the top edge",^{
            [view2 pinEdges:JRTViewPinTopEdge toSameEdgesOfView:view1];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]);
            XCTAssertEqual(100.0, CGRectGetMinY(view2.frame));
        });

        it (@"pins the left edge",^{
            [view2 pinEdges:JRTViewPinLeftEdge toSameEdgesOfView:view1];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]);
            XCTAssertEqual(100.0, CGRectGetMinX(view2.frame));
        });

        it (@"pins the bottom edge",^{
            [view2 pinEdges:JRTViewPinBottomEdge toSameEdgesOfView:view1];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]);
            XCTAssertEqual(200.0, CGRectGetMaxY(view2.frame));
        });

        it (@"pins the right edge",^{
            [view2 pinEdges:JRTViewPinRightEdge toSameEdgesOfView:view1];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]);
            XCTAssertEqual(200.0, CGRectGetMaxX(view2.frame));
        });

        it (@"pins a pair of edges",^{
            [view2 pinEdges:JRTViewPinTopEdge | JRTViewPinLeftEdge toSameEdgesOfView:view1];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]);
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]);
            XCTAssertEqual(100.0, CGRectGetMinY(view2.frame));
            XCTAssertEqual(100.0, CGRectGetMinX(view2.frame));
        });

        it (@"pins all edges",^{
            [view2 pinEdges:JRTViewPinAllEdges toSameEdgesOfView:view1];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]);
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]);
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]);
            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]);
            expect(view2).to.haveFrame(view1.frame);
        });

        it (@"pins the top edge with a positive inset",^{
            [view2 pinEdges:JRTViewPinTopEdge toSameEdgesOfView:view1 inset:10.0];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]);
            XCTAssertEqual(110.0, CGRectGetMinY(view2.frame));
        });

        it (@"pins the top edge with a negative inset",^{
            [view2 pinEdges:JRTViewPinTopEdge toSameEdgesOfView:view1 inset:-10.0f];
            [superview layoutIfNeeded];

            expect(superview).to.haveConstraint([NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10.0f]);
            XCTAssertEqual(90.0, CGRectGetMinY(view2.frame));
        });
    });

    context(@"when pinning specific points", ^{

        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subview = [UIView autoLayoutView];

            [superview addSubview:subview];

            [subview constrainToSize:CGSizeMake(100, 100)];
        });

        it(@"pins the left", ^{
            [subview pinPointAtX:NSLayoutAttributeLeft Y:NSLayoutAttributeNotAnAttribute toPoint:CGPointMake(10.0,0.0)];

            [superview layoutIfNeeded];
            XCTAssertEqual(10.0, CGRectGetMinX(subview.frame));
        });

        it(@"pins the center x", ^{
            [subview pinPointAtX:NSLayoutAttributeCenterX Y:NSLayoutAttributeNotAnAttribute toPoint:CGPointMake(10.0,0.0)];

            [superview layoutIfNeeded];
            XCTAssertEqual(10.0, CGRectGetMidX(subview.frame));
        });

        it(@"pins the right", ^{
            [subview pinPointAtX:NSLayoutAttributeRight Y:NSLayoutAttributeNotAnAttribute toPoint:CGPointMake(10.0,0.0)];

            [superview layoutIfNeeded];
            XCTAssertEqual(10.0, CGRectGetMaxX(subview.frame));
        });

        it(@"pins the top", ^{
            [subview pinPointAtX:NSLayoutAttributeNotAnAttribute Y:NSLayoutAttributeTop toPoint:CGPointMake(0.0,10.0)];

            [superview layoutIfNeeded];
            XCTAssertEqual(10.0, CGRectGetMinY(subview.frame));
        });

        it(@"pins the center y", ^{
            [subview pinPointAtX:NSLayoutAttributeNotAnAttribute Y:NSLayoutAttributeCenterY toPoint:CGPointMake(0.0,10.0)];

            [superview layoutIfNeeded];
            XCTAssertEqual(10.0, CGRectGetMidY(subview.frame));
        });

        it(@"pins the bottom", ^{
            [subview pinPointAtX:NSLayoutAttributeNotAnAttribute Y:NSLayoutAttributeBottom toPoint:CGPointMake(0.0,10.0)];

            [superview layoutIfNeeded];
            XCTAssertEqual(10.0, CGRectGetMaxY(subview.frame));
        });

        it(@"pins the baseline",^{
            UILabel *label = [UILabel autoLayoutView];
            label.text = @"TEXT";
            [superview addSubview:label];
            [label centerInContainerOnAxis:NSLayoutAttributeCenterX];

            [label pinPointAtX:NSLayoutAttributeNotAnAttribute Y:NSLayoutAttributeBaseline toPoint:CGPointMake(0.0,50.0)];
            [superview layoutIfNeeded];

            XCTAssertEqualWithAccuracy(50.0, CGRectGetMaxY(label.frame) + label.font.descender, 1.0);
        });

    });

    context(@"when spacing views", ^{

        __block UIView *view1 = nil;
        __block UIView *view2 = nil;
        __block UIView *view3 = nil;
        __block UIView *view4 = nil;
        __block NSArray *views = nil;

        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 410, 300)];
            view1 = [UIView autoLayoutView];
            view2 = [UIView autoLayoutView];
            view3 = [UIView autoLayoutView];
            view4 = [UIView autoLayoutView];
            views = @[view1,view2,view3,view4];

            [superview addSubview:view1];
            [superview addSubview:view2];
            [superview addSubview:view3];
            [superview addSubview:view4];
        });

        it(@"spaces the views with a set spacing", ^{
            [view1 pinToSuperviewEdges:JRTViewPinTopEdge inset:0.0];
            [superview spaceViews:views onAxis:UILayoutConstraintAxisHorizontal withSpacing:10.0 alignmentOptions:NSLayoutFormatAlignAllTop];
            [superview layoutIfNeeded];

            [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                XCTAssertEqual(view.frame.size.width,90.0);
                XCTAssertEqual(CGRectGetMinX(view.frame),10.0 + idx * 100);
            }];

        });

        it(@"spaces the views at regular points", ^{
            superview.frame = CGRectMake(0, 0, 400, 300);
            [view1 pinToSuperviewEdges:JRTViewPinTopEdge inset:0.0];
            [superview spaceViews:views onAxis:UILayoutConstraintAxisHorizontal];
            [superview layoutIfNeeded];

            CGFloat unitSize = CGRectGetWidth(superview.frame) / ([views count] + 1.0f);

            [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                XCTAssertEqual(CGRectGetMidX(view.frame),unitSize * (idx + 1));
            }];

        });

        it(@"allows the first item to have flexible width",^{
            superview.frame = CGRectMake(0,0,320,300);
            views = @[view1,view2,view3];
            [view1 pinToSuperviewEdges:JRTViewPinTopEdge inset:0.0];
            [superview spaceViews:views onAxis:UILayoutConstraintAxisHorizontal withSpacing:0.0 alignmentOptions:NSLayoutFormatAlignAllTop flexibleFirstItem:YES];

            XCTAssertEqual(CGRectGetWidth(view2.frame), CGRectGetWidth(view3.frame));
            XCTAssertEqualWithAccuracy(CGRectGetWidth(view1.frame), CGRectGetWidth(view2.frame), 1.0f);


        });
        
        it(@"doesnt space the edges", ^{
            [view1 pinToSuperviewEdges:JRTViewPinTopEdge inset:0.0];
            [superview spaceViews:views onAxis:UILayoutConstraintAxisHorizontal withSpacing:10.0 alignmentOptions:NSLayoutFormatAlignAllTop flexibleFirstItem:NO applySpacingToEdges:NO];
            [superview layoutIfNeeded];
            
            [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                XCTAssertEqual(view.frame.size.width, 95.0);
                XCTAssertEqual(CGRectGetMinX(view.frame),(idx * 95) + (10.0 * idx));
            }];
            
        });

    });

});

SpecEnd
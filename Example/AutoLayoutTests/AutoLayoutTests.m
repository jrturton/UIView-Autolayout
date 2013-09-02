//
//  AutoLayoutTests.m
//  AutoLayoutTests
//
//  Created by James Frost on 10/08/2013.
//  Copyright (c) 2013 James Frost. All rights reserved.
//


#import <Specta/Specta.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "EXPMatchers+haveConstraint.h"
#import "EXPMatchers+haveFrame.h"


#import "UIView+AutoLayout.h"


SpecBegin(AutoLayoutSpec)

describe(@"AutoLayout helpers", ^{
   
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
            
            expect(subview.frame.origin.x).to.equal(100);
        });

        it(@"centers a view vertically", ^{

            [subview centerInContainerOnAxis:NSLayoutAttributeCenterY];
            [superview layoutIfNeeded];
            
            expect(subview.frame.origin.y).to.equal(100);
        });

        it(@"centers a view within another view", ^{
           
            [subview centerInView:superview];
            [superview layoutIfNeeded];
            
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

            expect(subview.bounds.size.width).will.equal(100);
            expect(subview.bounds.size.height).will.equal(0);
        });
        
        it(@"constrains just the height", ^{
            [subview constrainToSize:CGSizeMake(0, 100)];
            [superview layoutIfNeeded];
            
            expect(subview.bounds.size.width).will.equal(0);
            expect(subview.bounds.size.height).will.equal(100);
        });
        
        it(@"constrains both width and height", ^{
            [subview constrainToSize:CGSizeMake(100, 100)];
            [superview layoutIfNeeded];
            
            expect(subview.bounds.size.width).will.equal(100);
            expect(subview.bounds.size.height).will.equal(100);
        });
    });
});

SpecEnd

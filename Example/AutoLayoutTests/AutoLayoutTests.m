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

#import "UIView+AutoLayout.h"


SpecBegin(AutoLayoutSpec)

describe(@"AutoLayout helpers", ^{
   
    context(@"when centering views", ^{
        __block UIView *superview = nil;
        __block UIView *subview = nil;
        
        beforeEach(^{
            superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
            subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [superview addSubview:subview];
        });
        
        NSLayoutConstraint *(^centerConstraintWithAxis)(NSLayoutAttribute) = ^ NSLayoutConstraint * (NSLayoutAttribute axis) {
            return [NSLayoutConstraint constraintWithItem:subview
                                                attribute:axis
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:superview
                                                attribute:axis multiplier:1.0f constant:0];
        };
        
        it(@"centers a view horizontally", ^{

            [subview centerInContainerOnAxis:NSLayoutAttributeCenterX];

            expect(superview).to.haveConstraint(centerConstraintWithAxis(NSLayoutAttributeCenterX));
        });

        it(@"centers a view vertically", ^{
            
            [subview centerInContainerOnAxis:NSLayoutAttributeCenterY];

            expect(superview).to.haveConstraint(centerConstraintWithAxis(NSLayoutAttributeCenterY));
        });

        it(@"centers a view within another view", ^{
           
            [subview centerInView:superview];
        });
        
    });
    
});

SpecEnd
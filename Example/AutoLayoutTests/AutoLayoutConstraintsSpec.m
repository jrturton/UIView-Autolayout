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

SpecBegin(AutoLayoutConstraints)

describe(@"AutoLayout constraints", ^{
    
    it(@"passes this test", ^{
        expect(YES).to.beFalsy();
    });
    
});

SpecEnd
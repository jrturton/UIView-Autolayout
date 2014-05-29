//
//  EXPMatchers+haveConstraint.m
//  AutoLayoutDemo
//
//  Created by James Frost on 10/08/2013.
//  Copyright (c) 2013 James Frost. All rights reserved.
//

#import "EXPMatchers+haveConstraint.h"

EXPMatcherImplementationBegin(haveConstraint, (NSLayoutConstraint *expected)) {
    BOOL actualIsNil = (actual == nil);
    BOOL expectedIsNil = (expected == nil);
    
    prerequisite(^BOOL{
        return !(actualIsNil || expectedIsNil);
        // Return `NO` if matcher should fail whether or not the result is inverted using `.Not`.
    });
    
    match(^BOOL{
        NSArray *constraints = ((UIView *)actual).constraints;

        __block BOOL matchFound = NO;
        
        [constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSLayoutConstraint *actualConstraint = (NSLayoutConstraint *)obj;
            BOOL firstAttributeMatches  = (expected.firstAttribute == actualConstraint.firstAttribute);
            BOOL firstItemMatches       = (expected.firstItem == actualConstraint.firstItem);
            BOOL secondAttributeMatches = (expected.secondAttribute == actualConstraint.secondAttribute);
            BOOL secondItemMatches      = (expected.secondItem == actualConstraint.secondItem);
            BOOL constantMatches        = (expected.constant == actualConstraint.constant);
            BOOL multiplierMatches      = (expected.multiplier == actualConstraint.multiplier);
            BOOL relationMatches        = (expected.relation == actualConstraint.relation);
            
            matchFound = firstAttributeMatches
                         && firstItemMatches
                         && secondAttributeMatches
                         && secondItemMatches
                         && constantMatches
                         && multiplierMatches
                         && relationMatches;
            
            *stop = matchFound;
        }];
        
        return matchFound;
    });
    
    failureMessageForTo(^NSString *{
        if(actualIsNil) return @"the actual view is nil/null";
        if(expectedIsNil) return @"the expected constraint is nil/null";
        return [NSString stringWithFormat:@"expected: view to have a constraint %@, "
                "got: a view with constraints %@, which does not contain constraint %@",
                expected, [actual constraints], expected];
    });
    
    failureMessageForNotTo(^NSString *{
        if(actualIsNil) return @"the actual view is nil/null";
        if(expectedIsNil) return @"the expected constraint is nil/null";
        return [NSString stringWithFormat:@"expected: view not to have a constraint %@, "
                "got: a view with constraints %@, which contains constraint %@",
                expected, [actual constraints], expected];
    });
}
EXPMatcherImplementationEnd
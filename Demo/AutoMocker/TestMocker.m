//
//  TestMocker.m
//  HNetworkAutoMock
//
//  Created by zct on 2017/5/8.
//  Copyright © 2017年 zct. All rights reserved.
//

#import "TestMocker.h"

@implementation TestMocker
+ (instancetype)shared
{
    static dispatch_once_t pred;
    static TestMocker *o = nil;
    
    dispatch_once(&pred, ^{ o = [[self alloc] init]; });
    return o;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textSeed = @"PARIS Centrist former economy minister Emmanuel Macron has won the French presidential election defeating his far-right rival Marine Le Pen in Sunday's runoff vote making him the youngest president in France's modern history according to polling agency projections The projections indicate that Macron garnered between 65 to 661 percent of votes and Le Pen between 339 to 35 percent Official results with more details to be published in days by the Constitutional Council are for sure to be in accordance with the current estimation Thousands of the independent winner's supporters gathered in high spirit at the courtyard outside the Louvre Museum in central Paris where a grand celebration for his victory has been planned for the whole night The joyful crowd waved French and the European Union EU flags mirroring Macron's pro-EU position and vision for the European integration A new page of history is starting today I want this page to be one of hope and trust  said Macron in a winning speech in his En Marche On the Move  movement's headquarters It's a great honor and a great responsibility I will do everything I can to not let you down  he added with a stern tone My responsibility will be to ease fears My responsibility will be to unite all the women and men ready to face the gigantic challenges that await us  he said Macron then joined his supporters outside the Louvre Museum where he also delivered a passionate speech calling for braveness and unity";
    }
    return self;
}
@end

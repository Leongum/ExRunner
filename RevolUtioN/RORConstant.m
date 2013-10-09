//
//  RORConstant.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORConstant.h"

@implementation RORConstant

NSString * const MissionTypeEnum_toString[] = {
    @"Challenge",
    @"Recommand",
    @"Cycle",
    @"SubCycle",
    @"Normal"
};

NSString * const MissionGradeEnum_toString[] = {
    @"S",
    @"A",
    @"B",
    @"C",
    @"D",
    @"E",
    @"F"
};

NSString * const MissionGradeImageEnum_toString[] = {
    @"stamp_s.png",
    @"stamp_a.png",
    @"stamp_b.png",
    @"stamp_c.png",
    @"stamp_d.png",
    @"stamp_e.png",
    @"stamp_f.png"
};

NSString * const MissionGradeCongratsImageEnum_toString[] = {
    @"S.png",
    @"A.png",
    @"B.png",
    @"C.png",
    @"D.png",
    @"E.png",
    @"F.png"
};

+(NSString *)SoundNameForSpecificGrade:(MissionGradeEnum)grade{
    if (grade == GRADE_S)
        return @"challenge_S.m4a";
    if (grade == GRADE_F)
        return @"challenge_F.m4a";
    return @"challenge_normal.m4a";
}

@end

//
//  bedGroup.hpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#ifndef bedGroup_hpp
#define bedGroup_hpp

#include <stdio.h>
#include <set>

#include "bedInfo.h"
#include "CNVInfo.hpp"

class bedGroup{
private:
    std::set<bedInfo> bedAll;
    std::set<bedInfo> combinedBed;
    std::set<bedInfo> sor;
    
    bool idxCombined;
    bool idxSOR;
    
public:
    bedGroup();
    bool add(bedInfo bed);
    bool add(CNVInfo cnv);
    
    std::set<bedInfo> getCombinedBed();
    std::set<bedInfo> getSOR();
};

#endif /* bedGroup_hpp */

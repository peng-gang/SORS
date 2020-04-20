//
//  CNVSample.hpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#ifndef CNVSample_hpp
#define CNVSample_hpp

#include <stdio.h>
#include <string>
#include <set>
#include "CNVInfo.hpp"
#include <vector>

class CNVSample{
private:
    std::string id;
    std::set<CNVInfo> cnvs;
    
public:
    CNVSample();
    CNVSample(std::string id);
    std::string getId() const {return id;}
    std::set<CNVInfo> getCNVs() {return cnvs;}
    
    bool addCNV(CNVInfo cnv);
    std::vector<double> getSORRatio(std::set<bedInfo> sor);
};

#endif /* CNVSample_hpp */

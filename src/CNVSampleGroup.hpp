//
//  CNVSampleGroup.hpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/8/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#ifndef CNVSampleGroup_hpp
#define CNVSampleGroup_hpp

#include <stdio.h>
#include <string>

#include "CNVSample.hpp"
#include "bedGroup.hpp"
#include <map>


class CNVSampleGroup{
private:
    std::map<std::string, CNVSample> samples;
    bedGroup bg;
    
    std::set<bedInfo> sor;
    std::vector<std::vector<double>> sorRatios;
    
    
public:
    CNVSampleGroup();
    //bool add(std::string id, CNVSample sample);
    bool add(std::string id, CNVInfo cnvInfo);
    bool add(std::string fline);
    
    std::set<bedInfo> getCombinedBed();
    std::set<bedInfo> getSOR();
    
    std::string output();
    
    void initSORRatio();
    
    friend std::ostream & operator << (std::ostream & os, CNVSampleGroup & csg);
};

#endif /* CNVSampleGroup_hpp */

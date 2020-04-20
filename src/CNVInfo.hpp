//
//  CNVInfo.hpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#ifndef CNVInfo_hpp
#define CNVInfo_hpp

#include <stdio.h>
#include <string>
#include "bedInfo.h"

class CNVInfo : public bedInfo{
private:
    //0, 1: loss
    //2: normal
    //3 or more gain
    double ratio;
    
public:
    CNVInfo();
    CNVInfo(int c, int s, int e, bool w, double ratio);
    CNVInfo(std::string fline);
    bool setRatio(double ratio);
    double getRatio() const {return ratio;}
    
};

#endif /* CNVInfo_hpp */

//
//  CNVSample.cpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#include "CNVSample.hpp"

using namespace std;

CNVSample::CNVSample(){
    id = "";
    cnvs.clear();
}

CNVSample::CNVSample(string id){
    this->id = id;
    cnvs.clear();
}

bool CNVSample::addCNV(CNVInfo cnv){
    cnvs.insert(cnv);
    return true;
}

std::vector<double> CNVSample::getSORRatio(std::set<bedInfo> sor){
    vector<double> rlt;
    for(set<bedInfo>::iterator it = sor.begin(); it!=sor.end(); it++){
        bool found = false;
        for(set<CNVInfo>::iterator it2 = cnvs.begin(); it2!=cnvs.end(); it2++){
            if(it2->contain(*it)){
                rlt.push_back(it2->getRatio());
                found=true;
                break;
            }
        }
        if(!found){
            rlt.push_back(1.0);
        }
    }
    return rlt;
}



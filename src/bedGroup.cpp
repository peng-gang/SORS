//
//  bedGroup.cpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#include "bedGroup.hpp"
using namespace std;

bedGroup::bedGroup(){
    idxCombined = false;
    idxSOR = false;
    bedAll.clear();
    combinedBed.clear();
    sor.clear();
}

bool bedGroup::add(bedInfo bed){
    bedAll.insert(bed);
    idxSOR=false;
    idxCombined=false;
    
    return true;
}

bool bedGroup::add(CNVInfo cnv){
    bedInfo tmp = bedInfo(cnv.getChr(), cnv.getStart(), cnv.getEnd(), cnv.getWithChr());
    bedAll.insert(tmp);
    idxSOR=false;
    idxCombined=false;
    
    return true;
}

set<bedInfo> bedGroup::getCombinedBed(){
    if(idxCombined){
        return combinedBed;
    }
    combinedBed.clear();
    
    bedInfo currentPos;
    for(set<bedInfo>::iterator it = bedAll.begin(); it != bedAll.end(); it++){
        if(it == bedAll.begin()){
            currentPos = *it;
            continue;
        }
        
        if(currentPos.getChr()==it->getChr()){
            if(currentPos.getEnd() >= (it->getStart()-1) ){
                currentPos.setEnd(max(currentPos.getEnd(), it->getEnd()));
                continue;
            } else {
                combinedBed.insert(currentPos);
                currentPos = *it;
            }
        } else {
            combinedBed.insert(currentPos);
            currentPos = *it;
        }
    }
    combinedBed.insert(currentPos);
    idxCombined = true;
    
    return combinedBed;
}

set<bedInfo> bedGroup::getSOR(){
    if(idxSOR){
        return sor;
    }
    sor.clear();
    
    if(!idxCombined){
        this->getCombinedBed();
    }
    
    for(set<bedInfo>::iterator it = combinedBed.begin(); it!=combinedBed.end(); it++){
        set<int> pos;
        pos.insert(it->getStart());
        pos.insert(it->getEnd());
        for(set<bedInfo>::iterator it2 = bedAll.begin(); it2!=bedAll.end(); it2++){
            if(it->getChr() == it2->getChr()){
                if(it->contain(*it2)){
                    pos.insert(it2->getStart());
                    pos.insert(it2->getEnd());
                } else {
                    continue;
                }
            } else {
                continue;
            }
        }
        
        set<int> :: iterator it2 = pos.begin();
        while (true) {
            int s = *it2;
            it2++;
            if(it2==pos.end()){
                break;
            }
            int e = *it2;
            sor.insert(bedInfo(it->getChr(), s, e, it->getWithChr()));
        }
    }
    
    idxSOR=true;
    return sor;
}









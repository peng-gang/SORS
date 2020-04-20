//
//  CNVInfo.cpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#include "CNVInfo.hpp"

using namespace std;

CNVInfo::CNVInfo() : bedInfo(){
    ratio = 1.0;
}

CNVInfo::CNVInfo(int c, int s, int e, bool w, double ratio) : bedInfo(c, s, e, w){
    this->ratio = ratio;
}

bool CNVInfo::setRatio(double ratio){
    this->ratio = ratio;
    return true;
}

CNVInfo::CNVInfo(string fline){
    string chrTmp;
    istringstream iss(fline);
    int chr, start, end;
    bool withChr;
    iss >> chrTmp;
    iss >> start;
    iss >> end;
    iss >> ratio;
    transform(chrTmp.begin(), chrTmp.end(), chrTmp.begin(), ::toupper);
    if(chrTmp.substr(0,3) == "CHR"){
        withChr=true;
        chrTmp = chrTmp.substr(3);
    } else {
        withChr=false;
    }
    if(chrTmp=="X"){
        chr=23;
    } else if(chrTmp=="Y"){
        chr=24;
    } else if(chrTmp=="MT"){
        chr = 25;
    } else{
        chr = atoi(chrTmp.c_str());
    }
    bedInfo(chr, start, end, withChr);
}



//
//  bedInfo.cpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/7/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#include <sstream>

#include "bedInfo.h"

using namespace std;

bedInfo::bedInfo(){
    chr = 0;
    start = 0;
    end = 0;
    withChr = false;
}

bedInfo::bedInfo(int c, int s, int e, bool w){
    chr = c;
    start = s;
    end = e;
    withChr = w;
}


bedInfo::bedInfo(string fline){
    string chrTmp;
    istringstream iss(fline);
    iss >> chrTmp;
    iss >> start;
    iss >> end;
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
}

bool bedInfo::setChr(int c){
    chr = c;
    return true;
}

bool bedInfo::setStart(int s){
    start = s;
    return true;
}

bool bedInfo::setEnd(int e){
    end = e;
    return true;
}

bool bedInfo::setWithChr(bool w){
    withChr = w;
    return true;
}


bool bedInfo::contain(bedInfo bi) const{
    if(chr == bi.getChr()){
        if(start<=bi.getStart() && end >= bi.getEnd()){
            return true;
        } else {
            return false;
        }
    } else{
        return false;
    }
}

bool bedInfo::overlap(bedInfo bi) const{
    if(chr==bi.getChr()){
        if(start>=bi.getEnd() || end<=bi.getStart()){
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}

bedInfo & bedInfo::operator= (const bedInfo & other){
    if(this == &other){
        return *this;
    }
    
    chr = other.chr;
    start = other.start;
    end = other.end;
    withChr = other.withChr;
    
    return *this;
    
}

bool bedInfo::operator< (const bedInfo & other) const{
    if(chr < other.chr){
        return true;
    } else if(chr == other.chr) {
        if(start < other.start){
            return true;
        } else if(start == other.start){
            return (end < other.end);
        } else {
            return false;
        }
    } else {
        return false;
    }
}

ostream & operator<< (ostream & os, const bedInfo & bi){
    if(bi.chr==23){
        if(bi.withChr){
            os << "chrX";
        } else{
            os << "X";
        }
    } else if (bi.chr == 24){
        if(bi.withChr){
            os << "chrY";
        } else{
            os << "Y";
        }
    } else if(bi.chr == 25){
        os << "MT";
    } else {
        if(bi.withChr){
            os << "chr" << bi.chr;
        } else {
            os << bi.chr;
        }
    }
    
    os << "\t" << bi.start << "\t" <<bi.end;
    return os;
}

string bedInfo::output() const{
    string rlt;
    
    if(chr==23){
        if(withChr){
            rlt = "chrX";
        } else{
            rlt = "X";
        }
    } else if (chr == 24){
        if(withChr){
            rlt = "chrY";
        } else{
            rlt = "Y";
        }
    } else if(chr == 25){
        rlt = "MT";
    } else {
        if(withChr){
            rlt =  "chr" + to_string(chr);
        } else {
            rlt = to_string(chr);
        }
    }
    
    rlt = rlt + "\t" + to_string(start) + "\t" + to_string(end);
    
    return rlt;
}

//
//  CNVSampleGroup.cpp
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/8/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#include <sstream>
#include "CNVSampleGroup.hpp"
#include <iostream>


using namespace std;

CNVSampleGroup::CNVSampleGroup(){
    samples.clear();
    sorRatios.clear();
}

/*
bool CNVSampleGroup::add(std::string id, CNVSample sample){
    map<string, CNVSample>::iterator it = samples.find(id);
    if(it==samples.end()){
        samples.insert(pair<string, CNVSample> (id, sample));
    } else {
        for(set<CNVInfo>::iterator it2 = sample.getCNVs().begin(); it2 != sample.getCNVs().end(); it2++){
            it->second.addCNV(*it2);
        }
    }
    return true;
}
 */

bool CNVSampleGroup::add(std::string id, CNVInfo cnvInfo){
    map<string, CNVSample>::iterator it = samples.find(id);
    if(it==samples.end()){
        CNVSample tmp = CNVSample(id);
        tmp.addCNV(cnvInfo);
        samples.insert(pair<string, CNVSample> (id, tmp));
        bg.add(cnvInfo);
    } else {
        it->second.addCNV(cnvInfo);
        bg.add(cnvInfo);
    }
    sorRatios.clear();
    return true;
}

bool CNVSampleGroup::add(std::string fline){
    string chrTmp;
    int chr, start, end;
    bool withChr;
    double ratios;
    string id;
    istringstream iss(fline);
    iss >> chrTmp;
    iss >> start;
    iss >> end;
    iss >> ratios;
    iss >> id;
    if(id==""){
        cout<<fline<<endl;
    }
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
    
    CNVInfo tmp = CNVInfo(chr, start, end, withChr, ratios);
    add(id, tmp);
    bg.add(tmp);

    sorRatios.clear();
    return true;
}

set<bedInfo> CNVSampleGroup::getCombinedBed(){
    return bg.getCombinedBed();
}

set<bedInfo> CNVSampleGroup::getSOR(){
    return bg.getSOR();
}
void CNVSampleGroup::initSORRatio(){
    sorRatios.clear();
    sor = bg.getSOR();
    for(map<string, CNVSample>::iterator it = samples.begin(); it!=samples.end(); it++){
        sorRatios.push_back(it->second.getSORRatio(sor));
    }
}


string CNVSampleGroup::output(){
    string rlt;
    rlt = "Chr\tStart\tEnd";
    for(map<string, CNVSample>::iterator it = samples.begin(); it != samples.end(); it++){
        rlt = rlt + "\t"  + it->first;
    }
    rlt = rlt + "\n";
    
    int idxSOR = 0;
    for(set<bedInfo>::iterator it = sor.begin(); it != sor.end(); it++){
        rlt = rlt + it->output();
        for(size_t i=0; i<sorRatios.size(); i++){
            rlt = rlt + "\t" + to_string(sorRatios[i][idxSOR]);
        }
        rlt = rlt + "\n";
        idxSOR++;
    }
    
    return rlt;
}

ostream & operator<< (ostream & os, CNVSampleGroup & csg){
    os <<"Chr\tStart\tEnd";
    for(map<string, CNVSample>::iterator it = csg.samples.begin(); it != csg.samples.end(); it++){
        os <<"\t" <<it->first;
    }
    os <<endl;
    int idxSOR = 0;
    for(set<bedInfo>::iterator it = csg.sor.begin(); it != csg.sor.end(); it++){
        os << *it;
        for(size_t i=0; i<csg.sorRatios.size(); i++){
            os<<"\t" << csg.sorRatios[i][idxSOR];
        }
        os <<endl;
        idxSOR++;
    }
    return os;
}








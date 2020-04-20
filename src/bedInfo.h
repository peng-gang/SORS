//
//  bedInfo.h
//  SmallestOverlapRegion
//
//  Created by Gang Peng on 11/6/18.
//  Copyright © 2018 Gang Peng. All rights reserved.
//

#ifndef bedInfo_h
#define bedInfo_h

#include <sstream>
#include <string>

//the start and end definition follow the USCS bed format definition
//The first base in a chromosome is numbered 0.
//The chromEnd base is not included in the display of the feature.
//For example, the first 100 bases of a chromosome are defined as chromStart=0, chromEnd=100,
//and span the bases numbered 0-99.

class bedInfo{
private:
    int chr;
    int start;
    int end;
    bool withChr;
    
public:
    bedInfo();
    bedInfo(int c, int s, int e, bool w);
    bedInfo(std::string fline);
    
    int getChr() const { return chr;}
    int getStart() const { return start;}
    int getEnd() const { return end; }
    bool getWithChr() const { return withChr; }
    
    bool setChr(int c);
    bool setStart(int s);
    bool setEnd(int e);
    bool setWithChr(bool w);
    
    bool contain(bedInfo bi) const;
    bool overlap(bedInfo bi) const;
    
    std::string output() const;
    
    bedInfo & operator= (const bedInfo & other);
    bool operator < (const bedInfo & other) const;
    friend std::ostream & operator << (std::ostream & os, const bedInfo & pi);
};


#endif /* bedInfo_h */

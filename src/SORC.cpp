
#include <Rcpp.h>
#include "normal.h"
#include "CNVSampleGroup.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::DataFrame getSORC(Rcpp::CharacterVector cnvInfo) {

  CNVSampleGroup csg;
  for(int i=0; i< cnvInfo.size(); i++){
    csg.add(Rcpp::as<std::string>(cnvInfo[i]));
  }
  
  csg.initSORRatio();
  
  //Rcout << csg.output() << std::endl;
  
  std::string strRlt = csg.output();
  std::vector<std::string> vs = split(strRlt, "\n");
  std::vector<std::string> vsHeader = split(vs[0], "\t");
  
  std::vector<std::vector<std::string> > vvRlt;
  for(std::size_t i=0; i<vsHeader.size(); i++){
    std::vector<std::string> tmp;
    vvRlt.push_back(tmp);
  }
  for(std::size_t i=1; i<vs.size(); i++){
    std::vector<std::string> vsTmp = split(vs[i], "\t");
    for(std::size_t j=0; j<vsTmp.size(); j++){
      vvRlt[j].push_back(vsTmp[j]);
    }
  }
  
  
  Rcpp::DataFrame rlt = Rcpp::DataFrame::create(
    Named(vsHeader[0]) = Rcpp::wrap(vvRlt[0]),
    Named(vsHeader[1]) = Rcpp::wrap(vvRlt[1]),
    Named(vsHeader[2]) = Rcpp::wrap(vvRlt[2])
  );
  
  for(std::size_t i=3; i<vsHeader.size(); i++){
    rlt.push_back(Rcpp::wrap(vvRlt[i]), vsHeader[i]);
  }
  
  return rlt;
}

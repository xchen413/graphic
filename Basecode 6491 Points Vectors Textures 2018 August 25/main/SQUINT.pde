PNT SQUINT(PNT A,PNT B,PNT C, PNT D, float u,float v){

  
  SIMILARITY SU = new SIMILARITY (A,B,D,C);
  PNT F = SU.F;
  float MU = SU.lambda;
  float AU = SU.alpha;
  
  SIMILARITY SV = new SIMILARITY (A,D,B,C);

  float MV = SV.lambda;
  float AV = SV.alpha;
  
  return P(F,pow(MU,u)*pow(MV,v),Rotated(V(F,A),(u*AU+v*AV)));
}


void showSM(PNT A,PNT B,PNT C, PNT D,float u,float v){

  
  beginShape();
  for(float t=0; t<1.05;t+=0.05){
    vert(SQUINT(A,B,C,D,t,v));
  }
  endShape();
  beginShape();
    for(float t=0; t<1.05;t+=0.05){
    vert(SQUINT(A,B,C,D,u,t));
  }
  endShape();
}

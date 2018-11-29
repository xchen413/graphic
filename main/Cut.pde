boolean SegmentIntersect(pt p1, pt p2, pt p3, pt p4){
  boolean intersect = false;
  vec va = V(p1,p2);
  vec vb = V(p3,p4);
  pt A = P();
  A.setTo(p1);
  pt B = P();
  B.setTo(p3);
 
  float KA = -1; float KB = -1;
  if(!parallel(va,vb)){
    KA = d(N(V(A,B),vb),N(va,vb))/d(N(va,vb),N(va,vb));
    KB = d(N(V(B,A),va),N(vb,va))/d(N(vb,va),N(vb,va));
  }
  if((KA >=0)&&(KA <= 1)){
    if((KB >=0)&&(KB <= 1)){
      intersect = true;
    }
  }
  return intersect;
}

float DistancePtoE(pt A, pt B,pt P){
  float d=0;
  if((d(V(A,B),V(A,P))>=0)&&(d(V(B,A),V(B,P))>=0)){
    d = det3(V(A,B),V(A,P));
  }
  else{
    d = min(norm(V(A,P)),norm(V(B,P)));
  }
  return d;
}

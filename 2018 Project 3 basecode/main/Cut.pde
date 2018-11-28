boolean SegmentIntersect(pt p1, pt p2, pt p3, pt p4){
  boolean intersect = false;
  vec va = V(p1,p2);
  vec vb = V(p3,p4);
  pt A = p1;
  pt B = p3;
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

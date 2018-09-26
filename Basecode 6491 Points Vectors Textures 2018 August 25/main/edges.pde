class EDGE // POINT
  { 
  PNT A=P(), B=P(); // Start and End vertices
  EDGE (PNT P, PNT Q) {A.setTo(P); B.setTo(Q);}; // Creates edge
  PNT PNTnearB() {return P(B,20,Normalized(V(A,B)));}
  }
EDGE E (PNT P, PNT Q) {return new EDGE(P,Q);}

void drawEdge(EDGE E) {drawEdge(E.A,E.B);} 
void drawEdgeAsArrow(EDGE E) {arrow(E.A,E.B);} 

EDGE LERP(EDGE E0, float t, EDGE E1) // LERP between EDGE endpoints
  {
  PNT At = LERP(E0.A,time,E1.A); 
  PNT Bt = LERP(E0.B,time,E1.B);
  return E(At,Bt);
  }


   
class SIMILARITY{
  PNT F = P() ;
  float lambda = 0.0;
  float alpha = 0.0;
  
  PNT apply(PNT A,float t){
    return P(F,pow(lambda,t),Rotated(V(F,A),t*alpha));
  }
  
  SIMILARITY(){};
  SIMILARITY (PNT A0,PNT B0, PNT A1, PNT B1){
    VCT V0 = V(A0,B0);
    VCT V1 = V(A1,B1);
    VCT AC = V(A0,A1);
    float m = normOf(V1)/normOf(V0);
    float a = angle(V0,V1);
    float c = cos(a), s=sin(a);
    VCT ACo = Rotated(AC);
    VCT U = Sum(m*c-1,AC,m*s,ACo);
    float u2 = dot(U,U);
    float x = - dot (AC,U)/u2;
    float y = det (AC,U)/u2;
    PNT F1 = P(A0,Sum(x,AC,y,ACo));
  
    F = F1;
    lambda = m;
    alpha = a;

  }
} 

void showSpiral(PNT A0, PNT B0, PNT A1,PNT B1){
    SIMILARITY S = new SIMILARITY(A0,B0,A1 ,B1);

    beginShape();
      for(float t=0;t<=1.05;t+=0.05)

        vert(S.apply(B0,t));
    endShape();
    beginShape();
      for(float t=0;t<=1.05;t+=0.05)

        vert(S.apply(A0,t));
    endShape();
}

//void showSpiralPattern(PNT A0,PNT B0,PNT A1,PNT B1){
//   SIMILARITY S = new SIMILARITY(A0,B0,A1,B1);
//   beginShape();
//     for(float t=0.05;t<0.99;t+=0.05)
//       E(S.apply(A0,t),S.apply(B0,t));
//   endShape();
//}

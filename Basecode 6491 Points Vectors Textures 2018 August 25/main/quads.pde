void  LERPquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time,int i)
  {


  
  PNT A1 =P();
  PNT B1 =P();
  PNT C1 =P();
  PNT D1 =P();
  PNT A0 =P();
  PNT B0 =P();
  PNT C0 =P();
  PNT D0 =P();
  

  A0.setTo(Point[i]);
  B0.setTo(Point[i+1]);
  C0.setTo(Point[i+2]);
  D0.setTo(Point[i+3]);
  
  A1.setTo(Point[(i+4)%16]);
  B1.setTo(Point[(i+5)%16]);
  C1.setTo(Point[(i+6)%16]);
  D1.setTo(Point[(i+7)%16]);
  
  A.setTo(LERP(A0,time,A1));
  B.setTo(LERP(B0,time,B1));
  C.setTo(LERP(C0,time,C1));
  D.setTo(LERP(D0,time,D1));
  }

void LPMquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time,int i){
 // int i = 0;
  PNT A1 =P();
  PNT B1 =P();
  PNT C1 =P();
  PNT D1 =P();
  PNT A0 =P();
  PNT B0 =P();
  PNT C0 =P();
  PNT D0 =P();
  

  A0.setTo(Point[i]);
  B0.setTo(Point[i+1]);
  C0.setTo(Point[i+2]);
  D0.setTo(Point[i+3]);
  
  A1.setTo(Point[(i+4)%16]);
  B1.setTo(Point[(i+5)%16]);
  C1.setTo(Point[(i+6)%16]);
  D1.setTo(Point[(i+7)%16]);
  
  
  
  SIMILARITY SAB= new SIMILARITY(A0,B0,A1,B1);
  
  //println("A0.x = .2f%\n",A0.x);
  //println("A0.x = .2f%\n",A1.x);  
  PNT At1 =SAB.apply(A0,time);
  PNT Bt1 =SAB.apply(B0,time);
  //println("At1.x = .2f%\n",At1.x);
  //println("time = .2f%\n",time);
  SIMILARITY SAD = new SIMILARITY(A0,D0,A1,D1);
  PNT At2 =SAD.apply(A0,time);
  PNT Dt1 =SAD.apply(D0,time);
  //println("At2.x = .2f%\n",At2.x);
  SIMILARITY SBC= new SIMILARITY(B0,C0,B1,C1);
  PNT Bt2 =SBC.apply(B0,time);
  PNT Ct1 =SBC.apply(C0,time);
  
  SIMILARITY SCD= new SIMILARITY(C0,D0,C1,D1);
  PNT Ct2 =SCD.apply(C0,time);
  PNT Dt2 =SCD.apply(D0,time);
  

  
  A.x = (At1.x+At2.x)/2;
  A.y = (At1.y+At2.y)/2;
  B.x = (Bt1.x+Bt2.x)/2;
  B.y = (Bt1.y+Bt2.y)/2;
  C.x = (Ct1.x+Ct2.x)/2;
  C.y = (Ct1.y+Ct2.y)/2;
  D.x = (Dt1.x+Dt2.x)/2;
  D.y = (Dt1.y+Dt2.y)/2;
  
  
}

void showSpiralquad(PNT[] Point,int i){
  PNT A1 =P();
  PNT B1 =P();
  PNT C1 =P();
  PNT D1 =P();
  PNT A0 =P();
  PNT B0 =P();
  PNT C0 =P();
  PNT D0 =P();
  A0.setTo(Point[i]);
  B0.setTo(Point[i+1]);
  C0.setTo(Point[i+2]);
  D0.setTo(Point[i+3]);
  A1.setTo(Point[(i+4)%16]);
  B1.setTo(Point[(i+5)%16]);
  C1.setTo(Point[(i+6)%16]);
  D1.setTo(Point[(i+7)%16]);
  
  SIMILARITY SAB= new SIMILARITY(A0,B0,A1,B1);
  SIMILARITY SAD = new SIMILARITY(A0,D0,A1,D1);
  SIMILARITY SBC= new SIMILARITY(B0,C0,B1,C1);    
  SIMILARITY SCD= new SIMILARITY(C0,D0,C1,D1);
  beginShape();
    for(float t =0.0;t<=1.05;t+=0.05){
      PNT At1 =SAB.apply(A0,t);
      PNT At2 =SAD.apply(A0,t);
      PNT A=P();
      A.x = (At1.x+At2.x)/2;
      A.y = (At1.y+At2.y)/2;
      vert(A);
    }
  endShape();
   beginShape();
    for(float t =0.0;t<=1.05;t+=0.05){
      PNT Bt1 =SAB.apply(B0,t);
      PNT Bt2 =SBC.apply(B0,t);
      PNT B=P();
      B.x = (Bt1.x+Bt2.x)/2;
      B.y = (Bt1.y+Bt2.y)/2;
      vert(B);
    }
  endShape();
    beginShape();
    for(float t =0.0;t<=1.05;t+=0.05){
      PNT Ct1 =SBC.apply(C0,t);
      PNT Ct2 =SCD.apply(C0,t);
      PNT C=P();
      C.x = (Ct1.x+Ct2.x)/2;
      C.y = (Ct1.y+Ct2.y)/2;
      vert(C);
    }
  endShape();
    beginShape();
    for(float t =0.0;t<=1.05;t+=0.05){
      PNT Dt1 =SAD.apply(D0,t);
      PNT Dt2 =SCD.apply(D0,t);
      PNT D=P();
      D.x = (Dt1.x+Dt2.x)/2;
      D.y = (Dt1.y+Dt2.y)/2;
      vert(D);
    }
  endShape();
    
 
 
}

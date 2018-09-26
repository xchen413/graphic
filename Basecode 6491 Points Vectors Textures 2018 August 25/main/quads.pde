void  LERPquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time, int i)
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

  A.setTo(LERP(A0, time, A1));
  B.setTo(LERP(B0, time, B1));
  C.setTo(LERP(C0, time, C1));
  D.setTo(LERP(D0, time, D1));
}

void LPMquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time, int i) {
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



  SIMILARITY SAB= new SIMILARITY(A0, B0, A1, B1);

  //println("A0.x = .2f%\n",A0.x);
  //println("A0.x = .2f%\n",A1.x);  
  PNT At1 =SAB.apply(A0, time);
  PNT Bt1 =SAB.apply(B0, time);
  //println("At1.x = .2f%\n",At1.x);
  //println("time = .2f%\n",time);
  SIMILARITY SAD = new SIMILARITY(A0, D0, A1, D1);
  PNT At2 =SAD.apply(A0, time);
  PNT Dt1 =SAD.apply(D0, time);
  //println("At2.x = .2f%\n",At2.x);
  SIMILARITY SBC= new SIMILARITY(B0, C0, B1, C1);
  PNT Bt2 =SBC.apply(B0, time);
  PNT Ct1 =SBC.apply(C0, time);

  SIMILARITY SCD= new SIMILARITY(C0, D0, C1, D1);
  PNT Ct2 =SCD.apply(C0, time);
  PNT Dt2 =SCD.apply(D0, time);



  A.x = (At1.x+At2.x)/2;
  A.y = (At1.y+At2.y)/2;
  B.x = (Bt1.x+Bt2.x)/2;
  B.y = (Bt1.y+Bt2.y)/2;
  C.x = (Ct1.x+Ct2.x)/2;
  C.y = (Ct1.y+Ct2.y)/2;
  D.x = (Dt1.x+Dt2.x)/2;
  D.y = (Dt1.y+Dt2.y)/2;
}

void showSpiralquad(PNT[] Point, int i) {
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

  SIMILARITY SAB= new SIMILARITY(A0, B0, A1, B1);
  SIMILARITY SAD = new SIMILARITY(A0, D0, A1, D1);
  SIMILARITY SBC= new SIMILARITY(B0, C0, B1, C1);    
  SIMILARITY SCD= new SIMILARITY(C0, D0, C1, D1);
  beginShape();
  for (float t =0.0; t<=1.05; t+=0.05) {
    PNT At1 =SAB.apply(A0, t);
    PNT At2 =SAD.apply(A0, t);
    PNT A=P();
    A.x = (At1.x+At2.x)/2;
    A.y = (At1.y+At2.y)/2;
    vert(A);
  }
  endShape();
  beginShape();
  for (float t =0.0; t<=1.05; t+=0.05) {
    PNT Bt1 =SAB.apply(B0, t);
    PNT Bt2 =SBC.apply(B0, t);
    PNT B=P();
    B.x = (Bt1.x+Bt2.x)/2;
    B.y = (Bt1.y+Bt2.y)/2;
    vert(B);
  }
  endShape();
  beginShape();
  for (float t =0.0; t<=1.05; t+=0.05) {
    PNT Ct1 =SBC.apply(C0, t);
    PNT Ct2 =SCD.apply(C0, t);
    PNT C=P();
    C.x = (Ct1.x+Ct2.x)/2;
    C.y = (Ct1.y+Ct2.y)/2;
    vert(C);
  }
  endShape();
  beginShape();
  for (float t =0.0; t<=1.05; t+=0.05) {
    PNT Dt1 =SAD.apply(D0, t);
    PNT Dt2 =SCD.apply(D0, t);
    PNT D=P();
    D.x = (Dt1.x+Dt2.x)/2;
    D.y = (Dt1.y+Dt2.y)/2;
    vert(D);
  }
  endShape();
}

void NevilleQuad(PNT At, PNT Bt, PNT Ct, PNT Dt, PNT[] Point, float time) {
  PNT A =P();
  PNT B =P();
  PNT C =P();
  PNT D =P();
  PNT[] xt = new PNT[4];
  float a=0;
  float b=0;
  float c=0;
  float d =0;

  for (int i=0; i<4; i+=1) {
    A.setTo(Point[i]);
    B.setTo(Point[(i+4)%16]);
    C.setTo(Point[(i+8)%16]);
    D.setTo(Point[(i+12)%16]);
    if (method ==0) { //knot method 0=uniform
      a=0;
      b=float(1)/float(3);
      c=float(2)/float(3);
      d =1;
    } else if (method ==1) { //chordal
      a=0;
      b = a+normOf(V(A, B));
      c = b+normOf(V(B, C));
      d = c+normOf(V(C, D));
      b=b/d;
      c=c/d;
      d = 1;
    } else if (method ==2) {//centripetal
      a=0;
      b = a+sqrt(normOf(V(A, B)));
      c = b+sqrt(normOf(V(B, C)));
      d = c+sqrt(normOf(V(C, D)));
      b=b/d;
      c=c/d;
      d = 1;
    }

    xt[i] = Neville(a, A, b, B, c, C, d, D, time);
    if (showCurve) {
      drawNevilleCurve(a, A, b, B, c, C, d, D);
    }
  }
  At.setTo(xt[0]);
  Bt.setTo(xt[1]);
  Ct.setTo(xt[2]);
  Dt.setTo(xt[3]);
}


void RegisterQuad(PNT At, PNT Bt, PNT Ct, PNT Dt, PNT[] Point, int m, float t) {
  PNT[] M = new PNT[4];
  PNT[] N = new PNT[4];
  PNT[] R = new PNT[4];
  M[0].setTo(Point[m]);
  M[1].setTo(Point[m+1]);
  M[2].setTo(Point[m+2]);
  M[3].setTo(Point[m+3]);

  N[0].setTo(Point[(m+4)%16]);
  N[1].setTo(Point[(m+5)%16]);
  N[2].setTo(Point[(m+6)%16]);
  N[3].setTo(Point[(m+7)%16]);  

  R[0].setTo(M[0]);
  R[1].setTo(M[1]);
  R[2].setTo(M[2]);
  R[3].setTo(M[3]);


  //translate 
  PNT A=centroid(M, 4); //stroke(green);// drawCircle(A, 4); 
  PNT B=centroid(N, 4); //stroke(red); //drawCircle(B, 4);
  PNT C=P(A, t, V(A, B));
  for (int i=0; i<4; i+=1) {
    R[i]=P(M[i], t, V(M[i], N[i]));
  }

  //rotate
  float s=0;
  float h=0;
  for (int i=0; i<4; i+=1) {
    s+=dot(V(A, M[i]), Rotated(V(B, N[i])));
  }
  for (int i=0; i<4; i+=1) {
    h+=dot(V(A, M[i]), V(B, N[i]));
  }
  float a =atan2(s, h);

  //scale
  float l=0;
  for (int i=0; i<4; i+=1) {
    l =l*(normOf(V(B, N[i]))/normOf(V(A, M[i])));
  }
  l=pow(l, 0.25);

  //moving 4 points with time
  for (int i=0; i<4; i+=1) {
    R[i]=P(C, t*l, Rotated(V(A, M[i]), a*t));
  }

  At.setTo(R[0]);
  Bt.setTo(R[1]);
  Ct.setTo(R[2]);
  Dt.setTo(R[3]);
}

PNT centroid(PNT[] A, int n) {
  PNT C =P();
  float X=0;
  float Y=0;
  for (int i =0; i<n; i+=1) {
    X=X+A[i].x;
    Y=Y+A[i].y;
  }
  C.x=X/float(n);
  C.y = Y/float(n);
  return C;
}

PNT SQUINT(PNT A, PNT B, PNT C, PNT D, float u, float v) {


  SIMILARITY SU = new SIMILARITY (A, D, B, C);
  PNT F = SU.F;
  float MU = SU.lambda;
  float AU = SU.alpha;

  SIMILARITY SV = new SIMILARITY (A, B, D, C);

  float MV = SV.lambda;
  float AV = SV.alpha;

  return P(F, pow(MU, u)*pow(MV, v), Rotated(V(F, A), (u*AU+v*AV)));
}


void showSM(PNT A, PNT B, PNT C, PNT D, float u, float v) {

  if ((angle(V(A, B), V(B, C)) == PI/2.0) || (angle(V(B, C), V(C, D))==PI/2.0)) { //check for 90 degree
    line(A.x, A.y, B.x, B.y);
    line(C.x, C.y, D.x, D.y);
    line(A.x, A.y, D.x, D.y);
    line(B.x, B.y, C.x, C.y);
  }
  else
  {
    beginShape();
    for (float t=0; t<1.05; t+=0.05) {
      vert(SQUINT(A, B, C, D, t, v));
    }
    endShape();
    beginShape();
    for (float t=0; t<1.05; t+=0.05) {
      vert(SQUINT(A, B, C, D, u, t));
    }
    endShape();
  }
}

void drawSQUINTtexture(PNT A, PNT B, PNT C, PNT D, PImage pix) {
  float u=0;
  float v=0;
  if ((angle(V(A, B), V(B, C)) == PI/2.0) || (angle(V(B, C), V(C, D))==PI/2.0)) {//check for 90 degree
    drawQuadTextured(A, B, C, D, pix);
  } else {
    noFill();
    noStroke();
    for (v=0; v<1; v+=0.05) {
      for (u=0; u<1; u+=0.05) {
        beginShape();
        texture(pix);
        float x =u;
        float y= v;
        vert(SQUINT(A, B, C, D, x, y), x, y);
        vert(SQUINT(A, B, C, D, x+0.05, y), x+0.05, y);
        vert(SQUINT(A, B, C, D, x+0.05, y+0.05), x+0.05, y+0.05);
        vert(SQUINT(A, B, C, D, x, y+0.05), x, y+0.05);
        endShape(CLOSE);
      }
    }
  }
}

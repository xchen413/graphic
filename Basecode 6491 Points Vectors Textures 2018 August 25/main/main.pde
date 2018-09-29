// base code 01 for graphics class 2018, Jarek Rossignac

// **** LIBRARIES
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;


// **** GLOBAL VARIABLES

// COLORS
color // set more colors using Menu >  Tools > Color Selector
  black=#000000, grey=#5F5F5F, white=#FFFFFF, 
  red=#FF0000, green=#00FF01, blue=#0300FF, 
  yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, 
  orange=#FCA41F, dgreen=#026F0A, brown=#AF6E0B;

// FILES and COUNTERS
String PicturesFileName = "SixteenPoints";
int frameCounter=0;
int pictureCounterPDF=0, pictureCounterJPG=0, pictureCounterTIF=0; // appended to file names to avoid overwriting captured images

// PICTURES
PImage FaceStudent1, FaceStudent2; // picture of student's face as /data/XXXXX.jpg in sketch folder !!!!!!!!

// TEXT
PFont bigFont; // Font used for labels and help text

// KEYBOARD-CONTROLLED BOOLEAM TOGGLES AND SELECTORS 
int method=0; // selects which method is used to set knot values (0=uniform, 1=chordal, 2=centripetal)
boolean animating=true; // must be set by application during animations to force frame capture
boolean texturing=false; // fill animated quad with texture
boolean showArrows=true;
boolean showInstructions=true;
boolean showLabels=true;
boolean showLERP=true;
boolean showLPM=true;
boolean fill=false;
boolean filming=false;  // when true frames are captured in FRAMES for a movie

boolean showSQUINT = false;
boolean showNeville= false;
boolean showCurve = false;
boolean showRegister = false;

// flags used to control when a frame is captured and which picture format is used 
boolean recordingPDF=false; // most compact and great, but does not always work
boolean snapJPG=false;
boolean snapTIF=false;   

// ANIMATION
float totalAnimationTime=9; // at 1 sec for 30 frames, this makes the total animation last 90 frames
float time=0;

//POINTS 
int pointsCountMax = 32;         //  max number of points
int pointsCount=4;               // number of points used
PNT[] Point = new PNT[pointsCountMax];   // array of points
PNT A, B, C, D; // Convenient global references to the first 4 control points 
PNT P; // reference to the point last picked by mouse-click


int N = 3 ;//SQUINT N*N point grid

// **** SETUP *******
void setup()               // executed once at the begining LatticeImage
{
  size(800, 800, P2D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  bigFont = createFont("AdobeFanHeitiStd-Bold-32", 16); 
  textFont(bigFont); // font used to write on screen
  FaceStudent1 = loadImage("data/studentFace.jpg");  // file containing photo of student's face
  //FaceStudent2 = loadImage("data/student2.jpg");  // file containing photo of student's face
  declarePoints(Point); // creates objects for 
  readPoints("data/points.pts");
  A=Point[0]; 
  B=Point[1]; 
  C=Point[2]; 
  D=Point[3]; // sets the A B C D pointers
  textureMode(NORMAL); // addressed using [0,1]^2
} // end of setup


// **** DRAW
void draw()      // executed at each frame (30 times per second)
{
  if (recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF

  if (showInstructions) showHelpScreen(); // display help screen with student's name and picture and project title

  else // display frame
  {
    background(white); // erase screen
    A=Point[0]; 
    B=Point[1]; 
    C=Point[2]; 
    D=Point[3]; // sets the A B C D pointers

    // Update animation time
    if (animating) 
    {
      if (time<1) time+=1./(totalAnimationTime*frameRate); // advance time
      else  time=0; // reset time to the beginning
    }

    // WHEN USING 4 CONTROL POINTS:  Use this for morphing edges (in 6491)
    if (pointsCount==4)
    {
      EDGE E0 = new EDGE(A, B);
      EDGE E1 = new EDGE(D, C);

      if (showArrows)         // Draw edges as arrows
      {
        stroke(grey); 
        strokeWeight(5); 
        drawEdgeAsArrow(E0); 
        drawEdgeAsArrow(E1);
      }

      if (showLERP)         // Draw lerp of endpoints (as a reference of a bad morph)
      {
        EDGE Et = LERP(E0, time, E1);
        stroke(blue); 
        strokeWeight(3); 
        fill(blue);
        drawEdgeAsArrow(Et);
        writeLabel(Et.PNTnearB(), " LERP");
        noFill();
      }

      if (showLPM)         // Draw LMP: This is a place holder with the wrong solution. 
      {
        //EDGE Et = LPM(E0,time,E1); // You must change this code (see TAB edges)
        SIMILARITY S = new SIMILARITY(E0.A, E0.B, E1.A, E1.B);
        //SIMILARITY sr = S(E0.A,E1.A,E0.B,E1.B);
        PNT At =S.apply(E0.A, time);
        PNT Bt =S.apply(E0.B, time);
        EDGE Et = E(At, Bt);
        stroke(red); 
        strokeWeight(3); 
        fill(red);

        drawEdgeAsArrow(Et);
        writeLabel(Et.PNTnearB(), " LPM");

        noFill();
        stroke(grey);
        strokeWeight(1);
        showSpiral(E0.A, E0.B, E1.A, E1.B); 

        noFill();
        //stroke(blue);
        //showSpiral(E0.A,E0.B,E1.B);
        //showSpiralPattern(E0.A,E0.B,E1.A,E1.B);
      }

      // Draw and label control points
      if (showLabels) // draw names of control points
      {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); 
        strokeWeight(1); // attribute of circle around the label
        showLabelInCircle(A, "A"); 
        showLabelInCircle(B, "B"); 
        showLabelInCircle(C, "C"); 
        showLabelInCircle(D, "D");
      } else // draw small dots at control points
      {
        fill(brown); 
        stroke(brown); 
        drawCircle(A, 4); 
        drawCircle(B, 4); 
        drawCircle(C, 4); 
        drawCircle(D, 4);
      }
      noFill();

      if (showNeville) { //draw Neville curve
        float a=0;
        float b=0;
        float c=0;
        float d =0;
        fill(black);
        String nv1 = "Neville";

        text(nv1, 300, 30);
        noFill();


        if (method ==0) { //knot method 0=uniform
          a=0;
          b=float(1)/float(3);
          c=float(2)/float(3);
          d =1;
          fill(black);
          String nv2 = "Method = Uniform";
          text(nv2, 300, 60);
          noFill();
        } else if (method ==1) { //chordal 
          a=0;
          b = a+normOf(V(A, B));
          c = b+normOf(V(B, C));
          d = c+normOf(V(C, D));
          b=b/d;
          c=c/d;
          d = 1;
          fill(black);
          String nv2 = "Method = Chordal";
          text(nv2, 300, 60);
          noFill();
        } else if (method ==2) {//centripetal
          a=0;
          b = a+sqrt(normOf(V(A, B)));
          c = b+sqrt(normOf(V(B, C)));
          d = c+sqrt(normOf(V(C, D)));
          b=b/d;
          c=c/d;
          d = 1;
          fill(black);
          String nv2 = "Method = Centripetal";
          text(nv2, 300, 60);
          noFill();
        }
        drawNevilleCurve(a, A, b, B, c, C, d, D);
        noFill();
      }
    } // end of when 4 points




    // WHEN USING 16 CONTROL POINTS (press '4' to make them or 'R' to load them from file) 
    if (pointsCount==16)
    {
      noFill(); 
      strokeWeight(6); 
      for (int i=0; i<4; i++) {
        stroke(50*i, 200-50*i, 0); 
        drawQuad(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3]);
      }
      // strokeWeight(2); stroke(grey,100); for(int i=0; i<4; i++) drawOpenQuad(Point[i],Point[i+4],Point[i+8],Point[i+12]);


      // Draw control points
      if (showLabels) // draw names of control points
      {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); 
        strokeWeight(1); // attribute of circle around the label
        for (int i=0; i<pointsCount; i++) showLabelInCircle(Point[i], Character.toString((char)(int)(i+65)));
      } else // draw small dots at control points
      {
        fill(blue); 
        stroke(blue); 
        strokeWeight(2);  
        for (int i=0; i<pointsCount; i++) drawCircle(Point[i], 4);
      }

      // Animate quad
      strokeWeight(20); 
      stroke(red, 100); // semitransparent
      // *** replace {At,Bt..} by QUAD OBJECT in the code below
      PNT At=P(), Bt=P(), Ct=P(), Dt=P();
      if (showLERP) {
        fill(black);
        String lp = "Blue :LERP";

        text(lp, 300, 90);
        noFill();

        if (time<=(float(1)/float(3))) {
          int i=0;
          LERPquads(At, Bt, Ct, Dt, Point, time*3, i);
        } else if (time<=(float(2)/float(3))) {

          int i=4;
          LERPquads(At, Bt, Ct, Dt, Point, 3*(time-0.333), i);
        } else {
          int i=8;
          LERPquads(At, Bt, Ct, Dt, Point, 3*(time-0.6667), i);
        }
        noFill(); 
        noStroke(); 
        if (texturing) 
          drawQuadTextured(At, Bt, Ct, Dt, FaceStudent1); // see ``points'' TAB for implementation
        else
        {
          noFill(); 
          if (fill) fill(yellow);
          strokeWeight(5); 
          stroke(blue, 100); // semitransparent
          drawQuad(At, Bt, Ct, Dt);
        }
      }
      if (showLPM) {
        fill(black);
        String lpm = "Red :LPM";

        text(lpm, 300, 120);
        noFill();

        if (time<=(float(1)/float(3))) {
          int i=0;
          LPMquads(At, Bt, Ct, Dt, Point, time*3, i);
        } else if (time<=(float(2)/float(3))) {

          int i=4;
          LPMquads(At, Bt, Ct, Dt, Point, 3*(time-0.333), i);
        } else {
          int i=8;
          LPMquads(At, Bt, Ct, Dt, Point, 3*(time-0.6667), i);
        }
        if (showCurve) {
          noFill();
          stroke(grey);
          strokeWeight(1);
          showSpiralquad(Point, 0);
          showSpiralquad(Point, 4);
          showSpiralquad(Point, 8);
        }
        noFill(); 
        noStroke(); 
        if (texturing) 
          drawQuadTextured(At, Bt, Ct, Dt, FaceStudent1); // see ``points'' TAB for implementation
        else
        {
          noFill(); 
          if (fill) fill(cyan);
          strokeWeight(5); 
          stroke(red, 100); // semitransparent
          drawQuad(At, Bt, Ct, Dt);
        }
      }

      if (showNeville) { //draw Neville

        fill(black);
        String nv1 = "Green :Neville";

        text(nv1, 300, 30);
        noFill();
        if (method==0) {
          fill(black);
          String nv2 = "Method = Uniform";
          text(nv2, 300, 60);
          noFill();
        } else if (method ==1) {
          fill(black);
          String nv2 = "Method = Chordal";
          text(nv2, 300, 60);
          noFill();
        } else {
          fill(black);
          String nv2 = "Method = Centripetal";
          text(nv2, 300, 60);
          noFill();
        }
        noFill(); 
        stroke(black);
        strokeWeight(1);
        NevilleQuad(At, Bt, Ct, Dt, Point, time);

        noFill(); 
        noStroke(); 
        if (texturing) 
          drawQuadTextured(At, Bt, Ct, Dt, FaceStudent1); // see ``points'' TAB for implementation
        else
        {
          noFill(); 
          if (fill) fill(cyan);
          strokeWeight(5); 
          stroke(green, 100); // semitransparent
          drawQuad(At, Bt, Ct, Dt);
        }
      }//end of neville

      if (showRegister) {
        fill(black);
        String rc = "Grey :Register + residual";

        text(rc, 300, 150);
        noFill();
        PNT A1=P(); 
        PNT A2=P(); 
        PNT A3=P();
        PNT A4=P();
        PNT B1=P(); 
        PNT B2=P(); 
        PNT B3=P();
        PNT B4=P();
        float t=0;
        if (time<=(float(1)/float(3))) {
          t=time*3;
          RegisterQuad(A1, A2, A3, A4, Point, 0, t, false);
          RegisterQuad(B1, B2, B3, B4, Point, 0, 1-t, true);
        } else if (time<=(float(2)/float(3))) {
          //RegisterQuad(At,Bt,Ct,Dt,Point,4,(time-(float(1)/float(3)))*3); 
          t=(time-(float(1)/float(3)))*3;
          RegisterQuad(A1, A2, A3, A4, Point, 4, t, false);
          RegisterQuad(B1, B2, B3, B4, Point, 4, 1-t, true);
        } else {
          //RegisterQuad(At,Bt,Ct,Dt,Point,8,(time-(float(2)/float(3)))*3);
          t=(time-(float(2)/float(3)))*3;
          RegisterQuad(A1, A2, A3, A4, Point, 8, t, false);
          RegisterQuad(B1, B2, B3, B4, Point, 8, 1-t, true);
        }
        At =LERP(A1, t, B1);
        Bt =LERP(A2, t, B2);
        Ct =LERP(A3, t, B3);
        Dt =LERP(A4, t, B4);
        noFill(); 
        noStroke(); 
        if (texturing) 
          drawQuadTextured(At, Bt, Ct, Dt, FaceStudent1); // see ``points'' TAB for implementation
        else
        {
          noFill(); 
          if (fill) fill(cyan);
          strokeWeight(5); 
          stroke(grey, 100); // semitransparent
          drawQuad(At, Bt, Ct, Dt);
        }

        noFill();
        noStroke();
        if (showCurve) {
          noFill();
          strokeWeight(1); 
          stroke(yellow); 
          drawRegistration(0, Point);
          drawRegistration(4, Point);
          drawRegistration(8, Point);
        }
      }//end of Register
    } // end of when 16 points 

    if (showSQUINT) {

      if (pointsCount == 4) {
        background(white); // erase screen
        A=Point[0]; 
        B=Point[1]; 
        C=Point[2]; 
        D=Point[3]; // sets the A B C D pointers


        //noFill();
        //stroke(blue);
        //strokeWeight(2);
        //showSM(A, B, C, D,0,0);
        //showSM(A,B,C,D,1,1);


        PNT[] pointset = new PNT[int(pow((N+1), 2))];
        float u=0;
        float v=0;
        int l =0;
        for (v=0.0; v<1.00005; v=v+1.0/float(N)) {
          for (u=0.0; u<1.000005; u=u+1.0/float(N)) {
            pointset[l]=SQUINT(A, B, C, D, u, v);
            fill(red);
            stroke(red);
            strokeWeight(2);
            drawCircle(pointset[l], 3);
            noFill();
            stroke(blue);
            strokeWeight(1.5);
            showSM(A, B, C, D, u, v);
          }
        }

        fill(black);
        String nstring = "N = ";
        String textstring =nstring+N;
        String texts1 = "use \"UP\" and \"DOWN\" in keyboard to increase or decrease N (N*N tiles grid)";
        text(texts1, 300, 30);
        text(textstring, 50, 60);


        if (texturing) { 
          drawSQUINTtexture(A, B, C, D, FaceStudent1);
        }

        // Draw and label control points
        if (showLabels) // draw names of control points
        {
          textAlign(CENTER, CENTER); // to position the label around the point
          stroke(black); 
          strokeWeight(1); // attribute of circle around the label
          for (int i=0; i<pointsCount; i++) showLabelInCircle(Point[i], Character.toString((char)(int)(i+65)));
        } else // draw small dots at control points
        {
          fill(blue); 
          stroke(blue); 
          strokeWeight(2);  
          for (int i=0; i<pointsCount; i++) drawCircle(Point[i], 4);
        }
      }// 4points

      if (pointsCount==16) {
        background(white);

        noFill(); 
        strokeWeight(3); 
        for (int i=0; i<4; i++) {
          stroke(50*i, 200-50*i, 0); 
          showSM(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], 0, 0);
          showSM(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], 1, 1);
        }
        // strokeWeight(2); stroke(grey,100); for(int i=0; i<4; i++) drawOpenQuad(Point[i],Point[i+4],Point[i+8],Point[i+12]);


        // Draw control points
        if (showLabels) // draw names of control points
        {
          textAlign(CENTER, CENTER); // to position the label around the point
          stroke(black); 
          strokeWeight(1); // attribute of circle around the label
          for (int i=0; i<pointsCount; i++) showLabelInCircle(Point[i], Character.toString((char)(int)(i+65)));
        } else // draw small dots at control points
        {
          fill(blue); 
          stroke(blue); 
          strokeWeight(2);  
          for (int i=0; i<pointsCount; i++) drawCircle(Point[i], 4);
        }


        //draw texture
        PNT At=P(), Bt=P(), Ct=P(), Dt=P();
        if (showLPM) 
        {
          if (time<=(0.3333)) {
            int i=0;
            LPMquads(At, Bt, Ct, Dt, Point, time*3, i);
          } else if (time<=(0.6667)) {

            int i=4;
            LPMquads(At, Bt, Ct, Dt, Point, 3*(time-0.333), i);
          } else {
            int i=8;
            LPMquads(At, Bt, Ct, Dt, Point, 3*(time-0.6667), i);
          }
          if (showCurve) {
            noFill();
            stroke(grey);
            strokeWeight(1);
            showSpiralquad(Point, 0);
            showSpiralquad(Point, 4);
            showSpiralquad(Point, 8);
          }
          noFill(); 
          noStroke(); 
          if (texturing) 
            drawSQUINTtexture(At, Bt, Ct, Dt, FaceStudent1);
          else {
            noFill(); 
            if (fill) fill(cyan);
            strokeWeight(5); 
            stroke(red, 100); //
            showSM(At, Bt, Ct, Dt, 0, 0);
            showSM(At, Bt, Ct, Dt, 1, 1);
          }
        }
      }//end of 16S
    }//end of SQUINT
  } // end of display frame



  // snap pictures or movie frames
  if (recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas
  if (snapTIF) snapPictureToTIF();   
  if (snapJPG) snapPictureToJPG();   
  if (filming) snapFrameToTIF(); // saves image on canvas as movie frame
} // end of draw()

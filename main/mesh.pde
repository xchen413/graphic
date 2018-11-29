// TRIANGLE MESH
class MESH {
    // VERTICES
    int nv=0, maxnv = 10000;  
    pt[] G = new pt [maxnv];                        
    // TRIANGLES 
    int nt = 0, maxnt = maxnv*2;                           
    int[] isInterior = new int[maxnv];                                      
    // CORNERS 
    int c=0;    // current corner                                                              
    int nc = 0; 
    int[] V = new int [3*maxnt];   
    int[] O = new int [3*maxnt];  
    
    //unuse tris
    int[] UV = new int [3*maxnt]; 
    int nu=0; // count of UV
    
    
    void ResetCut(){for(int i=0;i<nu;i++){UV[i]=0;};}
    // current corner that can be edited with keys
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new pt();};
  void reset() {nv=0; nt=0; nc=0;}                                                  // removes all vertices and tris
  void loadVertices(pt[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(pts P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(pt P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTri(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds tri (i,j,k) to V table

  // CORNER OPERATORS
  int t (int c) {int r=int(c/3); return(r);}                   // tri of corner c
  int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);}         // next corner
  int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);}         // previous corner
  pt g (int c) {return G[V[c]];}                             // shortcut to get the point where the vertex v(c) of corner c is located

  boolean nb(int c) {return(O[c]!=c);};  // not a border corner
  boolean bord(int c) {return(O[c]==c);};  // is a border corner

  pt cg(int c) {return P(0.6,g(c),0.2,g(p(c)),0.2,g(n(c)));}   // computes offset location of point at corner c

  // CORNER ACTIONS CURRENT CORNER c
  void next() {c=n(c);}
  void previous() {c=p(c);}
  void opposite() {c=o(c);}
  void left() {c=l(c);}
  void right() {c=r(c);}
  void swing() {c=s(c);} 
  void unswing() {c=u(c);} 
  void printCorner() {println("c = "+c);}
  
  

  // DISPLAY
  void showCurrentCorner(float r) { if(bord(c)) fill(red); else fill(dgreen); show(cg(c),r); };   // renders corner c as small ball
  void showEdge(int c) {beam( g(p(c)),g(n(c)),rt ); };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green inside, red outside
    {
    for (int v=0; v<nv; v++) 
      {
      if(isInterior[v]==1){fill(brown);}
      
      else if(isInterior[v]==3){ fill(black);}
      else if(isInterior[v]==2){fill(red);}
      
      show(G[v],r);
      }
    }                          
  void showInteriorVertices(float r) {for (int v=0; v<nv; v++) if(isInterior[v]==1) show(G[v],r); }                          // shows all vertices as dots
  void showTris() { for (int c=0; c<nc; c+=3) show(g(c), g(c+1), g(c+2)); }         // draws all tris (edges, or filled)
  void showEdges() {for (int i=0; i<nc; i++) showEdge(i); };         // draws all edges of mesh twice

  void triangulate()      // performs Delaunay triangulation using a quartic algorithm
   {
     c=0;                   // to reset current corner
     pt Center=P();
     boolean good = false;
     // **01 implement it
     for (int i=0;i<nv;i++){
       for(int j=i+1;j<nv;j++){
         for(int k=j+1;k<nv;k++){
           if(!isFlatterThan(G[i],G[j],G[k],10)){
             Center.setTo(CircumCenter(G[i],G[j],G[k]));
             good = true;
             for(int m=0;m<nv;m++){
               if((m!=i)&&(m!=j)&&(m!=k)){
                 if(d(Center,G[m])<=d(Center,G[i])){
                   good=false;
                 }
               }
             }
             if(good){
                   if(ccw(G[i],G[j],G[k])){
                     if(!CheckUnuse(i,j,k)){
                     addTri(i,j,k);}
                   }else{
                     if(!CheckUnuse(i,k,j)){
                     addTri(i,k,j);}
                   }
                 }
           }
         }
       }
     }
   }  

   
  void computeO() // **02 implement it 
    {                                          
    // **02 implement it
      for(int i=0;i<nc;i++){
        O[i]=i;
        int cn_V = V[n(i)];
        int cp_V = V[p(i)];
        for (int oi =0;oi<nc;oi++){
          if(oi!=i){
            int ocn_V=V[n(oi)];
            int ocp_V=V[p(oi)];
            if((cn_V==ocp_V)&&(cp_V==ocn_V)){
              O[i]=oi;
            }
          }
        }
      }
    } 
    
  void showBorderEdges()  // draws all border edges of mesh
    {
    // **02 implement; 
      for(int i=0;i<nc;i++){
        if(bord(i)){
          showEdge(i);
        }
      }
    }
  
  int countBorders(){
    int borders=0;
    for(int i=0;i<nc;i++){
        if(bord(i)){
          borders++;
        }
      }
    return borders;
  }

  void showNonBorderEdges() // draws all non-border edges of mesh
    {
    // **02 implement 
      for(int i=0;i<nc;i++  ){
        if(nb(i)){
          showEdge(n(i));
          showEdge(p(i));
        }
      }
    }        
    
  void classifyVertices() 
    { 
    // **03 implement it
    int[] vcount = new int[nv];
      for(int v=0;v<nv;v++){
        isInterior[v]=1;
  }
     
      for(int i=0;i<nc;i++){
        vcount[V[i]]++;
        
        if(bord(i)){
          isInterior[V[n(i)]]=2;
          isInterior[V[p(i)]]=2;
        }
      }
      for(int i=0;i<nu;i++){
        if(vcount[UV[i]]==0){
          
          isInterior[UV[i]]=3;
        }
      }
      
    }  
    
  
 
 
 
 
   // **05 implement corner operators in Mesh
  int v (int c) {return V[c];}                                // vertex of c
  int o (int c) {return O[c];}                                // opposite corner
  int l (int c) {return O[n(c)];}                             // left
  int s (int c) {return n(O[n(c)]);}                             // left
  int u (int c) {return p(O[p(c)]);}                             // left
  int r (int c) {return O[p(c)];}                             // right
  
  void showOpposites(){
    for(int i=0;i<nc;i++){
      if(nb(i)){
        pt A = g(i);pt C = g(O[i]);pt B = P(g(n(i)),g(p(i)));
        showBezier(A,B,C); 
      }
    }
  }
  
void showBezier(pt A, pt B, pt C){
    float du=1./90;
    beginShape();
    for(float u=0; u<=1.+du/2; u+=du){
      vert(Bezier(A,B,C,u));
    }
    endShape();
  }

  void showVoronoiEdges() // draws Voronoi edges on the boundary of Voroni cells of interior vertices
    { 
    // **06 implement it
    for(int i=0;i<nc;i++){
      if(nb(i)){
        pt iCenter =triCircumcenter(i);
        pt oCenter =triCircumcenter(O[i]);
        show(iCenter,oCenter) ;
      }
    }
    }               

  void showArcs() // draws arcs of quadratic B-spline of Voronoi boundary loops of interior vertices
    { 
    // **06 implement it
    for(int i=0;i<nc;i++){
      if(nb(i)){
        pt iCenter =triCircumcenter(i);
        pt oCenter =triCircumcenter(O[i]);
        pt ooCenter = triCircumcenter(O[n(O[i])]);
        showBezier(P(iCenter,oCenter),oCenter,P(oCenter,ooCenter));
      }
    }
    }               // draws arcs in tris
    
   void drawVoronoiFaceOfInteriorVertices(){
     float dc =1./(nv-1);
     for(int v=0;v<nv;v++) if(isInterior[v]==1){fill(dc*255*v,dc*255*(nv-v),200);drawVoronoiFaceOfInteriorVertex(v);noFill();}
   }
   
   void drawVoronoiFaceOfInteriorVertex(int v){
     int cvStart = cornerIndexFromVertexIndex(v);
     int cv=cvStart;
     int sc= s(cv);
     noStroke();
     beginShape();
     int countn =0;
     for(countn=0;countn<1000;countn++){ //to set a maximum cut off in case of dead loop
       vert(triCircumcenter(cv));
       vert(triCircumcenter(sc));
       cv=sc;
       sc=s(cv);
       if(sc == cvStart){break;}
     }
     endShape();
   }
   
   int cornerIndexFromVertexIndex(int v){
     int cv =0;
     for(cv =0;cv<nc;cv++){
       if(V[cv]==v){break;}
     }
     return cv;
   }

 
  pt triCenter(int c) {return P(g(c),g(n(c)),g(p(c))); }  // returns center of mass of tri of corner c
  pt triCircumcenter(int c) {return CircumCenter(g(c),g(n(c)),g(p(c))); }  // returns circumcenter of tri of corner c
  
  /****************** phase 2 ******************************/
  void CheckCut(pt A, pt B){
    for (int i = 0;i<nt;i++){
      if(CutTri(A,B,i)){
        UV[nu++]=V[i*3];UV[nu++]=V[i*3+1];UV[nu++]=V[i*3+2];
       
      }
    }
  
  }

  boolean CutTri(pt A, pt B, int i){
    boolean intersect = false;
    pt ta = P();pt tb = P(); pt tc =P();
    ta.setTo(g(i*3));
    tb.setTo(g(i*3+1));
    tc.setTo(g(i*3+2));
    if(SegmentIntersect(A,B,ta,tb)){intersect = true;return intersect;}
    if(SegmentIntersect(A,B,tb,tc)){intersect = true;return intersect;}
    if(SegmentIntersect(A,B,tc,ta)){intersect = true;return intersect;}
    return intersect;
  }
  boolean CheckUnuse(int i,int j,int k){
    boolean unuse = false;
    for (int u=0;u<nu;u++){
      if(UV[u]==i){
        if(UV[u+1]==j){
          if(UV[u+2]==k){
            unuse = true;
          }
        }
      }
    
    }
    return unuse;
  }
  void smoothenInterior(float s) { // even interior vertiex locations
    pt[] Gn = new pt[nv];
    // **04 implement it
    for(int v=0; v<nv; v++){
      Gn[v]=P();
    }
    int[] CountNeighbor = new int[nv];
    for (int i=0;i<nc;i++){
      Gn[V[n(i)]].add(G[V[i]]); //add this corner V to its next corner's Gn
      CountNeighbor[V[n(i)]]++;
    }
    for(int v=0; v<nv; v++){
      Gn[v].div(CountNeighbor[v]);
    }
    
    for (int v=0; v<nv; v++) {
      
      if(isInterior[v]==1) {
        G[v].translateTowards(s,Gn[v]);
      }
      }
    }
    
  void showBorderCorner(){
    for(int c=0;c<nc;c++){
      if(bord(c)){
        show(cg(c),15);
      }
    }
  }
  void smoothenBoundary(float s){
   
   pt B=P();pt C=P();pt D=P(); pt NP=P();
   
   
   for(int i=0;i<nc;i++){
     if(bord(i)){ // for every bord c
       int fc = i;//will not change inside if
       
       C.setTo(g(n(fc))); // focus point, then find it's 2 neighbors
       D.setTo(g(ccwNeighbor(n(fc))));
       B.setTo(g(p(fc)));
       float  ang=angle(V(C,B),V(C,D)); 
       
       if(ang<(3*PI/5)){
          NP.setTo(B(B,C,D,s));
        //Gn[V[n(fc)]].setTo(L(B,norm(V(D,C))/(norm(V(B,C))+norm(V(C,D))),D));
          G[V[n(fc)]].translateTowards(s,NP);
          
          
          //int dd = ccwNeighbor(n(fc));
          //C.setTo(g(dd));
          //D.setTo(g(ccwNeighbor(dd)));
          //B.setTo(g(fc));
          //NP.setTo(B(B,C,D,s));
          //G[V[n(dd)]].translateTowards(-s/20,NP);
          
          //int bb = leftNeighbor(p(fc));
          //C.setTo(g(p(fc)));
          //D.setTo(g(fc));
          //B.setTo(g(bb));
          //NP.setTo(B(B,C,D,s));
          //G[V[p(fc)]].translateTowards(-s/20,NP);
          
          
       }
       for(int j = 0;j<nu;j++){
         if(V[n(fc)] == UV[j]){
           
         }
       }
     }
     
   }
   
   
   
 }
 
 int ccwNeighbor(int i){
       int sc = s(i);
       int cc = i;
       int nb=0;
       for(int f=0;f<100;f++){
         if(V[sc] == V[cc]){
           sc = s(sc);
           cc = i;
         }else{break;}
       }
       nb=sc;
       return nb;
 }
  int leftNeighbor(int i){
       int uc = u(i);
       int cc = i;
       int nb=0;
       for(int f=0;f<100;f++){
         if(V[uc] == V[cc]){
           uc = u(uc);
           cc = i;
         }else{break;}
       }
       nb=uc;
       return nb;
 }
 //pt newBondaryP(pt A,pt B,pt C){
 //  float a = norm(V(A,B));
 //  float b = norm(V(B,C));
   
 //  //C = L((-0.5)*(a+b),A,(-0.25)*(b),B,0.25*(c),D,0.5*(c+d),E,0);
 //  B = L((-0.5)*a,A,0.5*b,C,0);
 //  return B;
 //}
 

  } // end of MESH

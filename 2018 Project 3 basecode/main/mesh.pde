// TRIANGLE MESH
class MESH {
    // VERTICES
    int nv=0, maxnv = 10000;  
    pt[] G = new pt [maxnv];                        
    // TRIANGLES 
    int nt = 0, maxnt = maxnv*2;                           
    boolean[] isInterior = new boolean[maxnv];                                      
    // CORNERS 
    int c=0;    // current corner                                                              
    int nc = 0; 
    int[] V = new int [3*maxnt];   
    int[] O = new int [3*maxnt];  
    
    //unuse triangles
    int[] UV = new int [3*maxnt]; 
    int nu=0;
    void ResetCut(){for(int i=0;i<nu;i++){UV[i]=0;};nu=0;}
    // current corner that can be edited with keys
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new pt();};
  void reset() {nv=0; nt=0; nc=0;}                                                  // removes all vertices and triangles
  void loadVertices(pt[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(pts P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(pt P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds triangle (i,j,k) to V table

  // CORNER OPERATORS
  int t (int c) {int r=int(c/3); return(r);}                   // triangle of corner c
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
      if(isInterior[v]) fill(green); else fill(red);
      show(G[v],r);
      }
    }                          
  void showInteriorVertices(float r) {for (int v=0; v<nv; v++) if(isInterior[v]) show(G[v],r); }                          // shows all vertices as dots
  void showTriangles() { for (int c=0; c<nc; c+=3) show(g(c), g(c+1), g(c+2)); }         // draws all triangles (edges, or filled)
  void showEdges() {for (int i=0; i<nc; i++) showEdge(i); };         // draws all edges of mesh twice

  void triangulate()      // performs Delaunay triangulation using a quartic algorithm
   {
     c=0;                   // to reset current corner
     pt Center;
     boolean good = false;
     // **01 implement it
     for (int i=0;i<nv;i++){
       for(int j=i+1;j<nv;j++){
         for(int k=j+1;k<nv;k++){
           if(!isFlatterThan(G[i],G[j],G[k],10)){
             Center = CircumCenter(G[i],G[j],G[k]);
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
                     addTriangle(i,j,k);}
                   }else{
                     if(!CheckUnuse(i,k,j)){
                     addTriangle(i,k,j);}
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
      for(int v=0;v<nv;v++){isInterior[v]=true;}
      for(int i=0;i<nc;i++){
        if(bord(i)){
          isInterior[V[n(i)]]=false;
          isInterior[V[p(i)]]=false;
        }
      }
    }  
    
  void smoothenInterior() { // even interior vertiex locations
    pt[] Gn = new pt[nv];
    // **04 implement it
    for(int v=0; v<nv; v++){
      Gn[v]=P();
    }
    int[] CountNeighbor = new int[nv];
    for (int i=0;i<nc;i++){
      Gn[V[n(i)]].add(G[V[i]]); //add this corner V to its next corner's V
      CountNeighbor[V[n(i)]]++;
    }
    for(int v=0; v<nv; v++){
      Gn[v].div(CountNeighbor[v]);
    }
    
    for (int v=0; v<nv; v++) if(isInterior[v]) G[v].translateTowards(.1,Gn[v]);
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
    }               // draws arcs in triangles
    
   void drawVoronoiFaceOfInteriorVertices(){
     float dc =1./(nv-1);
     for(int v=0;v<nv;v++) if(isInterior[v]){fill(dc*255*v,dc*255*(nv-v),200);drawVoronoiFaceOfInteriorVertex(v);noFill();}
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

 
  pt triCenter(int c) {return P(g(c),g(n(c)),g(p(c))); }  // returns center of mass of triangle of corner c
  pt triCircumcenter(int c) {return CircumCenter(g(c),g(n(c)),g(p(c))); }  // returns circumcenter of triangle of corner c
  /****************** phase 2 ******************************/
  void CheckCut(pt A, pt B){
    for (int i = 0;i<nt;i++){
      pt ta = g(i*3);
      pt tb = g(i*3+1);
      pt tc = g(i*3+2);
      if(CutTriangle(A,B,ta,tb,tc)){
        UV[nu++]=V[i*3];UV[nu++]=V[i*3+1];UV[nu++]=V[i*3+2];
        deleteTriangle(i,V,nv);
        nv=nv-3;
      }
     }

   }
  void Recheck(pt A,pt B){
    for (int i = 0;i<nu;i=i+3){
       pt ta1 = G[UV[i]];
       pt tb1 = G[UV[i]+1];
       pt tc1 = G[UV[i]+2];
      if(!CutTriangle(A,B,ta1,tb1,tc1)){
        //addTriangle(i*3,i*3+1,i*3+2);
        deleteTriangle(i,UV,nu);
        nu=nu-3;
      }
     }
  }
  void deleteTriangle(int i,int[] set,int n){
    for(int u=i;u<n;u++){
      set[u]=set[u+3];
    }
  }

  boolean CutTriangle(pt A, pt B, pt ta, pt tb, pt tc){
    boolean intersect = false;
    
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
  

  } // end of MESH

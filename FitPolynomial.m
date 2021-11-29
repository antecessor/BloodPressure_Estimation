function p = FitPolynomial(x1, Y1, x2, Y2, vars)
  
   
         x1(isnan(x1)==1)=0;
         x2(isnan(x2)==1)=0;
        [c,test,pos,cost]=SAGA(x1, Y1, x2, Y2);
      
        f = @(x,pos) min(max(c*CreateRegressorsMatrix(x,pos),0),1);

        Y1hat=f(x1,pos);
        Y2hat=f(x2,pos);
        
        p.Y1hat=Y1hat;
        p.Y2hat=Y2hat;
        p.pos=pos;
        p.vars = vars;
        p.B = [];
        p.c = c;
        p.f = f;
        p.error=cost;
        p.Statics=test;
    
end

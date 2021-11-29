function X = CreateRegressorsMatrix(x,a)

    X = [a(1)*ones(1,size(x,2))
         a(2)*x(1,:).^a(3)
         a(4)*x(2,:).^a(5)
         a(6)*sin(a(7)*x(1,:)+a(8)*x(2,:))
         a(9)*x(1,:).*x(2,:).^a(10)
       
         ];
     
  
  

end
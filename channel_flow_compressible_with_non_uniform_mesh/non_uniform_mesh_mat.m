function msh = non_uniform_mesh_mat(msh,cvec)


delx_mat = zeros(msh.NY,msh.NX,9,9);   %(~,~,no. of stencils,populations)
dely_mat = zeros(msh.NY,msh.NX,9,9);   %(~,~,no. of stencils,populations)
msh.linind_mat = zeros(msh.NY,msh.NX,9);   %(~,~,no. of stencils)
msh.a_coeffs = zeros(msh.NY,msh.NX,9,9);   %(~,~,no. of stencils,populations)

% Center Coefficients

for k = 1:9
  for j = 2:msh.NY-1
    for i = 2:msh.NX-1
        msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j-1 j-1 j-1 j j j+1 j+1 j+1], ...
                                            [i i-1 i i+1 i-1 i+1 i-1 i i+1]);
        delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
        dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;                
        S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
         %A = inv(S'*S)*S';
         A = pinv(S);
        msh.a_coeffs(j,i,:,k) = A(1,:);                                        
    end
  end
end

% Top Boundary Coefficients

for k = 1:9
    for j = 1
        for i = 2:msh.NX-1
                   msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j j j+1 j+1 j+1 j+2 j+2 j+2], ...
                                            [i i-1 i+1 i-1 i i+1 i-1 i i+1]);
                    delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
                    dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;                
                    S = [ones(9,1) ... 
                         permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
                         permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
                        (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
                        (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
                         permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:) ;    
        end
    end
end


% Bottom Boundary Coefficients

for k = 1:9
    for j = msh.NY
        for i = 2:msh.NX-1
                    msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j j j-1 j-1 j-1 j-2 j-2 j-2], ...
                                            [i i-1 i+1 i-1 i i+1 i-1 i i+1]);
        delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
        dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;                
                    S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);   
        end
    end
end


% Left Boundary Coefficients

for k = 1:9
    for j = 2:msh.NY-1
        for i = 1
                   msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j-1 j-1 j j+1 j+1 j-1 j j+1], ...
                                            [i i i+1 i+1 i i+1 i+2 i+2 i+2]);
        delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
        dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;                
                                 
                    S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);     
        end
    end
end

% Right boundary conditions

for k = 1:9
    for j = 2:msh.NY-1
        for i = msh.NX
                   msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j-1 j-1 j j+1 j+1 j-1 j j+1], ...
                                            [i i i-1 i-1 i i-1 i-2 i-2 i-2]);
                    delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
                    dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;                
                    S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);    
        end
    end
end




% Top Left Boundary Condition

for k = 1:9
    for j = 1
        for i = 1
                               msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j j j+1 j+1 j+1 j+2 j+2 j+2], ...
                                            [i i+1 i+2 i i+1 i+2 i i+1 i+2]);
                    delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
                    dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;        
                    S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);    
        end
    end
end


% Top Right Bundary Condition

for k = 1:9
    for j = 1
        for i = msh.NX
            
                               msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j j j+1 j+1 j+1 j+2 j+2 j+2], ...
                                            [i i-1 i-2 i i-1 i-2 i i-1 i-2]);
                    delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
                    dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;              
                    S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);    
        end
    end
end


% Bottom Right Bundary Condition

for k = 1:9
    for j = msh.NY
        for i = msh.NX
                               msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j j j-1 j-1 j-1 j-2 j-2 j-2], ...
                                            [i i-1 i-2 i i-1 i-2 i i-1 i-2]);
                    delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
                    dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;          
                    S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);    
        end
    end
end


% Bottom Left Bundary Condition

for k = 1:9
    for j = msh.NY
        for i = 1
                   msh.linind_mat(j,i,:) = sub2ind([msh.NY msh.NX], ...
                                            [j j j j-1 j-1 j-1 j-2 j-2 j-2], ...
                                            [i i+1 i+2 i i+1 i+2 i i+1 i+2]);
                    delx_mat(j,i,:,k) = msh.X(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.X(j,i) + cvec(k,1)*msh.delt;                                
                    dely_mat(j,i,:,k) = msh.Y(permute(msh.linind_mat(j,i,:),[3,1,2])) - msh.Y(j,i) + cvec(k,2)*msh.delt;        
                                 
                   S = [ones(9,1) ... 
            permute(delx_mat(j,i,:,k),[3,4,1,2]) ...
            permute(dely_mat(j,i,:,k),[3,4,1,2]) ...
            (permute(delx_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            (permute(dely_mat(j,i,:,k),[3,4,1,2]).^2)/2 ...
            permute(delx_mat(j,i,:,k),[3,4,1,2]).*permute(dely_mat(j,i,:,k),[3,4,1,2])];
                    %A = inv(S'*S)*S';
                    A = pinv(S);
                    msh.a_coeffs(j,i,:,k) = A(1,:);    
        end
    end
end

%msh.a_coeffs = permute(msh.a_coeffs,[4,3,1,2]);  % msh.a_coeffs(k,:,j,i)
%msh.linind_mat = permute(msh.linind_mat,[3,1,2]); % msh.linind_mat(:,j,i)

end
function [firstlevel,seclevel]=tran_statenum2sec(inputsec,matrix)
[~,fieldnum]=size(matrix);
an=0;
name_1=fieldnames(matrix);
first_field=name_1{1};

for i=1:fieldnum
    submatrix=getfield(matrix(i),first_field);
    [~,secnum]=size(submatrix);
    for ii=1:secnum
        an=an+1;
    if an==inputsec
        firstlevel=i;
        seclevel=ii;
        return
    end
    end

end
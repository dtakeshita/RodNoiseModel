function y = embed_single(event,single, single_sign, offset, sig)
    y = zeros(size(event));
    ndat = length(event);
    idx = find(event);
    n_single = length(single);
    n_idx = length(idx);
    st = idx + offset;
    ed = st + n_single-1;
    s = 1+sig*randn(3*n_idx,1);
    s = s(s>0);
    s = s(1:n_idx);
    single_all = zeros(n_single,n_idx);
    for n=1:n_idx
       if st(n)<=0 || st(n) > ndat
           continue;
       end
       if ed(n)<=0 || ed(n) > ndat
           continue
       end
       single_tmp = s(n)*sign(single_sign)*single;
       y(st(n):ed(n)) = single_tmp; 
       single_all(:,n) = single_tmp';
    end
    
end
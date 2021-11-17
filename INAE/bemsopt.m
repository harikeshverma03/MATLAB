function bemsopt(n,t)
    [z,alloc] = bems(n,t);
    [M,I] = min(abs(z));
    opt = alloc(:,:,I);
    disp(M);
    csvwrite('bems_opt.csv',opt);
end
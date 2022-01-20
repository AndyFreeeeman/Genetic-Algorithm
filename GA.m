
close all

p_c = 0.7 ;
p_m = 0.1 ;

xy = zeros(6,16);
xy_demical = zeros(6,2);
f_xy_demical = zeros(1,6);
norm_f_xy_demical = zeros(1,6);
increase_f = zeros(1,6);
fitness_ratio = zeros(1,6);
pool = zeros(6,16);
offspring = zeros(6,16);

f_max_average = zeros(2,100);

f_max = zeros(1,100);
f_average = zeros(1,100);


for i = 1:6
    for j = 1:16
        if( rand >= 0.5 )
            xy(i , j) =  1 ;
        else
            xy(i , j) =  0 ;
        end
    end
end

for s = 1:1000

    for i = 1:6

        x_demical = 0 ;
        y_demical = 0 ;

        for j = 1:8
            x_demical = x_demical + 2^(8-j) * xy(i,j)  ;
            y_demical = y_demical + 2^(8-j) * xy(i,j+8) ;
        end
    
        xx = x_demical * 0.0235294 - 3 ;
        yy = y_demical * 0.0235294 - 3 ;

        xy_demical(i,1) =  xx ;
        xy_demical(i,2) =  yy ;
    end

    f_xy_demical_sum = 0 ;

    for i = 1:6
        f_xy_demical(i) = (( 1 - xy_demical(i,1) ).^2 ).* exp( -1 * xy_demical(i,1).^2 - ( xy_demical(i,2) + 1 ).^2 ) - ( xy_demical(i,1) - xy_demical(i,1).^3 - xy_demical(i,2).^3 ) .* exp( -1 * xy_demical(i,1).^2 - xy_demical(i,2).^2 ) ;
        f_xy_demical_sum = f_xy_demical_sum + f_xy_demical(i) ;
    end

    f_average(s) = f_xy_demical_sum / 6 ;

    f_max_average(2,s) = f_xy_demical_sum / 6 ;

    f_max(s) = max(f_xy_demical) ;

    f_max_average(1,s) = max(f_xy_demical) ;

    norm_f_xy_demical = normalize(f_xy_demical,'range') ;

    for i = 1:6
        fitness_ratio(i) = ( norm_f_xy_demical(i) / sum(norm_f_xy_demical) ) * 100 ;
    end

    increase_f(1) = fitness_ratio(1) ;
    for i = 2:6
        increase_f(i) = increase_f(i-1) + fitness_ratio(i) ;
    end

    for i = 1:6
        choose_factor = rand*100 ;

        if choose_factor < increase_f(1)
            j = 1 ;
        elseif choose_factor < increase_f(2)
            j = 2 ;
        elseif choose_factor < increase_f(3)
            j = 3 ;
        elseif choose_factor < increase_f(4)
            j = 4 ;
        elseif choose_factor < increase_f(5)
            j = 5 ;
        else
            j = 6 ;
        end

        for k = 1:16
            pool(i,k) = xy(j,k) ;
        end

    end

    r = randperm(6) ;

    cross_p_factor = rand ;

    if cross_p_factor < p_c
        cross_over_point = round(rand(1,1)*15) + 1 ;

        mirror = 0 ;

        for i = cross_over_point:16
            mirror = pool(r(1),i) ; 
            pool(r(1),i) =  pool(r(2),i) ;
            pool(r(2),i) = pool(r(1),i) ; 
        end
    end

    cross_p_factor = rand ;

    if cross_p_factor < p_c
        cross_over_point = round(rand(1,1)*15) + 1 ;

        mirror = 0 ;

        for i = cross_over_point:16
            mirror = pool(r(1),i) ; 
            pool(r(3),i) = pool(r(4),i) ;
            pool(r(4),i) = pool(r(3),i) ; 
        end
    end

    cross_p_factor = rand ;

    if cross_p_factor < p_c
        cross_over_point = round(rand(1,1)*15) + 1 ;
        mirror = 0 ;

        for i = cross_over_point:16
            mirror = pool(r(1),i) ; 
            pool(r(5),i) = pool(r(6),i) ;
            pool(r(6),i) = pool(r(5),i) ; 
        end
    end

    for i = 1:6
        mutation_factor = rand ;
    
        if mutation_factor < p_m
            mutation_point = round(rand(1,1)*15) + 1 ;
            if pool(i,mutation_point) == 1
                pool(i,mutation_point) = 0 ;
            else
                pool(i,mutation_point) = 1 ;
            end
        end
    end

    for i = 1:6
        for j = 1:16
            xy(i,j) = pool(i,j) ;
        end
    end
disp("generation = " + s)
end


plot(f_max,'B*-');
hold on ;
plot(f_average,'M');
hold off ;
grid on
xlabel('Generation');
ylabel('fitness');
title("cross over = " + p_c + " , mutation = " + p_m );
legend("max","average");

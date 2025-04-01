function [a, b, f_handle] = extrapolation_interpolation_tofindMinimum()
    % 定义函数和区间
    a = 0;      % 区间左端点
    b = 2;      % 区间右端点
    
    % 定义目标函数
    f_handle = @(x) x.^3 - 2*x.^2;
    
    % 显示函数和区间信息
    fprintf('当前函数: f(x) = x^3 - 2*x^2\n');
    fprintf('搜索区间: [%.2f, %.2f]\n', a, b);
    
    % 调用求解器计算并输出结果
    [x_min, f_min] = minimization_solver(a, b, f_handle);
    fprintf('极小值点: x = %.6f\n', x_min);
    fprintf('极小值: f(x) = %.6f\n\n', f_min);
end


%%
function [x_min, f_min] = minimization_solver(a, b, f)
    % 极小值求解主函数
    epsilon = 1e-6;  % 精度要求
    
    % 使用外推法确定初始区间
    [a1, b1] = extrapolation(a, b, f);
    fprintf('外推法确定的初始区间: [%.6f, %.6f]\n', a1, b1);
    
    % 使用二次插值法搜索极小值点
    [x_min, f_min, iter] = quadratic_interpolation(a1, b1, epsilon, f);
    
    fprintf('二次插值法结果:\n');
    fprintf('极小值点: x = %.6f\n', x_min);
    fprintf('极小值: f(x) = %.6f\n', f_min);
    fprintf('迭代次数: %d\n', iter);
end

function [a, b] = extrapolation(a0, b0, f)
    % 外推法确定包含极小值的区间
    h = (b0 - a0)/10;
    x1 = a0;
    x2 = x1 + h;
    y1 = f(x1);
    y2 = f(x2);
    
    % 判断方向
    if y1 > y2
        x3 = x2 + h;
    else
        h = -h;
        x3 = x2;
        x2 = x1 + h;
    end
    
    y3 = f(x3);
    
    % 继续外推直到函数值开始增大
    while y2 > y3
        h = 2*h;
        x1 = x2;
        x2 = x3;
        x3 = x2 + h;
        y3 = f(x3);
    end
    
    % 确保a < b
    if x1 < x3
        a = x1;
        b = x3;
    else
        a = x3;
        b = x1;
    end
end

function [x_min, f_min, iter] = quadratic_interpolation(a, b, epsilon, f)
    % 二次插值法搜索极小值
    iter = 0;
    max_iter = 100;
    x0 = a;
    x1 = (a + b)/2;
    x2 = b;
    
    while iter < max_iter
        iter = iter + 1;
        
        % 计算三个点的函数值
        f0 = f(x0);
        f1 = f(x1);
        f2 = f(x2);
        
        % 计算二次插值的极小值点
        numerator = (x1^2 - x2^2)*f0 + (x2^2 - x0^2)*f1 + (x0^2 - x1^2)*f2;
        denominator = (x1 - x2)*f0 + (x2 - x0)*f1 + (x0 - x1)*f2;
        
        if denominator == 0
            x_min = x1;
            break;
        end
        
        x_new = 0.5 * numerator / denominator;
        
        % 检查是否收敛
        if abs(x_new - x1) < epsilon
            x_min = x_new;
            break;
        end
        
        % 更新三个点
        if x_new > x1
            x0 = x1;
            x1 = x_new;
        else
            x2 = x1;
            x1 = x_new;
        end
    end
    
    x_min = x1;
    f_min = f(x_min);
end
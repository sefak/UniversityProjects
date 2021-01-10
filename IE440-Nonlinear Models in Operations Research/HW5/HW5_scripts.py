# %% [markdown]
# # Homework 5
# %%
import pandas as pd
import numpy as np
from sympy import Symbol, lambdify
import random


# %%
x1 = Symbol("x1")
x2 = Symbol("x2")
x3 = Symbol("x3")
x4 = Symbol("x4")

func = 3*x1**2 + 2*x2**2 - 2*x1*x2 - 4*x1 + 2*x2 + 3
f = lambdify([[x1,x2,x3,x4]], func, "numpy")
gf = lambdify([[x1,x2,x3,x4]], func.diff([[x1, x2,x3,x4]]), "numpy")
grad_f = lambda x_arr : np.array(gf(x_arr), 'float64').reshape(1,len(x_arr))

A = np.array([[1, 1, 1, 0],
              [1, 1, 0, 1]])
b = np.array([2,5]).reshape(2,1)
x1_bounds = [2, 5]
x2_bounds = [-1, 6]
x3_bounds = [0, 4]
x4_bounds = [0, 10]
bounds = [x1_bounds, x2_bounds, x3_bounds, x4_bounds]

# %% [markdown]
# ### Useful Functions

# %%
np_str = lambda x_k : np.array2string(x_k.reshape(len(x_k)), precision=3, separator=',')

f_str = lambda x : "{0:.4f}".format(x)


# %%
class OutputTable:    
    def __init__(self):
        self.table = pd.DataFrame([],columns=['k', 'x^k', 'f(x^k)', 'd^k', 'a^k'])
    def add_row(self, k, xk, fxk, dk, ak):
        self.table.loc[len(self.table)] = [k, np_str(xk), f_str(fxk.item()), np_str(dk), ak]
    def print_latex(self):
        print(self.table.to_latex(index=False))

# %% [markdown]
# ### Exact Line Search

# %%
def GoldenSection(f,epsilon=0.005, a=-1000,b=1000):
    golden_ratio = (1+np.sqrt(5))/2
    gama = 1/golden_ratio
    iteration = 0
    x_1 = b - gama*(b-a)
    x_2 = a + gama*(b-a)
    fx_1 = f(x_1)
    fx_2 = f(x_2)
    while (b-a) >= epsilon:
        iteration+=1
        if(fx_1 >= fx_2):
            a = x_1
            x_1 = x_2
            x_2 = a + gama*(b-a)
            fx_1 = fx_2
            fx_2 = f(x_2)
        else:
            b = x_2
            x_2 = x_1
            x_1 = b - gama*(b-a)
            fx_2 = fx_1
            fx_1 = f(x_1)
    x_star = (a+b)/2
    fx_star = f(x_star)
    return x_star


# %%
def ExactLineSearch(f, x0, d, a_max, eps=0.0000000001):
    alpha = Symbol('alpha')
    function_alpha = f(np.array(x0)+alpha*np.array(d))
    f_alp = lambdify(alpha, function_alpha, 'numpy')
    alp_star = GoldenSection(f_alp, epsilon=eps, a=0, b=a_max)
    return alp_star

# %% [markdown]
# ## Reduced Gradient Method

# %%
def determineBasicAndNonbasics(xk, bounds, A):
    basics = []
    nonbasics = []
    m = len(A)
    for i in range(len(bounds)):
        if(bounds[i][0] < xk[i,0] < bounds[i][1]):
            basics.append(i)
        else:
            nonbasics.append(i)
    while len(basics) > m:
        random.shuffle(basics)
        new_basics = basics[0:m]
        if np.linalg.det(A[:,new_basics]) == 0: # found set is linearly dependent
            continue
        nonbasics = nonbasics + basics[m:]
        basics = new_basics
    return basics, nonbasics


# %%
def ReducedGradient(x0, f=f, gradf=grad_f, eps=0.001, A=A, b=b, bounds=bounds, float_prec=6):
    k = 0
    xk = np.array(x0).reshape(len(x0),1)
    output = OutputTable()
    repeat = True
    while(repeat):
        basics, nonbasics = determineBasicAndNonbasics(xk, bounds, A)
        B = A[:,basics]
        N = A[:,nonbasics]
        Binv = np.linalg.inv(B)
        gradfk = gradf(xk)
        gradB = gradfk[:,basics]
        gradN = gradfk[:,nonbasics]
        rNk = gradN - gradB @ Binv @ N
        rBk = 0
        rk = np.zeros((1,len(xk)))
        np.put(rk, nonbasics, rNk) # since rBk is 0, we only put rNk into rk
        dk = np.zeros_like(xk)
        for i in nonbasics:
            if xk[i] == bounds[i][0] and rk[0,i] < 0:
                dk[i,0] = -rk[0,i]
            elif xk[i] == bounds[i][1] and rk[0,i] > 0:
                dk[i,0] = -rk[0,i]
            elif bounds[i][0] < xk[i] < bounds[i][1]:
                dk[i,0] = -rk[0,i]
            else:
                dk[i,0] = 0
        dkB = - Binv @ N @ dk[nonbasics]
        np.put(dk, basics, dkB)
        a_max = 1000 # given upper limit
        for i in range(len(xk)):
            if(dk[i,0] == 0): # max value is infinity if dkj is 0
                continue
            a_max = min(a_max, max((bounds[i]-xk[i])/dk[i,0]))
        ak = ExactLineSearch(f,xk,dk,a_max)
        output.add_row(k, xk, f(xk), dk, ak)
        xkp = xk + ak * dk
        k += 1
        xk = np.round(xkp, float_prec) # rounding is required since the float calculations can cause precision problem
        if np.linalg.norm(dk) < eps:
            repeat = False
    output.add_row(k, xk, f(xk), np.array([]), None)
    return xk, f(xk).item(), output


# %%
xk = np.array([3, -1, 0, 3]).reshape(4,1)
xs1, fxs1, out1 = ReducedGradient(xk)
out1.table


# %%
xk = np.array([2, -1, 1, 4]).reshape(4,1)
xs2, fxs2, out2 = ReducedGradient(xk)
out2.table


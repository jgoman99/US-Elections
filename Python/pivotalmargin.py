# -*- coding: utf-8 -*-
"""
Created on Mon Jan 25 23:46:55 2021

@author: jgfri
"""
from cvxopt.glpk import ilp
import numpy as np
from cvxopt import matrix


def calculatePivotalMargin(margin_vec,reward_vec,threshold):
    margin_vec = np.array(margin_vec)
    reward_vec = np.array(reward_vec)
    m = len(margin_vec)
    c= matrix(np.array(margin_vec, dtype= float))
    coeff= np.array([reward_vec],dtype=float)
    G=matrix(-coeff)
    h=matrix(1*np.array([-threshold], dtype = float))
    I=set()
    B=set(range(m))
    (status,x)=ilp(c,G,h,matrix(1., (0,m)),matrix(1., (0,1)),I,B)
    
    pivotal_margin = sum(margin_vec[[i == 1 for i in x]])
    return status,x,pivotal_margin
    

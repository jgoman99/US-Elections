# -*- coding: utf-8 -*-
"""
Created on Tue Jan 26 00:12:09 2021

@author: jgfri
"""

#automate more
#add total votes 

import pandas as pd
import pivotalmargin as pm

def prepareAndWrite(df,threshold):
    df = prepareData(df,threshold)
    df.to_csv("../Modified Data/us_elections.csv",index=False)

def prepareData(df,threshold):
    prepared_data = pd.DataFrame()
    years = df.iloc[:,3].unique()
    for year in years:
        year_df = df.loc[df.iloc[:,3]==year]
        parties = year_df.party.unique()
    
        
        for party in parties:
            print(u"party: ",party,"year: ",year)
            margin_vec,reward_vec = prepareYearData(year_df,party)
            status,x,pivotal_margin = pm.calculatePivotalMargin(margin_vec,reward_vec,threshold)
            print(status)
            row = pd.DataFrame({'year':[year], 'party' : [party], 'pivotal margin': [pivotal_margin]})
            prepared_data = prepared_data.append(row)
            
    return(prepared_data)
            
#fix seat
def prepareYearData(year_df,other_party):    
    seats = year_df.iloc[:,0].unique()
    reward_vec = year_df.drop_duplicates("seat").iloc[:,6].values
    margin_vec = [None]*len(seats)
    for idx,seat in enumerate(seats):
        seat_df = year_df.loc[year_df.iloc[:,0]==seat]
        print(seat_df)
        
        if seat_df.iloc[:,4].unique()[0] == other_party:
            margin_vec[idx] = 0
        else:
            margin = seat_df.iloc[:,5].unique()[0] 
            - seat_df.loc[seat_df.iloc[:,1]== other_party].iloc[:,2].unique()[0]
            margin_vec[idx] = margin
    
    
    return margin_vec,reward_vec



#test case
df = pd.read_csv("../Input Data/uk_election_data.csv")
df=df.loc[df.year > 1963]

prepareAndWrite(df,326)
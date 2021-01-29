# -*- coding: utf-8 -*-
"""
Created on Tue Jan 26 00:12:09 2021

@author: jgfri
"""

# have to add differing seat compositions. (e.g. mult thressholds)

import pandas as pd
import pivotalmargin as pm

def prepareAndWrite(input_path,output_path,threshold):
    input_df = pd.read_csv(input_path)
    output_df = prepareData(input_df,threshold)
    output_df.to_csv(output_path,index=False)

def prepareData(df,threshold):
    prepared_data = pd.DataFrame()
    years = df.iloc[:,3].unique()
    for year in years:
        year_df = df.loc[df.iloc[:,3]==year]
        parties = year_df.iloc[:,1].unique()
        total_votes = year_df.iloc[:,2].sum()
        
        for party in parties:
            party_votes = year_df[year_df.iloc[:,1]==party].iloc[:,2].sum()
            print(u"party: ",party,"year: ",year)
            margin_vec,reward_vec = prepareYearData(year_df,party)
            status,x,pivotal_margin = pm.calculatePivotalMargin(margin_vec,reward_vec,threshold)
            print(status)

            row = pd.DataFrame({'year':[year], 'party' : [party], 'pivotal_margin': [pivotal_margin],
                                'total_votes': total_votes, 'party_votes': party_votes})
            prepared_data = prepared_data.append(row)
            
    return(prepared_data)
            
#fix seat
def prepareYearData(year_df,other_party):    
    seats = year_df.iloc[:,0].unique()
    seat_column_name = year_df.columns[0]
    reward_vec = year_df.drop_duplicates(seat_column_name).iloc[:,6].values
    margin_vec = [None]*len(seats)
    for idx,seat in enumerate(seats):
        seat_df = year_df.loc[year_df.iloc[:,0]==seat]
        
        
        if other_party not in seat_df.iloc[:,1].values:
            margin = seat_df.iloc[:,5].unique()[0] 
            margin_vec[idx] = margin
        elif seat_df.iloc[:,4].unique()[0] == other_party:
            margin_vec[idx] = 0
        else:
            margin = seat_df.iloc[:,5].unique()[0] 
            - seat_df.loc[seat_df.iloc[:,1]== other_party].iloc[:,2].unique()[0]
            margin_vec[idx] = margin
    
    
    return margin_vec,reward_vec



#Write to files:
prepareAndWrite("../Input Data/uk_election_data.csv","../Modified Data/uk_elections.csv",326)
#prepareAndWrite("../Input Data/us_election_data.csv","../Modified Data/us_elections.csv",270)
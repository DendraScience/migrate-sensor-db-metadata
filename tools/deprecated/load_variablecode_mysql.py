#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Load VariableCode into MySQL
Created on Thu Jan 25 06:40:07 2018

@author: collin
"""
import pandas as pd
import mysql.connector

def odm_connect(pwfilepath,boo_dev=False):
    # NOTE: password file (pwfile) should NEVER be uploaded to github!
    fpw = open(pwfilepath,'r')
    user = fpw.readline().strip()
    pw = fpw.readline().strip()
    fpw.close()
    if(boo_dev == True):
        db = 'odm_dev'
    else:
        db = 'odm'
    cnx = mysql.connector.connect(
        user=user,
        password=pw,
        host='localhost', #host='gall.berkeley.edu',
        database=db)
    return cnx

tf = "%Y-%m-%d %H:%M:%S"        # This is the 'time font' or tf for datebase objects

# use external password and connect to database
conn = odm_connect('../compost/odm.pw')
cursor = conn.cursor()

# Create table to hold VariableCode translations
sql = 'DROP TABLE IF EXISTS dendra_map_variablecodes_pre'
cursor.execute(sql)
print('DROPPED table:',sql)

# VariableCode,Medium,Variable,Unit,Aggregate,Misc
sql = 'CREATE TABLE dendra_map_variablecodes_pre ('+\
    'VariableCode varchar(255) CHARACTER SET latin1 NOT NULL, '+\
    'Medium varchar(255) NOT NULL, '+\
    'Variable varchar(255) NOT NULL, '+\
    'Unit varchar(255) NOT NULL, '+\
    'Aggregate varchar(255), '+\
    'Misc varchar(255), '+\
    'PRIMARY KEY (VariableCode) '+\
    ') ENGINE=InnoDB DEFAULT CHARSET=utf8'
cursor.execute(sql)
print(sql)

# Load Excel export for VariableCodes
# set location of Excel export file 
vc_path = '../sql/create-table/dendra_map_variablecodes_pre.csv'
df = pd.read_csv('../sql/create-table/dendra_map_variablecodes_pre.csv')
print("\n")
df

for i in range(0,len(df)):
    sql = 'INSERT INTO dendra_map_variablecodes_pre '+\
    '(VariableCode,Medium,Variable,Unit,Aggregate,Misc) '+\
    'VALUES ("'+df.VariableCode[i]+'","ds_Medium_'+df.Medium[i]+\
    '","ds_Variable_'+df.Variable[i]+'","dt_Unit_'+df.Unit[i]+'","ds_Aggregate_'+\
    df.Aggregate[i]+'","'+df.Tags[i]+'")'
    print(i,sql)
    cursor.execute(sql)

# Remove the Excel 0s
sql = 'UPDATE dendra_map_variablecodes_pre SET Aggregate = "" WHERE Aggregate = "ds_Aggregate_0"'
cursor.execute(sql)
sql = 'UPDATE dendra_map_variablecodes_pre SET Misc = "" WHERE Misc = "0"'
cursor.execute(sql)

# Clean up
conn.commit()
conn.close()

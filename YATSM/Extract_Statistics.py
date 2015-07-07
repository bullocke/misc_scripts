import numpy as np
import os
import fnmatch

def find_results(location, pattern):
    """ Create list of result files and return sorted
    Args:
      location (str): directory location to search
      pattern (str): glob style search pattern for results
    Returns:
      results (list): list of file paths for results found
    """
    # Note: already checked for location existence in main()
    records = []
    for root, dirnames, filenames in os.walk(location):
        for filename in fnmatch.filter(filenames, pattern):
            records.append(os.path.join(root, filename))


    records.sort()

    return records



def iter_records(records, warn_on_empty=False):
    """ Iterates over records, returning result NumPy array
    Args:
      records (list): List containing filenames of results
      warn_on_empty (bool, optional): Log warning if result contained no
        result records (default: False)
    Yields:
      np.ndarray: Result saved in record
    """
    n_records = len(records)

    for _i, r in enumerate(records):
        # Verbose progress
        try:
            rec = np.load(r)['record']
        except (ValueError, AssertionError):
            continue

        if rec.shape[0] == 0:
            # No values in this file
            continue

        yield rec

result_location='/projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1946_2045/images/YATSM_13'
#result_location='/projectnb/landsat/users/bullocke/testing/YATSM/Statistics'
pattern='yatsm*'
records=find_results(result_location, pattern)
sum=np.array([0,0,0,0,0,0,0])
amount=np.array([0])
amountchange=np.array([0])
amountrecs=np.array([0])

for rec in iter_records(records):
#first compute rmse   
    rmse=rec['rmse'][rec['break']==0]        
    rmse=rec['rmse']
    leng=len(rmse)
 
#coefficients
    rmse=rec['coef']
    leng=len(rmse)  

#now for amount change
    change=rec['break']
    changenum=np.count_nonzero(change)
    amountchange=amountchange+changenum

#now for amount of recs
    sum_rec=np.sum(rmse, axis=0)
   # rec1=rec['px']
   # recs=len(rec1)
    recs=len(np.unique(rec['px']))
    amountrecs=amountrecs+recs

#These always need to be on
    sum=sum+sum_rec
    amount=amount+leng

    
final=(sum/amount)    
changefinal=np.array([amountchange,amountrecs])
np.savetxt("13_numchange.csv", changefinal, fmt='%10.5f', delimiter=",")
#np.savetxt("1_coef.csv", final, fmt='%10.5f', delimiter=",")


#ob = np.load('file')
#rec = ob['record']
#rmse = rec['rmse']
#for rec in len[rmse]
#sum(rmse[0])/len(rmse[0]) = average of bands
#len(rmse) = total entries

#np.mean(rmse, axis=0)
#np.sum(rmse, axis=0)



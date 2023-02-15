'''

BHL Search

Last Updated:
    June 26, 2020
    
Contributors:
    Mark Friedman

Version History:

    0.5 Code cleanup
    0.4 Language=ENG only, JSON cache fix
    0.3 CSV input of scientific names, cache-loading of JSON results
    0.2 Multiple searches from list, added JSON file writing
    0.1 Single search against the API, outputs aggregated results to CSV

Notes:


TODO:

x    Check for output directories
x    Handling of network errors (Abort? Fail? Retry?)

'''

import os
import sys
import time
import requests
import csv
import json
import codecs
from functools import reduce


QUERY_WAIT = 0 # Seconds between api queries, zero (0) if no wait

input_filename = 'SeedCatalogNames.csv'

# Default directories: NO TRAILING SLASH!
cache_dir = "api_cache_BHL_tocomplete"
output_dir = "csv_output_BHL_tocomplete"


# Example:  https://www.biodiversitylibrary.org/api3?op=PublicationSearchAdvanced&apikey=cae7a5eb-786c-4546-8299-94a0211a1443&format=json&collection=56&page=1

# BHL API docs: https://www.biodiversitylibrary.org/docs/api3.html
"""
title - a title for which to search
titleop - 'all' to search for all specified words in the title fields; 'phrase' to search for the exact phrase specified
authorname - an author name for which to search
year - a four-digit publication year for which to search
subject - a subject for which to search
language - a language code; search will only return publications in the specified language
collection - a collection id; search will only return publications from the specfied collection
notes - one or more words for which to search in the publication notes
notesop - 'all' to search for all specified words in the notes field; 'phrase' to search for the exact phrase specified
text - one or more words for which to search in the text of the publications
textop - 'all' (DEFAULT) to search for all specified words in the text field; 'phrase' to search for the exact phrase specified
page - 1 for the first page of results, 2 for the second, and so on 
"""

api_key = "22574b8d-5784-42af-a0df-1542fc1cb0df"

base_url = "https://www.biodiversitylibrary.org/api3?op=PublicationSearchAdvanced"
base_url += "&apikey=" + api_key
base_url += "&format=json&language=ENG"
base_url += "&collection=56&textop=phrase"

output_fields = [ 'BHLType', 'FoundIn', 'ItemID', 'TitleID', 'Volume', 'ItemUrl', 'TitleUrl', 'MaterialType', 'PublisherPlace', 'PublisherName', 'PublicationDate', 'Authors', 'Genre', 'Title' ]



######################################################################################
##  OLD FUNCTIONS
######################################################################################





def merge_data_OLD(serial, ut_data):
    for field in output_fields:
        serial[field] = copy_data(ut_data[field])

    return




######################################################################################
##  FUNCTIONS
######################################################################################


def list_to_csv(list):
    build = ""
    
    for item in list:
        if build:
            build += "|"
        build += item['Name']

    return build
    
    
def copy_data(data):
    if data is None:
        return ""

    if type(data) is list:
        return list_to_csv(data)

    return str(data)



def get_data_cache(name):
    js_filename = cache_dir + "/" + name + ".json"
    data = None
    try:
        data = json.load( open( js_filename ) )
        print("Loaded from cache:", js_filename)
    except:
        #print("Couldn't load cache:", js_filename)
        pass
        
    return data


def search_species(paged_url):

    try:
        response = requests.get(paged_url)
    except:
        print("CRITICAL ERROR:","Query failed:","network or DNS outage? keyboard interrupt?")
        print("ABORTING BATCH!")
        terminate()

        
    if not response:
        print("CRITICAL ERROR:","Query failed:","no response")
        print("ABORTING BATCH!")
        terminate() # Abort entirely: most likely a malformed base url or site down

    data = response.json() # turn json response into a dictionary named data
    
    if not data:
        print("ERROR:","Query failed:","no data?")
        return None

    if not data['Status']:
        print("ERROR:","Query failed:","no data Status?")
        return None

    if not len(data['Result']):
        #print("INFO:","Empty result")
        return None

    return data



def proc_row(serial):
    row = []
    for field in output_fields:
    
        if serial.get(field):
            #row.append(copy_data(serial[field]).encode("utf-8"))
            
            
            if True:
                #print(copy_data(serial[field]))
                row.append(copy_data(serial[field]))
                    
            else:
            
                try:
                    row.append(copy_data(serial[field]))
                    print(copy_data(serial[field]))
                except Exception as e:
                    #logging.error(traceback.format_exc())
                    row.append("ERROR")            
                
        else:
            row.append(None)
            
    return row


def write_csv(species, all_data):

    output_filename = output_dir + "/" + species + ".csv"

    try:
        print ("Writing output file:", output_filename, "...\n")
        output_file = open(output_filename, 'w', encoding='utf-8', newline='') # open a file for writing
        csv_writer = csv.writer(output_file) # create a writer (formatter) for csv file
        csv_writer.writerow( output_fields ) # write the key names as the first line of csv file

        for title in all_data:
            #print(title['Title'])
            
            row = proc_row(title) # convert line dictionary to list of values
            csv_writer.writerow(row) # write vales to csv as row values
            
            # End of for-loop
            
        output_file.close()# close newly created csv file

    except:
        print("Couldn't save CSV:", output_filename)
        pass        
        
    return

def save_data_cache(species, data):
    js_filename = cache_dir + "/" + species + ".json"
    try:
        json.dump(data, open( js_filename, 'w' ) )
        #print("Saved to cache:", js_filename)        
    except:
        print("Couldn't save cache:", js_filename)
        pass        
    return js_filename
    

def process_name(name):
    name = name.strip()
    name = name.lower() # Doesn't seem to matter for BHL?
    return name
    
    
def seconds_to_str(t):
    return "%d:%02d:%02d.%03d" % \
           reduce(lambda ll, b: divmod(ll[0], b) + ll[1:],
                  [(t * 1000,), 1000, 60, 60])
            

def fix_cache_data(species, cache_data):
    document = {}
    document["Status"] = "ok"
    document["ErrorMessage"] = ""
    document["SearchText"] = species
    document["BaseURL"] = cache_data["BaseURL"].replace(" ", "%20") # escape spaces
    document["ResultCount"] = len(cache_data["Result"])
    document["Result"] = cache_data["Result"]
    
    save_data_cache(species, document)    
    
    return document


def terminate():
    input("\nEnd of program. Hit Enter to quit.")   
    sys.exit()


def ensure_dir(dir_name):
    # Make sure cache_dir exists
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
    return
    
    

######################################################################################
##  PROGRAM START
######################################################################################



start_time = time.time()
ensure_dir(cache_dir)
ensure_dir(output_dir)


# Collect and process all of our input species

print ("Reading input file:", input_filename, "...")
csv_infile = open(input_filename, 'r', encoding='ansi')
csv_reader = csv.DictReader(csv_infile)

record_count = 0
species_names = []

for record in csv_reader:
    clean_name = process_name(record["Scientific.Name"])
    
    if clean_name in species_names:
        print("* Duplicate species name:", clean_name)
    elif clean_name:
        species_names.append(clean_name)
        record_count += 1
    
    # End of for-loop

csv_infile.close()

# At this point, species_names contains "clean" scientific species names

print(record_count, "scientific names\n")



# Here's the actual API query loop

for species in species_names:
    print("\nSearching for species:", species)
    species_url = base_url + "&text=" + species.replace(" ", "%20")
    page_num = 0
    source_count = 0
    species_titles = []

    # Attempt fetch from cache
    cache_data = get_data_cache(species)
    if cache_data:
        # This will keep page_num == 0, which we'll use later
        cache_data = fix_cache_data(species, cache_data)
        species_titles = cache_data["Result"]

    # Keep requesting pages until we hit our limit, or no results remain
    
    while not cache_data:
        page_num += 1
        
        if page_num > 50:
            print("Page request exceeded BHL max of 50!")
            break
        
        paged_url = species_url + "&page=" + str(page_num)
        #print("Requesting:", paged_url)
        print("Requesting page:", page_num)
        
        data = search_species(paged_url)
        
        if data:
            data_count = len(data['Result'])
            source_count += data_count
            print("\t", data_count, "titles (" + str(source_count) + " total)")
            
            # TODO: Build list of ALL titles thus far
            species_titles = species_titles + data['Result']
            
        else:
            # Note: An empty result returns as None, including the end of pagination!
            break
        
        if QUERY_WAIT:
            time.sleep(QUERY_WAIT)
            
        # end of while
    
    # All pages done for this one species

    print(len(species_titles), "TOTAL titles for", species, "\n")

    # If this wasn't from cache...
    if page_num > 0:
        # ...create a cache document!
        document = {}
        document["Status"] = "ok"
        document["ErrorMessage"] = ""
        document["SearchText"] = species
        document["BaseURL"] = species_url
        document["ResultCount"] = len(species_titles)
        document["Result"] = species_titles

        save_data_cache(species, document)
        
    write_csv(species, species_titles)
    
    print("Elapsed time:", seconds_to_str(time.time() - start_time), "\n")    

    # End of each-species loop
    

# All species done

#print("\nTotal runtime:", seconds_to_str(time.time() - start_time))    
    
terminate()





